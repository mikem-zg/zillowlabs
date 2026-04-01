#!/bin/bash
# Constellation Token Audit Script
# Catches hardcoded CSS values where Constellation design tokens should be used.
# Usage: bash .agents/skills/constellation-design-system/scripts/validate-tokens.sh [directory]
#
# Exit codes:
#   0 = no violations found
#   1 = violations found

DIR="${1:-.}"
VIOLATIONS=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

check() {
  local label="$1"
  local pattern="$2"
  local suggestion="$3"
  local files
  files=$(grep -rl --include="*.tsx" --include="*.jsx" --include="*.ts" -E "$pattern" "$DIR" 2>/dev/null | grep -v node_modules | grep -v .mockup | grep -v styled-system | grep -v '\.test\.')
  if [ -n "$files" ]; then
    echo -e "${RED}VIOLATION:${NC} ${BOLD}$label${NC}"
    if [ -n "$suggestion" ]; then
      echo -e "  ${YELLOW}→ $suggestion${NC}"
    fi
    echo "$files" | while read -r f; do
      grep -n -E "$pattern" "$f" | head -3 | while read -r line; do
        echo "  $f:$line"
      done
    done
    echo ""
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
}

echo -e "${BOLD}Constellation Token Audit${NC}"
echo "Scanning: $DIR"
echo "---"
echo ""

echo -e "${BOLD}=== Hardcoded Colors ===${NC}"
echo ""

check "Hardcoded hex color in css prop" \
  "css=.*['\"]#[0-9a-fA-F]{3,8}['\"]" \
  "Use semantic tokens: text.subtle, icon.neutral, bg.screen.neutral, etc."

check "Hardcoded hex color in style prop" \
  "style=.*color:.*['\"]#[0-9a-fA-F]{3,8}['\"]" \
  "Use CSS variables: var(--color-text-subtle), var(--color-icon-neutral), etc."

check "Hardcoded rgb/rgba color" \
  "rgba?\([0-9]" \
  "Use design tokens or CSS variables instead of raw rgb/rgba values."

check "Wrong CSS variable prefix --colors- (should be --color-)" \
  "\-\-colors\-" \
  "Constellation uses --color- (singular): var(--color-text-on-hero-neutral)"

echo -e "${BOLD}=== Hardcoded Spacing ===${NC}"
echo ""

check "Hardcoded px in padding" \
  "css=.*p[xytblr]?:[[:space:]]*['\"][0-9]+px['\"]" \
  "Spacing tokens: '50'=2px, '100'=4px, '200'=8px, '300'=12px, '400'=16px, '500'=20px, '600'=24px, '800'=32px"

check "Hardcoded px in margin" \
  "css=.*m[xytblr]?:[[:space:]]*['\"][0-9]+px['\"]" \
  "Spacing tokens: '50'=2px, '100'=4px, '200'=8px, '300'=12px, '400'=16px, '500'=20px, '600'=24px, '800'=32px"

check "Hardcoded px in gap" \
  "css=.*gap:[[:space:]]*['\"][0-9]+px['\"]" \
  "Spacing tokens: '100'=4px, '200'=8px, '300'=12px, '400'=16px, '500'=20px, '600'=24px"

check "Hardcoded rem in spacing" \
  "css=.*(padding|margin|gap).*['\"][0-9.]+rem['\"]" \
  "Use spacing tokens ('200', '400', etc.) instead of rem values."

echo -e "${BOLD}=== Hardcoded Typography ===${NC}"
echo ""

check "Hardcoded fontSize in css prop" \
  "css=.*fontSize:[[:space:]]*['\"][0-9]+(px|rem|em)['\"]" \
  "Use textStyle prop: 'body-sm', 'body', 'body-lg', 'heading-sm', 'heading-lg', etc."

check "Hardcoded fontWeight in css prop" \
  "css=.*fontWeight:[[:space:]]*['\"]?(bold|[4-9][0-9]{2}|normal)['\"]?" \
  "Use textStyle prop with bold variants: 'body-bold', 'body-lg-bold', etc."

check "Hardcoded lineHeight in css prop" \
  "css=.*lineHeight:[[:space:]]*['\"][0-9]+(px|rem|em)?['\"]" \
  "Line height is included in textStyle tokens — don't override."

echo -e "${BOLD}=== Hardcoded Borders & Radii ===${NC}"
echo ""

check "Hardcoded borderRadius (use token)" \
  "borderRadius:[[:space:]]*['\"][0-9]+px['\"]" \
  "Use radius tokens: 'node.sm', 'node.md', 'node.lg'. Cards/buttons default to 12px."

check "Hardcoded border color" \
  "borderColor:[[:space:]]*['\"]#[0-9a-fA-F]" \
  "Use token: borderColor: 'border.muted' or 'border.default'"

echo -e "${BOLD}=== Token Misuse ===${NC}"
echo ""

check "bg.canvas (not a standard surface token)" \
  "bg\.canvas" \
  "Use bg.screen.neutral (white) or bg.soft (light gray for Professional apps)"

check "bg.accent.blue.soft on page background (not for pages)" \
  "background.*bg\.accent\.blue\.soft" \
  "Blue backgrounds are only for hero sections. Use bg.screen.neutral for pages."

check "Raw CSS property names in css prop (use Panda shorthands)" \
  "css=.*(paddingTop|paddingBottom|paddingLeft|paddingRight|marginLeft|marginRight):" \
  "Use shorthands: pt, pb, pl, pr, ml, mr, or px, py, mx, my"

echo "---"
if [ "$VIOLATIONS" -eq 0 ]; then
  echo -e "${GREEN}No token violations found.${NC}"
  exit 0
else
  echo -e "${RED}Found $VIOLATIONS token violation type(s).${NC}"
  echo "Token reference: .agents/skills/constellation-design-system/references/guides/token-reference.md"
  exit 1
fi
