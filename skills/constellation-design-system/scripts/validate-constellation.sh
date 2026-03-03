#!/bin/bash
# Constellation Design System Validator
# Scans TSX/JSX files for common design system violations.
# Usage: bash .agents/skills/constellation-design-system/scripts/validate-constellation.sh [directory]
#
# Exit codes:
#   0 = no violations found
#   1 = violations found

DIR="${1:-.}"
VIOLATIONS=0
TOTAL_FILES=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

check() {
  local label="$1"
  local pattern="$2"
  local files
  files=$(grep -rl --include="*.tsx" --include="*.jsx" -E "$pattern" "$DIR" 2>/dev/null | grep -v node_modules | grep -v .mockup | grep -v styled-system)
  if [ -n "$files" ]; then
    echo -e "${RED}VIOLATION:${NC} ${BOLD}$label${NC}"
    echo "$files" | while read -r f; do
      grep -n -E "$pattern" "$f" | head -3 | while read -r line; do
        echo "  $f:$line"
      done
    done
    echo ""
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
}

echo -e "${BOLD}Constellation Design System Validator${NC}"
echo "Scanning: $DIR"
echo "---"

TOTAL_FILES=$(find "$DIR" -name "*.tsx" -o -name "*.jsx" | grep -v node_modules | grep -v .mockup | grep -v styled-system | wc -l)
echo "Found $TOTAL_FILES TSX/JSX files"
echo ""

# Rule 1: PropertyCard must have saveButton
check "PropertyCard missing saveButton prop" '<PropertyCard[^>]*(?!saveButton)[^/]*>' 

# Rule 2: Card without tone="neutral"
check "Card missing tone=\"neutral\"" '<Card[[:space:]][^>]*(?!tone=)[^>]*>'

# Rule 3: CSS border instead of Divider
check "CSS border used instead of <Divider />" "border(Bottom|Top|Left|Right)?:[[:space:]]*['\"].*['\"]"

# Rule 4: Outline icons used as default (should be Filled)
check "Outline icon used (should use Filled variant)" 'Icon[A-Z][a-zA-Z]*Outline'

# Rule 5: Icon without size token wrapper
check "Icon without <Icon size=\"...\"> wrapper" 'import.*Icon[A-Z][a-zA-Z]*Filled'

# Rule 6: Tabs without defaultSelected
check "Tabs.Root without defaultSelected prop" '<Tabs\.Root[^>]*(?!defaultSelected)[^>]*>'

# Rule 7: Raw HTML elements instead of Constellation components
check "Raw <p> tag (use <Text> instead)" '<p[[:space:]>]'
check "Raw <span> tag (use <Text> instead)" '<span[[:space:]][^>]*style'
check "Raw <h[1-6]> tag (use <Heading> instead)" '<h[1-6][[:space:]>]'
check "Raw <button> tag (use <Button> instead)" '<button[[:space:]>]'
check "Raw <input> tag (use <Input> instead)" '<input[[:space:]>]'

# Rule 8: Light blue backgrounds
check "Light blue background (use bg.screen.neutral or Gray)" "background.*['\"].*#[eE][3-9].*[bB][lL][uU][eE]"
check "bg-blue or bg.blue token used" "bg[.:][[:space:]]*['\"].*blue"

# Rule 9: Title Case in UI text (check string literals in JSX)
check "ALL CAPS text in UI (use sentence case)" '>[[:space:]]*[A-Z]{4,}[[:space:]]*<'

# Rule 10: Custom Box used where Card should be
check "Box with padding+border (consider Card component)" '<Box[^>]*border[^>]*padding'

# Rule 11: Incorrect icon color prop
check "Icon color prop with token path (use css prop instead)" '<Icon[^>]*color="[a-z]+\.[a-z]'

# Rule 12: Button wrapping icon and text in Flex
check "Flex inside Button (use icon prop instead)" '<Button[^>]*>[[:space:]]*<Flex'

# Rule 13: defaultValue on Tabs (should be defaultSelected)
check "Tabs using defaultValue (should be defaultSelected)" '<Tabs[^>]*defaultValue'

# Rule 14: Modal content as children instead of body prop
check "Modal children content (use body prop instead)" '<Modal[^>]*>[[:space:]]*[^<]*[A-Za-z]'

echo "---"
if [ "$VIOLATIONS" -eq 0 ]; then
  echo -e "${GREEN}No violations found.${NC}"
  exit 0
else
  echo -e "${RED}Found $VIOLATIONS violation type(s).${NC}"
  echo "Review the design system rules: references/guides/design-system-rules.md"
  exit 1
fi
