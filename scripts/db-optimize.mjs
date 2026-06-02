import fs from "node:fs"
import path from "node:path"
import net from "node:net"
import { fileURLToPath } from "node:url"

// Define paths
const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..")
const dbPath = path.join(root, "payload.sqlite")

console.log("╔══════════════════════════════════════════════════════════════╗")
console.log("║  🗄️  Database Optimization Utility                          ║")
console.log("╚══════════════════════════════════════════════════════════════╝")

// Check if dev server is running on port 3000
function checkPort3000() {
  return new Promise((resolve) => {
    const socket = new net.Socket()
    socket.setTimeout(1000)
    
    socket.on("connect", () => {
      socket.destroy()
      resolve(true) // Port is in use (dev server running)
    })
    
    socket.on("error", () => {
      resolve(false) // Port is free
    })
    
    socket.on("timeout", () => {
      socket.destroy()
      resolve(false) // Timeout, port is likely free
    })
    
    socket.connect(3000, "127.0.0.1")
  })
}

async function run() {
  const isDevRunning = await checkPort3000()
  
  if (isDevRunning) {
    console.log("⚠️  WARNING: Development server appears to be running on port 3000.")
    console.log("   SQLite database may be locked or busy. Aborting optimization for safety.")
    console.log("   Please stop the dev server (Ctrl+C) first, then run optimization.")
    process.exit(1)
  }

  if (!fs.existsSync(dbPath)) {
    console.log(`❌ ERROR: Database file not found at ${dbPath}`)
    process.exit(1)
  }

  try {
    // Import better-sqlite3 dynamically
    const Database = (await import("better-sqlite3")).default
    
    const sizeBefore = fs.statSync(dbPath).size
    const sizeBeforeKb = (sizeBefore / 1024).toFixed(1)
    
    console.log(`📂 Database: ${dbPath}`)
    console.log(`📊 Size Before: ${sizeBeforeKb} KB`)
    console.log("🧹 Optimizing (PRAGMA optimize + VACUUM)...")
    
    const db = new Database(dbPath)
    
    // Execute optimize and vacuum
    db.pragma("optimize")
    db.exec("VACUUM")
    db.close()
    
    const sizeAfter = fs.statSync(dbPath).size
    const sizeAfterKb = (sizeAfter / 1024).toFixed(1)
    const bytesSaved = sizeBefore - sizeAfter
    const percentSaved = sizeBefore > 0 ? ((bytesSaved / sizeBefore) * 100).toFixed(1) : "0"
    
    console.log("✅ Optimization Complete!")
    console.log(`📊 Size After:  ${sizeAfterKb} KB`)
    if (bytesSaved > 0) {
      console.log(`✨ Saved:       ${(bytesSaved / 1024).toFixed(1)} KB (${percentSaved}%)`)
    } else if (bytesSaved === 0) {
      console.log("✨ Already fully optimized!")
    } else {
      console.log(`ℹ️ Size adjusted by: ${(bytesSaved / 1024).toFixed(1)} KB (VACUUM aligned pages)`)
    }
    console.log("━━━━━━━━━━━━━━━━════════════════════════════════════════════════")
  } catch (error) {
    console.error("❌ Optimization failed:", error.message)
    process.exit(1)
  }
}

run()
