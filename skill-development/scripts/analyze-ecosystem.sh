#!/bin/bash
# analyze-ecosystem.sh - Comprehensive skill ecosystem analysis

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

SKILLS_DIR=".claude/skills"
MAX_LINES=500

usage() {
    echo "Usage: $0 [skill-name|ecosystem]"
    echo ""
    echo "Analyze skill ecosystem for optimization planning."
    echo ""
    echo "Options:"
    echo "  skill-name    Analyze specific skill in detail"
    echo "  ecosystem     Analyze entire ecosystem (default)"
    echo ""
    echo "Examples:"
    echo "  $0 confluence-management"
    echo "  $0 ecosystem"
    exit 1
}

analyze_single_skill() {
    local skill_name="$1"
    local skill_path="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_path/SKILL.md"

    echo -e "${BLUE}=== Detailed Analysis: $skill_name ===${NC}"

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}❌ SKILL.md not found: $skill_file${NC}"
        return 1
    fi

    # Basic metrics
    local line_count=$(wc -l < "$skill_file")
    local word_count=$(wc -w < "$skill_file")
    local char_count=$(wc -c < "$skill_file")

    echo -e "${CYAN}📊 Basic Metrics:${NC}"
    echo -e "   Lines: $line_count"
    echo -e "   Words: $word_count"
    echo -e "   Characters: $char_count"

    # Size assessment
    if [[ $line_count -gt $MAX_LINES ]]; then
        local overage=$((line_count - MAX_LINES))
        echo -e "${RED}   Size Status: OVERSIZED (+$overage lines)${NC}"
    else
        echo -e "${GREEN}   Size Status: COMPLIANT${NC}"
    fi

    # Section analysis
    echo -e "${CYAN}📋 Section Analysis:${NC}"
    local sections=(
        "## Overview"
        "## Usage"
        "## Core Workflow"
        "## Quick Reference"
        "## Advanced Patterns"
        "## Integration Points"
    )

    for section in "${sections[@]}"; do
        if grep -q "^$section" "$skill_file"; then
            local section_lines=$(awk "/^$section/,/^## /{print}" "$skill_file" | wc -l)
            section_lines=$((section_lines - 1))
            echo -e "   ✅ $section: $section_lines lines"
        else
            echo -e "   ❌ $section: MISSING"
        fi
    done

    # Content complexity analysis
    echo -e "${CYAN}🔍 Content Complexity:${NC}"
    local code_blocks=$(grep -c '```' "$skill_file" || echo 0)
    local code_lines=$(awk '/```/,/```/' "$skill_file" | wc -l || echo 0)
    local tables=$(grep -c '|.*|.*|' "$skill_file" || echo 0)
    local links=$(grep -co '\[.*\](.*' "$skill_file" || echo 0)

    echo -e "   Code blocks: $code_blocks"
    echo -e "   Code lines: $code_lines"
    echo -e "   Tables: $tables"
    echo -e "   Links: $links"

    # Progressive disclosure assessment
    echo -e "${CYAN}📁 Progressive Disclosure Assessment:${NC}"
    if [[ -d "$skill_path" ]]; then
        local supporting_files=$(find "$skill_path" -name "*.md" | grep -v SKILL.md | wc -l)
        local directories=$(find "$skill_path" -type d | grep -v "^$skill_path$" | wc -l)

        echo -e "   Supporting files: $supporting_files"
        echo -e "   Subdirectories: $directories"

        if [[ $supporting_files -gt 0 ]]; then
            echo -e "${GREEN}   Progressive Disclosure: IMPLEMENTED${NC}"
        else
            echo -e "${RED}   Progressive Disclosure: NOT IMPLEMENTED${NC}"
        fi
    fi

    # Optimization recommendations
    echo -e "${CYAN}💡 Optimization Recommendations:${NC}"

    if [[ $line_count -gt 1000 ]]; then
        echo -e "${RED}   🔥 CRITICAL: Requires major restructuring${NC}"
        echo -e "      - Extract 60-70% of content to supporting files"
        echo -e "      - Implement comprehensive progressive disclosure"
        echo -e "      - Priority: IMMEDIATE"
    elif [[ $line_count -gt 800 ]]; then
        echo -e "${YELLOW}   ⚠️  HIGH: Requires significant optimization${NC}"
        echo -e "      - Extract 40-50% of content to supporting files"
        echo -e "      - Implement progressive disclosure architecture"
        echo -e "      - Priority: HIGH"
    elif [[ $line_count -gt 600 ]]; then
        echo -e "${YELLOW}   📝 MEDIUM: Requires moderate optimization${NC}"
        echo -e "      - Extract 20-30% of content to supporting files"
        echo -e "      - Add progressive disclosure structure"
        echo -e "      - Priority: MEDIUM"
    elif [[ $line_count -gt $MAX_LINES ]]; then
        echo -e "${CYAN}   📏 LOW: Requires minor optimization${NC}"
        echo -e "      - Extract 10-15% of content to supporting files"
        echo -e "      - Minor progressive disclosure improvements"
        echo -e "      - Priority: LOW"
    else
        echo -e "${GREEN}   ✅ COMPLIANT: No optimization required${NC}"
    fi

    echo ""
}

analyze_ecosystem() {
    echo -e "${BLUE}🌍 Skill Ecosystem Analysis${NC}"
    echo -e "${BLUE}=============================${NC}"

    if [[ ! -d "$SKILLS_DIR" ]]; then
        echo -e "${RED}❌ Skills directory not found: $SKILLS_DIR${NC}"
        exit 1
    fi

    # Initialize counters
    local total_skills=0
    local compliant_skills=0
    local critical_skills=0
    local high_priority_skills=0
    local medium_priority_skills=0
    local low_priority_skills=0

    declare -a critical_list=()
    declare -a high_priority_list=()
    declare -a medium_priority_list=()
    declare -a low_priority_list=()
    declare -a compliant_list=()

    echo -e "${CYAN}📊 Scanning all skills...${NC}"
    echo ""

    # Analyze each skill
    for skill_dir in "$SKILLS_DIR"/*; do
        if [[ -d "$skill_dir" ]]; then
            skill_name=$(basename "$skill_dir")
            skill_file="$skill_dir/SKILL.md"

            if [[ -f "$skill_file" ]]; then
                total_skills=$((total_skills + 1))
                line_count=$(wc -l < "$skill_file")

                # Classify by priority
                if [[ $line_count -gt 1000 ]]; then
                    critical_skills=$((critical_skills + 1))
                    critical_list+=("$skill_name:$line_count")
                    echo -e "${RED}🔥 CRITICAL: $skill_name ($line_count lines)${NC}"
                elif [[ $line_count -gt 800 ]]; then
                    high_priority_skills=$((high_priority_skills + 1))
                    high_priority_list+=("$skill_name:$line_count")
                    echo -e "${YELLOW}⚠️  HIGH: $skill_name ($line_count lines)${NC}"
                elif [[ $line_count -gt 600 ]]; then
                    medium_priority_skills=$((medium_priority_skills + 1))
                    medium_priority_list+=("$skill_name:$line_count")
                    echo -e "${CYAN}📝 MEDIUM: $skill_name ($line_count lines)${NC}"
                elif [[ $line_count -gt $MAX_LINES ]]; then
                    low_priority_skills=$((low_priority_skills + 1))
                    low_priority_list+=("$skill_name:$line_count")
                    echo -e "${BLUE}📏 LOW: $skill_name ($line_count lines)${NC}"
                else
                    compliant_skills=$((compliant_skills + 1))
                    compliant_list+=("$skill_name:$line_count")
                    echo -e "${GREEN}✅ COMPLIANT: $skill_name ($line_count lines)${NC}"
                fi
            fi
        fi
    done

    echo ""
    echo -e "${BLUE}📈 Ecosystem Summary${NC}"
    echo -e "${BLUE}===================${NC}"

    # Summary statistics
    echo -e "${CYAN}Total Skills: $total_skills${NC}"
    echo -e "${GREEN}Compliant: $compliant_skills ($(( compliant_skills * 100 / total_skills ))%)${NC}"
    echo -e "${RED}Non-Compliant: $(( total_skills - compliant_skills )) ($(( (total_skills - compliant_skills) * 100 / total_skills ))%)${NC}"
    echo ""

    # Priority breakdown
    echo -e "${CYAN}Priority Classification:${NC}"
    echo -e "${RED}🔥 Critical (>1000 lines): $critical_skills skills${NC}"
    echo -e "${YELLOW}⚠️  High (800-999 lines): $high_priority_skills skills${NC}"
    echo -e "${CYAN}📝 Medium (600-799 lines): $medium_priority_skills skills${NC}"
    echo -e "${BLUE}📏 Low (500-599 lines): $low_priority_skills skills${NC}"
    echo ""

    # Detailed priority lists
    if [[ ${#critical_list[@]} -gt 0 ]]; then
        echo -e "${RED}🔥 Critical Priority Skills:${NC}"
        for item in "${critical_list[@]}"; do
            skill=$(echo "$item" | cut -d: -f1)
            lines=$(echo "$item" | cut -d: -f2)
            overage=$((lines - MAX_LINES))
            echo -e "   • $skill: $lines lines (+$overage over limit)"
        done
        echo ""
    fi

    if [[ ${#high_priority_list[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  High Priority Skills:${NC}"
        for item in "${high_priority_list[@]}"; do
            skill=$(echo "$item" | cut -d: -f1)
            lines=$(echo "$item" | cut -d: -f2)
            overage=$((lines - MAX_LINES))
            echo -e "   • $skill: $lines lines (+$overage over limit)"
        done
        echo ""
    fi

    # Optimization effort estimation
    echo -e "${CYAN}📋 Optimization Effort Estimation:${NC}"
    local total_effort=0

    if [[ $critical_skills -gt 0 ]]; then
        local critical_effort=$((critical_skills * 3))  # 3 days per critical skill
        total_effort=$((total_effort + critical_effort))
        echo -e "   Critical Skills: $critical_skills × 3 days = $critical_effort days"
    fi

    if [[ $high_priority_skills -gt 0 ]]; then
        local high_effort=$((high_priority_skills * 2))  # 2 days per high priority skill
        total_effort=$((total_effort + high_effort))
        echo -e "   High Priority Skills: $high_priority_skills × 2 days = $high_effort days"
    fi

    if [[ $medium_priority_skills -gt 0 ]]; then
        local medium_effort=$((medium_priority_skills * 1))  # 1 day per medium priority skill
        total_effort=$((total_effort + medium_effort))
        echo -e "   Medium Priority Skills: $medium_priority_skills × 1 day = $medium_effort days"
    fi

    if [[ $low_priority_skills -gt 0 ]]; then
        local low_effort=$(( (low_priority_skills + 1) / 2 ))  # 0.5 days per low priority skill (batched)
        total_effort=$((total_effort + low_effort))
        echo -e "   Low Priority Skills: $low_priority_skills × 0.5 days = $low_effort days"
    fi

    echo -e "${MAGENTA}   Total Estimated Effort: $total_effort days${NC}"
    echo -e "${MAGENTA}   Recommended Timeline: $(( (total_effort + 6) / 7 )) weeks${NC}"
    echo ""

    # Progressive disclosure implementation status
    echo -e "${CYAN}📁 Progressive Disclosure Analysis:${NC}"
    local pd_implemented=0
    local pd_partial=0
    local pd_not_implemented=0

    for skill_dir in "$SKILLS_DIR"/*; do
        if [[ -d "$skill_dir" ]]; then
            skill_name=$(basename "$skill_dir")
            supporting_files=$(find "$skill_dir" -name "*.md" | grep -v SKILL.md | wc -l)
            directories=$(find "$skill_dir" -type d | grep -v "^$skill_dir$" | wc -l)

            if [[ $directories -gt 2 && $supporting_files -gt 3 ]]; then
                pd_implemented=$((pd_implemented + 1))
            elif [[ $directories -gt 0 || $supporting_files -gt 0 ]]; then
                pd_partial=$((pd_partial + 1))
            else
                pd_not_implemented=$((pd_not_implemented + 1))
            fi
        fi
    done

    echo -e "   ✅ Full Implementation: $pd_implemented skills ($(( pd_implemented * 100 / total_skills ))%)"
    echo -e "   ⚠️  Partial Implementation: $pd_partial skills ($(( pd_partial * 100 / total_skills ))%)"
    echo -e "   ❌ Not Implemented: $pd_not_implemented skills ($(( pd_not_implemented * 100 / total_skills ))%)"
    echo ""

    # Recommendations
    echo -e "${CYAN}💡 Ecosystem Optimization Recommendations:${NC}"
    echo -e "   1. Start with critical priority skills (immediate impact)"
    echo -e "   2. Develop automation for batch processing medium/low priority skills"
    echo -e "   3. Implement comprehensive progressive disclosure across ecosystem"
    echo -e "   4. Create monitoring and validation automation"
    echo -e "   5. Establish ongoing compliance maintenance procedures"
    echo ""

    # Next steps
    echo -e "${CYAN}🚀 Recommended Next Steps:${NC}"
    echo -e "   1. Run detailed analysis on critical skills:"
    for item in "${critical_list[@]}"; do
        skill=$(echo "$item" | cut -d: -f1)
        echo -e "      ./analyze-ecosystem.sh $skill"
    done
    echo -e "   2. Begin Phase 1: Infrastructure preparation (automation scripts)"
    echo -e "   3. Start Phase 2: Critical priority skill optimization"
    echo -e "   4. Implement progressive disclosure templates and tooling"

    return $(( total_skills - compliant_skills ))  # Return number of non-compliant skills
}

main() {
    local target="${1:-ecosystem}"

    case "$target" in
        "ecosystem"|"all"|"")
            analyze_ecosystem
            ;;
        *)
            if [[ -d "$SKILLS_DIR/$target" ]]; then
                analyze_single_skill "$target"
            else
                echo -e "${RED}❌ Skill not found: $target${NC}"
                echo -e "${CYAN}Available skills:${NC}"
                ls "$SKILLS_DIR" | head -10
                exit 1
            fi
            ;;
    esac
}

# Run main function
main "$@"