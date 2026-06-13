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
*   `load-qwen` — Fast-loads your default reasoning model (`qwen3-4b-instruct-2507` — 2.33 GB VRAM).
*   `load-deepseek` — Loads your heavy development model (`deepseek-coder-33b-instruct` — 20+ GB VRAM).
*   `unload-model` — Purges and unloads all models from VRAM immediately.
*   `model-status` — Displays currently active loaded models and their allocations.

### ⏱️ VRAM Idle Auto-Unload Daemon
To optimize local compilation and Next.js HMR speeds, the background daemon `[scripts/vram-idle-manager.ps1](scripts/vram-idle-manager.ps1)` monitors loaded models:
*   **14 Minutes Idle:** Speaks a warning: *"Warning: Model has been idle for fourteen minutes and will be unloaded shortly to conserve VRAM."*
*   **15 Minutes Idle:** Automatically unloads all models and speaks: *"Model auto unloaded to free up system VRAM."*

#### Daemon Controls:
*   `vram-daemon-start` — Spawns the monitor as a silent, background PowerShell Job.
*   `vram-daemon-stop` — Kills and cleans up the active background job.
*   `vram-status` — Prints active loaded models, configuration overrides, last activity timestamp, and exact idle durations.
*   `vram-unload` — Immediately purges loaded models manually.
*   `keep-model-on` — **Override:** Disables auto-unload (holds loaded models in VRAM indefinitely).
*   `keep-model-off` — **Override:** Restores the 15-minute auto-unload safety loop.

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
Execute the canonical session-start command to prepare your workspace:
```powershell
npm run msc:google-api:start-session
```
1.  Launches your local LiteLLM Google API proxy.
2.  Actively polls port `4000` until online.
3.  Waits 2 seconds for tunnel stabilization.
4.  Plays J.A.R.V.I.S.'s vocal welcome greeting: *"Welcome back Jon, I am J.A.R.V.I.S. your personal assistant..."*

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

## 🔧 6. Active Model Context Protocol (MCP) Servers

These servers are registered directly in your IDE settings (`cline_mcp_settings.json`) to expand Cursor's capabilities:

| Server | Configuration Command | Scope / Capabilities |
|--------|-----------------------|----------------------|
| **SQLite MCP** | `npx -y @modelcontextprotocol/server-sqlite D:\Cursor_Projectz\MyStudioChannel\payload.sqlite` | Enables Cursor to run read/write queries directly on your Payload CMS database, seed test records, or inspect user models. |
| **Git MCP** | `npx -y @modelcontextprotocol/server-git` | Allows Cursor to inspect advanced branch histories, run diffs, check blame logs, and manage staging areas. |
| **Docker MCP** | `npx -y docker-mcp` | Gives Cursor the ability to inspect running local containers, retrieve logs, and monitor system containers. |

---

## 🚨 7. Troubleshooting & Recovery Runbooks

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
