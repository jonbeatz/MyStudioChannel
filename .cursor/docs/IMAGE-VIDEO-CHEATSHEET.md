# Image and Video Capabilities Master Cheat Sheet

This document serves as your unified reference guide for all local and remote media generation and editing tools available in your workstation environment. It bridges the gap between raw PowerShell scripting and natural language commands executed by J.A.R.V.I.S.

---

## 1. Quick Reference Card

| What I Want | Command | Where It Runs |
|-------------|---------|---------------|
| Generate new image from text | `gen-image "prompt"` | Hugging Face API (remote) |
| Edit existing image | `edit-image -InputPath "file.png" -Prompt "changes"` | Local ComfyUI |
| Inpaint (replace area) | `inpaint-image -InputPath "file.png" -MaskPath "mask.png" -Prompt "new object"` | Local ComfyUI |
| Upscale to 4K | `upscale-image -InputPath "file.png" -TargetSize 4K` | Local ComfyUI |
| Fix faces | `fix-face -InputPath "file.png"` | Local ComfyUI |
| Generate video from text | `generate-video -Prompt "a dog running" -Duration 5` | Local ComfyUI (CogVideoX) |
| Animate a still image | `animate-image -InputPath "file.png" -Motion "zoom"` | Local ComfyUI (SVD) |

### 1.5 Natural Language Prompts (How You'll Actually Use It)
You do not need to remember rigid syntax. Just describe what you want in plain English, and J.A.R.V.I.S. will translate it into the appropriate tool execution:

| You Say | What J.A.R.V.I.S. Does |
|---------|-------------------------|
| make me a chicken playing golf on a football field | Runs `gen-image` with your prompt |
| edit this image and make the background blue | Runs `edit-image` on the last generated or specified image |
| fix the faces in this photo | Runs `fix-face` on the specified image |
| turn this photo into a video | Runs `animate-image` with default motion |
| make a 5 second video of a futuristic city | Runs `generate-video -Duration 5` |
| upscale this to 4K | Runs `upscale-image -TargetSize 4K` |
| inpaint this photo to remove the logo | Runs `inpaint-image` (asks for mask if not provided) |
| make this look like golden hour | Uses IC-Light nodes to change lighting |

#### Clarifying Handshakes (What J.A.R.V.I.S. Will Ask You If Missing)
*   **Which image?** *"Which image should I use? The last generated one or a specific file?"*
*   **Dimensions?** *"What dimensions? 1920x1080, 4K, or 1024x1024?"*
*   **How much change?** *"Should this be a subtle change (0.3) or dramatic (0.8)?"*
*   **Video duration?** *"How many seconds? (2-10 recommended)"*
*   **Mask for inpainting?** *"Please provide a mask image (white = keep, black = replace) or describe the area to change."*

#### Example Conversation Flow
1.  **You:** make a portrait of an astronaut on Mars
2.  **J.A.R.V.I.S.:** *[Generates image]* Saved to `public/media/generated-12345.png`
3.  **You:** fix the face on that one
4.  **J.A.R.V.I.S.:** *[Runs fix-face on public/media/generated-12345.png]* Face enhanced and saved to `public/media/facefixed-12345.png`.
5.  **You:** now turn it into a video, slow zoom in
6.  **J.A.R.V.I.S.:** *[Runs animate-image]* Video saved to `public/media/animated-12345.mp4`.

---

### 1.6 Automatic Dimension Parsing (When You Say "4K", "HD", etc.)

When interpreting your natural language, J.A.R.V.I.S. translates dimension keywords into structured parameters:

| You Say | J.A.R.V.I.S. Sets |
|---------|-------------------|
| `4K`, `ultra hd`, `3840x2160` | `-TargetSize 4K` or `-Width 3840 -Height 2160` |
| `HD`, `widescreen`, `1080p`, `1920x1080` | `-TargetSize 1080p` or `-Width 1920 -Height 1080` |
| `vertical`, `phone`, `9:16`, `1080x1920` | `-Width 1080 -Height 1920` (Orientation swap) |
| `square`, `1024x1024` | `-Width 1024 -Height 1024` |
| `4:3`, `1024x768` | `-Width 1024 -Height 768` |

---

## 2. Detailed Command Guide

### A. gen-image (Text to Image)
Generates high-fidelity original images from natural language descriptions via remote Hugging Face APIs.

*   **PowerShell Syntax:**
    ```powershell
    gen-image -Prompt "prompt string" [-Width <Int>] [-Height <Int>]
    ```
*   **Natural Language:** `"make me a beautiful mountain landscape"` or `"make me a 4K vertical phone wallpaper of an astronaut"`
*   **Typical Output Location:** `public/media/generated-timestamp.png`
*   **Expected Time:** ~10-15 seconds
*   **Best Results Tip:** Add descriptive details such as "photorealistic, cinematic lighting, 8k resolution" to maximize quality. Add dimensional qualifiers like "vertical" or "4K" to auto-parse aspect ratios.

---

### B. edit-image (Image to Image / Refinement)
Modifies an existing local image based on a prompt and change-strength ratio using local GGUF models.

*   **PowerShell Syntax:**
    ```powershell
    edit-image -InputPath "path/to/image.png" -Prompt "prompt string" [-Strength <Float>] [-OutputPath <String>]
    ```
*   **Natural Language:** `"edit this image and make the background snowy"` or `"make the car red with 0.6 strength"`
*   **Parameters:**
    *   `-InputPath` (required): Path to the source image file.
    *   `-Prompt` (required): Text description of the desired changes.
    *   `-Strength` (optional): Range `0.1` (almost no change) to `0.9` (full repaint). Default: `0.5`.
    *   `-OutputPath` (optional): Where to save the output.
*   **Typical Output Location:** `public/media/edited-timestamp.png`
*   **Expected Time:** ~10-20 seconds
*   **Best Results Tip:** A strength of `0.3` to `0.5` is ideal for adding elements while preserving structural details. Use `0.7+` only when you want a complete reimagining.

---

### C. inpaint-image (Area Selection and Replacement)
Surgically replaces a specific area of an image outlined by a black-and-white mask.

*   **PowerShell Syntax:**
    ```powershell
    inpaint-image -InputPath "path/to/image.png" -MaskPath "path/to/mask.png" -Prompt "prompt string" [-OutputPath <String>]
    ```
*   **Natural Language:** `"inpaint this photo to replace the logo with a red sports car"`
*   **Parameters:**
    *   `-InputPath` (required): The original image.
    *   `-MaskPath` (required): A mask image where solid white (`#FFFFFF`) marks the region to preserve, and solid black (`#000000`) marks the region to be replaced.
    *   `-Prompt` (required): Description of the object to place inside the masked area.
    *   `-OutputPath` (optional): Destination path.
*   **Typical Output Location:** `public/media/inpainted-timestamp.png`
*   **Expected Time:** ~15-25 seconds
*   **Best Results Tip:** Keep the boundaries of your mask soft (slightly feathered) for seamless blending with the original image surroundings.

---

### D. upscale-image (4K Upscaling)
Takes any source image and runs high-fidelity super-resolution to expand it up to 4K or custom dimensions.

*   **PowerShell Syntax:**
    ```powershell
    upscale-image -InputPath "path/to/image.png" [-TargetSize <String>] [-Model <String>] [-OutputPath <String>]
    ```
*   **Natural Language:** `"upscale this image to 4K"` or `"upscale with AnimeSharp model"`
*   **Parameters:**
    *   `-InputPath` (required): Path to the low-resolution file.
    *   `-TargetSize` (optional): `1080p`, `4K`, or custom like `3840x2160`. Default: `4K`.
    *   `-Model` (optional): `4x-UltraSharp`, `4x-AnimeSharp`, or `RealESRGAN_x4plus`. Default: `4x-UltraSharp`.
    *   `-OutputPath` (optional): Final path.
*   **Typical Output Location:** `public/media/upscaled-timestamp.png`
*   **Expected Time:** ~5-10 seconds
*   **Best Results Tip:** Use `4x-UltraSharp` for photographs and real-world assets. Use `4x-AnimeSharp` for illustrations, logos, and stylized graphic design.

---

### E. generate-video (Text-to-Video via CogVideoX)
Generates high-quality, high-consistency video clips from text descriptions using local CogVideoX-5B GGUF architectures.

*   **PowerShell Syntax:**
    ```powershell
    generate-video -Prompt "prompt string" [-Duration <Int>] [-Frames <Int>] [-Width <Int>] [-Height <Int>] [-OutputPath <String>]
    ```
*   **Natural Language:** `"make a 5 second video of a dog running on the beach"` or `"generate a cinematic clip of a flying car"`
*   **Parameters:**
    *   `-Prompt` (required): Text description of the scene and motion.
    *   `-Duration` (optional): Target video duration in seconds (2 to 10). Default: `5`.
    *   `-Frames` (optional): Target frames to sample. Default: `49` (corresponding to 5s at ~10fps).
    *   `-Width` / `-Height` (optional): Target sampling dimensions. Default: `1024x576`.
    *   `-OutputPath` (optional): Final video path.
*   **Typical Output Location:** `public/media/video-timestamp.mp4`
*   **Expected Time:** ~2-5 minutes (highly dependent on frame counts and GPU scheduling)
*   **Best Results Tip:** Be explicit about camera movements in your prompt, e.g., "slow drone panning shot, cinematic zoom, tracking shot".

---

### F. animate-image (Image-to-Video via Stable Video Diffusion)
Converts a static 16:9 or 4:3 still photograph into a dynamic moving video clip using Stable Video Diffusion (`svd_xt`).

*   **PowerShell Syntax:**
    ```powershell
    animate-image -InputPath "path/to/image.png" [-Motion <String>] [-Duration <Int>] [-OutputPath <String>]
    ```
*   **Natural Language:** `"turn this photo into a video with a slow zoom"` or `"animate this still photo"`
*   **Parameters:**
    *   `-InputPath` (required): Source image.
    *   `-Motion` (optional): Camera motion hints (`zoom`, `pan`, `orbit`, `static`). Default: `zoom`.
    *   `-Duration` (optional): Target length in seconds. Default: `5` (25 frames at 5-6fps).
    *   `-OutputPath` (optional): Final video path.
*   **Typical Output Location:** `public/media/animated-timestamp.mp4`
*   **Expected Time:** ~1-3 minutes
*   **Best Results Tip:** Use high-contrast, structurally well-defined inputs. Images with strong perspective elements (roads leading into distance, shorelines) translate into the most spectacular SVD animations.

---

### G. fix-face (Facial Restoration and Detailing)
Detects human faces in any image and runs local YOLO bounding-box details with restoration models to repair blurry or low-res features.

*   **PowerShell Syntax:**
    ```powershell
    fix-face -InputPath "path/to/image.png" [-Prompt <String>] [-OutputPath <String>]
    ```
*   **Natural Language:** `"fix the faces in this photo"` or `"restore the faces in portrait.png"`
*   **Parameters:**
    *   `-InputPath` (required): Path to the source photograph.
    *   `-Prompt` (optional): Positive detail prompt for face. Default: `"highly detailed face, realistic eyes, detailed skin texture, raw photo, masterwork, 8k"`.
    *   `-OutputPath` (optional): Final path.
*   **Typical Output Location:** `public/media/facefixed-timestamp.png`
*   **Expected Time:** ~10-20 seconds
*   **Best Results Tip:** Use default prompts for real-world faces. If fixing faces in paintings or stylized art, override the `-Prompt` parameter (e.g., `-Prompt "watercolor face painting, soft edges, detailed sketch"`) to prevent the model from stamping realistic skin textures onto art.

---

## 3. Workflow Examples (Step-by-Step Recipes)

### Example 1: Generate an Image, then Edit It
Generate a baseline sunset landscape remotely, and then local-edit it into a snowy winter landscape:
```powershell
# Step 1: Generate original sunset image
gen-image "a beautiful mountain landscape at sunset"

# Step 2: Local edit using wildcards to capture the latest generated image
edit-image -InputPath "public/media/generated-*.png" -Prompt "make it a snowy winter scene" -Strength 0.6
```

### Example 2: Fix Faces in a Generated Photo
Generate a close-up portrait of a person remotely, and then run local YOLO bounding-box detail restoration:
```powershell
# Step 1: Generate portrait
gen-image "close-up portrait of a smiling woman, photorealistic"

# Step 2: Detail the face to absolute perfection
fix-face -InputPath "public/media/generated-*.png"
```

### Example 3: Turn a Still Photo into a Video
Animate a generated sunset landscape into a moving video clip:
```powershell
# Step 1: Choose a scenic still image and animate it with zoom
animate-image -InputPath "public/media/some-photo.png" -Motion "slow zoom" -Duration 5
```

### Example 4: Upscale to 4K for Printing or Desktop Wallpaper
Enlarge an existing low-res asset to professional 4K output:
```powershell
# Step 1: Execute sharp upscaling
upscale-image -InputPath "public/media/some-image.png" -TargetSize 4K -OutputPath "desktop/4k-version.png"
```

### Example 5: Object Replacement via Inpainting
Replace a boring background element with a sports car:
```powershell
# Step 1: Inpaint with target mask mapping
inpaint-image -InputPath "photo.png" -MaskPath "mask.png" -Prompt "a red sports car"
```

### Example 6: Direct Text-to-Video Clip
Generate a high-fidelity video directly from a prompt description:
```powershell
# Step 1: Render 8 seconds of text-to-video frames
generate-video -Prompt "cinematic shot of waves crashing on rocks, 4k" -Duration 8
```

---

## 4. Model Reference Matrix

| Model | Best For | Speed | Quality |
|-------|----------|-------|---------|
| **`z-image-turbo`** (default edit) | Fast, highly interactive image editing | Fast | Good |
| **`flux-1-dev`** | Photorealistic faces, intricate hand details, complex text rendering | Medium | Excellent |
| **`SDXL Base + Refiner`** | Versatile scenery, illustration styles, generic text-to-image | Slow | Very Good |
| **`Realistic Vision v5.1`** | Real people, analog photography, realistic portraiture | Medium | Excellent |
| **`Anything v5`** | Anime, illustrative, cartoon, and stylized fantasy art | Medium | Very Good |
| **`CogVideoX`** (Text-to-Video) | Generative physics, continuous object movement from prompts | Slow | Good |
| **`SVD`** (Image-to-Video) | Realistic image panning, zoom effects, liquid/cloud motion | Slow | Good |

---

## 5. Custom Nodes & Addons Reference

*   **Impact Pack (`fix-face` command):** Uses YOLO models to locate faces and masks them dynamically, feeding them to an isolated detailing pipeline for ultra-clean expressions.
*   **IC-Light:** Provides studio-level light redirection and ambient color changing. You can use it to completely change lighting angles (e.g., "make this look like golden hour" or "add dramatic neon side-lighting").
*   **InstantID:** Identity preservation module. Allows you to swap or inject faces into arbitrary images while maintaining strict facial shape and feature alignment.
*   **Segment Anything 2 (SAM2):** Surgical, interactive object-boundary detector. Used to isolate subjects from complex backgrounds instantly.
*   **ControlNet:** Restricts structural generation based on a reference image's posture, depth map, or lines (e.g., "make this pose match my reference image").

---

## 6. Troubleshooting

| Issue | Root Cause | Solution |
|-------|------------|----------|
| `edit-image` takes forever or hangs | ComfyUI local server is not running or listening | Open your browser to `http://127.0.0.1:8188` to confirm active listening. If not, launch the server using your custom terminal start commands. |
| Out of memory (`CUDA OOM`) | Image resolution is too high for your GPU VRAM | Limit input images to 1024x1024 before editing, or close high-overhead background applications. CogVideoX and SVD are memory-intensive. |
| Face fix has no effect | YOLO face detector did not trigger | Ensure the subject's face is clearly visible, or decrease the detector threshold parameter in your ComfyUI configuration. |
| Video generation fails | Frame count is too high | Decrease the `-Duration` or `-Frames` parameter (5 seconds with 49 frames is highly recommended as a baseline). |

---

## 7. Web UI Tips (`http://127.0.0.1:8188`)

While our PowerShell CLI functions provide high-speed automation, the ComfyUI Web interface offers visual interactive power:

*   **Drag-and-Drop Workflows:** Any PNG generated or saved by ComfyUI contains its entire generating node graph embedded in its metadata. Drag and drop any image directly into the Web UI canvas to load its exact workflow!
*   **Visual Debugging:** Watch nodes light up with green outlines as they execute to see exactly where progress is, or which node is processing model weights.
*   **Workflow Preservation:** Save custom graphs as JSON files inside `D:\AI_Models\ComfyUI\workflows\` to instantly wire them to J.A.R.V.I.S. CLI commands.

---

## 8. Parameter Range Reference

*   **`-Strength` (Image Editing):** Range: `0.1` to `0.9`. Use `0.2` to `0.4` for subtle touch-ups. Use `0.5` to `0.7` for moderate adjustments. Use `0.8+` for severe stylistic changes.
*   **`-Duration` (Video Length):** Range: `2` to `10` seconds. Baseline: `5` seconds. Avoid running higher than `10` seconds on single-pass runs to prevent rendering delays.
*   **`-TargetSize` (Resolution):** `1080p` (1920x1080) or `4K` (3840x2160).
*   **`-Motion` (Image Animation):** Options: `zoom` (continuous camera dolly), `pan` (left/right sliding movement), `orbit` (3D camera rotation), `static` (preserves static geometry with active particles).

---

## 9. Performance Notes

*   **Warmup Cost:** The very first execution of any local model (e.g., loading `flux` or `CogVideoX`) will take slightly longer (~20-40 seconds) because the system must load heavy model weights from your high-speed SSD cache into active GPU VRAM.
*   **Cached Execution:** Subsequent runs of the same model happen in near-real-time because weights remain resident in memory.
*   **VRAM Allocation:** Generating videos (`CogVideo` and `SVD`) consumes significant GPU processing power. Close other high-overhead graphics applications (like premium video editors or active 3D games) when rendering complex video clips.

---

## 10. Quick Prompts Library

*   **Photorealistic Portraiture:**
    > "close-up portrait of [subject], photorealistic, 8K resolution, detailed skin pores, highly defined eyes, cinematic dramatic lighting, shallow depth of field, raw camera photo, masterwork"
*   **Cyberpunk Landscape:**
    > "a bustling futuristic cyberpunk city street, neon purple and blue holographic signs, rainy night reflecting on wet concrete, hovering vehicles, 8k resolution, highly detailed, octane render"
*   **Illustrative Fantasy:**
    > "ethereal fantasy landscape, magical glowing crystal forest, majestic waterfall under dual moons, vibrant colors, detailed watercolor and digital ink style, Studio Ghibli inspired, whimsical"
*   **Anime / Manga Character:**
    > "anime style, vibrant colors, close-up character portrait of [subject], clean ink outlines, soft cell-shading, dynamic background elements, 4k"

---

## 11. Model Download Status

All local weights are downloaded and fully operational across your drives:

| Model | Status | Drive Cache Location |
|-------|--------|----------------------|
| `flux1-dev-Q4_K_M.gguf` (7.02 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\unet\` |
| `stable-diffusion-xl-base-1.0-Q4_0.gguf` (3.54 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\unet\` |
| `stable-diffusion-xl-refiner-1.0-Q4_0.gguf` (3.06 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\unet\` |
| `Realistic_Vision_V5.1_noVAE.safetensors` (4.02 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\checkpoints\` |
| `anything-v5-PrtRE.safetensors` (4.03 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\checkpoints\` |
| `svd_xt.safetensors` (8.90 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\checkpoints\` |
| `CogVideoX_5b_I2V_GGUF_Q4_0.safetensors` (3.30 GB) | ✅ Complete | `H:\AI_Models\comfyui_cache\CogVideo\` |
| `4x-UltraSharp.pth` | ✅ Complete | `H:\AI_Models\comfyui_cache\upscale_models\` |
| `4x-AnimeSharp.pth` | ✅ Complete | `H:\AI_Models\comfyui_cache\upscale_models\` |
| `RealESRGAN_x4plus.pth` | ✅ Complete | `H:\AI_Models\comfyui_cache\upscale_models\` |

*Note: All commands are pre-wired, pre-symlinked, and fully ready for immediate high-performance deployment!*
