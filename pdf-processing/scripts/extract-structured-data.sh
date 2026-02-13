#!/bin/bash
# PDF Structured Data Extraction Script
# Extracts structured data patterns from PDF content

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/pdf-utils.sh"

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <pdf_file> [output_file]

Extract structured data patterns from PDF content.

OPTIONS:
    -p, --patterns PATTERNS   Comma-separated list of patterns to extract
    -f, --format FORMAT      Output format: json|csv|text (default: json)
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output

AVAILABLE PATTERNS:
    email        Email addresses
    phone        Phone numbers (US format)
    url          Web URLs
    date-iso     ISO dates (YYYY-MM-DD)
    date-us      US dates (MM/DD/YYYY)
    currency     Currency amounts (dollar signs)
    percentage   Percentage values
    custom:REGEX Custom regex pattern

EXAMPLES:
    $0 -p email,phone document.pdf
    $0 --patterns "currency,percentage" --format csv report.pdf data.csv
    $0 -p "custom:[A-Z]{3}-[0-9]{4}" logs.pdf ticket_numbers.json

EOF
}

# Parse command line arguments
PATTERNS=""
FORMAT="json"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--patterns)
            PATTERNS="$2"
            shift 2
            ;;
        -f|--format)
            FORMAT="$2"
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

if [[ -z "$PATTERNS" ]]; then
    echo "Error: Patterns required (use -p option)" >&2
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
    case "$FORMAT" in
        "json")
            OUTPUT_FILE="${PDF_FILE%.*}.structured.json"
            ;;
        "csv")
            OUTPUT_FILE="${PDF_FILE%.*}.structured.csv"
            ;;
        "text")
            OUTPUT_FILE="${PDF_FILE%.*}.structured.txt"
            ;;
    esac
fi

# Verbose logging function
log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "🔍 $*" >&2
    fi
}

# Extract text from PDF
extract_pdf_for_patterns() {
    local pdf_file="$1"
    local temp_text
    temp_text=$(mktemp)

    log_verbose "Extracting text from PDF for pattern analysis..."
    pdftotext -raw "$pdf_file" "$temp_text"

    echo "$temp_text"
}

# Extract patterns from text
extract_all_patterns() {
    local text_file="$1"
    local patterns="$2"
    local temp_results
    temp_results=$(mktemp)

    log_verbose "Extracting patterns: $patterns"

    local extraction_count=0

    # Process each pattern
    IFS=',' read -ra PATTERN_LIST <<< "$patterns"
    for pattern_spec in "${PATTERN_LIST[@]}"; do
        # Handle custom patterns
        if [[ "$pattern_spec" =~ ^custom: ]]; then
            local custom_pattern="${pattern_spec#custom:}"
            log_verbose "Extracting custom pattern: $custom_pattern"
            while IFS= read -r match; do
                echo "custom,$match" >> "$temp_results"
                extraction_count=$((extraction_count + 1))
            done < <(grep -oE "$custom_pattern" "$text_file" 2>/dev/null || true)
        else
            log_verbose "Extracting $pattern_spec patterns..."
            while IFS= read -r match; do
                echo "$pattern_spec,$match" >> "$temp_results"
                extraction_count=$((extraction_count + 1))
            done < <(extract_pattern "$text_file" "$pattern_spec")
        fi
    done

    log_verbose "Total matches found: $extraction_count"
    echo "$temp_results,$extraction_count"
}

# Generate JSON output
generate_json_output() {
    local pdf_file="$1"
    local output_file="$2"
    local results_file="$3"
    local extraction_count="$4"

    {
        echo "{"
        echo "  \"extracted_data\": {"
        echo "    \"source_pdf\": \"$pdf_file\","
        echo "    \"extraction_date\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\","
        echo "    \"total_matches\": $extraction_count,"
        echo "    \"patterns\": ["

        local first_item=true
        while IFS=',' read -r pattern_type value; do
            if [[ -n "$pattern_type" && -n "$value" ]]; then
                if [[ "$first_item" == "true" ]]; then
                    first_item=false
                else
                    echo ","
                fi
                # Escape quotes in JSON values
                local escaped_value
                escaped_value=$(echo "$value" | sed 's/"/\\"/g')
                echo -n "      {\"type\": \"$pattern_type\", \"value\": \"$escaped_value\"}"
            fi
        done < "$results_file"

        echo ""
        echo "    ]"
        echo "  }"
        echo "}"
    } > "$output_file"
}

# Generate CSV output
generate_csv_output() {
    local output_file="$1"
    local results_file="$2"

    echo "pattern_type,value" > "$output_file"
    cat "$results_file" >> "$output_file"
}

# Generate text output
generate_text_output() {
    local pdf_file="$1"
    local output_file="$2"
    local results_file="$3"
    local extraction_count="$4"

    {
        echo "Structured Data Extraction Report"
        echo "================================"
        echo ""
        echo "Source PDF: $pdf_file"
        echo "Extraction Date: $(date)"
        echo "Total Matches: $extraction_count"
        echo ""

        # Group by pattern type
        local current_type=""
        while IFS=',' read -r pattern_type value; do
            if [[ -n "$pattern_type" && -n "$value" ]]; then
                if [[ "$pattern_type" != "$current_type" ]]; then
                    if [[ -n "$current_type" ]]; then
                        echo ""
                    fi
                    echo "$pattern_type patterns:"
                    echo "$(printf '%.0s-' {1..20})"
                    current_type="$pattern_type"
                fi
                echo "$value"
            fi
        done < <(sort "$results_file")

    } > "$output_file"
}

# Generate summary statistics
generate_statistics() {
    local results_file="$1"

    echo "📊 Pattern Statistics:"

    # Count by pattern type
    awk -F',' '{count[$1]++} END {
        for (type in count) {
            if (type != "") printf "  %s: %d matches\n", type, count[type]
        }
    }' "$results_file" | sort
}

# Main execution
main() {
    log_verbose "Starting structured data extraction: $(basename "$PDF_FILE")"
    log_verbose "Patterns to extract: $PATTERNS"
    log_verbose "Output format: $FORMAT"

    # Extract text for pattern analysis
    local temp_text
    temp_text=$(extract_pdf_for_patterns "$PDF_FILE")

    # Extract all patterns
    local results_and_count temp_results extraction_count
    results_and_count=$(extract_all_patterns "$temp_text" "$PATTERNS")
    temp_results="${results_and_count%,*}"
    extraction_count="${results_and_count##*,}"

    # Check if any patterns were found
    if [[ $extraction_count -eq 0 ]]; then
        echo "⚠️  No patterns found matching: $PATTERNS" >&2
        rm -f "$temp_text" "$temp_results"

        # Create empty output file
        case "$FORMAT" in
            "json")
                echo '{"extracted_data": {"patterns": [], "total_matches": 0}}' > "$OUTPUT_FILE"
                ;;
            "csv")
                echo "pattern_type,value" > "$OUTPUT_FILE"
                ;;
            "text")
                echo "No patterns found" > "$OUTPUT_FILE"
                ;;
        esac

        echo "📄 Empty results saved to: $OUTPUT_FILE"
        exit 0
    fi

    # Generate output based on format
    case "$FORMAT" in
        "json")
            generate_json_output "$PDF_FILE" "$OUTPUT_FILE" "$temp_results" "$extraction_count"
            validate_json_output "$OUTPUT_FILE" || {
                echo "❌ JSON validation failed" >&2
                rm -f "$temp_text" "$temp_results"
                exit 1
            }
            ;;
        "csv")
            generate_csv_output "$OUTPUT_FILE" "$temp_results"
            ;;
        "text")
            generate_text_output "$PDF_FILE" "$OUTPUT_FILE" "$temp_results" "$extraction_count"
            ;;
        *)
            echo "Error: Unknown format: $FORMAT" >&2
            rm -f "$temp_text" "$temp_results"
            exit 1
            ;;
    esac

    # Show statistics
    generate_statistics "$temp_results"

    # Cleanup
    rm -f "$temp_text" "$temp_results"

    echo "✅ Structured data extraction complete: $OUTPUT_FILE"
}

# Run main function
main "$@"