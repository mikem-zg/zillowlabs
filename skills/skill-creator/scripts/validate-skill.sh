#!/usr/bin/env bash
# Validate an Agent Skill against the official spec
# Usage: bash .agents/skills/skill-creator/scripts/validate-skill.sh <skill-name|all>

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SKILLS_DIR=".agents/skills"
MAX_LINES=500
MAX_NAME_LEN=64
MAX_DESC_LEN=1024

VALID_FIELDS="name description license compatibility metadata allowed-tools"
INVALID_FIELDS="parameters argument-hint version tags category author"

usage() {
    echo "Usage: $0 <skill-name|all>"
    echo ""
    echo "Validate a skill against the Agent Skills specification."
    echo ""
    echo "Examples:"
    echo "  $0 pdf-processing       # Validate one skill"
    echo "  $0 all                  # Validate all skills"
    exit 1
}

extract_frontmatter() {
    local file="$1"
    sed -n '2,/^---$/p' "$file" | head -n -1
}

validate_skill() {
    local skill_name="$1"
    local skill_dir="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_dir/SKILL.md"
    local errors=0
    local warnings=0

    echo -e "${BLUE}--- $skill_name ---${NC}"

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}  FAIL: SKILL.md not found at $skill_file${NC}"
        return 1
    fi

    local first_line
    first_line=$(head -1 "$skill_file")
    if [[ "$first_line" != "---" ]]; then
        echo -e "${RED}  FAIL: Missing YAML frontmatter (file must start with ---)${NC}"
        return 1
    fi

    local frontmatter
    frontmatter=$(extract_frontmatter "$skill_file")

    local fm_name
    fm_name=$(echo "$frontmatter" | grep -E "^name:" | head -1 | sed 's/^name:[[:space:]]*//')
    if [[ -z "$fm_name" ]]; then
        echo -e "${RED}  FAIL: Missing required 'name' field${NC}"
        errors=$((errors + 1))
    else
        if [[ ${#fm_name} -gt $MAX_NAME_LEN ]]; then
            echo -e "${RED}  FAIL: Name exceeds $MAX_NAME_LEN chars (got ${#fm_name})${NC}"
            errors=$((errors + 1))
        fi

        if [[ ! "$fm_name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
            echo -e "${RED}  FAIL: Name must be lowercase letters, numbers, hyphens only (got '$fm_name')${NC}"
            errors=$((errors + 1))
        fi

        if [[ "$fm_name" =~ -- ]]; then
            echo -e "${RED}  FAIL: Name contains consecutive hyphens${NC}"
            errors=$((errors + 1))
        fi

        if [[ "$fm_name" != "$skill_name" ]]; then
            echo -e "${RED}  FAIL: Name '$fm_name' does not match directory '$skill_name'${NC}"
            errors=$((errors + 1))
        fi

        if [[ "$fm_name" =~ (anthropic|claude) ]]; then
            echo -e "${RED}  FAIL: Name contains reserved word (anthropic/claude)${NC}"
            errors=$((errors + 1))
        fi

        echo -e "${GREEN}  OK: name = $fm_name${NC}"
    fi

    local fm_desc
    fm_desc=$(echo "$frontmatter" | grep -E "^description:" | head -1 | sed 's/^description:[[:space:]]*//')
    if [[ -z "$fm_desc" ]]; then
        echo -e "${RED}  FAIL: Missing required 'description' field${NC}"
        errors=$((errors + 1))
    else
        if [[ ${#fm_desc} -gt $MAX_DESC_LEN ]]; then
            echo -e "${RED}  FAIL: Description exceeds $MAX_DESC_LEN chars (got ${#fm_desc})${NC}"
            errors=$((errors + 1))
        fi

        if echo "$fm_desc" | grep -qiE "^(I |You |We |My )"; then
            echo -e "${YELLOW}  WARN: Description should be third person (avoid I/You/We/My)${NC}"
            warnings=$((warnings + 1))
        fi

        if ! echo "$fm_desc" | grep -qi "use when\|use for\|use to\|triggers when"; then
            echo -e "${YELLOW}  WARN: Description should include trigger conditions (e.g., 'Use when...')${NC}"
            warnings=$((warnings + 1))
        fi

        local desc_preview="${fm_desc:0:80}"
        echo -e "${GREEN}  OK: description = ${desc_preview}...${NC}"
    fi

    for field in $INVALID_FIELDS; do
        if echo "$frontmatter" | grep -qE "^${field}:"; then
            echo -e "${RED}  FAIL: Invalid field '${field}' (not in Agent Skills spec)${NC}"
            errors=$((errors + 1))
        fi
    done

    local all_fields
    all_fields=$(echo "$frontmatter" | grep -oE "^[a-z][a-z-]*:" | sed 's/://' || true)
    for field in $all_fields; do
        local is_valid=false
        for vf in $VALID_FIELDS; do
            if [[ "$field" == "$vf" ]]; then
                is_valid=true
                break
            fi
        done
        if [[ "$is_valid" == "false" ]]; then
            echo -e "${RED}  FAIL: Unknown field '$field' in frontmatter${NC}"
            errors=$((errors + 1))
        fi
    done

    local line_count
    line_count=$(wc -l < "$skill_file")
    if [[ $line_count -gt $MAX_LINES ]]; then
        echo -e "${YELLOW}  WARN: SKILL.md is $line_count lines (recommended max: $MAX_LINES)${NC}"
        warnings=$((warnings + 1))
    else
        echo -e "${GREEN}  OK: $line_count lines${NC}"
    fi

    if [[ -d "$skill_dir/references" ]]; then
        local ref_count
        ref_count=$(find "$skill_dir/references" -type f -name "*.md" | wc -l)
        echo -e "${GREEN}  OK: $ref_count reference file(s)${NC}"
    fi

    if [[ -d "$skill_dir/scripts" ]]; then
        local script_count
        script_count=$(find "$skill_dir/scripts" -type f | wc -l)
        echo -e "${GREEN}  OK: $script_count script(s)${NC}"
    fi

    for bad_file in README.md CHANGELOG.md INSTALLATION_GUIDE.md; do
        if [[ -f "$skill_dir/$bad_file" ]]; then
            echo -e "${YELLOW}  WARN: Found $bad_file (not needed in skills)${NC}"
            warnings=$((warnings + 1))
        fi
    done

    if [[ $errors -gt 0 ]]; then
        echo -e "${RED}  RESULT: $errors error(s), $warnings warning(s)${NC}"
    elif [[ $warnings -gt 0 ]]; then
        echo -e "${GREEN}  RESULT: PASS with $warnings warning(s)${NC}"
    else
        echo -e "${GREEN}  RESULT: PASS${NC}"
    fi

    echo ""
    return $errors
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
    fi

    local target="$1"
    local total_errors=0
    local total_pass=0
    local total_fail=0

    if [[ "$target" == "all" ]]; then
        echo -e "${BLUE}Validating all skills in $SKILLS_DIR${NC}"
        echo ""

        if [[ ! -d "$SKILLS_DIR" ]]; then
            echo -e "${RED}Skills directory not found: $SKILLS_DIR${NC}"
            exit 1
        fi

        for skill_dir in "$SKILLS_DIR"/*/; do
            if [[ -d "$skill_dir" ]]; then
                local sname
                sname=$(basename "$skill_dir")
                if validate_skill "$sname"; then
                    total_pass=$((total_pass + 1))
                else
                    total_fail=$((total_fail + 1))
                fi
            fi
        done

        echo -e "${BLUE}=== Summary ===${NC}"
        echo -e "${GREEN}  Pass: $total_pass${NC}"
        if [[ $total_fail -gt 0 ]]; then
            echo -e "${RED}  Fail: $total_fail${NC}"
        fi
        exit $total_fail
    else
        validate_skill "$target"
        exit $?
    fi
}

main "$@"
