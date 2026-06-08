# MCP setup (Cursor)

How Model Context Protocol servers are configured for **MyStudioChannel** and Jon’s global Cursor profile.

**Related:** [Development.md](./Development.md) (env vars), [ReCall.md](./ReCall.md) (Payload MCP finding §2026-04-08).

**Last updated:** 2026-06-08 (browsermcp + antigravity archived; project MCP = 6; cursor-mcp-refresh installed)

---

## Three MCP channels

Cursor can expose MCP tools from **three separate places**. Only the first two use JSON files in this repo or your home directory.

| Channel | Config | This project |
|---------|--------|--------------|
| **Global manual MCPs** | `C:\Users\JONBEATZ\.cursor\mcp.json` | 8 servers (GitHub, filesystem, Playwright, fetch, **tavily**, terminal, sequential-thinking, desktop-commander) |
| **Project manual MCPs** | `.cursor/mcp.json` in repo | **6 servers** (see table below) |
| **Workspace / plugin MCPs** | Cursor Settings → MCP, extensions, marketplace | **No JSON** — e.g. `user-payload`, Stripe, Vercel, Firebase, **cursor-ide-browser** |

**Merge rule:** Cursor loads global + project configs. If the same server name exists in both, **project wins**.

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

1. Put secrets in **`.env.local`** (gitignored). See **`.env.example`** for keys:
   - `GITHUB_PERSONAL_ACCESS_TOKEN`
   - `TAVILY_API_KEY` (Tavily search MCP)
   - `WORDPRESS_SITE_URL`, `WORDPRESS_USERNAME`, `WORDPRESS_APP_PASSWORD`
2. Sync into MCP configs:

   ```bash
   npm run sync:mcp-env
   ```

   Or: `npm run sync:mcp-all` (same sync + confirmation message).

3. **Reload MCP** in Cursor: **Settings → MCP → refresh** (or restart Cursor).

The sync script writes to:

- **Global** `~/.cursor/mcp.json` → `github`, `tavily` (and `resend` if that server exists)
- **Project** `.cursor/mcp.json` → `mcp-wordpress`

Global `mcp.json` lives **outside the repo** and is never committed.

---

## Enabled servers (after 2026-06-08 consolidation)

### Global (8)

| Server | Purpose |
|--------|---------|
| `github` | Repos, issues, PRs (`@modelcontextprotocol/server-github`) |
| `filesystem` | File access scoped to `D:\Cursor_Projectz` (optional: add `I:\Vader_Vault` read-only after Obsidian trial) |
| `playwright` | Single browser MCP (Chrome + devtools) |
| `fetch` | HTTP fetch via `uvx mcp-server-fetch` (known URL → markdown) |
| `tavily` | Web **search**, extract, map, crawl via [tavily-mcp](https://github.com/tavily-ai/tavily-mcp) |
| `terminal-controller` | Shell/terminal control |
| `sequential-thinking` | Structured reasoning helper |
| `desktop-commander` | Desktop automation |

### Project (6)

| Server | Purpose |
|--------|---------|
| `local-wp` | Local WP / Flywheel site discovery |
| `mcp-wordpress` | WordPress REST API for `mscclean.local` |
| `browserbase` | Cloud browser automation with Browserbase and Stagehand |
| `21st-dev-magic` | AI-driven UI component generation with 21st.dev |
| `pencil` | Pencil.dev design canvas MCP |
| `markdownify` | Convert web pages, PDFs, and files to Markdown |

### Workspace / plugins (examples — not in mcp.json)

- `user-payload` — Payload schema tools
- `cursor-ide-browser` — Cursor-owned browser automation (preferred for agent QA)
- Stripe, Vercel, Firebase — Cursor marketplace plugins

---

## Archived / disabled servers

Removed from active configs. Full recipes:

**[`.cursor/mcp.servers.archived.json`](../mcp.servers.archived.json)**

Includes: `payload`, **`browsermcp`** (project, 2026-06-08), **`antigravity-awesome-skills`** (project, 2026-06-08), duplicate browsers, `postgres`, `neon-postgres`, `postman`, `mcp-vercel`, `untitledui`, `resend`, `task-master-ai`, `console-ninja`, `cursor-rules-generator`, `mcpterm`. (**`tavily`** re-enabled in global config when `TAVILY_API_KEY` is set.)

**Re-enable Resend MCP:**

```bash
node scripts/sync-mcp-env.js --enable-resend
npm run sync:mcp-env
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
4. Run `npm run sync:mcp-env`.
5. Reload MCP in Cursor.

---

## npm scripts

| Script | Action |
|--------|--------|
| `npm run sync:mcp-env` | Sync `.env.local` → global + project MCP configs |
| `npm run sync:mcp-all` | Same + confirmation echo |
| `npm run msc:backup` | Standard project backup following the Ritual |
| `npm run msc:google-api:start` | Start LiteLLM + ngrok proxy on port 4000 |
| `npm run sync:github-mcp` | Alias for `sync:mcp-env` |
| `npm run test:github-api` | Verify GitHub token from `.env.local` |
| `npm run test:tavily-api` | Verify Tavily token from `.env.local` |

---

## Backups

- Global trim backup: `~/.cursor/mcp.json.bak-20260529`
- Sync script first-run backups: `*.sync-bak` next to each MCP file (gitignored)

**Note:** Project **`.cursor/mcp.json`** is committed with placeholders. Global **`~/.cursor/mcp.json`** is outside the repo and receives secrets only via **`sync:mcp-env`**.
