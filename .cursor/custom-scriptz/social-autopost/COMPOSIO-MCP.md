# Composio MCP Setup (Phase 3)

Composio provides agent toolkits for Meta, TikTok, YouTube, X, and more — use for **dev/testing** in Cursor/Hermes. Production publish goes through **Postiz API**.

## Sign up

1. [Composio dashboard](https://app.composio.dev) — free developer tier
2. Add to `.env.local`:

   ```env
   COMPOSIO_API_KEY=your-key
   ```

## Cursor MCP registration

Add to global or project MCP config (Settings → MCP → Add server):

```json
{
  "composio": {
    "command": "npx",
    "args": ["-y", "@composio/mcp@latest"],
    "env": {
      "COMPOSIO_API_KEY": "<from .env.local via msc:sync:mcp-env or manual>"
    }
  }
}
```

Verify exact package name from [Composio MCP docs](https://docs.composio.dev) — update this file if the CLI package changes.

After editing MCP config:

```powershell
npm run msc:sync:mcp-env
```

Reload **Settings → MCP** in Cursor.

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
