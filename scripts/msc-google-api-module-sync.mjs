#!/usr/bin/env node
/**
 * Refresh google-api-proxy portable module from repo scripts/ + lib/.
 * Usage: npm run msc:google-api:module:sync
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');
const MODULE_ROOT = path.join(REPO_ROOT, '.cursor', 'custom-scriptz', 'google-api-proxy');

const SCRIPT_FILES = [
  'msc-litellm-preflight.mjs',
  'msc-litellm-install-deps.mjs',
  'msc-litellm-start.mjs',
  'msc-litellm-start-detached.mjs',
  'msc-litellm-test-ngrok.mjs',
  'msc-litellm-stop.mjs',
  'msc-litellm-status.mjs',
  'msc-litellm-verify.mjs',
];

const LIB_FILES = ['msc-load-env.mjs', 'msc-litellm-env.mjs', 'msc-ngrok-utils.mjs'];

const PREREQ_FILES = [{ src: 'scripts/msc-kill-dev-port.mjs', dest: 'prerequisites/scripts/msc-kill-dev-port.mjs' }];

const ASSET_PAIRS = [
  { src: 'config/litellm_config.yaml', dest: 'config/litellm_config.example.yaml', optional: true },
];

function copyFile(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

if (!fs.existsSync(MODULE_ROOT)) {
  console.error(`FAIL: module folder missing: ${MODULE_ROOT}`);
  process.exit(1);
}

console.log('[msc:google-api:module:sync] refreshing portable module…\n');

let copied = 0;
let skipped = 0;

for (const name of SCRIPT_FILES) {
  const src = path.join(REPO_ROOT, 'scripts', name);
  const dest = path.join(MODULE_ROOT, 'scripts', name);
  if (!fs.existsSync(src)) {
    console.warn(`  SKIP missing: scripts/${name}`);
    skipped += 1;
    continue;
  }
  copyFile(src, dest);
  console.log(`  OK scripts/${name}`);
  copied += 1;
}

for (const name of LIB_FILES) {
  const src = path.join(REPO_ROOT, 'scripts', 'lib', name);
  const dest = path.join(MODULE_ROOT, 'scripts', 'lib', name);
  if (!fs.existsSync(src)) {
    console.warn(`  SKIP missing: scripts/lib/${name}`);
    skipped += 1;
    continue;
  }
  copyFile(src, dest);
  console.log(`  OK scripts/lib/${name}`);
  copied += 1;
}

for (const { src: relSrc, dest: relDest } of PREREQ_FILES) {
  const src = path.join(REPO_ROOT, relSrc);
  const dest = path.join(MODULE_ROOT, relDest);
  if (!fs.existsSync(src)) {
    console.warn(`  SKIP missing: ${relSrc}`);
    skipped += 1;
    continue;
  }
  copyFile(src, dest);
  console.log(`  OK ${relDest}`);
  copied += 1;
}

for (const { src: relSrc, dest: relDest, optional } of ASSET_PAIRS) {
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

console.log(`\nPASS: ${copied} file(s) synced → .cursor/custom-scriptz/google-api-proxy/`);
if (skipped) {
  console.log(`WARN: ${skipped} expected file(s) missing in repo`);
}
