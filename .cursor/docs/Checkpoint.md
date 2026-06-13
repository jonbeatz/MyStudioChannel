# Project Checkpoint

## Current Status
- **Date:** 2026-06-12 (J.A.R.V.I.S. Welcome & Local Mem0 Memory Layer)
- **Branch:** MSC-Website-v9 @ `c0d834e` (active dev)
- **Version:** 8.0.0 (`package.json` Ã¢â‚¬â€ sole release number)
- **Build Status:** Passing (`verify:next:safe`); **GitHub Actions** verify + Playwright on push to `MSC-Website-v9` / `main`
- **Deploy default:** **`npm run pushit:live:fast`** (~10Ã¢â‚¬â€œ15 min) for daily code/UI; canonical table in **HOSTINGER-DEPLOY.md**. Say **push it live** Ã¢â€ â€™ agent asks mode.
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) Ã¢â‚¬â€ **v7.0.0** on host until next deploy; repo/local **`MyStudioChannel v9.0.0`**
- **Git:** `MSC-Website-v9` active; **`MSC-Website-v9`** frozen @ `c0d834e`; **`main`** @ `b4ab8ae`; `MSC-Website-v9` frozen @ `c9e260e`
- **Local preflight:** **`npm run verify:local`** (HTTP + Playwright smoke); **`npm run analyze`** for admin bundle (~816 kB baselined)
- **Backup:** quick backup **`MSC-Website-v9-k`** @ `b4ab8ae` (v7 restore point)

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-12 | **Portable J.A.R.V.I.S. Setup Script & LM Studio Guidebooks** | `4056295` |
| 2026-06-12 | **Conversational FLUX.1 Image Generation Pipeline** | `4056295` |
| 2026-06-12 | **LM Studio Idle Auto-Unload VRAM Daemon** | `4056295` |
| 2026-06-12 | **Payload Schema Types Sync Watcher & Validation Hook** | `4056295` |
| 2026-06-12 | **Local J.A.R.V.I.S. Memory Layer & LM Studio Switcher Integration** | `4056295` |
| 2026-06-12 | **J.A.R.V.I.S. Vocal Welcome Greeting & Unified System Startup** | `4056295` |
| 2026-06-12 | **Cursor Developer MCP Server Expansion (SQLite, Git, Docker)** | `4056295` |
| 2026-06-11 | **v8.0.0 release Ã¢â‚¬â€ version bump on `MSC-Website-v9`** | `40b200e` |
| 2026-06-11 | **MSC-Website-v9 branch cut Ã¢â‚¬â€ v7 frozen @ `b4ab8ae`** | `b4ab8ae` |
| 2026-06-11 | **depcheck fix Ã¢â‚¬â€ `@payloadcms/ui` + review.md closeout** | `3d3cef7` |
| 2026-06-11 | **Playwright CI fix Ã¢â‚¬â€ admin login wait + warmup script** | `112acc5` |
| 2026-06-11 | **Docs sync Ã¢â‚¬â€ operational docs @ `6cb8c5a`** | `ac79160` |
| 2026-06-11 | **Docs sync Ã¢â‚¬â€ ISSUES-RESOLVED v6 historical annotation** | `6cb8c5a` |
| 2026-06-11 | **Hygiene pass Ã¢â‚¬â€ CI, Playwright, deploy tables, bundle analyzer, depcheck** | `0878b3b` |
| 2026-06-07 | **Planning docs Ã¢â‚¬â€ `ideaz.md` (portable kit) + `review.md` (audit queue)** | `2c2e94d` |
| 2026-06-07 | **Comprehensive audit Phases 2Ã¢â‚¬â€œ4** | `9d9831f` |
| 2026-06-07 | **Backup bloat fix Ã¢â‚¬â€ exclude `zips/`, `backup:clean-zips`** | `273d03d` |
| 2026-06-08 | **Hostinger MCP spawn EINVAL fix + MCP-SETUP global 12 + sync script** | `ecfa5ea` |
| 2026-06-08 | **MSC Tooling Upgrade Ã¢â‚¬â€ UI taste skill, MCP consolidation, Obsidian pilot, cursor-mcp-refresh** | `27adb12` |
| 2026-06-08 | **pushit:live:fast Ã¢â‚¬â€ Tier 2b zip deploy + docs sync** | `8700e61` |
| 2026-06-08 | **Live 503 fix Ã¢â‚¬â€ sync-app + npm-install; deploy docs sync** | `b368d3e` |
| 2026-06-07 | **Header nav Ã¢â‚¬â€ submenuSource + Legal dropdown** | `6a21ce4` |
| 2026-06-07 | **GitHub releases/tags backfill v4Ã¢â‚¬â€œv6** | ops |
| 2026-06-08 | **pushit:live:fast zip unzip quoting fix + deploy diagnose** | `2404cc0` |
| 2026-06-08 | **payload.sqlite v7 dev baseline + main sync** | `14ceb53` |
| 2026-06-08 | **v7.0.0 live deploy (`pushit:live:fast -WithDb`)** | ops |
| 2026-06-08 | **v7.0.0 release Ã¢â‚¬â€ version bump + GitHub tag** | `a295fc4` |
| 2026-06-08 | **v7 development branch cut Ã¢â‚¬â€ MSC-Website-v9** | `c9e260e` |
| 2026-06-07 | **v6.0.0 branch cut Ã¢â‚¬â€ MSC-Website-v9** | `17b3da8` |
| 2026-06-07 | **Deploy hardening Ã¢â‚¬â€ SSH sync-db, Quick DB, Sentry org fix** | `06ec2be` |
| 2026-06-07 | **Sentry Diagnostics Suite Integrated** | feat |
| 2026-06-07 | **Jina Reader & Canonical Tool Chest Integrated** | feat |
| 2026-06-02 | **v5.0.0 branch cut + Master version bump** | chore |

## Session checklist
- [x] Branch `MSC-Website-v9` created from `MSC-Website-v9`
- [x] Version bumped to **6.0.0** in `package.json`
- [x] Operational docs synced to v6
- [x] GitHub tags/releases v4.0.0Ã¢â‚¬â€œv6.0.0
- [x] Branch `MSC-Website-v9` created from `MSC-Website-v9` @ `c9e260e`; v6 frozen
- [x] Version bumped to **7.0.0** in `package.json`
- [ ] Feature work on `MSC-Website-v9`
- [x] Deploy v7.0.0 labels to live (`pushit:live:fast -- -WithDb`)
- [x] Fix fast-deploy zip path (bash `$STAGING` quoting) + `package.json` FTPS on step 4
- [x] Document Hostinger two-folder map + 503 webpack fix across ops docs

