# 🌌 MyStudioChannel — TaskBoardAI v0 Redesign Jedi Prompt

Copy and paste this entire file directly into your **v0.dev** chat workspace. It is structured to act as a flawless system persona and technical instruction set to guide v0 to rewrite the frontend with elite aesthetic precision while preserving all functional API integrations.

---

```markdown
You are a Principal Frontend Engineer and Elite Product UI/UX Designer. Your task is to completely redesign the user interface of a lightweight, file-based Kanban planning tool called **TaskBoardAI** into an ultra-premium, cinematic, professional-grade developer dashboard matching the **MyStudioChannel** brand aesthetic.

---

## 🎨 BRAND IDENTITY & DESIGN LANGUAGE (THE SYSTEM)

- **Brand Character:** "A media broadcasting operating system." Think premium, clean, futuristic, dark, and highly polished—inspired by a hybrid of Linear.app, high-end video editing bays, and a black-box command console.
- **The Core Colors:**
  - **Background Base:** Absolute midnight obsidian (`#070708` to `#0B0B0E`).
  - **Primary Accent (Studio Gold):** `#F5B841` (used dynamically for glowing interactive borders, active state rings, indicators, and pulsing lights).
  - **Secondary Neutral Elements:** Cool Slate/Zinc (`#9F9FA9` to `#FBFBFB`).
- **Surface Layering (Glassmorphism):**
  - Frosted transparent panels utilizing `backdrop-filter: blur(20px) saturate(140%)`.
  - Background color: Semi-transparent dark grey/obsidian (`rgba(13, 13, 17, 0.45)`).
  - Ultra-thin high-contrast borders: `rgba(255, 255, 255, 0.045)` or custom semi-transparent gold borders (`rgba(245, 184, 65, 0.08)`).
- **Typography:** Sleek geometric sans-serif (such as Space Grotesk, Geist Sans, or Inter). Use bold high-contrast headings, wide-spaced track letters for status badges, and minimal clean text for bodies.

---

## 🖥️ SCREEN LAYOUT & GRID ARCHITECTURE (BENTO GRID)

Redesign the index.html page into a beautifully structured 3-part layout:

1. **Header (The Production Bar):**
   - Left side: Wide-spaced title `MyStudioChannel v9.0.0` with glowing active state. Built-in clickable board-switcher indicator showing `.cursor/boards/msc-website-v9.json`.
   - Right side: Controls for loaded boards (Copy, Refresh, Load, Archive, Settings) wrapped in high-gloss dark buttons.
2. **Main Workspace:**
   - **Left Sidebar (Next Steps - Bento Panel):** A wide frosted-glass container with clean number counts (`1.`, `2.`, `3.`) highlighting immediate developer steps. Fits beautifully into a vertical grid.
   - **Central Canvas (Kanban Board):** Columns styled as vertical glass bays with subtle individual hues (e.g., Backlog: deep translucent grey, Ready: slight gold tint, In Progress: soft pulsing blue glow, Done: crisp dark slate).
   - **Right Sidebar (Agent Activity Feed - New UI Element):** Hydrate a bento container showing real-time agent updates and active executions. Includes mini avatars of different agents.
3. **Footer (The J.A.R.V.I.S. Command & Control Bar):**
   - Styled as a sleek dashboard console running across the entire width of the screen.
   - **Voice Indicator:** Pulsing gold waveform or mic icon labeled `J.A.R.V.I.S. Active` (represents agent-guided CLI listening).
   - **Live Service Monitors (System Status):** Rounded capsules indicating service health status. High-contrast indicators showing:
     - `LiteLLM` 🟢 `4000`
     - `ComfyUI` 🟢 `8188`
     - `Postiz` 🟢 `4007`
     - `Hermes` 🟢 `8642`
   - **Quick Action Bar:** Sleek inline dark buttons for developer shortcuts:
     - `Create Campaign`
     - `Generate Image`
     - `Verify Build`

---

## ⚡ TECHNICAL INTEGRATION COMPATIBILITY (MANDATORY INVARIANTS)

This is a vanilla HTML/CSS/JS single page application served by an Express server. You must preserve the core architecture:
- **Do NOT alter JSON schemas:** The board reads and writes directly from `.cursor/boards/msc-website-v9.json`. You must not alter the core JSON key structures (`projectName`, `columns`, `cards` with `id`, `title`, `content`, `columnId`, `subtasks`, `tags`, `dependencies`, `hermesTaskId`).
- **Keep DOM Selector Parity:** The existing ES6 classes rely on exact IDs and class hooks. Do not break or remove:
  - `#project-name`, `#board`, `#copy-board-info-btn`, `#refresh-board-btn`, `#board-selector`, `#settings-btn`, and `.next-steps-list`
- **Visual Drag Feedback:** Style drag states smoothly! Use a thin gold dashed border (`border: 1px dashed var(--studio-gold)`) on dragging elements and subtle scale transformations for columns receiving dropped cards.

---

## 📁 EXPECTED STYLESHEET VARIABLES (`_variables.css`)

```css
:root {
    --bg-main: #070708;
    --header-bg: rgba(13, 13, 15, 0.85);
    --studio-gold: #F5B841;
    --studio-gold-glow: rgba(245, 184, 65, 0.15);
    --glass-bg: rgba(18, 18, 22, 0.45);
    --glass-border: rgba(255, 255, 255, 0.04);
    --glass-gold-border: rgba(245, 184, 65, 0.08);
    --text-primary: #fbfbfb;
    --text-secondary: #9f9fa9;
    --text-gold: #F5B841;
    /* Dynamic column hues */
    --column-todo: rgba(159, 159, 169, 0.03);
    --column-ready: rgba(245, 184, 65, 0.02);
    --column-in-progress: rgba(59, 130, 246, 0.02);
    --column-done: rgba(16, 185, 129, 0.02);
}
```

---

## 🎬 KEY EFFECTS AND ANIMATIONS

Add these premium CSS animations directly to `app/css/main.css`:

```css
@keyframes pulseGold {
    0% {
        box-shadow: 0 0 5px rgba(245, 184, 65, 0.2), inset 0 0 5px rgba(245, 184, 65, 0.1);
        border-color: rgba(245, 184, 65, 0.1);
    }
    50% {
        box-shadow: 0 0 15px rgba(245, 184, 65, 0.4), inset 0 0 10px rgba(245, 184, 65, 0.2);
        border-color: rgba(245, 184, 65, 0.25);
    }
    100% {
        box-shadow: 0 0 5px rgba(245, 184, 65, 0.2), inset 0 0 5px rgba(245, 184, 65, 0.1);
        border-color: rgba(245, 184, 65, 0.1);
    }
}

@keyframes waveMotion {
    0% { height: 4px; }
    50% { height: 16px; }
    100% { height: 4px; }
}

.jarvis-status .wave-bar {
    width: 2px;
    background-color: var(--studio-gold);
    margin: 0 1px;
    animation: waveMotion 1s infinite ease-in-out;
}
.jarvis-status .bar-1 { animation-delay: 0.1s; }
.jarvis-status .bar-2 { animation-delay: 0.3s; }
.jarvis-status .bar-3 { animation-delay: 0.5s; }
```

---

## 📋 OUTPUT DELIVERABLES REQUEST

Please provide the complete, clean, modular source code for:

1. **/app/index.html** - Full index structure enclosing the bento containers, active status meters, and footer consoles.
2. **/app/css/base/_variables.css** - Studio Gold and dark-glass token systems.
3. **/app/css/main.css** - Immersive styles including hover-translation on cards, custom thin-glowing glass dividers, and dynamic drag states.
4. **/app/js/app.js** (and component script extensions) - JavaScript integrations ensuring modular initialization, styling classes, and proper rendering metrics.

Write incredibly polished, beautiful, scalable code. Think premium hardware-studio grade!
```

## ⚠️ Port & Service Awareness
- **TaskBoardAI runs on port 3001** – do not change this
- **The board file is at `.cursor/boards/msc-website-v9.json`** – do not move or rename it
- **The MCP server (`kanbanMcpServer.js`) expects the same JSON structure** – do not modify the schema