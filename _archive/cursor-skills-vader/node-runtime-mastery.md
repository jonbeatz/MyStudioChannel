---
name: node-runtime-mastery
description: >-
  Universal Node/Next.js runtime execution — build gates, port clearance, HTTP
  smoke loops, package.json authority, and fix-local-first recovery. Use for
  app/, components/, lib/, config, and runtime script changes.
---

# Node Runtime Mastery (Universal)

## Local env hydration

- Every `scripts/*.mjs` entry point imports `scripts/lib/msc-load-env.mjs` first.
- Load order: `.env.local` (live, gitignored) → `.env.example` (contract, fills gaps only).
- Read config via `process.env.VARIABLE_NAME` only — never hardcode secrets in scripts.

## Scope

- Applies to Next.js, Payload, Electron-adjacent Node services, and standalone Node backends.
- Does not replace root `.cursorrules`; operationalizes them for runtime work.
- WordPress-only tasks → `wordpress-divi-engineering.md`.

## Command authority

- **`package.json` is the only command truth.** Never invent script names.
- Confirm lockfile type (`yarn.lock`, `pnpm-lock.yaml`, `package-lock.json`) before assuming npm.
- **Local vs remote:** Build, verify, and recovery run on the dev machine; host deploy/restart only when explicitly requested.

## Port allocation contract

| Service | Port(s) | Kill / smoke target |
|---------|---------|---------------------|
| Web dev + HTTP smoke | **3000** | `MSC_DEV_PORT` or CLI arg |
| LiteLLM AI proxy | **4000** (default) or **8000** | `MSC_LITELLM_PORT` — kill only before proxy restart; see Node 6 |
| Ngrok inspector | **4040** | Not managed by MSC scripts |

## Local Script Gate Sequence (canonical)

Every pre-flight or post-build HTTP check in this boilerplate runs **in this order only**:

```bash
node scripts/msc-kill-dev-port.mjs <port>
node scripts/msc-local-http-smoke.mjs <port>
```

CLI `<port>` or `MSC_DEV_PORT` for both scripts. Web workflows use **3000** unless the operator sets another dev port.

## Standard verification flow

After substantive runtime edits (`app/`, `components/`, `lib/`, collections, middleware, framework config):

1. **Local Script Gate Sequence** on the web dev port (typically **3000**) when clearing a hung listener.
2. **Build gate** — run the project's production build script from repo root until exit code **0** (e.g. `npm run verify:next`, `npm run build`).
3. **Restart dev** — if the dev port is free after verify, start the dev server so local routes respond again.
4. **Re-run the gate sequence** — kill (if needed) → smoke; **report status codes**; do not mark complete on failure.

   | Variable | Purpose |
   |----------|---------|
   | `MSC_DEV_PORT` | Shared port for kill + smoke (preferred) |
   | `MSC_SMOKE_PORT` / `DEV_PORT` | Smoke-only overrides |
   | `MSC_SMOKE_HOST` | Default `127.0.0.1` |
   | `MSC_SMOKE_PATHS` | Comma-separated paths (default `/,/admin`) |
   | `MSC_SMOKE_TIMEOUT_MS` | Per-request timeout |

## Recovery flow (fix local first)

When localhost fails (`ERR_CONNECTION_REFUSED`, 500s, missing vendor chunks, stale `.next`):

1. Run the project's one-shot recover script if defined (e.g. `dev:recover`).
2. If missing, run the **Local Script Gate Sequence** → clean build output → restart dev.
3. Re-run kill → smoke and **report status codes**—do not only instruct the operator.

**Guardrail:** Never delete `.next` (or equivalent) while `next dev` is actively serving that output.

## State & process discipline

- Prefer **tree-aware** process termination for managed child processes (avoid orphan Node listeners on standard dev ports).
- **Background services:** Start bridges/APIs in integrated terminal background shells; verify with ping/smoke before claiming success.
- **Error boundaries:** Surface failures via toast + inline card states + top-level React error boundary where applicable.

## UI coupling

When runtime changes affect UI, enforce Studio Dark tokens via `ui/msc-shield.css` and `.cursor/rules/studio-dark-ui.mdc`—no hardcoded hex in components.

Load order (WordPress or standalone): **`msc-shield.css` first**, then **`msc-hero-slider.css`** (declared as a dependency in `core/msc-assets.php` via `msc_register_core_visual_shield()`).

## TypeScript core bridges (front-end integration)

Use the boilerplate `.ts` modules from `core/` when wiring Next.js / Payload surfaces—do not reimplement validation or CMS bootstrapping ad hoc.

### Payload CMS bootstrap — `msc_createPayloadConfig`

```ts
import msc_createPayloadConfig from "./core/msc-payload-bridge"

export default msc_createPayloadConfig({
  // Optional: collections, globals, emailAdapter overrides
})
```

- Resolves `serverURL`, SQLite `DATABASE_URL`, and CSRF origins from env (`MSC_PUBLIC_ORIGIN`, `PAYLOAD_SECRET`, etc.).
- Ships scaffold collections: `users`, `media`, `subscribers`; global `site-content` with `heroSlides` for `MscHeroSlider`.

### Subscription capture — `msc_submitSubscription`

```ts
import {
  msc_submitSubscription,
  msc_createRestSubscriptionAdapter,
} from "./core/msc-subscription-handler"

const state = await msc_submitSubscription(
  email,
  msc_createRestSubscriptionAdapter("/api/subscribers"),
  { source: "homepage" },
)
// state.success | state.error — success message includes MSC signature when applicable
```

- **`msc_validateSubscriptionEmail()`** — pre-flight validation.
- **`msc_createRestSubscriptionAdapter(endpoint)`** — JSON POST adapter; swap endpoint per project.
- PHP stacks: after capture, route notifications through `msc_send_mail()` + `msc_build_transactional_email_template()` from `msc-communications.php`.

### Hero UI component

```tsx
import { MscHeroSlider } from "../ui/msc-hero-slider"
// Styles load via msc-assets enqueue (shield → hero slider)
```

### Auth & admin — `core/msc-auth-admin.ts`

```ts
import {
  msc_validateRegistration,
  msc_validateNewPassword,
  msc_canManageFullUserDirectory,
  msc_buildVerificationEmailHtml,
  type MscAuthMailAdapter,
} from "./core/msc-auth-admin"
```

- Registration: `msc_validateRegistration` before CMS `users` create.
- Password policy + visibility toggle state: `msc_validateNewPassword`, `msc_togglePasswordVisibility`.
- Account UI model: `msc_buildAccountDashboard` — profile + security only (no redundant visibility cards).
- Mail: prefer PHP `msc_send_mail()` + `msc_build_transactional_email_template()` or inject `MscAuthMailAdapter`.

### Project workspace — `core/msc-project-actions.ts` + `ui/msc-project-manager.tsx`

```ts
import { msc_createProject, type MscProjectPersistenceAdapter } from "./core/msc-project-actions"

await msc_createProject(adapter, {
  name,
  ownerUserId,
  memberIds,
  clientRefId,
  localPath,
  liveUrl,
  status: "local",
})
```

```tsx
import { MscAddProjectModal, MscProjectGrid, MscMemberCluster } from "../ui/msc-project-manager"

<div className="msc-dashboard-container msc-viewport-shield">
  <MscProjectGrid projects={rows} onAddProject={() => setModalOpen(true)} />
  <MscAddProjectModal open={modalOpen} ownerUserId={session.id} adapter={adapter} />
</div>
```

- Wizard steps: identity → connectivity → credentials → status.
- `MscMemberCluster` renders stacked avatars + expandable member list on project cards.

## Anti-patterns (release blockers)

- Inventing npm scripts not in `package.json`
- Marking tasks complete after failed build gate
- Running live/host commands for local-only repair
- Leaving localhost down after a successful `verify` rebuild
