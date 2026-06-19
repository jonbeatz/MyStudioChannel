#!/usr/bin/env node
/**
 * Refresh all portable custom-scriptz modules from live repo sources.
 * Usage: npm run msc:portable:sync
 */
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');

const SYNC_SCRIPTS = [
  'msc-hostinger-module-sync.mjs',
  'msc-hermes-module-sync.mjs',
  'msc-google-api-module-sync.mjs',
  'msc-backup-module-sync.mjs',
];

console.log('[msc:portable:sync] refreshing all portable modules…\n');

let failed = 0;

for (const script of SYNC_SCRIPTS) {
  const scriptPath = path.join(REPO_ROOT, 'scripts', script);
  console.log(`── ${script} ──`);
  const result = spawnSync(process.execPath, [scriptPath], {
    cwd: REPO_ROOT,
    stdio: 'inherit',
  });
  if (result.status !== 0) {
    failed += 1;
    console.error(`FAIL: ${script} exited ${result.status ?? 'unknown'}`);
  }
  console.log('');
}

if (failed) {
  console.error(`[msc:portable:sync] ${failed} module sync(s) failed.`);
  process.exit(1);
}

console.log('[msc:portable:sync] all modules synced.');
