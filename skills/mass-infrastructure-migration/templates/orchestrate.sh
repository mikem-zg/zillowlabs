#!/usr/bin/env bash
set -euo pipefail

#
# Generic parallel migration orchestrator.
#
# Reads a repo map CSV, clones each repo, creates a migration branch,
# and runs Claude Code with a migration skill in each repo in parallel.
#
# Usage:
#   ./orchestrate.sh data/repo_map.csv
#   ./orchestrate.sh data/repo_map.csv --jobs 5
#   ./orchestrate.sh data/repo_map.csv --dry-run
#   ./orchestrate.sh data/repo_map.csv --resume
#
# ── CONFIGURATION ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${SCRIPT_DIR}/workspaces"
LOG_DIR="${SCRIPT_DIR}/logs"
SKILL_PATH="${SCRIPT_DIR}/skill/SKILL.md"  # Path to the per-repo migration skill
BRANCH_NAME="migration/your-ticket-id"     # Git branch to create in each repo
GIT_HOST="gitlab.example.com"             # Your Git host (for normalizing short repo paths)
MAX_JOBS=3
DRY_RUN=false
RESUME=false
REPO_MAP=""

# ── CSV COLUMN NAMES ───────────────────────────────────────────────────────────
# Set these to match the actual column headers in your repo map CSV.
# They do not need to match any standard — just whatever you named them.

COL_REPO="gitRepo"           # Column containing the Git clone URL or short path
COL_SERVICE="service"        # Column identifying the service/workload (used for logging)
COL_ACCOUNT="account"        # Column identifying the cloud account or environment (used for logging)
                             # Set COL_ACCOUNT="" if your CSV doesn't have an account column.

# ── END CONFIGURATION ─────────────────────────────────────────────────────────

# AWS credential profile (leave empty to skip aws-vault)
AWS_VAULT_PROFILE="${AWS_VAULT_PROFILE:-}"
# Claude model to use
CLAUDE_MODEL="${CLAUDE_MODEL:-sonnet}"

export AWS_VAULT_BACKEND="${AWS_VAULT_BACKEND:-file}"
export AWS_VAULT_FILE_PASSPHRASE="${AWS_VAULT_FILE_PASSPHRASE:-}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --jobs|-j)    MAX_JOBS="$2"; shift 2 ;;
        --dry-run)    DRY_RUN=true; shift ;;
        --resume)     RESUME=true; shift ;;
        --branch)     BRANCH_NAME="$2"; shift 2 ;;
        --skill)      SKILL_PATH="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: $0 <repo_map.csv> [--jobs N] [--dry-run] [--resume] [--branch NAME] [--skill PATH]"
            exit 0 ;;
        -*)  echo "Unknown option: $1"; exit 1 ;;
        *)   REPO_MAP="$1"; shift ;;
    esac
done

[[ -z "$REPO_MAP" ]] && { echo "Error: repo map CSV is required."; exit 1; }
[[ -f "$SKILL_PATH" ]] || { echo "Error: SKILL.md not found at $SKILL_PATH"; exit 1; }
[[ -f "$REPO_MAP" ]]  || { echo "Error: $REPO_MAP not found"; exit 1; }

mkdir -p "$WORK_DIR" "$LOG_DIR"

# The prompt sent to Claude Code in each repo.
# Keep this short — the per-repo migration skill (SKILL.md) carries the detailed instructions.
MIGRATION_PROMPT="$(cat <<'EOF'
Follow the migration skill instructions exactly for this repository:
1. Search for all references to the old tool/pattern
2. Remove every reference found
3. Add the new tool/pattern configuration appropriate for this repo's workload type
4. Present the verification checklist when done

Commit all changes with a descriptive commit message prefixed with the ticket ID.
Then open a Merge Request against the default branch.
EOF
)"

normalize_clone_url() {
    local input="$1"
    if [[ "$input" == git@* ]]; then
        echo "$input"
    elif [[ "$input" == https://* ]]; then
        local path="${input#https://${GIT_HOST}/}"
        echo "git@${GIT_HOST}:${path%.git}.git"
    else
        # Treat as a short path: org/group/repo
        echo "git@${GIT_HOST}:${input%.git}.git"
    fi
}

run_claude() {
    local prompt="$1"
    local skill="$2"
    if [[ -n "$AWS_VAULT_PROFILE" ]]; then
        aws-vault exec "$AWS_VAULT_PROFILE" -- \
            claude -p \
                --model "$CLAUDE_MODEL" \
                --dangerously-skip-permissions \
                --append-system-prompt "$skill" \
                "$prompt"
    else
        claude -p \
            --model "$CLAUDE_MODEL" \
            --dangerously-skip-permissions \
            --append-system-prompt "$skill" \
            "$prompt"
    fi
}

process_repo() {
    local service="$1"
    local account="$2"
    local repo_input="$3"
    local clone_url
    clone_url="$(normalize_clone_url "$repo_input")"
    local repo_slug
    repo_slug="$(basename "${clone_url%.git}")"
    local work_path="${WORK_DIR}/${repo_slug}"
    local log_file="${LOG_DIR}/${repo_slug}.log"
    local status_file="${LOG_DIR}/${repo_slug}.status"

    if [[ "$RESUME" == "true" && -f "$status_file" ]]; then
        [[ "$(cat "$status_file")" == "success" ]] && { echo "[SKIP] ${repo_slug}"; return 0; }
    fi

    local label="${service}"
    [[ -n "$account" ]] && label+=" / ${account}"
    echo "[START] ${repo_slug} (${label})"

    {
        echo "=== ${label} ==="
        echo "Repo:    ${clone_url}"
        echo "Branch:  ${BRANCH_NAME}"
        echo "Started: $(date -Iseconds)"
        echo ""

        if [[ -d "$work_path" ]]; then
            echo "Workspace exists, updating..."
            cd "$work_path"
            git checkout main 2>/dev/null || git checkout master 2>/dev/null || true
            git pull --ff-only 2>/dev/null || true
        else
            echo "Cloning..."
            git clone "$clone_url" "$work_path"
            cd "$work_path"
        fi

        if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
            git checkout "$BRANCH_NAME"
        else
            git checkout -b "$BRANCH_NAME"
        fi

        echo ""
        echo "Running Claude Code..."
        local skill_content
        skill_content="$(cat "$SKILL_PATH")"
        run_claude "$MIGRATION_PROMPT" "$skill_content"

        echo ""
        echo "Finished: $(date -Iseconds)"
    } > "$log_file" 2>&1

    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        echo "success" > "$status_file"
        echo "[DONE]  ${repo_slug}"
    else
        echo "failed" > "$status_file"
        echo "[FAIL]  ${repo_slug} (exit ${exit_code}) — see ${log_file}"
    fi
    return $exit_code
}

# Parse repo map CSV (Python handles quoting/encoding robustly)
mapfile -t raw_entries < <(python3 - "$REPO_MAP" "$COL_REPO" "$COL_SERVICE" "$COL_ACCOUNT" <<'PYEOF'
import csv, sys
path, col_repo, col_svc, col_acct = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
seen = set()
with open(path, newline='', encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        repo = (row.get(col_repo) or '').strip()
        if not repo or repo in seen:
            continue
        seen.add(repo)
        svc  = (row.get(col_svc)  or 'unknown').strip() if col_svc  else 'unknown'
        acct = (row.get(col_acct) or '').strip()         if col_acct else ''
        print(f'{svc}|{acct}|{repo}')
PYEOF
)

[[ ${#raw_entries[@]} -eq 0 ]] && {
    echo "No repos found in ${REPO_MAP}."
    echo "Check that COL_REPO='${COL_REPO}' matches the column header in your CSV."
    exit 1
}

echo "============================================"
echo " Migration Orchestrator"
echo "============================================"
echo " Repo map:     ${REPO_MAP}"
echo " Repos:        ${#raw_entries[@]}"
echo " Parallel:     ${MAX_JOBS}"
echo " Branch:       ${BRANCH_NAME}"
echo " Skill:        ${SKILL_PATH}"
echo " Repo column:  ${COL_REPO}"
echo " Workspaces:   ${WORK_DIR}"
echo " Logs:         ${LOG_DIR}"
echo "============================================"
echo ""

if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would process:"
    for entry in "${raw_entries[@]}"; do
        IFS='|' read -r svc acct repo <<< "$entry"
        label="$svc"; [[ -n "$acct" ]] && label+=" / $acct"
        echo "  - ${repo}  (${label})"
    done
    exit 0
fi

succeeded=0; failed=0
pids=()

for entry in "${raw_entries[@]}"; do
    IFS='|' read -r svc acct repo <<< "$entry"
    while [[ $(jobs -rp | wc -l) -ge $MAX_JOBS ]]; do
        wait -n 2>/dev/null || true
    done
    process_repo "$svc" "$acct" "$repo" &
    pids+=($!)
done

for pid in "${pids[@]}"; do
    if wait "$pid"; then ((succeeded++)); else ((failed++)); fi
done

echo ""
echo "============================================"
echo " Results: ${succeeded} succeeded, ${failed} failed / ${#raw_entries[@]} total"
echo "============================================"

if [[ $failed -gt 0 ]]; then
    echo "Failed repos (re-run with --resume to retry):"
    for f in "${LOG_DIR}"/*.status; do
        [[ "$(cat "$f")" == "failed" ]] && echo "  - $(basename "$f" .status)"
    done
    exit 1
fi
