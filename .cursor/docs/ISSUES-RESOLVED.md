# Issues & Resolutions Log

This file tracks problems encountered during development and how they were resolved.

## Format

Each entry follows this structure:

```markdown
## [YYYY-MM-DD] Issue Title
- **Error:** What happened
- **Cause:** Why it happened
- **Solution:** How it was fixed
- **Files Changed:** Which files changed
- **Prevention:** How to avoid recurrence
```

## Log Entries

## [2026-05-30] Hero Section Images Mismatch
- **Error:** Hero slides showing demo preview images instead of hero images
- **Cause:** Database had wrong media IDs assigned (Demos-* images instead of hero-studio.jpg, show-artwork.jpg, on-air-bg.jpg, creator-in-mind.jpg)
- **Solution:** Ran fix-homepage-hero-slide-images.py to reassign correct media IDs
- **Files Changed:** payload.sqlite, scripts/fix-homepage-hero-slide-images.py
- **Prevention:** Verify media selections in Payload admin when editing hero slides; use the fix script if mismatch occurs

## [2026-05-29] MCP Duplicate Servers
- **Error:** MCPs appearing twice in Cursor list
- **Cause:** Same server defined in both global ~/.cursor/mcp.json and project .cursor/mcp.json
- **Solution:** Removed duplicates from project .cursor/mcp.json; kept only WordPress MCPs (local-wp, mcp-wordpress) in project config
- **Files Changed:** .cursor/mcp.json, .cursor/mcp.servers.archived.json
- **Prevention:** Keep only project-specific MCPs in project config; use global config for shared tools

## [2026-05-29] Temporary Button Redirects
- **Error:** N/A (intentional temporary change)
- **Change:** All CTA buttons redirected to external forms/calendar (Google Forms for consultations, Google Calendar for scheduling)
- **Files Changed:** components/header.tsx, components/hero-section.tsx, components/packages-section.tsx, components/contact-section.tsx, components/built-for-creators-section.tsx, components/requirements-section.tsx
- **Restore Instructions:** Search for // TEMPORARY REDIRECT in each file, delete the window.open() line, uncomment the original code above it

## [2026-05-29] Git Author Name Incorrect
- **Error:** Commits showing "mscAdmin" instead of "JonBeatz"
- **Cause:** Git global config had incorrect user.name
- **Solution:** Ran git config --global user.name "JonBeatz" and git config --global user.email "jonbeatz@gmail.com"
- **Files Changed:** Git config only (no project files)
- **Prevention:** Always set Git config on new machines before committing

## [2026-05-29] Port 3000 Already in Use
- **Error:** EADDRINUSE: address already in use :::3000
- **Cause:** Previous dev server process still running in background
- **Solution:** Found PID using netstat -ano | findstr :3000 and killed with taskkill /PID 11520 /F
- **Files Changed:** None
- **Prevention:** Always use Ctrl+C to stop dev servers; use npm run kill-dev-port script if needed

## Pending / To Be Investigated
None currently
