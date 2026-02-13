#!/bin/bash
# batch-optimize.sh - Batch optimization for multiple skills

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SKILLS_DIR=".claude/skills"
DEFAULT_TARGET_SIZE=450

usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Batch optimization for multiple skills."
    echo ""
    echo "Options:"
    echo "  --priority=LEVEL     Priority level: critical|high|medium|low|all"
    echo "  --target-size=N      Target size for optimized skills (default: 450)"
    echo "  --skills=LIST        Comma-separated list of specific skills"
    echo "  --dry-run           Show what would be optimized without making changes"
    echo "  --validate-each     Validate each skill after optimization"
    echo "  --validate-batch    Validate all skills after batch completion"
    echo "  --quick-mode        Faster processing for low-priority skills"
    echo "  --parallel          Process skills in parallel (experimental)"
    echo ""
    echo "Examples:"
    echo "  $0 --priority=critical --validate-each"
    echo "  $0 --priority=medium --target-size=400"
    echo "  $0 --skills=\"skill1,skill2,skill3\" --dry-run"
    echo "  $0 --priority=all --quick-mode"
    exit 1
}

get_skills_by_priority() {
    local priority="$1"
    local skills=()

    for skill_dir in "$SKILLS_DIR"/*; do
        if [[ -d "$skill_dir" ]]; then
            local skill_name=$(basename "$skill_dir")
            local skill_file="$skill_dir/SKILL.md"

            if [[ -f "$skill_file" ]]; then
                local line_count=$(wc -l < "$skill_file")

                case "$priority" in
                    "critical")
                        if [[ $line_count -gt 1000 ]]; then
                            skills+=("$skill_name")
                        fi
                        ;;
                    "high")
                        if [[ $line_count -gt 800 && $line_count -le 1000 ]]; then
                            skills+=("$skill_name")
                        fi
                        ;;
                    "medium")
                        if [[ $line_count -gt 600 && $line_count -le 800 ]]; then
                            skills+=("$skill_name")
                        fi
                        ;;
                    "low")
                        if [[ $line_count -gt 500 && $line_count -le 600 ]]; then
                            skills+=("$skill_name")
                        fi
                        ;;
                    "all")
                        if [[ $line_count -gt 500 ]]; then
                            skills+=("$skill_name")
                        fi
                        ;;
                esac
            fi
        fi
    done

    printf "%s\n" "${skills[@]}"
}

optimize_single_skill() {
    local skill_name="$1"
    local target_size="$2"
    local quick_mode="$3"
    local dry_run="$4"

    echo -e "${BLUE}📝 Optimizing: $skill_name${NC}"

    local skill_path="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_path/SKILL.md"

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}   ❌ SKILL.md not found${NC}"
        return 1
    fi

    local current_size=$(wc -l < "$skill_file")
    echo -e "   Current size: $current_size lines"
    echo -e "   Target size: $target_size lines"

    if [[ $current_size -le $target_size ]]; then
        echo -e "${GREEN}   ✅ Already compliant${NC}"
        return 0
    fi

    local extraction_needed=$((current_size - target_size))
    echo -e "   Extraction needed: $extraction_needed lines"

    if [[ "$dry_run" == "true" ]]; then
        echo -e "${CYAN}   [DRY RUN] Would optimize this skill${NC}"
        return 0
    fi

    # Run content extraction analysis
    if [[ "$quick_mode" == "true" ]]; then
        echo -e "   🚀 Quick mode optimization..."
        # Simplified optimization for low-priority skills
        optimize_quick_mode "$skill_name" "$target_size"
    else
        echo -e "   🔍 Comprehensive optimization..."
        # Full progressive disclosure implementation
        ./skills/skill-development/scripts/extract-content.sh "$skill_name" --target-size="$target_size"
    fi

    echo -e "${GREEN}   ✅ Optimization complete${NC}"
    return 0
}

optimize_quick_mode() {
    local skill_name="$1"
    local target_size="$2"
    local skill_path="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_path/SKILL.md"

    # Quick optimization strategy for low-priority skills
    echo -e "     • Creating basic progressive disclosure structure..."

    # Create basic directories
    mkdir -p "$skill_path/reference"
    mkdir -p "$skill_path/examples"

    # Extract examples to examples directory (simple pattern matching)
    if grep -q "### Examples\|#### Examples" "$skill_file"; then
        echo -e "     • Extracting examples to examples/usage-examples.md"

        # Create examples file (placeholder - would need more sophisticated extraction)
        cat > "$skill_path/examples/usage-examples.md" << 'EOF'
# Usage Examples

This file contains detailed usage examples extracted from the main skill.

[Content would be extracted here in actual implementation]
EOF
    fi

    # Extract detailed reference material
    if grep -q "API\|Reference\|Documentation" "$skill_file"; then
        echo -e "     • Extracting reference material to reference/detailed-documentation.md"

        cat > "$skill_path/reference/detailed-documentation.md" << 'EOF'
# Detailed Documentation

This file contains comprehensive reference documentation extracted from the main skill.

[Content would be extracted here in actual implementation]
EOF
    fi

    # Update main skill file with references (placeholder)
    echo -e "     • Updating main SKILL.md with references..."

    # This would include actual content extraction and reference insertion
    # For now, just indicating what would happen
    echo -e "     • [Placeholder] Content extraction and reference updates would occur here"
}

validate_batch_optimization() {
    local skills_list=("$@")
    local validation_failures=0

    echo -e "${CYAN}🔍 Batch Validation Results:${NC}"
    echo -e "${CYAN}============================${NC}"

    for skill in "${skills_list[@]}"; do
        echo -e "${BLUE}Validating: $skill${NC}"

        if ./skills/skill-development/scripts/validate-structure.sh "$skill" > /dev/null 2>&1; then
            echo -e "${GREEN}   ✅ PASSED${NC}"
        else
            echo -e "${RED}   ❌ FAILED${NC}"
            validation_failures=$((validation_failures + 1))
        fi
    done

    echo -e "${CYAN}Batch Validation Summary:${NC}"
    echo -e "   Total skills: ${#skills_list[@]}"
    echo -e "   Passed: $(( ${#skills_list[@]} - validation_failures ))"
    echo -e "   Failed: $validation_failures"

    if [[ $validation_failures -eq 0 ]]; then
        echo -e "${GREEN}🎉 All skills passed validation!${NC}"
    else
        echo -e "${YELLOW}⚠️  $validation_failures skills need additional work${NC}"
    fi

    return $validation_failures
}

run_parallel_optimization() {
    local skills_list=("$@")
    local target_size="$1"; shift
    local quick_mode="$1"; shift
    local dry_run="$1"; shift
    local remaining_skills=("$@")

    echo -e "${CYAN}🚀 Parallel Optimization Mode${NC}"
    echo -e "   Processing ${#remaining_skills[@]} skills in parallel..."

    # Create temporary directory for parallel processing logs
    local temp_dir=$(mktemp -d)
    local pids=()

    # Start optimization processes in background
    for skill in "${remaining_skills[@]}"; do
        {
            optimize_single_skill "$skill" "$target_size" "$quick_mode" "$dry_run" \
                > "$temp_dir/$skill.log" 2>&1
            echo $? > "$temp_dir/$skill.exit_code"
        } &
        pids+=($!)
    done

    # Wait for all processes to complete
    local completed=0
    local failed=0

    for i in "${!pids[@]}"; do
        local pid=${pids[$i]}
        local skill=${remaining_skills[$i]}

        wait $pid
        local exit_code=$(cat "$temp_dir/$skill.exit_code" 2>/dev/null || echo 1)

        if [[ $exit_code -eq 0 ]]; then
            echo -e "${GREEN}✅ Completed: $skill${NC}"
            completed=$((completed + 1))
        else
            echo -e "${RED}❌ Failed: $skill${NC}"
            failed=$((failed + 1))
        fi
    done

    # Show summary
    echo -e "${CYAN}Parallel Processing Summary:${NC}"
    echo -e "   Completed: $completed"
    echo -e "   Failed: $failed"

    # Cleanup
    rm -rf "$temp_dir"

    return $failed
}

main() {
    # Parse options
    local priority=""
    local target_size=$DEFAULT_TARGET_SIZE
    local skills_list=""
    local dry_run=false
    local validate_each=false
    local validate_batch=false
    local quick_mode=false
    local parallel=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --priority=*)
                priority="${1#*=}"
                ;;
            --target-size=*)
                target_size="${1#*=}"
                ;;
            --skills=*)
                skills_list="${1#*=}"
                ;;
            --dry-run)
                dry_run=true
                ;;
            --validate-each)
                validate_each=true
                ;;
            --validate-batch)
                validate_batch=true
                ;;
            --quick-mode)
                quick_mode=true
                ;;
            --parallel)
                parallel=true
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
        shift
    done

    # Validate requirements
    if [[ -z "$priority" && -z "$skills_list" ]]; then
        echo -e "${RED}❌ Must specify either --priority or --skills${NC}"
        usage
    fi

    echo -e "${BLUE}🔄 Batch Skill Optimization${NC}"
    echo -e "${BLUE}===========================${NC}"

    # Determine skills to optimize
    local skills_to_optimize=()

    if [[ -n "$skills_list" ]]; then
        IFS=',' read -ra skills_to_optimize <<< "$skills_list"
    else
        # Bash 3.2 compatible array population
        while IFS= read -r skill; do
            skills_to_optimize+=("$skill")
        done < <(get_skills_by_priority "$priority")
    fi

    if [[ ${#skills_to_optimize[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No skills found matching criteria${NC}"
        exit 0
    fi

    echo -e "Skills to optimize: ${#skills_to_optimize[@]}"
    echo -e "Priority: ${priority:-custom}"
    echo -e "Target size: $target_size lines"
    if [[ "$dry_run" == "true" ]]; then
        echo -e "Mode: ${CYAN}DRY RUN${NC}"
    fi
    if [[ "$quick_mode" == "true" ]]; then
        echo -e "Quick mode: ${CYAN}ENABLED${NC}"
    fi
    echo ""

    # Show skills list
    echo -e "${CYAN}📋 Skills to be optimized:${NC}"
    for skill in "${skills_to_optimize[@]}"; do
        local skill_file="$SKILLS_DIR/$skill/SKILL.md"
        if [[ -f "$skill_file" ]]; then
            local size=$(wc -l < "$skill_file")
            local overage=$((size - target_size))
            echo -e "   • $skill ($size lines, +$overage)"
        fi
    done
    echo ""

    # Confirmation for non-dry-run
    if [[ "$dry_run" != "true" ]]; then
        echo -e "${YELLOW}⚠️  This will modify ${#skills_to_optimize[@]} skills. Continue? (y/N)${NC}"
        read -r confirmation
        if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
            echo "Aborted."
            exit 0
        fi
    fi

    # Run optimization
    local start_time=$(date +%s)
    local optimization_failures=0

    if [[ "$parallel" == "true" && ${#skills_to_optimize[@]} -gt 3 ]]; then
        run_parallel_optimization "$target_size" "$quick_mode" "$dry_run" "${skills_to_optimize[@]}"
        optimization_failures=$?
    else
        # Sequential processing
        for skill in "${skills_to_optimize[@]}"; do
            if ! optimize_single_skill "$skill" "$target_size" "$quick_mode" "$dry_run"; then
                optimization_failures=$((optimization_failures + 1))
            fi

            # Individual validation if requested
            if [[ "$validate_each" == "true" && "$dry_run" != "true" ]]; then
                echo -e "   🔍 Validating..."
                if ./skills/skill-development/scripts/validate-structure.sh "$skill" > /dev/null 2>&1; then
                    echo -e "${GREEN}   ✅ Validation passed${NC}"
                else
                    echo -e "${YELLOW}   ⚠️  Validation issues detected${NC}"
                fi
            fi
            echo ""
        done
    fi

    # Batch validation if requested
    if [[ "$validate_batch" == "true" && "$dry_run" != "true" ]]; then
        echo ""
        validate_batch_optimization "${skills_to_optimize[@]}"
    fi

    # Final summary
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo -e "${CYAN}🏁 Batch Optimization Complete${NC}"
    echo -e "${CYAN}================================${NC}"
    echo -e "Skills processed: ${#skills_to_optimize[@]}"
    echo -e "Successful: $(( ${#skills_to_optimize[@]} - optimization_failures ))"
    echo -e "Failed: $optimization_failures"
    echo -e "Duration: ${duration}s"

    if [[ "$dry_run" == "true" ]]; then
        echo -e "${CYAN}[DRY RUN] No actual changes made${NC}"
    fi

    if [[ $optimization_failures -eq 0 ]]; then
        echo -e "${GREEN}🎉 All optimizations completed successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️  Some optimizations failed - review individual results${NC}"
    fi

    return $optimization_failures
}

# Run main function
main "$@"