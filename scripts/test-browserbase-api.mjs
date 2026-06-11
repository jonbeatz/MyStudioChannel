#!/usr/bin/env node
/**
 * Smoke-test Browserbase MCP credentials from .env.local.
 * Usage: node scripts/test-browserbase-api.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ENV_LOCAL = path.join(__dirname, '..', '.env.local');
const PROJECT_MCP = path.join(__dirname, '..', '.cursor', 'mcp.json');

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
  return value.length > 12 ? `${value.slice(0, 8)}…${value.slice(-4)}` : '***';
}

const env = parseEnv(ENV_LOCAL);
const apiKey = env.BROWSERBASE_API_KEY;
const projectId = env.BROWSERBASE_PROJECT_ID;

if (!apiKey) {
  console.error('FAIL: BROWSERBASE_API_KEY not found in .env.local');
  process.exit(1);
}
if (!projectId) {
  console.error('FAIL: BROWSERBASE_PROJECT_ID not found in .env.local');
  process.exit(1);
}

console.log('Testing Browserbase MCP credentials…');
console.log(`  API key:    ${mask(apiKey)}`);
console.log(`  Project ID: ${mask(projectId)}`);

const headers = {
  'x-bb-api-key': apiKey,
  'Content-Type': 'application/json',
};

const listRes = await fetch('https://api.browserbase.com/v1/sessions?limit=1', {
  headers: { 'x-bb-api-key': apiKey },
});
const listText = await listRes.text();
console.log(`  GET /v1/sessions: HTTP ${listRes.status}`);

if (listRes.status === 401 || listRes.status === 403) {
  console.error('FAIL: API key rejected');
  console.error(`  ${listText.replace(/\s+/g, ' ').slice(0, 200)}`);
  process.exit(2);
}
if (!listRes.ok) {
  console.error(`FAIL: unexpected list response HTTP ${listRes.status}`);
  process.exit(2);
}

const createRes = await fetch('https://api.browserbase.com/v1/sessions', {
  method: 'POST',
  headers,
  body: JSON.stringify({ projectId }),
});
const createText = await createRes.text();
console.log(`  POST /v1/sessions (projectId): HTTP ${createRes.status}`);

if (createRes.status === 401 || createRes.status === 403 || createRes.status === 404) {
  console.error('FAIL: project ID rejected or not found for this API key');
  console.error(`  ${createText.replace(/\s+/g, ' ').slice(0, 200)}`);
  process.exit(2);
}
if (!createRes.ok) {
  console.error(`FAIL: could not create test session (HTTP ${createRes.status})`);
  console.error(`  ${createText.replace(/\s+/g, ' ').slice(0, 200)}`);
  process.exit(2);
}

let sessionId;
try {
  sessionId = JSON.parse(createText).id;
} catch {
  console.error('FAIL: session create returned unexpected body');
  process.exit(2);
}

const releaseRes = await fetch(`https://api.browserbase.com/v1/sessions/${sessionId}`, {
  method: 'POST',
  headers,
  body: JSON.stringify({ status: 'REQUEST_RELEASE' }),
});
console.log(`  POST /v1/sessions/${sessionId} (release): HTTP ${releaseRes.status}`);

if (fs.existsSync(PROJECT_MCP)) {
  const mcp = JSON.parse(fs.readFileSync(PROJECT_MCP, 'utf8'));
  const bb = mcp.mcpServers?.browserbase?.env ?? {};
  const extra = ['GEMINI_API_KEY', 'GOOGLE_API_KEY'].filter((k) => k in bb);
  if (extra.length) {
    console.log(`WARN: .cursor/mcp.json still has optional keys: ${extra.join(', ')}`);
  } else {
    console.log('OK: .cursor/mcp.json has only BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID');
  }
}

console.log('PASS: Browserbase MCP credentials verified (API key + project ID)');
process.exit(0);
