# Agent Instructions for MyStudioChannel

## First Time Here?
1. Read `TRUTH.md` - This is the constitution. It has final authority.
2. Read `START-HERE.md` - Cold-start ritual and daily workflow.
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
| 2 | `START-HERE.md` | Entry point and rituals |
| 3 | `.cursor/docs/MASTER-COMMANDS.md` | Command reference |
| 4 | `.cursor/skills/` | Portable AI agent skills |

## Skill Packs (New)
Always check `.cursor/skills/` for project-specific and portable agent abilities.
- **DesignMD**: Use `.cursor/skills/DesignMD/SKILL.md` for design system extraction/application.
- **GitHub-Ops**: Use `.cursor/skills/GitHub-Ops/SKILL.md` for repo and library management.
- **Premium-UI**: Use `.cursor/skills/Premium-UI/SKILL.md` for pre-wired UI builders, Lenis smooth scroll integrations, 21st.dev Magic MCP, Uiverse.io, VibeUI, and MotionSites.ai.
- **Workflow-Portable**: Standard ops (backups, deploys, session logs).
- Code changes only: `npm run msc:push:website:live`
- Full deploy (code + database): `npm run msc:push:website:live -- --ftps`
- Always restart Node in hPanel after deploy.
