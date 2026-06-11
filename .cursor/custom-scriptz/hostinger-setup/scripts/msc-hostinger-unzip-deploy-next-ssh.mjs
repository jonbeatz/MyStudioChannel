#!/usr/bin/env node
/**
 * Unzip public_html/nodejs/deploy-next.zip into staging .next, verify BUILD_ID, remove zip.
 * Usage: npm run msc:hostinger:unzip-deploy-next
 */
import "./lib/msc-load-env.mjs";
import { Client } from "ssh2";
import process from "node:process";
import { requireHostingerSshEnv } from "./lib/msc-hostinger-ssh-preflight.mjs";

const BANNER = "[msc:hostinger:unzip-deploy-next]";
const ZIP_NAME = "deploy-next.zip";
const { host, port, username, password, appRoot } = requireHostingerSshEnv(BANNER);
const staging = appRoot.replace(/\/nodejs$/, "/public_html/nodejs");

const zipPrimary = `${staging}/${ZIP_NAME}`;
const zipLegacy = `${staging}/zips/${ZIP_NAME}`;

const cmd = [
  "set -e",
  `STAGING='${staging}'`,
  `ZIP_PRIMARY='${zipPrimary}'`,
  `ZIP_LEGACY='${zipLegacy}'`,
  'command -v unzip >/dev/null 2>&1 || { echo "missing unzip command on host"; exit 1; }',
  'ZIP="$ZIP_PRIMARY"',
  'if [ ! -f "$ZIP" ] && [ -f "$ZIP_LEGACY" ]; then ZIP="$ZIP_LEGACY"; fi',
  'test -f "$ZIP" || { echo "missing deploy-next.zip on staging (checked root and zips/)"; exit 1; }',
  'echo "unzip: $ZIP"',
  'cd "$STAGING"',
  'rm -rf .next',
  'unzip -oq "$ZIP"',
  'test -s .next/BUILD_ID || { echo "BUILD_ID missing or empty after unzip"; exit 1; }',
  'echo "BUILD_ID=$(cat .next/BUILD_ID)"',
  'rm -f "$ZIP_PRIMARY" "$ZIP_LEGACY"',
  'echo "removed deploy-next.zip from staging"',
  'ls -la .next/BUILD_ID',
].join("\n");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} unzip ${ZIP_NAME} on staging…`);
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
