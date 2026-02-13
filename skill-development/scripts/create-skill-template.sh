#!/bin/bash
# create-skill-template.sh - Create new skill from template

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SKILLS_DIR=".claude/skills"
TEMPLATES_DIR="$SKILLS_DIR/skill-development/templates"

usage() {
    echo "Usage: $0 <template-type> <skill-name> [description]"
    echo ""
    echo "Create a new skill from a template."
    echo ""
    echo "Template Types:"
    echo "  minimal     - Simple skill with basic instructions"
    echo "  workflow    - Multi-step process with checklists"
    echo "  knowledge   - Domain expertise with reference files"
    echo "  integration - External tool integration with scripts"
    echo ""
    echo "Examples:"
    echo "  $0 minimal file-processor \"Process and validate files\""
    echo "  $0 workflow deployment-pipeline \"Deploy applications safely\""
    echo ""
    exit 1
}

create_skill_from_template() {
    local template_type="$1"
    local skill_name="$2"
    local description="$3"

    # Validate skill name
    if [[ ! "$skill_name" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
        echo -e "${RED}❌ Invalid skill name. Use lowercase letters, numbers, and hyphens only.${NC}"
        echo -e "${RED}   Must start with a letter and cannot end with a hyphen.${NC}"
        exit 1
    fi

    # Check if skill already exists
    local skill_path="$SKILLS_DIR/$skill_name"
    if [[ -d "$skill_path" ]]; then
        echo -e "${RED}❌ Skill already exists: $skill_path${NC}"
        exit 1
    fi

    # Validate template type
    local template_file="$TEMPLATES_DIR/$template_type-skill.md"
    if [[ ! -f "$template_file" ]]; then
        echo -e "${RED}❌ Template not found: $template_type${NC}"
        echo -e "${YELLOW}Available templates:${NC}"
        for template in "$TEMPLATES_DIR"/*-skill.md; do
            if [[ -f "$template" ]]; then
                basename "$template" "-skill.md" | sed 's/^/  - /'
            fi
        done
        exit 1
    fi

    echo -e "${BLUE}📁 Creating skill: $skill_name${NC}"
    echo -e "${BLUE}📄 Template: $template_type${NC}"
    echo -e "${BLUE}📝 Description: $description${NC}"
    echo ""

    # Create skill directory
    mkdir -p "$skill_path"

    # Copy template to SKILL.md
    cp "$template_file" "$skill_path/SKILL.md"

    # Replace placeholders in the template
    sed -i.bak "s/skill-name/$skill_name/g" "$skill_path/SKILL.md"

    if [[ -n "$description" ]]; then
        # Escape special characters in description for sed
        local escaped_desc=$(echo "$description" | sed 's/[[\.*^$()+?{|]/\\&/g')
        sed -i.bak "s/Clear description with usage trigger (max 1024 chars). Include what it does and when to use it./$escaped_desc/g" "$skill_path/SKILL.md"
    fi

    # Remove backup file
    rm "$skill_path/SKILL.md.bak"

    # Create additional directories based on template type
    case "$template_type" in
        "workflow")
            mkdir -p "$skill_path/checklists"
            echo "# Workflow Checklists" > "$skill_path/checklists/README.md"
            ;;
        "knowledge")
            mkdir -p "$skill_path/reference"
            echo "# Domain Knowledge References" > "$skill_path/reference/README.md"
            ;;
        "integration")
            mkdir -p "$skill_path/scripts"
            mkdir -p "$skill_path/examples"
            echo "# Integration Scripts" > "$skill_path/scripts/README.md"
            echo "# Usage Examples" > "$skill_path/examples/README.md"
            ;;
    esac

    echo -e "${GREEN}✅ Successfully created skill: $skill_name${NC}"
    echo -e "${BLUE}📂 Location: $skill_path${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Edit $skill_path/SKILL.md to customize the content"
    echo -e "  2. Create evaluation scenarios to test the skill"
    echo -e "  3. Validate structure: ./scripts/validate-structure.sh $skill_name"
    echo -e "  4. Test the skill with representative use cases"
    echo ""
}

main() {
    if [[ $# -lt 2 ]]; then
        usage
    fi

    local template_type="$1"
    local skill_name="$2"
    local description="$3"

    # Check if we're in the right directory
    if [[ ! -d "$SKILLS_DIR" ]]; then
        echo -e "${RED}❌ Skills directory not found: $SKILLS_DIR${NC}"
        echo -e "${YELLOW}   Make sure you're in the root of your Claude Code project${NC}"
        exit 1
    fi

    create_skill_from_template "$template_type" "$skill_name" "$description"
}

# Run main function
main "$@"