# Agent Runbook: J.A.R.V.I.S. / Hermes System Module

This module installs and configures your local long-term memory (Mem0), VRAM auto-unload daemon, serverless image generation (FLUX), and schema type-sync capabilities.

---

## 🚀 1. Installation

Any agent can easily initialize the entire suite in a new repository by running the installer from the project root:
```powershell
powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/hermes-system/install.ps1
```

---

## 🧠 2. Core Capabilities Registered

After installation, the following scripts are fully copied and configured:

| Script Filename | Purpose / Capability |
|-----------------|----------------------|
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
2.  **Required PIP Packages:** Run `pip install huggingface_hub pillow python-dotenv mem0ai sentence-transformers`.
3.  **Local Qdrant Server:** Ensure local Qdrant is running or configured under `~/.mem0/qdrant`.
4.  **PowerShell Profile Sync:** Copy J.A.R.V.I.S. commands (`gen-image`, `speak`, `remember`, `recall`, etc.) into the system profile path: `C:\Users\JONBEATZ\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`.
