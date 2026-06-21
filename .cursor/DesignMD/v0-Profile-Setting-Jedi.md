# v0 Master Prompt — "Profile Jedi" Settings Panel

A single, paste-ready prompt to build the full **Settings** experience for the existing Profile Jedi
app. It merges Jon's tab spec with the recommended additions, aligned to the real Hermes Profile
Switcher backend (`D:\Hermes\custom-scriptz\profile-switcher\Switch-Hermes-Profile.ps1`).

- **Part A** = paste this whole block into v0 (continue on the existing Profile Jedi project).
- **Part B** = backend wiring map (for Cursor later — do NOT paste into v0).

Legend inside the prompt: settings marked **(wire)** map to the real PowerShell backend later;
everything else is pure UI/localStorage state for now.

---

## PART A — PASTE INTO v0 (below the divider)

---

Continue building the existing **Profile Jedi** app. Now build the **Settings** experience, opened
from the gear icon in the top bar. Keep the established aesthetic exactly: obsidian base
(`#070708`→`#0D0D11`), Studio Gold accent `#F5B841`, glassmorphism
(`backdrop-filter: blur(20px) saturate(140%)` over `rgba(13,13,17,0.45)`), ultra-thin borders, 1px
inner top highlight, Geist UI + Geist Mono for values/paths, and the same spring/Framer Motion
animations used by the Create/Adopt modals.

### Shell & layout

- A **full-screen premium glass modal** titled **SETTINGS** with the subtitle
  "A premium control panel for your Hermes environment." Spring scale-in (`0.96→1`) + backdrop blur.
- **Left vertical tab rail** (icon + label, active tab has a gold left indicator + glow): **General,
  Appearance, Console, Shortcuts, Integrations, Data & Storage, Advanced, About.**
- **Right content area** scrolls internally; settings grouped in glass cards with uppercase eyebrow
  section headers. Each setting row = label + short helper text + control on the right.
- **Sticky footer** inside the modal: a left "unsaved changes" dot/label when dirty, right side
  **Save Changes** (gold filled) + **Cancel** (ghost). `Esc` cancels; clicking backdrop asks to
  discard if dirty.
- Appearance settings **apply live** (preview) while open; Save persists, Cancel reverts.
- Use shadcn primitives: Switch, Select, Slider, Input (with a path/monospace variant), Tabs,
  Tooltip, AlertDialog (for destructive confirms), Button, Table, Badge.

### TAB 1 — GENERAL

- **Default new-profile location** — text input prefilled `D:\Hermes` + **Browse** button. Helper:
  "Where new profiles are created unless you choose a custom path." **(wire)**
- **Default model for new profiles** — Select, default `vader-3-flash` (options: `vader-3-flash`,
  `vader-3.5-flash`). **(wire)**
- **Default description template** — input, default `Hermes profile for {name}`.
- **Auto-Launch Hermes on Switch** — toggle, default ON. **(wire)**
- **Confirm Before Switch** — toggle, default ON.
- **Switch Behavior** — Select: **Close Hermes** (default) / **Keep Running** (maps to the `-NoKill`
  flag). Helper: "Keep Running leaves your current Hermes window open." **(wire)**
- **Auto-Sync CLI Profile on Switch** — toggle, default ON (runs the profile's
  `sync-hermes-profile.ps1`). **(wire)**

### TAB 2 — APPEARANCE

- **Theme** — Select: **Dark** (default, canonical) / Light / System. (Dark is the brand; Light is a
  tasteful inversion — keep gold accent.)
- **Accent Color** — preset swatches: **Jedi Gold `#F5B841`** (default), Saber Green `#3FB950`,
  Sith Red `#F85149`, Ice Blue `#58A6FF`, plus a custom hex picker. Live-updates a global
  `--accent` CSS variable across the whole app.
- **Accent Intensity** — Select: Subtle / **Medium** (default) / Bold (controls glow + border alpha).
- **Glass Intensity** — Select: Low / **Medium** (default) / High (controls blur/saturation).
- **Film Grain** — toggle, default ON. **Edge Vignette** — toggle, default ON. **Wordmark Glow** —
  toggle, default ON.
- **Show Monograms** — toggle, default ON. **Show CLI Status pills** — toggle, default ON.
- **Compact Mode** — toggle (denser cards/rows), default OFF.
- **Animation Speed** — Select: **Full** (default) / Reduced / Off (Off also respects
  `prefers-reduced-motion`).
- **UI Font** — Select: Geist (default) / Space Grotesk.

### TAB 3 — CONSOLE (J.A.R.V.I.S.)

- **Show J.A.R.V.I.S. Footer** — toggle, default ON.
- **Waveform Animation** — toggle, default ON.
- **Waveform Color** — Select: **Gold** (default) / White / Gradient.
- **Service Polling Interval** — Select: 2s / **5s** (default) / 10s / 30s. **(wire)**
- **Show Service Ports** — toggle, default ON.
- **Service Capsule Style** — Select: **Pill** (default) / Rounded / Minimal.
- **Monitored Services** — an editable list (Table) of capsules, each row: enabled toggle, Name,
  Endpoint/host, Port, plus **Add Service** and per-row remove. Seed rows: `LiteLLM` `127.0.0.1`
  `4000`; `ngrok` `127.0.0.1` `4040`; `LM Studio` `127.0.0.1` `1234`; `Hermes Gateway` (label only).
  **(wire — real probes later)**
- **Google API stack** — a full **Google API Stack card** (status-aware, not a plain toggle). See the
  dedicated **"Google API Control"** section below for the exact spec. Helper: "Runs your
  D:\Hermes\custom-scriptz\google-api start/stop scripts." **(wire)**

### TAB 4 — SHORTCUTS

A **Table** of keyboard shortcuts (Action | Keybinding | editable). Rows:
- Command Palette — `Ctrl+K`
- New Profile — `Ctrl+N`
- Focus Search — `/`
- Switch Selected Profile — `Enter`
- Navigate List — `Arrow Keys`
- Open Settings — `Ctrl+,` (editable; default comma is conventional, but allow `Ctrl+S`)
- Close Modals — `Esc` (editable)
- Toggle Dry-Run — `Ctrl+D` (editable)

Each editable row has a "click to record new keybinding" capture control and a reset-to-default.
Show a warning badge on conflicts. Include a **Reset all shortcuts** button.

### TAB 5 — INTEGRATIONS

- **Hermes Desktop Path** — display-only, auto-detected
  `%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` (copy button).
- **Cursor Path** — display-only, auto-detected (copy button).
- **PowerShell Execution Policy** — Select: **Bypass** (default) / RemoteSigned / AllSigned. **(wire)**
- **Profile Template Source** — text input, default
  `D:\Hermes\custom-scriptz\profile-switcher\profile-template`. **(wire)**
- **Switcher Script Path** — text input, default
  `D:\Hermes\custom-scriptz\profile-switcher\Switch-Hermes-Profile.ps1`, with a **Test Backend**
  button (runs `-Action list`; for now mock-resolves to a success toast showing profile count).
  **(wire)**
- **Open folders with** — Select: File Explorer (default) / Windows Terminal.
- **Sync on Launch** — toggle, default ON (re-sync CLI profiles when Profile Jedi starts). **(wire)**

### TAB 6 — DATA & STORAGE

- **Profiles Registry Path** — display-only `D:\Hermes\custom-scriptz\profile-switcher\profiles.json`
  (copy button).
- **Active Profile File** — display-only `%APPDATA%\Hermes\active-profile.json` (copy button).
- **Mem0 Store Path** — text input, default `%USERPROFILE%\.mem0`. **(wire)**
- **Local API Port** — number input, default `7780` (the local-only server port).
- **Import Registry** / **Export Registry** — buttons (backup/restore `profiles.json`). **(wire)**
- **Backup Now** — button (snapshots settings + registry). **(wire)**
- **Restore from Backup** — button (file picker + confirm). **(wire)**
- **Open App Data / Logs Folder** — button. **(wire)**
- **Reset All Settings** — danger button with AlertDialog confirmation ("This restores all
  defaults. Profiles are not affected.").

### TAB 7 — ADVANCED

- **Dry-Run Mode** — toggle, default OFF. When ON, every action shows its exact PowerShell command
  but does not execute, and an app-wide gold "DRY-RUN" banner appears. **(wire)**
- **Confirm Destructive Actions** — toggle, default ON.
- **Verbose Logging** — toggle, default OFF. **(wire)**
- **View Last Command Output** — opens a mono terminal-style drawer showing the last backend
  stdout/stderr (mock sample for now). **(wire)**
- **Bind Address** — display-only `127.0.0.1` with helper "Local only — this app runs shell
  commands and is never exposed publicly."

### TAB 8 — ABOUT

- App name + version, detected **Hermes Desktop** version, **Switcher backend** status
  (OK/unreachable via the same mock as Test Backend), profile count, and links. Include a small
  gold "Profile Jedi" lockup with the rune glyph.

### GOOGLE API CONTROL (footer cluster + settings card)

Add a status-aware control to start/stop the local **LiteLLM + ngrok** stack. This is NOT a plain
on/off toggle — the stack has three independent states, so model it as a multi-state control:

- **OFFLINE** — gray dot.
- **STARTING** — gold pulsing dot (animated).
- **ONLINE** — green dot: LiteLLM + ngrok tunnel both healthy.
- **DEGRADED** — amber dot: LiteLLM up but ngrok tunnel missing/dropped.
- **STOPPING** — gold pulsing dot (animated).

**Two placements (build both):**

1. **J.A.R.V.I.S. footer (primary).** Turn the existing `LITELLM 4000` + `NGROK 4040` capsules into
   an interactive **Google API cluster**: combined status dot + label, plus a context-aware action:
   - OFFLINE → gold **Start** button (play icon).
   - ONLINE / DEGRADED → **Stop** button (square icon, ghost/danger).
   - Always show a small **Restart** icon (stop then start) and a **Copy URL** icon (copies the ngrok
     public URL).
   - While STARTING/STOPPING → gold pulse, disable buttons, tiny spinner.

2. **Settings → Console tab (full card).** A "Google API Stack" card with the same status, large
   **Start / Stop / Restart** buttons, the live ngrok public URL (mono + copy), and three health rows
   each with its own status dot: **LiteLLM** (port 4000), **ngrok tunnel** (port 4040), **Vertex
   reachability** (model responds).

**Behavior (mock now via `lib/api.ts`):**

- Typed functions: `getGoogleApiStatus()`, `startGoogleApi()`, `stopGoogleApi()`, `restartGoogleApi()`.
- `getGoogleApiStatus()` returns
  `{ state, litellm: boolean, ngrok: boolean, vertex: boolean, publicUrl: string|null, port: number }`.
- Poll on the **Service Polling Interval** from Settings (default 5s); update dots live.
- Mock lifecycle: Start → `starting` ~2s → `online` with a fake `publicUrl`
  (e.g. `https://pushy-water-reformer.ngrok-free.dev`); Stop → `stopping` ~1.5s → `offline`;
  Restart chains stop then start.
- **Stop** and **Restart** open a premium glass confirm dialog ("This will stop the local LiteLLM +
  ngrok stack. In-flight requests may fail.") with Cancel / Confirm (danger). Gate the confirm on the
  **Confirm Destructive Actions** setting.
- Each action: `console.log` a JSON instruction (e.g. `{"action":"google-api:start"}`) + a Sonner
  toast (gold success / danger error).
- Respect **Dry-Run**: when ON, do not run — show the exact command
  (`> start-google-api-desktop.ps1`) in a toast/preview and keep the app-wide gold "DRY-RUN" banner.
- Honor `prefers-reduced-motion` (no pulsing when reduced).

**Components:** `GoogleApiControl` (footer cluster), `GoogleApiCard` (settings), reuse `StatusDot`
and the existing confirm dialog. Accessible: `aria-live` on status changes, labelled buttons, gold
`focus-visible` rings, hit targets >= 36px.

### Persistence & data model

Persist everything to a single `settings` object exposed via `lib/api.ts`
(`getSettings()` / `updateSettings(partial)`), backed by `localStorage` for now, so a real config
backend drops in later. Use this TypeScript shape (extend as needed, keep keys stable):

```ts
type Settings = {
  general: {
    defaultLocation: string;        // "D:\\Hermes"
    defaultModel: "vader-3-flash" | "vader-3.5-flash";
    descriptionTemplate: string;    // "Hermes profile for {name}"
    autoLaunchOnSwitch: boolean;    // true
    confirmBeforeSwitch: boolean;   // true
    switchBehavior: "close" | "keep"; // "close" -> keep maps to -NoKill
    autoSyncCliOnSwitch: boolean;   // true
  };
  appearance: {
    theme: "dark" | "light" | "system";
    accentColor: string;            // "#F5B841"
    accentIntensity: "subtle" | "medium" | "bold";
    glassIntensity: "low" | "medium" | "high";
    filmGrain: boolean; vignette: boolean; wordmarkGlow: boolean;
    showMonograms: boolean; showCliStatus: boolean; compact: boolean;
    animationSpeed: "full" | "reduced" | "off";
    font: "geist" | "space-grotesk";
  };
  console: {
    showFooter: boolean; waveformAnimation: boolean;
    waveformColor: "gold" | "white" | "gradient";
    pollIntervalMs: 2000 | 5000 | 10000 | 30000;
    showPorts: boolean; capsuleStyle: "pill" | "rounded" | "minimal";
    services: { id: string; name: string; host: string; port?: number; enabled: boolean }[];
  };
  shortcuts: Record<string, string>; // actionId -> keybinding
  integrations: {
    hermesPath: string; cursorPath: string;
    executionPolicy: "Bypass" | "RemoteSigned" | "AllSigned";
    templateSource: string; switcherScript: string;
    openFoldersWith: "explorer" | "wt"; syncOnLaunch: boolean;
  };
  data: {
    registryPath: string; activeProfileFile: string; mem0Path: string;
    apiPort: number; // 7780
  };
  advanced: {
    dryRun: boolean; confirmDestructive: boolean; verboseLogging: boolean;
    bindAddress: string; // "127.0.0.1"
  };
  googleApi: {
    startScript: string; // "D:\\Hermes\\custom-scriptz\\google-api\\scripts\\start-google-api-desktop.ps1"
    stopScript: string;  // "...\\stop-google-api-desktop.ps1"
    autoStartOnLaunch: boolean; // default false
    showInFooter: boolean;      // default true
  };
};

// Live status for the Google API control (from getGoogleApiStatus()):
type GoogleApiStatus = {
  state: "offline" | "starting" | "online" | "degraded" | "stopping";
  litellm: boolean;
  ngrok: boolean;
  vertex: boolean;
  publicUrl: string | null;
  port: number; // 4000
};
```

### Interactions
- Live-apply Appearance settings; other tabs apply on **Save Changes**.
- Track a dirty state; warn on Cancel/Esc/backdrop if unsaved.
- **Reset All Settings** and **Dry-Run** require an AlertDialog confirm.
- Dry-Run ON shows a persistent app-wide banner.
- Accent color writes a CSS variable consumed everywhere (`--accent`).
- **Test Backend**, **Backup/Restore/Export**, **Start/Stop Google API**, **View Last Command
  Output** all show toasts and (for now) mock-resolve — keep them behind `lib/api.ts` stubs.

### Components
`SettingsDialog`, `SettingsRail`, `SettingsTab`, `SettingRow`, `ServiceTable`, `ShortcutTable`,
`KeybindCapture`, `DryRunBanner`, `LastOutputDrawer`. Keep modular, accessible, and consistent with
the existing Profile Jedi components.

### Layout reference (match this structure)

```
+---------------------------------------------------------------+
|  SETTINGS                                                     |
|  A premium control panel for your Hermes environment.        |
|  +-----------+---------------------------------------------+  |
|  | GENERAL   |  Default Profile Location                   |  |
|  | APPEARANCE|    [D:\Hermes\__________] [Browse]          |  |
|  | CONSOLE   |  [x] Auto-Launch Hermes on Switch           |  |
|  | SHORTCUTS |  [x] Confirm Before Switch                  |  |
|  | INTEGRAT. |  Switch Behavior: [Close Hermes v]          |  |
|  | DATA      |  -- Appearance --                           |  |
|  | ADVANCED  |  Theme:[Dark v]  Glass:[Medium v]           |  |
|  | ABOUT     |  Accent:[Jedi Gold v] Intensity:[Medium v]  |  |
|  |           |  -- J.A.R.V.I.S. Console --                 |  |
|  |           |  [x] Show Footer  [x] Waveform              |  |
|  |           |  Poll:[5s v]  Capsule:[Pill v]              |  |
|  |           |  -- Shortcuts --                            |  |
|  |           |  | Ctrl+, | Open Settings |                 |  |
|  |           |  | Esc    | Close Modals  |                 |  |
|  |           |  -- Data & Storage --                       |  |
|  |           |  Registry: ...\profiles.json                |  |
|  |           |  [Backup Now][Restore][Reset All]           |  |
|  |           |                      [Save Changes][Cancel] |  |
|  +-----------+---------------------------------------------+  |
+---------------------------------------------------------------+
```

---

## PART B — Backend wiring map (Cursor only, do not paste to v0)

When the real backend is connected, the **(wire)** settings drive these operations:

| Setting | Real effect |
|---------|-------------|
| Default location / model / description | Pre-fill `New-HermesProfile` args |
| Switch Behavior = Keep | Adds `-NoKill` to `-Action switch` |
| Auto-Launch / Auto-Sync on switch | Launcher already syncs + launches; toggles gate it |
| Service list + Poll interval | `/api/health` probes host:port on interval |
| Google API status | `GET /api/google-api/status` → probe `127.0.0.1:4000/v1/models` (Bearer master key) for `litellm`/`vertex`, `127.0.0.1:4040/api/tunnels` for `ngrok` + `publicUrl`; derive `state` |
| Start Google API | `POST /api/google-api/start` → spawns `...\google-api\scripts\start-google-api-desktop.ps1` (detached) |
| Stop Google API | `POST /api/google-api/stop` → runs `...\google-api\scripts\stop-google-api-desktop.ps1` (LiteLLM + ngrok only; keeps Hermes gateway) |
| Restart Google API | `POST /api/google-api/restart` → stop then start |
| Execution Policy | The `-ExecutionPolicy` used when spawning `powershell.exe` |
| Template Source / Switcher Script | Paths passed to the route handlers |
| Test Backend | `Switch-Hermes-Profile.ps1 -Action list -Json` -> count |
| Registry / Active file / Mem0 path | Read/parse locations |
| Import/Export/Backup/Restore | Copy/replace `profiles.json` (+ settings json) |
| Dry-Run | Routes return the composed command string instead of executing |
| Verbose / Last Output | Capture and surface child_process stdout/stderr |
| API Port / Bind | Local server binds `127.0.0.1:<port>` only |

Settings persist to `localStorage` now; later mirror to a real
`profile-jedi/settings.json` next to the app so the backend and UI share one source.
