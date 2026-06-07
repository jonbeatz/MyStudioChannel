# Project Checkpoint

## Current Status
- **Date:** 2026-06-07
- **Branch:** MSC-Website-v6 (active dev)
- **Version:** 6.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`npm run build` / `verify:next:safe`)
- **Deploy default:** Say **push it live** → agent **asks mode** (Quick DB · Full FTPS · MCP code-only). **MCP/Git ≠ DB deploy** — verify `payload.sqlite` ~500 KB after rebuild; use **`msc:push:db:live`** if stub. [hPanel restart](https://hpanel.hostinger.com/websites/mystudiochannel.com).
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v5.0.0 on live** until next deploy; local/dev shows **v6.0.0**
- **Git:** `MSC-Website-v6` cut from v5 @ `92918b6`; `MSC-Website-v5` frozen; `main` to sync on push

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-07 | **v6.0.0 branch cut — MSC-Website-v6** | chore |
| 2026-06-07 | **Deploy hardening — SSH sync-db, Quick DB, Sentry org fix** | `06ec2be` |
| 2026-06-07 | **Sentry Diagnostics Suite Integrated** | feat |
| 2026-06-07 | **Jina Reader & Canonical Tool Chest Integrated** | feat |
| 2026-06-02 | **v5.0.0 branch cut + Master version bump** | chore |

## Session checklist
- [x] Branch `MSC-Website-v6` created from `MSC-Website-v5`
- [x] Version bumped to **6.0.0** in `package.json`
- [x] Operational docs synced to v6
- [ ] Feature work on `MSC-Website-v6`
- [ ] Deploy v6.0.0 labels to live when ready
