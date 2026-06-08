#!/usr/bin/env node
/**
 * One-shot bulk update: docs/rules reference msc:* npm scripts (Phase 3 audit).
 * Preserves valid short aliases (backup, deploy, doctor, sync, pushit:live, etc.).
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const pkg = JSON.parse(fs.readFileSync(path.join(ROOT, 'package.json'), 'utf8'));
const validScripts = new Set(Object.keys(pkg.scripts));

/** Short names that intentionally remain (no msc: prefix in docs). */
const KEEP_SHORT = new Set([
  'backup',
  'backup:quick',
  'backup:project',
  'backup:clean-zips',
  'deploy',
  'deploy:full',
  'doctor',
  'docs',
  'sync',
  'log:session',
  'log:fix',
  'log:milestone',
  'pushitup',
  'pushit:live',
  'pushit:live:fast',
  'push:website:live',
  'dev',
  'dev:fresh',
  'dev:recover',
  'dev:payload',
  'dev:launcher',
  'dev:quick',
  'dev:reset',
  'build',
  'start',
  'lint',
  'lint:fix',
  'verify:next',
  'verify:next:safe',
  'clean:next',
  'repair:dev',
  'restart:dev',
  'setup:dev',
  'seed:production',
  'seed:all',
  'msc:codeburn',
]);

/** Explicit renames (old short → canonical msc name). */
const RENAME = {
  'backup:clean': 'msc:backup:clean',
  'backup:github-repos': 'msc:backup:github-repos',
  'db:copy': 'msc:db:copy',
  'db:copy:force': 'msc:db:copy:force',
  'db:maintain': 'msc:db:maintain',
  'db:optimize': 'msc:db:optimize',
  'deploy:zip': 'msc:deploy:zip',
  'docs:audit': 'msc:docs:audit',
  'docs:sync': 'msc:docs:sync',
  'fix:hero-slide-images': 'msc:fix:hero-slide-images',
  'generate:types': 'msc:generate:types',
  'gh-test': 'msc:test:github-api',
  'dmd': 'msc:docs:audit',
  'kill-dev-port': 'msc:kill-dev-port',
  'kill-port': 'msc:kill-dev-port',
  'logs:live': 'msc:logs:live',
  'logs:live:console': 'msc:logs:live:console',
  'media:consolidate': 'msc:media:consolidate',
  'media:sync': 'msc:media:sync',
  'migrate:media:from-public-images': 'msc:migrate:media:from-public-images',
  'parity:ftp': 'msc:parity:ftp',
  'pushit:live:safe': 'msc:pushit:live:safe',
  PushItUP: 'msc:pushitup',
  'pushitup:admin-branding': 'msc:pushitup:admin-branding',
  'pushitup:admin-ui': 'msc:pushitup:admin-ui',
  'pushitup:ftp-smoke': 'msc:pushitup:ftp-smoke',
  'pushitup:server-config': 'msc:pushitup:server-config',
  pushitupzip: 'msc:pushitupzip',
  PushItUPzip: 'msc:pushitupzip',
  'seed:demo-page': 'msc:seed:demo-page',
  'sync:github-mcp': 'msc:sync:github-mcp',
  'sync:mcp-all': 'msc:sync:mcp-all',
  'sync:mcp-env': 'msc:sync:mcp-env',
  'sync:sftp-env': 'msc:sync:sftp-env',
  'test:github-api': 'msc:test:github-api',
  'test:hostinger-ftp': 'msc:test:hostinger-ftp',
  'test:tavily-api': 'msc:test:tavily-api',
  'verify:ftp-smoke': 'msc:verify:ftp-smoke',
  'verify:live': 'msc:verify:live',
  'verify:live:version': 'msc:verify:live:version',
  'verify:local': 'msc:verify:local',
};

const DOC_ROOTS = [
  '.cursor/docs',
  '.cursor/rules',
  '.cursor/prompts',
  '.cursor/skills',
  '.cursor/mcp.json',
  'AGENTS.md',
  'TRUTH.md',
  'README.md',
  'CHANGELOG.md',
  'CONTRIBUTING.md',
];

const FILE_REPLACEMENTS = [
  ['scripts/kill-dev-port.mjs', 'scripts/msc-kill-dev-port.mjs'],
  ['node scripts/kill-dev-port.mjs', 'node scripts/msc-kill-dev-port.mjs'],
  // Avoid double-prefix: skip if already msc:sync:mcp-env (handled via RENAME)
  [
    'D:\\Cursor_Projectz\\MyStudioChannel-deploy.zip',
    'zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip',
  ],
  [
    'D:/Cursor_Projectz/MyStudioChannel-deploy.zip',
    'zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip',
  ],
  ['npm run push:website:live` (MCP code-only)', 'npm run push:website:live` (MCP — avoid on this host)'],
  [
    '`npm run deploy` → `npm run push:website:live`',
    '`npm run deploy` → `npm run pushit:live:fast` (FTPS fast; MCP via `push:website:live`)',
  ],
  [
    '| `npm run deploy` | `npm run push:website:live` | Deploy code only |',
    '| `npm run deploy` | `npm run pushit:live:fast` | Fast FTPS code deploy |',
  ],
];

function transformContent(text, filePath) {
  let out = text;

  for (const [from, to] of FILE_REPLACEMENTS) {
    out = out.split(from).join(to);
  }

  // migrate:sqlite:* → msc:migrate:sqlite:*
  out = out.replace(/npm run migrate:sqlite:([a-z0-9-]+)/g, 'npm run msc:migrate:sqlite:$1');
  out = out.replace(/\*\*`migrate:sqlite:([^`]+)`\*\*/g, '**`msc:migrate:sqlite:$1`**');
  out = out.replace(/`migrate:sqlite:([^`]+)`/g, (m, slug) => {
    if (m.includes('msc:migrate:sqlite:')) return m;
    return `\`msc:migrate:sqlite:${slug}\``;
  });

  out = out.replace(/npm run ([a-zA-Z0-9:_-]+)/g, (full, cmd) => {
    if (cmd.startsWith('msc:')) return full;
    if (KEEP_SHORT.has(cmd)) return full;
    if (validScripts.has(cmd)) return full;
    if (RENAME[cmd]) return `npm run ${RENAME[cmd]}`;
    if (!cmd.includes(':') && RENAME[cmd]) return `npm run ${RENAME[cmd]}`;
    return full;
  });

  // Backtick-only command refs (no npm run prefix)
  for (const [oldName, newName] of Object.entries(RENAME)) {
    if (KEEP_SHORT.has(oldName)) continue;
    const escaped = oldName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    out = out.replace(new RegExp(`\`${escaped}\``, 'g'), `\`${newName}\``);
  }

  return out;
}

let changed = 0;
function walk(dir) {
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    if (ent.name.startsWith('_') && ent.name !== '_template') continue;
    const p = path.join(dir, ent.name);
    if (ent.isDirectory()) walk(p);
    else if (/\.(md|mdc|json)$/i.test(ent.name)) processFile(p);
  }
}

function processFile(filePath) {
  const rel = path.relative(ROOT, filePath).replace(/\\/g, '/');
  const before = fs.readFileSync(filePath, 'utf8');
  const after = transformContent(before, rel);
  if (after !== before) {
    fs.writeFileSync(filePath, after, 'utf8');
    console.log(`updated: ${rel}`);
    changed++;
  }
}

for (const r of DOC_ROOTS) {
  const full = path.join(ROOT, r);
  if (!fs.existsSync(full)) continue;
  if (fs.statSync(full).isDirectory()) walk(full);
  else processFile(full);
}

console.log(`\n[msc:sync:doc-commands] ${changed} file(s) updated.`);
