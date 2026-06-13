# Project Checkpoint

## Current Status
- **Date:** 2026-06-13 (LiteLLM database-less proxy + Start Project ritual)
- **Branch:** MSC-Website-v9 @ `a938232` (active dev)
- **Version:** 9.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`verify:next:safe`); lint clean; **GitHub Actions** verify + Playwright on push to `MSC-Website-v9` / `main`
- **Deploy default:** **`npm run pushit:live:fast`** (~10–15 min) for daily code/UI; canonical table in **HOSTINGER-DEPLOY.md**. Say **push it live** → agent asks mode.
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v7.0.0** on host until next deploy; repo/local **`MyStudioChannel v9.0.0`**
- **Git:** **`MSC-Website-v9`** active @ `a938232`; **`MSC-Website-v8`** frozen @ `c0d834e`; **`main`** @ `b4ab8ae`
- **Local preflight:** **`npm run verify:local`** (HTTP + Playwright smoke); **`npm run analyze`** for admin bundle (~816 kB baselined)
- **J.A.R.V.I.S.:** LiteLLM port **4000** + ngrok tunnel; `msc:litellm:verify` PASS; Start Project ~43s cold start
- **Backup:** quick backup **`MSC-Website-v9-k`** @ `b4ab8ae` (v7 restore point)

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-13 | **LiteLLM database-less proxy — no Prisma/SQLite startup errors** | `a938232` |
| 2026-06-13 | **Update Docs workflow split (Path A / Path B Mem0)** | `ae27ff2` |
| 2026-06-13 | **Version 9.0.0 release — MSC-Website-v9 active line** | `da57c3d` |
| 2026-06-13 | **Start Project ritual — JARVIS greeting, ngrok restore, summary cards** | `c0d834e` |
| 2026-06-12 | **Portable J.A.R.V.I.S. Setup Script & LM Studio Guidebooks** | `4056295` |
| 2026-06-12 | **Conversational FLUX.1 Image Generation Pipeline** | `4056295` |
| 2026-06-12 | **LM Studio Idle Auto-Unload VRAM Daemon** | `4056295` |
| 2026-06-12 | **Payload Schema Types Sync Watcher & Validation Hook** | `4056295` |
| 2026-06-12 | **Local J.A.R.V.I.S. Memory Layer & LM Studio Switcher Integration** | `4056295` |
| 2026-06-12 | **J.A.R.V.I.S. Vocal Welcome Greeting & Unified System Startup** | `4056295` |
| 2026-06-12 | **Cursor Developer MCP Server Expansion (SQLite, Git, Docker)** | `4056295` |
| 2026-06-11 | **v8.0.0 release — version bump on `MSC-Website-v9`** | `40b200e` |
| 2026-06-11 | **MSC-Website-v9 branch cut — v7 frozen @ `b4ab8ae`** | `b4ab8ae` |
| 2026-06-11 | **depcheck fix — `@payloadcms/ui` + review.md closeout** | `3d3cef7` |
| 2026-06-11 | **Playwright CI fix — admin login wait + warmup script** | `112acc5` |
| 2026-06-11 | **Docs sync — operational docs @ `6cb8c5a`** | `ac79160` |
| 2026-06-11 | **Docs sync — ISSUES-RESOLVED v6 historical annotation** | `6cb8c5a` |
| 2026-06-11 | **Hygiene pass — CI, Playwright, deploy tables, bundle analyzer, depcheck** | `0878b3b` |
| 2026-06-07 | **Planning docs — `ideaz.md` (portable kit) + `review.md` (audit queue)** | `2c2e94d` |
| 2026-06-07 | **Comprehensive audit Phases 2–4** | `9d9831f` |
| 2026-06-07 | **Backup bloat fix — exclude `zips/`, `backup:clean-zips`** | `273d03d` |
| 2026-06-08 | **Hostinger MCP spawn EINVAL fix + MCP-SETUP global 12 + sync script** | `ecfa5ea` |
| 2026-06-08 | **MSC Tooling Upgrade — UI taste skill, MCP consolidation, Obsidian pilot, cursor-mcp-refresh** | `27adb12` |
| 2026-06-08 | **pushit:live:fast — Tier 2b zip deploy + docs sync** | `8700e61` |
| 2026-06-08 | **Live 503 fix — sync-app + npm-install; deploy docs sync** | `b368d3e` |
| 2026-06-07 | **Header nav — submenuSource + Legal dropdown** | `6a21ce4` |
| 2026-06-07 | **GitHub releases/tags backfill v4–v6** | ops |
| 2026-06-08 | **pushit:live:fast zip unzip quoting fix + deploy diagnose** | `2404cc0` |
| 2026-06-08 | **payload.sqlite v7 dev baseline + main sync** | `14ceb53` |
| 2026-06-08 | **v7.0.0 live deploy (`pushit:live:fast -WithDb`)** | ops |
| 2026-06-08 | **v7.0.0 release — version bump + GitHub tag** | `a295fc4` |
| 2026-06-08 | **v7 development branch cut — MSC-Website-v9** | `c9e260e` |
| 2026-06-07 | **v6.0.0 branch cut — MSC-Website-v9** | `17b3da8` |
| 2026-06-07 | **Deploy hardening — SSH sync-db, Quick DB, Sentry org fix** | `06ec2be` |
| 2026-06-07 | **Sentry Diagnostics Suite Integrated** | feat |
| 2026-06-07 | **Jina Reader & Canonical Tool Chest Integrated** | feat |
| 2026-06-02 | **v5.0.0 branch cut + Master version bump** | chore |

## Session checklist
- [x] Branch `MSC-Website-v9` created from `MSC-Website-v9`
- [x] Version bumped to **6.0.0** in `package.json`
- [x] Operational docs synced to v6
- [x] GitHub tags/releases v4.0.0–v6.0.0
- [x] Branch `MSC-Website-v9` created from `MSC-Website-v9` @ `c9e260e`; v6 frozen
- [x] Version bumped to **7.0.0** in `package.json`
- [ ] Feature work on `MSC-Website-v9`
- [x] Deploy v7.0.0 labels to live (`pushit:live:fast -- -WithDb`)
- [x] Fix fast-deploy zip path (bash `$STAGING` quoting) + `package.json` FTPS on step 4
- [x] Document Hostinger two-folder map + 503 webpack fix across ops docs
