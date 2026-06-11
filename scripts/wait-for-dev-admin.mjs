/**
 * Poll Playwright until Payload admin login fields render (client-side).
 * Used in CI after `next dev` starts — first /admin compile can take several minutes.
 */
import { chromium } from "@playwright/test"

const origin = process.env.MSC_DEV_ORIGIN ?? "http://127.0.0.1:3000"
const timeoutMs = Number(process.env.MSC_DEV_ADMIN_WAIT_MS ?? 240_000)
const pollMs = Number(process.env.MSC_DEV_ADMIN_POLL_MS ?? 5_000)

const emailSelector =
  "input[type='email'], input[name='email'], input#field-email"
const passwordSelector = "input[type='password']"

async function serverResponds() {
  try {
    const res = await fetch(`${origin}/`, { signal: AbortSignal.timeout(10_000) })
    return res.ok
  } catch {
    return false
  }
}

async function adminLoginVisible(page) {
  const response = await page.goto(`${origin}/admin`, {
    waitUntil: "domcontentloaded",
    timeout: 60_000,
  })
  if (!response?.ok()) return false

  await page.waitForURL(/\/admin(\/login)?(\?.*)?$/i, { timeout: 30_000 })
  await page.locator(emailSelector).waitFor({ state: "visible", timeout: 15_000 })
  await page.locator(passwordSelector).waitFor({ state: "visible", timeout: 15_000 })
  return true
}

const started = Date.now()
const deadline = started + timeoutMs

while (Date.now() < deadline) {
  if (!(await serverResponds())) {
    await new Promise((resolve) => setTimeout(resolve, pollMs))
    continue
  }

  const browser = await chromium.launch()
  try {
    const page = await browser.newPage()
    try {
      if (await adminLoginVisible(page)) {
        console.log(`[wait-for-dev-admin] Login form ready (${Date.now() - started}ms)`)
        process.exit(0)
      }
    } catch {
      // Still compiling — retry after poll interval.
    }
  } finally {
    await browser.close()
  }

  console.log("[wait-for-dev-admin] Still compiling /admin — retrying…")
  await new Promise((resolve) => setTimeout(resolve, pollMs))
}

console.error(
  `[wait-for-dev-admin] Timed out after ${timeoutMs}ms waiting for admin login at ${origin}/admin`,
)
process.exit(1)
