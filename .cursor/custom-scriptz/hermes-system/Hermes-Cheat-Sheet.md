# 🎙️ J.A.R.V.I.S. Powered Development Suite (Hermes Cheat Sheet)

This is the ultimate reference guide for your local J.A.R.V.I.S. powered development suite, integrating advanced neural text-to-speech, local vector memory layers, model lifecycle daemons, serverless image generation, and fully automated build-safety pipelines.

---

## 🎙️ 1. Voice & TTS Commands

Your PowerShell profile features a dual-mode conversational routing layer that speaks literally or redirects questions to your local LLM (via Hermes).

### 💬 Basic Controls
*   `speak "<literal text>"` — Synthesizes and reads text out loud immediately using your active neural voice.
    ```powershell
    speak "Welcome back Jon. All systems are fully operational."
    ```
*   `speak "<AI prompt/question>"` — Automatically detects if the sentence starts with an AI query keyword (e.g., *how*, *what*, *why*, *tell*, *generate*). It sends the query to the local LLM proxy, prints the text response, and speaks it out loud!
    ```powershell
    speak "what does git status do?"
    ```
*   `test-voice "<text>"` — Silent voice diagnostics (synthesizes audio without standard terminal logging).

### 🎙️ Default Neural Voices
Switch your active speaking voice on the fly using these profile shortcuts:

| Command | Provider | Voice Name / Type | Accent / Gender |
|---------|----------|-------------------|-----------------|
| `set-voice-ryan` | Edge (Free) | `en-GB-RyanNeural` | British Male (Default J.A.R.V.I.S.) |
| `set-voice-sonia` | Edge (Free) | `en-GB-SoniaNeural` | British Female |
| `set-voice-andrew` | Edge (Free) | `en-US-AndrewMultilingualNeural` | American Male |
| `set-voice-orus` | Gemini (Premium) | `Orus` | Premium Deep Neural Male |
| `set-voice-charon` | Gemini (Premium) | `Charon` | Premium Dark/Sleek Male |
| `set-voice-zephyr` | Gemini (Premium) | `Zephyr` | Premium Whisper/Smooth |
| `set-voice-kore` | Gemini (Premium) | `Kore` | Premium Deep Warm Male |

### 🛡️ Auto-Fallback System
If your premium Gemini/Orus API limits are exceeded or hit a network timeout, J.A.R.V.I.S. automatically triggers a seamless fallback:
1.  Detects the API exception silently.
2.  Switches the active provider configuration to Sonia (Edge TTS).
3.  Reads your text without failing.
4.  Restores your primary Orus/Gemini voice settings automatically.

---

## 🧠 2. Local Memory Layer (Mem0)

Your workspace features a local long-term memory layer that persists context, user preferences, and project states across chat sessions.

### 💾 Memory Commands
*   `remember "<fact or preference>"` — Extracts semantic facts from your input using local LLM reasoning and stores them in your vector database.
    ```powershell
    remember "I prefer widescreen 1920x1080 images for header backgrounds"
    ```
*   `recall "<search query>"` — Performs a cosine-similarity search across your memory banks and speaks the extracted facts.
    ```powershell
    recall "header backgrounds"
    ```

### ⚙️ Architecture under the hood
*   **Vector Database:** Local Qdrant server running inside your home folder (`~/.mem0/qdrant`).
*   **Embedding Model:** Local `multi-qa-MiniLM-L6-cos-v1` via Hugging Face `sentence-transformers` (runs entirely on your local CPU).
*   **Reasoning Engine:** Local Qwen 4B GGUF running inside your LM Studio endpoint.

---

## 💻 3. LM Studio Model Management

Your system features native CLI model switching and an autonomous VRAM background daemon to keep your computer's resources fast and clean.

### 🔌 Model Switcher Shortcuts
*   **Model switchers** — `list-models` shows all shortcuts; load by nick or task:
    *   `load-qwen4` / `load-qwen` — default fast (`qwen3-4b-instruct-2507`)
    *   `load-qwen9` — smarter local chat (`qwen3.5-9b`)
    *   `load-coder14` — local coding, 16GB sweet spot
    *   `load-deepseek33` / `load-deepseek` — heavy coder test
    *   `load-r1` — step-by-step reasoning
    *   `load-arsenic` — creative writing
    *   `load-model code` · `smart` · `reason` · `creative` · `fast` — task aliases
    *   `unload-model` · `model-status`
*   `unload-model` — Purges and unloads all models from VRAM immediately.
*   `model-status` — Displays currently active loaded models and their allocations.

### ⏱️ VRAM Idle Auto-Unload Daemon
To optimize local compilation and Next.js HMR speeds, the background daemon `scripts/vram-idle-manager.ps1` (copied to repo `scripts/` on install) monitors loaded models:
*   **14 Minutes Idle:** Speaks a warning: *"Warning: Model has been idle for fourteen minutes and will be unloaded shortly to conserve VRAM."*
*   **15 Minutes Idle:** Automatically unloads all models and speaks: *"Model auto unloaded to free up system VRAM."*

#### Daemon Controls:
*   `vram-daemon-start` — Spawns the monitor as a silent, background PowerShell Job.
*   `vram-daemon-stop` — Kills and cleans up the active background job.
*   `vram-status` — Prints active loaded models, configuration overrides, last activity timestamp, and exact idle durations.
*   `vram-unload` — Immediately purges loaded models manually.
*   `keep-model-on` — **Override:** Disables auto-unload (holds loaded models in VRAM indefinitely).
*   `keep-model-off` — **Override:** Restores the 15-minute auto-unload safety loop.

### 🎮 Emergency VRAM Cleanup (GPU reset switch)

When LM Studio **and** idle ComfyUI both hold CUDA memory, total VRAM can hit **90%+** while the LM Studio UI still shows a small model. On Windows WDDM, trust **`nvidia-smi` total used**, not per-process `N/A` lines.

**Use when:** VRAM **>80%**, after ComfyUI/LM Studio **crash** with stuck memory, or **before Flux/heavy work** if VRAM **>65%** and nothing is generating.

**Do not use when:** VRAM **<65%**, a model is **actively generating**, or mid long-running task.

| Trigger | Command |
|---------|---------|
| Script (Local) | `powershell -File .cursor/custom-scriptz/vram-cleanup.ps1` |
| Pre-flight | `powershell -File .cursor/custom-scriptz/vram-check.ps1` |
| Dev HUD | `http://localhost:3000` → hover SystemStats → **Emergency VRAM cleanup** |
| Full playbook | **`.cursor/docs/VRAM-TROUBLESHOOTING.md`** |

### 🖼️ ComfyUI VRAM Control (explicit start/stop)

ComfyUI **must not** auto-start with the dev stack. High VRAM with ComfyUI "off" in the old HUD was a **state detection bug** (port 8188 vs python Path on WDDM) — fixed 2026-06-18.

| Trigger | Command |
|---------|---------|
| Start ComfyUI | `npm run msc:comfy:start` or HUD **Start** |
| Stop ComfyUI only (keep LM Studio) | `npm run msc:comfy:stop` or HUD **Stop** |
| Restart | `npm run msc:comfy:restart` or HUD **Restart** |
| Status JSON | `npm run msc:comfy:status` |
| Full diag | `npm run msc:vram:diag` |
| Profile aliases | `comfy-start` · `comfy-stop` · `comfy-restart` (requires `$env:MSC_COMFYUI_AUTO_START='1'` for auto in `Invoke-ComfyPrompt`) |
| Audit log | `logs/comfyui.log` (500-line rotation) |
| Models + SD 1.5 restore | **`.cursor/docs/COMFYUI-MODELS.md`** |

**HUD states:** stopped · idle · generating · unknown (gold during boot). Queue shown as `(running: X, pending: Y)`.

---

## 🎨 4. Free AI Image Generation Pipeline (FLUX.1)

Generate photorealistic, high-resolution visual assets directly from your command line with **0% local GPU and VRAM load**!

### 🖌️ Generation Shortcuts
*   `gen-image "<prompt>"` — Generates a pristine 1024x1024 PNG and saves it to `public/media/generated-[timestamp].png` with automatic Windows photo viewer startup.
    ```powershell
    gen-image "A professional studio microphone, gold accents, photorealistic"
    ```
*   `gen-image "<prompt>" -Path "<custom_path>" -Width <w> -Height <h>` — Generates an image with custom dimensions (e.g. 1920x1080 landscape, or 1080x1920 vertical) and saves to a specific filename:
    ```powershell
    gen-image "Modern tv studio set, photorealistic" -Path "public/media/my-tv-studio.png" -Width 1920 -Height 1080
    ```

### 🗣️ Conversational Chat Triggers
You can trigger the entire image generation pipeline inside your natural language `speak` commands! J.A.R.V.I.S. automatically intercepts the request, strips the conversational prefixes, detects widescreen variables, and launches the generator:
```powershell
speak "make me an HD background image of a video camera filming a tv show"
```
*Auto-extracts prompt:* `image of a video camera filming a tv show`
*Auto-detects aspect ratio:* `HD` -> `1920x1080`
*Action:* Auto-downloads, saves to media folder, speaks confirmation, and opens on your screen!

---

## 🔄 5. Project & Dev Automation

### 🚀 Daily Start Project Workflow (`Start Project`)
Say **Start Project** in Cursor (or run locally):

```powershell
npm run msc:session:start
```

Unified stack (one command):
1. **LiteLLM** on port **4000** + **ngrok** tunnel (Cursor **Override OpenAI Base URL**)
2. **Hermes Telegram gateway** (hidden; no Windows logon popup)
3. **Kanban stack** — TaskBoardAI (**3001**), Hermes Workspace (**3005**), Dashboard (**9119**) as hidden background processes

**Partial stack:**
| Command | Scope |
|---------|--------|
| `npm run msc:google-api:start-session` | LiteLLM + ngrok + gateway only (no Kanban) |
| `npm run kanban` | Kanban ports only |

**End Project:** `npm run msc:session:stop` stops Kanban + Next dev (**3000**) + LiteLLM/ngrok + gateway. Use `msc:session:stop:keep-gateway` to leave Telegram running overnight.

**Cold boot:** Say **Start Project** in Cursor — no voice/TTS in the launcher step. Manual gateway: `hermes gateway install --no-start-on-login --start-now`.

### 📱 Telegram Gateway (Hermes from phone)

| Command | Purpose |
|---------|---------|
| `hermes gateway setup` | First-time: @BotFather token + @userinfobot user ID |
| `hermes gateway status` | Confirm gateway running |
| `hermes gateway install --no-start-on-login --start-now` | Start Telegram gateway without logon auto-start (also runs from Start Project) |
| `hermes gateway stop` | Stop gateway (**End Project** — optional; operator may keep overnight) |

Config file: **`%LOCALAPPDATA%\hermes\.env`** — keys `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`. Verified **2026-06-15**.

### 🖥️ Hermes Desktop App + Jon’s desktop shortcuts

| Shortcut | Script / action |
|----------|-----------------|
| **Start-Google-API-v2** | `scripts/start-google-api-desktop.ps1` — one window LiteLLM + hidden ngrok |
| **Stop-Google-API** | `scripts/stop-msc-session-desktop.ps1` → `npm run msc:session:stop` |
| **Hermes - MyStudioChannel** | `scripts/start-hermes-desktop-msc.ps1` — Desktop with MSC project root |

**MSC project folder (Desktop):** Settings → Workspace → Working Directory is **not enough**. Desktop backend reads **`%APPDATA%\Hermes\project-dir.json`** first. Use **`Hermes - MyStudioChannel`** shortcut or set:

```json
{ "dir": "D:\\Cursor_Projectz\\MyStudioChannel" }
```

Then **quit Desktop fully** → reopen → **`Ctrl+N`** new session. Chat → Personality **Msc**. General tasks: **`D:\Hermes`**.

### 📧 Google Workspace skill (`google-workspace`) — Gmail · Calendar · Drive

**Status:** ✅ Authenticated **2026-06-17** · GCP project **`wordpress-map-1492461083797`**

| What | Where |
|------|--------|
| Token | `%LOCALAPPDATA%\hermes\google_token.json` |
| Client secret | `%LOCALAPPDATA%\hermes\google_client_secret.json` |
| Setup script | `%LOCALAPPDATA%\hermes\skills\productivity\google-workspace\scripts\setup.py` |

**Check auth:** `python …\setup.py --check` → `AUTHENTICATED`

**OAuth gotcha:** After browser **Allow**, redirect to `http://localhost:1` shows **`ERR_UNSAFE_PORT`** — **normal**. Copy the **full URL** from the address bar (contains `code=4/0A…`); agent runs `--auth-code "URL"`.

**Ask Hermes in plain English:** “Summarize unread emails”, “What's on my calendar today?”, “Search Drive for [file]”. No terminal needed day-to-day.

**GCP admin:** [OAuth Clients](https://console.cloud.google.com/auth/clients?project=wordpress-map-1492461083797) · [Test users / Audience](https://console.cloud.google.com/auth/audience?project=wordpress-map-1492461083797)

Full setup + revoke: **`Hermes-Agent.md`** § Google Workspace.

### 🛠️ Safe Build & Auto-Dev Pipeline (`npm run build:dev`)
Standard builds often leave your local server offline. This unified pipeline compiles code and immediately leaves your local server active:
```bash
npm run build:dev
```
1.  Runs database schema type validation.
2.  Executes optimized `next build`.
3.  Clears any active process on port `3000` to prevent port collisions.
4.  Launches `next dev` as a background PowerShell Job, leaving the site **fully live** on [http://localhost:3000](http://localhost:3000) for instant click-link testing!

### 🔗 Payload CMS Types Sync Pipeline (`scripts/payload-types-sync.ps1`)
Completely automates database compilation and safety gates:
*   `npm run msc:types:watch` — Runs an interactive schema watcher on `collections/` and `globals/` (2s throttle) to auto-compile types on the fly during development.
*   `npm run msc:types:validate` — Validation check inside NextJS compilation. Fails the build if you modified a schema but forgot to commit `payload-types.ts`.
*   **Husky Hooks (`.husky/pre-commit`):** Automatically intercepts commits. If schemas were changed, it compiles the types and **auto-stages `payload-types.ts`** into the current git commit safely!

---

## 📋 6. Visual Kanban & Task Management Stack

Manage your human ideas and agent executions through a fully integrated visual Kanban ecosystem.

### 🔌 Running Ports & URLs
*   **TaskBoardAI Web UI (Port 3001):** `http://localhost:3001/` — Repository-level planning board.
*   **Hermes Workspace Dashboard (Port 3005):** `http://localhost:3005/` — Visual orchestration dashboard.
*   **Embedded Hermes Dashboard (Port 9119):** `http://localhost:9119/` — Gateway admin panel.

### 🕹️ Service Control Shortcuts
*   **Start Workspace:** Run `pnpm dev` in `D:\Hermes\hermes-workspace`.
*   **Start TaskBoardAI Board:** Run `npm start` in `D:\Hermes\TaskBoardAI`. (Reads repository board file: `.cursor/boards/msc-website-v9.json`).
*   **Start Hermes Dashboard:** Run `hermes dashboard --no-open --port 9119`.

### 🛑 End Project — Kanban shutdown
**End Project** (`.cursor/prompts/End-Project.md`) kills **3001** (TaskBoardAI), **3005** (Workspace), **9119** (Dashboard), then LiteLLM/ngrok (**4000**/**4040**). Telegram gateway is **optional** — operator may keep it running overnight.

### 🔌 Cursor MCP Configuration
Add this under **Cursor Settings ➡️ Features ➡️ MCP ➡️ Add New MCP Server**:
*   **Name:** `TaskBoardAI`
*   **Type:** `stdio`
*   **Command:** `node "D:\Hermes\TaskBoardAI\server\mcp\kanbanMcpServer.js"`

### 🔄 The Standard Hybrid Promotion Flow
1. **Developer Plan:** Write/edit cards on **TaskBoardAI** (`http://localhost:3001/`).
2. **Agent Promote:** Copy/promote task to active **Hermes Kanban** via `hermes kanban create "Task Title" --body "..." --assignee msc --workspace "dir:D:\Cursor_Projectz\MyStudioChannel"`.
3. **Agent Execute:** A running gateway will automatically launch the profile `msc`, run the task, and mark it complete on finish.
4. **Visual Monitor:** Track real-time progress on **Hermes Workspace** (`http://localhost:3005/`).

---

## 🔧 7. Active Model Context Protocol (MCP) Servers

These servers are registered directly in your IDE settings (`cline_mcp_settings.json`) to expand Cursor's capabilities:

| Server | Configuration Command | Scope / Capabilities |
|--------|-----------------------|----------------------|
| **TaskBoardAI MCP** | `node "D:\Hermes\TaskBoardAI\server\mcp\kanbanMcpServer.js"` | Read/write, move, and edit Kanban boards inside the project repo directly from the chat. |
| **SQLite MCP** | `npx -y @modelcontextprotocol/server-sqlite D:\Cursor_Projectz\MyStudioChannel\payload.sqlite` | Enables Cursor to run read/write queries directly on your Payload CMS database, seed test records, or inspect user models. |
| **Git MCP** | `npx -y @modelcontextprotocol/server-git` | Allows Cursor to inspect advanced branch histories, run diffs, check blame logs, and manage staging areas. |
| **Docker MCP** | `npx -y docker-mcp` | Gives Cursor the ability to inspect running local containers, retrieve logs, and monitor system containers. |

---

## 🚨 8. Troubleshooting & Recovery Runbooks

### 💥 ERR_CONNECTION_REFUSED (Port 3000 Busy or White Screen)
If NextJS dev crashes or port 3000 gets locked by a dead Node process, execute recovery immediately:
```bash
npm run dev:reset
```
*Under the hood:* Runs `msc:kill-dev-port` (forces a port flush on 3000) -> `clean:next` (wipes stale cache chunks) -> starts `next dev` cleanly.

### 🚫 LM Studio Warning: Endpoint is Offline
*   **The Issue:** Running `remember` or `recall` returns: *"I was unable to access local memory because LM Studio is offline."*
*   **The Fix:** Make sure LM Studio is open on your PC and the local server port is active on `http://127.0.0.1:1234`.

### 💾 WAL/SHM Database Locking
*   **The Issue:** Your doctor check reports unusually large database sidecars or file locking errors on Hostinger.
*   **The Fix:** Flush the temporary SQL WAL/SHM files:
    *   *Local PowerShell:* `npm run msc:db:maintain` (performs local SQLite vacuum and compaction).
    *   *Live Server Terminal:* `rm -f payload.sqlite-wal payload.sqlite-shm`.

---

*Last Updated: 2026-06-12 — Authorized J.A.R.V.I.S. Core Update*
