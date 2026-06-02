# Project Checkpoint

## Current Status
- **Date:** 2026-06-02
- **Branch:** MSC-Website-v4 (active dev)
- **Version:** 4.0.0 (`package.json` — sole release number)
- **Build Status:** Passing (`npm run build` / `verify:next:safe`)
- **Deploy default:** Say **push website live** → `npm run push:website:live` → MCP zip (`hosting_deployJsApplication`) → [hPanel restart](https://hpanel.hostinger.com/websites/mystudiochannel.com). FTPS fallback: `-- --ftps`.
- **Live:** [https://mystudiochannel.com](https://mystudiochannel.com) — **v4.0.0** (redeploy via MCP zip in `zips/MyStudioChannel-deploy-*.zip`)
- **Git:** `main` synced with `MSC-Website-v4`; `MSC-Website-v3` frozen at v3.0.0

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| 2026-06-01 | **v4.0.0 live** on mystudiochannel.com (Hostinger Node.js rebuild) | docs sync |
| 2026-06-01 | v4.0.0 branch `MSC-Website-v4` + version bump | `87ec9de` |
| 2026-06-01 | Hostinger Path C deployment docs + doc sync | `8a44d95` |
| 2026-06-01 | First Hostinger zip deploy (v3.0.0) | `c0bdaac` |

## Next Milestones
- [ ] Set / verify all hPanel env vars (fixes `/api/globals/projects-home` 500)
- [ ] Feature work on `MSC-Website-v4`
- [ ] Test all button redirects
