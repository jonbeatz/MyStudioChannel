#!/usr/bin/env node
/**
 * Refresh hermes-system portable module from repo scripts/ + docs.
 * Usage: npm run msc:hermes:module:sync
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');
const MODULE_ROOT = path.join(REPO_ROOT, '.cursor', 'custom-scriptz', 'hermes-system');

const SCRIPT_FILES = [
  'payload-types-sync.ps1',
  'vram-idle-manager.ps1',
  'msc-build-and-dev.ps1',
  'generate-image.py',
  'mem0_integration.py',
  'mem0-chat.ps1',
  'start-hermes-api.ps1',
  'generate-payload-types.mjs',
  'setup-hermes.ps1',
  'profile-functions.template.ps1',
  'config.yaml.template',
  'version-bump.ps1',
  'github-release.ps1',
  'docs-update.ps1',
  'start-kanban-stack.ps1',
  'stop-kanban-stack.ps1',
  'start-session-stack.ps1',
  'stop-session-stack.ps1',
];

const ASSET_PAIRS = [
  { src: '.cursor/docs/KANBAN-STACK-GUIDE.md', dest: 'KANBAN-STACK-GUIDE.md' },
  { src: '.cursor/docs/Hermes-Cheat-Sheet.md', dest: 'Hermes-Cheat-Sheet.md' },
  { src: '.cursor/docs/LMSTUDIO-OPTIMAL-CONFIG.md', dest: 'LMSTUDIO-OPTIMAL-CONFIG.md', optional: true },
  { src: '.cursor/docs/VRAM-TROUBLESHOOTING.md', dest: 'VRAM-TROUBLESHOOTING.md', optional: true },
  { src: '.cursor/docs/HARDWARE-SPEC.md', dest: 'HARDWARE-SPEC.md', optional: true },
  { src: '.cursor/prompts/Start-Project.md', dest: 'prompts/Start-Project.md.fragment', optional: true },
  { src: '.cursor/prompts/End-Project.md', dest: 'prompts/End-Project.md.fragment', optional: true },
];

function copyFile(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

if (!fs.existsSync(MODULE_ROOT)) {
  console.error(`FAIL: module folder missing: ${MODULE_ROOT}`);
  process.exit(1);
}

console.log('[msc:hermes:module:sync] refreshing portable module…\n');

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

console.log(`\nPASS: ${copied} file(s) synced → .cursor/custom-scriptz/hermes-system/`);
if (skipped) {
  console.log(`WARN: ${skipped} expected file(s) missing in repo`);
}
