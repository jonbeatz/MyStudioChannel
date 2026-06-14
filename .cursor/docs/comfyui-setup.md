# ComfyUI Portable Integration Guide

This guide documents the installation, configuration, and PowerShell integration of ComfyUI as a separate, optional image-to-image editing and inpainting pipeline. It lives alongside the existing FLUX.1-schnell image generation setup and does not modify it.

---

## Folder Structure & Model Symlinks

All assets, models, and workflows are situated on your `D:` and `H:` drives to conserve local `C:` storage:

- **Engine and Virtual Environment:** `D:\AI_Models\ComfyUI\`
- **GGUF Checkpoint Models (Symlinked):**
  - **UNET/Diffusion Directories:** `D:\AI_Models\ComfyUI\ComfyUI\models\unet\` and `D:\AI_Models\ComfyUI\ComfyUI\models\diffusion_models\`
    - `flux-2-klein-4b-Q5_K_M.gguf` &rarr; `H:\AI_Models\unsloth\FLUX.2-klein-4B-GGUF\flux-2-klein-4b-Q5_K_M.gguf`
    - `z-image-turbo-Q4_K_M.gguf` &rarr; `H:\AI_Models\unsloth\Z-Image-Turbo-GGUF\z-image-turbo-Q4_K_M.gguf`
  - **Checkpoints Directory (For general fallback):** `D:\AI_Models\ComfyUI\ComfyUI\models\checkpoints\`
    - Symlinked versions of the GGUF models reside here as well.
- **Text Encoders (CLIP/T5):** `D:\AI_Models\ComfyUI\ComfyUI\models\clip\`
  - `Qwen3-4B-Instruct-2507-Q4_K_M.gguf` (Symlinked to `H:\AI_Models\unsloth\Qwen3-4B-Instruct-2507-GGUF\Qwen3-4B-Instruct-2507-Q4_K_M.gguf` &mdash; **Required Text Encoder for Lumina-2 / Z-Image-Turbo models**)
  - `clip_l.safetensors` (Direct download, standard fallback)
  - `t5xxl_fp8_e4m3fn.safetensors` (Direct download, standard fallback)
- **VAE Model:** `D:\AI_Models\ComfyUI\ComfyUI\models\vae\`
  - `ae.safetensors` (Direct download for FLUX.1 / Lumina-2)
- **Workflows:** `D:\AI_Models\ComfyUI\workflows\`
  - `img2img.json` (Image-to-Image API template)
  - `inpaint.json` (Inpainting API template)

---

## RTX 50-Series (Blackwell) & PyTorch CUDA 12.8 Upgrade

Your **NVIDIA GeForce RTX 5060 Ti** features the state-of-the-art **Blackwell architecture (Compute Capability `sm_120`)**. Standard PyTorch wheels built with CUDA 12.1 or 12.4 are incompatible and throw `no kernel image is available` errors.

To solve this, ComfyUI's embedded Python interpreter has been upgraded to a cutting-edge **PyTorch 2.11+ Build with native CUDA 12.8 support**, fully unlocking Blackwell acceleration:

```powershell
# Commands used for setup and upgrade:
D:\AI_Models\ComfyUI\python_embeded\python.exe -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 --force-reinstall
D:\AI_Models\ComfyUI\python_embeded\python.exe -m pip install "numpy<2.3" gguf sqlalchemy alembic
```

---

## Custom Nodes Configured

The following custom nodes have been cloned and fully installed into the ComfyUI portable environment:

1. **ComfyUI-Manager:** Handles web-based updates and node installation.
2. **ComfyUI-GGUF:** Custom loader required to parse and load the symlinked GGUF checkpoints.
3. **ComfyUI_IPAdapter_plus:** Pre-loaded for advanced image conditioning.
4. **comfyui_controlnet_aux:** Installed and compiled with all dependency requirements met.

---

## Lumina-2 / Z-Image-Turbo Architecture Setup

The GGUF models available (`flux-2-klein-4b` and `z-image-turbo`) are based on the **Lumina-2 (Flux2) architecture**. This architecture has specific nodes and pipelines distinct from standard FLUX.1:

1. **Text Encoding:** Uses `CLIPLoaderGGUF` pointing to `Qwen3-4B-Instruct-2507-Q4_K_M.gguf` rather than a standard dual FLUX.1 CLIP text loader.
2. **Latent Packing & Sampling:** Does not use `ModelSamplingFlux`. The KSampler hooks directly into the `UnetLoaderGGUF` output, decoding with `VAELoader` and `ae.safetensors`.
3. **Optimized Parameters:** Z-Image-Turbo runs optimally at **9 steps** and **1.5 CFG** with an Euler/Simple scheduler.

---

## PowerShell Functions

The following functions are added to your PowerShell profile (`Microsoft.PowerShell_profile.ps1`):

### 1. edit-image
Used for general image-to-image adjustments.
```powershell
edit-image -InputPath "path/to/image.png" -Prompt "Prompt description here" -Strength 0.65
```
- **InputPath:** Path to your source image.
- **Prompt:** String describing changes to apply.
- **Strength:** Float between `0.0` and `1.0` (denoise factor). Lower means closer to the original image; higher means closer to the prompt description.

### 2. inpaint-image
Used for inpainting specific parts of an image using a mask.
```powershell
inpaint-image -InputPath "path/to/image.png" -MaskPath "path/to/mask.png" -Prompt "Prompt description here"
```
- **InputPath:** Path to your source image.
- **MaskPath:** Path to your black-and-white mask image (the white area is modified).
- **Prompt:** String describing what to render in the masked region.

---

## How It Works (Headless API Execution)

1. **Auto-Server Detection:** When `edit-image` or `inpaint-image` is triggered, it checks if ComfyUI is active on `http://127.0.0.1:8188`.
2. **Auto-Launch:** If the server is not active, it boots ComfyUI minimized in the background (`run_nvidia_gpu.bat`) and polls until it starts responding. Standard output/error is redirected to log files in `D:\AI_Models\ComfyUI\` for transparent debugging.
3. **File Transport:** It automatically moves your input images and masks to ComfyUI's internal `input/` directory.
4. **Payload Injection:** It reads the pre-configured workflow JSON files from `D:\AI_Models\ComfyUI\workflows\`, replaces parameter placeholders, and posts the payload to ComfyUI's `/prompt` endpoint.
5. **Completion Polling:** It polls the history endpoint `/history/<prompt_id>` until execution is complete.
6. **Delivery & Auto-Open:** It moves the final image to your workspace `public/media/` directory under a timestamped name, triggers the voice synthesis engine (J.A.R.V.I.S.) for spoken feedback, and launches the default Windows photo viewer.

---

## System Independence Test Results (Proof of Isolation)

A dual system smoke test was run to verify zero-interference isolation:

### Test 1: Existing Remote FLUX.1 System
- **Command:** `gen-image 'A test image for existing workflow'`
- **Output:** Successfully generated a gorgeous 1920x1080 canvas in **12.0 seconds** without touching local resources.
- **Result File:** `public\media\generated-20260613-190636.png`

### Test 2: New Local ComfyUI GGUF System
- **Command:** `edit-image -InputPath 'public\media\generated-20260613-184504.png' -Prompt 'make the background bright blue, glowing neon style' -Strength 0.65`
- **Output:** Automatically launched background ComfyUI, successfully verified Blackwell `sm_120` CUDA 12.8 environment, parsed Lumina-2 nodes, ran 9 steps of inference, and completed successfully!
- **Result File:** `public\media\edited-20260613-190440.png`
