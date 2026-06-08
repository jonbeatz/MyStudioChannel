#!/usr/bin/env node

import './lib/msc-load-env.mjs';
import { execSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..');
/** MyStudioChannel project default — override with MSC_BACKUP_ROOT in .env.local */
const DEFAULT_BACKUP_ROOT = 'G:\\Cursor_Project_BackUpz\\MyStudioChannel';
/** Folder names under backup root: msc-website-v2-a … msc-website-v2-z */
const BACKUP_FOLDER_PREFIX = 'msc-website-v2';
const BACKUP_FOLDER_PATTERN = /^msc-website-v2-([a-z])$/i;
const STANDARD_DIRS = ['node_modules', '.next', 'logs', 'test-results', 'zips'];
const NOTES_REL_PATH = path.join('.cursor', 'BackUp-Notez.md');
const NOTES_FOOTER =
  '\n*Backup created — includes source code, config, and portable modules.*\n';

const rawArgs = process.argv.slice(2);
const noteFlagIndex = rawArgs.findIndex((a) => a === '--note' || a === '-n');
const userNoteFromCli = noteFlagIndex !== -1 ? (rawArgs[noteFlagIndex + 1] || '').trim() : '';
const args =
  noteFlagIndex === -1
    ? rawArgs
    : rawArgs.filter((_, i) => i !== noteFlagIndex && i !== noteFlagIndex + 1);

const isFullBackup = args.includes('--full') || args.includes('-f');
const isStandardBackup = args.includes('--standard') || args.includes('-s');
const skipConfirm = args.includes('--yes') || args.includes('-y');
const isDryRun = args.includes('--dry-run');
const customName = args.find((a) => !a.startsWith('-')) || null;

function getProjectName() {
  try {
    const pkgPath = path.join(REPO_ROOT, 'package.json');
    if (fs.existsSync(pkgPath)) {
      const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
      if (pkg.name && typeof pkg.name === 'string') {
        return pkg.name.replace(/^@/, '').replace(/\//g, '-');
      }
    }
  } catch {
    /* use folder name */
  }
  return path.basename(REPO_ROOT);
}

function getProjectVersion() {
  try {
    const pkgPath = path.join(REPO_ROOT, 'package.json');
    if (fs.existsSync(pkgPath)) {
      const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
      if (pkg.version && typeof pkg.version === 'string') {
        return pkg.version;
      }
    }
  } catch {
    /* fallback */
  }
  return 'unknown';
}

function defaultBackupFolder(projectName) {
  const stamp = new Date().toISOString().slice(0, 19).replace(/:/g, '-');
  return `${projectName}-backup-${stamp}`;
}

/** List `msc-website-v2-*` folders in backup root (for agent / interactive hints). */
function listSequentialBackupFolders(backupRoot) {
  if (!fs.existsSync(backupRoot)) return [];
  return fs
    .readdirSync(backupRoot, { withFileTypes: true })
    .filter((d) => d.isDirectory() && BACKUP_FOLDER_PATTERN.test(d.name))
    .map((d) => d.name)
    .sort((a, b) => a.localeCompare(b, undefined, { sensitivity: 'base' }));
}

/**
 * Next folder: msc-website-v2-a … z (e.g. …-a → …-b). Falls back to timestamp name if z exhausted.
 */
function suggestNextBackupFolder(backupRoot) {
  const existing = listSequentialBackupFolders(backupRoot);
  if (existing.length === 0) {
    return `${BACKUP_FOLDER_PREFIX}-a`;
  }

  let maxLetter = '@';
  for (const name of existing) {
    const letter = name.match(BACKUP_FOLDER_PATTERN)?.[1]?.toLowerCase();
    if (letter && letter > maxLetter) maxLetter = letter;
  }

  const nextCode = maxLetter.charCodeAt(0) + 1;
  if (nextCode > 'z'.charCodeAt(0)) {
    console.warn(
      `⚠️  ${BACKUP_FOLDER_PREFIX}-z exists; falling back to timestamp folder name.`,
    );
    return defaultBackupFolder(getProjectName());
  }

  return `${BACKUP_FOLDER_PREFIX}-${String.fromCharCode(nextCode)}`;
}

function displayBackupType(backupType) {
  return backupType === 'FULL' ? 'Full' : 'Standard';
}

function escapeTableCell(text) {
  return String(text).replace(/\|/g, '\\|').replace(/\r?\n/g, ' ').trim();
}

function getGitInfo(repoRoot) {
  try {
    const branch = execSync('git branch --show-current', {
      cwd: repoRoot,
      encoding: 'utf8',
    }).trim();
    const commit = execSync('git rev-parse --short HEAD', {
      cwd: repoRoot,
      encoding: 'utf8',
    }).trim();
    const message = execSync('git log -1 --pretty=%B', {
      cwd: repoRoot,
      encoding: 'utf8',
    })
      .trim()
      .split('\n')[0];
    return { branch, commit, message };
  } catch {
    return { branch: 'unknown', commit: 'unknown', message: 'unknown' };
  }
}

function verifyBackupContents(backupPath, backupType) {
  const errors = [];
  const warnings = [];
  const checks = [
    { path: 'package.json', type: 'file', required: true },
    { path: 'payload.sqlite', type: 'file', required: true },
    { path: '.env.local', type: 'file', required: true },
    { path: 'app', type: 'dir', required: true },
    { path: 'components', type: 'dir', required: true },
    { path: 'lib', type: 'dir', required: true },
  ];

  if (backupType === 'FULL') {
    checks.push({ path: 'node_modules', type: 'dir', required: true });
    checks.push({ path: '.next', type: 'dir', required: false });
  }

  for (const check of checks) {
    const targetPath = path.join(backupPath, check.path);
    if (!fs.existsSync(targetPath)) {
      if (check.required) {
        errors.push(`Missing required ${check.type}: ${check.path}`);
      } else {
        warnings.push(`Missing optional ${check.type}: ${check.path}`);
      }
    } else {
      const stat = fs.statSync(targetPath);
      if (check.type === 'file' && !stat.isFile()) {
        errors.push(`Expected file, found directory: ${check.path}`);
      } else if (check.type === 'dir' && !stat.isDirectory()) {
        errors.push(`Expected directory, found file: ${check.path}`);
      }
    }
  }

  return {
    success: errors.length === 0,
    errors,
    warnings,
    checkedItemsCount: checks.length
  };
}

function formatExcluded(backupType) {
  if (backupType === 'FULL') {
    return 'None (full backup)';
  }
  return STANDARD_DIRS.map((d) => `${d}/`).join(', ');
}

function formatIncluded(backupType) {
  if (backupType === 'FULL') {
    return 'Full mirror (all project files)';
  }
  return '.env.local';
}

function buildNoteEntry({ timestamp, backupType, userNotes, gitInfo, backupFolder, projectVersion, verification }) {
  const typeLabel = displayBackupType(backupType);
  let entry = `## [${timestamp}] - ${typeLabel} Backup\n\n`;

  if (userNotes?.trim()) {
    entry += `**My Notes:** ${userNotes.trim()}\n\n---\n\n`;
  } else {
    entry += `---\n\n`;
  }

  entry += `| Field | Value |\n`;
  entry += `|-------|-------|\n`;
  entry += `| **Folder** | ${escapeTableCell(backupFolder)} |\n`;
  entry += `| **Version** | ${escapeTableCell(projectVersion)} |\n`;
  entry += `| **Branch** | ${escapeTableCell(gitInfo.branch)} |\n`;
  entry += `| **Commit** | ${escapeTableCell(gitInfo.commit)} |\n`;
  entry += `| **Message** | ${escapeTableCell(gitInfo.message)} |\n`;
  entry += `| **Type** | ${typeLabel} |\n`;
  entry += `| **Excluded** | ${escapeTableCell(formatExcluded(backupType))} |\n`;
  entry += `| **Included (secrets)** | ${escapeTableCell(formatIncluded(backupType))} |\n`;
  
  if (verification) {
    const verifStatus = verification.success
      ? `✅ Verified (${verification.checkedItemsCount}/${verification.checkedItemsCount} items intact)`
      : `❌ Failed (${verification.errors.length} errors, see terminal)`;
    entry += `| **Verification** | ${escapeTableCell(verifStatus)} |\n`;
  }

  entry += `\n---\n\n`;

  return entry;
}

function prependBackupNote(backupPath, entry, preservedTail = '') {
  const notesPath = path.join(backupPath, NOTES_REL_PATH);
  const notesDir = path.dirname(notesPath);

  if (!fs.existsSync(notesDir)) {
    fs.mkdirSync(notesDir, { recursive: true });
  }

  let tail = preservedTail;
  if (!tail && fs.existsSync(notesPath)) {
    tail = fs.readFileSync(notesPath, 'utf8');
  }

  if (!tail.includes('*Backup created — includes source code')) {
    tail = tail + NOTES_FOOTER;
  }

  fs.writeFileSync(notesPath, entry + tail, 'utf8');
  return notesPath;
}

function readExistingNotesBody(backupPath) {
  const notesPath = path.join(backupPath, NOTES_REL_PATH);
  if (!fs.existsSync(notesPath)) {
    return '';
  }
  let content = fs.readFileSync(notesPath, 'utf8');
  const legacyFooterIdx = content.indexOf('\n# Backup Notes\n');
  if (legacyFooterIdx !== -1) {
    content = content.slice(0, legacyFooterIdx);
  }
  const footerIdx = content.indexOf('\n*Backup created — includes source code');
  if (footerIdx !== -1) {
    content = content.slice(0, footerIdx);
  }
  const trimmed = content.trimEnd();
  return trimmed ? `${trimmed}\n\n` : '';
}

function askQuestion(rl, question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

function createReadline() {
  return readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
}

async function resolveBackupPlan(rl) {
  const projectName = getProjectName();

  let backupRoot = process.env.MSC_BACKUP_ROOT?.trim() || '';
  let backupFolder = customName || '';
  const interactive = process.stdin.isTTY;

  console.log(`
╔══════════════════════════════════════════════════════════════╗
║  📦 Portable Backup System                                   ║
╚══════════════════════════════════════════════════════════════╝

Current project: ${projectName}
Source: ${REPO_ROOT}
`);

  if (interactive) {
    if (!backupRoot) {
      const answer = await askQuestion(rl, `Backup drive/folder [${DEFAULT_BACKUP_ROOT}]: `);
      backupRoot = answer.trim() || DEFAULT_BACKUP_ROOT;
    } else {
      console.log(`Backup root (from MSC_BACKUP_ROOT): ${backupRoot}`);
    }
  } else {
    backupRoot = backupRoot || DEFAULT_BACKUP_ROOT;
  }

  const existingSeq = listSequentialBackupFolders(backupRoot);
  if (existingSeq.length > 0) {
    console.log(`Existing backups (${existingSeq.length}): ${existingSeq.join(', ')}`);
  }

  const suggestedFolder =
    customName || suggestNextBackupFolder(backupRoot);

  if (interactive) {
    if (!backupFolder) {
      const folderAnswer = await askQuestion(rl, `Backup folder name [${suggestedFolder}]: `);
      backupFolder = folderAnswer.trim() || suggestedFolder;
    }
  } else {
    backupFolder = backupFolder || suggestedFolder;
    console.log(`Backup root: ${backupRoot}`);
    console.log(`Backup folder: ${backupFolder}`);
  }

  const fullBackupPath = path.join(backupRoot, backupFolder);
  const backupType = isFullBackup ? 'FULL' : 'STANDARD';

  console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Source:      ${REPO_ROOT}
📂 Destination: ${fullBackupPath}
📦 Type:        ${backupType}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`);

  if (interactive && !skipConfirm) {
    const confirm = await askQuestion(rl, 'Proceed with backup? (y/n): ');
    if (confirm.trim().toLowerCase() !== 'y') {
      console.log('\n❌ Backup cancelled.');
      return null;
    }
  } else if (!interactive && !skipConfirm) {
    console.log('\nNon-interactive session: add --yes to run, or run from a terminal for prompts.');
    return null;
  }

  let userNotes = userNoteFromCli;
  if (interactive && !userNotes) {
    userNotes = await askQuestion(
      rl,
      '\n📝 Add a short note about this backup (optional, press Enter to skip): ',
    );
    userNotes = userNotes.trim();
  }

  return { fullBackupPath, backupFolder, backupType, userNotes };
}

function printSuccess(fullBackupPath, backupType, backupFolder, notesPath, verification) {
  console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Backup complete!
📂 Location: ${fullBackupPath}
📦 Type:     ${backupType}
📝 Notes:    ${notesPath}
`);

  if (verification) {
    console.log("🔍 [POST-BACKUP VERIFICATION REPORT]");
    if (verification.success) {
      console.log(`   ✅ SUCCESS: All ${verification.checkedItemsCount} critical elements verified as fully intact.`);
    } else {
      console.log(`   ❌ FAILURE: ${verification.errors.length} elements missing/corrupted!`);
      for (const err of verification.errors) {
        console.log(`      - ${err}`);
      }
    }
    if (verification.warnings.length > 0) {
      for (const warn of verification.warnings) {
        console.log(`      ⚠️  Warning: ${warn}`);
      }
    }
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  console.log(`Folder: ${backupFolder}`);
}

async function main() {
  const rl = createReadline();

  try {
    const plan = await resolveBackupPlan(rl);
    if (!plan) {
      return;
    }

    const { fullBackupPath, backupFolder, backupType, userNotes } = plan;

    if (isDryRun) {
      console.log('\n[dry-run] Non-interactive backup plan (no files copied):');
      console.log(`  Destination: ${fullBackupPath}`);
      console.log(`  Folder:      ${backupFolder}`);
      console.log(`  Type:        ${backupType}`);
      console.log(`  Note:        ${userNotes || '(none)'}`);
      return;
    }

    if (!fs.existsSync(fullBackupPath)) {
      fs.mkdirSync(fullBackupPath, { recursive: true });
    }

    let cmd = `robocopy "${REPO_ROOT}" "${fullBackupPath}" /MIR`;

    if (isStandardBackup || (!isFullBackup && !isStandardBackup)) {
      cmd += ` /XD ${STANDARD_DIRS.join(' ')}`;
      console.log(`ℹ️  Standard skips: ${STANDARD_DIRS.join(', ')}\n`);
      console.log('ℹ️  Keep backup destination private (.env.local is copied).\n');
    } else {
      console.log('ℹ️  Full backup: no directory skips (includes node_modules, .next)\n');
    }

    console.log('📦 Creating backup...\n');

    const now = new Date();
    const timestamp = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;
    const gitInfo = getGitInfo(REPO_ROOT);
    const projectVersion = getProjectVersion();

    let robocopyOk = false;

    try {
      execSync(cmd, { stdio: 'inherit', shell: 'powershell.exe' });
      robocopyOk = true;
    } catch (error) {
      if (error.status === 1) {
        robocopyOk = true;
      } else {
        console.error(`\n❌ Backup failed: ${error.message}`);
        process.exit(1);
      }
    }

    if (robocopyOk) {
      // Run Verification on copied files
      const verification = verifyBackupContents(fullBackupPath, backupType);
      
      const noteEntry = buildNoteEntry({
        timestamp,
        backupType,
        userNotes,
        gitInfo,
        backupFolder,
        projectVersion,
        verification,
      });
      const preservedNotes = readExistingNotesBody(fullBackupPath);
      
      const notesPath = prependBackupNote(fullBackupPath, noteEntry, preservedNotes);
      printSuccess(fullBackupPath, backupType, backupFolder, notesPath, verification);
    }
  } finally {
    rl.close();
  }
}

main();
