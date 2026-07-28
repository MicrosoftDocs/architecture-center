// @ts-check
'use strict';

/**
 * Minimize superseded bot comments on open pull requests.
 *
 * Several Microsoft Learn build and validation bots re-post the same report on
 * every push, so a PR accumulates a stack of stale copies. This script groups a
 * bot's comments by report type, then collapses every copy except the newest as
 * OUTDATED via the GraphQL minimizeComment mutation.
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

  // Only comments from these bots are considered. The Learn build service posts
  // under a rotating pool of numbered identities (learn-build-service-prod,
  // learn-build-service-prod-02, ...-05, and so on), so the pattern matches any
  // -NN variant. Comments are grouped by report type alone, so copies collapse
  // regardless of which of these identities posted them.
  const TRACKED_BOT_PATTERNS = [
    /^learn-build-service-prod(-\d+)?\[bot\]$/,
    /^prmerger-automator\[bot\]$/,
  ];

  // Only inspect PRs updated within this window. Bot comments bump a PR's
  // updated_at, so anything older has no new activity to reconcile. The window is
  // wider than the daily schedule so a missed or delayed run still catches up.
  const ACTIVITY_WINDOW_HOURS = 30;

  // Only reconcile PRs targeting this base branch.
  const BASE_BRANCH = 'main';

  const { owner, repo } = context.repo;

  // ---- Helpers ----

  /**
   * Whether a login belongs to one of the tracked bots.
   *
   * @param {string} login
   * @returns {boolean}
   */
  function isTrackedBot(login) {
    return TRACKED_BOT_PATTERNS.some((pattern) => pattern.test(login));
  }

  /**
   * Map a comment body to a stable "type key" so runs of the same report group
   * together. Uses the first known marker or heading. Returns null for unknown
   * types, which are left untouched.
   *
   * @param {string} body
   * @returns {string | null}
   */
  function reportType(body) {
    if (body.includes('Learn Build status updates')) return 'build-status';
    if (body.includes('PoliCheck Scan Report')) return 'policheck';
    return null;
  }

  /**
   * @param {unknown} e
   * @returns {string}
   */
  function toMessage(e) {
    return e instanceof Error ? e.message : String(e);
  }

  // ---- Main ----

  // Page through open PRs newest-updated first and stop at the activity window.
  // A PR's updated_at advances when a bot posts a comment, so PRs outside the
  // window have nothing new to reconcile.
  const cutoff = new Date(Date.now() - ACTIVITY_WINDOW_HOURS * 60 * 60 * 1000).toISOString();
  const prs = [];
  for await (const { data: page } of github.paginate.iterator(github.rest.pulls.list, {
    owner,
    repo,
    state: 'open',
    sort: 'updated',
    direction: 'desc',
    per_page: 100,
  })) {
    let reachedCutoff = false;
    for (const pr of page) {
      if (pr.updated_at < cutoff) {
        reachedCutoff = true;
        break;
      }
      if (pr.base.ref !== BASE_BRANCH) continue;
      prs.push(pr);
    }
    if (reachedCutoff) break;
  }
  core.info(`Found ${prs.length} open PRs targeting ${BASE_BRANCH} updated in the last ${ACTIVITY_WINDOW_HOURS}h`);

  // TEMPORARY (testing): restrict the work to a single PR. Remove this block and
  // the TEST_ONLY_PR constant once testing is complete.
  const TEST_ONLY_PR = 14669;
  const scoped = prs.filter((pr) => pr.number === TEST_ONLY_PR);
  core.warning(`TEST MODE: restricting work to PR #${TEST_ONLY_PR} (${scoped.length} of ${prs.length} PRs match)`);
  prs.length = 0;
  prs.push(...scoped);

  let minimized = 0;
  let skipped = 0;

  for (const pr of prs) {
    const comments = await github.paginate(github.rest.issues.listComments, {
      owner,
      repo,
      issue_number: pr.number,
      per_page: 100,
    });

    // Collect tracked bot comments that have a known type, keyed by type.
    /** @type {Record<string, Array<{ id: number, node_id: string, created_at: string }>>} */
    const groups = {};
    for (const comment of comments) {
      if (!comment.user || !isTrackedBot(comment.user.login)) continue;
      const type = reportType(comment.body || '');
      if (!type) continue;
      (groups[type] = groups[type] || []).push({
        id: comment.id,
        node_id: comment.node_id,
        created_at: comment.created_at,
      });
    }

    // For each group with more than one posting, minimize all but the newest.
    for (const [key, entries] of Object.entries(groups)) {
      if (entries.length < 2) continue;
      entries.sort((a, b) => a.created_at.localeCompare(b.created_at));
      const outdated = entries.slice(0, -1); // all except the last (newest)
      for (const entry of outdated) {
        try {
          await github.graphql(
            `
              mutation($nodeId: ID!) {
                minimizeComment(input: { classifier: OUTDATED, subjectId: $nodeId }) {
                  minimizedComment { isMinimized }
                }
              }
            `,
            { nodeId: entry.node_id }
          );
          core.info(`PR #${pr.number} — minimized comment ${entry.id} (${key})`);
          minimized++;
        } catch (error) {
          core.warning(`PR #${pr.number} — failed to minimize comment ${entry.id}: ${toMessage(error)}`);
          skipped++;
        }
      }
    }
  }

  core.info(`Done. Minimized: ${minimized}, skipped: ${skipped}`);
};
