#!/bin/bash
# PDF Processing Utility Functions
# Shared functions for PDF processing scripts

# Validate PDF input file
validate_pdf_input() {
    local pdf_file="$1"

    # Check file exists and is readable
    if [[ ! -r "$pdf_file" ]]; then
        echo "❌ PDF file not readable: $pdf_file" >&2
        return 1
    fi

    # Check file extension
    if [[ ! "$pdf_file" =~ \.(pdf|PDF)$ ]]; then
        echo "❌ File does not appear to be a PDF: $pdf_file" >&2
        return 1
    fi

    # Test PDF validity by attempting info extraction
    if ! pdftotext -f 1 -l 1 "$pdf_file" /dev/null 2>/dev/null; then
        echo "❌ PDF file appears to be corrupted or encrypted: $pdf_file" >&2
        echo "   If encrypted, decrypt manually before processing" >&2
        return 1
    fi

    return 0
}

# Check if pdftotext is available
check_pdftotext_available() {
    if ! command -v pdftotext >/dev/null 2>&1; then
        echo "❌ pdftotext utility not found" >&2
        echo "" >&2
        echo "Install Poppler package:" >&2
        echo "  macOS:        brew install poppler" >&2
        echo "  Ubuntu:       sudo apt-get install poppler-utils" >&2
        echo "  CentOS/RHEL:  sudo yum install poppler-utils" >&2
        echo "" >&2
        echo "Documentation: https://poppler.freedesktop.org/" >&2
        return 1
    fi

    return 0
}

# Assess extraction quality
assess_extraction_quality() {
    local text_file="$1"

    if [[ ! -r "$text_file" ]]; then
        echo "unknown"
        return 1
    fi

    local quality="good"
    local total_lines
    total_lines=$(wc -l < "$text_file")
    local garbled_lines
    garbled_lines=$(grep -c '[^[:print:][:space:]]' "$text_file" 2>/dev/null || echo "0")

    if [[ $total_lines -eq 0 ]]; then
        quality="failed"
    elif [[ $garbled_lines -gt $((total_lines / 4)) ]]; then
        quality="poor"
    elif [[ $garbled_lines -gt $((total_lines / 10)) ]]; then
        quality="fair"
    fi

    echo "$quality"
}

# Detect document language (simple heuristic)
detect_document_language() {
    local text_file="$1"

    local english_words
    english_words=$(grep -ci '\b\(the\|and\|for\|are\|but\|not\|you\|all\|can\|had\|her\|was\|one\|our\|out\|day\)\b' "$text_file" 2>/dev/null || echo "0")
    local total_words
    total_words=$(wc -w < "$text_file")

    if [[ $total_words -gt 0 ]]; then
        local english_ratio
        english_ratio=$(awk "BEGIN {print ($english_words/$total_words)}")
        if (( $(echo "$english_ratio > 0.1" | bc -l 2>/dev/null || echo "0") )); then
            echo "english"
        else
            echo "other"
        fi
    else
        echo "unknown"
    fi
}

# Calculate readability score (simplified)
calculate_readability_score() {
    local text_file="$1"

    local sentences
    sentences=$(grep -co '[.!?]' "$text_file" 2>/dev/null || echo "1")
    local words
    words=$(wc -w < "$text_file")
    local characters
    characters=$(wc -c < "$text_file")

    if [[ $sentences -gt 0 ]] && [[ $words -gt 0 ]]; then
        # Simplified readability calculation
        local avg_sentence_length
        avg_sentence_length=$(awk "BEGIN {print ($words/$sentences)}")
        local avg_word_length
        avg_word_length=$(awk "BEGIN {print ($characters/$words)}")

        # Score based on sentence and word length (lower is more readable)
        local score
        score=$(awk "BEGIN {print (100 - ($avg_sentence_length * 2) - ($avg_word_length * 5))}" 2>/dev/null || echo "50")
        printf "%.1f" "$score"
    else
        echo "0.0"
    fi
}

# Extract key patterns from text
extract_pattern() {
    local text_file="$1"
    local pattern_name="$2"

    case "$pattern_name" in
        "email")
            grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$text_file"
            ;;
        "phone")
            grep -oE '(\+?1[-.\s]?)?\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}' "$text_file"
            ;;
        "url")
            grep -oE 'https?://[^\s<>"{}|\\^`\[\]]*' "$text_file"
            ;;
        "date-iso")
            grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$text_file"
            ;;
        "date-us")
            grep -oE '[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}' "$text_file"
            ;;
        "currency")
            grep -oE '\$[0-9,]+\.?[0-9]*' "$text_file"
            ;;
        "percentage")
            grep -oE '[0-9]+\.?[0-9]*%' "$text_file"
            ;;
        *)
            # Treat as custom regex pattern
            grep -oE "$pattern_name" "$text_file"
            ;;
    esac
}

# Classify document type based on content
classify_document() {
    local text_file="$1"

    local doc_type="unknown"
    local confidence=0

    if grep -qi "performance\|review\|evaluation\|feedback\|annual\|quarterly" "$text_file"; then
        doc_type="performance_review"
        confidence=85
    elif grep -qi "contract\|agreement\|terms\|conditions\|legal" "$text_file"; then
        doc_type="legal_document"
        confidence=80
    elif grep -qi "invoice\|receipt\|payment\|billing\|statement" "$text_file"; then
        doc_type="financial_document"
        confidence=90
    elif grep -qi "report\|analysis\|findings\|summary\|executive" "$text_file"; then
        doc_type="report"
        confidence=75
    elif grep -qi "manual\|instruction\|guide\|procedure\|documentation" "$text_file"; then
        doc_type="documentation"
        confidence=70
    elif grep -qi "proposal\|plan\|strategy\|roadmap" "$text_file"; then
        doc_type="planning_document"
        confidence=75
    fi

    echo "$doc_type,$confidence"
}

# Create JSON output structure
create_json_output() {
    local output_file="$1"
    shift
    local key_value_pairs=("$@")

    {
        echo "{"
        local first=true
        for pair in "${key_value_pairs[@]}"; do
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo ","
            fi
            local key="${pair%%:*}"
            local value="${pair#*:}"
            echo "  \"$key\": \"$value\""
        done
        echo "}"
    } > "$output_file"
}

# Validate JSON output
validate_json_output() {
    local json_file="$1"

    if command -v jq >/dev/null 2>&1; then
        if ! jq empty "$json_file" 2>/dev/null; then
            echo "❌ Invalid JSON output: $json_file" >&2
            return 1
        fi
    else
        # Basic validation without jq
        if ! python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
            echo "❌ Invalid JSON output: $json_file" >&2
            return 1
        fi
    fi

    return 0
}

# Create CSV header and validate format
create_csv_output() {
    local output_file="$1"
    local headers="$2"
    shift 2
    local data_lines=("$@")

    echo "$headers" > "$output_file"
    for line in "${data_lines[@]}"; do
        echo "$line" >> "$output_file"
    done
}

# Log with timestamp
log_with_timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Check available disk space
check_disk_space() {
    local output_dir="$1"
    local required_mb="${2:-100}"  # Default 100MB

    if ! df -m "$output_dir" >/dev/null 2>&1; then
        echo "⚠️  Cannot check disk space for: $output_dir" >&2
        return 1
    fi

    local available_mb
    available_mb=$(df -m "$output_dir" | tail -1 | awk '{print $4}')

    if [[ $available_mb -lt $required_mb ]]; then
        echo "❌ Insufficient disk space: ${available_mb}MB available, ${required_mb}MB required" >&2
        return 1
    fi

    return 0
}

# Create backup of file if it exists
create_backup() {
    local file_path="$1"

    if [[ -f "$file_path" ]]; then
        local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file_path" "$backup_path"
        echo "🛡️  Backup created: $backup_path" >&2
    fi
}

# Clean up temporary files
cleanup_temp_files() {
    local temp_pattern="$1"

    if [[ -n "$temp_pattern" ]]; then
        rm -f $temp_pattern 2>/dev/null || true
    fi
}

# Progress indicator for long operations
show_progress() {
    local current="$1"
    local total="$2"
    local description="$3"

    local percentage=$((current * 100 / total))
    local progress_bar=""
    local completed=$((percentage / 5))
    local remaining=$((20 - completed))

    for ((i=0; i<completed; i++)); do
        progress_bar+="█"
    done
    for ((i=0; i<remaining; i++)); do
        progress_bar+="░"
    done

    printf "\r🔄 %s: [%s] %d%% (%d/%d)" "$description" "$progress_bar" "$percentage" "$current" "$total"

    if [[ $current -eq $total ]]; then
        echo ""  # New line when complete
    fi
}