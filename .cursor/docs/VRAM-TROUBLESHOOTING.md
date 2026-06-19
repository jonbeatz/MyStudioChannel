# VRAM Troubleshooting — MyStudioChannel Workstation

RTX **5060 Ti 16GB** · Windows **WDDM** · LM Studio + ComfyUI + Next.js dev stack

---

## Root cause (2026-06-18 investigation)

### The paradox explained

| What you saw | What was actually true |
|--------------|------------------------|
| HUD: **14.7 GB / 16 GB (92%)** | Correct total VRAM used |
| LM Studio UI: **Qwen3-4B ~2.5 GB** | UI shows *currently selected* model size, not total GPU reservation |
| ComfyUI: **no active workflow** | ComfyUI **server still running** holds CUDA context + cached weights |
| Status: **Nominal** | Old HUD only checked **TCP ports**, not VRAM health |

### Primary culprits (confirmed)

1. **LM Studio + ComfyUI simultaneous CUDA contexts** — Both had compute processes on GPU (`LM Studio.exe` PID 4500, `python.exe` ComfyUI PID 28304).
2. **Orphaned / residual VRAM on WDDM** — Windows does not report per-process VRAM in `nvidia-smi` (shows `N/A`). Total used MiB is authoritative.
3. **Previously loaded large models** — Qwen 35B MoE or Flux pipelines can leave multi-GB reservations until the **process exits**, not when the UI says "unload".
4. **`--gpu-reset` unavailable on Windows WDDM** — `nvidia-smi --gpu-reset` is Linux/TCC only; cleanup = **kill compute processes**.

### Proof

Emergency cleanup (`vram-cleanup.ps1`) dropped VRAM from **~15,100 MB → ~843 MB (5.2%)** without driver reset — confirming process-held memory, not a driver bug.

---

## Quick reference

| VRAM % | Level | Action |
|--------|-------|--------|
| &lt; 65% | Healthy | Safe for one large workload |
| 65–80% | Warn | Do not start second AI app |
| 80–90% | High | Unload LM Studio model or stop ComfyUI |
| &gt; 90% | Critical | Run `vram-cleanup.ps1` immediately |

---

## Step-by-step cleanup

### Manual (recommended)

```powershell
# Local (Cursor / repo root)
powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/vram-cleanup.ps1
```

Stops: all `python`/`pythonw` (ComfyUI), all `LM Studio` processes.  
Waits 3s for WDDM to release memory.  
Reports post-cleanup VRAM.

### From dev site HUD

1. Open `http://localhost:3000`
2. Hover bottom-left **SystemStats** panel
3. Click **Emergency VRAM cleanup**

Or POST:

```http
POST http://localhost:3000/api/system/emergency-vram-cleanup
```

### Pre-flight before ComfyUI

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/custom-scriptz/vram-check.ps1
```

Exit **0** = safe · Exit **1** = high VRAM

---

## Emergency VRAM Cleanup — GPU reset switch

**What it does:** Stops all ComfyUI (`python`) and LM Studio processes, then waits for Windows WDDM to release VRAM. It does **not** reset the NVIDIA driver (unsupported on WDDM).

### Use when

| Situation | Why |
|-----------|-----|
| **VRAM &gt; 80%** and you need headroom | Frees stuck CUDA contexts |
| **ComfyUI or LM Studio crashed** but VRAM stays high | Orphaned process memory |
| **Before heavy work** (Flux, SDXL, 35B MoE) and VRAM **&gt; 65%** | Pre-flight clear so generation does not OOM |

### Do **not** use when

| Situation | Why |
|-----------|-----|
| A model is **actively generating** or processing | Kills the job mid-run |
| VRAM is already **&lt; 65%** | Unnecessary; use normal unload instead |
| You are in a **long-running task** you want to keep | Cleanup stops LM Studio + ComfyUI entirely |

### Triggers

- **HUD:** `http://localhost:3000` → hover SystemStats → **Emergency VRAM cleanup** (confirmation dialog matches VRAM level)
- **Script:** `.cursor/custom-scriptz/vram-cleanup.ps1`
- **API:** `POST /api/system/emergency-vram-cleanup` (localhost dev only)

### Hermes / agent playbook

Agents **may** run emergency cleanup **only** when Jon reports high VRAM, a crash with stuck memory, or before starting heavy ComfyUI/LLM work **and** VRAM is above 65%. **Never** run cleanup during active generation or when VRAM is already healthy (&lt; 65%) unless Jon explicitly asks for a full GPU reset.

---

## Scripts inventory

| Script | Purpose |
|--------|---------|
| `.cursor/custom-scriptz/vram-check.ps1` | Pre-flight threshold (10 GB) |
| `.cursor/custom-scriptz/vram-cleanup.ps1` | Emergency full cleanup |
| `.cursor/custom-scriptz/vram-diagnostics.ps1` | JSON snapshot for API/HUD |
| `.cursor/custom-scriptz/vram-watcher.ps1` | 30s polling → `vram-log.txt` |
| `.cursor/custom-scriptz/vram-auto-clean.ps1` | Scheduled: kill python @ 12 GB, LM Studio @ 14 GB |
| `start-mystudio.ps1` | Stack launcher with cleanup menu on high VRAM |

---

## LM Studio optimization

**App settings (manual):**

- Settings → Model → **Unload model after idle: 10 minutes** (600s)
- Do **not** keep Qwen 35B MoE loaded while ComfyUI is needed
- Prefer **one model at a time** on 16 GB

See also: `.cursor/docs/LMSTUDIO-OPTIMAL-CONFIG.md`

---

## ComfyUI optimization

ComfyUI does **not** use `extra_model_paths.yaml` for VRAM flags. Use launch args:

| Flag | When |
|------|------|
| Default | 16 GB with GGUF workflows |
| `--lowvram` | If OOM during Flux/SDXL |
| Stop server when idle | Close ComfyUI window or kill python — idle server still reserves VRAM |

Current launcher: `D:\AI_Models\ComfyUI\run_nvidia_gpu.bat`

### ComfyUI VRAM management (explicit control)

ComfyUI **must not** auto-start with the dev stack. Use explicit commands:

| Command | Action |
|---------|--------|
| `npm run msc:comfy:start` | Start ComfyUI (VRAM pre-flight) |
| `npm run msc:comfy:stop` | Stop ComfyUI only — **does not** kill LM Studio |
| `npm run msc:comfy:restart` | Stop → wait 2s → start (stuck/unknown states) |
| `npm run msc:comfy:status` | JSON state (port, queue, PIDs) |
| `npm run msc:vram:diag` | Full VRAM + ComfyUI state for HUD API |

**Flags:**

- `start-comfyui.ps1 -NoVRAMCheck` — skip VRAM gate (emergency generation)
- `start-comfyui.ps1 -Force` — warn but continue if VRAM high
- `start-comfyui.ps1 -UnloadLMStudio` — `lms unload --all` before start
- `stop-comfyui.ps1 -DryRun` — preview PIDs that would be killed

**Audit log:** `logs/comfyui.log` (last 500 lines, gitignored)

**HUD states** (`http://localhost:3000` bottom-left):

| State | Meaning |
|-------|---------|
| `stopped` | Port 8188 down |
| `idle` | Server up, queue empty — **still holds VRAM** |
| `generating` | Jobs in queue |
| `unknown` | Port up, `/queue` unavailable (booting) — shown in **gold**, not red |

**Signs ComfyUI runs in background:** Port 8188 listening + high total VRAM + HUD showed "off" (old bug — fixed via WMI + queue detection).

**Profile auto-start:** Disabled by default. Set `$env:MSC_COMFYUI_AUTO_START='1'` for one session, or use `comfy-start` / HUD.

**Idle watcher:** Opt-in only — `start-mystudio.ps1` menu option **5** or `npm run msc:comfy:idle-watcher` (suggests stop after 15 min, never auto-kills).

**Voice:** `comfy-start`, `comfy-stop`, `comfy-restart` in PowerShell profile.

Optional low-VRAM wrapper (repo):

```powershell
# .cursor/custom-scriptz/start-comfyui-lowvram.ps1
Start-Process -FilePath "D:\AI_Models\ComfyUI\python_embeded\python.exe" `
  -ArgumentList "-s", "ComfyUI\main.py", "--windows-standalone-build", "--lowvram" `
  -WorkingDirectory "D:\AI_Models\ComfyUI" -WindowStyle Minimized
```

---

## Best practices (enforce)

1. **Unload LM Studio** (or use idle auto-unload) **before** starting ComfyUI.
2. **Stop ComfyUI** (`python.exe` under `ComfyUI`) when not generating.
3. **Never** run Qwen 35B MoE + ComfyUI Flux concurrently on 16 GB.
4. **Restart ComfyUI** after a failed OOM generation.
5. **Close unused Brave tabs** with WebGL/video (GPU compute listed in `nvidia-smi`).
6. Run **`start-mystudio.ps1`** — default option **1** (no ComfyUI); use **`npm run msc:comfy:start`** when generating images.

---

## Emergency recovery

If VRAM stays high after cleanup:

1. Close Brave, Docker Desktop, extra Cursor windows
2. Re-run `vram-cleanup.ps1`
3. Reboot PC (guaranteed WDDM flush)
4. After reboot, idle VRAM should be **&lt; 2 GB**

---

## Monitoring

- **HUD:** `http://localhost:3000` → bottom-left panel (VRAM %, ComfyUI state, queue counts, Start/Stop/Restart, emergency cleanup)
- **API:** `GET /api/system/vram` · `POST /api/system/comfyui/start|stop|restart`
- **Watcher:** `powershell -File .cursor/custom-scriptz/vram-watcher.ps1` (background)

---

## Windows / driver notes

- **WDDM** shares GPU with desktop compositor — `dwm.exe`, `Cursor.exe`, `brave.exe` appear in process list with `N/A` VRAM.
- **Per-process VRAM** unavailable on Windows consumer drivers; trust **total** `memory.used`.
- Driver **596.49** / CUDA **13.2** — no known leak; issue was **dual AI stacks**.

---

## Related docs

- `LMSTUDIO-OPTIMAL-CONFIG.md`
- `COMFYUI-MODELS.md`
- `Restore-Points.md` → `RP-2026-06-18-workstation-unified-performance-guard`
