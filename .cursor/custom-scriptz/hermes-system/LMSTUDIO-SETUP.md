# 🔌 LM Studio & Local LLM Integration Guide

This guide details how to install, configure, and integrate **LM Studio** and your local GGUF models into your J.A.R.V.I.S. / Hermes ecosystem. 

By setting up LM Studio, you enable zero-latency local code reasoning, autonomous context-aware memory extraction, and terminal-driven model switching.

---

## 💾 1. Installation & Model Downloads

### Step 1: Download LM Studio
1. Navigate to the official website: [https://lmstudio.ai/](https://lmstudio.ai/)
2. Download and run the native Windows Installer.
3. Follow the on-screen steps to complete installation.

### Step 2: Download Your Local Models
LM Studio features an in-app Hugging Face model downloader. Open LM Studio, click the **Search icon (magnifying glass)** on the left navigation pane, and download the following models:

1.  **Fast Reasoning Model (Qwen 4B):**
    *   **Search for:** `qwen3-4b-instruct-2507` (or `qwen2.5-coder-7b-instruct` / `qwen2.5-7b-instruct`).
    *   **Quantization recommendation:** `Q4_K_M` or `Q5_K_M` (for the perfect balance of speed and high-fidelity reasoning).
    *   **Purpose:** Actively used by your Mem0 memory scripts to parse, extract, and structure semantic facts on the fly. Used for quick conversational tasks.
2.  **Heavy Developer Model (DeepSeek 33B):**
    *   **Search for:** `deepseek-coder-33b-instruct`.
    *   **Quantization recommendation:** `Q4_K_M`.
    *   **Purpose:** Heavy architectural reasoning, complex multi-file refactoring, and deep debugging.

---

## ⌨️ 2. Bootstrapping the LM Studio CLI (`lms`)

LM Studio includes a powerful CLI utility called `lms` that allows PowerShell scripts and background daemons to load, unload, and inspect models programmatically.

To enable the global `lms` command in PowerShell:
1. Open your terminal as an Administrator.
2. Run the bootstrap command:
   ```powershell
   lms bootstrap
   ```
3. Restart your PowerShell console.
4. Verify the CLI is active by running:
   ```powershell
   lms --version
   ```

---

## 🔗 3. Model Identifier Alignment

Your J.A.R.V.I.S. PowerShell shortcuts expect specific model nicknames/identifiers to be registered in your local LM Studio library.

To ensure `load-qwen` and `load-deepseek` work instantly, name or alias your downloaded models as follows inside LM Studio (or run `lms import` to register them):

*   **Qwen Nickname:** `qwen3-4b-instruct-2507`
*   **DeepSeek Nickname:** `deepseek-coder-33b-instruct`

To test loading via the CLI, execute:
```powershell
# Load Qwen
lms load "qwen3-4b-instruct-2507"

# Inspect active status
lms ps

# Unload models
lms unload --all
```

---

## 🌐 4. Configuring the Local API Endpoint

For J.A.R.V.I.S.'s memory layer (Mem0) to extract facts, the local LM Studio server must be active:

1. In LM Studio, click the **Local Server icon (double arrows)** on the left navigation pane.
2. Set the Port to `1234` (default).
3. Ensure the server is listening on `http://127.0.0.1:1234/v1`.
4. Click **Start Server**.

### Memory API Link:
The Python script `scripts/mem0_integration.py` is pre-configured to query this local endpoint:
```python
# From scripts/mem0_integration.py
config = {
    "llm": {
        "provider": "openai",
        "config": {
            "model": "qwen3-4b-instruct-2507",
            "openai_api_base": "http://127.0.0.1:1234/v1",
            "api_key": "lm-studio",
            "lmstudio_response_format": {
                "type": "json_schema", 
                "json_schema": {"type": "object", "schema": {}}
            }
        }
    }
}
```
If LM Studio is closed or the local server is stopped, J.A.R.V.I.S. will gracefully issue a voice warning: *"Excuse me Jon, I was unable to access local memory because LM Studio is offline."*

---

## ⏱️ 5. Autonomous VRAM Auto-Unload Integration

Local models occupy vast amounts of GPU memory (VRAM), which can slow down local Next.js HMR (Hot Module Replacement) compile times or webpack compilations.

To solve this, J.A.R.V.I.S. includes a silent, background VRAM manager daemon (`scripts/vram-idle-manager.ps1`):
1.  **Status Monitoring:** It periodically runs `lms ps` to verify if a model is currently loaded.
2.  **Activity Tracking:** Every time you execute an AI speech query, add a memory (`remember`), or search memories (`recall`), the system updates the timestamp file `.vram-idle-state.json`.
3.  **Idle Warnings:** If no AI tasks are executed for **14 minutes**, the daemon uses the Text-to-Speech engine to warn you verbally: *"Warning: Model has been idle for fourteen minutes and will be unloaded shortly to conserve VRAM."*
4.  **Auto-Unload:** At **15 minutes** of absolute idle time, it runs `lms unload --all` to free your GPU resources completely, speaking: *"Model auto unloaded to free up system VRAM."*

### Starting the Daemon:
To spin up the daemon on startup, simply run:
```powershell
vram-daemon-start
```
To check its tracking status and exact remaining seconds:
```powershell
vram-status
```
To temporarily pause auto-unloading (e.g. during heavy coding sessions):
```powershell
keep-model-on
```

---

*Now fully documented for the personal J.A.R.V.I.S. suite. Ready for instant deployment on any fresh computer!*
