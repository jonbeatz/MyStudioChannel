import fs from 'node:fs';
import path from 'node:path';
import { execSync, spawnSync } from 'node:child_process';
import process from 'node:process';

const REPO_ROOT = process.cwd();
const BANNER = '[msc:doctor]';

console.log(`${BANNER} Starting project health check...`);

let healthy = true;

// 1. Node Version Check
const nodeVersion = process.version;
const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0], 10);
if (majorVersion >= 20) {
  console.log(`✅ Node Version: ${nodeVersion} (OK)`);
} else {
  console.error(`❌ Node Version: ${nodeVersion} (Required: >=20.x)`);
  healthy = false;
}

// 2. .env.local Check
const envPath = path.join(REPO_ROOT, '.env.local');
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
  const requiredKeys = [
    'NODE_ENV',
    'PAYLOAD_SECRET',
    'DATABASE_URL',
    'NEXT_PUBLIC_SERVER_URL',
    'PAYLOAD_PUBLIC_SERVER_URL',
    'RESEND_API_KEY',
    'PAYLOAD_DISABLE_SHARP'
  ];
  
  const missingKeys = requiredKeys.filter(key => !envContent.includes(key));
  if (missingKeys.length === 0) {
    console.log(`✅ .env.local: All required keys present.`);
  } else {
    console.warn(`⚠️ .env.local: Missing keys: ${missingKeys.join(', ')}`);
  }
} else {
  console.error(`❌ .env.local: File missing!`);
  healthy = false;
}

// 3. SQLite Database Health
const dbPath = path.join(REPO_ROOT, 'payload.sqlite');
if (fs.existsSync(dbPath)) {
  const stats = fs.statSync(dbPath);
  const sizeKB = stats.size / 1024;
  if (sizeKB > 500) {
    console.log(`✅ SQLite DB: Found (${Math.round(sizeKB)}KB)`);
  } else {
    console.warn(`⚠️ SQLite DB: Found but unusually small (${Math.round(sizeKB)}KB)`);
  }
  
  // Check for lock files
  const walExists = fs.existsSync(dbPath + '-wal');
  const shmExists = fs.existsSync(dbPath + '-shm');
  if (walExists || shmExists) {
    console.warn(`⚠️ SQLite DB: WAL/SHM files exist. Database might be in use or locked.`);
  }
} else {
  console.warn(`⚠️ SQLite DB: payload.sqlite not found in root.`);
}

// 4. Port 3000 Check
try {
  // Using a simple check to see if anything is listening
  const portCheck = execSync('netstat -ano | findstr :3000', { encoding: 'utf8', stdio: [] });
  if (portCheck) {
    console.warn(`⚠️ Port 3000: Already in use. 'npm run dev' might fail.`);
  }
} catch (e) {
  console.log(`✅ Port 3000: Free.`);
}

// 5. Git Status Check
try {
  const gitStatus = execSync('git status --porcelain', { encoding: 'utf8' }).trim();
  if (gitStatus) {
    console.warn(`⚠️ Git: You have uncommitted changes.`);
  } else {
    console.log(`✅ Git: Working tree clean.`);
  }
} catch (e) {
  console.warn(`⚠️ Git: Not a repository or git not found.`);
}

// 6. LiteLLM Proxy Status
const litellmConfig = path.join(REPO_ROOT, 'config', 'litellm_config.yaml');
if (fs.existsSync(litellmConfig)) {
  try {
    const status = execSync('npm run msc:litellm:status', { encoding: 'utf8', stdio: [] }).trim();
    console.log(`✅ LiteLLM Proxy: ${status}`);
  } catch (e) {
    console.log(`⚠️ LiteLLM Proxy: Offline.`);
  }
}

console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
if (healthy) {
  console.log(`✅ System Healthy. Ready for development, Jon.`);
} else {
  console.error(`❌ System check failed. Please resolve the errors above.`);
  process.exit(1);
}
