/**
 * Postiz API client stub — Phase 2 live scheduling.
 * Docs: https://docs.postiz.com/public-api
 */
import '../lib/msc-load-env.mjs';

function getConfig() {
  const baseUrl = (process.env.POSTIZ_API_URL || 'http://localhost:4007/api/public/v1').replace(/\/$/, '');
  const apiKey = process.env.POSTIZ_API_KEY || '';
  return { baseUrl, apiKey };
}

function authHeaders(apiKey) {
  return {
    'Content-Type': 'application/json',
    Authorization: apiKey,
  };
}

/**
 * Schedule or publish posts via Postiz API.
 * @param {{ campaign: object, formatted: Record<string, object>, live?: boolean }} params
 */
export async function schedulePost({ campaign, formatted, live = false }) {
  const { baseUrl, apiKey } = getConfig();

  if (!apiKey) {
    return {
      success: false,
      dryRun: true,
      error: 'POSTIZ_API_KEY not set in .env.local — connect Postiz first (Phase 2)',
      hint: 'Install Postiz at D:\\Hermes\\postiz and add API key from Settings',
    };
  }

  const payload = {
    type: 'schedule',
    date: campaign.scheduledAt,
    posts: Object.entries(formatted).map(([integration, data]) => ({
      integration,
      value: [
        {
          content: data.text,
          image: campaign.image?.publicUrl || null,
        },
      ],
    })),
  };

  try {
    const res = await fetch(`${baseUrl}/posts`, {
      method: 'POST',
      headers: authHeaders(apiKey),
      body: JSON.stringify(payload),
    });

    const body = await res.json().catch(() => ({}));
    if (!res.ok) {
      return { success: false, status: res.status, error: body.message || res.statusText, body };
    }
    return { success: true, live, body };
  } catch (err) {
    return {
      success: false,
      error: err.message,
      hint: 'Is Postiz running? POSTIZ_API_URL=' + baseUrl,
    };
  }
}

/**
 * Health check for self-hosted Postiz.
 */
export async function checkPostizHealth() {
  const { baseUrl, apiKey } = getConfig();
  if (!apiKey) {
    return { ok: false, error: 'POSTIZ_API_KEY not set' };
  }
  try {
    const res = await fetch(`${baseUrl}/integrations`, {
      method: 'GET',
      headers: { Authorization: apiKey },
    });
    return { ok: res.ok, status: res.status };
  } catch (err) {
    return { ok: false, error: err.message };
  }
}
