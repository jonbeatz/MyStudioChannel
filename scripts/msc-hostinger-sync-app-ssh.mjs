#!/usr/bin/env node
/**
 * Mirror FTPS landing (public_html/nodejs) into the live Node app root.
 * Hostinger runs Node from domains/.../nodejs; FTPS /nodejs lands under public_html/nodejs.
 * Without this step, only the DB updates — code and .next stay stale (v5 footer, Legal -> /msc1).
 */
import "./lib/msc-load-env.mjs";

import { Client } from "ssh2";
import process from "node:process";

const BANNER = "[msc:hostinger:sync-app]";
const appRoot =
  process.env.HOSTINGER_APP_ROOT ||
  "/home/u942711528/domains/mystudiochannel.com/nodejs";
const ftpLanding = appRoot.replace(/\/nodejs$/, "/public_html/nodejs");

/** Paths that must match localhost after FTPS upload. node_modules stays on server. */
const SYNC_ITEMS = [
  ".next",
  "lib",
  "globals",
  "collections",
  "components",
  "app",
  "public",
  "middleware.ts",
  "payload.config.ts",
  "next.config.mjs",
  "server.js",
  "package.json",
  "package-lock.json",
  "instrumentation.ts",
  "instrumentation-client.ts",
];

const cmd = [
  "set -e",
  `PUB='${ftpLanding}'`,
  `APP='${appRoot}'`,
  `echo "FTP landing: $PUB"`,
  `echo "App root:      $APP"`,
  `test -d "$PUB" || { echo 'missing FTP landing dir'; exit 1; }`,
  `test -d "$APP" || { echo 'missing app root dir'; exit 1; }`,
  `for item in ${SYNC_ITEMS.join(" ")}; do`,
  `  if [ -e "$PUB/$item" ]; then`,
  `    echo "sync: $item"`,
  `    rm -rf "$APP/$item"`,
  `    cp -a "$PUB/$item" "$APP/$item"`,
  `  else`,
  `    echo "skip (not on FTP landing): $item"`,
  `  fi`,
  `done`,
  `cp -f "$PUB/payload.sqlite" "$APP/payload.sqlite"`,
  `rm -f "$APP/payload.sqlite-wal" "$APP/payload.sqlite-shm"`,
  `echo '=== verify ==='`,
  `grep -m1 '"version"' "$APP/package.json" || true`,
  `cat "$APP/.next/BUILD_ID" 2>/dev/null || echo 'no BUILD_ID'`,
  `sqlite3 "$APP/payload.sqlite" "SELECT label, submenu_source, link FROM header_nav_items WHERE label='Legal';"`,
  `wc -c < "$APP/payload.sqlite"`,
  `export PATH="/opt/alt/alt-nodejs22/root/usr/bin:/opt/alt/alt-nodejs20/root/usr/bin:$PATH"`,
  `echo '=== npm install (ignore-scripts — keeps better-sqlite3 binary) ==='`,
  `cd "$APP" && npm install --legacy-peer-deps --ignore-scripts 2>&1 | tail -5`,
  `test -f "$APP/node_modules/next/dist/compiled/webpack/webpack.js" && echo 'webpack OK' || echo 'webpack MISSING'`,
].join("\n");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} mirroring FTP landing -> live app root…`);
  conn.exec(cmd, (err, stream) => {
    if (err) {
      console.error(`${BANNER} FAIL — ${err.message}`);
      process.exit(1);
    }
    stream.on("data", (d) => process.stdout.write(d));
    stream.stderr.on("data", (d) => process.stderr.write(d));
    stream.on("close", (code) => {
      conn.end();
      process.exit(code === 0 ? 0 : 1);
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
