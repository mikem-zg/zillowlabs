#!/bin/bash
# extract-content.sh - Intelligent content extraction for progressive disclosure

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
    echo "Usage: $0 <skill-name> [options]"
    echo ""
    echo "Extract content for progressive disclosure implementation."
    echo ""
    echo "Options:"
    echo "  --target-size=N     Target size for main SKILL.md (default: 450)"
    echo "  --dry-run          Show what would be extracted without making changes"
    echo "  --aggressive       More aggressive content extraction"
    echo "  --preserve-core    Keep core workflow intact regardless of size"
    echo ""
    echo "Examples:"
    echo "  $0 confluence-management --target-size=400"
    echo "  $0 code-development --dry-run"
    echo "  $0 backend-test-development --aggressive"
    exit 1
}

analyze_extractable_content() {
    local skill_file="$1"
    local target_size="$2"
    local current_size=$(wc -l < "$skill_file")

    echo -e "${CYAN}📊 Content Analysis:${NC}"
    echo -e "   Current size: $current_size lines"
    echo -e "   Target size: $target_size lines"
    echo -e "   Extraction needed: $((current_size - target_size)) lines"
    echo ""

    # Analyze section sizes
    local sections=(
        "Overview"
        "Usage"
        "Core Workflow"
        "Quick Reference"
        "Advanced Patterns"
        "Integration Points"
    )

    for section in "${sections[@]}"; do
        local start_line=$(grep -n "^## $section" "$skill_file" | head -1 | cut -d: -f1)
        if [[ -n "$start_line" ]]; then
            local next_section_line=$(tail -n +$((start_line + 1)) "$skill_file" | grep -n "^## " | head -1 | cut -d: -f1)
            if [[ -n "$next_section_line" ]]; then
                local end_line=$((start_line + next_section_line - 1))
            else
                local end_line=$(wc -l < "$skill_file" | tr -d ' ')
            fi

            local size=$((end_line - start_line))
            echo -e "   $section: $size lines (lines $start_line-$end_line)"
        else
            echo -e "   $section: MISSING"
        fi
    done
    echo ""
}

suggest_extraction_strategy() {
    local skill_name="$1"
    local target_size="$2"
    local current_size="$3"
    local extraction_needed=$((current_size - target_size))

    echo -e "${CYAN}💡 Progressive Disclosure Strategy:${NC}"

    # Suggest directory structure
    echo -e "   Suggested structure:"
    echo -e "   $skill_name/"
    echo -e "   ├── SKILL.md ($target_size lines)"

    # Analyze content types for extraction suggestions
    local advanced_patterns_size=$(awk '/^## Advanced Patterns/,/^## / {lines++} END {print lines-1}' "$SKILLS_DIR/$skill_name/SKILL.md" 2>/dev/null || echo 0)
    local quick_ref_size=$(awk '/^## Quick Reference/,/^## / {lines++} END {print lines-1}' "$SKILLS_DIR/$skill_name/SKILL.md" 2>/dev/null || echo 0)
    local integration_points_size=$(awk '/^## Integration Points/,/^## / {lines++} END {print lines-1}' "$SKILLS_DIR/$skill_name/SKILL.md" 2>/dev/null || echo 0)

    if [[ $advanced_patterns_size -gt 100 ]]; then
        echo -e "   ├── advanced/"
        echo -e "   │   ├── complex-scenarios.md     # Complex workflow patterns"
        echo -e "   │   ├── optimization-guide.md    # Performance optimization"
        echo -e "   │   └── troubleshooting.md       # Advanced troubleshooting"
    fi

    if [[ $quick_ref_size -gt 150 ]]; then
        echo -e "   ├── reference/"
        echo -e "   │   ├── api-documentation.md     # Complete API reference"
        echo -e "   │   ├── commands.md              # Command reference"
        echo -e "   │   └── parameters.md            # Parameter documentation"
    fi

    if [[ $integration_points_size -gt 100 ]]; then
        echo -e "   ├── integration/"
        echo -e "   │   ├── workflow-patterns.md     # Multi-skill workflows"
        echo -e "   │   ├── handoff-protocols.md     # Integration protocols"
        echo -e "   │   └── coordination.md          # Cross-skill coordination"
    fi

    # Skill-specific suggestions based on name patterns
    case "$skill_name" in
        *"test"*|*"testing"*)
            echo -e "   ├── frameworks/"
            echo -e "   │   ├── unit-testing.md"
            echo -e "   │   ├── integration-testing.md"
            echo -e "   │   └── e2e-testing.md"
            echo -e "   └── examples/"
            echo -e "       ├── test-patterns.md"
            echo -e "       └── mock-strategies.md"
            ;;
        *"management"*|*"admin"*)
            echo -e "   ├── operations/"
            echo -e "   │   ├── create-operations.md"
            echo -e "   │   ├── update-operations.md"
            echo -e "   │   └── delete-operations.md"
            echo -e "   └── troubleshooting/"
            echo -e "       ├── common-issues.md"
            echo -e "       └── error-recovery.md"
            ;;
        *"development"*|*"coding"*)
            echo -e "   ├── workflows/"
            echo -e "   │   ├── feature-development.md"
            echo -e "   │   ├── bug-fixing.md"
            echo -e "   │   └── refactoring.md"
            echo -e "   └── quality/"
            echo -e "       ├── code-review.md"
            echo -e "       └── testing-standards.md"
            ;;
        *)
            echo -e "   ├── workflows/"
            echo -e "   │   └── detailed-processes.md"
            echo -e "   ├── examples/"
            echo -e "   │   └── usage-examples.md"
            echo -e "   └── reference/"
            echo -e "       └── detailed-documentation.md"
            ;;
    esac

    echo ""
}

identify_extractable_sections() {
    local skill_file="$1"
    local aggressive="$2"

    echo -e "${CYAN}🔍 Extractable Content Analysis:${NC}"

    # Look for large code blocks (potential extraction candidates)
    local code_blocks=$(awk '/```/,/```/ {if (++count > 10) print NR": " $0}' "$skill_file" | head -20)
    if [[ -n "$code_blocks" ]]; then
        echo -e "${YELLOW}   Large code blocks found (candidates for templates/)${NC}"
    fi

    # Look for long lists or tables (potential reference material)
    local long_tables=$(awk '/\|.*\|.*\|/ {count++} END {print count}' "$skill_file")
    if [[ $long_tables -gt 10 ]]; then
        echo -e "${YELLOW}   Extensive tables found ($long_tables rows) - candidate for reference/tables.md${NC}"
    fi

    # Look for example sections
    if grep -q "### Examples\|## Examples\|#### Examples" "$skill_file"; then
        echo -e "${YELLOW}   Examples sections found - candidates for examples/ directory${NC}"
    fi

    # Look for troubleshooting content
    if grep -qi "troubleshoot\|error\|fix\|problem" "$skill_file"; then
        echo -e "${YELLOW}   Troubleshooting content found - candidate for troubleshooting.md${NC}"
    fi

    # Look for API documentation patterns
    if grep -q "API\|endpoint\|parameter\|response" "$skill_file"; then
        echo -e "${YELLOW}   API documentation found - candidate for reference/api-documentation.md${NC}"
    fi

    # Identify repetitive patterns
    local repeated_patterns=$(grep -o "### [^#]*" "$skill_file" | sort | uniq -c | sort -nr | head -5)
    if [[ -n "$repeated_patterns" ]]; then
        echo -e "${YELLOW}   Repetitive section patterns detected - candidates for template extraction${NC}"
    fi

    echo ""
}

generate_extraction_plan() {
    local skill_name="$1"
    local skill_file="$2"
    local target_size="$3"
    local dry_run="$4"

    echo -e "${CYAN}📋 Extraction Plan Generation:${NC}"

    local current_size=$(wc -l < "$skill_file")
    local extraction_needed=$((current_size - target_size))

    # Priority extraction order
    echo -e "   Extraction Priority Order:"
    echo -e "   1. Examples and code samples → examples/"
    echo -e "   2. Detailed API documentation → reference/"
    echo -e "   3. Advanced troubleshooting → troubleshooting/"
    echo -e "   4. Complex workflow details → workflows/"
    echo -e "   5. Integration patterns → integration/"

    # Calculate extraction impact
    local examples_lines=$(grep -c "###.*[Ee]xample\|\`\`\`" "$skill_file" || echo 0)
    local api_lines=$(grep -c "API\|endpoint\|parameter" "$skill_file" || echo 0)
    local troubleshooting_lines=$(grep -c -i "troubleshoot\|error\|fix" "$skill_file" || echo 0)

    echo -e "   Estimated extraction impact:"
    echo -e "   • Examples: ~$((examples_lines * 3)) lines"
    echo -e "   • API docs: ~$((api_lines * 2)) lines"
    echo -e "   • Troubleshooting: ~$((troubleshooting_lines * 2)) lines"

    local total_extractable=$((examples_lines * 3 + api_lines * 2 + troubleshooting_lines * 2))
    echo -e "   Total extractable: ~$total_extractable lines"

    if [[ $total_extractable -ge $extraction_needed ]]; then
        echo -e "${GREEN}   ✅ Sufficient content identified for extraction${NC}"
    else
        echo -e "${YELLOW}   ⚠️  May need additional extraction strategies${NC}"
    fi

    if [[ "$dry_run" != "true" ]]; then
        echo -e "${BLUE}   Ready to generate extraction scripts...${NC}"
    else
        echo -e "${CYAN}   [DRY RUN] - No actual extraction performed${NC}"
    fi

    echo ""
}

create_extraction_scripts() {
    local skill_name="$1"
    local skill_path="$SKILLS_DIR/$skill_name"

    echo -e "${CYAN}🛠️  Creating Extraction Scripts:${NC}"

    # Create extraction script for this specific skill
    local extract_script="$skill_path/extract-progressive-disclosure.sh"

    cat > "$extract_script" << 'EOF'
#!/bin/bash
# Auto-generated progressive disclosure extraction script

set -e

SKILL_NAME="$(basename "$(pwd)")"
SKILL_FILE="SKILL.md"
BACKUP_FILE="SKILL.md.backup"

echo "Starting progressive disclosure extraction for $SKILL_NAME"

# Create backup
cp "$SKILL_FILE" "$BACKUP_FILE"
echo "✅ Backup created: $BACKUP_FILE"

# Create directory structure
mkdir -p {reference,examples,workflows,troubleshooting,integration}

# Extract examples (placeholder - customize based on skill content)
echo "📁 Extracting examples..."
# Add skill-specific extraction logic here

# Extract reference documentation
echo "📚 Extracting reference documentation..."
# Add reference extraction logic here

# Extract troubleshooting content
echo "🔧 Extracting troubleshooting content..."
# Add troubleshooting extraction logic here

# Update main SKILL.md with references
echo "🔗 Updating main SKILL.md with references..."
# Add reference update logic here

echo "✅ Progressive disclosure extraction complete"
echo "   Review extracted content and update references as needed"
EOF

    chmod +x "$extract_script"
    echo -e "   ✅ Created: $extract_script"

    # Create validation script
    local validate_script="$skill_path/validate-extraction.sh"

    cat > "$validate_script" << 'EOF'
#!/bin/bash
# Auto-generated extraction validation script

set -e

SKILL_FILE="SKILL.md"
TARGET_SIZE=450

echo "Validating progressive disclosure extraction..."

# Check file size
current_size=$(wc -l < "$SKILL_FILE")
echo "Current SKILL.md size: $current_size lines"

if [[ $current_size -le $TARGET_SIZE ]]; then
    echo "✅ Size target achieved"
else
    echo "⚠️  Still oversized by $((current_size - TARGET_SIZE)) lines"
fi

# Validate required sections
sections=("Overview" "Usage" "Core Workflow" "Quick Reference" "Advanced Patterns" "Integration Points")
for section in "${sections[@]}"; do
    if grep -q "^## $section" "$SKILL_FILE"; then
        echo "✅ Section present: $section"
    else
        echo "❌ Missing section: $section"
    fi
done

# Check for broken references
broken_refs=$(grep -o '\[.*\]([^)]*)' "$SKILL_FILE" | grep -v '^http' | wc -l)
if [[ $broken_refs -eq 0 ]]; then
    echo "✅ No broken references detected"
else
    echo "⚠️  Found $broken_refs potential broken references"
fi

echo "Validation complete"
EOF

    chmod +x "$validate_script"
    echo -e "   ✅ Created: $validate_script"

    echo ""
}

main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    local skill_name="$1"
    shift

    # Parse options
    local target_size=$DEFAULT_TARGET_SIZE
    local dry_run=false
    local aggressive=false
    local preserve_core=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --target-size=*)
                target_size="${1#*=}"
                ;;
            --dry-run)
                dry_run=true
                ;;
            --aggressive)
                aggressive=true
                ;;
            --preserve-core)
                preserve_core=true
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
        shift
    done

    # Validate skill exists
    local skill_path="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_path/SKILL.md"

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}❌ Skill not found: $skill_name${NC}"
        exit 1
    fi

    echo -e "${BLUE}🔍 Progressive Disclosure Content Extraction${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo -e "Skill: $skill_name"
    echo -e "Target size: $target_size lines"
    if [[ "$dry_run" == "true" ]]; then
        echo -e "Mode: ${CYAN}DRY RUN${NC}"
    fi
    echo ""

    # Perform analysis
    analyze_extractable_content "$skill_file" "$target_size"
    suggest_extraction_strategy "$skill_name" "$target_size" "$(wc -l < "$skill_file")"
    identify_extractable_sections "$skill_file" "$aggressive"
    generate_extraction_plan "$skill_name" "$skill_file" "$target_size" "$dry_run"

    # Create extraction scripts if not dry run
    if [[ "$dry_run" != "true" ]]; then
        create_extraction_scripts "$skill_name"

        echo -e "${GREEN}🚀 Next Steps:${NC}"
        echo -e "   1. Review the generated extraction plan above"
        echo -e "   2. Customize the extraction script: $skill_path/extract-progressive-disclosure.sh"
        echo -e "   3. Run the extraction: cd $skill_path && ./extract-progressive-disclosure.sh"
        echo -e "   4. Validate results: ./validate-extraction.sh"
        echo -e "   5. Test the optimized skill with real use cases"
    else
        echo -e "${CYAN}[DRY RUN] Complete - No changes made${NC}"
    fi
}

# Global variables for section analysis (bash 3.2 compatible)

# Run main function
main "$@"