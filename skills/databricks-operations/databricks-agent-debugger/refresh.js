#!/usr/bin/env node

const { execSync } = require("child_process");
const path = require("path");

const SCRIPT_DIR = __dirname;
const REFRESH_SH = path.join(SCRIPT_DIR, "refresh.sh");

console.log("Delegating to refresh.sh for Databricks API download...");
try {
  execSync(`bash "${REFRESH_SH}"`, { stdio: "inherit" });
} catch (err) {
  console.error("Refresh failed:", err.message);
  process.exit(1);
}
