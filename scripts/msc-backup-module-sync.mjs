#!/usr/bin/env node
/**
 * Refresh backup-system portable module from repo scripts/.
 * Usage: npm run msc:backup:module:sync
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');
const MODULE_ROOT = path.join(REPO_ROOT, '.cursor', 'custom-scriptz', 'backup-system');

const FILES = [
  { src: 'scripts/msc-backup.mjs', dest: 'scripts/msc-backup.mjs' },
  { src: 'scripts/lib/msc-load-env.mjs', dest: 'scripts/lib/msc-load-env.mjs' },
  { src: 'scripts/clean-old-backups.ps1', dest: 'scripts/clean-old-backups.ps1', optional: true },
];

function copyFile(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

if (!fs.existsSync(MODULE_ROOT)) {
  console.error(`FAIL: module folder missing: ${MODULE_ROOT}`);
  process.exit(1);
}

console.log('[msc:backup:module:sync] refreshing portable module…\n');

let copied = 0;
let skipped = 0;

for (const { src: relSrc, dest: relDest, optional } of FILES) {
  const src = path.join(REPO_ROOT, relSrc);
  const dest = path.join(MODULE_ROOT, relDest);
  if (!fs.existsSync(src)) {
    if (optional) console.log(`  — optional skip: ${relSrc}`);
    else {
      console.warn(`  SKIP missing: ${relSrc}`);
      skipped += 1;
    }
    continue;
  }
  copyFile(src, dest);
  console.log(`  OK ${relDest}`);
  copied += 1;
}

console.log(`\nPASS: ${copied} file(s) synced → .cursor/custom-scriptz/backup-system/`);
if (skipped) console.log(`WARN: ${skipped} expected file(s) missing in repo`);
