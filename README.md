# My Studio Channel (MSC) Ã¢â‚¬â€ Next-Gen Creator Platform

## Ã°Å¸Å¡â‚¬ Quick Start for Contributors

### Prerequisites
- **Node.js** 18, 20, 22, or 24
- **Git**

### One-command setup

```bash
git clone https://github.com/jonbeatz/MyStudioChannel.git
cd MyStudioChannel
npm run setup:dev
```

This command will:
- **Install** all dependencies
- **Create** your `.env.local` file
- **Optionally seed** the database with sample data
- **Run a health check** to ensure everything is ready

After setup, run `npm run dev` and visit [http://localhost:3000](http://localhost:3000)

---

**The production-hardened development operating system for creator platforms.**  
**Build studio-style websites with a visual command center,** 
**Next.js 15 stability, and the custom MSC PRO ENGINE.**

![My Studio Channel Hero](.cursor/design-references/MSC-Pages/MSC-Pages-v1.jpg)

[![Next.js 15](https://img.shields.io/badge/Next.js-15-black?logo=next.js)](https://nextjs.org/)
[![Payload CMS 3](https://img.shields.io/badge/Payload_CMS-3-green?logo=payload)](https://payloadcms.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS 4](https://img.shields.io/badge/Tailwind_CSS-4-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Cursor](https://img.shields.io/badge/Cursor-Agent_Ready-8E44AD?logo=cursor)](https://cursor.com/)
[![Troubleshooting](https://img.shields.io/badge/Troubleshooting-Active_Guide-red?logo=github)](.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md)
![Version](https://img.shields.io/badge/version-9.0.0-blue)
![Deploy](https://img.shields.io/badge/deploy-ftps-success)

---

> Ã°Å¸â€Â® **Single Source of Truth:** Read **[`TRUTH.md`](TRUTH.md)** for our master project identity, core commands, and architectural blueprint.

## Ã°Å¸â€œÅ  Current Status

| Metric              | Value                                                                  |
| ------------------- | ---------------------------------------------------------------------- |
| **Version**         | v8.0.0 ([Latest release](https://github.com/jonbeatz/MyStudioChannel/releases/latest); deploy to update live label at [mystudiochannel.com](https://mystudiochannel.com)) |
| **Stack**           | Next.js 15 (React 19) + Payload CMS 3.81.0                             |
| **CMS Engine**      | Ã¢Å“â€¦ MSC PRO ENGINE Studio Mode Ã¢â‚¬â€ Gold Sidebar + Dashboard               |
| **Deployment**      | Ã¢Å“â€¦ Tiered FTPS (Hostinger/hPanel) via `msc:pushitup`                       |
| **Database**        | Ã¢Å“â€¦ Local SQLite (Production-hardened)                                  |
| **Verified**        | Ã¢Å“â€¦ `npm run verify:next` (Build Gate + Integrity)                      |
| **Status**          | Ã°Å¸Å¸Â¢ Production Ready                                                    |

---

## Ã°Å¸Å¡â‚¬ Why My Studio Channel?

Most templates give you a website. **MSC gives you a complete media broadcasting operating system.**

| Capability                         | My Studio Channel | Typical Boilerplate |
| ---------------------------------- | ----------------- | ------------------- |
| Network-Style Layouts              | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| MSC PRO ENGINE (Custom CMS)        | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| Cinema-Quality Bento Grids         | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| Tiered FTPS Deploy Engine          | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| Zero Platform Fees (Ownership)     | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| Agent-Ready Documentation          | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| Hardened Production Verify Scripts | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |
| 16:9 Cinematic Design System       | Ã¢Å“â€¦                 | Ã¢ÂÅ’                   |

---

## Ã°Å¸â€“Â¼Ã¯Â¸Â Screenshots

### Built for Creators Like You
![Built for Creators](.cursor/design-references/MSC-Pages/MSC-Pages-v2.jpg)
*Structured layouts for Podcasters, Content Creators, and Network Builders.*

### Custom Add-Ons & Recommendations
![View Demos](.cursor/design-references/MSC-Pages/MSC-Pages-v6.jpg)
*Integrated demo viewer with pro-grade video production website designs.*

### High Quality Showcase Templates
![Add-Ons](.cursor/design-references/MSC-Pages/MSC-Pages-v5.jpg)
*Complete platform guidance from domain setup to social media graphics packages.*

---

## Ã°Å¸Å¡â‚¬ Quick Start

```bash
git clone https://github.com/jonbeatz/MyStudioChannel.git
cd MyStudioChannel
npm install                     # Install dependencies
copy .env.example .env.local    # Setup environment (Windows)
npm run dev:payload             # Start dev server on :3000
```

**Open `http://localhost:3000`** Ã¢â‚¬â€ The MSC portal.
**Admin `http://localhost:3000/admin`** Ã¢â‚¬â€ MSC PRO ENGINE Studio Mode.

Verify the baseline gate:
```bash
npm run verify:next             # clean Ã‚Â· build Ã‚Â· integrity check
```

> **Requirements:** Node 20.x+ Ã‚Â· npm Ã¢â€°Â¥ 10  
> **Secrets:** Live keys belong in `.env.local` only Ã¢â‚¬â€ never commit secrets.

> **Agent ritual:** Say `Begin project` in Cursor chat for full cold-start Ã¢â‚¬â€ see START-HERE.md.

---

## Ã°Å¸Ââ€”Ã¯Â¸Â Architecture

```
My Studio Channel
Ã¢â€Å“Ã¢â€â‚¬Ã¢â€â‚¬ MSC PRO ENGINE          # Custom Payload CMS admin experience
Ã¢â€Å“Ã¢â€â‚¬Ã¢â€â‚¬ Frontend (port 3000)    # Next.js 15 App Router (React 19)
Ã¢â€Å“Ã¢â€â‚¬Ã¢â€â‚¬ PushItUP Engine         # Tiered FTPS deployment automation
Ã¢â€Å“Ã¢â€â‚¬Ã¢â€â‚¬ NovaMira Design         # High-end studio UI components
Ã¢â€â€Ã¢â€â‚¬Ã¢â€â‚¬ Jedi Tooling            # msc:* script system for ops
```

---

## Ã°Å¸â€ºÂ¡Ã¯Â¸Â Production-Hardening & Reliability Features

The **`MSC-Website-v8`** line (cut from frozen **`MSC-Website-v7`** @ `b4ab8ae`) continues comprehensive safety and developer experience features from v5Ã¢â‚¬â€œv7:
- **Database Optimization Utility:** Optimize database files with `npm run msc:db:optimize` (using `PRAGMA optimize` + `VACUUM`), automated to prevent bloat.
- **Git Pre-commit Hook (Husky):** Enforces lint checks automatically on every `git commit`, preventing bad syntax or build errors from entering git.
- **SSH Live Log Streaming:** Instantly tail remote host logs on your PC terminal via `npm run msc:logs:live` (stderr) and `npm run msc:logs:live:console`.
- **Version & Branch Tracking:** Automated version mapping, branch names, and commit hashes embedded inside backup notes.
- **Post-Backup Verification:** Self-testing backup checker that validates the structural completeness of local backups automatically.
- **Backup Retention Manager:** Simple retention utility via `npm run msc:backup:clean` that retains only the 10 most recent backups and purges older folders.

## Ã°Å¸â€œÂ¦ Deployment Workflow

Optimized for **Hostinger (hPanel)** with **automated validation and recovery**:

- **Say "push it live"** in Cursor Ã¢â‚¬â€ agent asks mode: **Quick DB** Ã‚Â· **Fast FTPS** (`pushit:live:fast`) Ã‚Â· **Full FTPS** Ã‚Â· **MCP** (avoid on this host)
- **Tier 1 (Branding):** `npm run msc:pushitup:admin-branding` (CSS + Graphics fast ship)
- **Tier 2b (Fast):** `npm run pushit:live:fast` (zip `.next` + admin-ui + **`sync-app`** Ã¢â‚¬â€ ~10Ã¢â‚¬â€œ15 min; **`-- -WithDb`** for CMS DB). Pitfalls: **`.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`**
- **Tier 2 (Full):** `npm run pushit:live` (build + `.next` + DB + media; SSH **`sync-db`** + **`sync-app`**)
- **Tier 3 (Config):** `npm run msc:pushitup:server-config` (Package/Server files contract)

---

## Ã°Å¸â€œÅ¡ Documentation

| Document                                           | Purpose                                           |
| -------------------------------------------------- | ------------------------------------------------- |
| [START-HERE.md](./.cursor/docs/START-HERE.md)     | Operator cold-start & source-of-truth order       |
| [MASTER-COMMANDS.md](./.cursor/docs/MASTER-COMMANDS.md) | Master list of dev, deployment, and troubleshooting commands |
| [Agent-Runbook.md](./.cursor/docs/Agent-Runbook.md) | Standardized prompts for consistent workflow       |
| [HOSTINGER-DEPLOY.md](./.cursor/docs/HOSTINGER-DEPLOY.md) | Production hosting playbook (Path A/B/C) & recovery |
| [DEPLOYMENT-TROUBLESHOOTING.md](./.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md) | Root-cause troubleshooting for 503/500/504 and DB deployment issues |
| [DEPLOYMENT-FIXES.md](./.cursor/docs/DEPLOYMENT-FIXES.md) | Hostinger deploy learnings & canonical dependency rule |
| [Jedi-List.md](./.cursor/docs/Jedi-List.md)       | Command quick-reference for npm scripts           |
| [CHANGELOG.md](./CHANGELOG.md)                    | Release history                                   |
| [TOOL-CHEST.md](./.cursor/docs/TOOL-CHEST.md)     | Master index of external APIs, services, and search proxies |
| [Restore-Points.md](./.cursor/docs/Restore-Points.md) | Milestone checkpoints & rollback instructions |

---

## Ã°Å¸â€˜Â¥ Contributors

- **Jon Beatz** - Creator & Developer
  - GitHub: [@jonbeatz](https://github.com/jonbeatz)
  - Email: createmystudiochannel@gmail.com

---

## Ã°Å¸â€œâ€ž License

MIT Ã‚Â© My Studio Channel

---

<p align="center">
  <sub>Ã‚Â· Powered by the MSC Media Engine</sub>
</p>

