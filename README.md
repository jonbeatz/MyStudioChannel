# My Studio Channel (MSC) — Next-Gen Creator Platform

## 🚀 Quick Start for Contributors

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
![Version](https://img.shields.io/badge/version-6.0.0-blue)
![Deploy](https://img.shields.io/badge/deploy-ftps-success)

---

> 🔮 **Single Source of Truth:** Read **[`TRUTH.md`](TRUTH.md)** for our master project identity, core commands, and architectural blueprint.

## 📊 Current Status

| Metric              | Value                                                                  |
| ------------------- | ---------------------------------------------------------------------- |
| **Version**         | v6.0.0 ([Latest release](https://github.com/jonbeatz/MyStudioChannel/releases/latest); live at [mystudiochannel.com](https://mystudiochannel.com) until next deploy) |
| **Stack**           | Next.js 15 (React 19) + Payload CMS 3.81.0                             |
| **CMS Engine**      | ✅ MSC PRO ENGINE Studio Mode — Gold Sidebar + Dashboard               |
| **Deployment**      | ✅ Tiered FTPS (Hostinger/hPanel) via `PushItUP`                       |
| **Database**        | ✅ Local SQLite (Production-hardened)                                  |
| **Verified**        | ✅ `npm run verify:next` (Build Gate + Integrity)                      |
| **Status**          | 🟢 Production Ready                                                    |

---

## 🚀 Why My Studio Channel?

Most templates give you a website. **MSC gives you a complete media broadcasting operating system.**

| Capability                         | My Studio Channel | Typical Boilerplate |
| ---------------------------------- | ----------------- | ------------------- |
| Network-Style Layouts              | ✅                 | ❌                   |
| MSC PRO ENGINE (Custom CMS)        | ✅                 | ❌                   |
| Cinema-Quality Bento Grids         | ✅                 | ❌                   |
| Tiered FTPS Deploy Engine          | ✅                 | ❌                   |
| Zero Platform Fees (Ownership)     | ✅                 | ❌                   |
| Agent-Ready Documentation          | ✅                 | ❌                   |
| Hardened Production Verify Scripts | ✅                 | ❌                   |
| 16:9 Cinematic Design System       | ✅                 | ❌                   |

---

## 🖼️ Screenshots

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

## 🚀 Quick Start

```bash
git clone https://github.com/jonbeatz/MyStudioChannel.git
cd MyStudioChannel
npm install                     # Install dependencies
copy .env.example .env.local    # Setup environment (Windows)
npm run dev:payload             # Start dev server on :3000
```

**Open `http://localhost:3000`** — The MSC portal.
**Admin `http://localhost:3000/admin`** — MSC PRO ENGINE Studio Mode.

Verify the baseline gate:
```bash
npm run verify:next             # clean · build · integrity check
```

> **Requirements:** Node 20.x+ · npm ≥ 10  
> **Secrets:** Live keys belong in `.env.local` only — never commit secrets.

> **Agent ritual:** Say `Begin project` in Cursor chat for full cold-start — see START-HERE.md.

---

## 🏗️ Architecture

```
My Studio Channel
├── MSC PRO ENGINE          # Custom Payload CMS admin experience
├── Frontend (port 3000)    # Next.js 15 App Router (React 19)
├── PushItUP Engine         # Tiered FTPS deployment automation
├── NovaMira Design         # High-end studio UI components
└── Jedi Tooling            # msc:* script system for ops
```

---

## 🛡️ Production-Hardening & Reliability Features

The `MSC-Website-v6` line continues comprehensive safety and developer experience features from v5:
- **Database Optimization Utility:** Optimize database files with `npm run db:optimize` (using `PRAGMA optimize` + `VACUUM`), automated to prevent bloat.
- **Git Pre-commit Hook (Husky):** Enforces lint checks automatically on every `git commit`, preventing bad syntax or build errors from entering git.
- **SSH Live Log Streaming:** Instantly tail remote host logs on your PC terminal via `npm run logs:live` (stderr) and `npm run logs:live:console`.
- **Version & Branch Tracking:** Automated version mapping, branch names, and commit hashes embedded inside backup notes.
- **Post-Backup Verification:** Self-testing backup checker that validates the structural completeness of local backups automatically.
- **Backup Retention Manager:** Simple retention utility via `npm run backup:clean` that retains only the 10 most recent backups and purges older folders.

## 📦 Deployment Workflow

Optimized for **Hostinger (hPanel)** with **automated validation and recovery**:

- **Say "push it live"** in Cursor — agent asks mode: **Quick DB** · **Fast FTPS** (`pushit:live:fast`) · **Full FTPS** · **MCP** (avoid on this host)
- **Tier 1 (Branding):** `npm run pushitup:admin-branding` (CSS + Graphics fast ship)
- **Tier 2b (Fast):** `npm run pushit:live:fast` (zip `.next` + admin-ui + **`sync-app`** — ~10–15 min)
- **Tier 2 (Full):** `npm run pushit:live` (build + `.next` + DB + media; SSH **`sync-db`** + **`sync-app`**)
- **Tier 3 (Config):** `npm run pushitup:server-config` (Package/Server files contract)

---

## 📚 Documentation

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

## 👥 Contributors

- **Jon Beatz** - Creator & Developer
  - GitHub: [@jonbeatz](https://github.com/jonbeatz)
  - Email: createmystudiochannel@gmail.com

---

## 📄 License

MIT © My Studio Channel

---

<p align="center">
  <sub>· Powered by the MSC Media Engine</sub>
</p>
