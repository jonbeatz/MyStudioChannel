import { expect, test } from "@playwright/test"

test("homepage loads with expected title", async ({ page }) => {
  const response = await page.goto("http://localhost:3000/")
  expect(response?.status()).toBe(200)
  await expect(page).toHaveTitle(/My Studio Channel/i)
})

test("admin login page loads", async ({ page }) => {
  const response = await page.goto("http://localhost:3000/admin")
  expect(response?.status()).toBe(200)
  const body = page.locator("body")
  await expect(body).toContainText(/Email|Password/i)
})
