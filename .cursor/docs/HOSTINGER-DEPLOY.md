# Hostinger Deployment Guide - My Studio Channel

This document outlines the steps to deploy the Next.js + Payload CMS project to Hostinger shared hosting (Node.js Application Manager).

## 1. Environment Variables Checklist
Copy and paste these keys into your **Hostinger hPanel -> Advanced -> Node.js Application -> Environment Variables**.

| Key | Value / Description |
|-----|---------------------|
| `NODE_ENV` | `production` |
| `PAYLOAD_SECRET` | [Generate a long random string] |
| `DATABASE_URL` | `file:./payload.sqlite` |
| `NEXT_PUBLIC_SERVER_URL` | `https://yourdomain.com` |
| `PAYLOAD_PUBLIC_SERVER_URL` | `https://yourdomain.com` |
| `NEXT_PUBLIC_MSC_BOOKING_URL` | `payload` |
| `RESEND_API_KEY` | [Your Resend API Key] |
| `PAYLOAD_DISABLE_SHARP` | `true` |
| `PORT` | [Hostinger assigns this; fallback 3000] |

## 2. Deployment Steps

1. **Local Build**:
   Run `npm run build` locally to ensure no errors.
2. **Prepare Files**:
   Ensure `payload.sqlite` exists in the root (for initial seed).
3. **Upload**:
   Upload all files to Hostinger via FTP/File Manager, **EXCLUDING**:
   - `node_modules`
   - `.env.local`
   - `.git`
   - `.cursor`
4. **Install Dependencies**:
   In Hostinger Terminal (or Node.js App Manager), run:
   ```bash
   npm install --production --legacy-peer-deps
   ```
5. **Start Application**:
   - Application Entry Point: `server.js`
   - Node version: 20.x or higher
   - Click **Restart** or **Start**.

## 3. Post-Deployment Verification
- Access `https://yourdomain.com/` (Home)
- Access `https://yourdomain.com/admin` (CMS)
- Verify media uploads work (check folder permissions for `public/media`)
- Verify emails send via Resend (Contact/Booking forms)

## 4. Troubleshooting
- **Port Conflict**: Hostinger handles the port via `process.env.PORT`. `server.js` is already configured for this.
- **SQLite Permissions**: Ensure `payload.sqlite` and the root folder are writable by the Node process.
- **Sharp Errors**: `PAYLOAD_DISABLE_SHARP=true` is set to avoid native binary issues on shared hosting.
- **404 on Admin**: Ensure `server.js` is used as the entry point, not just `next start`.
