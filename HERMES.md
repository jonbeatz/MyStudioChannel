# HERMES.md — Hermes Agent Master Project Instruction

Welcome to **MyStudioChannel**! This document provides you (the Hermes Agent) with the essential project architecture, core commands, rules, and files to navigate, develop, and maintain the codebase efficiently on Windows 11.

---

## 1. Project Constitution & Rules

*   **Final Authority:** The file `TRUTH.md` in the project root is the ultimate constitution and blueprint of this project. Always refer to `TRUTH.md` for architectural context, file paths, and rules.
*   **Official Name:** Always refer to this project as **MyStudioChannel**.
*   **Operating Environment:** Native Windows 11 with PowerShell.
*   **Development Rules:**
    *   **Custom Prefixing:** Custom functions must use the `msc_` prefix. Custom CSS classes must use `msc-` or `nm-`.
    *   **Environment Isolation:** Secrets go **only** in `.env.local` (never committed).
    *   **Media Assets:** Serve assets from `public/media/` and access them as `/media/filename.ext`. Run `npm run msc:media:sync` to register new media assets into the database.
    *   **SQLite Database:** `payload.sqlite` is tracked in git. Commit significant CMS changes with `chore(db):` prefix.

---

## 2. Core Architecture

*   **Next.js 15 App Router:** Uses route groups:
    *   `app/(site)/`: Marketing site frontend (custom layouts, header, footer, bento-grid explorer).
    *   `app/(payload)/`: Integrated Payload CMS v3.81 Admin Panel.
*   **Payload CMS v3 + SQLite:** Schema configurations:
    *   `collections/`: Dynamic collection schemas (leads, bookings, etc.).
    *   `globals/`: Global configuration schemas (homepage, header, settings).
*   **Tailwind CSS v4 + Framer Motion:** Used for the cinematic "NovaMira" visual aesthetic (Gold Standard, glassmorphism, bento grids).

---

## 3. Core Commands

Always run commands from the project root using PowerShell:

| Command | Action / Purpose |
| :--- | :--- |
| `npm run dev` | Starts development server on port `3000` (cleans lingering node ports). |
| `npm run dev:fresh` | Cleans `.next` compilation cache and starts a fresh development server on `3000`. |
| `npm run build` | Compiles Next.js + Payload production bundle. |
| `npm run verify:next:safe` | Checks production build compile-safety on Windows. |
| `npm run start` | Runs the compiled production server locally. |
| `npm run lint` | Runs TypeScript and syntax checks. |
| `npm run msc:parity:ftp` | Audits local file trees against the live Hostinger remote server. |
| `npm run msc:media:sync` | Syncs assets under `public/media/` into the Payload CMS DB. |
| `npm run msc:backup:quick` | Non-interactively backs up the project immediately to `G:\Cursor_Project_BackUpz\MyStudioChannel`. |

---

## 4. Launching Hermes with Project Context

To start chatting with Hermes loaded with this exact project context, run the following command from the project root:

```powershell
hermes -z "Let's load the project's architecture, TRUTH.md, and rules. Ask me what task I should perform next."
```
