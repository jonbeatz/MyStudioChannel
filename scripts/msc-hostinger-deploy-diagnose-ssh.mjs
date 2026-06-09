#!/usr/bin/env node
/**
 * Read-only Hostinger deploy staging diagnostics (disk, zip, BUILD_ID, package.json).
 * Usage: npm run msc:hostinger:deploy-diagnose
 */
import "./lib/msc-load-env.mjs";
import { Client } from "ssh2";
import process from "node:process";
import { requireHostingerSshEnv } from "./lib/msc-hostinger-ssh-preflight.mjs";

const BANNER = "[msc:hostinger:deploy-diagnose]";
const { host, port, username, password, appRoot } = requireHostingerSshEnv(BANNER);
const staging = appRoot.replace(/\/nodejs$/, "/public_html/nodejs");

const cmd = [
  "set -e",
  `STAGING='${staging}'`,
  `APP='${appRoot}'`,
  'echo "=== disk ==="',
  'df -h "$STAGING" | tail -1',
  'echo "=== zip on staging ==="',
  'ls -lh "$STAGING/deploy-next.zip" "$STAGING/zips/deploy-next.zip" 2>/dev/null || echo "(no deploy-next.zip)"',
  'echo "=== BUILD_ID ==="',
  'cat "$STAGING/.next/BUILD_ID" 2>/dev/null || echo "(no staging BUILD_ID)"',
  'cat "$APP/.next/BUILD_ID" 2>/dev/null || echo "(no app BUILD_ID)"',
  'echo "=== package.json version ==="',
  'grep -m1 \'"version"\' "$STAGING/package.json" 2>/dev/null || echo "(no staging package.json)"',
  'grep -m1 \'"version"\' "$APP/package.json" 2>/dev/null || echo "(no app package.json)"',
  'echo "=== unzip available ==="',
  'command -v unzip >/dev/null && unzip -v | head -1 || echo "unzip missing"',
  'if [ -f "$STAGING/deploy-next.zip" ]; then',
  '  echo "=== zip test (unzip -t) ==="',
  '  unzip -t "$STAGING/deploy-next.zip" 2>&1 | tail -6',
  '  echo "=== zip listing (head) ==="',
  '  unzip -l "$STAGING/deploy-next.zip" 2>/dev/null | head -8',
  '  echo "=== zip BUILD_ID paths ==="',
  '  unzip -l "$STAGING/deploy-next.zip" 2>/dev/null | grep BUILD_ID | head -3',
  'fi',
].join("\n");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} SSH connected`);
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
