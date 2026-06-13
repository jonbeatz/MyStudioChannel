# J.A.R.V.I.S. Core Suite (Hermes System Module)

This is your portable, fully-featured **J.A.R.V.I.S. / Hermes System Module** located under `.cursor/custom-scriptz/hermes-system/`. 

It packages your neural speaking assistant, vector memory layers, VRAM idle auto-unloader, serverless image generation pipelines, and automated build-safety tools so you can easily install and recreate your exact development suite in **any other workspace or project**!

---

## 📦 What's Included

*   **`install.ps1`** — Portable PowerShell installer using shared Vader/MSC libraries to merge dependencies, environments, and package scripts.
*   **`CURSOR.md`** — Guidelines for AI agents to configure, run, and sync the systems.
*   **`scripts/`** — Staged copies of all 8 core automation scripts:
    *   `payload-types-sync.ps1` — Watches, compiles, and auto-stages Payload schema types.
    *   `vram-idle-manager.ps1` — Monitors LM Studio inactivity, warns at 14m, unloads at 15m.
    *   `msc-build-and-dev.ps1` — NextJS production build check + detached auto-dev relaunch.
    *   `generate-image.py` — High-fidelity FLUX.1 cloud image generation.
    *   `mem0_integration.py` & `mem0-chat.ps1` — Local Qdrant memory vector layers.
    *   `start-hermes-api.ps1` — Polling API launcher + J.A.R.V.I.S. greeting trigger.
    *   `generate-payload-types.mjs` — Fast Jiti-driven Payload typescript generator.

---

## 🚀 How to Install inside a New Project

To replicate your awesome J.A.R.V.I.S. setup inside another repository (like a new project in your workspace):

1.  **Copy this folder:** Copy `.cursor/custom-scriptz/hermes-system` into the new project's `.cursor/custom-scriptz/` folder.
2.  **Run the Installer:** Open PowerShell at the root of the new project and execute:
    ```powershell
    powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/hermes-system/install.ps1
    ```
3.  **Sync Environment Variables:** Add your `HF_TOKEN=hf_...` and GCP keys to the new `.env.local` file.
4.  **Confirm Global Shortcuts:** Ensure your global Cursor rules (or `.cursorrules`) include the commands listed in `global.mdc.fragment` so Cursor knows how to invoke your tools conversationally!

Your exact J.A.R.V.I.S. development suite is now fully packaged, completely modularized, and 100% portable!
