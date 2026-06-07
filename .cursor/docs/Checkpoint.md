# Project Checkpoint

## Current Status
- **Date:** 2026-06-07
- **Branch:** MSC-Website-v6 (active dev)
- **Version:** 6.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`npm run build` / `verify:next:safe`)
- **Deploy default:** Say **push it live** → agent **asks mode** (Quick DB · Full FTPS · MCP code-only). **MCP/Git ≠ DB deploy** — verify `payload.sqlite` ~500 KB after rebuild; use **`msc:push:db:live`** if stub. [hPanel restart](https://hpanel.hostinger.com/websites/mystudiochannel.com).
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v5.0.0 on live** until next deploy; local/dev shows **v6.0.0**
- **Git:** `MSC-Website-v6` (active); `main` synced with v6; `MSC-Website-v5` frozen @ `92918b6`
- **Nav:** Header **Legal** dropdown via **`submenuSource: pages-collection`**; MSC1 excluded (**`showInHeaderNav`**)
- **GitHub releases:** [v6.0.0 Latest](https://github.com/jonbeatz/MyStudioChannel/releases/latest) · tags `v1.0.0`–`v6.0.0` on [tags](https://github.com/jonbeatz/MyStudioChannel/tags)

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-07 | **Header nav — submenuSource + Legal dropdown** | feat |
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
- [ ] Deploy v6.0.0 labels to live when ready
