# Tool Chest — External APIs & Services

Welcome to the MyStudioChannel Developer Tool Chest. This authoritative manual indexes our external API services, tooling configurations, extraction systems, and third-party integrations used across the workspace.

---

## 🌐 Content Extraction & Search APIs

### 1. Jina Reader API
*   **Purpose:** Convert any public URL, document (PDF/Word/Excel), or dynamic page directly into clean, LLM-friendly Markdown. Also supports instant multi-site search indexing.
*   **Documentation:** [https://github.com/jina-ai/reader](https://github.com/jina-ai/reader)
*   **Base Endpoints:**
    *   **Read Endpoint:** `https://r.jina.ai/[target_url]` — e.g. `https://r.jina.ai/https://mystudiochannel.com`
    *   **Search Endpoint:** `https://s.jina.ai/[search_query]` — e.g. `https://s.jina.ai/latest+tailwind+v4+button+glow`
*   **Interactive Control Headers (Optional):**
    *   `x-retain-images: none` — Drops all markdown image links from output (minimizes token context).
    *   `x-retain-links: text` — Keeps link anchor text, but discards actual URLs.
    *   `x-with-generated-alt: true` — Powers up a Vision-Language Model (VLM) on Jina's side to auto-caption on-page images with descriptive alternative text.
    *   `x-engine: browser` — Forces headless Chrome execution to fully render heavy JavaScript-driven Single Page Applications (SPAs).
*   **API Authentication:** Free tier is standard and highly generous. Higher limits can be unlocked with an API token from `jina.ai/reader` (configured locally as `JINA_API_KEY` in `.env.local`).
*   **Use Cases:**
    *   **Competitor UX Scrapes:** Instantly scrape visual elements and structures.
    *   **Clean Documentation Parsing:** Retrieve clean markdown blocks from docs, libraries, or PDFs.
    *   **Dynamic Search Hydration:** Execute real-time queries to feed the newest API features into custom components.

---

## 📧 Communication & Notifications

### 2. Resend API
*   **Purpose:** Standardized transaction email delivery. Powers the Two-Step Booking Engine confirmations and automated newsletter newsletter notifications.
*   **Documentation:** [https://resend.com/docs](https://resend.com/docs)
*   **Configuration**: Integrated via `@payloadcms/email-resend` plugin inside `payload.config.ts`.
*   **Credentials:** Configured under `RESEND_API_KEY` inside `.env.local`.

---

## 💰 Payments & Subscriptions

### 3. Stripe API
*   **Purpose:** Core SaaS transaction engine and invoice management.
*   **Documentation:** [https://stripe.com/docs](https://stripe.com/docs)
*   **Use Cases:** Handles product bookings, retainer payments, and custom invoices.
*   **Credentials:** Verified under `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` inside `.env.local`.

---

## 🧠 AI Agent Inference & Proxies

### 4. Vertex AI & LiteLLM Google Proxy
*   **Purpose:** Fast, resilient local API translation proxy allowing local AI agents to utilize Google Vertex Gemini models.
*   **Ports & Tunneling:**
    *   **LiteLLM server:** Local port `:4000` (`msc:google-api:start`)
    *   **Ngrok Inspector:** Local port `:4040` for tunneling secure public HTTPS routes.
*   **Inference Model:** Vertex AI Gemini 3.5 Flash (`vader-3.5-flash`).

---

## 🚨 Guidelines for AI Agents
When prompted to gather external web context, documentation, or search results, the agent MUST:
1. Prefer using `fetch-mcp` or `user-fetch` pointed at Jina's prefixes (`https://r.jina.ai/` or `https://s.jina.ai/`) for lightning-fast, high-density Markdown text parsing.
2. Use headers like `x-retain-images: none` if images aren't needed to drastically decrease token consumption.
3. Keep all credentials localized to `.env.local` — NEVER commit keys, secrets, or bearer tokens to the git log.
