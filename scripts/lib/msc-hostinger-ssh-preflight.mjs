#!/usr/bin/env node
/**
 * Shared SSH credential preflight for Hostinger deploy scripts.
 * @returns {{ host: string, port: number, username: string, password: string, appRoot: string }}
 */
export function requireHostingerSshEnv(banner = "[msc:hostinger]") {
  const host = process.env.HOSTINGER_SSH_HOST;
  const port = parseInt(process.env.HOSTINGER_SSH_PORT || "65002", 10);
  const username = process.env.HOSTINGER_SSH_USER;
  const password = process.env.HOSTINGER_SSH_PASSWORD;
  const appRoot =
    process.env.HOSTINGER_APP_ROOT ||
    "/home/u942711528/domains/mystudiochannel.com/nodejs";

  if (!host || !username || !password) {
    console.error(
      `${banner} FAIL — set HOSTINGER_SSH_HOST, HOSTINGER_SSH_USER, HOSTINGER_SSH_PASSWORD in .env.local`,
    );
    process.exit(1);
  }

  return { host, port, username, password, appRoot };
}
