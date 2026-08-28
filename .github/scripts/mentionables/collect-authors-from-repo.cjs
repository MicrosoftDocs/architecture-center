// Scans docs/ for article `author` fields and writes the distinct union to repo memory.
// Invoked from the "Update authors from repo" workflow via actions/github-script.
const fs = require('fs');
const path = require('path');

const DOCS_ROOT = 'docs';
const MEMORY_DIR = '/tmp/gh-aw/repo-memory/mentionables';
// Depth-1 subfolder: repo-memory file-glob only matches files one level below the branch root.
const OUT_FILE = path.join(MEMORY_DIR, 'repo', 'article-authors.json');

// Match a top-level (md frontmatter) or metadata-indented (yml) `author:` line.
// Leading `ms.` is excluded because the `author:` token is not whitespace-preceded there.
const AUTHOR_RE = /^[ \t]*author:[ \t]*["']?([A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)["']?[ \t]*$/;

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* walk(full);
    } else if (entry.isFile() && (full.endsWith('.md') || full.endsWith('.yml'))) {
      yield full;
    }
  }
}

async function main({ core }) {
  const authors = new Set();
  for (const file of walk(DOCS_ROOT)) {
    const text = fs.readFileSync(file, 'utf8');
    for (const line of text.split(/\r?\n/)) {
      const m = AUTHOR_RE.exec(line);
      if (m) authors.add(m[1]);
    }
  }

  const sorted = [...authors].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
  fs.mkdirSync(path.dirname(OUT_FILE), { recursive: true });
  fs.writeFileSync(OUT_FILE, JSON.stringify(sorted, null, 2) + '\n');
  core.info(`Wrote ${sorted.length} distinct authors to ${OUT_FILE}`);

  // Emit noop so the harness skips the AI engine entirely; repo memory still commits.
  // User steps don't inherit GH_AW_SAFE_OUTPUTS, so fall back to the same path gh-aw uses.
  const safeOutputs = process.env.GH_AW_SAFE_OUTPUTS || `${process.env.RUNNER_TEMP}/gh-aw/safeoutputs/outputs.jsonl`;
  fs.mkdirSync(path.dirname(safeOutputs), { recursive: true });
  fs.appendFileSync(safeOutputs, JSON.stringify({ type: 'noop', message: `Stored ${sorted.length} article authors` }) + '\n');
}

module.exports = { main };
