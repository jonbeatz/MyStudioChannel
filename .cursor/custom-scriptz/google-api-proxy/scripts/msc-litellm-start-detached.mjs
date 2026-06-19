#!/usr/bin/env node
/**
 * Start LiteLLM (+ optional ngrok) detached in the background for session rituals.
 * Exits once local /v1/models responds — does NOT block on foreground logs.
 *
 * Logs: logs/litellm-proxy.log
 */
import './lib/msc-load-env.mjs';

import { spawn, spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import {
  msc_hydrateVertexEnv,
  msc_litellmConfigPath,
  msc_probeLitellmModels,
  msc_syncLitellmMasterKey,
  msc_waitForLitellmReady,
} from './lib/msc-litellm-env.mjs';
import {
  msc_fetchNgrokHttpsUrl,
  msc_ngrokAvailable,
  msc_printCursorNgrokSettings,
  msc_resolveNgrokBin,
} from './lib/msc-ngrok-utils.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const scriptsDir = path.resolve(__dirname);
const REPO_ROOT = path.resolve(scriptsDir, '..');
const BANNER = '[msc:litellm:start-detached]';
const LOG_DIR = path.join(REPO_ROOT, 'logs');
const LOG_FILE = path.join(LOG_DIR, 'litellm-proxy.log');

const args = new Set(process.argv.slice(2));
const withNgrok =
  !args.has('--local-only') &&
  (args.has('--ngrok') ||
    process.env.MSC_LITELLM_START_NGROK === '1' ||
    process.env.MSC_LITELLM_START_NGROK === 'true' ||
    process.env.MSC_GOOGLE_API_START_NGROK !== '0');

function ensureLogDir() {
  if (!fs.existsSync(LOG_DIR)) {
    fs.mkdirSync(LOG_DIR, { recursive: true });
  }
}

function appendLog(line) {
  ensureLogDir();
  const stamp = new Date().toISOString();
  fs.appendFileSync(LOG_FILE, `[${stamp}] ${line}\n`, 'utf8');
}

function runStop() {
  console.log(`${BANNER} clean stop before detached start…`);
  const stop = spawnSync(process.execPath, [path.join(scriptsDir, 'msc-litellm-stop.mjs')], {
    stdio: 'inherit',
  });
  if (stop.status !== 0) {
    process.exit(stop.status ?? 1);
  }
}

function runPreflight() {
  const pre = spawnSync(process.execPath, [path.join(scriptsDir, 'msc-litellm-preflight.mjs')], {
    stdio: 'inherit',
  });
  if (pre.status !== 0) {
    process.exit(pre.status ?? 1);
  }
}

function resolveExecutable(command) {
  if (path.isAbsolute(command) && fs.existsSync(command)) {
    return command;
  }
  const fromRoot = path.resolve(REPO_ROOT, command);
  if (fs.existsSync(fromRoot)) {
    return fromRoot;
  }
  return command;
}

function spawnDetached(command, cmdArgs, { label, useShell = false }) {
  ensureLogDir();
  const resolved = resolveExecutable(command);
  appendLog(`spawn ${label}: ${resolved} ${cmdArgs.join(' ')}`);

  const logStream = fs.openSync(LOG_FILE, 'a');
  const child = spawn(resolved, cmdArgs, {
    cwd: REPO_ROOT,
    env: childEnv,
    detached: true,
    stdio: ['ignore', logStream, logStream],
    shell: useShell && process.platform === 'win32',
    windowsHide: true,
  });
  child.unref();
  return child;
}

runStop();
runPreflight();

const { port } = msc_hydrateVertexEnv();
const configPath = msc_litellmConfigPath();
msc_syncLitellmMasterKey();

spawnSync(process.execPath, [path.join(scriptsDir, 'msc-kill-dev-port.mjs'), String(port)], {
  stdio: 'inherit',
});

const childEnv = {
  ...process.env,
  PYTHONUTF8: '1',
  PYTHONIOENCODING: 'utf-8',
};
if (
  childEnv.MSC_LITELLM_MASTER_KEY?.trim() === 'your_litellm_master_key_local_only' ||
  childEnv.MSC_LITELLM_MASTER_KEY?.startsWith('your_')
) {
  delete childEnv.MSC_LITELLM_MASTER_KEY;
}

console.log(`${BANNER} starting LiteLLM detached on port ${port}…`);
console.log(`${BANNER} log file: ${LOG_FILE}`);

spawnDetached('litellm', ['--config', configPath, '--port', String(port)], {
  label: 'litellm',
  useShell: true,
});

console.log(`${BANNER} waiting for LiteLLM /v1/models (up to 90s)…`);
const ready = await msc_waitForLitellmReady(port, { timeoutMs: 90000 });
if (!ready.ok) {
  console.error(`${BANNER} FAIL — LiteLLM did not respond on port ${port} within 90s`);
  console.error(`${BANNER}       See ${LOG_FILE}`);
  process.exit(1);
}

const localV1 = `http://127.0.0.1:${port}/v1`;
const localProbe = await msc_probeLitellmModels(localV1);
if (!localProbe.ok) {
  console.error(`${BANNER} FAIL — local ${localV1}/models HTTP ${localProbe.status || 'unreachable'}`);
  process.exit(1);
}

console.log(
  `${BANNER} OK — LiteLLM online (${localProbe.modelIds.join(', ') || 'no models'})`,
);

let ngrokOk = false;
if (withNgrok) {
  if (!msc_ngrokAvailable()) {
    console.warn(`${BANNER} WARN — ngrok not found; local proxy only on port ${port}`);
  } else {
    spawnSync(process.execPath, [path.join(scriptsDir, 'msc-kill-dev-port.mjs'), '4040'], {
      stdio: 'inherit',
    });

    const ngrokBin = resolveExecutable(msc_resolveNgrokBin());
    console.log(`${BANNER} starting ngrok detached → port ${port} (${ngrokBin})…`);
    spawnDetached(ngrokBin, ['http', String(port)], { label: 'ngrok', useShell: false });

    const publicUrl = await msc_fetchNgrokHttpsUrl(45000);
    if (!publicUrl) {
      console.warn(`${BANNER} WARN — ngrok did not expose HTTPS URL within 45s`);
      console.warn(`${BANNER}       Local proxy still works at ${localV1}`);
    } else {
      process.env.MSC_LITELLM_BASE_URL = publicUrl;
      msc_printCursorNgrokSettings(publicUrl);

      const remoteV1 = `${publicUrl.replace(/\/$/, '')}/v1`;
      const remoteProbe = await msc_probeLitellmModels(remoteV1, { ngrok: true });
      if (remoteProbe.ok) {
        ngrokOk = true;
        console.log(`${BANNER} OK — ngrok tunnel verified (${remoteProbe.modelIds.join(', ')})`);
      } else {
        console.warn(
          `${BANNER} WARN — ngrok ${remoteV1}/models HTTP ${remoteProbe.status || 'unreachable'}`,
        );
        console.warn(`${BANNER}       Local proxy still works; retry: npm run msc:litellm:stop && npm run msc:google-api:start`);
      }
    }
  }
} else {
  console.log(`${BANNER} local-only mode — ${localV1}`);
}

console.log(`${BANNER} READY — proxy running in background (port ${port}${ngrokOk ? ', ngrok verified' : ''})`);
process.exit(0);
