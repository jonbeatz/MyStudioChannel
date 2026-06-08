#!/usr/bin/env node
/**
 * Mirror FTPS landing (public_html/nodejs) into the live Node app root.
 * Hostinger runs Node from domains/.../nodejs; FTPS /nodejs lands under public_html/nodejs.
 * Without this step, only the DB updates — code and .next stay stale (v5 footer, Legal -> /msc1).
 *
 * Flags:
 *   --skip-db   Code-only sync — do not copy payload.sqlite (use for pushit:live:fast default).
 */
import "./lib/msc-load-env.mjs";

import { Client } from "ssh2";
import process from "node:process";
import { requireHostingerSshEnv } from "./lib/msc-hostinger-ssh-preflight.mjs";

const BANNER = "[msc:hostinger:sync-app]";
const skipDb =
  process.argv.includes("--skip-db") ||
  process.env.MSC_HOSTINGER_SYNC_SKIP_DB === "1" ||
  process.env.MSC_HOSTINGER_SYNC_SKIP_DB === "true";

const { host, port, username, password, appRoot } = requireHostingerSshEnv(BANNER);
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

const dbLines = skipDb
  ? [
      `echo 'skip-db: leaving live payload.sqlite unchanged'`,
    ]
  : [
      `test -f "$PUB/payload.sqlite" || { echo 'missing staging payload.sqlite'; exit 1; }`,
      `cp -f "$PUB/payload.sqlite" "$APP/payload.sqlite"`,
      `rm -f "$APP/payload.sqlite-wal" "$APP/payload.sqlite-shm"`,
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
  ...dbLines,
  `echo '=== verify ==='`,
  `grep -m1 '"version"' "$APP/package.json" || true`,
  `cat "$APP/.next/BUILD_ID" 2>/dev/null || echo 'no BUILD_ID'`,
  skipDb
    ? `echo 'skip-db: skipped sqlite verify'`
    : `sqlite3 "$APP/payload.sqlite" "SELECT label, submenu_source, link FROM header_nav_items WHERE label='Legal';"`,
  skipDb
    ? `test -f "$APP/payload.sqlite" && wc -c < "$APP/payload.sqlite" || echo 'live db unchanged'`
    : `wc -c < "$APP/payload.sqlite"`,
  `export PATH="/opt/alt/alt-nodejs22/root/usr/bin:/opt/alt/alt-nodejs20/root/usr/bin:$PATH"`,
  `echo '=== npm install (ignore-scripts — keeps better-sqlite3 binary) ==='`,
  `cd "$APP" && npm install --legacy-peer-deps --ignore-scripts 2>&1 | tail -5`,
  `test -f "$APP/node_modules/next/dist/compiled/webpack/webpack.js" || { echo 'webpack MISSING'; exit 1; }`,
  `echo 'webpack OK'`,
].join("\n");

if (skipDb) {
  console.log(`${BANNER} mode: code-only (--skip-db, live DB untouched)`);
}

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
      process.exit(code === 0 ? 0 : code || 1);
    });
  });
});
conn.on("error", (e) => {
  console.error(`${BANNER} FAIL — ${e.message}`);
  process.exit(1);
});
conn.connect({ host, port, username, password });
