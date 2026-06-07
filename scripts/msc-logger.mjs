import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import readline from 'node:readline';

const REPO_ROOT = process.cwd();
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });

const ask = (query) => new Promise((resolve) => rl.question(query, resolve));

async function logFix() {
  console.log('\n🔧 MSC Fix Logger');
  const issue = await ask('What was the issue? ');
  const cause = await ask('Root cause? ');
  const solution = await ask('Shortest verified fix? ');
  
  const date = new Date().toISOString().split('T')[0];
  const entry = `\n## [${date}] - ${issue}\n- **Symptom:** ${issue}\n- **Root Cause:** ${cause}\n- **Resolution:** ${solution}\n`;
  
  const filePath = path.join(REPO_ROOT, '.cursor/docs/ISSUES-RESOLVED.md');
  fs.appendFileSync(filePath, entry);
  console.log(`✅ Logged to ISSUES-RESOLVED.md`);
  rl.close();
}

async function logSession() {
  console.log('\n📝 MSC Session Logger');
  const summary = await ask('Summary of session? ');
  const branch = await ask('Active branch? ');
  
  const date = new Date().toLocaleString();
  const entry = `\n## [${date}] - Session Summary\n- **Branch:** ${branch}\n- **Changes:** ${summary}\n- **Status:** completed\n`;
  
  const filePath = path.join(REPO_ROOT, '.cursor/docs/project-log.md');
  fs.appendFileSync(filePath, entry);
  console.log(`✅ Logged to project-log.md`);
  rl.close();
}

async function logMilestone() {
  console.log('\n🌟 MSC Milestone Logger');
  const milestone = await ask('Milestone name? ');
  const commit = await ask('Commit hash (optional)? ') || 'chore';
  const summary = await ask('Brief summary of achievement? ');
  
  const date = new Date().toISOString().split('T')[0];
  
  // 1. Update Restore-Points.md
  const restoreEntry = `\n| ${date} | **${milestone}** | ${commit} | ${summary} |\n`;
  const restorePath = path.join(REPO_ROOT, '.cursor/docs/Restore-Points.md');
  if (fs.existsSync(restorePath)) {
    fs.appendFileSync(restorePath, restoreEntry);
    console.log(`✅ Restore point added.`);
  }

  // 2. Update Checkpoint.md (Recent Milestones)
  const checkpointPath = path.join(REPO_ROOT, '.cursor/docs/Checkpoint.md');
  if (fs.existsSync(checkpointPath)) {
    let content = fs.readFileSync(checkpointPath, 'utf8');
    const milestoneRow = `| ${date} | **${milestone}** | ${commit} |`;
    content = content.replace('## Recent Milestones', `## Recent Milestones\n${milestoneRow}`);
    fs.writeFileSync(checkpointPath, content);
    console.log(`✅ Checkpoint updated.`);
  }
  
  rl.close();
}

const mode = process.argv[2];
if (mode === '--fix') logFix();
else if (mode === '--session') logSession();
else if (mode === '--milestone') logMilestone();
else {
  console.log('Usage: node scripts/msc-logger.mjs [--fix|--session|--milestone]');
  rl.close();
}
