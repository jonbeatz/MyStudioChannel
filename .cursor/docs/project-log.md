# Project Session Log

## [2026-06-02] - MCP-first push website live + deploy tooling
- **Branch:** MSC-Website-v4
- **Changes:** `deploy:zip`, MCP-default `push-website-live.ps1`, FTPS fallback (`--ftps`), Hostinger restart reminder, `FTP_REMOTE_PATH=/nodejs` sync, debug projects-home probe (gated).
- **Docs:** Push-Website-Live.md, HOSTINGER-DEPLOY Path C, global/workflow rules, Jedi-List, START-HERE, Checkpoint, ReCall.
- **Next:** MCP deploy + hPanel restart; verify live API/globals

## [2026-06-01] - v4.0.0 live deploy + docs sync
- **Branch:** MSC-Website-v4 @ `87ec9de`+; **main** synced
- **Live:** mystudiochannel.com serving Next.js v4.0.0 (Hostinger MCP deploy, build `019e8569-74dc-70e6-bc10-4a121aac92ad`)
- **Status:** `/` and `/admin` 200; API globals 500 until hPanel env vars verified
- **Next:** Feature work on MSC-Website-v4

## [2026-06-01] - v4.0.0 development branch
- **Branch:** MSC-Website-v4 (new from MSC-Website-v3 @ `8a44d95`)
- **Changes:** Version bump to 4.0.0; operational docs updated for v4
- **Status:** Complete
- **Next:** Deploy to live (done same day)

## [2026-06-01] - Docs sync (Hostinger deploy + Path C)
- **Branch:** MSC-Website-v3 @ `c0bdaac`
- **Changes:** `HOSTINGER-DEPLOY.md` Path C daily updates; `DEPLOYMENT-FIXES.md` canonical dependency rule; cross-links in START-HERE, Jedi-List, Go-Live, TRUTH; ISSUES-RESOLVED + Restore-Points + ReCall synced.
- **Status:** Complete
- **Next:** Ongoing live updates via `pushit:live`; verify hPanel env vars

## [2026-06-01] - Hostinger first live deploy + deployment docs
- **Branch:** MSC-Website-v3 / main
- **Changes:** Successful zip deploy to mystudiochannel.com; moved `@tailwindcss/postcss`, `postcss`, `tw-animate-css` to `dependencies`; full HOSTINGER-DEPLOY rewrite; DEPLOYMENT-FIXES.md created.
- **Status:** Complete
- **Next:** Path C FTPS updates for day-to-day changes

## [2026-06-01] - Docs sync + main merge
- **Branch:** MSC-Website-v3 / main @ `57910cd`
- **Changes:** Version/branding consolidation docs; `main` fast-forwarded from `MSC-Website-v3`; Jedi-List, ReCall, Checkpoint, Go-Live updated for `package.json`-only versioning.
- **Status:** Complete
- **Next:** Deploy when ready; continue feature work on `MSC-Website-v3`

## [2026-06-01] - Version consolidation
- **Branch:** MSC-Website-v3
- **Changes:** `lib/msc-app-version.ts` from `package.json`; removed `msc-admin-version.ts`; footer/admin MyStudioChannel labels; hero slide 5 JPG; MCP test script.
- **Status:** Complete
- **Next:** Merge to main (done same day)

## [2026-05-30] - Version 3.0.0 Bump
- **Branch:** MSC-Website-v3
- **Changes:** Deep audit consolidation completed; branch upgraded to v3; version bumped to 3.0.0.
- **Status:** Complete
- **Next:** Continue development on v3

## [2026-05-30] - Initial Setup
- **Branch:** MSC-Website-v3
- **Changes:** Initial workflow system setup
- **Status:** Complete
- **Next:** Begin development
