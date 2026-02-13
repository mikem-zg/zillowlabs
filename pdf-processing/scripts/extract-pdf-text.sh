#!/bin/bash
# PDF Text Extraction Script
# Extracts text from PDF files using pdftotext with various modes

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/pdf-utils.sh"

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <pdf_file> [output_file]

Extract text from PDF documents using pdftotext.

OPTIONS:
    -m, --mode MODE     Extraction mode: layout|raw|table|fixed-width|smart (default: layout)
    -h, --help         Show this help message
    -v, --verbose      Enable verbose output

MODES:
    layout      Preserve original layout and formatting (default)
    raw         Extract raw text without layout preservation
    table       Attempt to preserve table structure
    fixed-width Use fixed-width formatting (good for forms)
    smart       Auto-detect best extraction method

EXAMPLES:
    $0 document.pdf
    $0 -m raw report.pdf extracted_text.txt
    $0 --mode smart complex_doc.pdf

EOF
}

# Parse command line arguments
MODE="layout"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Validate arguments
if [[ $# -lt 1 ]]; then
    echo "Error: PDF file path required" >&2
    usage >&2
    exit 1
fi

PDF_FILE="$1"
OUTPUT_FILE="${2:-}"

# Validate inputs
validate_pdf_input "$PDF_FILE" || exit 1
check_pdftotext_available || exit 1

# Set output file if not provided
if [[ -z "$OUTPUT_FILE" ]]; then
    OUTPUT_FILE="${PDF_FILE%.*}.txt"
fi

# Verbose logging function
log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "📄 $*" >&2
    fi
}

# Extract text based on mode
extract_text() {
    local pdf_file="$1"
    local output_file="$2"
    local extraction_mode="$3"

    log_verbose "Extracting text from: $(basename "$pdf_file")"
    log_verbose "Mode: $extraction_mode"

    case "$extraction_mode" in
        "layout")
            pdftotext -layout "$pdf_file" "$output_file"
            ;;
        "raw")
            pdftotext -raw "$pdf_file" "$output_file"
            ;;
        "table")
            pdftotext -table "$pdf_file" "$output_file"
            ;;
        "fixed-width")
            pdftotext -fixed 4 "$pdf_file" "$output_file"
            ;;
        "smart")
            extract_smart "$pdf_file" "$output_file"
            return $?
            ;;
        *)
            echo "Error: Unknown extraction mode: $extraction_mode" >&2
            return 1
            ;;
    esac

    local extracted_lines
    extracted_lines=$(wc -l < "$output_file" 2>/dev/null || echo "0")
    log_verbose "Extracted $extracted_lines lines"

    return 0
}

# Smart extraction - try different methods and choose best
extract_smart() {
    local pdf_file="$1"
    local output_file="$2"

    log_verbose "Smart extraction: testing methods..."

    local temp_dir
    temp_dir=$(mktemp -d)
    local methods=("layout" "raw" "table" "fixed-width")
    local best_method=""
    local best_score=0

    for method in "${methods[@]}"; do
        local temp_output="$temp_dir/test_$method.txt"

        case "$method" in
            "layout")
                pdftotext -layout "$pdf_file" "$temp_output" 2>/dev/null || continue
                ;;
            "raw")
                pdftotext -raw "$pdf_file" "$temp_output" 2>/dev/null || continue
                ;;
            "table")
                pdftotext -table "$pdf_file" "$temp_output" 2>/dev/null || continue
                ;;
            "fixed-width")
                pdftotext -fixed 4 "$pdf_file" "$temp_output" 2>/dev/null || continue
                ;;
        esac

        # Score extraction quality
        local score=0
        if [[ -r "$temp_output" ]]; then
            local lines words chars
            lines=$(wc -l < "$temp_output")
            words=$(wc -w < "$temp_output")
            chars=$(wc -c < "$temp_output")

            # Higher score for more content and better structure
            score=$((lines * 2 + words + chars / 100))

            # Bonus for preserved structure indicators
            if grep -q "^[[:space:]]\+[A-Za-z]" "$temp_output"; then
                score=$((score + 50))  # Indentation preserved
            fi
            if grep -q "|\|---" "$temp_output"; then
                score=$((score + 30))  # Table structure preserved
            fi
        fi

        log_verbose "Method '$method': score $score"
        if [[ $score -gt $best_score ]]; then
            best_score=$score
            best_method=$method
        fi
    done

    if [[ -n "$best_method" ]]; then
        log_verbose "Using best method: $best_method (score: $best_score)"
        cp "$temp_dir/test_$best_method.txt" "$output_file"
    else
        echo "Error: All extraction methods failed" >&2
        rm -rf "$temp_dir"
        return 1
    fi

    rm -rf "$temp_dir"
    return 0
}

# Main execution
main() {
    extract_text "$PDF_FILE" "$OUTPUT_FILE" "$MODE"

    if [[ $? -eq 0 ]]; then
        echo "✅ Text extracted successfully: $OUTPUT_FILE"

        # Show basic stats
        if [[ -r "$OUTPUT_FILE" ]]; then
            local lines words chars
            lines=$(wc -l < "$OUTPUT_FILE")
            words=$(wc -w < "$OUTPUT_FILE")
            chars=$(wc -c < "$OUTPUT_FILE")

            echo "📊 Statistics: $lines lines, $words words, $chars characters"

            # Quality assessment
            local quality
            quality=$(assess_extraction_quality "$OUTPUT_FILE")
            echo "📈 Extraction quality: $quality"
        fi
    else
        echo "❌ Text extraction failed" >&2
        exit 1
    fi
}

# Run main function
main "$@"