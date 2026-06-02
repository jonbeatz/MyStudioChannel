import { NextResponse } from "next/server"

import {
  DEBUG_PROJECTS_HOME_LOG,
  runProjectsHomeDebugProbe,
} from "@/lib/debug-projects-home-probe"

export const dynamic = "force-dynamic"
export const runtime = "nodejs"

/**
 * Temporary live debugger for `/api/globals/projects-home` 500s.
 *
 * Production (hPanel env):
 *   ENABLE_DEV_LAB=true
 *   MSC_DEBUG_SECRET=<random-long-string>
 *
 * Call:
 *   GET https://mystudiochannel.com/api/dev/debug-projects-home?token=<MSC_DEBUG_SECRET>
 *
 * Reads/writes: `<app-root>/debug-projects-home.log` on the server (same folder as payload.sqlite).
 * Remove this route after fixing live.
 */
function isDebugRouteAllowed(request: Request): boolean {
  if (process.env.NODE_ENV !== "production") return true

  if (process.env.ENABLE_DEV_LAB !== "true") return false

  const secret = process.env.MSC_DEBUG_SECRET?.trim()
  if (!secret) return false

  const url = new URL(request.url)
  const token =
    url.searchParams.get("token")?.trim() ||
    request.headers.get("x-msc-debug-token")?.trim()

  return token === secret
}

export async function GET(request: Request) {
  if (!isDebugRouteAllowed(request)) {
    return NextResponse.json(
      {
        error: "Not found",
        hint:
          "Set ENABLE_DEV_LAB=true and MSC_DEBUG_SECRET in hPanel, then call with ?token=...",
      },
      { status: 404 },
    )
  }

  try {
    const result = await runProjectsHomeDebugProbe()

    return NextResponse.json(
      {
        ok: result.ok,
        logFile: DEBUG_PROJECTS_HOME_LOG,
        logPath: result.logPath,
        steps: result.steps,
        errorMessage: result.errorMessage,
        errorStack: result.errorStack,
        readLogHint:
          "Live (hPanel → Terminal): cd to app root, then: cat debug-projects-home.log",
      },
      {
        status: result.ok ? 200 : 500,
        headers: {
          "Cache-Control": "no-store",
        },
      },
    )
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    const stack = err instanceof Error ? err.stack : undefined
    return NextResponse.json(
      { ok: false, errorMessage: message, errorStack: stack },
      { status: 500 },
    )
  }
}
