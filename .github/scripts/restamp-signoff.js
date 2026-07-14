// @ts-check
'use strict';

/**
 * Carry a sign-off forward across new commits.
 *
 * Runs on pull_request_target (synchronize/reopened). Commit statuses attach to
 * a specific head SHA, so a new commit drops the "Patterns & Practices sign off"
 * status. The workflow if: gates this job on the pnp-signed-off label (applied by
 * an authorized #sign-off), so reaching this script means the PR is signed off.
 * It fetches the PR's live head and re-stamps success on the current head so the
 * sign-off persists without another comment.
 *
 * Invoked from actions/github-script, which injects `github`, `context`, and
 * `core`.
 *
 * @param {object} args
 * @param {ReturnType<typeof import('@actions/github').getOctokit>} args.github Authenticated Octokit client.
 * @param {typeof import('@actions/github').context} args.context Workflow run context.
 * @param {typeof import('@actions/core')} args.core Actions core toolkit.
 */
module.exports = async ({ github, context, core }) => {
  // Must stay identical to the value in gate-signoff.js and match the required
  // status check name in branch protection.
  const STATUS_CONTEXT = 'Patterns & Practices sign off';

  const { owner, repo } = context.repo;
  const defaultBranch = context.payload.repository?.default_branch;
  const eventPr = context.payload.pull_request;

  if (!eventPr) {
    core.info('Pull request payload is missing. Nothing to do.');
    return;
  }
  const prNumber = eventPr.number;

  /**
   * Set the required commit status on a commit. Descriptions are capped at 140
   * characters by the GitHub API.
   *
   * @param {string} sha
   * @param {'error' | 'failure' | 'pending' | 'success'} state
   * @param {string} description
   * @param {string} [targetUrl]
   */
  async function setStatus(sha, state, description, targetUrl) {
    await github.rest.repos.createCommitStatus({
      owner, repo, sha, state,
      context: STATUS_CONTEXT,
      description: description.slice(0, 140),
      ...(targetUrl ? { target_url: targetUrl } : {}),
    });
  }

  const ZERO_SHA = '0000000000000000000000000000000000000000';

  /**
   * Normalize a caught value to a string message.
   *
   * @param {unknown} e
   * @returns {string}
   */
  function toMessage(e) {
    return e instanceof Error ? e.message : String(e);
  }

  /**
   * Look up the prior "Patterns & Practices sign off" status on a commit so its
   * description ("Signed off by <user>") and target_url (the link to the sign-off
   * comment) can be copied forward onto the new head commit. Returns undefined
   * when there is no usable predecessor, letting the caller fall back to a generic
   * description.
   *
   * @param {string | undefined} sha
   * @returns {Promise<{ description: string, targetUrl: string | undefined } | undefined>}
   */
  async function findPriorSignOffStatus(sha) {
    if (!sha || sha === ZERO_SHA) return undefined;
    const { data: statuses } = await github.rest.repos.listCommitStatusesForRef({
      owner, repo, ref: sha, per_page: 100,
    });
    // The API returns statuses newest first, so the first context match is the
    // most recent sign-off status set on that commit.
    const prior = statuses.find((/** @type {{ context: string, state: string }} */ s) => s.context === STATUS_CONTEXT && s.state === 'success');
    if (!prior) return undefined;
    return { description: prior.description || '', targetUrl: prior.target_url || undefined };
  }

  let headSha;
  try {
    const { data: pr } = await github.rest.pulls.get({ owner, repo, pull_number: prNumber });
    headSha = pr.head.sha;

    // Not gated unless targeting the default branch.
    if (pr.base.ref !== defaultBranch) {
      core.info(`PR targets ${pr.base.ref}, not ${defaultBranch}. Not gated.`);
      return;
    }

    const prior =
      await findPriorSignOffStatus(headSha)
      ?? await findPriorSignOffStatus(context.payload.before);
    const description = prior?.description || 'PR previously signed off; carried forward after update.';
    await setStatus(headSha, 'success', description, prior?.targetUrl);
    core.info(`Re-stamped success on the current head commit after a prior sign-off. Description: "${description}".`);
  } catch (error) {
    // Fail closed: on an unexpected error, do not carry the sign-off forward.
    core.setFailed(`Carry-forward error: ${toMessage(error)}`);
    if (headSha) {
      try {
        await setStatus(headSha, 'pending', 'Sign-off carry-forward error. Blocked pending review.');
      } catch (statusError) {
        core.warning(`Failed to set pending status after error: ${toMessage(statusError)}`);
      }
    }
  }
};
