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
| **RP-2026-06-18-workstation-unified-performance-guard** | 2026-06-18 | **Workstation Hardware Guard & Performance HUD Dashboard Upgrade:** Created VRAM pre-flight guard `.cursor/custom-scriptz/vram-check.ps1` to query hardware memory thresholds via `nvidia-smi` and prevent active LLM collisions with ComfyUI. Removed obsolete SD 1.5 checkpoints (`v1-5-pruned-emaonly.ckpt`), freeing 4.27 GB of high-speed local storage. Authored unified, emoji-free, UTF-8-safe `.ps1` master stack launcher `start-mystudio.ps1` to orchestrate dev servers, Kanban stack background processes, ComfyUI, and Postiz Docker containers with full port verify handshakes. Built `/api/system/vram` API route checking GPU metrics and parallel TCP service status. Designed a beautiful, glass-morphic floating `SystemStats` HUD in the bottom-left of the viewport with interactive hover cards. All builds, lints, and type validations passed cleanly. **Branch:** `MSC-Website-v9` (uncommitted stack code). **Restore:** Revert changes in `components/site-tooling-provider.tsx`, delete `components/system-stats.tsx` and `app/api/system/vram/route.ts`, and delete `start-mystudio.ps1`. |
| **RP-2026-06-18-dualmode-kanban-comfyui-restore** | 2026-06-18 | **Dual-Mode Kanban Automation & ComfyUI Suite Restore:** Restored the complete local ComfyUI model suite (~35GB) for your RTX 5060 Ti 16GB, including FLUX.2 Klein, FLUX.1 Dev, SDXL, and Realistic Vision. Fixed the `mat1 and mat2 shapes cannot be multiplied` error in the Flux.2 Klein workflow by transitioning to the correct `CLIPLoaderGGUF` (type: `flux2`) and `flux2-vae.safetensors` model dependencies. Automated all workflow tests via `test-comfyui-workflows.ps1` with verified 1024x1024 landscape saves. Programmed the **`task-executor.js`** skill inside `.cursor/custom-scriptz/agent-tasks/` supporting **Dual-Mode (Manual/Auto)**, smart tag routing, progress log commentary, and rich, formatted Telegram alerts via `%LOCALAPPDATA%\hermes\.env`. Added custom npm scripts to `package.json` and documented everything inside `.cursor/docs/AGENT-TASKS.md` and `COMFYUI-MODELS.md`. **Branch:** `MSC-Website-v9` (uncommitted code). **Restore:** Revert changes in `package.json`, delete `.cursor/custom-scriptz/agent-tasks/`, and remove `.cursor/docs/AGENT-TASKS.md` / `COMFYUI-MODELS.md`. |
| **RP-2026-06-18-session-stack-workflow** | 2026-06-18 | **Unified Session Start/Stop + Hidden Kanban Launches:** Replaced scattered manual port kills and duplicate Windows Terminal tabs with **`npm run msc:session:start`** (LiteLLM + ngrok + gateway + Kanban hidden) and **`npm run msc:session:stop`** / **`:keep-gateway`** (full teardown with orphan shell cleanup). Kanban stack now launches via hidden **`cmd.exe /c`** — not **`Start-Process npm`** (avoids Notepad popup) or **`wt.exe`** (avoids tab clutter). Start Project and End Project prompts, MASTER-COMMANDS, START-HERE, and KANBAN-STACK-GUIDE synced. Fixed duplicate **`msc:session:stop`** key in **`package.json`**. **Branch:** `MSC-Website-v9` (uncommitted). **Restore:** Revert session scripts + prompt changes; use old **`start-hermes-api.ps1`** + manual port kills. |
| **RP-2026-06-18-unified-kanban-sqlite-sync** | 2026-06-18 | **Unified Kanban Stack Direct SQLite Sync & LM Studio Optimization:** Unified TaskBoardAI (port 3001) and Hermes Workspace (port 3005) into real-time, bidirectional sync with your active Hermes SQLite database (`\boards\msc-website-v9\kanban.db`). Upgraded the Hermes backend query engine to compile queries directly using Node's native `node:sqlite` module, bypassing system `sqlite3` CLI errors on Windows and keeping the board active when Python Dashboard (port 9119) is offline. Bound Hermes Workspace to the `msc-website-v9` active board via `.env`. Created and injected hardware-maximized context configurations (up to 64k context) for your newly downloaded 32B/14B Qwen Coder, DeepSeek R1, and Shahrazad models inside LM Studio concrete overrides. Auto-booted the Python dashboard (port 9119) inside the unified `npm run kanban` launcher with active socket filters to prevent `TIME_WAIT` conflicts. All doctor, sync, and E2E checks pass. **Branch:** `MSC-Website-v9` (uncommitted stack code). **Restore:** Revert changes in `D:\Hermes\hermes-workspace\src\server\kanban-backend.ts` and `.env`. |
| **RP-2026-06-17-taskboardai-premium-hud** | 2026-06-17 | **TaskBoardAI Redesigned into Premium Cinematic HUD:** Redesigned the developer/agent console with MyStudioChannel brand gold (#F5B841), bento glassmorphism, dynamic Next Steps sidebar, real-time agent activity panel, J.A.R.V.I.S. orbital pulses, and live port monitors (LiteLLM, ComfyUI, Postiz, Hermes) running on port `3001`. Original `/app` backed up to `/app-stock` for a 100% reversible rollback. **Branch:** `MSC-Website-v9` (uncommitted TaskBoardAI code). **Restore:** Copy `/app-stock` back into `/app`. |
| **RP-2026-06-17-social-autopost-postiz-composio** | 2026-06-17 | **Social auto-post infra stabilized:** Postiz self-hosted at `http://localhost:4007` with API base `http://localhost:4007/api/public/v1` and working `postiz-client.mjs` health check. Composio MCP stabilized in Cursor by switching to `mcp-remote` stdio bridge (avoids SSE 404) and syncing `COMPOSIO_API_KEY` via `npm run msc:sync:mcp-env`. **Branch:** `MSC-Website-v9` (uncommitted). **Restore:** keep `.cursor/mcp.json` composio entry using `mcp-remote`; if Cursor shows composio OAuth session, click Logout then restart Cursor. |
| **RP-2026-06-13-comfyui-enhanced** | 2026-06-13 | **Local ComfyUI Setup Enhanced with GGUF Image & Video Engines:** Cloned and fully wired 11 new custom node suites (Impact Pack, IC-Light, VHS, segment-anything-2, etc.). Configured a high-performance sequential downloader and mklink symlinker to store ~35 GB of model checkpoints, upscale models (`4x-UltraSharp`), image-to-video (`SVD`), and text-to-video (`CogVideoX`) models directly on `H:\AI_Models\comfyui_cache\` and link them to `D:\AI_Models\ComfyUI\ComfyUI\models\`. Implemented and integrated 4 new custom PowerShell commands (`upscale-image`, `generate-video`, `animate-image`, `fix-face`) inside the user profile, backed up the profile-functions template, and authored a comprehensive master cheat sheet at `.cursor/docs/IMAGE-VIDEO-CHEATSHEET.md`. All tests, ESLint, Payload schema type sync, and git push succeeded. **Branch/commit:** `MSC-Website-v9` @ `55d856e`. **Restore:** `git fetch origin && git checkout MSC-Website-v9 && git reset --hard 55d856e`. |
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
