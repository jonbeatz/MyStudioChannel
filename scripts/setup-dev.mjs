#!/usr/bin/env node
/**
 * MSC PRO ENGINE - Developer Onboarding Script
 * Automates the initial setup for new contributors.
 * 
 * Usage:
 *   npm run setup:dev
 */

import fs from 'node:fs';
import path from 'node:path';
import { execSync, spawnSync } from 'node:child_process';
import process from 'node:process';
import readline from 'node:readline';

const REPO_ROOT = process.cwd();
const BANNER = '\x1b[1m\x1b[33m[msc:setup]\x1b[0m'; // Gold [msc:setup]
const SUCCESS = '\x1b[32m✅\x1b[0m';
const WARN = '\x1b[33m⚠️\x1b[0m';
const ERROR = '\x1b[31m❌\x1b[0m';
const INFO = '\x1b[36mℹ️\x1b[0m';

console.log(`\n${BANNER} Starting automated developer onboarding...\n`);

// 1. Node.js Version Check
const nodeVersion = process.version;
const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0], 10);
const supportedVersions = [18, 20, 22, 24]; // Adding 24 as current user is on 24

if (!supportedVersions.includes(majorVersion)) {
  console.warn(`${WARN} Node Version: ${nodeVersion}`);
  console.warn(`   Notice: This project is production-hardened for Node 18, 20, or 22.`);
  console.warn(`   You are using ${nodeVersion}. Continuing, but beware of drift.\n`);
} else {
  console.log(`${SUCCESS} Node Version: ${nodeVersion} (Supported)`);
}

// 2. Install Dependencies
console.log(`\n${INFO} Installing dependencies (npm install)...`);
try {
  execSync('npm install', { stdio: 'inherit', cwd: REPO_ROOT });
  console.log(`${SUCCESS} Dependencies installed.\n`);
} catch (error) {
  console.error(`${ERROR} npm install failed.`);
  process.exit(1);
}

// 3. Setup Environment Variables
const examplePath = path.join(REPO_ROOT, '.env.example');
const localPath = path.join(REPO_ROOT, '.env.local');

if (!fs.existsSync(localPath)) {
  console.log(`${INFO} Creating .env.local from .env.example...`);
  try {
    if (fs.existsSync(examplePath)) {
      fs.copyFileSync(examplePath, localPath);
      console.log(`${SUCCESS} .env.local created.\n`);
    } else {
      console.warn(`${WARN} .env.example not found. Skipping env setup.\n`);
    }
  } catch (error) {
    console.error(`${ERROR} Failed to create .env.local.`);
  }
} else {
  console.log(`${SUCCESS} .env.local already exists. Skipping copy.\n`);
}

// 4. Database Seeding (Interactive)
async function handleSeeding() {
  const dbPath = path.join(REPO_ROOT, 'payload.sqlite');
  let needsSeed = true;

  if (fs.existsSync(dbPath)) {
    const stats = fs.statSync(dbPath);
    if (stats.size > 1000) {
      needsSeed = false;
      console.log(`${SUCCESS} SQLite database found and has data.\n`);
    }
  }

  if (needsSeed) {
    console.log(`${INFO} No existing database or database is empty.`);
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    const answer = await new Promise(resolve => {
      rl.question(`${BANNER} Do you want to seed the database with sample data? (y/n): `, resolve);
    });
    rl.close();

    if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') {
      console.log(`\n${INFO} Running seeder (npm run seed:demo-page)...`);
      try {
        execSync('npm run msc:seed:demo-page', { stdio: 'inherit', cwd: REPO_ROOT });
        console.log(`${SUCCESS} Database seeded successfully.\n`);
      } catch (error) {
        console.warn(`${WARN} Seeding failed, but environment is otherwise ready.`);
      }
    } else {
      console.log(`${INFO} Skipping basic seeding.`);
      
      const prodAnswer = await new Promise(resolve => {
        rl.question(`\n${BANNER} Do you want to seed production-representative data from JSON? (y/n): `, resolve);
      });

      if (prodAnswer.toLowerCase() === 'y' || prodAnswer.toLowerCase() === 'yes') {
        console.log(`\n${INFO} Running production seeder (npm run seed:all)...`);
        try {
          execSync('npm run seed:all', { stdio: 'inherit', cwd: REPO_ROOT });
          console.log(`${SUCCESS} Production data seeded successfully.\n`);
        } catch (error) {
          console.warn(`${WARN} Production seeding failed, but environment is otherwise ready.`);
        }
      } else {
        console.log(`${INFO} Skipping all seeding. You will start with an empty database.\n`);
      }
    }
    rl.close();

// 5. Final Health Check (msc:doctor)
async function runDoctor() {
  console.log(`${INFO} Running final system health check...`);
  try {
    execSync('npm run msc:doctor', { stdio: 'inherit', cwd: REPO_ROOT });
  } catch (error) {
    console.warn(`${WARN} Health check reported issues. See logs above.`);
  }
}

// Main Execution
async function main() {
  await handleSeeding();
  await runDoctor();

  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`\x1b[1m\x1b[32mSETUP COMPLETE!\x1b[0m`);
  console.log(`\nNext steps for you:`);
  console.log(`  1. \x1b[1mnpm run dev\x1b[0m - Start the development server`);
  console.log(`  2. Visit \x1b[4mhttp://localhost:3000\x1b[0m in your browser`);
  console.log(`  3. Visit \x1b[4mhttp://localhost:3000/admin\x1b[0m for the CMS`);
  console.log(`\nWelcome to the MyStudioChannel team!`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
}

main().catch(err => {
  console.error(`\n${ERROR} Setup failed unexpectedly:`, err);
  process.exit(1);
});
