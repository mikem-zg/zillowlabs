#!/usr/bin/env bash
# Initialize a new Agent Skill with proper structure
# Usage: bash .agents/skills/skill-creator/scripts/init-skill.sh <skill-name>

set -euo pipefail

SKILL_NAME="${1:-}"
SKILLS_DIR=".agents/skills"

if [[ -z "$SKILL_NAME" ]]; then
  echo "Usage: bash .agents/skills/skill-creator/scripts/init-skill.sh <skill-name>"
  echo ""
  echo "Requirements:"
  echo "  - Lowercase letters, numbers, and hyphens only"
  echo "  - Max 64 characters"
  echo "  - No leading/trailing hyphens"
  echo "  - No consecutive hyphens"
  echo ""
  echo "Examples:"
  echo "  bash .agents/skills/skill-creator/scripts/init-skill.sh pdf-processing"
  echo "  bash .agents/skills/skill-creator/scripts/init-skill.sh analyzing-data"
  exit 1
fi

# Validate name
if [[ ${#SKILL_NAME} -gt 64 ]]; then
  echo "Error: Name must be 64 characters or fewer (got ${#SKILL_NAME})"
  exit 1
fi

if [[ ! "$SKILL_NAME" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
  echo "Error: Name must be lowercase letters, numbers, and hyphens only"
  echo "       Cannot start or end with a hyphen"
  exit 1
fi

if [[ "$SKILL_NAME" =~ -- ]]; then
  echo "Error: Name cannot contain consecutive hyphens"
  exit 1
fi

SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"

if [[ -d "$SKILL_DIR" ]]; then
  echo "Error: Skill directory already exists: $SKILL_DIR"
  exit 1
fi

# Create directories
mkdir -p "$SKILL_DIR/references"
mkdir -p "$SKILL_DIR/scripts"

# Create SKILL.md
TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

cat > "$SKILL_DIR/SKILL.md" << SKILLEOF
---
name: $SKILL_NAME
description: [TODO: What this skill does and when to use it. Write in third person. Include trigger keywords. Max 1024 chars.]
---

# $TITLE

[TODO: 2-3 sentences explaining what this skill enables.]

## Core Workflow

[TODO: Essential steps. Keep under 500 lines total. Move details to references/.]

## Resources

[TODO: Link to reference files as needed]
- **Detailed guide**: See [references/guide.md](references/guide.md) (create if needed)
SKILLEOF

# Create placeholder reference
cat > "$SKILL_DIR/references/.gitkeep" << 'EOF'
EOF

echo "Skill '$SKILL_NAME' initialized at $SKILL_DIR/"
echo ""
echo "Files created:"
echo "  $SKILL_DIR/SKILL.md"
echo "  $SKILL_DIR/references/"
echo "  $SKILL_DIR/scripts/"
echo ""
echo "Next steps:"
echo "  1. Edit SKILL.md — complete the TODO items"
echo "  2. Write the description (most important field)"
echo "  3. Add reference files if needed"
echo "  4. Validate: check references/validation-checklist.md in skill-creator"
