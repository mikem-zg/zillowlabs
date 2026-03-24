#!/usr/bin/env bash
set -euo pipefail

#
# Syncs the progress dashboard HTML to a hosted location.
# Supports: Replit (via GitHub push), GitHub Pages, or local copy.
#
# Configure the variables below, then run after any dashboard update:
#   ./sync-dashboard.sh
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/output/progress-report.html"

# ── CONFIGURATION ─────────────────────────────────────────────────────────────
# Choose ONE of the options below:

# Option A: Replit or GitHub Pages (push to a git repo)
DEPLOY_REPO_DIR="${SCRIPT_DIR}/replit-dashboard"  # Local git repo dir synced to GitHub
DEPLOY_FILE="index.html"                           # Filename inside the deploy repo

# Option B: Confluence (set page ID and token, leave DEPLOY_REPO_DIR empty)
CONFLUENCE_BASE_URL=""   # e.g., https://zillowgroup.atlassian.net/wiki
CONFLUENCE_PAGE_ID=""    # Numeric page ID from the page URL
CONFLUENCE_TOKEN=""      # Bearer token (or set via env: CONFLUENCE_TOKEN)

# ── END CONFIGURATION ─────────────────────────────────────────────────────────

TIMESTAMP=$(TZ='America/Los_Angeles' date '+%B %-d, %Y at %-I:%M %p %Z')

# Update "Last updated" timestamp in the HTML
update_timestamp() {
    local src="$1" dst="$2"
    sed "s|Last updated [^<]*|Last updated ${TIMESTAMP}|g" "$src" > "$dst"
    echo "Timestamp set: ${TIMESTAMP}"
}

# ── Option A: Push to Git (Replit / GitHub Pages) ────────────────────────────
if [[ -n "$DEPLOY_REPO_DIR" && -d "$DEPLOY_REPO_DIR" ]]; then
    DST="${DEPLOY_REPO_DIR}/${DEPLOY_FILE}"
    update_timestamp "$SRC" "$DST"
    echo "Dashboard → ${DST}"

    cd "$DEPLOY_REPO_DIR"
    if git diff --quiet "$DEPLOY_FILE" 2>/dev/null; then
        echo "No changes to push."
        exit 0
    fi

    git add "$DEPLOY_FILE"
    git commit -m "Update dashboard — ${TIMESTAMP}"
    git push origin main

    echo "Pushed to GitHub. Deploy target will update shortly."
    exit 0
fi

# ── Option B: Confluence ──────────────────────────────────────────────────────
if [[ -n "$CONFLUENCE_PAGE_ID" ]]; then
    CONFLUENCE_TOKEN="${CONFLUENCE_TOKEN:-}"
    if [[ -z "$CONFLUENCE_TOKEN" ]]; then
        echo "Error: CONFLUENCE_TOKEN not set." >&2
        exit 1
    fi

    # Get current version number
    CURRENT_VERSION=$(curl -sf \
        -H "Authorization: Bearer ${CONFLUENCE_TOKEN}" \
        "${CONFLUENCE_BASE_URL}/rest/api/content/${CONFLUENCE_PAGE_ID}?expand=version" \
        | python3 -c "import json,sys; print(json.load(sys.stdin)['version']['number'])")
    NEXT_VERSION=$((CURRENT_VERSION + 1))

    # Read and escape HTML content
    HTML_CONTENT=$(python3 -c "
import sys, json
with open('${SRC}') as f:
    print(json.dumps(f.read()))
" | tr -d '"')  # Will be re-added in JSON below

    python3 - <<PYEOF
import json, urllib.request, urllib.error

url = '${CONFLUENCE_BASE_URL}/rest/api/content/${CONFLUENCE_PAGE_ID}'
with open('${SRC}') as f:
    html = f.read()

payload = json.dumps({
    'version': {'number': ${NEXT_VERSION}},
    'title': 'Migration Progress Dashboard',
    'type': 'page',
    'body': {'storage': {'value': html, 'representation': 'storage'}}
}).encode()

req = urllib.request.Request(url, data=payload, method='PUT')
req.add_header('Authorization', 'Bearer ${CONFLUENCE_TOKEN}')
req.add_header('Content-Type', 'application/json')

try:
    with urllib.request.urlopen(req) as r:
        print(f'Confluence updated (version {${NEXT_VERSION}}): {url}')
except urllib.error.HTTPError as e:
    print(f'Error: {e.code} {e.read().decode()}')
    exit(1)
PYEOF
    exit 0
fi

echo "No deploy target configured. Edit DEPLOY_REPO_DIR or CONFLUENCE_PAGE_ID in this script."
exit 1
