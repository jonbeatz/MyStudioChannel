# J.A.R.V.I.S. VRAM Auto-Unload & Lifecycle Manager

This documentation details the architecture and operational guidelines for the automatic model unload and VRAM reclamation service implemented in the `MyStudioChannel` project.

---

## 1. Overview & Goal
Large Language Models running locally via LM Studio consume substantial GPU VRAM (e.g., Qwen 4B occupies ~2.33 GB; DeepSeek 33B consumes up to 20+ GB). Leaving these models loaded indefinitely when idle degrades overall system performance, slows down Next.js local compilation, and increases power consumption.

The **VRAM Idle Manager** is an autonomous, lightweight daemon that monitors inactive model times and automatically unloads models from LM Studio after **15 minutes** of absolute silence.

---

## 2. Architecture

```
+--------------------------------------------------------+
|                 PowerShell Session                     |
| (remember, recall, load-qwen, speak, load-deepseek)     |
+---------------------------+----------------------------+
                            |
                     Touches Activity
                            v
+--------------------------------------------------------+
|      .vram-idle-state.json (Persistent State)          |
| { "LastActivityTime": "...", "KeepModelOn": false }    |
+---------------------------+----------------------------+
                            ^
                     Reads & Evaluates
                            |
+---------------------------+----------------------------+
|             vram-idle-manager.ps1 (Daemon)             |
|  Loops every 30s | lms ps | Unloads after 15m idle     |
+--------------------------------------------------------+
```

---

## 3. Core Components

### A. State File (`.vram-idle-state.json`)
Located at the workspace root, this persistent JSON acts as the shared database between your PowerShell interactive commands and the background monitoring loop.
```json
{
  "LastActivityTime": "2026-06-13T00:50:32.411Z",
  "KeepModelOn": false
}
```

### B. Monitoring Daemon (`scripts/vram-idle-manager.ps1`)
A robust script running in daemon mode:
1. Detects loaded models via `lms ps`.
2. Inspects `KeepModelOn` override toggle.
3. Calculates elapsed idle time since `LastActivityTime`.
4. Triggers a **vocal warning** at 14 minutes: `"Warning: Model has been idle for fourteen minutes and will be unloaded shortly to conserve VRAM."`
5. Unloads all models at 15 minutes (`lms unload --all`) and issues a vocal confirmation: `"Model auto unloaded to free up system VRAM."`

---

## 4. CLI Command Reference

We have fully integrated controls directly into your PowerShell profile. Open any terminal and run:

| Command | Action | J.A.R.V.I.S. Vocal Feedback |
|---------|--------|------------------------------|
| `vram-daemon-start` | Starts the active background monitoring daemon | Yes |
| `vram-daemon-stop` | Stops the background monitoring daemon | Yes |
| `vram-status` | Prints current loaded models, idle time, and configuration state | No |
| `vram-unload` | Forces an immediate purge of all loaded models to reclaim VRAM | Yes |
| `keep-model-on` | Disables auto-unload (Keep Model Loaded override) | Yes |
| `keep-model-off` | Re-enables the 15-minute auto-unload safety | Yes |

---

## 5. Intelligent Model Auto-Loading
You no longer have to manually load models before running operations!
Our custom profile wrapper automatically checks if LM Studio is empty before running **`remember`** or **`recall`** queries. If empty, it automatically triggers a silent **`load-qwen`** before proceeding, ensuring zero-latency operations for the user.
