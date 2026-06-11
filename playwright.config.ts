import { defineConfig } from "@playwright/test"

export default defineConfig({
  testDir: "./tests",
  timeout: 240_000,
  retries: process.env.CI ? 2 : 0,
  expect: {
    timeout: 180_000,
  },
  use: {
    baseURL: "http://localhost:3000",
    navigationTimeout: 120_000,
    actionTimeout: 30_000,
  },
})
