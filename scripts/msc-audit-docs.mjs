import fs from "node:fs"
import path from "node:path"
import crypto from "node:crypto"
import { execSync } from "node:child_process"
import { fileURLToPath } from "node:url"

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..")
const docsDir = path.join(root, ".cursor", "docs")
const promptsDir = path.join(root, ".cursor", "prompts")
const customScriptzDir = path.join(root, ".cursor", "custom-scriptz")

function collectMarkdownFiles(dir, acc = []) {
  if (!fs.existsSync(dir)) return acc
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    if (ent.name.startsWith("_")) continue
    const p = path.join(dir, ent.name)
    if (ent.isDirectory()) collectMarkdownFiles(p, acc)
    else if (ent.name.endsWith(".md") || ent.name.endsWith(".mdc")) acc.push(p)
  }
  return acc
}

console.log("╔══════════════════════════════════════════════════════════════╗")
console.log("║  📚 Documentation Integrity & Sync Auditor                   ║")
console.log("╚══════════════════════════════════════════════════════════════╝")

// Load package.json version
const pkg = JSON.parse(fs.readFileSync(path.join(root, "package.json"), "utf8"))
const currentVersion = pkg.version
const currentBranch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();

// List of files to scan
const targetFiles = [
  path.join(root, "README.md"),
  path.join(root, "TRUTH.md"),
  path.join(root, "CHANGELOG.md"),
]

if (fs.existsSync(docsDir)) {
  const files = fs.readdirSync(docsDir)
  for (const f of files) {
    if (f.endsWith(".md")) {
      targetFiles.push(path.join(docsDir, f))
    }
  }
}

for (const p of collectMarkdownFiles(promptsDir)) {
  targetFiles.push(p)
}

for (const p of collectMarkdownFiles(customScriptzDir)) {
  targetFiles.push(p)
}

/** Key portable pairs — live repo → custom-scriptz copy (hash drift = run msc:portable:sync). */
const PORTABLE_DRIFT_PAIRS = [
  ["scripts/start-session-stack.ps1", ".cursor/custom-scriptz/hermes-system/scripts/start-session-stack.ps1"],
  ["scripts/stop-session-stack.ps1", ".cursor/custom-scriptz/hermes-system/scripts/stop-session-stack.ps1"],
  ["scripts/start-kanban-stack.ps1", ".cursor/custom-scriptz/hermes-system/scripts/start-kanban-stack.ps1"],
  ["scripts/stop-kanban-stack.ps1", ".cursor/custom-scriptz/hermes-system/scripts/stop-kanban-stack.ps1"],
  ["scripts/msc-litellm-stop.mjs", ".cursor/custom-scriptz/google-api-proxy/scripts/msc-litellm-stop.mjs"],
  [".cursor/docs/Hermes-Cheat-Sheet.md", ".cursor/custom-scriptz/hermes-system/Hermes-Cheat-Sheet.md"],
  [".cursor/docs/KANBAN-STACK-GUIDE.md", ".cursor/custom-scriptz/hermes-system/KANBAN-STACK-GUIDE.md"],
]

function fileSha256(filePath) {
  if (!fs.existsSync(filePath)) return null
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex")
}

let totalErrors = 0
let totalWarnings = 0

// Helper to check for broken relative markdown links
function checkMarkdownLinks(filePath, content) {
  const fileDir = path.dirname(filePath)
  const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g
  let match
  const issues = []

  while ((match = linkRegex.exec(content)) !== null) {
    const linkUrl = match[2].trim()

    // We only care about relative local file links (ignore web URLs, emails, anchors)
    if (
      !linkUrl.startsWith("http://") &&
      !linkUrl.startsWith("https://") &&
      !linkUrl.startsWith("mailto:") &&
      !linkUrl.startsWith("#")
    ) {
      // Strip any hash anchors inside local links (e.g. ./docs.md#section -> ./docs.md)
      const cleanPath = linkUrl.split("#")[0]
      if (!cleanPath) continue

      const absoluteCleanPath = path.resolve(fileDir, cleanPath)
      
      if (!fs.existsSync(absoluteCleanPath)) {
        issues.push(`Broken link to: "${linkUrl}"`)
      }
    }
  }
  return issues
}

console.log(`📡 Scanning ${targetFiles.length} files for path and version drift...`)

for (const filePath of targetFiles) {
  if (!fs.existsSync(filePath)) continue

  const relativeName = path.relative(root, filePath)
  const isRecallOrChangelogOrCheck = 
    relativeName.endsWith("ReCall.md") || 
    relativeName.endsWith("CHANGELOG.md") || 
    relativeName.endsWith("Restore-Points.md") ||
    relativeName.endsWith("project-log.md") ||
    relativeName.endsWith("Checkpoint.md")

  const content = fs.readFileSync(filePath, "utf8")
  const fileIssues = []
  const fileWarnings = []

  // Rule 1: Check for legacy project name references (msc-new)
  if (content.includes("msc-new") && !isRecallOrChangelogOrCheck && !relativeName.endsWith("ISSUES-RESOLVED.md")) {
    fileIssues.push("Contains legacy project name 'msc-new' (should be 'MyStudioChannel')")
  }

  // Rule 2: Check for hardcoded old absolute drive paths
  if (/D:\\Cursor_Projectz\\MSC_Clean/i.test(content) || /D:\\Cursor_Projectz\\msc-new/i.test(content)) {
    fileIssues.push("Contains hardcoded legacy absolute drive path")
  }

  // Rule 3: Check for outdated active branch references
  // (Exclude archived entries in ReCall.md and CHANGELOG.md which intentionally document past branches)

  if (!isRecallOrChangelogOrCheck) {
    if (content.includes("MSC-Website-v4") && !content.includes("frozen")) {
      fileWarnings.push(`Refers to 'MSC-Website-v4' (historical — active branch is ${currentBranch})`)
    }
    if (content.includes("MSC-Website-v5") && !content.includes("frozen at") && !content.includes("frozen backup")) {
      fileWarnings.push(`Refers to 'MSC-Website-v5' (should likely be upgraded to '${currentBranch}')`)
    }
    if (content.includes("MSC-Website-v6") && !content.includes("frozen")) {
      fileWarnings.push(`Refers to 'MSC-Website-v6' (historical — active branch is ${currentBranch} unless frozen restore context)`)
    }
    if (content.includes("MSC-Website-v7") && !content.includes("frozen")) {
      fileWarnings.push(`Refers to 'MSC-Website-v7' (historical — active branch is ${currentBranch} unless frozen restore context)`)
    }
    if (content.includes("v4.0.0") && !content.includes("frozen at v4.0.0")) {
      fileWarnings.push(`Refers to 'v4.0.0' (historical — current version is v${currentVersion})`)
    }
    if (content.includes("v5.0.0") && !content.includes("frozen at v5.0.0")) {
      fileWarnings.push(`Refers to 'v5.0.0' (should likely be upgraded to 'v${currentVersion}')`)
    }
    if (content.includes("v6.0.0") && !content.includes("frozen") && !content.includes("v1.0.0")) {
      fileWarnings.push(`Refers to 'v6.0.0' (should likely be upgraded to 'v${currentVersion}' unless historical release context)`)
    }
    if (content.includes("v7.0.0") && !content.includes("frozen") && !content.includes("historical")) {
      fileWarnings.push(`Refers to 'v7.0.0' (should likely be upgraded to 'v${currentVersion}' unless historical release context)`)
    }
  }

  // Rule 4: Audit relative markdown links
  const linkIssues = checkMarkdownLinks(filePath, content)
  for (const linkIssue of linkIssues) {
    fileIssues.push(linkIssue)
  }

  // Rule 5: Start Project should reference unified session stack (not legacy-only google-api)
  const isStartProjectGuide =
    relativeName.endsWith("Start-Project.md") ||
    (relativeName.includes("Hermes-Cheat-Sheet") && !relativeName.includes("custom-scriptz"))
  if (
    isStartProjectGuide &&
    content.includes("msc:google-api:start-session") &&
    !content.includes("msc:session:start")
  ) {
    fileWarnings.push("Start Project docs still use msc:google-api:start-session only — prefer msc:session:start (full stack)")
  }

  // Rule 6: End Project / session stop should include Kanban in unified stop
  if (
    (relativeName.endsWith("Jedi-List.md") || relativeName.endsWith("TRUTH.md")) &&
    content.includes("msc:session:stop") &&
    content.includes("Kanban stack ports") &&
    content.includes("stopped separately")
  ) {
    fileWarnings.push("msc:session:stop now includes Kanban — remove 'stopped separately' wording")
  }

  // Report issues for this file
  if (fileIssues.length > 0 || fileWarnings.length > 0) {
    console.log(`\n📄 File: ${relativeName}`)
    for (const issue of fileIssues) {
      console.log(`   ❌ ERROR: ${issue}`)
      totalErrors++
    }
    for (const warn of fileWarnings) {
      console.log(`   ⚠️  WARNING: ${warn}`)
      totalWarnings++
    }
  }
}

console.log("\n🔌 Portable module drift (live → custom-scriptz)…")
let portableDrift = 0
for (const [liveRel, portableRel] of PORTABLE_DRIFT_PAIRS) {
  const livePath = path.join(root, liveRel)
  const portablePath = path.join(root, portableRel)
  const liveHash = fileSha256(livePath)
  const portableHash = fileSha256(portablePath)
  if (!liveHash) {
    console.log(`   ⚠️  SKIP missing live: ${liveRel}`)
    continue
  }
  if (!portableHash) {
    console.log(`   ❌ MISSING portable: ${portableRel}`)
    totalErrors++
    portableDrift++
    continue
  }
  if (liveHash !== portableHash) {
    console.log(`   ⚠️  DIFFERS: ${portableRel} (run npm run msc:portable:sync)`)
    totalWarnings++
    portableDrift++
  }
}
if (portableDrift === 0) {
  console.log("   ✅ All checked portable files match live repo")
}

console.log("\n━━━━━━━━━━━━━━━━════════════════════════════════════════════════")
if (totalErrors === 0 && totalWarnings === 0) {
  console.log(`✅ PERFECT SYNC: All docs verified. Version: v${currentVersion} | Branch: ${currentBranch}`)
} else {
  console.log(`📊 Audit Complete: Found ${totalErrors} Error(s) and ${totalWarnings} Warning(s).`)
  if (totalErrors > 0) {
    console.log("❌ Please fix documentation errors before shipping.")
    process.exit(1)
  } else {
    console.log("✅ Ready! Only warnings found.")
  }
}
console.log("━━━━━━━━━━━━━━━━════════════════════════════════════════════════")
