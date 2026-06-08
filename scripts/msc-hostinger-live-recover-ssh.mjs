#!/usr/bin/env node
/**
 * Diagnose 503 on live Hostinger Node app: logs, .builds preload, app root health.
 * Usage: node scripts/msc-hostinger-live-recover-ssh.mjs
 */
import "./lib/msc-load-env.mjs";
import { Client } from "ssh2";
import process from "node:process";

const BANNER = "[msc:hostinger:recover]";
const appRoot =
  process.env.HOSTINGER_APP_ROOT ||
  "/home/u942711528/domains/mystudiochannel.com/nodejs";
const pub = appRoot.replace(/\/nodejs$/, "/public_html/nodejs");
const buildsPreload =
  "/home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js";

const cmd = [
  "set -e",
  `APP='${appRoot}'`,
  `PUB='${pub}'`,
  `PRELOAD='${buildsPreload}'`,
  'echo "=== NODE PROCESSES ==="',
  "pgrep -af node 2>/dev/null || echo '(none)'",
  'echo "=== APP ROOT HEALTH ==="',
  'cd "$APP"',
  'pwd',
  'grep -m1 \'"version"\' package.json || true',
  'test -f .next/BUILD_ID && echo "BUILD_ID=$(cat .next/BUILD_ID)" || echo "MISSING .next/BUILD_ID"',
  'test -f server.js && echo "server.js OK" || echo "MISSING server.js"',
  'ls -la payload.sqlite stderr.log console.log 2>&1 | head -10',
  'echo "=== STDERR (last 40 lines) ==="',
  'tail -40 stderr.log 2>/dev/null || echo "(no stderr.log)"',
  'echo "=== CONSOLE (last 25 lines) ==="',
  'tail -25 console.log 2>/dev/null || echo "(no console.log)"',
  'echo "=== .builds PRELOAD ==="',
  'ls -la "$PRELOAD" 2>&1 || echo "MISSING preload"',
  'echo "=== PUB vs APP package version ==="',
  'grep -m1 \'"version"\' "$PUB/package.json" 2>/dev/null || true',
  'grep -m1 \'"version"\' "$APP/package.json" 2>/dev/null || true',
  'echo "=== LEGAL ROW ==="',
  'sqlite3 "$APP/payload.sqlite" "SELECT label, submenu_source, link FROM header_nav_items;" 2>&1 | head -8',
  'echo "=== FIX: preload + WAL + log trim ==="',
  'mkdir -p "$(dirname "$PRELOAD")"',
  'touch "$PRELOAD"',
  'chmod 644 "$PRELOAD"',
  'rm -f "$APP/payload.sqlite-wal" "$APP/payload.sqlite-shm"',
  ':> "$APP/stderr.log"',
  'ls -la "$PRELOAD"',
  'echo "=== webpack module ==="',
  'test -f "$APP/node_modules/next/dist/compiled/webpack/webpack.js" && echo OK || echo MISSING',
  'echo "=== DONE ==="',
].join("\n");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} SSH diagnose + preload fix…`);
  conn.exec(cmd, (err, stream) => {
    if (err) {
      console.error(`${BANNER} FAIL — ${err.message}`);
      process.exit(1);
    }
    stream.on("data", (d) => process.stdout.write(d));
    stream.stderr.on("data", (d) => process.stderr.write(d));
    stream.on("close", (code) => {
      conn.end();
      process.exit(code ?? 0);
    });
  });
});
conn.on("error", (e) => {
  console.error(`${BANNER} FAIL — ${e.message}`);
  process.exit(1);
});
conn.connect({
  host: process.env.HOSTINGER_SSH_HOST,
  port: parseInt(process.env.HOSTINGER_SSH_PORT || "65002", 10),
  username: process.env.HOSTINGER_SSH_USER,
  password: process.env.HOSTINGER_SSH_PASSWORD,
});
