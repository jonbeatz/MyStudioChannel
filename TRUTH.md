# TRUTH.md - MyStudioChannel Master Reference

## Project Identity
- **Name:** MyStudioChannel
- **Type:** Next.js (15.4) + Payload CMS (3.81) application
- **OS/Shell:** Windows 10/11 + PowerShell (Core or Desktop)
- **Primary Branch:** `MSC-Website-v5` (active dev); **`main`** synced with v5 line
- **Repository:** [https://github.com/jonbeatz/MyStudioChannel](https://github.com/jonbeatz/MyStudioChannel)
- **Primary Domain:** [https://mystudiochannel.com](https://mystudiochannel.com)

---

## Core Commands (Quick Reference)

These are the primary executable commands configured inside `package.json`. Always run these from the project root.

| Command | What it does | Expected Outcome / Scope |
| :--- | :--- | :--- |
| `npm run dev` | Start development server | Stops lingering node processes on port 3000, then starts Next.js dev server on port `3000` with HMR (Webpack). |
| `npm run dev:fresh` | Clear cache and start dev | Resets `.next` compilation cache, kills port 3000, and launches a fresh dev instance. |
| `npm run build` | Compile production build | Compiles an optimized full-stack Next.js + Payload production bundle to `.next/`. |
| `npm run verify:next:safe` | Safe production build check | Verifies compilation safety on Windows by ensuring port 3000 is clean and avoids corrupting `.next` during builds. |
| `npm run start` | Run production server | Boots the compiled Next.js production server locally for smoke testing. |
| `npm run lint` | Run ESLint static check | Scans for TypeScript and syntax issues. |
| `npm run test:hostinger-ftp` | Smoke test FTP connection | Quick, read-only remote FTPS directory listing to test Hostinger logins. |
| `npm run parity:ftp` | Audit local vs remote drift | Compares local file tree with live Hostinger file tree and outputs `parity-ftp-report.md` (gitignored). |
| `npm run media:consolidate` | Clean up media folders | Relocates stray files from the root into `public/media/`. |
| `npm run media:sync` | Sync media directory to DB | Registers physical files under `public/media/` into the Payload database, bypassing alt-text blocks. |
| `npm run backup:github-repos` | Mirror GitHub repositories | Clones and bundles all active GitHub projects into `.cursor/GitHub-Repo-BackUps/`. |

---

## Workflow Commands (Natural Language)

Say these exact commands in Cursor chat to run automated, pre-flight workflow scripts.

| Say This | What happens | Associated Prompts / Skills |
| :--- | :--- | :--- |
| **`"Start Project"`** | Cold-start handshake ritual | Loads START-HERE, README, TRUTH, project-log, and Checkpoint. Runs preflights. |
| **`"End Project"`** | Session closeout and ports clear | Identifies changed files, prompts for git commits, logs summary, kills port 3000. |
| **`"update docs"`** | Synchronizes documentation | Audits files for drift, updates versions, logs issues to ISSUES-RESOLVED.md. |
| **`"Update Project"`** | Git-to-docs milestone sync | Parses commits and updates `project-log.md` and `Checkpoint.md` milestones. |
| **`"backup project"`** | Runs project backup ritual | Prompts step-by-step for standard/full backup, note, and exports to the G: backup drive. |
| **`"start google-api"`** | Start Vertex AI proxy | Boots local LiteLLM on port `4000` connected to Vertex AI and mounts an ngrok tunnel. |

---

## Documentation Map

This is the canonical Source of Truth reading order for all human developers and AI agents.

| Path | Purpose | When to read |
| :--- | :--- | :--- |
| [`TRUTH.md`](TRUTH.md) | This file - Project blueprint and master map | **Every session start** (Cold Start) |
| [`.cursor/docs/START-HERE.md`](.cursor/docs/START-HERE.md) | Primary entry point and daily bookmarks | Every session start |
| [`.cursor/docs/project-log.md`](.cursor/docs/project-log.md) | Continuous session summary logs | When running Start Project or checking status |
| [`.cursor/docs/Checkpoint.md`](.cursor/docs/Checkpoint.md) | Active milestone and target tracking | When planning new feature updates |
| [`.cursor/docs/Prompt-Cheat-Sheet.md`](.cursor/docs/Prompt-Cheat-Sheet.md) | Comprehensive command and trigger reference | Whenever looking up commands |
| [`.cursor/docs/HOSTINGER-DEPLOY.md`](.cursor/docs/HOSTINGER-DEPLOY.md) | Deploy tier processes and hPanel commands | Before pushing any code change to live |
| [`.cursor/docs/DEPLOYMENT-FIXES.md`](.cursor/docs/DEPLOYMENT-FIXES.md) | Hostinger deploy fixes and learnings (2026-06-01) | When live build fails or first-time zip deploy |
| [`.cursor/docs/ISSUES-RESOLVED.md`](.cursor/docs/ISSUES-RESOLVED.md) | Debugging logs and resolutions index | During troubleshooting or after resolving a bug |
| [`.cursor/docs/Restore-Points.md`](.cursor/docs/Restore-Points.md) | Backup history and local git rollbacks | When freezing a milestone or rolling back |

---

## Rules & Conventions

- **Name Standard:** Always use `MyStudioChannel` as the official project name. No "Vader Engine" references.
- **Custom Code Prefix:** All custom PHP functions prefix with `msc_`. Custom CSS/UI classes prefix with `msc-`.
- **Environment Isolation:** Place secrets **only** in `.env.local` (never committed). `.env.example` serves as the public variable map.
- **Pathing discipline:** Never write absolute local paths (like `D:\...`) inside code or scripts. Use relative path resolution or workspace variables.
- **File Structure:** Marketing site resides under route group `app/(site)/`. Embedded Payload admin panel resides under `app/(payload)/` with custom graphics, custom logout, and suppression patches for hydration overlays.
- **Assets Rule:** All images are served from `public/media/` addressing them as `/media/filename.ext`. Bulk uploads must be registered using `npm run media:sync`.

---

## Essential File Structure

```text
MyStudioChannel/
├── app/                  # Next.js App Router
│   ├── (payload)/        # Payload CMS admin and core routes
│   └── (site)/           # Marketing frontend (header, sections, footer)
├── collections/          # Payload CMS collection schemas (leads, bookings, pages, etc.)
├── components/           # Reusable React components and section modules
├── globals/              # Payload CMS global schemas (site settings, homepage, header)
├── lib/                  # CMS retrieval adapters, form handlers, and utility scripts
├── public/               # Static assets folder
│   └── media/            # Uploaded marketing assets (accessed as /media/*)
├── scripts/              # Windows PowerShell and NodeJS automation scripts
├── .cursor/
│   ├── docs/             # Canonical project documentation
│   ├── prompts/          # Natural language workflow definition files
│   ├── rules/            # Active project-level Cursor rule (.mdc) files
│   └── custom-scriptz/   # Portable local modules (google-api-proxy, backup-system)
└── TRUTH.md              # This file (Master Source of Truth Reference)
```

---

## Deployment (Hostinger)

**Live:** [https://mystudiochannel.com](https://mystudiochannel.com) · **Dev branch:** `MSC-Website-v5` · **Production:** v5.0.0 on Hostinger Node.js

| Path | When | Local command |
|------|------|----------------|
| **Zip upload** | First deploy, WordPress replacement, full refresh | Stop dev → **`npm run build`** → upload **`MyStudioChannel-deploy.zip`** via hPanel |
| **FTPS** | Day-to-day updates | **`npm run pushit:live`** |

**Critical rules:**

1. **Dependencies:** Packages imported in app/CSS/PostCSS must be in **`dependencies`** — Hostinger skips **`devDependencies`**. Audit: **`npm ls --omit=dev --depth=0`**.
2. **Package manager:** **npm** only — ship **`package-lock.json`**, not **`pnpm-lock.yaml`**.
3. **Env vars (hPanel):** `NODE_ENV`, `PAYLOAD_SECRET`, `DATABASE_URL`, `NEXT_PUBLIC_SERVER_URL`, `PAYLOAD_PUBLIC_SERVER_URL`, `RESEND_API_KEY`, `PAYLOAD_DISABLE_SHARP=true`.
4. **hPanel build:** Next.js preset, Node **22.x**, **`npm run build`**, output **`.next`**.
5. **After deploy:** Restart Node in hPanel; verify with **`npm run verify:live`** and Incognito **`/`** + **`/admin`**.

**Docs:** [HOSTINGER-DEPLOY.md](.cursor/docs/HOSTINGER-DEPLOY.md) · [DEPLOYMENT-FIXES.md](.cursor/docs/DEPLOYMENT-FIXES.md) · [Go-Live-Checklist.md](.cursor/docs/Go-Live-Checklist.md)

---

## Agent Instructions

When booting up a session, you **must** execute the following sequence:

1. **Read `TRUTH.md` first.** This is non-negotiable.
2. **Read `.cursor/docs/START-HERE.md`** to load Operator contracts andBookmarks.
3. **Execute the `"Start Project"`** natural language prompt workflow.
4. **Report environment status** (branch, git status, node version, local server health) to Jon.
5. **Never commit or push to GitHub** without explicit permission.

---

*Last Updated: 2026-06-02 (v5.0.0 live on mystudiochannel.com; MSC-Website-v5 active dev)*  
<sub>· Powered by the MyStudioChannel Media Engine</sub>
