#!/usr/bin/env node
/**
 * Smoke-test 21ST_DEV_MAGIC_API_KEY from .env.local against 21st.dev Magic API.
 * Usage: node scripts/test-21st-api.mjs
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

const env = parseEnv(ENV_LOCAL);
const apiKey = env['21ST_DEV_MAGIC_API_KEY'];

if (!apiKey) {
  console.error('FAIL: 21ST_DEV_MAGIC_API_KEY not found in .env.local');
  process.exit(1);
}

const mask = apiKey.length > 12 ? `${apiKey.slice(0, 6)}…${apiKey.slice(-4)}` : '***';

async function tryRequest(url, init) {
  const res = await fetch(url, init);
  const text = await res.text();
  return { status: res.status, text: text.slice(0, 200) };
}

console.log(`Testing 21st.dev Magic API key (${mask})…`);

const url = 'https://magic.21st.dev/api/fetch-ui';
const init = {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
  },
  body: JSON.stringify({ message: 'ping', searchQuery: 'button' }),
};

try {
  const { status, text } = await tryRequest(url, init);
  console.log(`  magic.21st.dev/api/fetch-ui: HTTP ${status}`);
  if (status === 401 || status === 403) {
    console.error('FAIL: API key rejected (invalid or expired)');
    process.exit(2);
  }
  if (status >= 200 && status < 300) {
    console.log('PASS: 21st.dev Magic API key authenticated');
    const snippet = text.replace(/\s+/g, ' ').slice(0, 100);
    if (snippet) console.log(`  Response preview: ${snippet}`);
    process.exit(0);
  }
  console.error(`FAIL: unexpected HTTP ${status}`);
  console.error(`  Body: ${text.replace(/\s+/g, ' ').slice(0, 150)}`);
  process.exit(2);
} catch (err) {
  console.error(`FAIL: ${err.message}`);
  process.exit(2);
}
