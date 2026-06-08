#!/usr/bin/env node
/**
 * Run npm install --legacy-peer-deps on live Hostinger app root via SSH.
 * Fixes MODULE_NOT_FOUND (e.g. next/dist/compiled/webpack) after package-lock sync.
 */
import "./lib/msc-load-env.mjs";
import { Client } from "ssh2";
import process from "node:process";
import { requireHostingerSshEnv } from "./lib/msc-hostinger-ssh-preflight.mjs";

const BANNER = "[msc:hostinger:npm-install]";
const { host, port, username, password, appRoot } = requireHostingerSshEnv(BANNER);

const cmd = [
  "set -e",
  `APP='${appRoot}'`,
  'echo "=== stop node ==="',
  "pkill -u $(whoami) node 2>/dev/null || true",
  "sleep 2",
  'echo "=== locate node/npm ==="',
  'export PATH="/opt/alt/alt-nodejs22/root/usr/bin:/opt/alt/alt-nodejs20/root/usr/bin:$PATH"',
  "which node || true",
  "node -v || true",
  "which npm || true",
  'cd "$APP"',
  'echo "=== webpack before ==="',
  'test -f node_modules/next/dist/compiled/webpack/webpack.js && echo OK || echo MISSING',
  'echo "=== npm install --legacy-peer-deps (may take 2-5 min) ==="',
  "npm install --legacy-peer-deps --ignore-scripts 2>&1",
  'echo "=== webpack after ==="',
  'test -f node_modules/next/dist/compiled/webpack/webpack.js && echo OK || echo STILL_MISSING',
  'rm -f payload.sqlite-wal payload.sqlite-shm',
  'grep -m1 \'"version"\' package.json || true',
  'echo "=== DONE — restart Node in hPanel ==="',
].join("\n");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} SSH npm install on live app root…`);
  conn.exec(cmd, (err, stream) => {
    if (err) {
      console.error(`${BANNER} FAIL — ${err.message}`);
      process.exit(1);
    }
    stream.on("data", (d) => process.stdout.write(d));
    stream.stderr.on("data", (d) => process.stderr.write(d));
    stream.on("close", (code) => {
      conn.end();
      process.exit(code === 0 ? 0 : code || 1);
    });
  });
});
conn.on("error", (e) => {
  console.error(`${BANNER} FAIL — ${e.message}`);
  process.exit(1);
});
conn.connect({ host, port, username, password });
