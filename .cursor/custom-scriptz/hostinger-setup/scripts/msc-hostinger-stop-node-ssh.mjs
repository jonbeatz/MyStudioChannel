#!/usr/bin/env node
/**
 * Stop live Node.js processes on Hostinger via SSH (Option B — no hPanel Stop button).
 * Usage: npm run msc:hostinger:stop-node
 */
import "./lib/msc-load-env.mjs";

import { Client } from "ssh2";
import process from "node:process";
import { requireHostingerSshEnv } from "./lib/msc-hostinger-ssh-preflight.mjs";

const BANNER = "[msc:hostinger:stop-node]";
const { host, port, username, password, appRoot } = requireHostingerSshEnv(BANNER);

const cmd = [
  `cd ${appRoot}`,
  "echo '=== before ==='",
  "pgrep -af node 2>/dev/null || true",
  "pkill -u $(whoami) node 2>/dev/null || true",
  "sleep 2",
  "echo '=== after ==='",
  "pgrep -af node 2>/dev/null || echo '(no node processes)'",
  "rm -f payload.sqlite-wal payload.sqlite-shm",
  "ls -la payload.sqlite payload.sqlite-wal payload.sqlite-shm payload.sqlite.bak-* 2>/dev/null || true",
  "wc -c < payload.sqlite 2>/dev/null || true",
].join(" && ");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} SSH connected — stopping Node on live host…`);
  conn.exec(cmd, (err, stream) => {
    if (err) {
      console.error(`${BANNER} FAIL — ${err.message}`);
      process.exit(1);
    }
    stream.on("data", (d) => process.stdout.write(d));
    stream.stderr.on("data", (d) => process.stderr.write(d));
    stream.on("close", (code) => {
      conn.end();
      if (code === 0) {
        console.log(`${BANNER} PASS — live Node stopped, WAL/SHM cleared`);
      } else {
        console.error(`${BANNER} WARN — remote exit ${code}`);
      }
      process.exit(code === 0 ? 0 : 1);
    });
  });
});
conn.on("error", (e) => {
  console.error(`${BANNER} FAIL — ${e.message}`);
  process.exit(1);
});
conn.connect({ host, port, username, password });
