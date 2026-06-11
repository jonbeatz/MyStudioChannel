#!/usr/bin/env node
/**
 * Refresh hostinger-setup portable module from repo scripts/ + rules + prompts.
 * Usage: npm run msc:hostinger:module:sync
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');
const MODULE_ROOT = path.join(REPO_ROOT, '.cursor', 'custom-scriptz', 'hostinger-setup');

const SCRIPT_FILES = [
  'PushItUP.ps1',
  'pushit-live.ps1',
  'pushit-live-fast.ps1',
  'pushit-live-safe.ps1',
  'push-website-live.ps1',
  'PushItUPzip.ps1',
  'Test-HostingerFtp.ps1',
  'print-hostinger-restart-reminder.ps1',
  'copy-db-for-deploy.ps1',
  'assert-payload-sqlite-deploy.ps1',
  'verify-live.ps1',
  'verify-live-version.ps1',
  'sync-sftp-from-env.ps1',
  'ftp-parity-check.ps1',
  'verify-ftp-smoke-remote.ps1',
  'msc-hostinger-unzip-deploy-next-ssh.mjs',
  'msc-hostinger-deploy-diagnose-ssh.mjs',
  'msc-hostinger-stop-node-ssh.mjs',
  'msc-hostinger-sync-db-ssh.mjs',
  'msc-hostinger-sync-app-ssh.mjs',
  'msc-hostinger-npm-install-ssh.mjs',
  'msc-hostinger-live-recover-ssh.mjs',
  'msc-hostinger-mcp.mjs',
  'msc-push-db-live.mjs',
];

const LIB_FILES = ['msc-load-env.mjs', 'msc-hostinger-ssh-preflight.mjs'];

const ASSET_PAIRS = [
  {
    src: '.cursor/rules/deploy-safety-hostinger.mdc',
    dest: 'rules/deploy-safety-hostinger.mdc',
  },
  {
    src: '.cursor/rules/jon-operator-hpanel.mdc',
    dest: 'rules/jon-operator-hpanel.mdc.fragment',
  },
  {
    src: '.cursor/prompts/Push-Website-Live.md',
    dest: 'prompts/Push-Website-Live.md',
  },
  {
    src: '.cursor/docs/HOSTINGER-MODULE.md',
    dest: 'docs/HOSTINGER-MODULE.md',
    optional: true,
  },
  {
    src: '.cursor/docs/PITFALLS-HOSTINGER.md',
    dest: 'docs/PITFALLS-HOSTINGER.md',
    optional: true,
  },
  {
    src: '.cursor/docs/NEW-PROJECT-CHECKLIST.md',
    dest: 'docs/NEW-PROJECT-CHECKLIST.md',
    optional: true,
  },
];

function copyFile(src, dest) {
  const parent = path.dirname(dest);
  fs.mkdirSync(parent, { recursive: true });
  fs.copyFileSync(src, dest);
}

let copied = 0;
let skipped = 0;

if (!fs.existsSync(MODULE_ROOT)) {
  console.error(`FAIL: module folder missing: ${MODULE_ROOT}`);
  process.exit(1);
}

console.log('[msc:hostinger:module:sync] refreshing portable module…\n');

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

for (const { src: relSrc, dest: relDest, optional } of ASSET_PAIRS) {
  const src = path.join(REPO_ROOT, relSrc);
  const dest = path.join(MODULE_ROOT, relDest);
  if (!fs.existsSync(src)) {
    if (optional) {
      console.log(`  — optional skip: ${relSrc}`);
    } else {
      console.warn(`  SKIP missing: ${relSrc}`);
      skipped += 1;
    }
    continue;
  }
  copyFile(src, dest);
  console.log(`  OK ${relDest}`);
  copied += 1;
}

console.log(`\nPASS: ${copied} file(s) synced → .cursor/custom-scriptz/hostinger-setup/`);
if (skipped) {
  console.log(`WARN: ${skipped} expected file(s) missing in repo`);
}
console.log('Next: commit module folder · on other projects run hostinger-setup/install.ps1');
