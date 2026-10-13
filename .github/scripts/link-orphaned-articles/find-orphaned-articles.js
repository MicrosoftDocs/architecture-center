// @ts-check
'use strict';

const fs = require('fs');
const path = require('path');

/**
 * Find published article entry points that aren't referenced by the main TOC.
 *
 * Markdown articles are identified by an article `ms.topic` entry in their front
 * matter. YAML articles are identified by both a YamlMime declaration and an
 * article `ms.topic` entry. This excludes `ms.topic: include`, paired
 * `*-content.md` files, and other supporting files.
 *
 * Invoked from actions/github-script, which injects `core`.
 *
 * @param {object} args
 * @param {typeof import('@actions/core')} args.core Actions core toolkit.
 * @param {{ workspace?: string, writeSummary?: boolean }} [options]
 * @returns {Promise<{ articleCount: number, tocReferenceCount: number, orphanedArticles: string[] }>}
 */
module.exports = async ({ core }, options = {}) => {
  const workspace = path.resolve(options.workspace || process.env.GITHUB_WORKSPACE || process.cwd());
  const contentRoot = path.join(workspace, 'docs');
  const mainToc = path.join(contentRoot, 'toc.yml');

  if (!fs.existsSync(mainToc)) {
    throw new Error(`Main TOC not found: ${toPosix(path.relative(workspace, mainToc))}`);
  }

  const articles = findArticles(contentRoot);
  const tocReferences = findTocReferences(mainToc, contentRoot);
  const orphanedArticles = [...articles]
    .filter((article) => !isReferenced(article, tocReferences))
    .map((article) => toPosix(path.relative(workspace, article)))
    .sort();

  core.setOutput('orphaned-count', orphanedArticles.length);
  core.setOutput('orphaned-articles', JSON.stringify(orphanedArticles));
  core.info(`Scanned ${articles.size} articles and ${tocReferences.size} unique local TOC references.`);

  if (orphanedArticles.length === 0) {
    core.info('No orphaned articles found.');
  } else {
    core.warning(`Found ${orphanedArticles.length} article(s) that aren't referenced by the main TOC.`);
    for (const article of orphanedArticles) {
      core.info(`- ${article}`);
    }
  }

  const writeSummary = options.writeSummary ?? Boolean(process.env.GITHUB_STEP_SUMMARY);
  if (writeSummary) {
    core.summary.addHeading('Orphaned article report', 2);
    core.summary.addRaw(
      `Scanned ${articles.size} articles and found ${orphanedArticles.length} orphaned article(s).`
    );
    if (orphanedArticles.length > 0) {
      core.summary.addHeading('Articles not in the TOC', 3);
      core.summary.addList(orphanedArticles.map((article) => `\`${article}\``));
    }
    await core.summary.write();
  }

  return {
    articleCount: articles.size,
    tocReferenceCount: tocReferences.size,
    orphanedArticles,
  };
};

/**
 * @param {string} contentRoot
 * @returns {Set<string>}
 */
function findArticles(contentRoot) {
  const articles = new Set();

  for (const file of walkFiles(contentRoot)) {
    const extension = path.extname(file).toLowerCase();
    if (!['.md', '.yml', '.yaml'].includes(extension)) continue;

    const contents = fs.readFileSync(file, 'utf8').replace(/^\uFEFF/, '');
    if (isArticle(extension, contents)) {
      articles.add(path.resolve(file));
    }
  }

  return articles;
}

/**
 * @param {string} extension
 * @param {string} contents
 * @returns {boolean}
 */
function isArticle(extension, contents) {
  if (extension === '.md') {
    const lines = contents.split(/\r?\n/);
    if (lines[0]?.trim() !== '---') return false;

    const closingDelimiter = lines.findIndex((line, index) => index > 0 && line.trim() === '---');
    if (closingDelimiter === -1) return false;

    return hasArticleTopic(lines.slice(1, closingDelimiter));
  }

  return /^###\s+YamlMime\s*:/m.test(contents) && hasArticleTopic(contents.split(/\r?\n/));
}

/**
 * @param {string[]} lines
 * @returns {boolean}
 */
function hasArticleTopic(lines) {
  const topicLine = lines.find((line) => /^\s*ms\.topic\s*:/.test(line));
  if (!topicLine) return false;

  const match = topicLine.match(/^\s*ms\.topic\s*:\s*(.*?)\s*$/);
  const topic = match ? parseYamlScalar(match[1]).toLowerCase() : '';
  return Boolean(topic) && topic !== 'include';
}

/**
 * Collect local article references from the main TOC and any local TOCs that it
 * includes. References are stored as absolute paths. Extensionless references
 * are matched against article aliases later.
 *
 * @param {string} mainToc
 * @param {string} contentRoot
 * @returns {Set<string>}
 */
function findTocReferences(mainToc, contentRoot) {
  const references = new Set();
  const visitedTocs = new Set();

  /**
   * @param {string} tocPath
   */
  function visit(tocPath) {
    const resolvedToc = path.resolve(tocPath);
    if (visitedTocs.has(resolvedToc)) return;
    visitedTocs.add(resolvedToc);

    if (!fs.existsSync(resolvedToc)) {
      throw new Error(`Included TOC not found: ${toPosix(path.relative(contentRoot, resolvedToc))}`);
    }

    const contents = fs.readFileSync(resolvedToc, 'utf8');
    for (const line of contents.split(/\r?\n/)) {
      const match = line.match(/^\s*(?:-\s*)?(href|include)\s*:\s*(.*?)\s*$/);
      if (!match) continue;

      const value = parseYamlScalar(match[2]);
      const target = resolveTocTarget(value, resolvedToc, contentRoot);
      if (!target) continue;

      if (match[1] === 'include') {
        visit(target);
      } else {
        references.add(target);
      }
    }
  }

  visit(mainToc);
  return references;
}

/**
 * @param {string} article
 * @param {Set<string>} references
 * @returns {boolean}
 */
function isReferenced(article, references) {
  if (references.has(article)) return true;

  const extensionlessArticle = article.slice(0, -path.extname(article).length);
  if (references.has(extensionlessArticle)) return true;

  const basename = path.basename(extensionlessArticle).toLowerCase();
  if (basename === 'index') {
    const directory = path.dirname(article);
    return references.has(directory) || references.has(`${directory}${path.sep}`);
  }

  return false;
}

/**
 * @param {string} value
 * @param {string} tocPath
 * @param {string} contentRoot
 * @returns {string | null}
 */
function resolveTocTarget(value, tocPath, contentRoot) {
  const withoutFragment = value.split(/[?#]/, 1)[0].trim();
  if (!withoutFragment || withoutFragment.startsWith('#')) return null;
  if (/^[a-z][a-z\d+.-]*:/i.test(withoutFragment) || withoutFragment.startsWith('//')) return null;

  const architectureRoot = '/azure/architecture';
  if (withoutFragment === architectureRoot || withoutFragment === `${architectureRoot}/`) {
    return path.resolve(contentRoot, 'index');
  }
  if (withoutFragment.startsWith(`${architectureRoot}/`)) {
    return path.resolve(contentRoot, withoutFragment.slice(architectureRoot.length + 1));
  }
  if (withoutFragment.startsWith('/')) return null;

  return path.resolve(path.dirname(tocPath), withoutFragment);
}

/**
 * Parse the simple scalar values used by TOC `href` and `include` properties.
 *
 * @param {string} rawValue
 * @returns {string}
 */
function parseYamlScalar(rawValue) {
  const value = rawValue.trim();
  if (value.startsWith("'")) {
    const closingQuote = value.lastIndexOf("'");
    if (closingQuote > 0) {
      return value.slice(1, closingQuote).replace(/''/g, "'");
    }
  }
  if (value.startsWith('"')) {
    const closingQuote = value.lastIndexOf('"');
    if (closingQuote > 0) {
      const quotedValue = value.slice(0, closingQuote + 1);
      try {
        return JSON.parse(quotedValue);
      } catch {
        throw new Error(`Invalid quoted TOC value: ${rawValue}`);
      }
    }
  }

  return value.replace(/\s+#.*$/, '').trim();
}

/**
 * @param {string} root
 * @returns {string[]}
 */
function walkFiles(root) {
  const files = [];
  const entries = fs.readdirSync(root, { withFileTypes: true })
    .sort((left, right) => left.name.localeCompare(right.name));

  for (const entry of entries) {
    const entryPath = path.join(root, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkFiles(entryPath));
    } else if (entry.isFile()) {
      files.push(entryPath);
    }
  }

  return files;
}

/**
 * @param {string} value
 * @returns {string}
 */
function toPosix(value) {
  return value.split(path.sep).join('/');
}
