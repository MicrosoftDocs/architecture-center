// Combines the mentionable lists from the memory/mentionables branch and rewrites the
// allowed: block in the shared author-mentions file. Invoked from the
// "Sync author mentions" workflow via actions/github-script.
const fs = require('fs');

const BRANCH = 'memory/mentionables';
const SHARED_FILE = '.github/workflows/shared/author-mentions.md';
// Depth-1 subfolders match how each writer stores its list on the branch; manual list is optional.
const SOURCES = ['repo/article-authors.json', 'prs/pr-knowns.json', 'manual/manually-addeds.json'];
const EXCLUSIONS_SOURCE = 'manual/manually-excludeds.json';

// GitHub usernames: 1-39 chars, alphanumeric or hyphen, no leading/trailing hyphen.
const USERNAME_RE = /^[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?$/;

async function main({ github, context, core }) {
  const { owner, repo } = context.repo;

  async function readList(file) {
    try {
      const res = await github.rest.repos.getContent({ owner, repo, path: file, ref: BRANCH });
      const text = Buffer.from(res.data.content, 'base64').toString('utf8');
      const arr = JSON.parse(text);
      return Array.isArray(arr) ? arr : [];
    } catch (e) {
      if (e.status === 404) return [];
      throw e;
    }
  }

  const excludedUsernames = new Set(
    (await readList(EXCLUSIONS_SOURCE))
      .filter((login) => typeof login === 'string' && USERNAME_RE.test(login))
      .map((login) => login.toLowerCase()),
  );

  const union = new Map();
  for (const src of SOURCES) {
    for (const login of await readList(src)) {
      if (typeof login !== 'string' || !USERNAME_RE.test(login)) continue;
      const normalized = login.toLowerCase();
      if (!excludedUsernames.has(normalized) && !union.has(normalized)) {
        union.set(normalized, login);
      }
    }
  }
  const sorted = [...union.values()].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));

  const content = fs.readFileSync(SHARED_FILE, 'utf8');
  const lines = content.split('\n');
  // Replace only the mentions.allowed list items, preserving every other setting.
  const idx = lines.findIndex((l) => /^    allowed:\s*$/.test(l));
  if (idx === -1) throw new Error(`Could not find "    allowed:" in ${SHARED_FILE}`);
  let end = idx + 1;
  while (end < lines.length && /^      - /.test(lines[end])) end++;
  const newItems = sorted.map((u) => `      - ${u}`);
  const rebuilt = [...lines.slice(0, idx + 1), ...newItems, ...lines.slice(end)].join('\n');

  if (rebuilt === content) {
    core.info(`No change: ${sorted.length} mentionables already current.`);
    core.setOutput('changed', 'false');
    // Emit noop so the harness skips the AI engine and no pull request is opened.
    // User steps don't inherit GH_AW_SAFE_OUTPUTS, so fall back to the same path gh-aw uses.
    const safeOutputs = process.env.GH_AW_SAFE_OUTPUTS || `${process.env.RUNNER_TEMP}/gh-aw/safeoutputs/outputs.jsonl`;
    fs.mkdirSync(require('path').dirname(safeOutputs), { recursive: true });
    fs.appendFileSync(safeOutputs, JSON.stringify({ type: 'noop', message: `Mentionables unchanged (${sorted.length})` }) + '\n');
    return;
  }

  fs.writeFileSync(SHARED_FILE, rebuilt);
  core.info(`Updated ${SHARED_FILE} with ${sorted.length} mentionables.`);
  core.setOutput('changed', 'true');
}

module.exports = { main };
