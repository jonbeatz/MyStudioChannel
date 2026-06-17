# Platform Matrix — Social Auto-Post

Dimensions, limits, and API notes for each target platform. Use with `scripts/social/format-caption.mjs` and campaign YAML `platforms[]`.

## Summary table

| Platform | Image size (recommended) | Caption limit | API cost | Publish hub |
|----------|-------------------------|---------------|----------|-------------|
| `facebook` | 1200×630 (link), 1080×1080 (feed) | 63,206 chars (practical: 500) | Free | Postiz / Meta Graph |
| `instagram` | 1080×1080 feed, 1080×1920 story/reel cover | 2,200 | Free | Postiz / Meta Graph |
| `tiktok` | 1080×1920 video; photo carousels supported | 4,000 | Free | Postiz / TikTok API |
| `x` | 1200×675 (16:9), 1080×1080 | 280 (standard); 25,000 (Premium) | **Paid** ~$0.015/post | Postiz / X API |
| `youtube` | 1280×720 thumbnail; video required for post | Title 100, description 5,000 | Free quota | Postiz / YouTube Data API |
| `wordpress` | Featured image flexible | No hard limit (excerpt ~55 words) | Free | WP REST / Postiz |
| `payload` | Via Media collection | Flexible (CMS) | Free | Payload local API |

## facebook

- **Aspect ratios:** 1.91:1 (link preview), 1:1 (square feed), 4:5 (portrait feed)
- **Requirements:** Facebook Page, Meta Developer App, `pages_manage_posts` (App Review for production)
- **Notes:** Links in posts; avoid engagement bait per Meta policies

## instagram

- **Aspect ratios:** 1:1, 4:5, 1.91:1 (feed); 9:16 (Stories/Reels)
- **Requirements:** IG Professional (Business/Creator) linked to Facebook Page
- **Publish flow:** Create media container → `media_publish` (two-step Graph API)
- **Notes:** Hashtags up to ~30; first line is hook before "...more"

## tiktok

- **Format:** Vertical video 9:16 primary; photo mode available
- **Requirements:** TikTok Developer App, OAuth; **public HTTPS URL** for media
- **Rate limits:** ~6 requests/minute on publish endpoints
- **Notes:** Use Postiz media upload or Hostinger `/media/` public URL

## x (twitter)

- **Cost warning:** No free tier for new developers (2026 pay-per-use)
- **Image:** Up to 4 images; 5MB max each
- **Character limit:** 280 default
- **Defer:** Until X API credits loaded in `.env.local`

## youtube

- **Post type:** Video upload (`videos.insert`) or Community post (limited API)
- **Thumbnail:** 1280×720
- **Quota:** `videos.insert` ~100 units/call; default daily bucket supports ~100 uploads/day
- **Schedule:** `status.publishAt` with `privacyStatus: private` until publish time

## wordpress (optional separate blog)

- **Auth:** Application password or OAuth plugin
- **Endpoint:** `POST /wp-json/wp/v2/posts`
- **Use case:** Long-form cross-post from social campaigns
- **MCP:** Existing `mcp-wordpress` in `.cursor/mcp.json`

## payload (mystudiochannel.com — primary owned site)

- **Use case:** Announcements, blog-style updates on main MSC site
- **Future:** `SocialPost` collection (draft schema in Phase 4)
- **Media:** Upload to Payload `media` collection; reference in post body

## Image generation defaults (FLUX)

| Use case | Width | Height |
|----------|-------|--------|
| IG/FB square | 1080 | 1080 |
| IG/FB portrait | 1080 | 1350 |
| Story/Reel/TikTok | 1080 | 1920 |
| X / link card | 1200 | 675 |
| YouTube thumb | 1280 | 720 |

Set in campaign YAML `image.width` / `image.height` or let `auto-post.mjs` pick from first platform in list.
