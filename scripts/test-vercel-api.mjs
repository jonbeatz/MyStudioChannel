#!/usr/bin/env node
/**
 * Smoke-test VERCEL_API_TOKEN / VERCEL_API_TOKEN_ALT from .env.local.
 * Usage: node scripts/test-vercel-api.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ENV_LOCAL = path.join(__dirname, '..', '.env.local');

function parseEnv(filePath) {
  const env = {};
  for (const line of fs.readFileSync(filePath, 'utf8').split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eq = trimmed.indexOf('=');
    if (eq === -1) continue;
    const key = trimmed.slice(0, eq).trim();
    let value = trimmed.slice(eq + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    env[key] = value;
  }
  return env;
}

function mask(value) {
  if (!value) return '(missing)';
  if (value.length <= 12) return '***';
  return `${value.slice(0, 6)}…${value.slice(-4)}`;
}

async function probe(label, token) {
  if (!token) {
    console.log(`\n${label}: SKIP — not set in .env.local`);
    return { label, ok: false, reason: 'missing' };
  }

  console.log(`\n${label} (${mask(token)}):`);

  const headers = { Authorization: `Bearer ${token}` };

  const userRes = await fetch('https://api.vercel.com/v2/user', { headers });
  const userText = await userRes.text();
  console.log(`  GET /v2/user: HTTP ${userRes.status}`);

  if (userRes.status === 401 || userRes.status === 403) {
    console.log('  → rejected (invalid or expired)');
    return { label, ok: false, reason: 'auth' };
  }

  let username = '';
  if (userRes.ok) {
    try {
      const user = JSON.parse(userText).user ?? JSON.parse(userText);
      username = user.username || user.email || user.name || '(unknown)';
      console.log(`  → user: ${username}`);
    } catch {
      console.log('  → user response OK');
    }
  }

  const projRes = await fetch('https://api.vercel.com/v9/projects?limit=5', { headers });
  console.log(`  GET /v9/projects: HTTP ${projRes.status}`);
  let projectCount = 0;
  if (projRes.ok) {
    try {
      const data = await projRes.json();
      projectCount = data.projects?.length ?? 0;
      const names = (data.projects ?? []).map((p) => p.name).slice(0, 3);
      console.log(`  → projects visible: ${projectCount}${names.length ? ` (${names.join(', ')})` : ''}`);
    } catch {
      console.log('  → projects list OK');
    }
  }

  const ok = userRes.ok || projRes.ok;
  return { label, ok, username, projectCount };
}

const env = parseEnv(ENV_LOCAL);
const results = [];

for (const [label, key] of [
  ['VERCEL_API_TOKEN', 'VERCEL_API_TOKEN'],
  ['VERCEL_API_TOKEN_ALT', 'VERCEL_API_TOKEN_ALT'],
]) {
  results.push(await probe(label, env[key]));
}

console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
const working = results.filter((r) => r.ok);
if (working.length === 0) {
  console.log('FAIL: No working Vercel token found');
  process.exit(2);
}
if (working.length === 1) {
  console.log(`PASS: Use ${working[0].label} as your single Vercel token`);
} else {
  console.log(`PASS: Both tokens work — prefer ${working[0].label} (primary naming)`);
}
process.exit(0);
