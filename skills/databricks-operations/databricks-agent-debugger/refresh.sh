#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="${SCRIPT_DIR}/SKILL.md"
NOTEBOOK_PATH="/Users/bretttr@zillowgroup.com/Agent Debugger"
NOTEBOOK_ID="2186037508178725"
DATABRICKS_URL="https://zg-pa-lab.cloud.databricks.com/editor/notebooks/${NOTEBOOK_ID}?o=1721967766797624"

if [ -z "${DATABRICKS_HOST:-}" ] || [ -z "${DATABRICKS_TOKEN:-}" ]; then
  echo "ERROR: DATABRICKS_HOST and DATABRICKS_TOKEN environment variables must be set."
  exit 1
fi

HOST="${DATABRICKS_HOST%/}/"

ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${NOTEBOOK_PATH}'))")
API_URL="${HOST}api/2.0/workspace/export?path=${ENCODED_PATH}&format=SOURCE&direct_download=true"

echo "Fetching notebook: ${NOTEBOOK_PATH}"
echo "API URL: ${API_URL}"

TMPFILE=$(mktemp)
trap 'rm -f "${TMPFILE}"' EXIT

HTTP_CODE=$(curl -s -o "${TMPFILE}" -w "%{http_code}" \
  -H "Authorization: Bearer ${DATABRICKS_TOKEN}" \
  "${API_URL}")

if [ "${HTTP_CODE}" != "200" ]; then
  echo "ERROR: Databricks API returned HTTP ${HTTP_CODE}"
  cat "${TMPFILE}"
  exit 1
fi

CONTENT_LENGTH=$(wc -c < "${TMPFILE}")
if [ "${CONTENT_LENGTH}" -lt 100 ]; then
  echo "ERROR: Response too small (${CONTENT_LENGTH} bytes) — likely an error."
  cat "${TMPFILE}"
  exit 1
fi

TODAY=$(date +%Y-%m-%d)

{
cat <<EOF
---
name: databricks-agent-debugger
description: >-
  Brett Tracy's Agent Debugger Databricks notebook — a reusable diagnostic tool that
  profiles a single agent's 30-day routing history including ranking positions, FindPro
  call-down results, connection share, and competitor analysis. Use when investigating
  why a specific agent is or isn't receiving connections, debugging routing outcomes,
  or analyzing agent performance factors.
evolving: true
source: ${DATABRICKS_URL}
---

# Agent Debugger

> **Notebook ID:** ${NOTEBOOK_ID}
> **Databricks URL:** [Agent Debugger](${DATABRICKS_URL})
> **Workspace path:** ${NOTEBOOK_PATH}
> **Author:** Brett Tracy (bretttr@zillowgroup.com)
> **Last refreshed:** ${TODAY}
> **Refresh command:** \`bash .agents/skills/databricks-agent-debugger/refresh.sh\`

---

EOF
cat "${TMPFILE}"
} > "${SKILL_FILE}"

echo "SKILL.md updated successfully ($(wc -c < "${SKILL_FILE}") bytes)"
echo "Last refreshed: ${TODAY}"
