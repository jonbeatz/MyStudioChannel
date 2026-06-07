# Agent Instructions for MyStudioChannel

## First Time Here?
1. Read `TRUTH.md` - This is the constitution. It has final authority.
2. Read `START-HERE.md` - Cold-start ritual and daily workflow.
3. Read `.cursor/docs/MASTER-COMMANDS.md` - All commands in one place.

## Core Rules
- Always run `npm run msc:doctor` before starting significant work.
- Never commit secrets. Secrets go in `.env.local` (gitignored).
- Follow the "Start Project" ritual to begin a session.
- Follow the "End Project" ritual to close a session.

## Documentation Hierarchy
| Priority | Document | Purpose |
|----------|----------|---------|
| 1 | `TRUTH.md` | Constitution (final authority) |
| 2 | `START-HERE.md` | Entry point and rituals |
| 3 | `.cursor/docs/MASTER-COMMANDS.md` | Command reference |

## Deployment
- Code changes only: `npm run msc:push:website:live`
- Full deploy (code + database): `npm run msc:push:website:live -- --ftps`
- Always restart Node in hPanel after deploy.
