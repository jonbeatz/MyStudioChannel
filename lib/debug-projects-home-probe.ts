import fs from "fs"
import path from "path"
import { DatabaseSync } from "node:sqlite"
import { getPayload } from "payload"
import config from "@payload-config"

export const DEBUG_PROJECTS_HOME_LOG = "debug-projects-home.log"

export type DebugProbeResult = {
  ok: boolean
  logPath: string
  steps: Array<{ step: string; ok: boolean; detail?: string }>
  errorMessage?: string
  errorStack?: string
}

function appendLog(logPath: string, line: string) {
  const stamp = new Date().toISOString()
  fs.appendFileSync(logPath, `[${stamp}] ${line}\n`, "utf8")
}

function envPresence() {
  const keys = [
    "NODE_ENV",
    "DATABASE_URL",
    "PAYLOAD_SECRET",
    "NEXT_PUBLIC_SERVER_URL",
    "PAYLOAD_PUBLIC_SERVER_URL",
    "PAYLOAD_DISABLE_SHARP",
    "RESEND_API_KEY",
  ] as const
  return keys.map((key) => {
    const raw = process.env[key]
    const set = raw != null && String(raw).trim().length > 0
    let note = set ? "set" : "MISSING"
    if (key === "PAYLOAD_SECRET" && set) {
      note = `set (length ${String(raw).length})`
    }
    if (key === "DATABASE_URL" && set) {
      note = `set (${String(raw).replace(/\/\/[^@]+@/, "//***@")})`
    }
    return { key, note }
  })
}

function resolveSqlitePath(): string | null {
  const url = process.env.DATABASE_URL?.trim()
  if (!url) return null
  if (url.startsWith("file:")) {
    const rel = url.slice("file:".length).replace(/^\.\//, "")
    return path.resolve(process.cwd(), rel)
  }
  return null
}

function probeSqlite(logPath: string, dbPath: string) {
  appendLog(logPath, `sqlite: path=${dbPath}`)
  if (!fs.existsSync(dbPath)) {
    appendLog(logPath, "sqlite: file NOT FOUND")
    return { ok: false, detail: "database file missing" }
  }
  const stat = fs.statSync(dbPath)
  appendLog(logPath, `sqlite: size=${stat.size} bytes`)
  const wal = `${dbPath}-wal`
  const shm = `${dbPath}-shm`
  if (fs.existsSync(wal)) appendLog(logPath, `sqlite: WAL exists (${fs.statSync(wal).size} bytes)`)
  if (fs.existsSync(shm)) appendLog(logPath, `sqlite: SHM exists`)

  try {
    const db = new DatabaseSync(dbPath, { readOnly: true })
    const hasTable = db
      .prepare(
        `SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'projects_home'`,
      )
      .get()
    if (!hasTable) {
      db.close()
      appendLog(logPath, "sqlite: table projects_home MISSING")
      return { ok: false, detail: "projects_home table missing" }
    }
    const count = db
      .prepare(`SELECT COUNT(*) AS c FROM projects_home_project_items`)
      .get() as { c: number }
    db.close()
    appendLog(logPath, `sqlite: projects_home_project_items count=${count?.c ?? 0}`)
    return { ok: true, detail: `items=${count?.c ?? 0}` }
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    const stack = err instanceof Error ? err.stack : undefined
    appendLog(logPath, `sqlite: ERROR ${message}`)
    if (stack) appendLog(logPath, stack)
    return { ok: false, detail: message }
  }
}

async function probePayloadFindGlobal(logPath: string) {
  appendLog(logPath, "payload: getPayload + findGlobal(slug=projects-home, depth=1)")
  try {
    const payload = await getPayload({ config })
    const doc = await payload.findGlobal({
      slug: "projects-home",
      depth: 1,
    })
    const items = Array.isArray(doc?.projectItems) ? doc.projectItems.length : 0
    appendLog(logPath, `payload: OK — projectItems.length=${items}`)
    return { ok: true, detail: `projectItems=${items}` }
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    const stack = err instanceof Error ? err.stack : undefined
    appendLog(logPath, `payload: ERROR ${message}`)
    if (stack) appendLog(logPath, stack)
    return { ok: false, detail: message, stack }
  }
}

/**
 * Run diagnostics for live projects-home 500s. Appends full detail to debug-projects-home.log in cwd.
 */
export async function runProjectsHomeDebugProbe(): Promise<DebugProbeResult> {
  const logPath = path.join(process.cwd(), DEBUG_PROJECTS_HOME_LOG)
  const steps: DebugProbeResult["steps"] = []

  fs.writeFileSync(
    logPath,
    `\n========== debug probe ${new Date().toISOString()} ==========\n`,
    "utf8",
  )
  appendLog(logPath, `cwd=${process.cwd()}`)
  appendLog(logPath, `node=${process.version}`)

  for (const row of envPresence()) {
    appendLog(logPath, `env ${row.key}: ${row.note}`)
    steps.push({
      step: `env:${row.key}`,
      ok: !row.note.includes("MISSING"),
      detail: row.note,
    })
  }

  const dbPath = resolveSqlitePath()
  if (dbPath) {
    const sqlite = probeSqlite(logPath, dbPath)
    steps.push({ step: "sqlite", ok: sqlite.ok, detail: sqlite.detail })
  } else {
    appendLog(logPath, "sqlite: skipped (DATABASE_URL not file:...)")
    steps.push({ step: "sqlite", ok: false, detail: "non-file DATABASE_URL" })
  }

  const payload = await probePayloadFindGlobal(logPath)
  steps.push({ step: "payload.findGlobal", ok: payload.ok, detail: payload.detail })

  appendLog(logPath, "========== end probe ==========")

  return {
    ok: payload.ok,
    logPath,
    steps,
    errorMessage: payload.ok ? undefined : payload.detail,
    errorStack: payload.ok ? undefined : payload.stack,
  }
}
