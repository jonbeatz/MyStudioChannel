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

### Step 4: Close Kanban Stack Services
Run from repo root (**Local — Cursor / PC**). Kill Kanban UI ports, stop LiteLLM + ngrok, and optionally leave the Telegram gateway running overnight.

#### 4a. Kill Kanban stack ports
```powershell
# Kill all Kanban stack ports (TaskBoardAI 3001, Workspace 3005, Dashboard 9119)
$ports = @(3001, 3005, 9119)
foreach ($port in $ports) {
    $pids = netstat -ano | findstr ":$port " | findstr "LISTENING" | ForEach-Object { ($_ -split '\s+')[-1] } | Select-Object -Unique
    foreach ($processId in $pids) {
        if ($processId -match '^\d+$') { taskkill /PID $processId /F 2>$null }
    }
}
```

| Port | Service | Action |
|------|---------|--------|
| **3001** | TaskBoardAI | Kill the Node process |
| **3005** | Hermes Workspace | Kill the `pnpm dev` / Node process |
| **9119** | Hermes Dashboard | Kill the dashboard process |

Report per port: **killed** / **already free**.

#### 4b. Orphan Hermes Workspace cleanup
If any Kanban port is still listening after **4a**, find and kill orphaned workspace processes:
```powershell
Get-CimInstance Win32_Process -Filter "Name = 'node.exe'" -ErrorAction SilentlyContinue |
  Where-Object { $_.CommandLine -match 'hermes-workspace' } |
  ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
```
Re-check **3001**, **3005**, **9119** and report.

#### 4c. Telegram gateway (optional — may stay running overnight)
Use **`AskQuestion`** with:
- **Stop Telegram gateway** (recommended for full shutdown)
- **Keep gateway running overnight** (bot stays responsive; LiteLLM/ngrok still stop below)

#### 4d. Stop LiteLLM + ngrok (ports 4000, 4040)
| Port | Service | Action |
|------|---------|--------|
| **4000** | LiteLLM | Stopped via `msc:litellm:stop` |
| **4040** | ngrok inspector | Stopped via `msc:litellm:stop` |

- If operator chose **Stop Telegram gateway**: run `npm run msc:litellm:stop` (includes `hermes gateway stop` on Windows).
- If operator chose **Keep gateway running overnight**: run LiteLLM/ngrok cleanup only — kill ports **4000** and **4040** and ngrok processes (`node scripts/msc-kill-dev-port.mjs 4000`, `node scripts/msc-kill-dev-port.mjs 4040`, plus ngrok kill from `scripts/lib/msc-ngrok-utils.mjs` pattern in `msc-litellm-stop.mjs`) — **do not** run `hermes gateway stop`.

Report what each sub-step found (process killed vs already free).

### Step 5: Stop Next.js dev (port 3000)
Run from repo root:
- If operator chose **Stop Telegram gateway** in **4c**: `npm run msc:session:stop` (clears **3000**, **4000**, **4040**, ngrok, and Hermes gateway).
- If operator chose **Keep gateway running overnight**: `npm run msc:kill-dev-port` only (clears **3000**; gateway + partial LiteLLM cleanup from **4d** unchanged).

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
   🛑 Services stopped…… Next dev (3000), Kanban (3001, 3005, 9119), LiteLLM + ngrok (4000, 4040)
   📡 Telegram gateway…… [stopped | left running overnight]

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
- **Agents:** run Kanban port kills and shutdown commands yourself from repo root — do not only list steps for Jon
