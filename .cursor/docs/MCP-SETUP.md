# MCP setup (Cursor)

How Model Context Protocol servers are configured for **MyStudioChannel** and Jon’s global Cursor profile.

**Related:** [Development.md](./Development.md) (env vars), [ReCall.md](./ReCall.md) (Payload MCP finding §2026-04-08).

**Last updated:** 2026-06-08 (Hostinger spawn EINVAL fix; global **12**; project **6**; `HOSTINGER_API_TOKEN` sync; cursor-mcp-refresh)

---

## Three MCP channels

Cursor can expose MCP tools from **three separate places**. Only the first two use JSON files in this repo or your home directory.

| Channel | Config | This project (live) |
|---------|--------|---------------------|
| **Global manual MCPs** | `C:\Users\JONBEATZ\.cursor\mcp.json` | **12 servers** — core 8 + **Hostinger quartet** (see table below) |
| **Project manual MCPs** | `.cursor/mcp.json` in repo | **6 servers** (see table below) |
| **Workspace / plugin MCPs** | Cursor Settings → MCP, extensions, marketplace | **No JSON** — e.g. `cursor-ide-browser`, Stripe, Vercel, Firebase, `user-payload` |

**Merge rule:** Cursor loads global + project configs. If the same server name exists in both, **project wins**.

**Registered vs configured:** A server in `mcp.json` only works when **enabled** in **Cursor Settings → MCP** and successfully started. After edits, refresh via **cursor-mcp-refresh** (`MCP (X/Y)` status bar) or restart Cursor.

---

## MCP health check (quick)

Run from repo root:

```bash
npm run msc:sync:mcp-env
npm run msc:test:github-api
npm run msc:test:tavily-api
```

| Check | Pass means |
|-------|------------|
| `msc:sync:mcp-env` | GitHub + Tavily tokens copied global → `~/.cursor/mcp.json`; WordPress copied if `WORDPRESS_*` set |
| `msc:test:github-api` | `GITHUB_PERSONAL_ACCESS_TOKEN` in `.env.local` works |
| `msc:test:tavily-api` | `TAVILY_API_KEY` in `.env.local` works |

Then **refresh MCP** in Cursor. In **Settings → MCP**, confirm project servers are **toggled on** (they do not auto-enable from git alone).

---

## Browser QA playbook (single path)

Do **not** re-enable duplicate browser MCPs (`browsermcp`, `browser-tools-mcp`, extra Playwright CDP).

| Task | Tool |
|------|------|
| Local smoke `/` + `/admin` | `npm run verify:local` or **cursor-ide-browser** MCP |
| Live smoke | `npm run verify:live` |
| Scripted e2e | Global **playwright** MCP |
| Cloud / Stagehand | Project **browserbase** (when API keys set) |

---

## Payload CMS — no manual MCP entry

We **do not** configure `@govcraft/payload-cms-mcp` in any `mcp.json`.

**Reason:** That package requires **Redis + remote SSE** and is **not stable for local stdio in Cursor** ([ReCall.md](./ReCall.md) §2026-04-08). The old global `"payload"` entry was removed.

**Use instead:**

1. **`user-payload`** — workspace MCP (schema/codegen tools). Cursor registers it automatically; **not** in `mcp.json`. No setup in this repo.
2. **Payload REST** — `http://localhost:3000/api/*` when dev is running.
3. **Admin UI** — `http://localhost:3000/admin` in browser or agent fetch.

---

## Antigravity skills — curated only

**`antigravity-awesome-skills`** was removed from project MCP (2026-06-08). It auto-installed 1,500+ playbooks and caused skill drift.

**Use instead:** `.cursor/skills/imported/CURATED-INDEX.md` — 15 approved topic categories. Copy individual playbooks manually when needed.

**MSC-first skills:** MSC-UI-Taste, NovaMira-Design, Premium-UI, DesignMD, Workflow-Portable.

---

## Secrets workflow

**Never commit real API keys** in `.cursor/mcp.json` or `.cursor/mcp.json.example`.

1. Put secrets in **`.env.local`** (gitignored). See **`.env.example`** and the checklist below.
2. Sync what the script supports:

   ```bash
   npm run msc:sync:mcp-env
   ```

   Alias: `npm run sync:mcp-env` · `npm run msc:sync:mcp-all` (same + confirmation echo).

3. **Reload MCP** — **cursor-mcp-refresh** status bar **`MCP (X/Y)`**, or restart Cursor.

### What `msc:sync:mcp-env` syncs automatically

| Target | `.env.local` keys | Written to |
|--------|-------------------|------------|
| Global `github` | `GITHUB_PERSONAL_ACCESS_TOKEN` | `~/.cursor/mcp.json` |
| Global `tavily` | `TAVILY_API_KEY` | `~/.cursor/mcp.json` |
| Global `resend` (if enabled) | `RESEND_API_KEY` | `~/.cursor/mcp.json` |
| Global `hostinger-*` (×4) | `HOSTINGER_API_TOKEN` | `~/.cursor/mcp.json` |
| Project `mcp-wordpress` | `WORDPRESS_SITE_URL`, `WORDPRESS_USERNAME`, `WORDPRESS_APP_PASSWORD` | `.cursor/mcp.json` |

### Project MCP secrets checklist (manual until extended)

These project servers still use **placeholders** in committed `.cursor/mcp.json` until you configure them:

| Server | Required secrets | How to configure |
|--------|------------------|------------------|
| **`mcp-wordpress`** | `WORDPRESS_SITE_URL`, `WORDPRESS_USERNAME`, `WORDPRESS_APP_PASSWORD` | Add to `.env.local` → **`npm run msc:sync:mcp-env`** |
| **`21st-dev-magic`** | `21ST_DEV_MAGIC_API_KEY` (maps to MCP `API_KEY`) | Add to `.env.local`, then paste into project `.cursor/mcp.json` → `21st-dev-magic.env.API_KEY` (sync script does **not** copy this yet) |
| **`browserbase`** | `BROWSERBASE_API_KEY`, `BROWSERBASE_PROJECT_ID`, `GEMINI_API_KEY` | Add to `.env.local`, then paste into project `.cursor/mcp.json` → `browserbase.env.*` (sync script does **not** copy this yet) |
| **`local-wp`** | None | Enable in Settings → MCP; Local by Flywheel site running |
| **`pencil`** | None | Enable in Settings → MCP; **Pencil desktop app** must be running |
| **`markdownify`** | None | Enable in Settings → MCP |

### Global Hostinger MCP (synced from `.env.local`)

| Server | Secret | Notes |
|--------|--------|--------|
| `hostinger-hosting` | `HOSTINGER_API_TOKEN` | **`npm run msc:sync:mcp-env`** copies to all four |
| `hostinger-vps` | same | Windows: use `cmd /c npx -y hostinger-api-mcp@latest …` (not bare `npx.cmd` — causes `spawn EINVAL`) |
| `hostinger-domains` | same | |
| `hostinger-dns` | same | |

Add `HOSTINGER_API_TOKEN` to **`.env.local`** (see **`.env.example`**). Obtain from [hPanel](https://hpanel.hostinger.com/) → API / Hostinger MCP connector. **Never commit** the token to the repo.

If MCP panel shows **duplicate** hostinger rows or `?` icons, restart Cursor once after refresh — stale entries from failed `npx.cmd` spawns.

Global `mcp.json` lives **outside the repo** and is never committed.

---

## Enabled servers (live config)

### Global (12)

| Server | Purpose | Secrets |
|--------|---------|---------|
| `github` | Repos, issues, PRs | `GITHUB_PERSONAL_ACCESS_TOKEN` via sync |
| `filesystem` | File access (`${workspaceFolder}`) | None |
| `playwright` | Single browser MCP (Chrome + devtools) | None |
| `fetch` | HTTP fetch via `uvx mcp-server-fetch` | Python/`uvx` |
| `tavily` | Web search, extract, crawl | `TAVILY_API_KEY` via sync |
| `terminal-controller` | Shell/terminal control | Python `terminal_controller` |
| `sequential-thinking` | Structured reasoning helper | None |
| `desktop-commander` | Desktop automation | None |
| `hostinger-hosting` | Deploy, JS apps, hosting API | `HOSTINGER_API_TOKEN` in global JSON |
| `hostinger-vps` | VPS management | Same token |
| `hostinger-domains` | Domain management | Same token |
| `hostinger-dns` | DNS records | Same token |

**Optional global path (Obsidian trial):** add `I:\Vader_Vault` read-only to filesystem scope after 14-day pilot.

### Project (6)

| Server | Purpose | Ready when |
|--------|---------|------------|
| `local-wp` | Local WP / Flywheel site discovery | MCP enabled + Local site up |
| `mcp-wordpress` | WordPress REST for `mscclean.local` | `WORDPRESS_*` synced |
| `browserbase` | Cloud browser + Stagehand | Browserbase + Gemini keys in project JSON |
| `21st-dev-magic` | 21st.dev UI component generation | `API_KEY` set in project JSON |
| `pencil` | Pencil.dev design canvas | Pencil app running |
| `markdownify` | Web/PDF/images → Markdown | MCP enabled |

### Workspace / plugins (not in mcp.json)

| Server | Purpose |
|--------|---------|
| `cursor-ide-browser` | Cursor browser automation (preferred agent QA) |
| `user-payload` | Payload schema tools (when Cursor registers it) |
| Stripe, Vercel, Firebase | Marketplace plugins |

---

## Archived / disabled servers

Removed from active configs. Full recipes:

**[`.cursor/mcp.servers.archived.json`](../mcp.servers.archived.json)**

Includes: `payload`, **`browsermcp`** (project, 2026-06-08), **`antigravity-awesome-skills`** (project, 2026-06-08), duplicate browsers, `postgres`, `neon-postgres`, `postman`, `mcp-vercel`, `untitledui`, `resend`, `task-master-ai`, `console-ninja`, `cursor-rules-generator`, `mcpterm`. (**`tavily`** re-enabled in global config when `TAVILY_API_KEY` is set.)

**Re-enable Resend MCP:**

```bash
node scripts/msc-sync-mcp-env.mjs --enable-resend
npm run msc:sync:mcp-env
```

Then reload MCP in Cursor.

**Re-enable any other archived server:** Copy its block from `mcp.servers.archived.json` into the appropriate `mcp.json`, add secrets via `.env.local` + sync if applicable, reload MCP.

---

## Enable / disable in Cursor

1. **Remove or add** a server block in the appropriate `mcp.json`, **or**
2. Toggle in **Cursor Settings → MCP** (when supported for that server).

Prefer **remove + archive** over `"disabled": true` — Cursor may still connect disabled entries.

### MCP refresh extension (installed)

**[cursor-mcp-refresh](https://github.com/tankmurdock/cursor-mcp-refresh)** v1.1.0 — VSIX at `.cursor/tools/cursor-mcp-refresh-1.1.0.vsix` (reinstall: `cursor --install-extension` that path).

After **restart Cursor**:

1. Status bar → click **`MCP (X/Y)`** to refresh selected servers
2. Explorer → **MCP Servers** panel → gear → select servers to manage
3. Command Palette: **Refresh Enabled MCP Servers**

Use after editing `mcp.json` or when a server is stuck — faster than a full IDE restart for day-to-day use.

---

## New clone checklist

1. Copy `.env.example` → `.env.local` and fill values.
2. Copy `.cursor/mcp.json.example` → `.cursor/mcp.json` if missing (repo should already include `.cursor/mcp.json` with placeholders).
3. Adjust `mcp-wordpress` `node` path if npm global install differs.
4. Run `npm run msc:sync:mcp-env`.
5. Manually set **browserbase**, **21st-dev-magic**, and **Hostinger** secrets per checklist above.
6. Enable all needed servers in **Cursor Settings → MCP**.
7. Refresh MCP (extension or restart).

---

## npm scripts

| Script | Action |
|--------|--------|
| `npm run msc:sync:mcp-env` | Sync `.env.local` → global + project MCP configs |
| `npm run sync:mcp-env` | Alias for `msc:sync:mcp-env` |
| `npm run msc:sync:mcp-all` | Same + confirmation echo |
| `npm run msc:test:github-api` | Verify GitHub token from `.env.local` |
| `npm run msc:test:tavily-api` | Verify Tavily token from `.env.local` |
| `npm run msc:backup` | Standard project backup following the Ritual |
| `npm run msc:google-api:start` | Start LiteLLM + ngrok proxy on port 4000 |

---

## Backups

- Global trim backup: `~/.cursor/mcp.json.bak-20260529`
- Sync script first-run backups: `*.sync-bak` next to each MCP file (gitignored)

**Note:** Project **`.cursor/mcp.json`** is committed with placeholders. Global **`~/.cursor/mcp.json`** is outside the repo and receives GitHub/Tavily/WordPress secrets via **`msc:sync:mcp-env`** only.
