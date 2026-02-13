#!/usr/bin/env bash
#
# psalm-check.sh - Run Psalm static analysis with common configurations
#
# Usage:
#   ./psalm-check.sh [mode] [options]
#
# Modes:
#   check          - Standard check (default)
#   baseline       - Update baseline file
#   info           - Show info-level issues
#   debug          - Run with debug output
#   clear          - Clear cache and run check
#
# Options:
#   --threads N    - Number of threads (default: auto)
#   --show-info    - Show info level issues
#   --no-cache     - Disable cache
#   --stats        - Show statistics
#
# Examples:
#   ./psalm-check.sh                      # Standard check
#   ./psalm-check.sh baseline             # Update baseline
#   ./psalm-check.sh info                 # Show info issues
#   ./psalm-check.sh check --stats        # Check with statistics
#   ./psalm-check.sh clear                # Clear cache and check

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PSALM_BIN="${PSALM_BIN:-vendor/bin/psalm}"
THREADS="${THREADS:-auto}"

# Usage function
usage() {
    cat << EOF
Usage: $(basename "$0") [mode] [options]

Run Psalm static analysis with common configurations.

Modes:
  check          Standard check (default)
  baseline       Update baseline file
  info           Show info-level issues
  debug          Run with debug output
  clear          Clear cache and run check

Options:
  --threads N    Number of threads (default: auto)
  --show-info    Show info level issues
  --no-cache     Disable cache
  --stats        Show statistics
  -h, --help     Show this help message and exit

Features:
  - Common flag combinations pre-configured
  - Automatic thread detection
  - Cache management
  - Baseline handling
  - Progress output

Requirements:
  - Psalm installed (vendor/bin/psalm)
  - psalm.xml configuration file

Examples:
  $(basename "$0")                      # Standard check
  $(basename "$0") baseline             # Update baseline
  $(basename "$0") info                 # Show info issues
  $(basename "$0") check --stats        # Check with statistics
  $(basename "$0") clear                # Clear cache and check
  $(basename "$0") --help               # Show this help

EOF
    exit 0
}

# Handle help flag first
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
fi

# Check if Psalm is available
if [[ ! -f "$PSALM_BIN" ]]; then
    echo -e "${RED}Error: Psalm not found at $PSALM_BIN${NC}"
    echo -e "${YELLOW}Run: composer install${NC}"
    exit 1
fi

# Parse mode
MODE="${1:-check}"
shift || true

# Parse additional options
PSALM_ARGS=()
SHOW_STATS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --threads)
            THREADS="$2"
            shift 2
            ;;
        --show-info)
            PSALM_ARGS+=("--show-info=true")
            shift
            ;;
        --no-cache)
            PSALM_ARGS+=("--no-cache")
            shift
            ;;
        --stats)
            SHOW_STATS=true
            PSALM_ARGS+=("--stats")
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            PSALM_ARGS+=("$1")
            shift
            ;;
    esac
done

echo -e "${BLUE}=== Psalm Static Analysis ===${NC}"
echo -e "${BLUE}Mode:${NC} $MODE"
echo -e "${BLUE}Threads:${NC} $THREADS"
echo ""

# Execute based on mode
case "$MODE" in
    check)
        echo -e "${GREEN}Running standard check...${NC}"
        "$PSALM_BIN" --threads="$THREADS" "${PSALM_ARGS[@]}"
        ;;

    baseline)
        echo -e "${YELLOW}Updating baseline file...${NC}"
        "$PSALM_BIN" --threads="$THREADS" --set-baseline=psalm-baseline.xml "${PSALM_ARGS[@]}"
        echo -e "${GREEN}✓ Baseline updated: psalm-baseline.xml${NC}"
        ;;

    info)
        echo -e "${GREEN}Running check with info-level issues...${NC}"
        "$PSALM_BIN" --threads="$THREADS" --show-info=true "${PSALM_ARGS[@]}"
        ;;

    debug)
        echo -e "${YELLOW}Running with debug output...${NC}"
        "$PSALM_BIN" --threads="$THREADS" --debug "${PSALM_ARGS[@]}"
        ;;

    clear)
        echo -e "${YELLOW}Clearing cache...${NC}"
        "$PSALM_BIN" --clear-cache
        echo -e "${GREEN}✓ Cache cleared${NC}"
        echo ""
        echo -e "${GREEN}Running check...${NC}"
        "$PSALM_BIN" --threads="$THREADS" "${PSALM_ARGS[@]}"
        ;;

    --help|-h)
        usage
        ;;

    *)
        echo -e "${RED}Error: Unknown mode: $MODE${NC}"
        echo ""
        usage
        ;;
esac

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ Psalm check passed${NC}"
else
    echo -e "${RED}✗ Psalm found issues (exit code $EXIT_CODE)${NC}"
fi

exit $EXIT_CODE