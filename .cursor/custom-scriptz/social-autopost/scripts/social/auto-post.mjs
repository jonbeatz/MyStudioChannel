#!/usr/bin/env node
/**
 * Social auto-post orchestrator (dry-run by default).
 * Usage: node scripts/social/auto-post.mjs --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
 */
import '../lib/msc-load-env.mjs';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import {
  formatCaptionForPlatform,
  getImageDefaultsForPlatforms,
} from './format-caption.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..', '..');
const OUTBOX_ROOT = path.join(REPO_ROOT, 'specs', 'social-autopost', 'outbox');

function parseArgs(argv) {
  const out = { spec: null, dryRun: true, live: false, generateImage: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--spec' && argv[i + 1]) out.spec = path.resolve(REPO_ROOT, argv[++i]);
    else if (a === '--dry-run') out.dryRun = true;
    else if (a === '--live') {
      out.live = true;
      out.dryRun = false;
    } else if (a === '--generate-image') out.generateImage = true;
    else if (a === '--help' || a === '-h') out.help = true;
  }
  return out;
}

function loadYamlLike(filePath) {
  const raw = fs.readFileSync(filePath, 'utf8');
  const lines = raw.split(/\r?\n/);
  const obj = {};
  let section = null;
  let listKey = null;
  let multiline = null;

  const flushMultiline = () => {
    if (!multiline) return;
    const { key, parent, lines: mlLines } = multiline;
    const text = mlLines.join('\n').trimEnd();
    if (parent) {
      if (!obj[parent] || typeof obj[parent] !== 'object') obj[parent] = {};
      obj[parent][key] = text;
    } else {
      obj[key] = text;
    }
    multiline = null;
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.trim().startsWith('#')) continue;

    if (multiline) {
      if (/^\s{2,}/.test(line) && !/^\s{2}\w+:/.test(line)) {
        multiline.lines.push(line.replace(/^\s{2}/, ''));
        continue;
      }
      flushMultiline();
    }

    const listItem = line.match(/^\s+-\s+(.+)$/);
    if (listItem && listKey) {
      if (!Array.isArray(obj[listKey])) obj[listKey] = [];
      obj[listKey].push(listItem[1].trim());
      continue;
    }

    const nestedMl = line.match(/^  (\w+):\s*\|\s*$/);
    if (nestedMl && section) {
      multiline = { key: nestedMl[1], parent: section, lines: [] };
      continue;
    }

    const nestedScalar = line.match(/^  (\w+):\s*(.+)$/);
    if (nestedScalar && section) {
      if (!obj[section] || typeof obj[section] !== 'object' || Array.isArray(obj[section])) {
        obj[section] = {};
      }
      let val = nestedScalar[2].trim();
      if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
        val = val.slice(1, -1);
      }
      if (val === 'true') val = true;
      if (val === 'false') val = false;
      obj[section][nestedScalar[1]] = val;
      continue;
    }

    const topList = line.match(/^(\w+):\s*$/);
    if (topList) {
      flushMultiline();
      const key = topList[1];
      const next = lines[i + 1] || '';
      if (/^\s+-\s+/.test(next)) {
        listKey = key;
        section = null;
        obj[key] = [];
      } else {
        section = key;
        listKey = null;
        obj[key] = obj[key] || {};
      }
      continue;
    }

    const top = line.match(/^(\w+):\s*(.+)$/);
    if (top) {
      flushMultiline();
      section = null;
      listKey = null;
      const key = top[1];
      let val = top[2].trim();
      if (val === 'true') obj[key] = true;
      else if (val === 'false') obj[key] = false;
      else {
        if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
          val = val.slice(1, -1);
        }
        obj[key] = val;
      }
    }
  }
  flushMultiline();
  return obj;
}

function ensureOutbox(campaignId) {
  const dir = path.join(OUTBOX_ROOT, campaignId);
  fs.mkdirSync(dir, { recursive: true });
  return dir;
}

function maybeGenerateImage(campaign, outDir) {
  const img = campaign.image || {};
  const defaults = getImageDefaultsForPlatforms(campaign.platforms);
  const width = Number(img.width) || defaults.width;
  const height = Number(img.height) || defaults.height;
  const prompt = img.prompt || campaign.topic;
  const outputPath = path.join(outDir, 'generated.png');

  const py = path.join(REPO_ROOT, 'scripts', 'generate-image.py');
  const result = spawnSync('python', [py, '--prompt', prompt, '--width', String(width), '--height', String(height), '--output', outputPath], {
    cwd: REPO_ROOT,
    encoding: 'utf8',
  });

  if (result.status !== 0) {
    return {
      success: false,
      error: result.stderr || result.stdout || 'generate-image failed',
      skipped: true,
    };
  }
  try {
    const parsed = JSON.parse(result.stdout.trim().split('\n').pop());
    return parsed;
  } catch {
    return { success: fs.existsSync(outputPath), file_path: outputPath };
  }
}

async function runPostizLive(campaign, formatted) {
  const { schedulePost } = await import('./postiz-client.mjs');
  return schedulePost({ campaign, formatted, live: true });
}

function printHelp() {
  console.log(`Social auto-post (dry-run default)

Usage:
  npm run social:auto-post -- --dry-run --spec <campaign.yaml>
  npm run social:auto-post -- --live --spec <campaign.yaml>   # requires Postiz credentials
  npm run social:auto-post -- --dry-run --spec <path> --generate-image

Options:
  --spec <file>       Campaign YAML path
  --dry-run           Preview only (default)
  --live              Schedule via Postiz API (Phase 2+)
  --generate-image    Call generate-image.py when HF_TOKEN is set
`);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    printHelp();
    process.exit(0);
  }
  if (!args.spec || !fs.existsSync(args.spec)) {
    console.error('[social:auto-post] --spec <path> required');
    printHelp();
    process.exit(1);
  }

  const campaign = loadYamlLike(args.spec);
  const dryRun = args.dryRun && !args.live && campaign.dryRun !== false;

  const campaignId = campaign.id || path.basename(args.spec, path.extname(args.spec));
  const outDir = ensureOutbox(campaignId);

  const draftText = campaign.caption?.draft || campaign.topic || '';
  const hashtags = campaign.caption?.hashtags || campaign.hashtags || [];
  const platforms = Array.isArray(campaign.platforms) ? campaign.platforms : [];
  const crossPostRaw = campaign.crossPost || {};
  const crossPost = {
    payload: crossPostRaw.payload === true || crossPostRaw.payload === 'true',
    wordpress: crossPostRaw.wordpress === true || crossPostRaw.wordpress === 'true',
  };

  const formatted = {};
  for (const platform of platforms) {
    formatted[platform] = formatCaptionForPlatform(platform, draftText, { hashtags });
  }

  let imageResult = { skipped: true, reason: 'dry-run or --generate-image not set' };
  if (args.generateImage && process.env.HF_TOKEN) {
    imageResult = maybeGenerateImage(campaign, outDir);
  } else if (args.generateImage) {
    imageResult = { skipped: true, reason: 'HF_TOKEN not set in .env.local' };
  }

  const preview = {
    mode: dryRun ? 'dry-run' : 'live',
    campaignId,
    topic: campaign.topic,
    scheduledAt: campaign.scheduledAt,
    platforms,
    formatted,
    image: imageResult,
    crossPost,
    outbox: outDir,
  };

  fs.writeFileSync(path.join(outDir, 'preview.json'), JSON.stringify(preview, null, 2), 'utf8');

  for (const [platform, data] of Object.entries(formatted)) {
    fs.writeFileSync(path.join(outDir, `${platform}-caption.txt`), data.text, 'utf8');
  }

  let postizResult = null;
  if (!dryRun) {
    postizResult = await runPostizLive(campaign, formatted);
    preview.postiz = postizResult;
    fs.writeFileSync(path.join(outDir, 'preview.json'), JSON.stringify(preview, null, 2), 'utf8');
  }

  console.log(JSON.stringify({ success: true, ...preview, postiz: postizResult }, null, 2));
}

main().catch((err) => {
  console.error('[social:auto-post]', err.message);
  process.exit(1);
});
