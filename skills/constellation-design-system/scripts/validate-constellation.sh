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

echo -e "${BOLD}=== Critical Rules (23) ===${NC}"
echo ""

# Rule 1: PropertyCard must have saveButton
check "PropertyCard missing saveButton prop" '<PropertyCard[^>]*(?!saveButton)[^/]*>'

# Rule 2: Card without tone="neutral"
check "Card missing tone=\"neutral\"" '<Card[[:space:]][^>]*(?!tone=)[^>]*>'

# Rule 3: CSS border instead of Divider (for content separators)
check "CSS border used instead of <Divider /> (OK in header containers)" "border(Bottom|Top|Left|Right)?:[[:space:]]*['\"].*['\"]"

# Rule 4: Outline icons used as default (should be Filled)
check "Outline icon used (should use Filled variant)" 'Icon[A-Z][a-zA-Z]*Outline'

# Rule 5: Verify imported icons actually exist in package (batched for speed)
ICON_LIST=$(grep -roh --include="*.tsx" --include="*.jsx" 'Icon[A-Z][a-zA-Z]*\(Filled\|Outline\|Percent\)' "$DIR" 2>/dev/null | grep -v node_modules | sort -u | tr '\n' ',' | sed 's/,$//')
if [ -n "$ICON_LIST" ]; then
  ICON_RESULT=$(node --input-type=module -e "
    import * as m from '@zillow/constellation-icons';
    const icons = '${ICON_LIST}'.split(',');
    const invalid = icons.filter(i => !m[i]);
    if (invalid.length) { invalid.forEach(i => console.log(i)); process.exit(1); }
  " 2>/dev/null)
  if [ $? -ne 0 ] && [ -n "$ICON_RESULT" ]; then
    echo -e "${RED}VIOLATION:${NC} ${BOLD}Non-existent icon imports${NC}"
    echo "$ICON_RESULT" | while read -r icon; do
      FILES=$(grep -rl --include="*.tsx" --include="*.jsx" "$icon" "$DIR" 2>/dev/null | grep -v node_modules | head -3)
      echo "  $icon"
      echo "$FILES" | sed 's/^/    /'
    done
    echo ""
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
fi

# Rule 6: Tabs without defaultSelected
check "Tabs.Root without defaultSelected prop" '<Tabs\.Root[^>]*(?!defaultSelected)[^>]*>'

# Rule 8: bg.canvas (not a standard page surface token)
check "bg.canvas used (use bg.screen.neutral instead)" "bg\.canvas"

# Rule 9: Text/Icon color prop with semantic token (use css prop instead)
check "Icon color prop with token path (use css={{ color: '...' }} instead)" '<Icon[^>]*color="[a-z]+\.[a-z]'
check "Text color prop with token path (use css={{ color: '...' }} instead)" '<Text[^>]*color="[a-z]+\.[a-z]'

# Rule 10: On-hero text using css prop (must use style prop)
check "On-hero token in css prop (use style={{ color: 'var(--color-text-on-hero-...)' }})" "css=.*text\.onHero"
check "On-hero token in css prop (use style={{ color: 'var(--color-text-on-hero-...)' }})" "css=.*text\.on-hero"

# Rule 12: Modal content as children instead of body prop
check "Modal children content (use body prop instead)" '<Modal[^>]*>[[:space:]]*[^<]*[A-Za-z]'

# Rule 14: Page not wrapped in Page.Root — check files that import Page but don't use Page.Root
check "Page imported but Page.Root not used" 'import.*Page.*constellation.*(?!.*Page\.Root)'

# Rule 15: Heading without level prop
check "Heading without level prop" '<Heading[^>]*(?!level)[^>]*>'

# Rule 17-18: Raw HTML elements instead of Constellation components
check "Raw <input> tag (use <Input> instead)" '<input[[:space:]>]'
check "Raw <select> tag (use <Select> instead)" '<select[[:space:]>]'
check "Raw <textarea> tag (use <Textarea> instead)" '<textarea[[:space:]>]'
check "Raw <button> tag (use <Button> instead)" '<button[[:space:]>]'
check "Raw <h[1-6]> tag (use <Heading> instead)" '<h[1-6][[:space:]>]'
check "Raw <p> tag (use <Text> instead)" '<p[[:space:]>]'

# Rule 22: fontWeight: 'bold' (should use textStyle bold variants)
check "fontWeight in css/style prop (use textStyle='body-bold' etc.)" "fontWeight.*['\"]bold['\"]"
check "fontWeight token in css prop (use textStyle bold variant)" "fontWeight:[[:space:]]*['\"][0-9]"

# Rule 23: Raw <input type="range"> (should use Slider or Range)
check "Raw <input type=\"range\"> (use <Slider> or <Range>)" '<input[^>]*type=["\x27]range["\x27]'

# Rule 19: Raw CSS property names instead of PandaCSS shorthands
check "Raw 'padding' in css prop (use p/px/py/pt/pb/pl/pr)" "css=.*padding[^A-Z]"
check "Raw 'marginBottom' in css prop (use mb)" "css=.*marginBottom"
check "Raw 'marginTop' in css prop (use mt)" "css=.*marginTop"
check "Raw 'marginInline' in css prop (use mx)" "css=.*marginInline"

# Rule 21: Button wrapping icon and text in Flex
check "Flex inside Button (use icon prop instead)" '<Button[^>]*>[[:space:]]*<Flex'

echo -e "${BOLD}=== Token & Styling ===${NC}"
echo ""

# --colors- prefix (should be --color-)
check "--colors- prefix (should be --color-, singular)" '\-\-colors\-'

# Light blue backgrounds
check "Light blue background hex (use bg.screen.neutral or Gray)" "background.*['\"].*#[eE][3-9].*[bB][lL][uU][eE]"
check "bg.blue or bg.accent.blue.soft on Page (not allowed for page backgrounds)" "bg[.:][[:space:]]*['\"].*blue"

# Hardcoded hex colors in css prop
check "Hardcoded hex color in css prop (use design tokens)" "css=.*['\"]#[0-9a-fA-F]{3,8}['\"]"

# Hardcoded px in padding/margin/gap (should use spacing tokens)
check "Hardcoded px in padding (use spacing tokens: '100'=4px, '200'=8px, '300'=12px, '400'=16px)" "css=.*p[xytblr]?:[[:space:]]*['\"][0-9]+px['\"]"
check "Hardcoded px in margin (use spacing tokens)" "css=.*m[xytblr]?:[[:space:]]*['\"][0-9]+px['\"]"
check "Hardcoded px in gap (use spacing tokens)" "css=.*gap:[[:space:]]*['\"][0-9]+px['\"]"

echo -e "${BOLD}=== Component Patterns ===${NC}"
echo ""

# Tabs defaultValue (should be defaultSelected)
check "Tabs using defaultValue (should be defaultSelected)" '<Tabs[^>]*defaultValue'

# Box with padding+border (should use Card)
check "Box with padding+border (consider Card component)" '<Box[^>]*border[^>]*padding'

# ALL CAPS text in UI
check "ALL CAPS text in UI (use sentence case)" '>[[:space:]]*[A-Z]{4,}[[:space:]]*<'

# Bare Flex without direction (defaults to row, likely a bug for stacking)
check "Adjacent Text siblings without flex-column wrapper (text runs inline)" '<Text[^>]*/>[[:space:]]*<Text'

# Icon wrapper inside Button icon prop (should be raw icon, not <Icon><IconXFilled /></Icon>)
check "<Icon> wrapper inside Button icon prop (pass raw icon)" 'icon=\{<Icon[ >]'

# IconButton without title prop
check "IconButton without title prop (required for accessibility)" '<IconButton[^>]*(?!title)[^>]*>'

echo "---"
if [ "$VIOLATIONS" -eq 0 ]; then
  echo -e "${GREEN}No violations found.${NC}"
  exit 0
else
  echo -e "${RED}Found $VIOLATIONS violation type(s).${NC}"
  echo "Fix guide: .agents/skills/constellation-design-system/references/guides/design-system-rules.md"
  exit 1
fi
