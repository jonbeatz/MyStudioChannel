# Curated Antigravity Playbooks (whitelist)

> **Antigravity MCP archived** from project `.cursor/mcp.json` (2026-06-08).  
> Do **not** bulk auto-install 1,500+ skills. Use this whitelist + first-party MSC skills.

## MSC-first routing

| Need | Use instead |
|------|-------------|
| UI taste / anti-slop | `.cursor/skills/MSC-UI-Taste/SKILL.md` |
| NovaMira tokens | `.cursor/skills/NovaMira-Design/SKILL.md` |
| Components / motion | `.cursor/skills/Premium-UI/SKILL.md` |
| Deploy / backup | Workflow-Portable skills |

## Approved playbook topics (reference only)

When searching GitHub or antigravity repo manually, these **15** categories are pre-approved for copy into `imported/`:

1. `nextjs-app-router` — routing, RSC, caching
2. `react-19-patterns` — hooks, server components boundaries
3. `tailwind-v4` — utility patterns, `@theme`
4. `accessibility-audit` — WCAG, focus, aria
5. `security-review` — OWASP, secrets, auth
6. `sqlite-ops` — WAL, migrations, backups
7. `payload-cms` — collections, hooks, admin
8. `stripe-integration` — webhooks, Checkout
9. `email-deliverability` — Resend, SPF/DKIM notes
10. `performance-lighthouse` — Core Web Vitals
11. `typescript-strict` — types, narrowing
12. `testing-playwright` — e2e smoke patterns
13. `git-workflow` — branch, PR, conventional commits
14. `docs-governance` — TRUTH hierarchy, drift audits
15. `error-monitoring-sentry` — Next.js SDK patterns

## Adding a new imported skill

1. Copy **one** playbook into `imported/<name>/SKILL.md`
2. Add row to this index with source URL
3. Run `npm run sync` if docs reference it
4. Never enable `antigravity-awesome-skills` MCP without Jon's explicit request
