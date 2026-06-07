import type { GlobalConfig } from "payload"

import { adminRowsStartCollapsed } from "@/lib/payload-admin-defaults"

export const HeaderGlobal: GlobalConfig = {
  slug: "header",
  label: "Header",
  admin: {
    group: "Site",
    description: "Manage primary header navigation links for the marketing site.",
  },
  access: {
    read: () => true,
    update: ({ req }) => Boolean(req.user),
  },
  fields: [
    {
      name: "navItems",
      label: "Navigation items",
      type: "array",
      minRows: 1,
      admin: {
        ...adminRowsStartCollapsed,
        description:
          "Set **Submenu source** to **From Pages collection** when a row should list published pages from **Site → Pages** (slug `home` and `msc1` excluded; each page can opt out with **Show in header nav**). Use **Manual** for section anchors like Services and Resources.",
      },
      defaultValue: [
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
      ],
      fields: [
        {
          name: "label",
          type: "text",
          required: true,
        },
        {
          name: "submenuSource",
          label: "Submenu source",
          type: "select",
          defaultValue: "manual",
          options: [
            { label: "Manual", value: "manual" },
            { label: "From Pages collection", value: "pages-collection" },
          ],
          admin: {
            description:
              "**Manual** — edit **Submenu items** below. **From Pages collection** — dropdown is built from **Site → Pages** at runtime (manual submenu and link are ignored).",
          },
        },
        {
          name: "link",
          type: "text",
          required: true,
          admin: {
            description:
              "Use section anchors (e.g. #msc-contact); runtime resolves to # on the home page and /# off home. Full URLs allowed. Ignored when **Submenu source** is **From Pages collection** (parent link becomes `/`).",
          },
        },
        {
          name: "submenu",
          label: "Submenu items",
          type: "array",
          admin: {
            ...adminRowsStartCollapsed,
            condition: (_data, siblingData) =>
              siblingData?.submenuSource !== "pages-collection",
          },
          fields: [
            {
              name: "label",
              type: "text",
              required: true,
            },
            {
              name: "link",
              type: "text",
              required: true,
            },
          ],
        },
      ],
    },
  ],
}

