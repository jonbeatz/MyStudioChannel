import packageJson from "../package.json"

/** App release version — sole source: root package.json "version". */
export const MSC_APP_VERSION = packageJson.version

export const MSC_BRAND_NAME = "MyStudioChannel" as const

/** Footer: `MyStudioChannel v4.0.0` */
export const MSC_FOOTER_VERSION_LABEL = `${MSC_BRAND_NAME} v${MSC_APP_VERSION}` as const

/** Payload admin sidebar: `MyStudioChannel Admin v4.0.0` */
export const MSC_ADMIN_VERSION_LABEL = `${MSC_BRAND_NAME} Admin v${MSC_APP_VERSION}` as const
