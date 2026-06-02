import fs from "node:fs"
import path from "node:path"
import { fileURLToPath } from "node:url"
import dotenv from "dotenv"
import { Client } from "ssh2"

// Load env variables
const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..")
dotenv.config({ path: path.join(root, ".env.local") })

const host = process.env.HOSTINGER_SSH_HOST || "82.180.174.36"
const port = parseInt(process.env.HOSTINGER_SSH_PORT || "65002", 10)
const username = process.env.HOSTINGER_SSH_USER || "u942711528"
const password = process.env.HOSTINGER_SSH_PASSWORD || "Dracula822!!"
const appRoot = process.env.HOSTINGER_APP_ROOT || "/home/u942711528/domains/mystudiochannel.com/nodejs"

// Detect log type from CLI arguments
const useConsoleLog = process.argv.includes("--console")
const logFile = useConsoleLog ? "console.log" : "stderr.log"
const remoteLogPath = `${appRoot}/${logFile}`

console.log("╔══════════════════════════════════════════════════════════════╗")
console.log(`║  🔌 SSH Live Log Streamer (${logFile})                       ║`)
console.log("╚══════════════════════════════════════════════════════════════╝")
console.log(`📡 Connecting to ${username}@${host}:${port}...`)

const conn = new Client()

conn.on("ready", () => {
  console.log("✅ SSH Connection established successfully!")
  console.log(`🪵  Streaming logs from: ${remoteLogPath}`)
  console.log("💡 Press Ctrl+C to exit log stream.\n")
  console.log("------------------- LOG STREAM START -------------------")

  // Execute tail -f command on remote server
  conn.exec(`tail -n 50 -f ${remoteLogPath}`, (err, stream) => {
    if (err) {
      console.error(`❌ SSH Execution Error: ${err.message}`)
      conn.end()
      process.exit(1)
    }

    stream.on("close", (code, signal) => {
      console.log(`\n-------------------- LOG STREAM END (Exit Code: ${code}) --------------------`)
      conn.end()
    })

    stream.on("data", (data) => {
      process.stdout.write(data)
    })

    stream.stderr.on("data", (data) => {
      process.stderr.write(`⚠️  [remote-stderr] ${data}`)
    })

    // Handle process interruption to close SSH cleanly
    process.on("SIGINT", () => {
      console.log("\n🔌 Closing SSH log stream stream. Goodbye!")
      stream.end()
      conn.end()
      process.exit(0)
    })
  })
})

conn.on("error", (err) => {
  console.error(`❌ SSH Connection Error: ${err.message}`)
  process.exit(1)
})

conn.connect({
  host,
  port,
  username,
  password,
  readyTimeout: 20000,
})
