#!/usr/bin/env node
/**
 * Copy payload.sqlite from FTPS landing zone (public_html/nodejs) to live app root.
 * Hostinger FTPS chroot often lands /nodejs/* under public_html/nodejs while Node runs from domains/.../nodejs.
 */
import "./lib/msc-load-env.mjs";

import { Client } from "ssh2";
import process from "node:process";

const BANNER = "[msc:hostinger:sync-db]";
const appRoot =
  process.env.HOSTINGER_APP_ROOT ||
  "/home/u942711528/domains/mystudiochannel.com/nodejs";
const ftpLanding = appRoot.replace(/\/nodejs$/, "/public_html/nodejs");

const cmd = [
  `set -e`,
  `echo 'FTP landing: ${ftpLanding}/payload.sqlite'`,
  `ls -la ${ftpLanding}/payload.sqlite 2>/dev/null || { echo 'missing FTP landing DB'; exit 1; }`,
  `cp -f ${ftpLanding}/payload.sqlite ${appRoot}/payload.sqlite`,
  `rm -f ${appRoot}/payload.sqlite-wal ${appRoot}/payload.sqlite-shm`,
  `echo 'App root DB:'`,
  `ls -la ${appRoot}/payload.sqlite`,
  `wc -c < ${appRoot}/payload.sqlite`,
].join(" && ");

const conn = new Client();
conn.on("ready", () => {
  console.log(`${BANNER} syncing DB into live app root…`);
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
