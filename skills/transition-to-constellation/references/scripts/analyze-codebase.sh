#!/bin/bash
set -u

# Constellation Migration Analyzer
# Scans a React codebase and produces a structured migration report.
# Usage: bash analyze-codebase.sh [src-directory]
#
# Output: A migration report showing:
#   - Current UI stack (libraries, styling, icons)
#   - File counts per library
#   - Component usage inventory
#   - Migration priority order
#   - Estimated migration scope

SRC_DIR="${1:-src}"
REPORT_FILE="migration-report.md"

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory '$SRC_DIR' not found."
  echo "Usage: bash analyze-codebase.sh [src-directory]"
  exit 1
fi

count_files() {
  local pattern="$1"
  local result
  result=$(grep -rl "$pattern" "$SRC_DIR" --include="*.tsx" --include="*.ts" --include="*.jsx" --include="*.js" 2>/dev/null | wc -l)
  echo "$result"
}

count_matches() {
  local pattern="$1"
  local result
  result=$(grep -r "$pattern" "$SRC_DIR" --include="*.tsx" --include="*.ts" --include="*.jsx" --include="*.js" 2>/dev/null | wc -l)
  echo "$result"
}

list_files() {
  local pattern="$1"
  grep -rl "$pattern" "$SRC_DIR" --include="*.tsx" --include="*.ts" --include="*.jsx" --include="*.js" 2>/dev/null || true
}

echo "Scanning $SRC_DIR..."
echo ""

# ─── Package.json Analysis ───
PKG_FILE=""
for f in package.json ../package.json ../../package.json; do
  if [ -f "$f" ]; then
    PKG_FILE="$f"
    break
  fi
done

# ─── Detect UI Libraries ───
HAS_TAILWIND=false
HAS_MUI=false
HAS_CHAKRA=false
HAS_SHADCN=false
HAS_ANTD=false
HAS_RADIX=false
HAS_MANTINE=false
HAS_CONSTELLATION=false

if [ -n "$PKG_FILE" ]; then
  grep -q "tailwindcss" "$PKG_FILE" 2>/dev/null && HAS_TAILWIND=true
  grep -q "@mui/" "$PKG_FILE" 2>/dev/null && HAS_MUI=true
  grep -q "@chakra-ui/" "$PKG_FILE" 2>/dev/null && HAS_CHAKRA=true
  grep -q "class-variance-authority" "$PKG_FILE" 2>/dev/null && HAS_SHADCN=true
  grep -q "antd" "$PKG_FILE" 2>/dev/null && HAS_ANTD=true
  grep -q "@radix-ui/" "$PKG_FILE" 2>/dev/null && HAS_RADIX=true
  grep -q "@mantine/" "$PKG_FILE" 2>/dev/null && HAS_MANTINE=true
  grep -q "@zillow/constellation" "$PKG_FILE" 2>/dev/null && HAS_CONSTELLATION=true
fi

# Also check for Tailwind config files
if [ -f "tailwind.config.js" ] || [ -f "tailwind.config.ts" ] || [ -f "tailwind.config.mjs" ]; then
  HAS_TAILWIND=true
fi

# Check for shadcn components.json
if [ -f "components.json" ]; then
  HAS_SHADCN=true
fi

# ─── Detect Styling Solutions ───
TAILWIND_FILES=$(count_files "className=")
CSS_MODULE_FILES=$(count_files "styles\." 2>/dev/null || echo "0")
STYLED_COMP_FILES=$(count_files "styled\." 2>/dev/null || echo "0")
EMOTION_FILES=$(count_files "from '@emotion" 2>/dev/null || echo "0")
INLINE_STYLE_FILES=$(count_files "style={{" 2>/dev/null || echo "0")
PANDA_FILES=$(count_files "from.*styled-system" 2>/dev/null || echo "0")

# ─── Detect Icon Libraries ───
LUCIDE_FILES=$(count_files "from 'lucide-react'" 2>/dev/null || echo "0")
HEROICONS_FILES=$(count_files "from '@heroicons/" 2>/dev/null || echo "0")
REACT_ICONS_FILES=$(count_files "from 'react-icons/" 2>/dev/null || echo "0")
MUI_ICONS_FILES=$(count_files "from '@mui/icons-material" 2>/dev/null || echo "0")
FA_FILES=$(count_files "from '@fortawesome/" 2>/dev/null || echo "0")
CONSTELLATION_ICON_FILES=$(count_files "from '@zillow/constellation-icons" 2>/dev/null || echo "0")

# ─── Count Specific Component Patterns ───
CLASSNAME_USAGES=$(count_matches "className=")
CSS_BORDER_USAGES=$(count_matches "border.*:" 2>/dev/null || echo "0")
RAW_H_TAGS=$(count_matches "<h[1-6][ >]" 2>/dev/null || echo "0")
RAW_P_TAGS=$(count_matches "<p[ >]" 2>/dev/null || echo "0")
RAW_BUTTON_TAGS=$(count_matches "<button[ >]" 2>/dev/null || echo "0")
RAW_INPUT_TAGS=$(count_matches "<input[ >]" 2>/dev/null || echo "0")
RAW_DIV_FLEX=$(count_matches 'className=".*flex' 2>/dev/null || echo "0")

# ─── shadcn Component Detection ───
SHADCN_BUTTON=$(count_files "from.*components/ui/button" 2>/dev/null || echo "0")
SHADCN_CARD=$(count_files "from.*components/ui/card" 2>/dev/null || echo "0")
SHADCN_DIALOG=$(count_files "from.*components/ui/dialog" 2>/dev/null || echo "0")
SHADCN_INPUT=$(count_files "from.*components/ui/input" 2>/dev/null || echo "0")
SHADCN_SELECT=$(count_files "from.*components/ui/select" 2>/dev/null || echo "0")
SHADCN_TABLE=$(count_files "from.*components/ui/table" 2>/dev/null || echo "0")
SHADCN_TABS=$(count_files "from.*components/ui/tabs" 2>/dev/null || echo "0")
SHADCN_BADGE=$(count_files "from.*components/ui/badge" 2>/dev/null || echo "0")
SHADCN_TOOLTIP=$(count_files "from.*components/ui/tooltip" 2>/dev/null || echo "0")
SHADCN_SEPARATOR=$(count_files "from.*components/ui/separator" 2>/dev/null || echo "0")
SHADCN_ACCORDION=$(count_files "from.*components/ui/accordion" 2>/dev/null || echo "0")

# ─── MUI Component Detection ───
MUI_BUTTON=$(count_files "from '@mui/material/Button'" 2>/dev/null || echo "0")
MUI_TEXTFIELD=$(count_files "from '@mui/material/TextField'" 2>/dev/null || echo "0")
MUI_CARD=$(count_files "from '@mui/material/Card'" 2>/dev/null || echo "0")
MUI_DIALOG=$(count_files "from '@mui/material/Dialog'" 2>/dev/null || echo "0")
MUI_BOX=$(count_files "from '@mui/material/Box'" 2>/dev/null || echo "0")

# ─── Constellation Component Detection ───
CONST_IMPORTS=$(count_files "from '@zillow/constellation'" 2>/dev/null || echo "0")

# ─── Total File Count ───
TOTAL_FILES=$(find "$SRC_DIR" -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.jsx" -o -name "*.js" \) 2>/dev/null | wc -l)

# ─── Generate Report ───
cat > "$REPORT_FILE" << EOF
# Migration Report

Generated: $(date '+%Y-%m-%d %H:%M')
Source directory: \`$SRC_DIR\`
Total source files: $TOTAL_FILES

---

## 1. Current UI Stack

### Libraries Detected
EOF

if $HAS_TAILWIND; then echo "- **Tailwind CSS** (detected)" >> "$REPORT_FILE"; fi
if $HAS_MUI; then echo "- **Material UI** (detected)" >> "$REPORT_FILE"; fi
if $HAS_CHAKRA; then echo "- **Chakra UI** (detected)" >> "$REPORT_FILE"; fi
if $HAS_SHADCN; then echo "- **shadcn/ui** (detected)" >> "$REPORT_FILE"; fi
if $HAS_ANTD; then echo "- **Ant Design** (detected)" >> "$REPORT_FILE"; fi
if $HAS_RADIX; then echo "- **Radix UI** (detected)" >> "$REPORT_FILE"; fi
if $HAS_MANTINE; then echo "- **Mantine** (detected)" >> "$REPORT_FILE"; fi
if $HAS_CONSTELLATION; then echo "- **Constellation** (already installed)" >> "$REPORT_FILE"; fi

if ! $HAS_TAILWIND && ! $HAS_MUI && ! $HAS_CHAKRA && ! $HAS_SHADCN && ! $HAS_ANTD && ! $HAS_MANTINE; then
  echo "- No major UI library detected (likely vanilla CSS or custom components)" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

### Styling Solutions

| Method | Files Using |
|--------|-------------|
| className props | $TAILWIND_FILES |
| CSS Modules | $CSS_MODULE_FILES |
| styled-components | $STYLED_COMP_FILES |
| Emotion | $EMOTION_FILES |
| Inline styles | $INLINE_STYLE_FILES |
| PandaCSS (styled-system) | $PANDA_FILES |

### Icon Libraries

| Library | Files Using |
|---------|-------------|
| lucide-react | $LUCIDE_FILES |
| Heroicons | $HEROICONS_FILES |
| react-icons | $REACT_ICONS_FILES |
| MUI Icons | $MUI_ICONS_FILES |
| FontAwesome | $FA_FILES |
| Constellation Icons | $CONSTELLATION_ICON_FILES |

---

## 2. Component Usage Inventory

### Raw HTML Elements (need Constellation replacements)

| Element | Occurrences | Constellation Replacement |
|---------|-------------|--------------------------|
| \`<h1>-<h6>\` tags | $RAW_H_TAGS | \`Heading\` / \`Text textStyle\` |
| \`<p>\` tags | $RAW_P_TAGS | \`Text\` |
| \`<button>\` tags | $RAW_BUTTON_TAGS | \`Button\` |
| \`<input>\` tags | $RAW_INPUT_TAGS | \`Input\` / \`LabeledInput\` |
| Tailwind flex classes | $RAW_DIV_FLEX | \`Flex\` from styled-system |
| Total className usages | $CLASSNAME_USAGES | PandaCSS \`css()\` or component props |

EOF

if $HAS_SHADCN; then
cat >> "$REPORT_FILE" << EOF
### shadcn/ui Components

| Component | Files Using | Constellation Replacement |
|-----------|-------------|--------------------------|
| Button | $SHADCN_BUTTON | \`Button\` |
| Card | $SHADCN_CARD | \`Card tone="neutral"\` |
| Dialog | $SHADCN_DIALOG | \`Modal\` |
| Input | $SHADCN_INPUT | \`Input\` / \`LabeledInput\` |
| Select | $SHADCN_SELECT | \`Select\` / \`DropdownSelect\` |
| Table | $SHADCN_TABLE | \`Table\` |
| Tabs | $SHADCN_TABS | \`Tabs.Root\` |
| Badge | $SHADCN_BADGE | \`Tag\` |
| Tooltip | $SHADCN_TOOLTIP | \`Tooltip\` |
| Separator | $SHADCN_SEPARATOR | \`Divider\` |
| Accordion | $SHADCN_ACCORDION | \`Accordion\` |

EOF
fi

if $HAS_MUI; then
cat >> "$REPORT_FILE" << EOF
### Material UI Components

| Component | Files Using | Constellation Replacement |
|-----------|-------------|--------------------------|
| Button | $MUI_BUTTON | \`Button\` |
| TextField | $MUI_TEXTFIELD | \`Input\` / \`LabeledInput\` |
| Card | $MUI_CARD | \`Card tone="neutral"\` |
| Dialog | $MUI_DIALOG | \`Modal\` |
| Box | $MUI_BOX | \`Box\` from styled-system |

EOF
fi

cat >> "$REPORT_FILE" << EOF
---

## 3. Migration Scope Estimate

EOF

# Calculate migration scope
TOTAL_MIGRATEABLE=0
TOTAL_MIGRATEABLE=$((TOTAL_MIGRATEABLE + TAILWIND_FILES + LUCIDE_FILES + HEROICONS_FILES + REACT_ICONS_FILES + MUI_ICONS_FILES + FA_FILES))
TOTAL_MIGRATEABLE=$((TOTAL_MIGRATEABLE + SHADCN_BUTTON + SHADCN_CARD + SHADCN_DIALOG + SHADCN_INPUT + SHADCN_SELECT))
TOTAL_MIGRATEABLE=$((TOTAL_MIGRATEABLE + SHADCN_TABLE + SHADCN_TABS + SHADCN_BADGE + SHADCN_TOOLTIP + SHADCN_SEPARATOR))

# Deduplicate estimate (files may have multiple patterns)
if [ "$TOTAL_MIGRATEABLE" -gt "$TOTAL_FILES" ]; then
  TOTAL_MIGRATEABLE=$TOTAL_FILES
fi

if [ "$TOTAL_MIGRATEABLE" -eq 0 ]; then
  SCOPE="minimal"
  SCOPE_DESC="Very few files need migration. This may be a new project or already uses Constellation."
elif [ "$TOTAL_MIGRATEABLE" -lt 10 ]; then
  SCOPE="small"
  SCOPE_DESC="Small migration. Can likely be completed in a single session."
elif [ "$TOTAL_MIGRATEABLE" -lt 30 ]; then
  SCOPE="medium"
  SCOPE_DESC="Medium migration. Recommend page-by-page conversion over 2-3 sessions."
else
  SCOPE="large"
  SCOPE_DESC="Large migration. Recommend incremental coexistence strategy — run old and new systems side-by-side."
fi

cat >> "$REPORT_FILE" << EOF
**Scope: $SCOPE** — $SCOPE_DESC

| Metric | Count |
|--------|-------|
| Total source files | $TOTAL_FILES |
| Files needing migration (estimated) | $TOTAL_MIGRATEABLE |
| Already using Constellation | $CONST_IMPORTS |
| Already using PandaCSS | $PANDA_FILES |

EOF

# ─── Suggested migration order ───
cat >> "$REPORT_FILE" << EOF
---

## 4. Suggested Migration Order

### Phase 1: Setup (do first)
1. Install Constellation packages and configure PandaCSS
2. Set up theme injection and styled-system aliases
3. Import Constellation CSS in entry point
EOF

if $HAS_TAILWIND; then
cat >> "$REPORT_FILE" << EOF
4. Configure Tailwind/PandaCSS coexistence (prefix Tailwind classes with \`tw-\`)
EOF
fi

cat >> "$REPORT_FILE" << EOF

### Phase 2: App Shell
1. Replace header/navigation with Constellation \`Page.Header\` or \`TopNav\`
2. Replace page layout wrapper with \`Page.Root\` / \`Layout\`
3. Add \`ZillowLogo\` component

### Phase 3: Convert by Priority

**High priority** (most visible, convert first):
EOF

# List files with most old-library imports
echo "" >> "$REPORT_FILE"

if [ "$LUCIDE_FILES" -gt 0 ]; then
  echo "- Replace **lucide-react** icons → Constellation Filled icons ($LUCIDE_FILES files)" >> "$REPORT_FILE"
fi
if [ "$SHADCN_BUTTON" -gt 0 ]; then
  echo "- Replace **shadcn Button** → Constellation \`Button\` ($SHADCN_BUTTON files)" >> "$REPORT_FILE"
fi
if [ "$SHADCN_CARD" -gt 0 ]; then
  echo "- Replace **shadcn Card** → Constellation \`Card\` ($SHADCN_CARD files)" >> "$REPORT_FILE"
fi
if [ "$RAW_BUTTON_TAGS" -gt 0 ]; then
  echo "- Replace raw **\`<button>\`** tags → Constellation \`Button\` ($RAW_BUTTON_TAGS occurrences)" >> "$REPORT_FILE"
fi
if [ "$RAW_H_TAGS" -gt 0 ]; then
  echo "- Replace raw **heading** tags → \`Heading\` / \`Text\` ($RAW_H_TAGS occurrences)" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

**Medium priority** (forms and data display):
EOF

if [ "$SHADCN_INPUT" -gt 0 ] || [ "$RAW_INPUT_TAGS" -gt 0 ]; then
  echo "- Replace inputs → Constellation \`Input\` / \`LabeledInput\`" >> "$REPORT_FILE"
fi
if [ "$SHADCN_TABLE" -gt 0 ]; then
  echo "- Replace tables → Constellation \`Table\`" >> "$REPORT_FILE"
fi
if [ "$SHADCN_DIALOG" -gt 0 ]; then
  echo "- Replace dialogs → Constellation \`Modal\`" >> "$REPORT_FILE"
fi
if [ "$SHADCN_TABS" -gt 0 ]; then
  echo "- Replace tabs → Constellation \`Tabs.Root\` (with \`defaultSelected\`)" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

**Low priority** (cleanup):
EOF

if $HAS_TAILWIND; then
  echo "- Convert remaining Tailwind classes → PandaCSS (use \`tw2panda\` tool)" >> "$REPORT_FILE"
fi
echo "- Remove old CSS files, config files, and unused dependencies" >> "$REPORT_FILE"
echo "- Run validation script to confirm no remnants" >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## 5. Files to Migrate

### Files with old UI library imports
EOF

# List key files
if [ "$LUCIDE_FILES" -gt 0 ]; then
  echo "" >> "$REPORT_FILE"
  echo "**lucide-react imports:**" >> "$REPORT_FILE"
  echo '```' >> "$REPORT_FILE"
  list_files "from 'lucide-react'" | head -20 >> "$REPORT_FILE"
  echo '```' >> "$REPORT_FILE"
fi

if $HAS_SHADCN; then
  SHADCN_ALL=$(list_files "from.*components/ui/" 2>/dev/null)
  if [ -n "$SHADCN_ALL" ]; then
    echo "" >> "$REPORT_FILE"
    echo "**shadcn/ui component imports:**" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    echo "$SHADCN_ALL" | head -30 >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
  fi
fi

if $HAS_MUI; then
  MUI_ALL=$(list_files "from '@mui/" 2>/dev/null)
  if [ -n "$MUI_ALL" ]; then
    echo "" >> "$REPORT_FILE"
    echo "**MUI imports:**" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    echo "$MUI_ALL" | head -30 >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
  fi
fi

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "*Report generated by Constellation Migration Analyzer*" >> "$REPORT_FILE"

echo ""
echo "Migration report written to: $REPORT_FILE"
echo ""
cat "$REPORT_FILE"
