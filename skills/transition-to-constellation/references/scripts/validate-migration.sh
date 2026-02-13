#!/bin/bash
set -u

# Constellation Migration Validator
# Checks a codebase for migration completeness and remaining old patterns.
# Usage: bash validate-migration.sh [src-directory]
#
# Exit codes:
#   0 = all checks pass
#   1 = remaining issues found

SRC_DIR="${1:-src}"
ISSUES=0
WARNINGS=0

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory '$SRC_DIR' not found."
  exit 1
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}PASS${NC} $1"; }
fail() { echo -e "  ${RED}FAIL${NC} $1"; ISSUES=$((ISSUES + 1)); }
warn() { echo -e "  ${YELLOW}WARN${NC} $1"; WARNINGS=$((WARNINGS + 1)); }

safe_count() {
  local result
  result=$(eval "$1" 2>/dev/null || true)
  if [ -z "$result" ]; then
    echo "0"
  else
    echo "$result" | wc -l | tr -d ' '
  fi
}

count_files_matching() {
  safe_count "grep -rl '$1' '$SRC_DIR' --include='*.tsx' --include='*.ts' --include='*.jsx' --include='*.js'"
}

echo ""
echo "======================================="
echo "  Constellation Migration Validator"
echo "======================================="
echo ""

# 1. Old Library Imports
echo "1. Old Library Remnants"
echo "-----------------------"

check_old_import() {
  local pattern="$1"
  local label="$2"
  local count
  count=$(count_files_matching "$pattern")
  if [ "$count" -gt 0 ]; then
    fail "$label found in $count files"
    grep -rl "$pattern" "$SRC_DIR" --include="*.tsx" --include="*.ts" --include="*.jsx" --include="*.js" 2>/dev/null | head -5 | while read -r f; do
      echo "       -> $f"
    done
  else
    pass "No $label imports"
  fi
}

check_old_import "from 'lucide-react'" "lucide-react"
check_old_import "from '@heroicons/" "Heroicons"
check_old_import "from 'react-icons/" "react-icons"
check_old_import "from '@mui/" "Material UI"
check_old_import "from '@chakra-ui/" "Chakra UI"
check_old_import "from '@mantine/" "Mantine"

SHADCN_COUNT=$(count_files_matching "from.*components/ui/")
if [ "$SHADCN_COUNT" -gt 0 ]; then
  fail "shadcn/ui component imports found in $SHADCN_COUNT files"
  grep -rl "from.*components/ui/" "$SRC_DIR" --include="*.tsx" --include="*.ts" 2>/dev/null | head -5 | while read -r f; do
    echo "       -> $f"
  done
else
  pass "No shadcn/ui component imports"
fi

echo ""

# 2. Styling Remnants
echo "2. Styling Remnants"
echo "-------------------"

TW_DIRECTIVES=$(safe_count "grep -rl '@tailwind' '$SRC_DIR' --include='*.css'")
if [ "$TW_DIRECTIVES" -gt 0 ]; then
  fail "Tailwind @tailwind directives found in $TW_DIRECTIVES CSS files"
else
  pass "No Tailwind directives in CSS"
fi

CLASSNAME_COUNT=$(count_files_matching 'className=')
if [ "$CLASSNAME_COUNT" -gt 0 ]; then
  warn "className prop found in $CLASSNAME_COUNT files (check if these are third-party components)"
else
  pass "No className usage"
fi

STYLED_COUNT=$(count_files_matching "from 'styled-components'")
if [ "$STYLED_COUNT" -gt 0 ]; then
  fail "styled-components found in $STYLED_COUNT files"
else
  pass "No styled-components"
fi

EMOTION_COUNT=$(count_files_matching "from '@emotion/")
if [ "$EMOTION_COUNT" -gt 0 ]; then
  fail "Emotion CSS found in $EMOTION_COUNT files"
else
  pass "No Emotion CSS"
fi

echo ""

# 3. Constellation Design System Rules
echo "3. Design System Rules"
echo "----------------------"

BORDER_DIVIDERS=$(safe_count "grep -rn 'borderBottom\|border-bottom\|borderTop\|border-top' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep -v node_modules | grep -v styled-system")
if [ "$BORDER_DIVIDERS" -gt 0 ]; then
  warn "CSS border used as divider in $BORDER_DIVIDERS places (use <Divider /> instead)"
else
  pass "No CSS border dividers detected"
fi

OUTLINE_ICONS=$(safe_count "grep -rn 'IconOutline\|Outline}' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep constellation-icons")
if [ "$OUTLINE_ICONS" -gt 0 ]; then
  warn "Outline icons found ($OUTLINE_ICONS occurrences) - use Filled variants by default"
else
  pass "No Outline icon imports detected"
fi

TABS_WITHOUT_DEFAULT=$(safe_count "grep -rn 'Tabs.Root' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep -v defaultSelected")
if [ "$TABS_WITHOUT_DEFAULT" -gt 0 ]; then
  fail "Tabs.Root without defaultSelected found ($TABS_WITHOUT_DEFAULT occurrences)"
else
  pass "All Tabs have defaultSelected"
fi

PROPERTY_CARDS=$(safe_count "grep -rn 'PropertyCard' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep -v 'import\|SaveButton\|//\|Badge\|Photo\|HomeDetails'")
SAVE_BUTTONS=$(safe_count "grep -rn 'PropertyCard.SaveButton\|saveButton=' '$SRC_DIR' --include='*.tsx' --include='*.jsx'")
if [ "$PROPERTY_CARDS" -gt 0 ] && [ "$SAVE_BUTTONS" -eq 0 ]; then
  fail "PropertyCard used without saveButton prop"
else
  pass "PropertyCard saveButton check OK"
fi

RAW_HEADINGS=$(safe_count "grep -rn '<h[1-6][ >]' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep -v node_modules")
if [ "$RAW_HEADINGS" -gt 0 ]; then
  warn "Raw HTML heading tags found ($RAW_HEADINGS occurrences) - use Heading or Text component"
else
  pass "No raw HTML heading tags"
fi

RAW_P=$(safe_count "grep -rn '<p[ >]' '$SRC_DIR' --include='*.tsx' --include='*.jsx' | grep -v node_modules")
if [ "$RAW_P" -gt 0 ]; then
  warn "Raw <p> tags found ($RAW_P occurrences) - use Text component"
else
  pass "No raw <p> tags"
fi

echo ""

# 4. Constellation Setup
echo "4. Constellation Setup"
echo "----------------------"

PKG_FILE=""
for f in package.json ../package.json; do
  if [ -f "$f" ]; then PKG_FILE="$f"; break; fi
done

if [ -n "$PKG_FILE" ]; then
  if grep -q "@zillow/constellation" "$PKG_FILE" 2>/dev/null; then
    pass "Constellation package installed"
  else
    fail "Constellation package NOT in package.json"
  fi

  if grep -q "@zillow/constellation-icons" "$PKG_FILE" 2>/dev/null; then
    pass "Constellation Icons package installed"
  else
    warn "Constellation Icons package not in package.json"
  fi

  if grep -q "@pandacss/dev" "$PKG_FILE" 2>/dev/null; then
    pass "PandaCSS installed"
  else
    fail "PandaCSS NOT installed"
  fi
fi

if [ -f "panda.config.ts" ] || [ -f "panda.config.mjs" ] || [ -f "panda.config.js" ]; then
  pass "PandaCSS config file exists"
  PANDA_CONFIG=$(find . -maxdepth 1 -name "panda.config.*" 2>/dev/null | head -1)
  if [ -n "$PANDA_CONFIG" ]; then
    if grep -q "constellationPandaConfig" "$PANDA_CONFIG" 2>/dev/null; then
      pass "Using constellationPandaConfig (recommended)"
    elif grep -q "constellationPandaPreset" "$PANDA_CONFIG" 2>/dev/null; then
      warn "Using constellationPandaPreset - consider switching to constellationPandaConfig for plugin support"
    fi
  fi
else
  fail "No PandaCSS config file found"
fi

if [ -d "$SRC_DIR/styled-system" ]; then
  pass "styled-system directory exists"
else
  fail "styled-system directory not found - run 'npx panda codegen'"
fi

THEME_INJECTION=$(safe_count "grep -rl 'injectTheme\|ConstellationProvider\|getTheme' '$SRC_DIR' --include='*.tsx' --include='*.ts'")
if [ "$THEME_INJECTION" -gt 0 ]; then
  pass "Theme injection detected"
else
  fail "No theme injection found - add injectTheme() or ConstellationProvider"
fi

echo ""

# 5. Old Config Files
echo "5. Old Configuration Files"
echo "--------------------------"

check_old_config() {
  local file="$1"
  local label="$2"
  if [ -f "$file" ]; then
    warn "Old config file exists: $file ($label)"
  else
    pass "No $file"
  fi
}

check_old_config "tailwind.config.js" "Tailwind"
check_old_config "tailwind.config.ts" "Tailwind"
check_old_config "tailwind.config.mjs" "Tailwind"
check_old_config "components.json" "shadcn"

echo ""

# Summary
echo "======================================="
if [ "$ISSUES" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "  ${GREEN}Migration complete - all checks passed${NC}"
elif [ "$ISSUES" -eq 0 ]; then
  echo -e "  ${YELLOW}$WARNINGS warnings, 0 issues${NC}"
  echo "  Migration is functional but has minor items to address."
else
  echo -e "  ${RED}$ISSUES issues, $WARNINGS warnings${NC}"
  echo "  Migration has remaining work. Fix items marked FAIL first."
fi
echo "======================================="
echo ""

if [ "$ISSUES" -gt 0 ]; then
  exit 1
fi
exit 0
