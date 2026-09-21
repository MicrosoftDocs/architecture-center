// Builds the cached image-dimension catalog and the bounded lightbox edit worklist.
// Invoked from the "Lightbox janitor" workflow via actions/github-script.
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const WORKSPACE = process.env.GITHUB_WORKSPACE || process.cwd();
const CONTENT_ROOTS = ['docs', 'includes'];
const CACHE_DIR = '/tmp/gh-aw/cache-memory/lightbox-dimensions';
const CACHE_FILE = path.join(CACHE_DIR, 'dimensions.json');
const DATA_DIR = '/tmp/gh-aw/data';
const WORKLIST_FILE = path.join(DATA_DIR, 'lightbox-worklist.json');
const CACHE_SCHEMA = 4;
const WIDTH_THRESHOLD = 688;
const MAX_PATCH_FILES = 10;
const CSS_PIXELS_PER_INCH = 96;

function writeJson(file, value) {
  fs.writeFileSync(file, JSON.stringify(value, null, 2) + '\n');
}

function readCache(core) {
  try {
    const parsed = JSON.parse(fs.readFileSync(CACHE_FILE, 'utf8'));
    if (parsed.schema_version === CACHE_SCHEMA && parsed.entries && typeof parsed.entries === 'object') {
      return parsed;
    }
  } catch (error) {
    core.info('No usable dimension catalog; starting with a cold cache.');
  }
  return { schema_version: CACHE_SCHEMA, entries: {} };
}

function toRepoPath(absolutePath) {
  return path.relative(WORKSPACE, absolutePath).split(path.sep).join('/');
}

function isContentPath(repoPath) {
  return CONTENT_ROOTS.some(root => repoPath === root || repoPath.startsWith(root + '/'));
}

function listContentFiles() {
  const files = [];
  function walk(directory) {
    if (!fs.existsSync(directory)) return;
    for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
      const absolute = path.join(directory, entry.name);
      if (entry.isDirectory()) {
        walk(absolute);
      } else if (entry.isFile() && path.extname(entry.name).toLowerCase() === '.md') {
        files.push(toRepoPath(absolute));
      }
    }
  }
  for (const root of CONTENT_ROOTS) walk(path.join(WORKSPACE, root));
  return files.sort();
}

function loadBlobIds() {
  const ids = new Map();
  const output = execFileSync(
    'git',
    ['ls-files', '-s', '-z', '--', ...CONTENT_ROOTS],
    { cwd: WORKSPACE, encoding: 'utf8' },
  );
  for (const record of output.split('\0')) {
    if (!record) continue;
    const match = /^(\d+) ([0-9a-f]+) (\d+)\t(.+)$/.exec(record);
    if (match && match[3] === '0') ids.set(match[4], match[2]);
  }
  return ids;
}

function resolveLocalTarget(contentFile, rawTarget) {
  if (!rawTarget || /\$\{\{|\{\{|<%|%>/.test(rawTarget)) return null;
  if (/^(?:[a-z][a-z0-9+.-]*:|\/\/|\/)/i.test(rawTarget)) return null;

  let decoded;
  try {
    decoded = decodeURIComponent(rawTarget.split(/[?#]/, 1)[0]);
  } catch (error) {
    return null;
  }

  const absolute = decoded.startsWith('~/')
    ? path.resolve(WORKSPACE, 'docs', decoded.slice(2))
    : path.resolve(WORKSPACE, path.dirname(contentFile), decoded);
  const repoPath = toRepoPath(absolute);
  if (!isContentPath(repoPath)) return null;
  if (['.gif', '.webp'].includes(path.extname(repoPath).toLowerCase())) return null;

  try {
    if (!fs.statSync(absolute).isFile()) return null;
    const realPath = fs.realpathSync(absolute);
    const realRepoPath = toRepoPath(realPath);
    if (!isContentPath(realRepoPath)) return null;
    return { absolute: realPath, repoPath: realRepoPath };
  } catch (error) {
    return null;
  }
}

function rootAttribute(attributes, name) {
  const expression = new RegExp(`(?:^|\\s)${name}\\s*=\\s*(?:"([^"]*)"|'([^']*)')`, 'i');
  const match = expression.exec(attributes);
  return match ? (match[1] ?? match[2]) : null;
}

function measureSvg(buffer) {
  const text = buffer.toString('utf8');
  const root = /<svg\b([^>]*)>/i.exec(text);
  if (!root) return null;

  const attributes = root[1];
  const widthAttribute = rootAttribute(attributes, 'width');
  const widthMatch = /^\s*([+]?(?:\d+(?:\.\d*)?|\.\d+))(px|in)?\s*$/i.exec(widthAttribute || '');
  const width = widthMatch
    ? Number(widthMatch[1]) * (widthMatch[2]?.toLowerCase() === 'in' ? CSS_PIXELS_PER_INCH : 1)
    : null;
  if (!Number.isFinite(width) || width <= 0) return null;
  const measurementSource = widthMatch[2]?.toLowerCase() === 'in'
    ? 'width-inches'
    : 'width-px-or-unitless';
  return { format: 'svg', width, measurement_source: measurementSource };
}

function measureJpeg(buffer) {
  if (buffer.length < 4 || buffer[0] !== 0xff || buffer[1] !== 0xd8) return null;
  const startOfFrameMarkers = new Set([
    0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7,
    0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf,
  ]);
  let offset = 2;
  while (offset + 3 < buffer.length) {
    if (buffer[offset] !== 0xff) {
      offset += 1;
      continue;
    }
    while (offset < buffer.length && buffer[offset] === 0xff) offset += 1;
    const marker = buffer[offset++];
    if (marker === 0xd9 || marker === 0xda) break;
    if (marker === 0x01 || (marker >= 0xd0 && marker <= 0xd7)) continue;
    if (offset + 1 >= buffer.length) break;
    const length = buffer.readUInt16BE(offset);
    if (length < 2 || offset + length > buffer.length) break;
    if (startOfFrameMarkers.has(marker) && length >= 7) {
      return {
        format: 'jpeg',
        width: buffer.readUInt16BE(offset + 5),
        height: buffer.readUInt16BE(offset + 3),
        measurement_source: 'header',
      };
    }
    offset += length;
  }
  return null;
}

function measureImage(absolutePath) {
  const buffer = fs.readFileSync(absolutePath);
  let dimensions = null;
  if (buffer.length >= 24 && buffer.subarray(0, 8).equals(Buffer.from('89504e470d0a1a0a', 'hex'))) {
    dimensions = {
      format: 'png',
      width: buffer.readUInt32BE(16),
      height: buffer.readUInt32BE(20),
      measurement_source: 'header',
    };
  } else if (buffer.length >= 2 && buffer[0] === 0xff && buffer[1] === 0xd8) {
    dimensions = measureJpeg(buffer);
  } else if (path.extname(absolutePath).toLowerCase() === '.svg' || /<svg\b/i.test(buffer.toString('utf8', 0, Math.min(buffer.length, 4096)))) {
    dimensions = measureSvg(buffer);
  }
  return dimensions && Number.isFinite(dimensions.width) && dimensions.width > 0
    ? { status: 'measured', ...dimensions }
    : { status: 'unknown' };
}

function directiveAttribute(directive, name) {
  const expression = new RegExp(`(?:^|\\s)${name}\\s*=\\s*(?:"([^"]*)"|'([^']*)')`, 'i');
  const match = expression.exec(directive);
  return match ? { value: match[1] ?? match[2] } : null;
}

async function main({ core }) {
  fs.mkdirSync(CACHE_DIR, { recursive: true });
  fs.mkdirSync(DATA_DIR, { recursive: true });

  const cache = readCache(core);
  const blobIds = loadBlobIds();
  const candidates = [];
  let directiveCount = 0;
  let measuredCount = 0;
  let reusedCount = 0;

  for (const contentFile of listContentFiles()) {
    const text = fs.readFileSync(path.join(WORKSPACE, contentFile), 'utf8');
    const expression = /:::image(?=\s)[\s\S]*?:::/g;
    let match;
    let occurrence = 0;
    while ((match = expression.exec(text)) !== null) {
      directiveCount += 1;
      occurrence += 1;
      const directive = match[0];
      const source = directiveAttribute(directive, 'source');
      const lightbox = directiveAttribute(directive, 'lightbox');
      if (!source) continue;

      const target = lightbox ? lightbox.value : source.value;
      const resolved = resolveLocalTarget(contentFile, target);
      if (!resolved) continue;

      let blobId = blobIds.get(resolved.repoPath);
      if (!blobId) {
        blobId = 'sha256:' + crypto.createHash('sha256').update(fs.readFileSync(resolved.absolute)).digest('hex');
      } else {
        blobId = 'git:' + blobId;
      }

      let measurement = cache.entries[blobId];
      if (!measurement) {
        measurement = measureImage(resolved.absolute);
        cache.entries[blobId] = measurement;
        measuredCount += 1;
      } else {
        reusedCount += 1;
      }
      if (measurement.status !== 'measured') continue;

      const shouldHaveLightbox = measurement.width > WIDTH_THRESHOLD;
      const action = lightbox && !shouldHaveLightbox
        ? 'remove'
        : (!lightbox && shouldHaveLightbox ? 'add' : null);
      if (!action) continue;

      const line = text.slice(0, match.index).split('\n').length;
      candidates.push({
        file: contentFile,
        line,
        occurrence,
        action,
        source: source.value,
        current_lightbox: lightbox ? lightbox.value : null,
        measured_target: target,
        target_file: resolved.repoPath,
        width: measurement.width,
        format: measurement.format,
        measurement_source: measurement.measurement_source,
        expected_directive: directive,
      });
    }
  }

  cache.entries = Object.fromEntries(Object.entries(cache.entries).sort(([left], [right]) => left.localeCompare(right)));
  writeJson(CACHE_FILE, cache);

  candidates.sort((left, right) =>
    left.file.localeCompare(right.file) || left.line - right.line || left.action.localeCompare(right.action),
  );
  const selectedFiles = [...new Set(candidates.map(candidate => candidate.file))].slice(0, MAX_PATCH_FILES);
  const selectedFileSet = new Set(selectedFiles);
  const actions = candidates.filter(candidate => selectedFileSet.has(candidate.file));
  writeJson(WORKLIST_FILE, {
    threshold: WIDTH_THRESHOLD,
    comparison: 'width > threshold',
    scanned_directives: directiveCount,
    newly_measured_images: measuredCount,
    reused_measurements: reusedCount,
    total_candidate_actions: candidates.length,
    remaining_candidate_actions: candidates.length - actions.length,
    selected_files: selectedFiles,
    actions,
  });

  core.info(`Scanned ${directiveCount} image directive(s).`);
  core.info(`Measured ${measuredCount} new image blob(s); reused ${reusedCount} cached measurement(s).`);
  core.info(`Selected ${actions.length} action(s) in ${selectedFiles.length} file(s) from ${candidates.length} candidate action(s).`);
}

module.exports = { main };