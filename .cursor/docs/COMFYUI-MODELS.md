# ComfyUI Model Library — MyStudioChannel Workstation

**Hardware:** NVIDIA RTX 5060 Ti (16 GB VRAM) · 32 GB RAM · Windows 11  
**ComfyUI root:** `D:\AI_Models\ComfyUI\` (port **8188**)  
**Model storage:** `H:\AI_Models\` (symlinked into ComfyUI `models/` folders)  
**Workflows:** `D:\AI_Models\ComfyUI\workflows\`  
**Last restored:** 2026-06-18 (LM Studio cleanup collateral recovery)

---

## Quick switch guide

| Goal | Workflow JSON | PowerShell test |
|------|---------------|-----------------|
| Fast local default (z-image) | `txt2img-gen-image-local.json` | `gen-image-local "prompt"` |
| Flux.1-dev quality | `txt2img-flux-dev.json` | See test script below |
| Flux.2 Klein 4B (fast) | `txt2img-flux-klein.json` | See test script below |
| SDXL base | `txt2img-sdxl.json` | See test script below |
| Photorealism (SD 1.5) | `txt2img-realism.json` | See test script below |
| Anime / illustration | `txt2img-anime.json` | See test script below |

Run all smoke tests:

```powershell
# Local (Cursor / PC)
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AI_Models\ComfyUI\scripts\test-comfyui-workflows.ps1
```

Repair symlinks after re-download:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AI_Models\ComfyUI\scripts\repair-comfyui-symlinks.ps1
```

Re-download deleted weights:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AI_Models\ComfyUI\scripts\restore-comfyui-models.ps1
```

---

## Installed image models

### Primary stack (already working)

| Model | Format | Size | Storage path | ComfyUI symlink(s) | Workflow |
|-------|--------|------|--------------|-------------------|----------|
| **z-image-turbo** Q4_K_M | GGUF | ~4.7 GB | `H:\AI_Models\unsloth\Z-Image-Turbo-GGUF\` | `unet/`, `checkpoints/`, `diffusion_models/` | `txt2img-gen-image-local.json`, `edit-image`, `inpaint`, `img2img` |
| **Qwen3-4B-Instruct** Q4_K_M (CLIP) | GGUF | ~2.3 GB | `H:\AI_Models\unsloth\Qwen3-4B-Instruct-2507-GGUF\` | `clip/` | z-image workflows |
| **ae.safetensors** (Flux/Z VAE) | safetensors | ~0.31 GB | `D:\AI_Models\ComfyUI\ComfyUI\models\vae\` (direct) | — | Flux + z-image |
| **clip_l.safetensors** | safetensors | ~0.23 GB | `models/clip/` (direct) | — | Flux, SDXL |
| **t5xxl_fp8_e4m3fn** | safetensors | ~4.6 GB | `models/clip/` (direct) | — | Flux.1 / Flux.2 Klein |

### Restored 2026-06-18

| Model | Format | Size | Download source | Storage path | Workflow |
|-------|--------|------|-----------------|--------------|----------|
| **Flux.2 Klein 4B** Q5_K_M | GGUF | ~2.9 GB | `unsloth/FLUX.2-klein-4B-GGUF` | `H:\AI_Models\unsloth\FLUX.2-klein-4B-GGUF\` | `txt2img-flux-klein.json` |
| **Flux.1-dev** Q4_K_S | GGUF | ~6.8 GB | `city96/FLUX.1-dev-gguf` | `H:\AI_Models\comfyui_cache\unet\` | `txt2img-flux-dev.json` |
| **SDXL base 1.0** Q4_0 | GGUF | ~1.5 GB | `hum-ma/SDXL-models-GGUF` | `H:\AI_Models\comfyui_cache\unet\` | `txt2img-sdxl.json` |
| **SDXL refiner 1.0** Q4_0 | GGUF | ~3.1 GB | `gpustack/stable-diffusion-xl-refiner-1.0-GGUF` | `H:\AI_Models\comfyui_cache\unet\` | (optional refiner pass — not wired yet) |
| **SDXL CLIP-L / CLIP-G** | safetensors | ~0.5 GB each | `hum-ma/SDXL-models-GGUF` (`clip/`) | `H:\AI_Models\comfyui_cache\clip\` → `models/clip/` | `txt2img-sdxl.json` |
| **SDXL VAE** xlVAEC_c91 | safetensors | ~0.3 GB | `hum-ma/SDXL-models-GGUF` (`vae/`) | `H:\AI_Models\comfyui_cache\vae\` → `models/vae/` | `txt2img-sdxl.json` |
| **Realistic Vision V5.1** (noVAE) | safetensors | ~4.0 GB | `SG161222/Realistic_Vision_V5.1_noVAE` | `H:\AI_Models\comfyui_cache\checkpoints\` | `txt2img-realism.json` |
| **SD 1.5 VAE** ft-mse | safetensors | ~0.3 GB | `stabilityai/sd-vae-ft-mse` | `H:\AI_Models\comfyui_cache\vae\` | `txt2img-realism.json` |
| **Anything v5 PrtRE** | safetensors | ~4.0 GB | `jackson885/anything-v5-PrtRE` *(Linaqruf repo gated)* | `H:\AI_Models\comfyui_cache\checkpoints\` | `txt2img-anime.json` |
| **4x-AnimeSharp** | `.pth` | ~64 MB | `Kim2091/AnimeSharp` | `H:\AI_Models\comfyui_cache\upscale_models\` | `upscale-image -Model 4x-AnimeSharp` |
| **RealESRGAN_x4plus** | `.pth` | ~64 MB | `schwgHao/RealESRGAN_x4plus` | `H:\AI_Models\comfyui_cache\upscale_models\` | `upscale-image -Model RealESRGAN_x4plus` |

> **Note:** `city96/FLUX.1-dev-gguf` does not publish `Q4_K_M`. We use **Q4_K_S** and keep a hardlink alias `flux1-dev-Q4_K_M.gguf` for backward-compatible symlinks.

> **Note:** SDXL refiner is on disk for future two-pass workflows; base-only workflow is wired in `txt2img-sdxl.json`.

---

## Symlink map

ComfyUI reads from `D:\AI_Models\ComfyUI\ComfyUI\models\`. Large files live on `H:` and are symlinked:

```
models/unet/*.gguf              -> H:\AI_Models\comfyui_cache\unet\ or H:\AI_Models\unsloth\*
models/checkpoints/*.safetensors -> H:\AI_Models\comfyui_cache\checkpoints\
models/clip/*.gguf              -> H:\AI_Models\unsloth\*
models/vae/*.safetensors        -> H:\AI_Models\comfyui_cache\vae\ (or direct ae.safetensors)
models/upscale_models/*.pth     -> H:\AI_Models\comfyui_cache\upscale_models\
```

Run `repair-comfyui-symlinks.ps1` after any restore.

---

## Workflow parameters (1024×1024 defaults)

| Workflow | Steps | CFG | Sampler | Notes |
|----------|-------|-----|---------|-------|
| `txt2img-gen-image-local` | 8 | 1.0 | euler / simple | Default local GPU path |
| `txt2img-flux-dev` | 20 | 3.5 | euler / simple | Flux.1-dev Q4_K_S |
| `txt2img-flux-klein` | 8 | 3.5 | euler / simple | Flux.2 Klein distilled |
| `txt2img-sdxl` | 25 | 7.0 | euler / normal | Dual CLIP + xlVAEC VAE |
| `txt2img-realism` | 28 | 6.5 | dpmpp_2m / karras | + external SD1.5 VAE |
| `txt2img-anime` | 28 | 7.0 | euler_ancestral | Built-in checkpoint VAE |

Placeholder in JSON: `"OVERRIDE_PROMPT"` — replaced by `Invoke-ComfyPrompt`.

---

## Recommended additions (16 GB VRAM, 2026)

Models worth adding next (not auto-installed unless you download):

| Model | Why | Size | Source | License | Format |
|-------|-----|------|--------|---------|--------|
| **Qwen-Image-2512** Q4_K_M | Best open text-in-image + realism (Dec 2025 SOTA) | ~13 GB | `unsloth/Qwen-Image-2512-GGUF` | Apache 2.0 | GGUF + Qwen2.5-VL encoder |
| **Juggernaut XL** Q4_0 | Top SDXL photoreal fine-tune | ~1.5 GB | `hum-ma/SDXL-models-GGUF` | CreativeML Open RAIL++-M | GGUF |
| **RealVisXL V5** Q4_0 | Photoreal SDXL | ~1.5 GB | `hum-ma/SDXL-models-GGUF` | Open RAIL | GGUF |
| **Flux.1-schnell** Q4_K_S | Fast Flux iterations | ~6 GB | `city96/FLUX.1-schnell-gguf` | Apache 2.0 | GGUF |
| **SD 3.5 Large** Q4_K_S | Newer DiT architecture | ~8 GB | `city96/stable-diffusion-3.5-large-gguf` | Stability Community | GGUF |
| **Wan 2.2** (low VRAM) | 2026 open video leader | ~8–14 GB | Comfy-Org / Kijai wrappers | Apache / model-specific | safetensors / GGUF |
| **Pony Diffusion XL** | Stylized / anime SDXL | ~6.5 GB | Civitai mirrors | Fair AI Public License | safetensors |

**Not recommended on 16 GB:** Flux.2 Dev 32B BF16 (~80 GB+), Qwen-Image BF16 (~40 GB), Flux.2 Klein 9B FP16 (~29 GB). Use GGUF Q4–Q5 quants instead.

**No Flux.3** as of June 2026 — latest Black Forest Labs line is **Flux.2 Klein** (4B/9B).

---

## Video models (existing, not part of this restore)

| Model | Path | Workflow |
|-------|------|----------|
| SVD XT | `H:\AI_Models\comfyui_cache\checkpoints\svd_xt.safetensors` | `animate-image` |
| CogVideoX 5B I2V | `H:\AI_Models\comfyui_cache\CogVideo\` | `generate-video` |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Broken symlink (0-byte stub) | Run `restore-comfyui-models.ps1` then `repair-comfyui-symlinks.ps1` |
| `UnetLoaderGGUF` missing | Install **ComfyUI-GGUF** custom node via ComfyUI Manager |
| OOM at 1024² | Drop to 768² or use Q4 quant; close LM Studio GPU models |
| SDXL wrong colors | Ensure `xlVAEC_c91.safetensors` — not `ae.safetensors` |
| Realistic Vision gray output | Ensure `vae-ft-mse-840000-ema-pruned.safetensors` is linked |

---

## Related docs

- `.cursor/docs/IMAGE-VIDEO-CHEATSHEET.md` — PowerShell commands (`gen-image-local`, upscale, video)
- `.cursor/docs/comfyui-setup.md` — Portable install, RTX 50-series CUDA notes
- `.cursor/docs/comfyui-enhancements.md` — Upscaler and multi-model overview
