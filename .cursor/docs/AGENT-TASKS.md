# J.A.R.V.I.S. Kanban Workflow Automation: Manual + Auto Agent Suite

This guide documents the architecture, database synchronizers, direct actuators, commands, and routing pipelines for the **MyStudioChannel Autonomous Task Dispatcher and Executor Suite**.

---

## 🗺️ Architectural Mapping

All task management and dispatcher operations are synchronized bidirectionally across your physical PC workstation's SQLite store and local repository files:

| File / Component | Workspace Path | Purpose |
| :--- | :--- | :--- |
| **Orchestration Core** | `.cursor/custom-scriptz/agent-tasks/task-executor.js` | Direct Node.js scheduler, database listener, router, and Telegram notifier. |
| **State Registry** | `.cursor/custom-scriptz/agent-tasks/state.json` | Local cache holding execution modes (`manual` or `auto`), active PID locks, and approvals. |
| **Visual Board JSON** | `.cursor/boards/msc-website-v9.json` | TaskBoardAI layout config file synchronized reactively. |
| **Primary SQLite DB** | `%LOCALAPPDATA%\hermes\kanban\boards\msc-website-v9\kanban.db` | Master transaction-safe database (SQLite 3) serving as single source of truth. |
| **Hermes Credentials** | `%LOCALAPPDATA%\hermes\.env` | Global configurations storing bot authentication tokens and chat channels. |

---

## ⚙️ 1. Dual Mode Operations

The dispatcher is configured with two distinct operation states, defaulting to a safety-first **Manual Mode**:

```
                  ┌──────────────────────────────┐
                  │ Task Moved to Ready Column   │
                  └──────────────┬───────────────┘
                                 │
                                 ▼
                     Suggested Agent Identified
                   (e.g., #code -> coder agent)
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
         [ MANUAL MODE ]                  [ AUTO MODE ]
        (Default Safety-First)           (Full Autonomy)
                 │                               │
                 ▼                               ▼
       Telegram Alert Sent             Task Status: In Progress
      "Awaiting operator approve"       Agent logs thinking steps
                 │                               │
        Operator commands:                       ▼
      "approve" or "assign"            Task executed via scripts
                 │                               │
                 ▼                               ▼
       Task Status: In Progress           Task Status: Done
                 │                               │
                 └───────────────┬───────────────┘
                                 ▼
                    Telegram Completion Post &
                     Rich Board Status Comments
```

### 🟡 Manual Mode (Default State)
- When a task enters the **Ready** column, the system reads its contents and suggests the optimal agent profile.
- A **Telegram notification** and a **system comment** are posted, asking for your approval.
- Execution is completely gated; the agent will not touch any files or run any command line triggers until you explicitly authorize it.

### 🟢 Auto Mode
- Tasks in the **Ready** column are automatically claimed by their routed agents.
- The system immediately updates status fields to **`in_progress`** and publishes progress comments.
- Actuators run physical workstation commands in real-time (e.g. Next.js compiler checks, ComfyUI render pipelines, directory audits).
- Results are pushed live to Telegram and finalized in the **Done** or **Blocked** columns.

---

## 🎯 2. Smart Tag Routing Matrix

Tasks are routed instantly to the corresponding developer profile by scanning the card’s native tags (TaskBoardAI metadata) and contents:

| Tag Indicator | routed Profile | Assigned Agent Responsibilities & Actuators |
| :--- | :--- | :--- |
| **`#code`** / `coder` | **`coder`** | Modifies files, fixes bugs, checks lints, runs Next.js builds (`npm run verify:next:safe`). |
| **`#research`** / `find` | **`researcher`** | Conducts web lookups, summarizes documentation guides, drafts technical schemas. |
| **`#creative`** / `design` | **`creative`** | Drives local Stable Diffusion/FLUX, loads VAEs, triggers render test loops (`test-comfyui-workflows.ps1`). |
| **`#deploy`** / `live` | **`msc`** | Orchestrates deployment preflights, handles FTPS pushes, and triggers remote node recovery. |

*If a task does not contain any of these hashtags or keywords, the orchestrator alerts you on Telegram asking for manual mapping.*

---

## 💬 3. J.A.R.V.I.S. Command Reference

You can pass command strings directly to the orchestrator to alter routing parameters, change execution modes, or authorize tasks:

| Command | Action Description | Telegram Feedback |
| :--- | :--- | :--- |
| **`go auto`** / `resume` | Unlocks full autonomous mode. Ready tasks execute immediately. | 🟢 "Mode Swapped to AUTO MODE." |
| **`go manual`** / `pause` | Freezes the dispatcher. Tasks are safely gated waiting for approval. | 🟡 "Mode Swapped to MANUAL MODE." |
| **`run all ready`** | Overrides approval and executes all tasks currently in the Ready column. | 🚀 "Executing all ready tasks immediately..." |
| **`status`** / `what's next?` | Lists active tasks, ready tasks, and suggested profiles. | 📊 Detailed status rundown report. |
| **`approve [taskId]`** | Approves the suggested agent and starts execution of that task. | ✅ "Task approved for execution." |
| **`assign [taskId] to [agent]`** | Overrides routing and forces execution under the specified agent. | 🎯 "Task manually reassigned and approved." |
| **`skip [taskId]`** | Bypasses task and moves card back to the Backlog. | ⏮️ "Task returned to Backlog column." |
| **`take over [taskId]`** | Safely unassigns the agent and moves execution to you (`user` assignee). | 👤 "Task is now being handled manually." |

---

## 🚀 4. Triggering the Automation Suite

To run the background task-executor daemon alongside your existing visual board ports:

### 🟩 Start the Polling Daemon
To spin up the polling listener (watches your board every 10 seconds):
```powershell
node .cursor/custom-scriptz/agent-tasks/task-executor.js --daemon
```

### 💬 Issue Ad-Hoc Commands
To pass an instant command line instruction (e.g. while working in chat):
```powershell
node .cursor/custom-scriptz/agent-tasks/task-executor.js --cmd "go auto"
node .cursor/custom-scriptz/agent-tasks/task-executor.js --cmd "approve t_cc0c3355"
node .cursor/custom-scriptz/agent-tasks/task-executor.js --cmd "status"
```

---

## 🛡️ 5. Error Self-Healing & Safety Gates
1. **Double-Attempt Retry:** If an actuator or script command fails on a task, the executor logs the error, posts a Telegram retry alert, resets the active PID lock, and retries once on the next interval.
2. **Auto-Blocked Escapes:** If a task fails on the second attempt, it is moved to the `Blocked` column, a detailed error traceback is appended as a card comment, and a priority alarm is pushed to your Telegram.
3. **Transaction Locking:** Active locks (`state.json` registry) prevent multiple loops from double-claiming or duplicating executions, ensuring complete thread safety.
