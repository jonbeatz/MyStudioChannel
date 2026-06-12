# 🪐 Hermes Agent — MyStudioChannel Master Guide & Cheat Sheet

Welcome to the **MyStudioChannel** Hermes Agent guide! This document is a complete cheat sheet for utilizing the **Hermes Agent** natively on Windows 11 within this project's ecosystem.

---

## 1. 📋 Overview

### What is Hermes Agent?
**Hermes Agent** is an advanced, terminal-optimized, tool-using AI developer agent created by **Nous Research**. It is fully capable of running local shell commands, reading and writing files, automating browsers via Playwright, and maintaining persistent session memories.

### Native Vertex AI + LiteLLM Integration
To bypass direct API-key limitations, OpenRouter markup fees, or AI Studio outages, Hermes is seamlessly bridged with your enterprise-grade **Google Cloud Vertex AI** setup using your native service account credentials.
*   **Bridge Layer:** LiteLLM proxy running locally on **port 4000**.
*   **Custom Provider:** Named `vertex-proxy` configured inside Hermes.
*   **GCP Project ID:** `wordpress-map-1492461083797`
*   **Routing Path:** Hermes CLI (`vader-3.5-flash`) ➡️ LiteLLM Proxy (`localhost:4000`) ➡️ Google Cloud Vertex AI (Gemini).

### Storage Locations
Hermes stores all of its system, configuration, session, and log files inside your local AppData folder:
*   `C:\Users\JONBEATZ\AppData\Local\hermes\`

---

## 2. ⚙️ Installation & PATH Setup

### Global Runner Details
*   **Full Executable Path:** `C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe`
*   **Global CLI Command:** `hermes`

### Verification Commands
To check your installation health, run the following commands in your PowerShell console:

```powershell
# Check current version
hermes --version

# Run full health diagnostics
hermes doctor
```

---

## 3. 🛠️ Core Commands

Use these commands from your terminal to drive the Hermes Agent CLI:

| Command | Description |
| :--- | :--- |
| `hermes` | Start interactive terminal UI (TUI) chat session. |
| `hermes -z "question"` | Ask a quick, non-interactive one-off question. |
| `hermes --context HERMES.md` | Start a session pre-loading your project's custom instructions. |
| `hermes model` | Open the interactive provider and model picker menu. |
| `hermes tools` | Turn specific CLI/agent tools on or off. |
| `hermes config edit` | Open your global `config.yaml` file in your default system editor. |
| `hermes config set <key> <value>` | Set a specific configuration option directly from the CLI. |
| `hermes doctor` | Diagnose and auto-fix system or configuration inconsistencies. |
| `hermes update` | Fetch and compile the latest upstream releases from GitHub. |
| `hermes desktop` | Download, install, or launch the Hermes Desktop GUI application. |

---

## 4. 💬 TUI (Terminal User Interface) Slash Commands

When inside an interactive Hermes chat session (`hermes`), you can control the agent using these **slash commands**:

| Command | Description |
| :--- | :--- |
| `/help` | List all available system slash commands. |
| `/model <name>` | Instantly switch active LLM models (e.g., `/model vader-3.5-flash`). |
| `/reset` or `/new` | Clear current chat memory and start a completely fresh conversation. |
| `/skills` | Display all currently configured and loaded workflow skills. |
| `/skills create` | Interactively author a new reusable workflow skill. |
| `/todo` | View, add, or manage tasks on your active session checklist. |
| `/memory` | Inspect your persistent, cross-session vector memory banks. |
| `/compress` | Manually compress long chat contexts to save prompt token space. |
| `/usage` | Render high-fidelity prompt and completion token statistics. |
| `/search <query>` | Query and look up matching historical conversation transcripts. |
| `/personality <name>` | Change the agent's tone (helpful, concise, creative, pirate, catgirl). |
| `/exit` or `Ctrl+C` | Gracefully close the terminal session. |

---

## 5. 🤖 Model Switching & Selection

All model requests are securely routed via the local LiteLLM proxy:

*   **`vader-3-flash`** *(Default)* — Standard, extremely fast, and highly reliable. Ideal for quick code reviews and general questions.
*   **`vader-3-pro`** — High-capacity reasoning engine. Excellent for debugging complex logical bugs.
*   **`vader-31-pro`** — Ultimate-tier corporate agentic model. Ideal for architectural planning.
*   **`vader-3.5-flash`** — Google's latest model, equipped with advanced reasoning loops for complex refactoring tasks.

### To Switch Models Instantly:
Inside a live chat session, simply type:
```text
/model vader-3.5-flash
```

---

## 6. 🚀 Project-Specific Usage

For optimal results, **always run Hermes from your project root**:
`D:\Cursor_Projectz\MyStudioChannel`

Hermes automatically scans and loads `HERMES.md` and `TRUTH.md` from the workspace folder to align itself with project blueprints, standards, and deployment safety triggers.

### Core Project Commands Hermes Can Trigger:
*   `npm run dev` — Launch the Next.js development server on port 3000 (after clearing port).
*   `npm run verify:next` — Clean cache and execute production build check.
*   `npm run msc:pushitup:live` — Trigger automated Hostinger FTP deployment.
*   `npm run msc:db:optimize` — Clean and index your local CMS SQLite database.

---

## 7. 🧰 Tool Configuration Summary

Hermes evaluates system environment conditions and enables/disables tools automatically:

| Status | Toolset | Details / Notes |
| :--- | :--- | :--- |
| ✅ | **Web Search & Extract** | High-speed parallel searching. Fully free, no additional API keys needed. |
| ✅ | **Browser Automation** | Local Chromium via Playwright. Automates scraping and visual QA. |
| ✅ | **Terminal & Processes** | Executes system-level commands natively on your machine. |
| ✅ | **File Operations** | Read, write, edit, and search workspace code blocks. |
| ✅ | **Vision / Image Analysis** | Fully supported on all Vertex AI-routed Gemini models. |
| ✅ | **Text-to-Speech (TTS)** | Free integration using Microsoft Edge TTS pipelines. |
| ✅ | **Task Planning (`todo`)** | Built-in tracking engine for long, multi-step agent actions. |
| ✅ | **Skills** | Custom multi-step automated script pipelines. |
| ✅ | **Memory** | Persistent, vector-backed workspace learning. |
| ⚠️ | **Image Generation** | Free, routed via OpenAI Codex OAuth configuration. |
| ❌ | **Mixture of Agents (`moa`)** | Inactive (Requires direct OpenRouter configuration). |

---

## 8. 💡 Common Workflows & Recipes

### 💡 Quick Code Explanation
```powershell
hermes -z "Explain how the Payload collections work in this project"
```

### ⌨️ Standard Interactive Development Session
```powershell
cd D:\Cursor_Projectz\MyStudioChannel
hermes
```

### 🔍 Commit & Code Review
```powershell
hermes -z "Review my latest commit on MSC-Website-v8 and suggest UI improvements"
```

### 🐛 Error Debugging
```powershell
hermes -z "Here is the error from my terminal: [Paste Error]. What's causing this?"
```

### 🏗️ Code Generation
```powershell
hermes -z "Create a new Payload collection schema for 'PodcastEpisodes' with fields for title, description, audioUrl, and publishDate"
```

### 🌐 Documentation Deep Research
```powershell
hermes -z "Search the web for the latest Next.js 15 App Router best practices and summarize"
```

---

## 9. 🩺 Troubleshooting

### ❌ `hermes: command not found`
**Cause:** Your current PowerShell session has not picked up the newly appended PATH variables.
**Solution:** Either restart your terminal, or map a permanent alias into your active PowerShell profile.

### ❌ No final response produced
**Cause:** The background LiteLLM proxy port might have dropped or is blocked.
**Solution:** Run the following command in PowerShell to check connectivity:
```powershell
Test-NetConnection 127.0.0.1 -Port 4000
```
If the port is closed, run `npm run start google-api` to restart the proxy.

### ❌ Model not responding / 401 Unauthorized
**Cause:** Stale Vertex authorization tokens.
**Solution:** Type `hermes model` in your terminal and re-verify that your active selection is pointing directly to your custom `vertex-proxy`.

---

## 📂 10. File Locations Reference

| Content Type | Absolute File Path |
| :--- | :--- |
| **Hermes Config** | `C:\Users\JONBEATZ\AppData\Local\hermes\config.yaml` |
| **Hermes Env File** | `C:\Users\JONBEATZ\AppData\Local\hermes\.env` |
| **Skills Folder** | `C:\Users\JONBEATZ\AppData\Local\hermes\skills\` |
| **Active Session Logs** | `C:\Users\JONBEATZ\AppData\Local\hermes\sessions\` |
| **Project Context File** | `D:\Cursor_Projectz\MyStudioChannel\HERMES.md` |
| **Project Truth File** | `D:\Cursor_Projectz\MyStudioChannel\TRUTH.md` |

---

## ⌨️ 11. Quick Alias Setup (PowerShell)

To access Hermes easily from any console window without entering full executable paths, append the following function to your active PowerShell profile (`notepad $PROFILE`):

```powershell
function hermes { & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe" $args }
```

---

## ℹ️ 12. Version Info

*   **Active CLI Version:** `v0.16.0` (Upstream standard compilation)
*   **Active Python Runtime:** `3.11.15`
*   **Active Model Provider:** Vertex AI via local LiteLLM Proxy (`vertex-proxy` on port `4000`)
*   **Tested & Verified Models:** `vader-3-flash`, `vader-3-pro`, `vader-31-pro`, `vader-3.5-flash`
