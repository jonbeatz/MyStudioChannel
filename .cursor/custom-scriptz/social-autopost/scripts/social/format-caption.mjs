/**
 * Per-platform caption formatting for social auto-post.
 * Usage: node scripts/social/format-caption.mjs --platform instagram --text "..." [--hashtags tag1,tag2]
 */

const PLATFORMS = {
  facebook: {
    maxLength: 500,
    hashtagStyle: 'inline',
    notes: 'Practical limit ~500 chars for engagement',
  },
  instagram: {
    maxLength: 2200,
    hashtagStyle: 'block',
    maxHashtags: 30,
    notes: 'Hashtags often placed after line break',
  },
  tiktok: {
    maxLength: 4000,
    hashtagStyle: 'inline',
    maxHashtags: 10,
  },
  x: {
    maxLength: 280,
    hashtagStyle: 'inline',
    maxHashtags: 5,
    notes: 'X API is paid per post in 2026',
  },
  youtube: {
    maxLength: 5000,
    titleMaxLength: 100,
    hashtagStyle: 'description',
    notes: 'Use as video description; title separate',
  },
  wordpress: {
    maxLength: 100000,
    hashtagStyle: 'none',
    notes: 'Long-form; use excerpt for social teaser',
  },
  payload: {
    maxLength: 100000,
    hashtagStyle: 'none',
    notes: 'MSC site CMS post body',
  },
};

const IMAGE_DEFAULTS = {
  facebook: { width: 1080, height: 1080 },
  instagram: { width: 1080, height: 1080 },
  tiktok: { width: 1080, height: 1920 },
  x: { width: 1200, height: 675 },
  youtube: { width: 1280, height: 720 },
  wordpress: { width: 1200, height: 630 },
  payload: { width: 1200, height: 630 },
};

function parseArgs(argv) {
  const out = { platform: '', text: '', hashtags: [], title: '' };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--platform' && argv[i + 1]) out.platform = argv[++i].toLowerCase();
    else if (a === '--text' && argv[i + 1]) out.text = argv[++i];
    else if (a === '--hashtags' && argv[i + 1]) {
      out.hashtags = argv[++i].split(',').map((t) => t.trim()).filter(Boolean);
    } else if (a === '--title' && argv[i + 1]) out.title = argv[++i];
    else if (a === '--json' && argv[i + 1]) {
      try {
        const spec = JSON.parse(argv[++i]);
        out.platform = spec.platform || out.platform;
        out.text = spec.text ?? spec.draft ?? out.text;
        out.hashtags = spec.hashtags || out.hashtags;
        out.title = spec.title || out.title;
      } catch {
        /* ignore */
      }
    }
  }
  return out;
}

function formatHashtags(tags, style) {
  if (!tags?.length || style === 'none') return '';
  const normalized = tags.map((t) => (t.startsWith('#') ? t : `#${t}`));
  if (style === 'block') return '\n\n' + normalized.join(' ');
  return ' ' + normalized.join(' ');
}

export function formatCaptionForPlatform(platform, text, options = {}) {
  const key = platform.toLowerCase();
  const rules = PLATFORMS[key];
  if (!rules) {
    throw new Error(`Unknown platform: ${platform}. Supported: ${Object.keys(PLATFORMS).join(', ')}`);
  }

  const hashtags = options.hashtags || [];
  let body = (text || '').trim();
  const tagSuffix = formatHashtags(hashtags.slice(0, rules.maxHashtags ?? hashtags.length), rules.hashtagStyle);

  if (rules.hashtagStyle === 'block' && tagSuffix) {
    body = body + tagSuffix;
  } else if (tagSuffix) {
    body = body + tagSuffix;
  }

  let truncated = body;
  if (body.length > rules.maxLength) {
    truncated = body.slice(0, rules.maxLength - 1) + '…';
  }

  const title = options.title || '';
  let formattedTitle = title;
  if (rules.titleMaxLength && title.length > rules.titleMaxLength) {
    formattedTitle = title.slice(0, rules.titleMaxLength - 1) + '…';
  }

  return {
    platform: key,
    text: truncated,
    title: formattedTitle || undefined,
    charCount: truncated.length,
    maxLength: rules.maxLength,
    truncated: truncated.length < body.length,
    image: IMAGE_DEFAULTS[key] || { width: 1080, height: 1080 },
    notes: rules.notes,
  };
}

export function getImageDefaultsForPlatform(platform) {
  return IMAGE_DEFAULTS[platform.toLowerCase()] || { width: 1080, height: 1080 };
}

export function getImageDefaultsForPlatforms(platforms) {
  if (!platforms?.length) return { width: 1080, height: 1080 };
  return getImageDefaultsForPlatform(platforms[0]);
}

export function listPlatforms() {
  return Object.keys(PLATFORMS);
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (!args.platform) {
    console.error('Usage: node scripts/social/format-caption.mjs --platform <name> --text "..." [--hashtags a,b]');
    process.exit(1);
  }
  const result = formatCaptionForPlatform(args.platform, args.text, {
    hashtags: args.hashtags,
    title: args.title,
  });
  console.log(JSON.stringify(result, null, 2));
}

const isMain = process.argv[1]?.replace(/\\/g, '/').endsWith('format-caption.mjs');
if (isMain) main();
