const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const MEMORY = '/tmp/gh-aw/repo-memory/svg-icon-updater-tracking';
const DATA = '/tmp/gh-aw/agent/svg-icon-updater';
const hash = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const writeJson = (file, value) => fs.writeFileSync(file, JSON.stringify(value, null, 2) + '\n');
const readJson = file => JSON.parse(fs.readFileSync(file, 'utf8'));

function isSvg(file) {
  return file.startsWith('docs/') && path.posix.normalize(file) === file && !file.includes('\\') && file.endsWith('.svg') &&
    !['docs/_images/', 'docs/icons/', 'docs/browse/'].some(prefix => file.startsWith(prefix));
}

function loadState(file) {
  if (!fs.existsSync(file)) return { last_processed_path: null };
  const state = readJson(file);
  assert.ok(state && typeof state === 'object' && !Array.isArray(state), 'Invalid SVG cursor state');
  assert.deepEqual(Object.keys(state), ['last_processed_path'], 'SVG memory must contain only the cursor');
  assert.ok(state.last_processed_path === null || isSvg(state.last_processed_path), 'Invalid SVG cursor path');
  return state;
}

function choose(files, cursor) {
  const available = [...files].sort();
  const next = available.find(file => cursor === null || file > cursor);
  return {
    selected: next ?? available[0] ?? null,
    eligible_count: available.length,
    wrapped: next === undefined && available.length > 0,
  };
}

async function prepare({ context, core, workspace = process.env.GITHUB_WORKSPACE,
  memory = MEMORY, data = DATA }) {
  const root = path.resolve(workspace);
  const reference = path.join(root, '_svg-icon-reference');
  const revision = execFileSync('git', ['rev-parse', 'HEAD'], { cwd: reference, encoding: 'utf8' }).trim();
  const stateFile = path.join(memory, 'state.json');
  const state = loadState(stateFile);
  const tracked = execFileSync('git', ['ls-files', '-z', '--', 'docs'], { cwd: root, encoding: 'utf8' })
    .split('\0').filter(isSvg);
  for (const file of tracked) {
    const absolute = path.join(root, file);
    assert.ok(fs.lstatSync(absolute).isFile(), `SVG input must be a regular file: ${file}`);
  }
  const selection = choose(tracked, state.last_processed_path);
  const selected = selection.selected
    ? { path: selection.selected, sha256: hash(fs.readFileSync(path.join(root, selection.selected))) }
    : null;
  fs.mkdirSync(memory, { recursive: true });
  fs.mkdirSync(path.join(data, 'artifacts'), { recursive: true });
  const cursorBefore = state.last_processed_path;
  if (selected) state.last_processed_path = selected.path;
  // Cursor advancement is attempt rotation, never semantic verification.
  writeJson(stateFile, state);
  const work = {
    schema_version: 1,
    source_revision: execFileSync('git', ['rev-parse', 'HEAD'], { cwd: root, encoding: 'utf8' }).trim(),
    reference_revision: revision,
    reference_branch: 'memory/svg-icon-catalog',
    node: path.join(data, 'bin/node'),
    toolkit: path.join(reference, 'tooling/diagram.mjs'),
    usage: path.join(reference, 'tooling/SINGLE-SVG.md'),
    catalog: path.join(reference, 'memory/svg-icon-catalog'),
    font: path.join(data, 'fonts/DejaVuSans.ttf'),
    input: selection.selected ? path.join(data, 'artifacts/input.svg') : null,
    selected,
    cursor_before: cursorBefore,
    cursor_after: state.last_processed_path,
    wrapped: selection.wrapped,
    eligible_count: selection.eligible_count,
    svg_count: tracked.length,
    run_url: `${context.serverUrl || 'https://github.com'}/${context.repo.owner}/${context.repo.repo}/actions/runs/${context.runId}`,
  };
  if (work.selected) fs.copyFileSync(path.join(root, work.selected.path), work.input);
  writeJson(path.join(data, 'artifacts/work-item.json'), work);
  core.info(selected ? `Selected ${selected.path}${selection.wrapped ? ' (wrapped to start)' : ''}` : 'No eligible SVGs found.');
  await core.summary.addHeading('SVG icon updater selection', 3).addTable([
    [{ data: 'Metric', header: true }, { data: 'Value', header: true }],
    ['Selected SVG', work.selected?.path || '(none)'],
    ['Eligible SVGs', String(work.eligible_count)],
    ['Cursor before', cursorBefore || '(start)'],
    ['Cursor after', state.last_processed_path || '(none)'],
    ['Wrapped', work.wrapped ? 'yes' : 'no'],
    ['Reference revision', revision],
  ]).write();
  return work;
}

function verify({ workspace = process.env.GITHUB_WORKSPACE, data = DATA } = {}) {
  const root = path.resolve(workspace);
  const work = readJson(path.join(data, 'artifacts/work-item.json'));
  assert.equal(work.schema_version, 1);
  const reference = path.join(root, '_svg-icon-reference');
  execFileSync('git', ['diff', '--exit-code', 'HEAD'], { cwd: reference, stdio: 'pipe' });
  const changed = execFileSync('git', ['diff', '--name-only', '-z', 'HEAD'], { cwd: root, encoding: 'utf8' })
    .split('\0').filter(Boolean);
  if (!work.selected) {
    assert.deepEqual(changed, [], 'An empty selection must not change the checkout');
    return { changed: false };
  }
  assert.ok(isSvg(work.selected.path), 'Selected source must be a normalized docs SVG path');
  assert.equal(hash(fs.readFileSync(work.input)), work.selected.sha256, 'Original run input was modified');
  if (changed.length) {
    assert.deepEqual(changed, [work.selected.path], 'Only the selected SVG may change');
    const validation = readJson(path.join(data, 'artifacts/result/validation.json'));
    const output = fs.readFileSync(path.join(data, 'artifacts/result/updated.svg'));
    assert.equal(validation.input_sha256, work.selected.sha256);
    assert.equal(validation.changed, true);
    assert.equal(validation.output_sha256, hash(output));
    assert.equal(hash(fs.readFileSync(path.join(root, work.selected.path))), validation.output_sha256);
    assert.equal(validation.labels_preserved, true);
    assert.equal(validation.official_appearance_verified, true);
    assert.deepEqual(validation.validation.map(check => check.width), [1800, 3600]);
    assert.ok(validation.validation.every(check => check.outside_footprints === 0));
  }
  return { changed: changed.length > 0, selected: work.selected.path };
}

module.exports = { choose, loadState, prepare, verify };

if (require.main === module) {
  assert.equal(process.argv[2], 'verify', 'Usage: tracking.cjs verify');
  console.log(JSON.stringify(verify(), null, 2));
}
