#!/bin/bash
# Constellation Icon Import Validator
# Scans TSX/JSX files and verifies every imported icon exists in @zillow/constellation-icons.
# Usage: bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh [directory]
#
# Exit codes:
#   0 = all icons valid
#   1 = invalid icons found

DIR="${1:-.}"
ERRORS=0

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}Constellation Icon Import Validator${NC}"
echo "Scanning: $DIR"
echo "---"

for f in $(grep -rl --include="*.tsx" --include="*.jsx" "constellation-icons" "$DIR" 2>/dev/null | grep -v node_modules | grep -v .mockup | grep -v styled-system); do
  ICONS=$(grep -oE 'Icon[A-Z][a-zA-Z]+(Filled|Outline|Percent)' "$f" 2>/dev/null | sort -u)
  for icon in $ICONS; do
    RESULT=$(node --input-type=module -e "import * as m from '@zillow/constellation-icons'; process.stdout.write(m['$icon'] ? 'OK' : 'BAD')" 2>/dev/null)
    if [ "$RESULT" = "BAD" ]; then
      echo -e "${RED}INVALID:${NC} ${BOLD}$icon${NC} in $f"
      BASE=$(echo "$icon" | sed -E 's/(Filled|Outline)$//' | sed 's/^Icon//' | tr '[:upper:]' '[:lower:]')
      SUGGESTIONS=$(node --input-type=module -e "import * as m from '@zillow/constellation-icons'; Object.keys(m).filter(k=>k.toLowerCase().includes('$BASE')&&k.endsWith('Filled')).slice(0,5).forEach(k=>process.stdout.write(k+' '))" 2>/dev/null)
      if [ -n "$SUGGESTIONS" ]; then
        echo "  Did you mean: $SUGGESTIONS"
      fi
      ERRORS=$((ERRORS + 1))
    fi
  done
done

echo "---"
if [ "$ERRORS" -eq 0 ]; then
  echo -e "${GREEN}All icon imports are valid.${NC}"
  exit 0
else
  echo -e "${RED}Found $ERRORS invalid icon import(s).${NC}"
  echo "Search for valid icons: node --input-type=module -e \"import * as m from '@zillow/constellation-icons'; Object.keys(m).filter(k=>k.toLowerCase().includes('keyword')).forEach(k=>console.log(k))\""
  exit 1
fi
