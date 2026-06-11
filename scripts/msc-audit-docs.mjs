import fs from "node:fs"
import path from "node:path"
import { execSync } from "node:child_process"
import { fileURLToPath } from "node:url"

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..")
const docsDir = path.join(root, ".cursor", "docs")

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
