import { execSync } from 'child_process';
import fetch from 'node-fetch';
import fs from 'fs';
import dotenv from 'dotenv';

const tests = [
  { 
    name: 'github', 
    type: 'cli',
    cmd: 'gh repo list jonbeatz --limit 1' 
  },
  { 
    name: 'filesystem', 
    type: 'api',
    test: async () => {
      return fs.existsSync('payload.sqlite');
    }
  },
  { 
    name: 'payload', 
    type: 'http',
    url: 'http://localhost:3000/api/globals/homepage?depth=0' 
  },
  {
    name: 'resend',
    type: 'env',
    test: async () => {
      dotenv.config({ path: '.env.local' });
      return !!process.env.RESEND_API_KEY && process.env.RESEND_API_KEY.startsWith('re_');
    }
  }
];

async function runTests() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║                    MCP HEALTH DIAGNOSTICS                    ║');
  console.log(`║                     ${new Date().toISOString().replace('T', ' ').substring(0, 19)}                      ║`);
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  let passed = 0;
  const details = [];

  for (const test of tests) {
    try {
      if (test.type === 'cli') {
        execSync(test.cmd, { stdio: 'pipe' });
        console.log(`✅ ${test.name.toUpperCase()}: PASS`);
        passed++;
        details.push({ name: test.name, status: 'WORKING', details: 'CLI verification successful' });
      } else if (test.type === 'http') {
        const res = await fetch(test.url);
        if (res.ok) {
          console.log(`✅ ${test.name.toUpperCase()}: PASS (HTTP ${res.status})`);
          passed++;
          details.push({ name: test.name, status: 'WORKING', details: `HTTP Endpoint responsive (${res.status})` });
        } else {
          throw new Error(`HTTP Error ${res.status}: ${await res.text()}`);
        }
      } else if (test.type === 'api' || test.type === 'env') {
        const ok = await test.test();
        if (ok) {
          console.log(`✅ ${test.name.toUpperCase()}: PASS`);
          passed++;
          details.push({ name: test.name, status: 'WORKING', details: 'Programmatic validation passed' });
        } else {
          throw new Error('Validation returned falsy');
        }
      }
    } catch (err) {
      console.log(`❌ ${test.name.toUpperCase()}: FAIL - ${err.message}`);
      details.push({ name: test.name, status: 'FAILING', details: err.message });
    }
  }

  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  console.log(`📊 OVERALL: ${passed}/${tests.length} MCP domains functioning\n`);
  
  console.log('✅ WORKING:');
  details.filter(d => d.status === 'WORKING').forEach(d => console.log(`- ${d.name}: ${d.details}`));

  const failing = details.filter(d => d.status === 'FAILING');
  if (failing.length > 0) {
    console.log('\n❌ FAILING:');
    failing.forEach(d => console.log(`- ${d.name}: ${d.details}`));
  } else {
    console.log('\n🎉 ALL DIAGNOSTICS PASSED');
  }
}

runTests();
