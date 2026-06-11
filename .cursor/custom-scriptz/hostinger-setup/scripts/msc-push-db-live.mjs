#!/usr/bin/env node
/**
 * Quick live DB sync (~1–2 min): SSH stop → FTPS payload.sqlite → SSH sync into app root.
 * Use when live APIs 500 but / and /admin work (stub payload.sqlite on server).
 */
import "./lib/msc-load-env.mjs";

import { spawnSync } from "node:child_process";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const BANNER = "[msc:push:db:live]";
const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..");
const hpanelUrl = "https://hpanel.hostinger.com/websites/mystudiochannel.com";

function run(label, cmd, args = [], opts = {}) {
  console.log(`\n${BANNER} ${label}…`);
  const r = spawnSync(cmd, args, {
    cwd: root,
    stdio: "inherit",
    shell: process.platform === "win32",
    ...opts,
  });
  if (r.status !== 0) {
    console.error(`${BANNER} FAIL at: ${label}`);
    process.exit(r.status ?? 1);
  }
}

run("preflight (payload.sqlite size)", "powershell", [
  "-ExecutionPolicy",
  "Bypass",
  "-File",
  "scripts/assert-payload-sqlite-deploy.ps1",
]);
run("safe DB copy", "powershell", [
  "-ExecutionPolicy",
  "Bypass",
  "-File",
  "scripts/copy-db-for-deploy.ps1",
  "-Quiet",
]);
run("SSH stop live Node", "npm", ["run", "msc:hostinger:stop-node"]);

const dbFile = path.join(root, "payload.sqlite");
const tempDb = path.join(root, "payload.sqlite.temp");
const backupDb = path.join(root, "payload.sqlite.live.bak");

console.log(`\n${BANNER} FTPS upload payload.sqlite…`);
try {
  if (process.platform === "win32") {
    run("upload", "powershell", [
      "-ExecutionPolicy",
      "Bypass",
      "-Command",
      [
        `$bak='${backupDb.replace(/'/g, "''")}'`,
        `$db='${dbFile.replace(/'/g, "''")}'`,
        `$temp='${tempDb.replace(/'/g, "''")}'`,
        "if (Test-Path $bak) { Remove-Item $bak -Force }",
        "Move-Item $db $bak -Force",
        "Move-Item $temp $db -Force",
        "npm run pushitup -- payload.sqlite",
        "exit $LASTEXITCODE",
      ].join("; "),
    ]);
  }
} finally {
  if (process.platform === "win32") {
    spawnSync(
      "powershell",
      [
        "-ExecutionPolicy",
        "Bypass",
        "-Command",
        [
          `$bak='${backupDb.replace(/'/g, "''")}'`,
          `$db='${dbFile.replace(/'/g, "''")}'`,
          `$temp='${tempDb.replace(/'/g, "''")}'`,
          "if (Test-Path $bak) { Move-Item $bak $db -Force }",
          "if (Test-Path $temp) { Remove-Item $temp -Force }",
        ].join("; "),
      ],
      { cwd: root, stdio: "inherit", shell: true },
    );
  }
}

run("SSH sync DB into app root", "npm", ["run", "msc:hostinger:sync-db"]);
run("SSH sync app into app root", "npm", ["run", "msc:hostinger:sync-app"]);

console.log("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
console.log("✅ DB-only live sync complete (~1–2 min path)");
console.log("🔄 Live (hPanel): Restart Node.js app, wait 30s");
console.log(`   ${hpanelUrl}`);
console.log("🧪 Local: npm run msc:verify:live");
console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
