#!/bin/bash
# validate-structure.sh - Validate skill progressive disclosure structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_LINES=500
SKILLS_DIR=".claude/skills"

usage() {
    echo "Usage: $0 [skill-name|all-skills]"
    echo ""
    echo "Validate skill structure and progressive disclosure compliance."
    echo ""
    echo "Options:"
    echo "  skill-name    Validate specific skill"
    echo "  all-skills    Validate all skills in directory"
    echo ""
    echo "Examples:"
    echo "  $0 email-processing"
    echo "  $0 all-skills"
    exit 1
}

validate_skill() {
    local skill_name="$1"
    local skill_path="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_path/SKILL.md"

    echo -e "${BLUE}=== Validating Skill: $skill_name ===${NC}"

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}❌ SKILL.md not found: $skill_file${NC}"
        return 1
    fi

    local errors=0
    local warnings=0

    # Check file size
    local line_count=$(wc -l < "$skill_file")
    echo -e "${BLUE}📏 File size: $line_count lines${NC}"

    if [[ $line_count -gt $MAX_LINES ]]; then
        echo -e "${RED}❌ File exceeds maximum length: $line_count > $MAX_LINES lines${NC}"
        errors=$((errors + 1))
    elif [[ $line_count -gt $((MAX_LINES - 50)) ]]; then
        echo -e "${YELLOW}⚠️  File approaching maximum length: $line_count lines${NC}"
        warnings=$((warnings + 1))
    else
        echo -e "${GREEN}✅ File size within limits${NC}"
    fi

    # Check required sections
    echo -e "${BLUE}📋 Checking required sections...${NC}"

    local required_sections=(
        "## Overview"
        "## Usage"
        "## Core Workflow"
        "## Quick Reference"
        "## Advanced Patterns"
        "## Integration Points"
    )

    for section in "${required_sections[@]}"; do
        if grep -q "^$section" "$skill_file"; then
            echo -e "${GREEN}✅ Found: $section${NC}"
        else
            echo -e "${RED}❌ Missing: $section${NC}"
            errors=$((errors + 1))
        fi
    done

    # Check YAML frontmatter
    echo -e "${BLUE}📝 Checking YAML frontmatter...${NC}"

    if grep -q "^---$" "$skill_file" && sed -n '1,/^---$/p' "$skill_file" | grep -q "name:"; then
        echo -e "${GREEN}✅ YAML frontmatter present${NC}"

        # Check required fields
        local frontmatter=$(sed -n '1,/^---$/p' "$skill_file")

        if echo "$frontmatter" | grep -q "^name:"; then
            echo -e "${GREEN}✅ 'name' field present${NC}"
        else
            echo -e "${RED}❌ Missing 'name' field${NC}"
            errors=$((errors + 1))
        fi

        if echo "$frontmatter" | grep -q "^description:"; then
            echo -e "${GREEN}✅ 'description' field present${NC}"
        else
            echo -e "${RED}❌ Missing 'description' field${NC}"
            errors=$((errors + 1))
        fi
    else
        echo -e "${RED}❌ YAML frontmatter missing or malformed${NC}"
        errors=$((errors + 1))
    fi

    # Check section lengths
    echo -e "${BLUE}📐 Analyzing section lengths...${NC}"

    check_section_length() {
        local section_name="$1"
        local min_lines="$2"
        local max_lines="$3"

        local section_lines=$(awk "/^## $section_name/,/^## /{print}" "$skill_file" | wc -l)
        section_lines=$((section_lines - 1))  # Subtract 1 for the header line

        if [[ $section_lines -eq 0 ]]; then
            return  # Section doesn't exist, already caught above
        fi

        echo -e "${BLUE}   $section_name: $section_lines lines${NC}"

        if [[ $section_lines -lt $min_lines ]]; then
            echo -e "${YELLOW}⚠️  $section_name section might be too short (< $min_lines lines)${NC}"
            warnings=$((warnings + 1))
        elif [[ $section_lines -gt $max_lines ]]; then
            echo -e "${YELLOW}⚠️  $section_name section might be too long (> $max_lines lines)${NC}"
            warnings=$((warnings + 1))
        fi
    }

    check_section_length "Core Workflow" 30 120
    check_section_length "Quick Reference" 50 250
    check_section_length "Advanced Patterns" 100 450
    check_section_length "Integration Points" 50 250

    # Check for common anti-patterns
    echo -e "${BLUE}🔍 Checking for anti-patterns...${NC}"

    # Check for Windows-style paths
    if grep -q '\\\\' "$skill_file"; then
        echo -e "${RED}❌ Found Windows-style paths (use forward slashes)${NC}"
        errors=$((errors + 1))
    else
        echo -e "${GREEN}✅ No Windows-style paths found${NC}"
    fi

    # Check for time-sensitive information
    if grep -qi 'before.*202[0-9]\|after.*202[0-9]\|until.*202[0-9]' "$skill_file"; then
        echo -e "${YELLOW}⚠️  Found potential time-sensitive information${NC}"
        warnings=$((warnings + 1))
    else
        echo -e "${GREEN}✅ No time-sensitive information detected${NC}"
    fi

    # Summary
    echo -e "${BLUE}📊 Validation Summary for $skill_name:${NC}"
    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✅ Structure validation passed${NC}"
        if [[ $warnings -gt 0 ]]; then
            echo -e "${YELLOW}⚠️  $warnings warnings found${NC}"
        fi
    else
        echo -e "${RED}❌ $errors errors found${NC}"
        if [[ $warnings -gt 0 ]]; then
            echo -e "${YELLOW}⚠️  $warnings warnings found${NC}"
        fi
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
    local total_skills=0

    if [[ "$target" == "all-skills" ]]; then
        echo -e "${BLUE}🔍 Validating all skills in $SKILLS_DIR${NC}"
        echo ""

        if [[ ! -d "$SKILLS_DIR" ]]; then
            echo -e "${RED}❌ Skills directory not found: $SKILLS_DIR${NC}"
            exit 1
        fi

        for skill_dir in "$SKILLS_DIR"/*; do
            if [[ -d "$skill_dir" ]]; then
                skill_name=$(basename "$skill_dir")
                if validate_skill "$skill_name"; then
                    echo -e "${GREEN}✅ $skill_name: PASSED${NC}"
                else
                    echo -e "${RED}❌ $skill_name: FAILED${NC}"
                    total_errors=$((total_errors + 1))
                fi
                total_skills=$((total_skills + 1))
                echo ""
            fi
        done

        echo -e "${BLUE}🏁 Final Summary:${NC}"
        echo -e "${BLUE}   Total skills validated: $total_skills${NC}"
        if [[ $total_errors -eq 0 ]]; then
            echo -e "${GREEN}   All skills passed validation${NC}"
        else
            echo -e "${RED}   Skills with errors: $total_errors${NC}"
        fi

    else
        # Validate single skill
        validate_skill "$target"
        total_errors=$?
    fi

    exit $total_errors
}

# Run main function
main "$@"