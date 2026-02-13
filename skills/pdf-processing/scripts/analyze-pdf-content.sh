#!/bin/bash
# PDF Content Analysis Script
# Analyzes PDF content for structure, patterns, and classification

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/pdf-utils.sh"

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <pdf_file> [output_file]

Analyze PDF content for structure, patterns, and document classification.

OPTIONS:
    -l, --level LEVEL   Analysis level: basic|full (default: basic)
    -f, --format FORMAT Output format: json|text (default: json)
    -h, --help         Show this help message
    -v, --verbose      Enable verbose output

ANALYSIS LEVELS:
    basic   Basic metrics, patterns, and document classification
    full    Comprehensive analysis including advanced content processing

EXAMPLES:
    $0 document.pdf
    $0 -l full report.pdf analysis.json
    $0 --format text manual.pdf manual_analysis.txt

EOF
}

# Parse command line arguments
LEVEL="basic"
FORMAT="json"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--level)
            LEVEL="$2"
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

PDF_FILE="$1"
OUTPUT_FILE="${2:-}"

# Validate inputs
validate_pdf_input "$PDF_FILE" || exit 1
check_pdftotext_available || exit 1

# Set output file if not provided
if [[ -z "$OUTPUT_FILE" ]]; then
    case "$FORMAT" in
        "json")
            OUTPUT_FILE="${PDF_FILE%.*}.analysis.json"
            ;;
        "text")
            OUTPUT_FILE="${PDF_FILE%.*}.analysis.txt"
            ;;
    esac
fi

# Verbose logging function
log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "📊 $*" >&2
    fi
}

# Extract text for analysis
extract_for_analysis() {
    local pdf_file="$1"
    local temp_text
    temp_text=$(mktemp)

    log_verbose "Extracting text for analysis..."
    pdftotext -layout "$pdf_file" "$temp_text"

    echo "$temp_text"
}

# Analyze content patterns
analyze_patterns() {
    local text_file="$1"

    log_verbose "Analyzing content patterns..."

    local emails phones urls dates currency percentages
    emails=$(extract_pattern "$text_file" "email" | wc -l)
    phones=$(extract_pattern "$text_file" "phone" | wc -l)
    urls=$(extract_pattern "$text_file" "url" | wc -l)
    dates=$(grep -cE '[0-9]{4}-[0-9]{2}-[0-9]{2}|[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}|[A-Za-z]{3,9}\s+[0-9]{1,2},?\s+[0-9]{4}' "$text_file" 2>/dev/null || echo "0")
    currency=$(extract_pattern "$text_file" "currency" | wc -l)
    percentages=$(extract_pattern "$text_file" "percentage" | wc -l)

    echo "$emails,$phones,$urls,$dates,$currency,$percentages"
}

# Analyze document structure
analyze_structure() {
    local text_file="$1"

    log_verbose "Analyzing document structure..."

    local headers bullet_points form_fields table_indicators page_breaks indented_sections
    headers=$(grep -cE '^[A-Z][A-Za-z\s]+:?\s*$|^[0-9]+\.\s+[A-Za-z]' "$text_file" 2>/dev/null || echo "0")
    bullet_points=$(grep -cE '^\s*[-*•]\s+|^\s*[0-9]+\.\s+' "$text_file" 2>/dev/null || echo "0")
    form_fields=$(grep -cE '__+|\.\.\.|\[\s*\]|___' "$text_file" 2>/dev/null || echo "0")
    table_indicators=$(grep -cE '\|.*\||\s{3,}\w+\s{3,}\w+' "$text_file" 2>/dev/null || echo "0")
    page_breaks=$(grep -c $'\f' "$text_file" 2>/dev/null || echo "0")
    indented_sections=$(grep -cE '^\s{4,}[A-Za-z]' "$text_file" 2>/dev/null || echo "0")

    echo "$headers,$bullet_points,$form_fields,$table_indicators,$page_breaks,$indented_sections"
}

# Get basic metrics
get_basic_metrics() {
    local text_file="$1"

    local lines words chars avg_line_length
    lines=$(wc -l < "$text_file")
    words=$(wc -w < "$text_file")
    chars=$(wc -c < "$text_file")
    avg_line_length=$(awk '{sum+=length()} END {print (NR>0 ? sum/NR : 0)}' "$text_file")

    echo "$lines,$words,$chars,$avg_line_length"
}

# Advanced analysis for full level
advanced_analysis() {
    local text_file="$1"

    log_verbose "Performing advanced analysis..."

    # Extract key topics (simple keyword frequency)
    local key_topics
    key_topics=$(tr '[:upper:]' '[:lower:]' < "$text_file" | \
                tr -d '[:punct:]' | \
                tr ' ' '\n' | \
                grep -E '^[a-z]{4,}$' | \
                sort | uniq -c | sort -nr | head -10 | \
                awk '{print $2}' | tr '\n' ',' | sed 's/,$//')

    # Extract potential action items
    local action_items
    action_items=$(grep -ci '\b\(todo\|action\|complete\|implement\|fix\|update\|review\|follow.up\)\b' "$text_file" 2>/dev/null || echo "0")

    # Extract important dates (more specific patterns)
    local important_dates
    important_dates=$(grep -c '\b\(deadline\|due\|meeting\|schedule\|appointment\|quarterly\|annual\)\s*[:\-]' "$text_file" 2>/dev/null || echo "0")

    echo "$key_topics,$action_items,$important_dates"
}

# Generate JSON output
generate_json_output() {
    local pdf_file="$1"
    local output_file="$2"
    local level="$3"
    local temp_text="$4"

    local basic_metrics patterns structure_info classification language readability quality

    basic_metrics=$(get_basic_metrics "$temp_text")
    patterns=$(analyze_patterns "$temp_text")
    structure_info=$(analyze_structure "$temp_text")
    classification=$(classify_document "$temp_text")
    language=$(detect_document_language "$temp_text")
    readability=$(calculate_readability_score "$temp_text")
    quality=$(assess_extraction_quality "$temp_text")

    # Parse comma-separated values
    IFS=',' read -r lines words chars avg_line_length <<< "$basic_metrics"
    IFS=',' read -r emails phones urls dates currency percentages <<< "$patterns"
    IFS=',' read -r headers bullet_points form_fields table_indicators page_breaks indented_sections <<< "$structure_info"
    IFS=',' read -r doc_type confidence <<< "$classification"

    {
        echo "{"
        echo "  \"pdf_analysis\": {"
        echo "    \"source_file\": \"$pdf_file\","
        echo "    \"analysis_date\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\","
        echo "    \"analysis_level\": \"$level\","
        echo "    \"basic_metrics\": {"
        echo "      \"total_lines\": $lines,"
        echo "      \"total_words\": $words,"
        echo "      \"total_characters\": $chars,"
        echo "      \"average_line_length\": $avg_line_length"
        echo "    },"
        echo "    \"content_patterns\": {"
        echo "      \"emails\": $emails,"
        echo "      \"phone_numbers\": $phones,"
        echo "      \"urls\": $urls,"
        echo "      \"dates\": $dates,"
        echo "      \"currency_amounts\": $currency,"
        echo "      \"percentages\": $percentages"
        echo "    },"
        echo "    \"document_structure\": {"
        echo "      \"headers_detected\": $headers,"
        echo "      \"bullet_points\": $bullet_points,"
        echo "      \"form_fields\": $form_fields,"
        echo "      \"table_indicators\": $table_indicators,"
        echo "      \"page_breaks\": $page_breaks,"
        echo "      \"indented_sections\": $indented_sections"
        echo "    },"
        echo "    \"content_classification\": {"
        echo "      \"document_type\": \"$doc_type\","
        echo "      \"confidence_percentage\": $confidence,"
        echo "      \"detected_language\": \"$language\""
        echo "    },"
        echo "    \"quality_metrics\": {"
        echo "      \"extraction_quality\": \"$quality\","
        echo "      \"readability_score\": $readability"
        echo "    }"

        # Add advanced analysis for full level
        if [[ "$level" == "full" ]]; then
            local advanced_info
            advanced_info=$(advanced_analysis "$temp_text")
            IFS=',' read -r key_topics action_items important_dates <<< "$advanced_info"

            echo "    ,\"advanced_analysis\": {"
            echo "      \"key_topics\": \"$key_topics\","
            echo "      \"action_items_detected\": $action_items,"
            echo "      \"important_dates_found\": $important_dates"
            echo "    }"
        fi

        echo "  }"
        echo "}"
    } > "$output_file"
}

# Generate text output
generate_text_output() {
    local pdf_file="$1"
    local output_file="$2"
    local level="$3"
    local temp_text="$4"

    local basic_metrics patterns structure_info classification language readability quality

    basic_metrics=$(get_basic_metrics "$temp_text")
    patterns=$(analyze_patterns "$temp_text")
    structure_info=$(analyze_structure "$temp_text")
    classification=$(classify_document "$temp_text")
    language=$(detect_document_language "$temp_text")
    readability=$(calculate_readability_score "$temp_text")
    quality=$(assess_extraction_quality "$temp_text")

    # Parse comma-separated values
    IFS=',' read -r lines words chars avg_line_length <<< "$basic_metrics"
    IFS=',' read -r emails phones urls dates currency percentages <<< "$patterns"
    IFS=',' read -r headers bullet_points form_fields table_indicators page_breaks indented_sections <<< "$structure_info"
    IFS=',' read -r doc_type confidence <<< "$classification"

    {
        echo "PDF Content Analysis Report"
        echo "=========================="
        echo ""
        echo "Source File: $pdf_file"
        echo "Analysis Date: $(date)"
        echo "Analysis Level: $level"
        echo ""
        echo "Basic Metrics"
        echo "-------------"
        echo "Total Lines: $lines"
        echo "Total Words: $words"
        echo "Total Characters: $chars"
        printf "Average Line Length: %.1f\n" "$avg_line_length"
        echo ""
        echo "Content Patterns"
        echo "---------------"
        echo "Emails: $emails"
        echo "Phone Numbers: $phones"
        echo "URLs: $urls"
        echo "Dates: $dates"
        echo "Currency Amounts: $currency"
        echo "Percentages: $percentages"
        echo ""
        echo "Document Structure"
        echo "-----------------"
        echo "Headers Detected: $headers"
        echo "Bullet Points: $bullet_points"
        echo "Form Fields: $form_fields"
        echo "Table Indicators: $table_indicators"
        echo "Page Breaks: $page_breaks"
        echo "Indented Sections: $indented_sections"
        echo ""
        echo "Classification"
        echo "-------------"
        echo "Document Type: $doc_type"
        echo "Confidence: ${confidence}%"
        echo "Language: $language"
        echo ""
        echo "Quality Assessment"
        echo "-----------------"
        echo "Extraction Quality: $quality"
        printf "Readability Score: %.1f\n" "$readability"

        # Add advanced analysis for full level
        if [[ "$level" == "full" ]]; then
            local advanced_info
            advanced_info=$(advanced_analysis "$temp_text")
            IFS=',' read -r key_topics action_items important_dates <<< "$advanced_info"

            echo ""
            echo "Advanced Analysis"
            echo "----------------"
            echo "Key Topics: $key_topics"
            echo "Action Items Detected: $action_items"
            echo "Important Dates Found: $important_dates"
        fi
    } > "$output_file"
}

# Main execution
main() {
    log_verbose "Starting PDF content analysis: $(basename "$PDF_FILE")"

    # Extract text for analysis
    local temp_text
    temp_text=$(extract_for_analysis "$PDF_FILE")

    # Generate output based on format
    case "$FORMAT" in
        "json")
            generate_json_output "$PDF_FILE" "$OUTPUT_FILE" "$LEVEL" "$temp_text"
            validate_json_output "$OUTPUT_FILE" || {
                echo "❌ JSON validation failed" >&2
                rm -f "$temp_text"
                exit 1
            }
            ;;
        "text")
            generate_text_output "$PDF_FILE" "$OUTPUT_FILE" "$LEVEL" "$temp_text"
            ;;
        *)
            echo "Error: Unknown format: $FORMAT" >&2
            rm -f "$temp_text"
            exit 1
            ;;
    esac

    # Cleanup
    rm -f "$temp_text"

    echo "✅ Analysis complete: $OUTPUT_FILE"

    # Show brief summary
    if [[ "$FORMAT" == "json" ]]; then
        if command -v jq >/dev/null 2>&1; then
            local doc_type confidence
            doc_type=$(jq -r '.pdf_analysis.content_classification.document_type' "$OUTPUT_FILE" 2>/dev/null || echo "unknown")
            confidence=$(jq -r '.pdf_analysis.content_classification.confidence_percentage' "$OUTPUT_FILE" 2>/dev/null || echo "0")
            echo "📋 Document Type: $doc_type (${confidence}% confidence)"
        fi
    fi
}

# Run main function
main "$@"