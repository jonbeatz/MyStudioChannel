# Restore points — MyStudioChannel (`MyStudioChannel`)

Human-named checkpoints so you can roll back mentally or on disk if a change goes wrong.

## How to restore

1. **Git (recommended)**  
   If the repo is under version control: tag after each checkpoint, e.g. `git tag restore-2026-04-08-cms-globals`.

2. **No git**  
   Copy the whole **`MyStudioChannel`** folder, or at minimum:
   - `payload.sqlite` (all CMS data: users, media, bookings, globals, leads)
   - `patch/` + `package-lock.json` if you rely on patched deps

3. **Database only**  
   Stop the dev server, copy `payload.sqlite` to a dated backup (e.g. `payload.2026-04-08.bak.sqlite`), restore by swapping the file back.

---

## Checkpoints

| ID | Date | Summary |
|----|------|---------|
| **RP-2026-06-13-flux-polished** | 2026-06-13 | **FLUX.1 Image Generation Polished:** Fixed terminal link clickability on Windows using standard raw backslashes `Saved to: D:\...`. Handled Hugging Face API constraints (max 2048x2048) by scaling widescreen "4k" prompts to `2048x1152`. Shortened voice feedback to `"Image generated, opening now."` and removed duplicate vocal synthesis processes. Tested E2E successfully. **Branch/commit:** `MSC-Website-v9` @ `97b4d5d`. **Restore:** `git fetch origin && git checkout MSC-Website-v9 && git reset --hard 97b4d5d`. |
| **RP-2026-06-13-litellm-databaseless** | 2026-06-13 | **LiteLLM database-less Vertex proxy:** Strips Payload SQLite `DATABASE_URL` from LiteLLM env; `disable_spend_logs` / `disable_error_logs`; `msc:litellm:verify` PASS; Start Project cold start ~43s without Prisma noise. **Branch/commit:** `MSC-Website-v9` @ **`a938232`**. **Restore:** `git fetch origin && git checkout MSC-Website-v9 && git reset --hard a938232`. |
| **RP-2026-06-13-v9-start** | 2026-06-13 | **`MSC-Website-v9` active line + v9.0.0:** Active dev from frozen **`MSC-Website-v8`** @ **`c0d834e`** (ngrok + litellm restored, backups standard complete, CI green). Version **9.0.0** in **`package.json`**. **Restore v8:** `git fetch origin && git checkout MSC-Website-v8 && git reset --hard c0d834e`. **Restore v9:** `git fetch --tags origin && git checkout MSC-Website-v9 && git pull`. |
| **RP-2026-06-13-ngrok-restored** | 2026-06-13 | **LiteLLM + ngrok Start Project Integration:** Restored the `start-hermes-api.ps1` launcher to boot both LiteLLM (via elevated Windows Terminal) and ngrok (via minimized background process to prevent double-UAC prompts). Added automated inspection of the `4040` local ngrok API, validation of remote model accessibility via public `/v1/models`, dynamic `.cursor/session-google-api.json` generation, and Cursor settings logging. All tests and completions pass. **Branch/commit:** `MSC-Website-v8` @ `c0d834e`. **Restore:** `git fetch origin && git checkout MSC-Website-v8 && git reset --hard c0d834e`. |
| **RP-2026-06-11-demos-reimagined** | 2026-06-11 | **Cinematic Bento-Grid Demos, CMS Seeding & Hermes Agent:** Built `DemosReimagined` (grid, motion reveals, pagination, `#msc-demos` anchor) and `DemosModal` (spring overlay). Permanently seeded 3 test projects and registered media assets in SQLite `payload.sqlite`. Hid legacy `DemosSection` in `page.tsx`. Installed global `hermes-agent` CLI and integrated it with existing Google Cloud Vertex AI via local LiteLLM proxy, creating project-specific `HERMES.md` instructions. Upgraded Payload to `3.85.1` and React to `19.2.7`, and optimized performance via ISR `revalidate = 3600`. All tests and lints pass. **Branch/commit:** `MSC-Website-v8` @ `f2d7b47`. **Restore:** `git fetch origin && git checkout MSC-Website-v8 && git reset --hard f2d7b47`. |
| **RP-2026-06-11-v8-start** | 2026-06-11 | **`MSC-Website-v8` branch cut + v8.0.0:** Active dev from frozen **`MSC-Website-v7`** @ **`b4ab8ae`** (hygiene complete, CI green, backup **`msc-website-v2-k`**). Version **8.0.0** in **`package.json`**. **Restore v7:** `git fetch origin && git checkout MSC-Website-v7 && git reset --hard b4ab8ae`. **Restore v8:** `git fetch --tags origin && git checkout MSC-Website-v8 && git pull`. |
| **RP-2026-06-11-ci-playwright** | 2026-06-11 | **Playwright CI fix @ `112acc5`:** Wait for Payload admin login form fields; longer Playwright timeouts; **`scripts/wait-for-dev-admin.mjs`** warmup before smoke tests. All smoke tests pass on GitHub Actions. **Restore:** `git fetch origin && git checkout MSC-Website-v7 && git reset --hard 112acc5`. |

> **Archive:** Older checkpoints moved to [_archive/Restore-Points-historical.md](_archive/Restore-Points-historical.md) (Phase 4 trim — keeps 3 most recent).

## New restore-point template (copy/paste)

Use this template when adding a checkpoint:

```md
| **RP-YYYY-MM-DD-short-name** | YYYY-MM-DD | **What was working:** short summary. **Branch/commit:** `<branch> @ <sha>`. **Restore steps:** 1) checkout branch/sha 2) run exact startup/deploy commands 3) note any env/dependency caveats. |
```

Suggested naming:

- `RP-2026-04-10-admin-v103-sidebar-version`
- `RP-2026-04-10-deploy-pushit-live-stable`

### Files worth diffing from this checkpoint

- `payload.config.ts`
- `globals/Homepage.ts`, `globals/SiteSettings.ts`, `globals/Header.ts`
- `collections/Leads.ts`, `collections/Media.ts`, `collections/Pages.ts`, `collections/Bookings.ts`
- `components/contact-section.tsx`, `components/hero-section.tsx`
- `lib/cms/*` (incl. **`homepage-gallery-hydrate.ts`**, **`homepage-gallery-seed.ts`**), `lib/booking.ts`, `lib/email-brand.ts`, `lib/email-templates.ts`
- `app/(site)/page.tsx`, `app/(site)/layout.tsx`
- `next.config.mjs` (image `remotePatterns` for localhost)

*(Older docs mentioned `collections/HeroSlides.ts` — that collection was removed; hero rows live on **`globals/Homepage`**, images on **Media**.)*

---

*Append a new row when you create the next restore point.*
