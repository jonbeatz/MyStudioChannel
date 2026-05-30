# Prompt & Custom Commands Cheat Sheet

This is your ongoing reference guide for all custom developer prompts, workflows, and session commands configured for the **MyStudioChannel** project. 

Whenever you create or adapt workflows, update this cheat sheet so you always have an accurate, ready-to-use list.

---

## 🚀 Unified Commands (Session Workflows)

These commands are bound to automated workflows inside `.cursor/prompts/` and are coordinated by `.cursor/rules/workflow.mdc`.

### ➡️ `"Start Project"`  
*Alternative phrasings: `"Begin Project"`, `"Start Session"`, `"Cold Start"`*
- **Action:** Cold-start handshake ritual.
- **Workflow File:** `.cursor/prompts/Start-Project.md`
- **Expected Behavior:** 
  1. Automatically reads critical files (`README.md`, `START-HERE.md`, `project-log.md`, `Checkpoint.md`).
  2. Runs lightweight preflight node/git environment checks.
  3. Optionally prompts to start the Google API / LiteLLM proxy.
  4. Outputs a beautiful, green session start handshake.

### ➡️ `"End Project"`  
*Alternative phrasings: `"End Session"`, `"Close Session"`, `"Session Closeout"`*
- **Action:** Session closeout & cleanup.
- **Workflow File:** `.cursor/prompts/End-Project.md`
- **Expected Behavior:** 
  1. Identifies and summarizes modified, added, and deleted files.
  2. Appends logs to `.cursor/docs/project-log.md`.
  3. Runs a Git audit and asks if you would like to commit and push.
  4. Cleans up ports (kills dev server on `3000` and LiteLLM on `4000`).
  5. Outputs goodbye handshake.

### ➡️ `"update docs"`  
- **Action:** Documentation sync & audit.
- **Workflow File:** `.cursor/prompts/Update-Docs.md`
- **Expected Behavior:** 
  1. Scans project folders for outdated paths, names, and contradictions.
  2. Synchronizes version info.
  3. Logs bug fixes and temporary changes to `ISSUES-RESOLVED.md`.
  4. Automatically stages, commits, and pushes doc updates.

### ➡️ `"Update Project"`  
*Alternative phrasings: `"Sync Project"`*
- **Action:** Git-to-docs tracker sync.
- **Workflow File:** `.cursor/prompts/Update-Project.md`
- **Expected Behavior:** 
  1. Reads git logs and diffs.
  2. Automatically syncs milestone dates, versions, and lists inside `project-log.md` and `Checkpoint.md`.

### ➡️ `"backup project"`  
- **Action:** Interactive/Non-interactive standard & full backups.
- **Module File:** `.cursor/custom-scriptz/backup-system/CURSOR.md`
- **Expected Behavior:** 
  1. Guides you through Type, Destination, Folder, and custom note steps.
  2. Packages files and exports them safely to `G:\Cursor_Project_BackUpz\MyStudioChannel`.

---

## 📡 API Tunnels & Proxies

For AI development, API testing, and model integrations.

### ➡️ `"start google-api"`  
- **Action:** Start LiteLLM Vertex AI proxy + ngrok tunnel.
- **Script Command:** `npm run msc:google-api:start`
- **Expected Outcome:** Launches LiteLLM on port `4000` mapped to Vertex AI and mounts an active public HTTPS ngrok tunnel.

### ➡️ `"verify google-api"`  
- **Action:** Test proxy tunnel connections.
- **Script Command:** `npm run msc:litellm:test:ngrok`
- **Expected Outcome:** Tests endpoint connections and lists the active tunnel URLs for Cursor.

### ➡️ `"stop google-api"`  
- **Action:** Stop active proxy instance.
- **Script Command:** `npm run msc:litellm:stop`
- **Expected Outcome:** Safely terminates the Python LiteLLM proxy process on port `4000`.

---

## 📦 Hostinger Deployment (Tiered FTPS)

Commands for deploying code changes to Hostinger from your PC terminal.

### ➡️ `"Push my branding"`  
- **Action:** Tier 1 Fast FTP (Look & Feel only).
- **Script Command:** `npm run pushitup:admin-branding`
- **Scope:** Uploads SCSS and admin graphics files (`custom.scss`, `Users.ts`, admin components). No full build step. Followed by hPanel Node app restart.

### ➡️ `"Lets Push It Live"`  
- **Action:** Tier 2 Full Production Sync.
- **Script Command:** `npm run pushit:live`
- **Scope:** Builds Next.js; uploads `.next/` bundle, SQLite `payload.sqlite` database, and `public/media/` to `/public_html/`. Requires live app stopping first. Followed by hPanel Node app restart.

### ➡️ `"Push server config"`  
- **Action:** Tier 3 Server/Node Contract.
- **Script Command:** `npm run pushitup:server-config`
- **Scope:** Syncs `server.js`, `package.json`, and `.env.example`. Followed by server-side `npm install` and hPanel restart.

### ➡️ `"Lets test FTP"`  
- **Action:** Read-Only FTP connection smoke test.
- **Script Command:** `npm run test:hostinger-ftp`
- **Scope:** Runs a quick READ-ONLY LIST of the remote directory to check FTPS logins and paths.

---

## 🛠️ Environment Recovery & Diagnostics

Troubleshooting and maintenance triggers when things break.

### ➡️ `"Fix Local"`  
- **Action:** Local dev recovery.
- **Script Command:** `npm run dev:recover` *(or `npm run repair:dev` for complete rebuild)*
- **Expected Outcome:** Kills stale node listeners, clears Next.js caches, restarts dev server on port `3000`, and probes local URLs to ensure 200 OK.

### ➡️ `"Take a snapshot"`  
- **Action:** Milestone checkpointing.
- **Expected Outcome:** Updates local documentation files, summarizes progress, commits, and creates a recovery branch for rollback safety.

### ➡️ `"Clean my folders"`  
- **Action:** Consolidate stray media.
- **Script Command:** `npm run media:consolidate`
- **Expected Outcome:** Moves files outside `public/media/` back into their correct structured folders.

### ➡️ `"Sync my media"`  
- **Action:** Bulk Media Database sync.
- **Script Command:** `npm run media:sync`
- **Expected Outcome:** Scans `public/media/` and automatically registers physical files as database rows in Payload CMS, bypassing Alt text constraints.

---

*Last Updated: 2026-05-30*  
<sub>· Powered by the MSC Media Engine</sub>
