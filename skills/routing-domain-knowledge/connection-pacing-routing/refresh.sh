#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="${SCRIPT_DIR}/SKILL.md"
SOURCE_URL="https://gitlab.zgtools.net/zillow/conductors/services/connection-pacing/-/blob/main/CLAUDE.md"

cat <<'INSTRUCTIONS'
================================================================================
  connection-pacing-routing skill refresh
================================================================================

This skill's content is sourced from the connection-pacing repo's CLAUDE.md via
Glean MCP, which is only available inside the Replit agent sandbox.

To refresh, ask the Replit agent to run the refresh.js script in this directory:

    node .agents/skills/connection-pacing-routing/refresh.js

Or simply ask the agent:

    "Refresh the connection-pacing-routing skill from the source repo"

The agent will:
  1. Fetch the latest CLAUDE.md via mcpGlean_readDocument
  2. Re-format with proper markdown structure
  3. Overwrite SKILL.md with updated content and today's date
================================================================================
INSTRUCTIONS

echo ""
echo "NOTE: Running refresh.js outside the Replit agent sandbox will fail"
echo "because mcpGlean_readDocument is only available as a pre-registered"
echo "callback in the agent's code_execution environment."
echo ""
echo "Run refresh.js from the Replit agent code_execution sandbox for automated refresh."
