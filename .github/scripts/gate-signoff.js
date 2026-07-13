// @ts-check
'use strict';

/**
 * Gate PR sign-off.
 *
 * Only authorized users (repository write access or higher) may sign off a pull
 * request with "#sign-off" in a PR conversation comment (issue_comment) or a
 * submitted PR review body (pull_request_review). This script controls the required
 * "Patterns & Practices sign off" commit status check: an authorized sign-off sets it to
 * success; an unauthorized one leaves it pending, so branch protection blocks
 * the merge. On an unauthorized attempt, it posts the hold-off comment, whose
 * #hold-off token drives the merge bot to remove ready-to-merge and add
 * do-not-merge.
 *
 * An authorized sign-off also applies the pnp-signed-off label so
 * restamp-signoff.js can carry the sign-off forward across later commits. The
 * commit status check is the authoritative gate and must be a required status
 * check in branch protection for the default branch.
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
  // ---- Configuration ----
  const STATUS_CONTEXT = 'Patterns & Practices sign off';
  // Applied on an authorized sign-off so restamp-signoff.js can carry the sign-off
  // forward. Must stay identical to the label restamp-signoff.js checks.
  const SIGNED_OFF_LABEL = 'pnp-signed-off';
  // Match a standalone token so "#sign-off-later" or "#sign-offs" do not trigger.
  const SIGN_OFF_PATTERN = /#sign-off(?![\w-])/i;

  const { owner, repo } = context.repo;
  const defaultBranch = context.payload.repository?.default_branch;

  // Extract the sign-off request from whichever event fired: a PR conversation
  // comment (issue_comment) or a submitted PR review body (pull_request_review).
  // The job `if:` already screened for the token and a non-bot author.
  /** @type {number} */
  let prNumber;
  /** @type {string} */
  let commenter;
  /** @type {string} */
  let commentBody;
  if (context.eventName === 'issue_comment') {
    const { issue, comment } = context.payload;
    if (!issue || !comment) {
      core.info('Comment payload is missing issue or comment data. Nothing to do.');
      return;
    }
    prNumber = issue.number;
    commenter = comment.user.login;
    commentBody = comment.body || '';
  } else if (context.eventName === 'pull_request_review') {
    const { pull_request: reviewedPr, review } = context.payload;
    if (!reviewedPr || !review) {
      core.info('Review payload is missing pull_request or review data. Nothing to do.');
      return;
    }
    prNumber = reviewedPr.number;
    commenter = review.user.login;
    commentBody = review.body || '';
  } else {
    core.info(`Unhandled event '${context.eventName}'. Nothing to do.`);
    return;
  }

  // ---- Helpers ----

  /**
   * @param {string} body
   * @returns {boolean}
   */
  function isSignOffComment(body) {
    return SIGN_OFF_PATTERN.test(body);
  }

  /**
   * Set the required commit status on a commit. Descriptions are capped at 140
   * characters by the GitHub API.
   *
   * @param {string} sha
   * @param {'error' | 'failure' | 'pending' | 'success'} state
   * @param {string} description
   */
  async function setStatus(sha, state, description) {
    await github.rest.repos.createCommitStatus({
      owner, repo, sha, state,
      context: STATUS_CONTEXT,
      description: description.slice(0, 140),
    });
  }

  // Return the commenter's effective repository access. `canPush` is the
  // authoritative signal: true for write access or higher (write, maintain,
  // admin, and custom roles that grant push), false for triage/read/none. The
  // legacy `permission` base level is returned only for diagnostic logging.
  async function getCommenterAccess() {
    const { data } = await github.rest.repos.getCollaboratorPermissionLevel({
      owner, repo, username: commenter,
    });
    return {
      canPush: data.user?.permissions?.push === true,
      permission: data.permission,
    };
  }

  // The message carries functional tokens (#hold-off and #label:...) that
  // downstream bots act on, plus a team cc. The token lines must start at column
  // zero (no leading whitespace) so the bots match them, so keep this template
  // literal flush-left.
  function buildHoldOffComment() {
    return `Hello @${commenter} -

The Azure patterns & practices team is accountable for updates to Azure architecture content and must review all PRs. After they review the content and sign off again, the PR Review team will review the PR for merging. Thanks!

#hold-off
#label:"pending-content-team/business-approval"

cc: @MicrosoftDocs/patterns-and-practices-team-pr-reviewers`;
  }

  /**
   * Unauthorized sign-off: keep the gate closed. The posted comment carries the
   * #hold-off token, which the merge bot acts on to remove ready-to-merge and add
   * do-not-merge, so this script does not manipulate those labels directly.
   *
   * @param {string} sha
   * @param {string} permission
   */
  async function blockUnauthorizedSignOff(sha, permission) {
    await setStatus(sha, 'pending', `${commenter} is not authorized to sign off.`);
    await github.rest.issues.createComment({
      owner, repo, issue_number: prNumber, body: buildHoldOffComment(),
    });
    core.warning(`Unauthorized #sign-off by ${commenter} (permission: ${permission}). PR remains blocked.`);
  }

  // ---- Main ----

  if (!isSignOffComment(commentBody)) {
    core.info('Comment has no standalone #sign-off token. Nothing to do.');
    return;
  }

  let headSha;
  try {
    const { data: pr } = await github.rest.pulls.get({ owner, repo, pull_number: prNumber });
    headSha = pr.head.sha;

    // Only gate PRs that target the default branch. For any other base branch,
    // return WITHOUT creating the status.
    if (pr.base.ref !== defaultBranch) {
      core.info(`PR targets ${pr.base.ref}, not ${defaultBranch}. Leaving status unset so a later retarget to ${defaultBranch} still requires an authorized sign-off.`);
      return;
    }

    const { canPush, permission } = await getCommenterAccess();
    core.info(`Commenter ${commenter} has permission '${permission}', canPush: ${canPush}.`);

    if (canPush) {
      await setStatus(headSha, 'success', `Signed off by ${commenter}.`);
      // Mark the PR signed off so restamp-signoff.js keeps later commits green.
      await github.rest.issues.addLabels({
        owner, repo, issue_number: prNumber, labels: [SIGNED_OFF_LABEL],
      }).catch((/** @type {Error} */ e) => core.warning(`Could not add ${SIGNED_OFF_LABEL}: ${e.message}`));
      core.info('Authorized sign-off. Status set to success.');
      return;
    }

    await blockUnauthorizedSignOff(headSha, permission);
  } catch (error) {
    // Fail closed: on an unexpected error, do not approve. Leaving the gate
    // blocked prevents an induced failure from bypassing authorization.
    const message = error instanceof Error ? error.message : String(error);
    core.setFailed(`Sign-off gate error: ${message}`);
    if (headSha) {
      try {
        await setStatus(headSha, 'pending', 'Sign-off gate error. Blocked pending review.');
      } catch (statusError) {
        const statusMessage = statusError instanceof Error ? statusError.message : String(statusError);
        core.warning(`Failed to set pending status after error: ${statusMessage}`);
      }
    }
  }
};
