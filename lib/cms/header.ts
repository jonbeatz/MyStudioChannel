import type { Payload } from "payload"
import { getPayload } from "payload"
import config from "@payload-config"

import { normalizeInternalNavLink } from "@/lib/hash-nav"

export type HeaderNavItem = {
  label: string
  link: string
  submenu?: Array<{
    label: string
    link: string
  }>
}

export { normalizeInternalNavLink }

type NavSubmenuSource = "manual" | "pages-collection"

function normalizeNavItem(item: HeaderNavItem): HeaderNavItem {
  const submenu = item.submenu?.map((s) => ({
    ...s,
    link: normalizeInternalNavLink(s.link),
  }))
  return {
    ...item,
    link: normalizeInternalNavLink(item.link),
    ...(submenu && submenu.length > 0 ? { submenu } : {}),
  }
}

export const DEFAULT_HEADER_NAV_ITEMS: HeaderNavItem[] = [
  { label: "About", link: "#msc-about" },
  {
    label: "Services",
    link: "#msc-services",
    submenu: [
      { label: "Own Your Platform", link: "#msc-own-platform" },
      { label: "Packages", link: "#msc-packages" },
      { label: "Requirements", link: "#msc-requirements" },
      { label: "What We Do", link: "#msc-creators" },
    ],
  },
  { label: "Demos", link: "#msc-demos" },
  {
    label: "Resources",
    link: "#msc-testimonials",
    submenu: [
      { label: "Testimonials", link: "#msc-testimonials" },
      { label: "Extras", link: "#msc-addons" },
      { label: "FAQ", link: "#msc-faq" },
    ],
  },
  { label: "Contact", link: "#msc-contact" },
]

async function getPageLinksForPagesMenu(
  payload: Payload,
): Promise<Array<{ label: string; link: string }>> {
  try {
    const result = await payload.find({
      collection: "pages",
      where: {
        slug: {
          not_equals: "home",
        },
      },
      sort: "title",
      limit: 100,
      depth: 0,
    })
    return result.docs
      .map((doc) => {
        const title = typeof doc.title === "string" ? doc.title.trim() : ""
        const slug = typeof doc.slug === "string" ? doc.slug.trim() : ""
        if (!slug) return null
        const lower = slug.toLowerCase()
        if (lower === "home" || lower === "msc1") return null
        const showInNav = (doc as { showInHeaderNav?: boolean | null })
          .showInHeaderNav
        if (showInNav === false) return null
        return {
          label: title.length > 0 ? title : slug,
          link: `/${encodeURIComponent(slug)}`,
        }
      })
      .filter(
        (row): row is { label: string; link: string } => row !== null,
      )
  } catch {
    return []
  }
}

/** Resolve submenu source; legacy rows labeled exactly `Pages` without the field still work. */
function resolveSubmenuSource(row: Record<string, unknown>): NavSubmenuSource {
  const raw = row.submenuSource
  if (raw === "pages-collection") return "pages-collection"
  if (raw === "manual") return "manual"
  const label = typeof row.label === "string" ? row.label.trim() : ""
  if (label === "Pages") return "pages-collection"
  return "manual"
}

function rowsNeedPagesCollection(rows: unknown[]): boolean {
  return rows.some((row) => {
    if (!row || typeof row !== "object") return false
    return resolveSubmenuSource(row as Record<string, unknown>) === "pages-collection"
  })
}

function applyPagesCollectionSubmenu(
  item: HeaderNavItem,
  pageSubmenu: Array<{ label: string; link: string }>,
): HeaderNavItem {
  if (pageSubmenu.length === 0) {
    return { label: item.label, link: "/" }
  }
  return { label: item.label, link: "/", submenu: pageSubmenu }
}

export async function getHeaderNavItems(): Promise<HeaderNavItem[]> {
  try {
    const payload = await getPayload({ config })
    const doc = await payload.findGlobal({
      slug: "header",
      depth: 0,
    })

    const rows = Array.isArray(doc?.navItems) ? doc.navItems : []
    const shouldFetchPages = rowsNeedPagesCollection(rows)
    const pageSubmenu = shouldFetchPages
      ? await getPageLinksForPagesMenu(payload)
      : []

    const mapped = rows
      .map((row) => {
        if (!row || typeof row !== "object") return null
        const record = row as Record<string, unknown>
        const label = typeof record.label === "string" ? record.label.trim() : ""
        const link = typeof record.link === "string" ? record.link.trim() : ""
        if (!label || !link) return null

        const source = resolveSubmenuSource(record)
        if (source === "pages-collection") {
          return applyPagesCollectionSubmenu({ label, link }, pageSubmenu)
        }

        const submenuRows = Array.isArray(record.submenu)
          ? (record.submenu as Array<{ label?: unknown; link?: unknown }>)
              .map((item) => {
                const subLabel =
                  typeof item?.label === "string" ? item.label.trim() : ""
                const subLink =
                  typeof item?.link === "string" ? item.link.trim() : ""
                if (!subLabel || !subLink) return null
                return { label: subLabel, link: subLink }
              })
              .filter(
                (
                  item,
                ): item is {
                  label: string
                  link: string
                } => item !== null,
              )
          : []

        return {
          label,
          link,
          submenu: submenuRows.length > 0 ? submenuRows : undefined,
        }
      })
      .filter((row): row is Exclude<typeof row, null> => row !== null)

    const base =
      mapped.length > 0
        ? mapped.map((item) => normalizeNavItem(item))
        : DEFAULT_HEADER_NAV_ITEMS.map((item) => normalizeNavItem(item))

    return base
  } catch {
    return DEFAULT_HEADER_NAV_ITEMS.map((item) => normalizeNavItem(item))
  }
}
