import { expect, test } from "@playwright/test"

test("homepage loads with expected title", async ({ page }) => {
  const response = await page.goto("/")
  expect(response?.status()).toBe(200)
  await expect(page).toHaveTitle(/My Studio Channel/i)
})

test("admin login page loads", async ({ page }) => {
  const response = await page.goto("/admin")
  expect(response?.status()).toBe(200)
  await expect(page).toHaveURL(/\/admin(\/login)?(\?.*)?$/i)

  // Payload admin login is client-rendered; first CI compile can take minutes.
  const email = page.locator(
    "input[type='email'], input[name='email'], input#field-email",
  )
  const password = page.locator("input[type='password']")

  await expect(email).toBeVisible({ timeout: 180_000 })
  await expect(password).toBeVisible({ timeout: 30_000 })
})
