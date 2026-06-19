# End Project - Session Closeout

## Trigger
When user says "End Project", "End Session", "Close Session", or "Session Closeout"

## Execution Steps

### Step 1: Summarize Working Changes
Based on `git status` and `git diff --name-only`, summarize:
- Files modified (group by type: components, docs, config, scripts)
- Files added
- Files deleted

### Step 2: Update Tracking Docs
Append to `.cursor/docs/project-log.md`:
```markdown
### [YYYY-MM-DD HH:MM] - Session Summary
- **Branch:** [current branch]
- **Changes:** [summary from step 1]
- **Status:** [completed / in-progress / blocked]
- **Next:** [what operator plans next session]
```

### Step 3: Git Audit
- Show `git status --porcelain`
- Note any unstaged secrets (`.env.local`, credentials) - do NOT show values
- **Reminder Note for Jon**: Remind Jon to verify or find any missing API keys (e.g., `21ST_DEV_MAGIC_API_KEY`) in `.env.local` to fully unlock pre-wired MCP servers next session.
- Ask: "Commit and push changes? (yes/no)"

### Step 4: Stop Session Stack
Run from repo root (**Local — Cursor / PC**). Uses unified teardown scripts — **agents run these commands themselves**, do not only list steps for Jon.

#### 4a. Telegram gateway (optional — may stay running overnight)
Use **`AskQuestion`** with:
- **Stop everything including Telegram gateway** (recommended for full shutdown)
- **Keep Telegram gateway running overnight** (bot stays responsive; LiteLLM/ngrok still stop)

#### 4b. Unified session stop
| Command | When |
|---------|------|
| `npm run msc:session:stop` | Operator chose **Stop everything** — Kanban (**3001**, **3005**, **9119**), Next dev (**3000**), LiteLLM + ngrok (**4000**, **4040**), Hermes Telegram gateway |
| `npm run msc:session:stop:keep-gateway` | Operator chose **Keep gateway overnight** — same as above **except** Telegram gateway stays running |

**What `stop-session-stack.ps1` does:**
1. `kanban:stop` — ports **3001**, **3005**, **9119**
2. Orphan cleanup — stale TaskBoard/Hermes `cmd.exe` shells and old WT tabs
3. `msc-kill-dev-port.mjs 3000` — Next.js dev
4. `msc-litellm-stop.mjs` — ports **4000**, **4040**, ngrok (+ gateway unless `--keep-gateway`)

| Port | Service | Action |
|------|---------|--------|
| **3001** | TaskBoardAI | Stopped via `kanban:stop` |
| **3005** | Hermes Workspace | Stopped via `kanban:stop` |
| **9119** | Hermes Dashboard | Stopped via `kanban:stop` |
| **3000** | Next.js dev | Stopped via session stop |
| **4000** | LiteLLM | Stopped via `msc-litellm:stop` |
| **4040** | ngrok inspector | Stopped via `msc-litellm:stop` |

**Kanban-only stop** (without touching LiteLLM): `npm run kanban:stop`

Report per port: **killed** / **already free** (read script output).

**Postiz (4007):** Docker stack — not stopped by End Project. To shut down: `cd D:\Hermes\postiz && docker compose down`

### Step 5: Confirm dev port clear
Step **4b** already clears port **3000**. Re-check with `netstat -ano | findstr ":3000 "` if needed.

Report what was killed vs already free.

### Step 6: Session Handoff Block
Print (replace `[…]` with live values):

```
-------------------------------------------------------------------------------
✅ SESSION CLOSEOUT — [YYYY-MM-DD HH:MM]
-------------------------------------------------------------------------------

📦 SESSION WRAP-UP
   📝 Changes logged……… project-log.md
   🔧 Git………………… [clean | pending commit/push]
   🛑 Services stopped…… Kanban (3001, 3005, 9119), Next dev (3000), LiteLLM + ngrok (4000, 4040)
   📡 Telegram gateway…… [stopped | left running overnight]
   🐳 Postiz (4007)……… [still running in Docker | stopped manually]

📁 PROJECT
   🌿 Branch……………… [current branch]

-------------------------------------------------------------------------------
✅ Goodbye, Jon. See you next session.
-------------------------------------------------------------------------------

Cold-start pointer: Say "Start Project" to begin next session.
```

## Important Rules
- NEVER commit without explicit operator approval
- NEVER force push unless operator confirms
- NEVER log secret values - reference only variable names
- **Agents:** run `npm run msc:session:stop` (or `:keep-gateway`) yourself from repo root — do not only list steps for Jon
