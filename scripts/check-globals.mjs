/**
 * Inspect local payload.sqlite — Payload globals, projects-home, file size.
 * Usage: node scripts/check-globals.mjs
 */
import fs from "fs"
import path from "path"
import { fileURLToPath } from "url"
import { DatabaseSync } from "node:sqlite"

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const repoRoot = path.join(__dirname, "..")
const dbPath = path.join(repoRoot, "payload.sqlite")

/** Payload global slug -> SQLite table name (underscore). */
const GLOBAL_SLUGS = [
  { slug: "homepage", table: "homepage" },
  { slug: "projects-home", table: "projects_home" },
  { slug: "site-settings", table: "site_settings" },
  { slug: "header", table: "header" },
]

function formatBytes(bytes) {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(2)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(2)} MB`
}

function tableExists(db, name) {
  const row = db
    .prepare(`SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?`)
    .get(name)
  return Boolean(row)
}

if (!fs.existsSync(dbPath)) {
  console.error(`ABORT: missing ${dbPath}`)
  process.exit(1)
}

const stat = fs.statSync(dbPath)
const walPath = `${dbPath}-wal`
const shmPath = `${dbPath}-shm`
const walBytes = fs.existsSync(walPath) ? fs.statSync(walPath).size : 0
const shmBytes = fs.existsSync(shmPath) ? fs.statSync(shmPath).size : 0

console.log("")
console.log("check-globals — local payload.sqlite")
console.log("=".repeat(50))
console.log(`Path: ${dbPath}`)
console.log(`Size: ${formatBytes(stat.size)} (${stat.size} bytes)`)
if (walBytes || shmBytes) {
  console.log(
    `Sidecars: WAL ${formatBytes(walBytes)}${shmBytes ? `, SHM ${formatBytes(shmBytes)}` : ""} — stop \`npm run dev\` before uploading DB to live`,
  )
}
console.log("")

const db = new DatabaseSync(dbPath, { readOnly: true })

const allTables = db
  .prepare(
    `SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name`,
  )
  .all()
  .map((r) => r.name)

console.log("1) Globals (Payload slugs / tables)")
let missingAny = false
for (const { slug, table } of GLOBAL_SLUGS) {
  const exists = tableExists(db, table)
  if (!exists) missingAny = true
  console.log(`   - ${slug}  →  table \`${table}\`  ${exists ? "OK" : "MISSING"}`)
}

/** Legacy unified `globals` table (some migrations). */
if (tableExists(db, "globals")) {
  const slugs = db.prepare(`SELECT slug FROM globals ORDER BY slug`).all()
  console.log("")
  console.log("   (also found legacy `globals` table:)")
  slugs.forEach((r) => console.log(`     - ${r.slug}`))
}

console.log("")
console.log("2) projects-home")
const hasProjectsHome = tableExists(db, "projects_home")
if (hasProjectsHome) {
  const meta = db.prepare(`SELECT id FROM projects_home LIMIT 1`).get()
  let itemCount = 0
  if (tableExists(db, "projects_home_project_items")) {
    itemCount = db.prepare(`SELECT COUNT(*) AS c FROM projects_home_project_items`).get()?.c ?? 0
  }
  console.log(`   YES — \`projects_home\` table exists (global id: ${meta?.id ?? "?"})`)
  console.log(`   projectItems rows: ${itemCount}`)
} else {
  console.log("   NO — \`projects_home\` table missing")
  missingAny = true
}

console.log("")
console.log("3) Database size summary")
console.log(`   payload.sqlite: ${formatBytes(stat.size)}`)
console.log(`   Total tables: ${allTables.length}`)
console.log("")

db.close()
process.exit(missingAny ? 1 : 0)
