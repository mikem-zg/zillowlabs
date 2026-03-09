#!/bin/bash
# Professional Brand Guidelines Validator
# Checks professional-audience code for brand violations
# Usage: bash validate-brand-professional.sh <source_directory>

DIR="${1:-.}"
VIOLATIONS=0

echo "=== Professional Brand Guidelines Validation ==="
echo "Scanning: $DIR"
echo ""

echo "=== CLR_P02: Prohibited colors (purple, orange, teal) in UI ==="
PROHIBITED=$(grep -rn --include="*.tsx" --include="*.ts" --include="*.css" \
  -E "(Purple[0-9]|Orange[0-9]|Teal[0-9]|#933DFB|#D03C0B|#136F65|#E6A8FF|#FFA385|#3B0470|#7D2103)" \
  "$DIR" | grep -v "node_modules" | grep -v "illustration" | grep -v "styled-system" | grep -v "\.svg" || true)
if [ -n "$PROHIBITED" ]; then
  echo "VIOLATION: Purple/Orange/Teal found in non-illustration code:"
  echo "$PROHIBITED"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No prohibited colors in UI code"
fi
echo ""

echo "=== CLR_P04: No light/pastel colored backgrounds ==="
PASTEL=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E "(#E3F2FD|#E8F5E9|#FFF3E0|#F3E5F5|#E0F7FA|#FCE4EC|lightBlue|lightPurple|lightTeal)" \
  "$DIR" | grep -v "node_modules" | grep -v "styled-system" || true)
if [ -n "$PASTEL" ]; then
  echo "VIOLATION: Light/pastel backgrounds found:"
  echo "$PASTEL"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No light/pastel backgrounds"
fi
echo ""

echo "=== SHAPE_P01: No house motif for professionals ==="
MOTIF=$(grep -rn --include="*.tsx" --include="*.ts" -i \
  -E "(house.?motif|HouseMotif|house.?frame|HouseFrame|solid.?house|SolidHouse)" \
  "$DIR" | grep -v "node_modules" || true)
if [ -n "$MOTIF" ]; then
  echo "VIOLATION: House motif references found (prohibited for professionals):"
  echo "$MOTIF"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No house motif references"
fi
echo ""

echo "=== ILLUS_P01: No scene illustrations ==="
SCENE=$(grep -rn --include="*.tsx" --include="*.ts" -i \
  -E "(scene.?illustration|SceneIllustration|scene.?illus)" \
  "$DIR" | grep -v "node_modules" || true)
if [ -n "$SCENE" ]; then
  echo "VIOLATION: Scene illustration references found (only spot allowed for professionals):"
  echo "$SCENE"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No scene illustration references"
fi
echo ""

echo "=== COMP_P01: Buttons/inputs/tables should default to size='sm' ==="
SIZING=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E '<(Button|Input|Select|IconButton)[^>]* size="(md|lg|xl)"' \
  "$DIR" | grep -v "node_modules" | grep -v "styled-system" || true)
if [ -n "$SIZING" ]; then
  echo "CHECK: Non-sm sizing found on buttons/inputs — verify these are intentional (only hero CTAs should be md):"
  echo "$SIZING"
else
  echo "PASS: All buttons/inputs use size='sm' or default"
fi
echo ""

echo "=== COMP_P03: Max heading size is heading-md ==="
HEADING_LG=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E 'heading-lg|heading-xl' \
  "$DIR" | grep -v "node_modules" | grep -v "styled-system" || true)
if [ -n "$HEADING_LG" ]; then
  echo "VIOLATION: heading-lg or heading-xl found — professional apps max at heading-md:"
  echo "$HEADING_LG"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No heading-lg or heading-xl usage"
fi
echo ""

echo "=== TYPO_P06: No blue headlines ==="
BLUE_HEADING=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E '<Heading[^>]*(color.*blue|Blue|#0041D9)' \
  "$DIR" | grep -v "node_modules" || true)
if [ -n "$BLUE_HEADING" ]; then
  echo "VIOLATION: Blue Heading components found (blue = interactive only):"
  echo "$BLUE_HEADING"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo "PASS: No blue Heading components"
fi
echo ""

echo "=== SURF_P03: Shadows only on interactive elements ==="
echo "CHECK: Review shadow usage — shadows should indicate interactivity"
echo ""

echo "=== CLR_P11: CSS borders instead of Divider (content separators) ==="
echo "NOTE: borderBottom is correct on header containers (sticky Box) — review matches for context"
BORDERS=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E "(borderBottom|borderTop|border-bottom|border-top)" \
  "$DIR" | grep -v "node_modules" | grep -v "styled-system" | grep -v "borderBottomWidth" || true)
if [ -n "$BORDERS" ]; then
  echo "CHECK: CSS borders found — verify these are header edge lines (OK) or content separators (should use <Divider />):"
  echo "$BORDERS"
else
  echo "PASS: No CSS border usage found"
fi
echo ""

echo "=== Summary ==="
if [ $VIOLATIONS -gt 0 ]; then
  echo "$VIOLATIONS violation(s) found. Review and fix before delivery."
else
  echo "All automated checks passed."
fi
