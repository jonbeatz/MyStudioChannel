# VADER SITH Workstation: LM Studio Optimal Hardware Configurations

This guide provides the mathematically optimized GPU offloading, RAM/VRAM allocations, and context length limits for your newly downloaded models running on your Ryzen 7 9700X and **RTX 5060 Ti 16GB GDDR7** GPU.

---

## 💻 GPU Specifications (VRAM Budget)
*   **VRAM Available:** 16 GB GDDR7
*   **Safe VRAM allocation budget:** 14.5 GB (leaves 1.5 GB for Windows Desktop, Cursor, and dual 1080p monitors)
*   **System RAM Available:** 32GB DDR5-6000 (allows fast CPU fallbacks for larger models)

---

## 🚀 1. Google DiffusionGemma (26B-A4B-it) — "The Speedster"
*   **File Size:** 16.8 GB (Q4_K_M)
*   **VRAM Footprint:** ~17.5 GB if fully loaded (slightly exceeds our 16GB budget).
*   **Optimal Settings:**
    *   **GPU Offload (llama.cpp):** Set `GPU Offload` to **`80%`** or specify **`35-40 layers`** (out of ~46 layers).
    *   **Context Length:** **`8,192`** tokens (Gemma 4 architecture uses high context cache, keeping it at 8k prevents out-of-memory errors).
    *   **CPU Threads:** Set to **`8`** threads (matching the physical core count of your Ryzen 7 9700X).
    *   **Flash Attention:** **`Enabled`** (crucial for accelerating generation speed and saving VRAM).

---

## 🎨 2. Arsenic-Shahrazad 12B v4.4 — "The Uncensored"
*   **File Size:** 7.5 GB (Q4_K_M)
*   **VRAM Footprint:** ~8.2 GB (fits 100% inside VRAM with massive headroom).
*   **Optimal Settings:**
    *   **GPU Offload:** Set to **`100%`** (fully load all **`40 layers`** onto the GPU).
    *   **Context Length:** **`32,768`** tokens (massive context window, perfect for long creative writing or role-playing sessions).
    *   **Flash Attention:** **`Enabled`** (brings speed to ~60+ tokens/second).
    *   **Keep Model in Memory:** Enabled.

---

## 🧠 3. DeepSeek-R1-Distill-Qwen-32B — "The Reasoning Giant"
*   **File Size:** 19.9 GB (Q4_K_M)
*   **VRAM Footprint:** ~21.5 GB (exceeds our 16GB VRAM, requires hybrid GPU + CPU offloading).
*   **Optimal Settings:**
    *   **GPU Offload:** Set to **`55%`** (specify **`32-35 layers`** out of 64). This offloads ~11 GB to your 16GB GDDR7, leaving the remaining layers to run on your lightning-fast Ryzen 7 9700X CPU and DDR5-6000 system RAM.
    *   **Context Length:** **`16,384`** (or **`8,192`** for maximum speed).
    *   **Flash Attention:** **`Enabled`**.
    *   **CPU Threads:** **`8`** threads (very important since CPU is doing substantial work).

---

## 🧑‍💻 4. Qwen 2.5 Coder 14B Instruct — "The Developer King"
*   **File Size:** 9.0 GB (Q4_K_M)
*   **VRAM Footprint:** ~9.8 GB (fits 100% inside VRAM with plenty of space left for local Next.js compilation).
*   **Optimal Settings:**
    *   **GPU Offload:** Set to **`100%`** (fully load all **`48 layers`** onto the RTX 5060 Ti).
    *   **Context Length:** **`32,768`** tokens (essential for passing full codebases, component directories, or server files directly to J.A.R.V.I.S.).
    *   **Flash Attention:** **`Enabled`**.
    *   **Inference Speed:** Expect **~55-65 tokens/second**!

---

## 🚀 5. Qwen 3.6 35B-A3B-MoE — "The Supercharged Expert"
*   **File Size:** 22.3 GB (Q4_K_M)
*   **VRAM Footprint:** Mixture-of-Experts routing (only ~4.5B active parameters per token). Extremely fast inference speed despite its 35B parameter capacity. Fits hybrid GPU/CPU budget beautifully.
*   **Optimal Settings:**
    *   **GPU Offload:** Set to **`65%`** (specify **`26-28 layers`** out of 40). This offloads ~13.5 GB to your RTX 5060 Ti's VRAM, allowing your Ryzen 7 9700X CPU and high-speed DDR5-6000 RAM to process routing experts.
    *   **Context Length:** **`32,768`** tokens (superb for deep coding sessions or large multi-file prompts).
    *   **Flash Attention:** **`Enabled`** (mandatory for maximum performance).
    *   **CPU Threads:** **`8`** threads (crucial for physical core alignment).
    *   **Inference Speed:** Blazing fast due to MoE gating!

---

## ⏱️ VRAM Idle Manager Sync (`vram-idle-manager.ps1`)
*   Since the **Qwen 2.5 Coder 14B** fits comfortably inside your VRAM, it's highly recommended to register its nickname as the primary memory encoder in `scripts/mem0_integration.py` if you prefer it over the smaller `qwen3-4b` model!
*   The background VRAM manager is fully compatible with all 4 of these models. At 15 minutes of idle time, it will silently unload whichever model is active, reclaiming your complete 16GB VRAM for gaming, Next.js hot reloads, or heavy ComfyUI FLUX runs!

---

## ⚙️ Automated LM Studio Override Injections
We have programmatically injected these hardware-optimized configuration profiles directly into LM Studio's concrete defaults located under:
`C:\Users\JONBEATZ\.lmstudio\.internal\user-concrete-model-default-config\`

The following files have been generated to enforce these limits automatically upon model load:

1. **Qwen 2.5 Coder 32B Instruct (Q4_K_M)**
   - **Path:** `.../sabafallah/Qwen2.5-Coder-32B-Instruct-Q4_K_M-GGUF/qwen2.5-coder-32b-instruct-q4_k_m.gguf.json`
   - **Pre-Configured Context Length:** `65,536` tokens
2. **DeepSeek-R1-Distill-Qwen-32B (Q4_K_M)**
   - **Path:** `.../lmstudio-community/DeepSeek-R1-Distill-Qwen-32B-GGUF/DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf.json`
   - **Pre-Configured Context Length:** `32,768` tokens
3. **Qwen 2.5 Coder 14B Instruct (Q4_K_M)**
   - **Path:** `.../itlwas/Qwen2.5-Coder-14B-Instruct-Q4_K_M-GGUF/qwen2.5-coder-14b-instruct-q4_k_m.gguf.json`
   - **Pre-Configured Context Length:** `65,536` tokens
4. **Google DiffusionGemma (26B-A4B-it)**
   - **Path:** `.../unsloth/diffusiongemma-26B-A4B-it-GGUF/diffusiongemma-26B-A4B-it-Q4_K_M.gguf.json`
   - **Pre-Configured Context Length:** `8,192` tokens
5. **Arsenic-Shahrazad 12B v4.4**
   - **Path:** `.../mradermacher/arsenic-shahrazad-12b-v4.4-GGUF/arsenic-shahrazad-12b-v4.4.q4_k_m.gguf.json`
   - **Pre-Configured Context Length:** `32,768` tokens

These overrides ensure that when you select any of these models from LM Studio's dropdown menus or load them via CLI, they will automatically scale to these maximized context windows without requiring manual adjustments in the sidebar.

---

## VRAM collision prevention (required on 16 GB)

| Setting | Value | Why |
|---------|-------|-----|
| **Unload model after idle** | **10 minutes** | Frees CUDA context when you switch to ComfyUI |
| **Only one large model loaded** | Qwen 35B MoE **or** ComfyUI Flux — never both | Combined usage exceeds 16 GB |
| **Context length when coding + ComfyUI same session** | Cap at **8,192–16,384** for 35B MoE | KV cache adds multi-GB overhead |

Before starting ComfyUI, run from repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/vram-check.ps1
```

Full playbook: **`.cursor/docs/VRAM-TROUBLESHOOTING.md`**

