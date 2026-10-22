"use strict";

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const XLSX = require("xlsx");

function requireValue(condition, message) {
  if (!condition) throw new Error(message);
}

function isExcludedRow(data) {
  const populated = Object.values(data).filter(value => value !== null && value !== "");
  if (!populated.length) return true;
  if (populated.length === 1 && typeof populated[0] === "string" &&
    populated[0].startsWith("Applied filters:")) return true;
  return data.Title === "Total" && !data.GitUrl && !data.LiveUrl &&
    Object.entries(data).every(([name, value]) => name === "Title" || value === null ||
      value === "" || typeof value === "number" ||
      (typeof value === "string" && /^-?\d+(\.\d+)?$/.test(value)));
}

function workbookRows(filename) {
  const stat = fs.lstatSync(filename);
  requireValue(stat.isFile() && !stat.isSymbolicLink(), `Expected a regular workbook: ${filename}`);
  requireValue(stat.size <= 25 * 1024 * 1024, `Workbook exceeds 25 MiB: ${filename}`);
  const bytes = fs.readFileSync(filename);
  requireValue(bytes.length >= 4 && bytes.readUInt32LE(0) === 0x04034b50,
    `Expected an XLSX ZIP archive: ${filename}`);
  const workbook = XLSX.read(bytes, { type: "buffer" });
  const source = path.basename(filename);
  const records = [];
  for (const worksheet of workbook.SheetNames) {
    const sheet = workbook.Sheets[worksheet];
    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null, raw: true });
    const headerRow = rows.findIndex(values => values.some(value => value !== null && value !== ""));
    if (headerRow === -1) continue;
    const headers = rows[headerRow];
    requireValue(headers.every(name => typeof name === "string" && name.trim()),
      `Empty or invalid column header in ${source}, worksheet ${worksheet}.`);
    requireValue(new Set(headers).size === headers.length,
      `Duplicate column headers in ${source}, worksheet ${worksheet}.`);
    const firstRow = XLSX.utils.decode_range(sheet["!ref"]).s.r;
    for (let row = headerRow + 1; row < rows.length; row++) {
      const data = Object.fromEntries(headers.map((name, column) => [name, rows[row][column]]));
      if (isExcludedRow(data)) continue;
      const identity = [
        source, worksheet,
        Object.keys(data).sort().map(column => [column, data[column]]),
      ];
      records.push({
        id: crypto.createHash("sha256").update(JSON.stringify(identity)).digest("hex"),
        source, worksheet, row: firstRow + row + 1,
        article: data.GitUrl || data.LiveUrl || null, status: "unassessed", data,
      });
    }
  }
  return records;
}

function readRows(inputRoot, folder = ".") {
  const root = fs.realpathSync(inputRoot);
  const directory = fs.realpathSync(path.resolve(root, folder));
  const relative = path.relative(root, directory);
  requireValue(relative !== ".." && !relative.startsWith(`..${path.sep}`) &&
    !path.isAbsolute(relative) && fs.statSync(directory).isDirectory(),
    "Folder must be inside the input checkout.");
  const files = fs.readdirSync(directory).filter(file => path.extname(file).toLowerCase() === ".xlsx")
    .sort();
  requireValue(files.length, "No XLSX files found in the selected folder.");
  const records = new Map();
  for (const filename of files) {
    for (const row of workbookRows(path.join(directory, filename))) {
      if (!records.has(row.id)) records.set(row.id, row);
    }
  }
  return [...records.values()];
}

function writeJson(filename, value) {
  fs.mkdirSync(path.dirname(filename), { recursive: true });
  fs.writeFileSync(filename, JSON.stringify(value, null, 2) + "\n");
}

function main({ core, inputRoot, folder, output }) {
  const rows = readRows(inputRoot, folder);
  writeJson(output, rows);
  core.info(`Extracted ${rows.length} recommendation rows.`);
  return rows.length;
}

module.exports = { main, readRows };
