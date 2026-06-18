# MyStudioChannel Visual Kanban & Developer Management Stack

This guide documents the architecture, directory mapping, port allocations, and unified startup/teardown commands for the **MyStudioChannel Visual Kanban and Developer Management Stack**.

---

## 🗺️ Workstation Folder & Service Mapping

All master development services are compartmentalized under the **`D:\Hermes\`** workspace directories:

| Tool / Service | Local Repository Path | Port | Active URL | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **TaskBoardAI** | `D:\Hermes\TaskBoardAI` | **`3001`** | [http://localhost:3001/](http://localhost:3001/) | Premium cinematic visual planning console (reads board JSON from project repo). |
| **Hermes Workspace** | `D:\Hermes\hermes-workspace` | **`3005`** | [http://localhost:3005/](http://localhost:3005/) | Visual developer Kanban dashboard with automated state controllers. |
| **Hermes Gateway WebAPI** | Built-in | **`8642`** | — | Native background service routing CLI requests and state changes. |
| **Hermes Embedded Dashboard** | Built-in | **`9119`** | [http://localhost:9119/](http://localhost:9119/) | Active embedded gateway log console. |
| **Postiz Self-Hosted** | `D:\Hermes\postiz` | **`4007`** | [http://localhost:4007/](http://localhost:4007/) | Multi-platform social outbox auto-posting hub. |
| **MyStudioChannel Dev App** | `D:\Cursor_Projectz\MyStudioChannel` | **`3000`** | [http://localhost:3000/](http://localhost:3000/) | Your Next.js 15 local dev server and Payload CMS 3 Admin panel. |

---

## ⌨️ 1-Command Developer Shortcuts (MyStudioChannel Root)

We have pre-configured native PowerShell automation hooks inside your project. You can run these directly from the MyStudioChannel repo folder in Cursor:

### 🟢 1. Spin Up the Entire Visual Stack
Runs TaskBoardAI, Hermes Workspace, and Hermes Dashboard as **hidden background processes** (no command-window clutter):
```bash
npm run kanban
```

**Full session start** (LiteLLM + ngrok + Kanban — used by **Start Project**):
```bash
npm run msc:session:start
```

### 🔴 2. Cleanly Teardown All Ports
Gracefully terminates Kanban ports (3001, 3005, 9119):
```bash
npm run kanban:stop
```

**Full session stop** (Kanban + Next dev + LiteLLM + ngrok — used by **End Project**):
```bash
npm run msc:session:stop
```
Keep Telegram gateway overnight: `npm run msc:session:stop:keep-gateway`

---

## 🔗 How Everything Connects Behind the Scenes

```
┌────────────────────────────────────────────────────────────────────────┐
│                        MyStudioChannel Workstation                      │
└────────────────────────────────────────────────────────────────────────┘
                                    │
         ┌──────────────────────────┼──────────────────────────┐
         ▼                          ▼                          ▼
 ┌───────────────┐          ┌───────────────┐          ┌───────────────┐
 │ Next.js App   │          │  TaskBoardAI  │          │    Hermes     │
 │  (Port 3000)  │          │  (Port 3001)  │          │  (Port 3005)  │
 └───────────────┘          └───────────────┘          └───────────────┘
                                    │                          │
                                    ▼                          ▼
                         Direct Real-time Sync      Native Direct Access
                        ┌────────────────────────────────────────┐
                        │   Hermes Multi-Board SQLite Database   │
                        │ `...\boards\msc-website-v9\kanban.db`  │
                        └────────────────────────────────────────┘
                                    ▲
                                    │ Bidirectional Sync
                                    ▼
                        ┌────────────────────────────────────────┐
                        │    Project Master Board JSON file      │
                        │ `.cursor/boards/msc-website-v9.json`   │
                        └────────────────────────────────────────┘
```

1.  **Direct SQLite Synchronization & Unity:** Both TaskBoardAI and Hermes Workspace are bound in lockstep to your active Hermes Multi-Board SQLite database at:
    `C:\Users\JONBEATZ\AppData\Local\hermes\kanban\boards\msc-website-v9\kanban.db`
    They read and write task states (statuses, titles, descriptions, assignments, dates) to this single source of truth.
2.  **Shared Storage JSON Link:** TaskBoardAI maintains bidirectional synchronization by writing task updates back to your local repository planning board JSON file inside your codebase at:
    `D:\Cursor_Projectz\MyStudioChannel\.cursor\boards\msc-website-v9.json`
    This ensures any changes are tracked as local Git adjustments inside your main project.
3.  **Direct Node.js SQLite compiler (Resilience):** Hermes Workspace (Port 3005) is equipped with a direct compilation engine utilizing Node.js 22+'s native `node:sqlite` module synchronously. This eliminates dependencies on the `sqlite3` CLI executable on Windows, allowing it to load tasks instantly with zero lag, even when the Python dashboard (Port 9119) is offline.
4.  **Multi-Board Binding via KANBAN_BOARD:** We configured Hermes Workspace (`hermes-workspace/.env`) with `KANBAN_BOARD=msc-website-v9` to bind its local-fallback queries directly to your active multi-board project database instead of the legacy global fallback.
5.  **Active J.A.R.V.I.S. Indicators:** The TaskBoardAI is styled using the custom **Studio Gold `#F5B841`** glassmorphic branding, with active waveforms reflecting local AI status on Port 1234, complete with active port monitors displaying whether your services are online or offline on the fly.

---

## 🩹 Teardown & End Project Integration
To ensure complete system hygiene when closing a session, the stop commands are hooked directly into your **End Project (Item 40)** sequence. Running the final closeout automatically frees up all memory and ports, keeping your workstation light and optimized for gaming or other processing tasks!
