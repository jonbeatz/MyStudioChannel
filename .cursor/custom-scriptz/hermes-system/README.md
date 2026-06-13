# J.A.R.V.I.S. Core Suite (Hermes System Module)

This is your portable, fully-featured **J.A.R.V.I.S. / Hermes System Module** located under `.cursor/custom-scriptz/hermes-system/`. 

It packages your neural speaking assistant, vector memory layers, VRAM idle auto-unloader, serverless image generation pipelines, and automated build-safety tools so you can easily install and recreate your exact development suite in **any other workspace or project**!

---

## 📦 What's Included

*   **`install.ps1`** — Portable PowerShell installer using shared Vader/MSC libraries to merge dependencies, environments, and package scripts.
*   **`CURSOR.md`** — Guidelines for AI agents to configure, run, and sync the systems.
*   **`Hermes-Cheat-Sheet.md`** — The ultimate user reference guide documenting all voice commands, Mem0, VRAM daemons, and image generators.
*   **`LMSTUDIO-SETUP.md`** — Step-by-step user guide to install LM Studio, bootstrap the CLI (`lms`), download GGUF files, and configure local endpoints.
*   **`scripts/`** — Staged copies of all 11 core automation scripts and templates:
    *   `setup-hermes.ps1` — Full environment setup/restore utility (creates directories, restores presets, backs up and auto-injects J.A.R.V.I.S. PowerShell profile commands).
    *   `profile-functions.template.ps1` — Reusable PowerShell profile function templates with dynamic project root injection.
    *   `config.yaml.template` — Pristine global configuration file presets.
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
3.  **Run the Environment Setup:** Run the newly copied Hermes configuration utility from the project root:
    ```powershell
    powershell -ExecutionPolicy Bypass -File scripts/setup-hermes.ps1 -InstallPythonDeps
    ```
    *(Note: This automatically restores folders, pristine config.yaml models/voice mappings, backs up your active PowerShell profile, and auto-injects all custom J.A.R.V.I.S. helper functions with dynamic paths!)*
4.  **Sync Environment Variables:** Add your `HF_TOKEN=hf_...` and GCP keys to the new `.env.local` file.
5.  **Confirm Global Shortcuts:** Ensure your global Cursor rules (or `.cursorrules`) include the commands listed in `global.mdc.fragment` so Cursor knows how to invoke your tools conversationally!

Your exact J.A.R.V.I.S. development suite is now fully packaged, completely modularized, and 100% portable!
