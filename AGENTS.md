# Agent Instructions for MyStudioChannel

## First Time Here?
1. Read `TRUTH.md` - This is the constitution. It has final authority.
2. Read `.cursor/docs/START-HERE.md` - Cold-start ritual and daily workflow.
3. Read `.cursor/docs/MASTER-COMMANDS.md` - All commands in one place.

## Core Rules
- Always run `npm run doctor` before starting significant work.
- Use short aliases (`log:session`, `log:fix`, `deploy`, `backup`) when possible to stay efficient.
- Never commit secrets. Secrets go in `.env.local` (gitignored).
- Follow the "Start Project" ritual to begin a session.
- Follow the "End Project" ritual to close a session.
- **Commands:** Prefer the short aliases listed in `MASTER-COMMANDS.md` (e.g., `npm run sync` instead of `npm run msc:docs:sync`).
- **Commits:** Always run `npm run lint:fix` before committing to satisfy Husky pre-commit hooks.

## Documentation Workflow
- **Log Fixes:** Run `npm run msc:log:fix` immediately after resolving any bug.
- **Log Sessions:** Run `npm run msc:log:session` before every "End Project" ritual.
- **Milestones:** Use `specs/` folder for feature planning; summarize into `Restore-Points.md` on completion.
- **No Drift:** Run `npm run msc:docs:sync` after any significant documentation changes.

## Documentation Hierarchy
| Priority | Document | Purpose |
|----------|----------|---------|
| 1 | `TRUTH.md` | Constitution (final authority) |
| 2 | `.cursor/docs/START-HERE.md` | Entry point and rituals |
| 3 | `.cursor/docs/MASTER-COMMANDS.md` | Command reference |
| 4 | `.cursor/skills/` | Portable AI agent skills |

## Skill Packs (New)
Always check `.cursor/skills/` for project-specific and portable agent abilities.
- **MSC-UI-Taste**: Use `.cursor/skills/MSC-UI-Taste/SKILL.md` for anti-slop UI, taste dials, and audit/polish workflow (merged taste-skill + impeccable + emilkowalski).
- **NovaMira-Design**: Studio Gold `#F5B841`, glass, bento — read before any MSC UI work.
- **DesignMD**: Use `.cursor/skills/DesignMD/SKILL.md` for design system extraction/application. **Required before greenfield UI.**
- **Premium-UI**: Use `.cursor/skills/Premium-UI/SKILL.md` for pre-wired UI builders, Lenis smooth scroll integrations, 21st.dev Magic MCP, Uiverse.io, VibeUI, and MotionSites.ai.
- **GitHub-Ops**: Use `.cursor/skills/GitHub-Ops/SKILL.md` for repo and library management.
- **Workflow-Portable**: Standard ops (backups, deploys, session logs).
- **Imported playbooks**: `.cursor/skills/imported/CURATED-INDEX.md` only — **do not** bulk-install antigravity skills.

## UI taste rules
1. Cite **NovaMira Gold** before generic Tailwind/shadcn defaults.
2. Ban purple-gradient heroes, Inter-only centered layouts, cookie-cutter SaaS cards.
3. Optional harsh review: `.cursor/prompts/harsh-review.md` — **never** for deploy, docs sync, or Hostinger ops.

## Obsidian think layer
Personal vault: `I:\Vader_Vault` (not in git). Ship layer: `.cursor/docs/` + TRUTH. Weekly distill to ReCall — manual, not auto-sync.
- Say **push it live** — agent asks mode: Quick DB · **Fast FTPS** (`pushit:live:fast`) · **Full FTPS** · MCP (**avoid on this host**)
- **Routine deploy:** `npm run pushit:live:fast` — zip `.next` + `sync-app` (~10–15 min). Full parity: `npm run pushit:live` (includes `sync-db` + media)
- **503 repair:** `msc:hostinger:npm-install` (webpack) or `msc:hostinger:recover` (preload/logs)
- MCP zip: `npm run push:website:live` — not a DB deploy; `better-sqlite3` compile often fails on host
- Always restart Node in hPanel after deploy; run `msc:verify:live`
