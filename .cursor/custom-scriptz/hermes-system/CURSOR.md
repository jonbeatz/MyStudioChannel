# Agent Runbook: J.A.R.V.I.S. / Hermes System Module

This module installs and configures your local long-term memory (Mem0), VRAM auto-unload daemon, serverless image generation (FLUX), and schema type-sync capabilities.

### 📚 Reference Manuals Included:
*   **`Hermes-Cheat-Sheet.md`** — Comprehensive user guide documenting all voice commands, Mem0, VRAM commands, and image triggers.
*   **`LMSTUDIO-SETUP.md`** — Step-by-step user guide to install LM Studio, download local models, and bootstrap the local CLI.

---

## 🚀 1. Installation

Any agent can easily initialize the entire suite in a new repository by running the installer from the project root:
```powershell
powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/hermes-system/install.ps1
```

Once files are copied, run the automated setup/restore tool:
```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-hermes.ps1 -InstallPythonDeps
```
This utility automatically configures system directories, copies model configuration presets, backs up the active PowerShell profile, and auto-injects all user-level J.A.R.V.I.S. shortcuts.

---

## 🧠 2. Core Capabilities Registered

After installation, the following scripts are fully copied and configured:

| Script Filename | Purpose / Capability |
|-----------------|----------------------|
| `scripts/setup-hermes.ps1` | Comprehensive Hermes CLI installer, configuration restorer, and profile injector. |
| `scripts/profile-functions.template.ps1` | Core PowerShell profile template with dynamic workspace path replacement tokens. |
| `scripts/config.yaml.template` | Preset configuration files with Custom LiteLLM model mappings and Ryan Neural voice parameters. |
| `scripts/payload-types-sync.ps1` | Type validation, watch triggers, and pre-commit schema auto-staging. |
| `scripts/vram-idle-manager.ps1` | Monitors model idle durations, triggers verbal warning at 14m, auto-unloads at 15m. |
| `scripts/msc-build-and-dev.ps1` | Production build gate + detached NextJS auto-dev restart so click-links are live. |
| `scripts/generate-image.py` | Serverless cloud-accelerated FLUX.1 generation (0% local VRAM/GPU load). |
| `scripts/mem0_integration.py` | Python orchestration layer for Qdrant memory vectors. |
| `scripts/mem0-chat.ps1` | PowerShell wrapper for adding/searching vectors with auto-LLM-load checkers. |

---

## 🛠️ 3. Post-Installation Verification Checklist

To complete setup inside any new project, verify the following steps:
1.  **Hugging Face Credentials:** Ensure `HF_TOKEN` exists inside `.env.local`.
2.  **Required PIP Packages:** Run `pip install huggingface_hub pillow python-dotenv mem0ai sentence-transformers` (or pass `-InstallPythonDeps` to `setup-hermes.ps1`).
3.  **Local Qdrant Server:** Ensure local Qdrant is running or configured under `~/.mem0/qdrant`.
4.  **Automatic Profile Configuration:** Execute `powershell -ExecutionPolicy Bypass -File scripts/setup-hermes.ps1` from the project root to automatically configure system-wide profile functions and global model configuration templates!
