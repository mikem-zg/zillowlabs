#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
ERRORS=0

red()   { printf '\033[0;31m%s\033[0m\n' "$1"; }
green() { printf '\033[0;32m%s\033[0m\n' "$1"; }
warn()  { printf '\033[0;33m%s\033[0m\n' "$1"; }
header(){ printf '\n\033[1;36m=== %s ===\033[0m\n' "$1"; }

header "Zillow Consumer Brand Guideline Validation"
echo "Scanning: $TARGET"

header "CLR_002: No light/pastel colored backgrounds"
LIGHT_BG=$(grep -rn --include='*.tsx' --include='*.ts' -iE "(bg\.screen\.blue|lightBlue|#E8F4FD|#EBF5FF|#F0F7FF|#E3F2FD|#BBDEFB|background.*['\"].*blue.*['\"])" "$TARGET" 2>/dev/null || true)
if [ -n "$LIGHT_BG" ]; then
  red "VIOLATION: Light blue or pastel backgrounds detected:"
  echo "$LIGHT_BG"
  ERRORS=$((ERRORS + 1))
else
  green "PASS: No light blue backgrounds found"
fi

header "CLR_003: No navy backgrounds"
NAVY_BG=$(grep -rn --include='*.tsx' --include='*.ts' -E "(#001962|Waterfront|navy)" "$TARGET" 2>/dev/null | grep -iE "(background|bg\.|Background)" || true)
if [ -n "$NAVY_BG" ]; then
  red "VIOLATION: Navy/Waterfront used as background:"
  echo "$NAVY_BG"
  ERRORS=$((ERRORS + 1))
else
  green "PASS: No navy backgrounds found"
fi

header "CLR_006: Blue not used for non-interactive elements"
BLUE_HEADINGS=$(grep -rn --include='*.tsx' -E "<(Heading|Text).*color.*[Bb]lue" "$TARGET" 2>/dev/null || true)
if [ -n "$BLUE_HEADINGS" ]; then
  red "WARNING: Blue color on text/heading (blue = interactive only):"
  echo "$BLUE_HEADINGS"
  ERRORS=$((ERRORS + 1))
else
  green "PASS: No blue text/headings detected"
fi

header "LOGO_001/002: Logo sizing"
LOGO_SIZING=$(grep -rn --include='*.tsx' --include='*.ts' -E "ZillowLogo|ZillowHomeLogo" "$TARGET" 2>/dev/null || true)
if [ -n "$LOGO_SIZING" ]; then
  BAD_SIZE=$(echo "$LOGO_SIZING" | grep -vE "(24px|16px|height)" || true)
  if [ -n "$BAD_SIZE" ]; then
    warn "CHECK: Logo found without explicit sizing — verify 24px desktop / 16px mobile:"
    echo "$BAD_SIZE"
  else
    green "PASS: Logo instances have height values"
  fi
else
  green "PASS: No logo instances to check"
fi

header "TYPO_005: No blue headlines"
BLUE_HEADING=$(grep -rn --include='*.tsx' -E "<Heading.*[Bb]lue|<Heading.*action" "$TARGET" 2>/dev/null || true)
if [ -n "$BLUE_HEADING" ]; then
  red "VIOLATION: Blue color on Heading component (implies interactivity):"
  echo "$BLUE_HEADING"
  ERRORS=$((ERRORS + 1))
else
  green "PASS: No blue Heading components"
fi

header "ELEV_001: Shadows only on interactive elements"
STATIC_SHADOW=$(grep -rn --include='*.tsx' -B2 "shadow\|boxShadow\|elevation" "$TARGET" 2>/dev/null | grep -v "interactive\|onClick\|href\|button\|Button\|IconButton" | head -20 || true)
if [ -n "$STATIC_SHADOW" ]; then
  warn "CHECK: Shadow/elevation found — verify these are on interactive elements:"
  echo "$STATIC_SHADOW" | head -10
fi

header "SHAPE_002: Do not override component corner radii"
CUSTOM_RADIUS=$(grep -rn --include='*.tsx' -E "borderRadius.*[0-9]+(px)?" "$TARGET" 2>/dev/null | grep -v "node\.\|rounded" | head -10 || true)
if [ -n "$CUSTOM_RADIUS" ]; then
  warn "CHECK: Custom borderRadius values found — verify not overriding Constellation defaults:"
  echo "$CUSTOM_RADIUS"
fi

echo ""
header "Summary"
if [ "$ERRORS" -eq 0 ]; then
  green "All automated brand checks passed."
else
  red "$ERRORS violation(s) found. Review and fix before delivery."
fi

exit $ERRORS
