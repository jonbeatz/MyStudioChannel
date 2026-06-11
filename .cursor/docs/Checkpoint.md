# Project Checkpoint

## Current Status
- **Date:** 2026-06-11 (`MSC-Website-v8` branch cut)
- **Branch:** MSC-Website-v8 @ `b4ab8ae` (active dev)
- **Version:** 8.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`verify:next:safe`); **GitHub Actions** verify + Playwright on push to `MSC-Website-v8` / `main`
- **Deploy default:** **`npm run pushit:live:fast`** (~10–15 min) for daily code/UI; canonical table in **HOSTINGER-DEPLOY.md**. Say **push it live** → agent asks mode.
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v7.0.0** on host until next deploy; repo/local **`MyStudioChannel v8.0.0`**
- **Git:** `MSC-Website-v8` active; **`MSC-Website-v7`** frozen @ `b4ab8ae`; **`main`** @ `b4ab8ae`; `MSC-Website-v6` frozen @ `c9e260e`
- **Local preflight:** **`npm run verify:local`** (HTTP + Playwright smoke); **`npm run analyze`** for admin bundle (~816 kB baselined)
- **Backup:** quick backup **`msc-website-v2-k`** @ `b4ab8ae` (v7 restore point)

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-11 | **v8.0.0 release — version bump on `MSC-Website-v8`** | `7d23c45` |
| 2026-06-11 | **MSC-Website-v8 branch cut — v7 frozen @ `b4ab8ae`** | `b4ab8ae` |
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
| 2026-06-08 | **v7 development branch cut — MSC-Website-v7** | `c9e260e` |
| 2026-06-07 | **v6.0.0 branch cut — MSC-Website-v6** | `17b3da8` |
| 2026-06-07 | **Deploy hardening — SSH sync-db, Quick DB, Sentry org fix** | `06ec2be` |
| 2026-06-07 | **Sentry Diagnostics Suite Integrated** | feat |
| 2026-06-07 | **Jina Reader & Canonical Tool Chest Integrated** | feat |
| 2026-06-02 | **v5.0.0 branch cut + Master version bump** | chore |

## Session checklist
- [x] Branch `MSC-Website-v6` created from `MSC-Website-v5`
- [x] Version bumped to **6.0.0** in `package.json`
- [x] Operational docs synced to v6
- [x] GitHub tags/releases v4.0.0–v6.0.0
- [x] Branch `MSC-Website-v7` created from `MSC-Website-v6` @ `c9e260e`; v6 frozen
- [x] Version bumped to **7.0.0** in `package.json`
- [ ] Feature work on `MSC-Website-v7`
- [x] Deploy v7.0.0 labels to live (`pushit:live:fast -- -WithDb`)
- [x] Fix fast-deploy zip path (bash `$STAGING` quoting) + `package.json` FTPS on step 4
- [x] Document Hostinger two-folder map + 503 webpack fix across ops docs
