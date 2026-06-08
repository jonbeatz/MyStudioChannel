# Project Checkpoint

## Current Status
- **Date:** 2026-06-08
- **Branch:** MSC-Website-v6 (active dev)
- **Version:** 6.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`npm run build` / `verify:next:safe`)
- **Deploy default:** **`npm run pushit:live:fast`** (~10–15 min) for daily code/UI; **`pushit:live`** for full DB + media. Say **push it live** → agent asks mode (Quick DB · Fast FTPS · Full FTPS · MCP avoid). [hPanel restart](https://hpanel.hostinger.com/websites/mystudiochannel.com).
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v6.0.0** on live; Legal dropdown + **`verify:live`** passing
- **Git:** `MSC-Website-v6` (active); `main` syncing with v6; `MSC-Website-v5` frozen @ `92918b6`
- **Nav:** Header **Legal** dropdown via **`submenuSource: pages-collection`**; MSC1 excluded (**`showInHeaderNav`**)
- **GitHub releases:** [v6.0.0 Latest](https://github.com/jonbeatz/MyStudioChannel/releases/latest) · tags `v1.0.0`–`v6.0.0` on [tags](https://github.com/jonbeatz/MyStudioChannel/tags)

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-08 | **pushit:live:fast — Tier 2b zip deploy + docs sync** | `8700e61` |
| 2026-06-08 | **Live 503 fix — sync-app + npm-install; deploy docs sync** | `b368d3e` |
| 2026-06-07 | **Header nav — submenuSource + Legal dropdown** | `6a21ce4` |
| 2026-06-07 | **GitHub releases/tags backfill v4–v6** | ops |
| 2026-06-07 | **v6.0.0 branch cut — MSC-Website-v6** | `17b3da8` |
| 2026-06-07 | **Deploy hardening — SSH sync-db, Quick DB, Sentry org fix** | `06ec2be` |
| 2026-06-07 | **Sentry Diagnostics Suite Integrated** | feat |
| 2026-06-07 | **Jina Reader & Canonical Tool Chest Integrated** | feat |
| 2026-06-02 | **v5.0.0 branch cut + Master version bump** | chore |

## Session checklist
- [x] Branch `MSC-Website-v6` created from `MSC-Website-v5`
- [x] Version bumped to **6.0.0** in `package.json`
- [x] Operational docs synced to v6
- [x] GitHub tags/releases v4.0.0, v5.0.0, v6.0.0 (Latest)
- [ ] Feature work on `MSC-Website-v6`
- [x] Deploy v6.0.0 labels to live
- [x] Document Hostinger two-folder map + 503 webpack fix across ops docs
