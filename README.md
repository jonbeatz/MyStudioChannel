# My Studio Channel (MSC) — Next-Gen Creator Platforms

Professional, network-style websites for creators who want more. **My Studio Channel** gives podcasters, talk show hosts, and independent producers the look and structure of a major network—powered by **Next.js 15**, **Payload CMS 3**, and the custom **MSC PRO ENGINE**.

## 📺 The Platform

My Studio Channel is built for creators, by creators. We design clean, organized platforms that showcase programming the way a real network would.

- **Network-Style Layouts:** Structured shows, episodes, and categories that rival major broadcasters.
- **Cinema-Quality Presentation:** High-end visual bento grids and cinematic hero carousels.
- **MSC PRO ENGINE:** A custom Payload CMS administrative experience with a gold sidebar, dashboard enhancements, and built-in tutorials.
- **Zero Platform Fees:** Built once, owned forever. No monthly subscriber charges or platform cuts.

## 🛠️ Stack

- **Framework:** [Next.js 15](https://nextjs.org/) (App Router, React 19)
- **CMS:** [Payload CMS 3](https://payloadcms.com/) (Local SQLite, relationship drawers, custom admin components)
- **Styling:** [Tailwind CSS 4](https://tailwindcss.com/) + [Radix UI](https://www.radix-ui.com/)
- **Operations:** Custom FTPS deployment engine (`PushItUP`) for shared hosting environments.

## 🚀 Local Development

1. **Setup:**
   ```bash
   npm install
   copy .env.example .env.local
   ```
2. **Environment:** Update `.env.local` with your `PAYLOAD_SECRET` and `RESEND_API_KEY`.
3. **Start:**
   ```bash
   npm run dev:payload
   ```
   - Site: `http://localhost:3000/`
   - Admin: `http://localhost:3000/admin` (MSC PRO ENGINE Studio Mode)

## 📦 Deployment Workflow

This project is optimized for deployment to **Spaceship** (shared hosting) using a Tiered FTPS strategy:

- **Tier 1 (Branding):** `npm run pushitup:admin-branding` (CSS + Graphics only)
- **Tier 2 (App):** `npm run pushit:live` (Full build, `.next`, SQLite, and Media)
- **Tier 3 (Config):** `npm run pushitup:server-config` (Package/Server files)

Before every live push, ensure `npm run verify:local` passes and all WAL journal files are removed from the server.

## 📄 Documentation

Operational guide for agents and operators:

- **[START-HERE.md](./.cursor/docs/START-HERE.md)** — Daily startup, source-of-truth order, and cPanel links.
- **[Agent-Runbook.md](./.cursor/docs/Agent-Runbook.md)** — Standardized prompts for consistent workflow.
- **[HOSTINGER-DEPLOY.md](./.cursor/docs/HOSTINGER-DEPLOY.md)** — The production hosting playbook and incident recovery.
- **[Jedi-List.md](./.cursor/docs/Jedi-List.md)** — Command quick-reference for all npm scripts.
- **[Restore-Points.md](./.cursor/docs/Restore-Points.md)** — Milestone checkpoints and rollback instructions.

---
**Version:** `v1.0.8` | **Admin:** MSC PRO ENGINE Studio Mode
