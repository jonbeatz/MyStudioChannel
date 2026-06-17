# Composio MCP Setup (Phase 3)

Composio provides agent toolkits for Meta, TikTok, YouTube, X, and more — use for **dev/testing** in Cursor/Hermes. Production publish goes through **Postiz API**.

## Sign up

1. [Composio dashboard](https://dashboard.composio.dev) — free developer tier
2. Add to `.env.local`:

   ```env
   COMPOSIO_API_KEY=your-key
   ```

## Cursor MCP registration (recommended — mcp-remote stdio bridge)

Direct `url` to `connect.composio.dev` can flash green then red in Cursor (**SSE stream 404**). Use **mcp-remote** instead:

Project config: `.cursor/mcp.json` (synced via `npm run msc:sync:mcp-env`)

```json
{
  "composio": {
    "command": "cmd",
    "args": [
      "/c", "npx", "-y", "mcp-remote@latest",
      "https://connect.composio.dev/mcp",
      "--transport", "http-first",
      "--header", "x-consumer-api-key:${COMPOSIO_API_KEY}"
    ],
    "env": { "COMPOSIO_API_KEY": "ck_..." }
  }
}
```

Get your **consumer key** (`ck_…`) from **dashboard.composio.dev → Connect → MCP card** (FOR YOU mode in sidebar). Not Settings → API Keys (`ak_…`).

```powershell
npm run msc:sync:mcp-env
```

Reload **Settings → MCP**. If you previously clicked Connect/OAuth, click **Logout** on composio first, then toggle off/on.

## Cursor MCP registration (HTTP — may error in Cursor)

```json
{
  "composio": {
    "url": "https://connect.composio.dev/mcp",
    "headers": {
      "x-consumer-api-key": "YOUR_CK_KEY"
    }
  }
}
```

## Platform toolkits

| Platform | Composio toolkit |
|----------|------------------|
| Facebook | `facebook` |
| Instagram | `instagram` |
| TikTok | `tiktok` |
| YouTube | `youtube` |
| X | `twitter` or `x` |

Use Composio to **read** pages, test OAuth, inspect posts — not as primary scheduler.

## vs Postiz

| Layer | Tool |
|-------|------|
| Agent experiments | Composio MCP |
| Scheduled publish queue | Postiz self-hosted |
| Image + caption pipeline | MSC `auto-post.mjs` + FLUX |

## Hermes

Install skill reference in `.agents/skills/auto-post/SKILL.md`. Optional: copy to `%LOCALAPPDATA%\hermes\skills\` for Telegram/Desktop.
