// Collects mentionable logins from recent pull requests and writes them to repo memory.
// Invoked from the "Update authors from PRs" workflow via actions/github-script.
const fs = require('fs');
const path = require('path');

const MEMORY_DIR = '/tmp/gh-aw/repo-memory/mentionables';
const KNOWNS_FILE = path.join(MEMORY_DIR, 'pr-knowns.json');
const STATE_FILE = path.join(MEMORY_DIR, 'pr-scan-state.json');
const LOOKBACK_DAYS = 30;

// GitHub usernames: 1-39 chars, alphanumeric or hyphen, no leading/trailing hyphen.
const USERNAME_RE = /^[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?$/;
const MENTION_RE = /(?:^|[^A-Za-z0-9_/])@([A-Za-z0-9-]{1,39})/g;

const isBot = (login) => !login || login.endsWith('[bot]') || login.toLowerCase() === 'github-actions';
const addLogin = (set, login) => { if (login && !isBot(login) && USERNAME_RE.test(login)) set.add(login); };
const readJSON = (file, fallback) => { try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return fallback; } };

async function main({ github, context, core }) {
  const knowns = new Set(readJSON(KNOWNS_FILE, []));
  const oldState = readJSON(STATE_FILE, {});
  const newState = {};

  const cutoff = Date.now() - LOOKBACK_DAYS * 24 * 60 * 60 * 1000;
  const { owner, repo } = context.repo;

  function extract(pr) {
    addLogin(knowns, pr.user && pr.user.login);
    for (const a of pr.assignees || []) addLogin(knowns, a.login);
    for (const r of pr.requested_reviewers || []) addLogin(knowns, r.login);
    if (pr.body) {
      MENTION_RE.lastIndex = 0;
      let m;
      while ((m = MENTION_RE.exec(pr.body)) !== null) addLogin(knowns, m[1]);
    }
  }

  // Skip PRs whose updated_at is unchanged since the last scan (watermark).
  function consider(pr) {
    newState[pr.number] = pr.updated_at;
    if (oldState[pr.number] === pr.updated_at) return false;
    extract(pr);
    return true;
  }

  let scanned = 0, changed = 0;

  // All open PRs.
  for await (const { data: prs } of github.paginate.iterator(github.rest.pulls.list, {
    owner, repo, state: 'open', per_page: 100,
  })) {
    for (const pr of prs) { scanned++; if (consider(pr)) changed++; }
  }

  // Closed PRs updated within the lookback window (sorted newest-first; stop when older).
  outer:
  for await (const { data: prs } of github.paginate.iterator(github.rest.pulls.list, {
    owner, repo, state: 'closed', sort: 'updated', direction: 'desc', per_page: 100,
  })) {
    for (const pr of prs) {
      if (new Date(pr.updated_at).getTime() < cutoff) break outer;
      scanned++; if (consider(pr)) changed++;
    }
  }

  const sorted = [...knowns].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
  fs.mkdirSync(MEMORY_DIR, { recursive: true });
  fs.writeFileSync(KNOWNS_FILE, JSON.stringify(sorted, null, 2) + '\n');
  fs.writeFileSync(STATE_FILE, JSON.stringify(newState, null, 2) + '\n');
  core.info(`Scanned ${scanned} PRs (${changed} changed since last run); ${sorted.length} known logins`);

  // Emit noop so the harness skips the AI engine entirely; repo memory still commits.
  // User steps don't inherit GH_AW_SAFE_OUTPUTS, so fall back to the same path gh-aw uses.
  const safeOutputs = process.env.GH_AW_SAFE_OUTPUTS || `${process.env.RUNNER_TEMP}/gh-aw/safeoutputs/outputs.jsonl`;
  fs.mkdirSync(path.dirname(safeOutputs), { recursive: true });
  fs.appendFileSync(safeOutputs, JSON.stringify({ type: 'noop', message: `PR scan: ${sorted.length} known logins (${changed} PRs changed)` }) + '\n');
}

module.exports = { main };
