// @ts-check
'use strict';

/**
 * Post the patterns & practices hold-off notice.
 *
 * Contributors trigger the org merge bot by commenting "#sign-off". Approval to
 * merge is granted separately: an authorized patterns & practices reviewer adds
 * the pnp-sign-off label by hand, which the required "Patterns & Practices
 * approval" check (signoff-approval-check.yml) enforces.
 *
 * This script covers a "#sign-off" that arrives before that approval exists. It
 * posts the hold-off comment, whose #hold-off token drives the merge bot to
 * remove ready-to-merge and add do-not-merge, and which cc's the review team. If
 * the PR is already approved (label present) it does nothing, so the #sign-off
 * proceeds.
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
  // The approval label an authorized reviewer applies by hand. Must stay identical
  // to the label required by signoff-approval-check.yml.
  const SIGNED_OFF_LABEL = 'pnp-sign-off';
  // Match a standalone token so "#sign-off-later" or "#sign-offs" do not trigger.
  const SIGN_OFF_PATTERN = /#sign-off(?![\w-])/i;

  const { owner, repo } = context.repo;
  const defaultBranch = context.payload.repository?.default_branch;

  // Extract the #sign-off from the PR conversation comment (issue_comment). The
  // job `if:` already screened for the token, a non-bot author, and label absence.
  const signOff = extractSignOff();
  if (!signOff) return;
  const { prNumber, commenter, commentBody } = signOff;

  // ---- Helpers ----

  /**
   * @returns {{ prNumber: number, commenter: string, commentBody: string } | null}
   */
  function extractSignOff() {
    if (context.eventName === 'issue_comment') {
      const { issue, comment } = context.payload;
      if (!issue || !comment) {
        core.info('Comment payload is missing issue or comment data. Nothing to do.');
        return null;
      }
      return { prNumber: issue.number, commenter: comment.user.login, commentBody: comment.body || '' };
    }
    core.info(`Unhandled event '${context.eventName}'. Nothing to do.`);
    return null;
  }

  /**
   * @param {unknown} e
   * @returns {string}
   */
  function toMessage(e) {
    return e instanceof Error ? e.message : String(e);
  }

  // The message carries functional tokens (#hold-off and #label:...) that
  // downstream bots act on, plus a team cc. The token lines must start at column
  // zero (no leading whitespace) so the bots match them, so keep this template
  // literal flush-left.
  function buildHoldOffComment() {
    return `Hello @${commenter} -

The Azure Patterns & Practices team is accountable for updates to Azure architecture content and must review all PRs. After they review the content they will approve the PR and sign off again. Thanks!

#hold-off
#label:"pending-content-team/business-approval"

cc: @MicrosoftDocs/patterns-and-practices-team-pr-reviewers`;
  }

  // ---- Main ----

  if (!SIGN_OFF_PATTERN.test(commentBody)) {
    core.info('Comment has no standalone #sign-off token. Nothing to do.');
    return;
  }

  try {
    const { data: pr } = await github.rest.pulls.get({ owner, repo, pull_number: prNumber });

    // Only act on PRs that target the default branch.
    if (pr.base.ref !== defaultBranch) {
      core.info(`PR targets ${pr.base.ref}, not ${defaultBranch}. Nothing to do.`);
      return;
    }

    // Approval is a sticky, one-time gate granted by the pnp-sign-off label.
    // Re-check it live (the job `if:` reads the event payload snapshot, which can
    // lag a just-applied label). If it is present, the #sign-off should proceed,
    // so do not post a hold-off on an already-approved PR.
    const approved = (pr.labels || []).some((/** @type {{ name: string }} */ label) => label.name === SIGNED_OFF_LABEL);
    if (approved) {
      core.info(`PR already has ${SIGNED_OFF_LABEL}. Letting #sign-off proceed.`);
      return;
    }

    await github.rest.issues.createComment({
      owner, repo, issue_number: prNumber, body: buildHoldOffComment(),
    });
    core.info(`#sign-off by ${commenter} on an unapproved PR. Posted hold-off.`);
  } catch (error) {
    core.setFailed(`Hold-off notice error: ${toMessage(error)}`);
  }
};
