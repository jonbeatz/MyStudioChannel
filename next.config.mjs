import { withPayload } from "@payloadcms/next/withPayload"
import { withSentryConfig } from "@sentry/nextjs"
import bundleAnalyzer from "@next/bundle-analyzer"

// Windows / synced folders: the default watcher can miss rapid rewrites to `.next`, leaving
// half-built `vendor-chunks/*` and 404s for `/_next/static/*`. Polling is slower but stable.
if (process.platform === "win32" && process.env.WATCHPACK_POLLING == null) {
  process.env.WATCHPACK_POLLING = "true"
}

const canonicalSiteFallback =
  process.env.MSC_CANONICAL_SITE_ORIGIN?.trim() || "https://mystudiochannel.com"

const publicOrigin =
  process.env.NEXT_PUBLIC_SERVER_URL?.trim() || canonicalSiteFallback

const remotePatterns = [
  {
    protocol: "http",
    hostname: "localhost",
  },
]

try {
  const { protocol, hostname } = new URL(publicOrigin)
  if (hostname && hostname !== "localhost") {
    remotePatterns.push({
      protocol: protocol === "https:" ? "https" : "http",
      hostname,
    })
  }
} catch {
  // Invalid NEXT_PUBLIC_SERVER_URL — keep defaults only.
}

/** Polling interval (ms) for webpack’s watcher on Windows — complements WATCHPACK_POLLING. */
const winWebpackPollMs = Number(process.env.MSC_WEBPACK_POLL_MS ?? "1000") || 1000

/** @type {import('next').NextConfig} */
const nextConfig = {
  /**
   * Payload globals live at `/admin/globals/:slug`. A bare `/admin/homepage` yields one segment
   * (`homepage`), so RootPage never resolves the Homepage global and logged-in users see 404.
   */
  async redirects() {
    return [
      // v1.0.23: old shortcut `/admin/homepage` still works
      {
        source: "/admin/homepage",
        destination: "/admin/msc-homepage",
        permanent: false,
      },
      // v1.0.23: canonical Payload URL redirects to the isolated static route so
      // bookmarks/sidebar links continue to work and bypass globals/[slug] routing.
      {
        source: "/admin/globals/homepage",
        destination: "/admin/msc-homepage",
        permanent: false,
      },
    ]
  },
  // Hide Next.js dev toolbar / “Preferences” panel (bottom-left in dev). Not part of Payload.
  devIndicators: false,
  poweredByHeader: false,
  // Hostinger runs `npm install --production` — ESLint is not on the server (see DEPLOYMENT-FIXES.md).
  eslint: { ignoreDuringBuilds: true },
  transpilePackages: ["three", "@react-three/fiber", "@react-three/drei", "motion"],
  // Payload requires a Node server. Static `out/` export is disabled while CMS is integrated.
  // next/image: local `/api/media/file/*` and `/media/*` (public/media) are same-origin — no remotePatterns entry needed.
  // Hostinger: no Next image optimizer on shared Node — local /media and Payload URLs stay unoptimized.
  images: {
    unoptimized: true,
    remotePatterns,
  },
  /**
   * Windows dev: reinforce polling so HMR sees rapid `.next` rewrites (reduces half-built
   * vendor-chunks and `/_next/static/*` 404s after edits). Do not set `cache: false` here.
   */
  webpack: (config, { dev }) => {
    if (dev && process.platform === "win32") {
      config.watchOptions = {
        ...(config.watchOptions ?? {}),
        poll: winWebpackPollMs,
        aggregateTimeout: 500,
      }
    }
    return config
  },
}
// Avoid `webpack: (c) => { c.cache = false }` in dev — it can break Payload admin vendor-chunks on Windows.

const withBundleAnalyzer = bundleAnalyzer({
  enabled: process.env.ANALYZE === "true",
})

const payloadConfig = withPayload(nextConfig)

export default withSentryConfig(withBundleAnalyzer(payloadConfig), {
  // For all available options, see:
  // https://github.com/getsentry/sentry-webpack-plugin#options

  // Must match Sentry org slug (see SENTRY_AUTH_TOKEN payload / Sentry → Settings → Organization)
  org: process.env.SENTRY_ORG || "mystudiochannel",
  project: process.env.SENTRY_PROJECT || "mystudiochannel",
  authToken: process.env.SENTRY_AUTH_TOKEN,

  // Only print logs for uploading source maps in CI or production builds
  silent: !process.env.CI,

  // Do not fail production builds when auth token is missing (local dev / dry-runs)
  widenClientFileUpload: true,
  hideSourceMaps: true,
  webpack: {
    treeshake: {
      removeDebugLogging: true,
    },
  },
})

