# v0 Prompt — "Profile Jedi" (Hermes Profile Switcher UI)

A premium control-panel UI for the working **Hermes Profile Switcher** that lives at
`D:\Hermes\custom-scriptz\profile-switcher\`. This document has three parts:

1. **Proposed tech stack** (read this first).
2. **The v0.dev prompt** (paste this into v0).
3. **The wiring contract** (how the UI talks to the real PowerShell backend after v0).

---

## PART 1 — Proposed Tech Stack (my recommendation)

The original draft asked for a single `index.html`. I recommend **against** that for the final
product, because a raw browser page is sandboxed — it cannot read `profiles.json` on disk or run
`Switch-Hermes-Profile.ps1`. To make the buttons actually switch/create/adopt profiles we need a
tiny local backend. v0.dev also natively outputs this exact stack, so we get the best of both.

### Recommended (final): Local Next.js app

| Layer | Choice | Why |
|-------|--------|-----|
| Framework | **Next.js 15 (App Router) + React 19 + TypeScript** | v0's native output; gives us API routes for the PowerShell bridge |
| Styling | **Tailwind CSS v4** | v0 default; matches NovaMira tokens |
| Components | **shadcn/ui** (Dialog, Command, Sonner/toast, Tabs, Badge, ScrollArea, Tooltip) | v0 default; accessible, themable |
| Animation | **Framer Motion** | pulsing gold glow, panel slides, modal springs |
| Icons | **lucide-react** | clean line icons |
| Fonts | **Geist** (UI) + **Geist Mono** / **Space Grotesk** (status/console) | broadcasting-OS feel |
| Backend bridge | **Next.js Route Handlers** (`app/api/**/route.ts`) calling `child_process` | runs the real `.ps1` headless API |
| Run mode | `next dev` on `http://localhost:7780` (pick a dedicated port) | open in browser, or as a pinned web app |

### Optional later: wrap as a real desktop app

Once the Next.js app works in the browser, wrap it for a true window + taskbar icon:

- **Tauri (recommended)** — Rust shell, ~5–10 MB, can spawn PowerShell directly and is far lighter
  than Electron. Best fit for a local "studio control panel."
- **Electron** — heavier but simplest if we want parity with how Hermes Desktop itself ships.

For v0 we only build the **front end with mock data**. I wire the backend in Cursor afterward
(Part 3). Tell v0 to keep all data access behind a typed `lib/api.ts` so swapping mock → real is one file.

### Fallback (fastest, least power): single `index.html`
Keep this only if you want a quick visual mock with no real switching. It can `fetch()` a local
helper server but cannot run PowerShell on its own. Not recommended for the real tool.

---

## PART 2 — THE v0.dev PROMPT (paste everything below the line into v0)

---

You are a Principal Frontend Engineer and elite product UI/UX designer. Build a **standalone
Next.js 15 (App Router) + TypeScript + Tailwind v4 + shadcn/ui + Framer Motion** application called
**"Profile Jedi"** — a premium control panel for switching between, creating, and adopting AI agent
profiles. The aesthetic must match the **"MyStudioChannel / NovaMira"** design language: a hybrid of
a high-end audio console, a futuristic developer dashboard, and a broadcasting operating system.
Powerful, clean, cinematic, intuitive.

### Brand & design tokens (use exactly)

Background base: layered midnight obsidian `#070708` → `#0B0B0E` → `#0D0D11`.
Primary accent — **Studio Gold** `#F5B841` (active states, glow rings, the J.A.R.V.I.S. waveform,
key CTAs). Gold-dim `#C8922E` for borders/hovers.
Text: `#FBFBFB` primary, `#9F9FA9` secondary, `#6B6B73` muted.
Success `#3FB950`, warning `#F5B841`, danger `#F85149`, info `#58A6FF`.

Glassmorphism: `backdrop-filter: blur(20px) saturate(140%)` over `rgba(13,13,17,0.45)`.
Ultra-thin borders: `rgba(255,255,255,0.04)` default, `rgba(245,184,65,0.10)` on active/hover.
Corner radius: 16–20px on panels, 12px on cards, 10px on inputs.
Shadows: soft ambient `0 8px 40px rgba(0,0,0,0.5)` + a faint inner top highlight.
Typography: **Geist** for UI, **Geist Mono** (or Space Grotesk) for statuses, ports, slugs, paths,
and the command preview. Headers: high-contrast, wide letter-spacing, uppercase eyebrow labels.

Avoid generic SaaS clichés: no purple gradient hero, no plain centered Inter card stack. This should
read like premium studio hardware.

### Layout — asymmetric bento grid

Full-height app, `100dvh`, no page scroll (panels scroll internally).

- **Top bar (slim):** left = "PROFILE JEDI" wordmark with a small gold rune/diamond glyph and a
  thin animated gold underline; center = global search/command input (placeholder
  "Search profiles or press Ctrl+K"); right = a live "ACTIVE PROFILE" capsule showing the currently
  active profile name + gold dot, and a settings gear.
- **Left panel (wide, ~38%): "Known Profiles".** A vertical, scrollable list of profile cards.
  Each card shows: profile **Name** (bold), **slug** in mono, the **workspace path** (truncated mono,
  with tooltip), a **CLI health** pill ("CLI ok" green / "CLI missing" amber), and a small right-edge
  status rail. The **active** profile card has a glowing gold left border + soft `pulseGold` halo and
  an "ACTIVE" tag. Hover lifts the card 2px and brightens the border. A sticky header row has the
  count ("4 profiles") and small "New" + "Adopt" ghost buttons.
- **Right panel (detail, ~62%): "Active / Selected Profile".** A larger glass panel showing the
  selected profile in depth:
  - Header: big profile name, slug chip, an "ACTIVE" or "Switch to this" primary gold button.
  - A 2x2 **stat bento** of mono cards: Workspace path (with "Open Folder"), CLI profile home
    (`%LOCALAPPDATA%\hermes\profiles\<slug>`), Mem0 collection (`<slug>_memories`), Desktop shortcut.
  - A **Quick Actions** row of buttons: **Launch Hermes**, **Sync CLI Profile**, **Open Folder**,
    **Reveal Shortcut**, **Edit in Cursor**.
  - A **"Command preview"** terminal-style block (mono, dark, gold caret) that shows the exact
    PowerShell that the current action will run, e.g.
    `Switch-Hermes-Profile.ps1 -Action switch -Profile JonBeatz` — updates live as the user hovers
    actions. This is the "Jedi transparency" feature.

### J.A.R.V.I.S. footer console bar (full width, fixed bottom)

A glass console strip containing:
- Left: a **pulsing gold voice waveform** (5–7 animated bars) labeled "J.A.R.V.I.S. ACTIVE" in mono.
- Center: **service health capsules**, each a pill with a colored status dot, a mono label and port:
  `LITELLM 4000`, `NGROK 4040`, `LM STUDIO 1234`, `HERMES GATEWAY`. Green dot = online, gray =
  offline, amber = checking. (For the prototype, randomize/mock these and animate the dot.)
- Right: quick-action buttons **Switch Profile**, **Create New** (gold filled), **Adopt Project**.

### Modals (shadcn Dialog, premium, spring-in)

1. **Create New Profile** — fields: **Name** (required; live-preview the derived lowercase slug and
   the resulting mem0 collection `<slug>_memories`), **Description**, **Location** (advanced; default
   shown as `D:\Hermes\<Name>`, editable, with a "use default" toggle). A live **Command preview**
   updates as they type: `Switch-Hermes-Profile.ps1 -Action new -Name "<Name>" -Location "<loc>" -Description "<desc>"`.
   Primary gold "Create Profile" button.
2. **Adopt Existing Project** — fields: **Folder path** (required, with a note "your existing files
   are never overwritten — only missing Hermes scaffolding is added"), **Name** (defaults to folder
   leaf), **Description**. Command preview:
   `Switch-Hermes-Profile.ps1 -Action adopt -Location "<path>" -Name "<Name>"`.
3. **Switch confirm (optional inline):** a small toast/confirmation noting Hermes will restart;
   include a "Keep current Hermes running (-NoKill)" checkbox.

### Interactivity (prototype stage)

All data lives behind a single typed module `lib/api.ts` with functions
`listProfiles()`, `switchProfile()`, `createProfile()`, `adoptProfile()`, `getServiceHealth()`,
`getActiveProfile()`. For the v0 prototype these return **mock data** and, on actions:
- `console.log` a JSON instruction, e.g. `{"action":"switch","profile":"JonBeatz"}`.
- Show an elegant **toast** (shadcn Sonner) confirming success/error.

Seed mock profiles:
```json
[
  { "name": "JonBeatz", "slug": "jonbeatz", "path": "D:\\Hermes\\JonBeatz", "description": "Personal AI command center", "cliProfile": true },
  { "name": "MyStudioChannel", "slug": "msc", "path": "D:\\Cursor_Projectz\\MyStudioChannel", "description": "MSC website project", "cliProfile": true },
  { "name": "ClientX", "slug": "clientx", "path": "D:\\Hermes\\ClientX", "description": "Client engagement", "cliProfile": false }
]
```

Keep the TypeScript type identical to the real backend:
```ts
type Profile = {
  name: string; slug: string; path: string;
  description: string; cliProfile: boolean; active?: boolean;
};
```

### Key effects & animations (Framer Motion)

1. **pulseGold** — active profile halo + J.A.R.V.I.S. waveform breathe (gold glow oscillates).
2. Waveform bars animate height on a staggered loop.
3. Modal: spring scale `0.96 → 1` + fade, backdrop blur-in.
4. Profile selection: animated gold border + a brief shimmer sweep across the detail panel.
5. Card hover: 2px lift + border brighten; respects `prefers-reduced-motion`.
6. Service dots: subtle blink/breathe.

### Keyboard / UX polish

- `Ctrl+K` command palette (shadcn Command) to fuzzy-jump/switch profiles.
- `Ctrl+N` open Create; `/` focus search; `Enter` on a card = switch; arrow keys navigate the list.
- Empty state for "no profiles" with a tasteful gold-outlined CTA.
- Fully responsive down to a single column (list collapses above detail); but optimize for a wide
  desktop window (≥1280px).

### Deliverable

A complete, modular Next.js App Router project: `app/page.tsx`, components under `components/`
(`ProfileList`, `ProfileCard`, `ProfileDetail`, `JarvisFooter`, `ServiceCapsule`, `CreateProfileDialog`,
`AdoptProfileDialog`, `CommandPreview`, `Waveform`), `lib/api.ts` (mock now), `lib/types.ts`, and a
Tailwind theme with the tokens above. Write polished, accessible, scalable code. It must feel like a
premium hardware-studio control panel — not a generic dashboard.

---

## PART 3 — Wiring Contract (I implement this in Cursor after v0)

Once v0 gives us the front end, I replace the mock `lib/api.ts` with calls to Next.js Route Handlers
that shell out to the **real, already-working** headless PowerShell API.

### Source of truth
- Registry: `D:\Hermes\custom-scriptz\profile-switcher\profiles.json`
  (array of `{ name, slug, path, description, created }`).
- Switcher: `D:\Hermes\custom-scriptz\profile-switcher\Switch-Hermes-Profile.ps1`.
- Active profile: `%APPDATA%\Hermes\active-profile.json` → `{ "profile": "<slug>" }`.

### Headless commands the routes will call
```text
list   : Switch-Hermes-Profile.ps1 -Action list -Json
switch : Switch-Hermes-Profile.ps1 -Action switch -Profile <name|slug> [-NoKill]
new    : Switch-Hermes-Profile.ps1 -Action new   -Name <name> -Location <path> -Description <text> -Json
adopt  : Switch-Hermes-Profile.ps1 -Action adopt -Location <path> -Name <name> -Description <text> -Json
```
`-Json` returns machine-readable output that the route parses and forwards to the UI.

### API routes to add (App Router)
| Route | Method | Calls |
|-------|--------|-------|
| `/api/profiles` | GET | `list -Json` (merges with `active-profile.json` to set `active`) |
| `/api/profiles/switch` | POST `{ profile, noKill? }` | `switch` |
| `/api/profiles/new` | POST `{ name, location?, description? }` | `new -Json` |
| `/api/profiles/adopt` | POST `{ location, name?, description? }` | `adopt -Json` |
| `/api/health` | GET | probes `127.0.0.1:4000` (LiteLLM), `:4040` (ngrok), `:1234` (LM Studio) |

Each route uses Node `child_process.execFile('powershell.exe', ['-NoProfile','-ExecutionPolicy','Bypass','-File', SWITCHER, ...args])`,
captures stdout, and returns JSON. Security: this server is **local-only** (bind `127.0.0.1`), never
deployed publicly, since it executes shell commands.

### Run it
```powershell
# Local (PC) — from the Next.js app folder
npm run dev   # http://localhost:7780
```
Later: add a `Profile Jedi` desktop shortcut (same pattern as our other launchers) that starts the
server and opens the browser/Tauri window.

### Stretch features (once wired)
- Live service health (real probes, 5s poll) feeding the J.A.R.V.I.S. capsules.
- "Open Folder" (`explorer.exe <path>`), "Reveal Shortcut", "Edit in Cursor" (`cursor <path>`).
- "Sync CLI Profile" → runs the profile's `scripts\sync-hermes-profile.ps1`.
- Show which profile is **currently active** (highlight + footer capsule) from `active-profile.json`.
- Toggle `-NoKill` so switching doesn't close a running Hermes.

---

### Summary of what I changed vs. your original draft
- Switched the target from a sandboxed single `index.html` to a **local Next.js app** (the only way
  the buttons can really switch/create/adopt) — with a fallback note if you want a pure mock.
- Aligned the UI to the **real data model** (`name, slug, path, description, cliProfile, active`) and
  the **real headless commands** the switcher already supports.
- Added a **Command Preview** "Jedi transparency" block, a richer **profile detail bento**
  (workspace, CLI home, mem0 collection, shortcut), real **service ports** (4000/4040/1234/gateway),
  **Ctrl+K command palette**, keyboard nav, reduced-motion support, and the **adopt-preserves-files** note.
- Documented the **backend wiring contract** so I can connect v0's output to the working PowerShell
  switcher in one file (`lib/api.ts`) plus a handful of API routes.
```
