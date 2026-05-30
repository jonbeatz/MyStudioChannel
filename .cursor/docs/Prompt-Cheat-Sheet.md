# Prompt & Custom Commands Cheat Sheet

This is your ongoing reference guide for all custom developer prompts, workflows, and session commands configured for the **MyStudioChannel** project. 

Whenever you create or adapt workflows, update this cheat sheet so you always have an accurate, ready-to-use list.

---

## 🚀 Unified Commands (Session Workflows)

These commands are bound to automated workflows inside `.cursor/prompts/` and are coordinated by `.cursor/rules/workflow.mdc`.

| Command / Phrase | Action | File Location | Expected Behavior |
|:---|:---|:---|:---|
| **`"Start Project"`** <br>*(or "Begin Project", "Start Session", "Cold Start")* | Cold-start handshake | `.cursor/prompts/Start-Project.md` | Loads `README.md`, `START-HERE.md`, `project-log.md`, `Checkpoint.md`; performs node preflight; checks git status; asks to start Google API; prints start handshake. |
| **`"End Project"`** <br>*(or "End Session", "Close Session", "Session Closeout")* | Session closeout & cleanup | `.cursor/prompts/End-Project.md` | Summarizes changed/added/deleted files; logs session to `project-log.md`; performs Git audit; stops local services (dev server, LiteLLM) and cleans ports; prints closeout block. |
| **`"update docs"`** | Documentation sync & audit | `.cursor/prompts/Update-Docs.md` | Scans documents for outdated paths, names, and contradictions; synchronizes version info; logs bug fixes into `ISSUES-RESOLVED.md`; commits and pushes documentation changes. |
| **`"Update Project"`** <br>*(or "Sync Project")* | Git-to-docs tracker sync | `.cursor/prompts/Update-Project.md` | Reads recent git logs (last 10 commits) and file diffs; appends updates to `project-log.md`; updates dates, versions, and milestones in `Checkpoint.md`. |
| **`"backup project"`** | Interactive/Non-interactive backups | `.cursor/custom-scriptz/backup-system/CURSOR.md` | Initiates the backup system. Runs standard or full backups with custom notes, git meta tracking, and exports to `G:\Cursor_Project_BackUpz\MyStudioChannel`. |

---

## 📡 API Tunnels & Proxies

For AI development, API testing, and model integrations.

| Command / Phrase | Action | Underlying Command | Expected Outcome |
|:---|:---|:---|:---|
| **`"start google-api"`** | Start LiteLLM Vertex AI proxy + ngrok | `npm run msc:google-api:start` | Stops any current LiteLLM instance, starts LiteLLM on port `4000` mapped to Vertex AI, and initializes a secure public ngrok tunnel. |
| **`"verify google-api"`** | Test proxy tunnel connections | `npm run msc:litellm:test:ngrok` | Verifies LiteLLM connection status, checks ngrok health, and outputs active URL endpoints. |
| **`"stop google-api"`** | Stop LiteLLM proxy | `npm run msc:litellm:stop` | Safely kills the active LiteLLM python and proxy processes on port 4000. |

---

## 📦 Hostinger Deployment (Tiered FTPS)

Use these commands for deploying to Hostinger (hPanel/shared hosting) from your PC terminal.

| Command / Phrase | Action | Script Run | Scope |
|:---|:---|:---|:---|
| **`"Push my branding"`** | Tier 1 Fast FTP (Look & Feel only) | `npm run pushitup:admin-branding` | Uploads CSS/SCSS and admin panel layouts only (`custom.scss`, custom admin components, `Users.ts`). Fast, no build step. |
| **`"Lets Push It Live"`** | Tier 2 Full Production Sync | `npm run pushit:live` | Triggers Next.js build; uploads compiled `.next/`, local SQLite `payload.sqlite` database, and uploaded media to `/public_html/`. Requires live App stopping first. |
| **`"Push server config"`** | Tier 3 Server/Node Contract | `npm run pushitup:server-config` | Syncs `server.js`, `package.json`, `package-lock.json`, and `.env.example`. Required after changing dependencies. |
| **`"Lets test FTP"`** | Read-Only FTP connection smoke | `npm run test:hostinger-ftp` | Validates FTPS credentials and folder permissions by executing a read-only LIST of `/public_html/`. |

---

## 🛠️ Environment Recovery & Diagnostics

Use these prompts when things break or localhost goes down.

| Command / Phrase | Action | Core Solution | Probes Run |
|:---|:---|:---|:---|
| **`"Fix Local"`** | Recover broken localhost server | `npm run dev:recover` <br>*(or `npm run repair:dev` for complete rebuild)* | Stops any process on port 3000, wipes Next cache files, spins up fresh dev server, and runs local smoke curls. |
| **`"Take a snapshot"`** | Fast checkpoint creation | Guides you to create `Restore-Points.md` | Stages local documentation updates, commits with active branch/SHA details, and generates branch recovery steps. |
| **`"Clean my folders"`** | Consolidate stray media | `npm run media:consolidate` | Cleans up workspace by moving media files scattered outside of `public/media/`. |
| **`"Sync my media"`** | Rebuild media DB registration | `npm run media:sync` | Scans `public/media/` and automatically populates database tables to register local images in Payload CMS. |

---

*Last Updated: 2026-05-30*  
<sub>· Powered by the MSC Media Engine</sub>
