# ComfyUI Enhanced Features Guide

This document tracks and outlines the major June 2026 feature additions, models, upscale systems, and video capabilities added to your standalone ComfyUI setup.

---

## 1. Storage Optimization & Model Symlinks
To conserve space on your primary `D:` drive (940 GB free) while leveraging the massive capacity of your `H:` drive (3.3 TB free), all newly added heavy models are downloaded under `H:\AI_Models\comfyui_cache\` and symlinked natively into ComfyUI's standard directories.

| Model Category | Path on H: | Path on D: (ComfyUI Symlink) |
|---|---|---|
| **UNET/GGUF Checkpoints** | `H:\AI_Models\comfyui_cache\unet\` | `D:\AI_Models\ComfyUI\ComfyUI\models\unet\` |
| **Standard Checkpoints** | `H:\AI_Models\comfyui_cache\checkpoints\` | `D:\AI_Models\ComfyUI\ComfyUI\models\checkpoints\` |
| **Video Models** | `H:\AI_Models\comfyui_cache\CogVideo\` | `D:\AI_Models\ComfyUI\ComfyUI\models\CogVideo\` |
| **Upscale Models** | `H:\AI_Models\comfyui_cache\upscale_models\` | `D:\AI_Models\ComfyUI\ComfyUI\models\upscale_models\` |

---

## 2. Models Installed

### High-Quality Image Generation
*   **`flux1-dev-Q4_K_M.gguf` (~7.02 GB):** Best-in-class realism and face structure. Loaded using `UnetLoaderGGUF`.
*   **`stable-diffusion-xl-base-1.0-Q4_0.gguf` (~3.54 GB):** Community standard base SDXL model.
*   **`stable-diffusion-xl-refiner-1.0-Q4_0.gguf` (~3.06 GB):** Enhances details, textures, and backgrounds.
*   **`Realistic_Vision_V5.1_noVAE.safetensors` (~4.02 GB):** Premier photo-realistic portrait model.
*   **`anything-v5-PrtRE.safetensors` (~4.03 GB):** High-end illustrative/stylized/anime model.

### Upscaling Models
*   **`4x-UltraSharp.pth`:** Premier sharp upscaling filter.
*   **`4x-AnimeSharp.pth`:** Best for illustrative and stylized upscaling.
*   **`RealESRGAN_x4plus.pth`:** Versatile general-purpose photo upscaler.

### Video Generation Models
*   **`svd_xt.safetensors` (~9.5 GB):** Stable Video Diffusion image-to-video model.
*   **`CogVideoX_5b_I2V_GGUF_Q4_0.safetensors` (~3.54 GB):** Optimized text-to-video transformer model.

---

## 3. Added Custom Nodes (Expansion Suite)
1.  **ComfyUI-Impact-Pack:** Face detailing, YOLO object detection, and mask automation.
2.  **ComfyUI-Advanced-ControlNet:** Better ControlNet integration.
3.  **ComfyUI-Inspire-Pack:** Full utility pack for ComfyUI.
4.  **ComfyUI-IC-Light:** Image relighting nodes.
5.  **ComfyUI_LayerStyle:** Photoshop-like layer blending inside ComfyUI.
6.  **ComfyUI_InstantID:** Identity preservation nodes.
7.  **ComfyUI-segment-anything-2:** Advanced surgical segmentation.
8.  **ComfyUI-VideoHelperSuite:** Frame video loaders and audio/video combining.
9.  **ComfyUI-Frame-Interpolation:** Generates smooth frame transitions for high framerates.
10. **ComfyUI-Video-Matting:** Background removal.
11. **ComfyUI-CogVideoXWrapper:** Front-end implementation for CogVideoX workflows.

---

## 4. API Workflow Files (`D:\AI_Models\ComfyUI\workflows\`)
*   `txt2img-sdxl.json` - High-quality SDXL generation.
*   `img2img-face-fix.json` - Detailer workflow for restoring face, eyes, and skin textures.
*   `upscale-4k.json` - Fast upscaler that expands any image using `4x-UltraSharp` up to 4K resolution.
*   `txt2vid-cogvideo.json` - Text-to-video using CogVideoX.
*   `img2vid-svd.json` - Image-to-video animation using `svd_xt`.

---

## 5. New PowerShell Commands

### A. upscale-image
Takes any input image and upscales it to 4K using `4x-UltraSharp`.
```powershell
upscale-image -InputPath "C:\path\to\image.png"
```

### B. generate-video
Generates a short MP4 video based on a text description.
```powershell
generate-video -Prompt "A beautiful waterfall in the middle of a cyber forest, 8k resolution"
```

### C. animate-image
Animates a still photo into a video clip using Stable Video Diffusion.
```powershell
animate-image -InputPath "C:\path\to\input.png"
```

### D. fix-face
Automatically detects and detailed-restores low-fidelity faces in any photo.
```powershell
fix-face -InputPath "C:\path\to\photo.png"
```
