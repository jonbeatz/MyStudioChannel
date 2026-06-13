# Free AI Image Generation Pipeline Setup Guide (FLUX.1)

This documentation details the setup, architecture, and usage of the zero-cost, cloud-accelerated, high-fidelity image generation pipeline implemented in the `MyStudioChannel` project.

---

## 1. Overview & Advantages
The image generation pipeline connects your local workspace to the **Hugging Face Serverless Inference API** using **FLUX.1-schnell** (created by Black Forest Labs). 

*   **The Best Quality:** FLUX.1 is the world-leading state-of-the-art model for image photorealism, layout adherence, and text rendering.
*   **0% Local GPU & VRAM Load:** The heavy neural network calculations run on Hugging Face's high-speed cloud clusters. Your local machine stays cool, and all local VRAM remains fully available for LLMs and dev servers.
*   **Zero-Cost Free Tier:** Standard accounts receive free monthly inference credits, enabling you to generate high-resolution images completely free.
*   **Sub-3s Speeds:** Images are fully computed and streamed back to your computer in just 2 to 3 seconds.

---

## 2. Architecture & Data Flow

```
+-----------------------------------------------------------+
|                   PowerShell Terminal                     |
|      gen-image "A beautiful recording studio..."          |
+-----------------------------+-----------------------------+
                              |
                       Auto-launches
                              v
+-----------------------------------------------------------+
|                 scripts/generate-image.py                 |
|  1. Parses .env.local to find HF_TOKEN                    |
|  2. Sends prompt to Hugging Face serverless FLUX          |
|  3. Downloads high-res PNG directly to your output folder  |
+-----------------------------+-----------------------------+
                              |
                       Triggers Feedback
                              v
+-----------------------------------------------------------+
|                    J.A.R.V.I.S. Audio                     |
|  "Image generated, Jon. Opening it now..."                |
+-----------------------------------------------------------+
```

---

## 3. Installation & Credentials Setup

### A. Hugging Face Access Token
1. Create a free account at [huggingface.co](https://huggingface.co) if you do not have one.
2. Navigate to **Settings -> Access Tokens**.
3. Create a new token with at least **Read** permissions.
4. Add the key directly to your `[.env.local](../../.env.local)` file:
   ```env
   HF_TOKEN=hf_your_actual_token_here
   ```

### B. Python Libraries
Install the required packages in your main Python environment (this has already been completed for your workspace):
```bash
pip install huggingface_hub pillow python-dotenv
```

---

## 4. Usage Guide & Commands

We have fully integrated a native PowerShell shortcut command **`gen-image`** into your PowerShell profile.

### Basic Generation
Generates a photorealistic 1024x1024 image and saves it in `public/media/generated-[timestamp].png` with automatic Windows photo viewer startup:
```powershell
gen-image "A beautiful recording studio with gold accent lighting, photorealistic, 4k"
```

### Save to Custom Path & Dimensions (Widescreen HD)
Generates an image with a specific resolution (e.g. 1920x1080 widescreen landscape or vertical aspect ratios) and outputs it to a custom path:
```powershell
gen-image "Modern tv studio set, photorealistic, 4k" -Path "public/media/my-tv-studio.png" -Width 1920 -Height 1080
```

---

## 5. Under-The-Hood Integrations

*   **VRAM Idle Manager Synchronization:** Calling `gen-image` automatically touches your local `.vram-idle-state.json` file. This tells your background auto-unload manager that you are actively working, preventing your local LLMs from unloading unexpectedly during design tasks.
*   **J.A.R.V.I.S. Vocal Feedback:** Connects with your local TTS helper to speak out loud: *"Image generated, Jon. Opening it now."*
*   **Auto-Opening Trigger:** Spawns a native background Windows process (`Start-Process`) to instantly load the generated file into your default desktop photo viewer the exact millisecond the download completes!
