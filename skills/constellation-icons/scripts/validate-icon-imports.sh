#!/bin/bash
# Constellation Icon Import Validator
# Scans TSX/JSX files and verifies every imported icon exists in @zillow/constellation-icons.
# Usage: bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh [directory]
#
# Exit codes:
#   0 = all icons valid
#   1 = invalid icons found

DIR="${1:-.}"

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}Constellation Icon Import Validator${NC}"
echo "Scanning: $DIR"
echo "---"

ICON_LIST=$(grep -roh --include="*.tsx" --include="*.jsx" 'Icon[A-Z][a-zA-Z]*\(Filled\|Outline\|Percent\)' "$DIR" 2>/dev/null | grep -v node_modules | sort -u)

if [ -z "$ICON_LIST" ]; then
  echo "No icon imports found."
  exit 0
fi

ICONS_JSON=$(echo "$ICON_LIST" | tr '\n' ',' | sed 's/,$//')

RESULT=$(node --input-type=module -e "
import * as m from '@zillow/constellation-icons';
const icons = '${ICONS_JSON}'.split(',');
const invalid = [];
const valid = [];
for (const icon of icons) {
  if (m[icon]) { valid.push(icon); } else { invalid.push(icon); }
}
console.log(JSON.stringify({ valid: valid.length, invalid }));
" 2>/dev/null)

INVALID_COUNT=$(echo "$RESULT" | node -e "const d=require('fs').readFileSync('/dev/stdin','utf8');const j=JSON.parse(d);console.log(j.invalid.length)" 2>/dev/null)
VALID_COUNT=$(echo "$RESULT" | node -e "const d=require('fs').readFileSync('/dev/stdin','utf8');const j=JSON.parse(d);console.log(j.valid)" 2>/dev/null)

if [ "$INVALID_COUNT" = "0" ] || [ -z "$INVALID_COUNT" ]; then
  echo -e "${GREEN}All $VALID_COUNT icon imports are valid.${NC}"
  exit 0
fi

echo "$RESULT" | node -e "
const d=require('fs').readFileSync('/dev/stdin','utf8');
const j=JSON.parse(d);
j.invalid.forEach(icon => {
  console.log('INVALID: ' + icon);
  const base = icon.replace(/^Icon/,'').replace(/(Filled|Outline)$/,'').toLowerCase();
  const all = Object.keys(require('@zillow/constellation-icons')).filter(k=>k.toLowerCase().includes(base)&&k.endsWith('Filled')).slice(0,5);
  if (all.length) console.log('  Did you mean: ' + all.join(', '));
});
" 2>/dev/null

echo "---"
echo -e "${RED}Found $INVALID_COUNT invalid icon(s) out of $((VALID_COUNT + INVALID_COUNT)) total.${NC}"

for icon in $(echo "$RESULT" | node -e "const d=require('fs').readFileSync('/dev/stdin','utf8');JSON.parse(d).invalid.forEach(i=>console.log(i))" 2>/dev/null); do
  FILES=$(grep -rl --include="*.tsx" --include="*.jsx" "$icon" "$DIR" 2>/dev/null | grep -v node_modules | head -5)
  if [ -n "$FILES" ]; then
    echo "  $icon found in:"
    echo "$FILES" | sed 's/^/    /'
  fi
done

exit 1
