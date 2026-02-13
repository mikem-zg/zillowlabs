## Advanced Patterns

<details>
<summary>Click to expand advanced text manipulation techniques and optimization strategies</summary>

### Advanced Multi-Step Text Processing Workflows

**Complex Text Transformation Pipelines:**
```bash
# Multi-stage text processing with intermediate validation
process_complex_text_pipeline() {
    local input="$1"
    local pipeline_config="$2"
    local output="$3"

    local temp_dir=$(mktemp -d)
    local stage_counter=0
    local current_file="$input"

    # Parse pipeline configuration
    jq -r '.stages[] | "\(.operation)|\(.parameters // "")"' "$pipeline_config" | \
    while IFS='|' read -r operation parameters; do
        stage_counter=$((stage_counter + 1))
        local stage_output="$temp_dir/stage_${stage_counter}_output"

        echo "🔄 Stage $stage_counter: $operation"

        case "$operation" in
            "extract")
                extract_patterns "$current_file" "$parameters" "csv" "$stage_output"
                ;;
            "normalize")
                normalize_text "$current_file" "$parameters" "UTF-8" "$stage_output"
                ;;
            "transform")
                transform_strings "$current_file" "$parameters" "$stage_output"
                ;;
            "filter")
                apply_content_filters "$current_file" "$parameters" "$stage_output"
                ;;
        esac

        # Validate intermediate result
        if ! validate_output_quality "$stage_output" "" "$current_file"; then
            echo "❌ Stage $stage_counter failed validation"
            rm -rf "$temp_dir"
            return 1
        fi

        current_file="$stage_output"
        echo "✅ Stage $stage_counter complete"
    done

    # Move final result to output
    mv "$current_file" "$output"
    rm -rf "$temp_dir"

    echo "🎉 Pipeline complete: $output"
}
```

**Intelligent Content Classification and Processing:**
```bash
# Advanced content analysis and classification
classify_and_process_content() {
    local input="$1"
    local classification_rules="$2"
    local output_dir="$3"

    mkdir -p "$output_dir"
    local temp_analysis=$(mktemp)

    # Analyze content characteristics
    {
        echo "Content Classification Analysis"
        echo "File: $input"
        echo "Size: $(wc -c < "$input") bytes"
        echo "Lines: $(wc -l < "$input")"
        echo "Encoding: $(detect_encoding "$input")"
        echo "Format: $(detect_format "$input")"
        echo ""

        # Content pattern analysis
        echo "Pattern Analysis:"
        echo "Emails: $(grep -cE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$input")"
        echo "URLs: $(grep -cE 'https?://[^\s<>"{}|\\^`\[\]]*' "$input")"
        echo "Phone Numbers: $(grep -cE '(\+?1[-.\s]?)?\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}' "$input")"
        echo "Dates: $(grep -cE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$input")"
        echo "IP Addresses: $(grep -cE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$input")"
        echo ""

        # Language and structure analysis
        echo "Structure Analysis:"
        echo "Code-like patterns: $(grep -cE '^\s*(function|class|def|public|private)' "$input")"
        echo "Config-like patterns: $(grep -cE '^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*[=:]' "$input")"
        echo "Log-like patterns: $(grep -cE '^\d{4}-\d{2}-\d{2}|\[.*\]|\w+:\s' "$input")"

    } > "$temp_analysis"

    # Apply classification rules and process accordingly
    jq -r '.rules[] | "\(.pattern)|\(.action)|\(.parameters // "")"' "$classification_rules" | \
    while IFS='|' read -r pattern action parameters; do
        if grep -qE "$pattern" "$temp_analysis"; then
            echo "🏷️  Matched classification: $pattern"
            case "$action" in
                "extract")
                    extract_patterns "$input" "$parameters" "json" "$output_dir/extracted_$(basename "$input").json"
                    ;;
                "normalize")
                    normalize_text "$input" "$parameters" "UTF-8" "$output_dir/normalized_$(basename "$input")"
                    ;;
                "analyze-structure")
                    analyze_content_structure "$input" "$output_dir/structure_analysis.json"
                    ;;
                "process-as-logs")
                    analyze_logs "$input" "$parameters" "" "json" "$output_dir/log_analysis.json"
                    ;;
            esac
        fi
    done

    cp "$temp_analysis" "$output_dir/classification_report.txt"
    rm -f "$temp_analysis"

    echo "📊 Content classified and processed in: $output_dir"
}
```

### Performance Optimization and Batch Processing

**High-Performance Batch Text Processing:**
```bash
# Optimized batch processing for large datasets
batch_process_optimized() {
    local input_pattern="$1"
    local operation="$2"
    local parameters="$3"
    local max_parallel="$4"

    local temp_dir=$(mktemp -d)
    local job_counter=0
    local active_jobs=0

    # Create processing job queue
    find . -path "$input_pattern" -type f > "$temp_dir/job_queue"
    local total_jobs=$(wc -l < "$temp_dir/job_queue")

    echo "🚀 Starting batch processing: $total_jobs files"
    echo "Max parallel jobs: ${max_parallel:-4}"

    # Process files in parallel with job control
    while read -r file; do
        # Wait if we're at max parallel jobs
        while [[ $active_jobs -ge ${max_parallel:-4} ]]; do
            wait -n  # Wait for any background job to complete
            active_jobs=$((active_jobs - 1))
        done

        # Start new processing job
        job_counter=$((job_counter + 1))
        active_jobs=$((active_jobs + 1))

        (
            echo "🔄 Processing file $job_counter/$total_jobs: $(basename "$file")"
            local output_file="$temp_dir/$(basename "$file").processed"

            case "$operation" in
                "normalize")
                    normalize_text "$file" "$parameters" "UTF-8" "$output_file"
                    ;;
                "extract")
                    extract_patterns "$file" "$parameters" "json" "$output_file"
                    ;;
                "transform")
                    transform_strings "$file" "$parameters" "$output_file"
                    ;;
                "analyze")
                    analyze_logs "$file" "$parameters" "" "json" "$output_file"
                    ;;
            esac

            echo "✅ Completed: $(basename "$file")"
        ) &

    done < "$temp_dir/job_queue"

    # Wait for all remaining jobs
    wait

    echo "🎉 Batch processing complete: $job_counter files processed"
    echo "Results available in: $temp_dir"
}

# Memory-efficient processing for large files
process_large_file_streaming() {
    local input="$1"
    local operation="$2"
    local parameters="$3"
    local chunk_size="${4:-10000}"

    local temp_dir=$(mktemp -d)
    local chunk_counter=0
    local total_lines=$(wc -l < "$input")

    echo "📊 Processing large file ($total_lines lines) in chunks of $chunk_size"

    # Process file in chunks to manage memory
    split -l "$chunk_size" "$input" "$temp_dir/chunk_"

    for chunk_file in "$temp_dir"/chunk_*; do
        chunk_counter=$((chunk_counter + 1))
        local chunk_output="$chunk_file.processed"

        echo "🔄 Processing chunk $chunk_counter"

        case "$operation" in
            "normalize")
                normalize_text "$chunk_file" "$parameters" "UTF-8" "$chunk_output"
                ;;
            "extract")
                extract_patterns "$chunk_file" "$parameters" "csv" "$chunk_output"
                ;;
            "analyze")
                analyze_logs "$chunk_file" "$parameters" "" "json" "$chunk_output"
                ;;
        esac
    done

    # Combine results
    case "$operation" in
        "normalize"|"extract")
            cat "$temp_dir"/*.processed > "$input.final_output"
            ;;
        "analyze")
            # Merge JSON analysis results
            jq -s 'add' "$temp_dir"/*.processed > "$input.analysis.json"
            ;;
    esac

    rm -rf "$temp_dir"
    echo "✅ Large file processing complete"
}
```

### Advanced Integration and Workflow Automation

**Smart Workflow Integration with External Tools:**
```bash
# Intelligent integration with development workflows
integrate_with_development_workflow() {
    local workflow_type="$1"
    local input_sources="$2"
    local integration_config="$3"

    case "$workflow_type" in
        "ci-cd-logs")
            # Process CI/CD pipeline logs for integration
            for log_source in $input_sources; do
                echo "🔄 Processing CI/CD logs: $log_source"

                # Extract build information
                extract_patterns "$log_source" "Build.*\d+,Test.*passed|failed,Deploy.*\w+" "json" "build_info.json"

                # Analyze failure patterns
                analyze_logs "$log_source" "FAILED\|ERROR\|Exception" "last-build" "markdown" "failure_report.md"

                # Generate metrics for dashboard
                {
                    echo "build_duration:$(extract_build_duration "$log_source")"
                    echo "test_count:$(count_test_results "$log_source")"
                    echo "error_count:$(count_errors "$log_source")"
                } > "build_metrics.properties"
            done
            ;;

        "application-monitoring")
            # Process application logs for monitoring integration
            for app_log in $input_sources; do
                echo "🔄 Processing application logs: $app_log"

                # Real-time error detection
                analyze_logs "$app_log" "severity>=ERROR" "last-hour" "json" "current_errors.json"

                # Performance metrics extraction
                extract_patterns "$app_log" "response_time:\d+ms,memory_usage:\d+MB" "csv" "performance_metrics.csv"

                # Alert condition detection
                if grep -q "CRITICAL\|FATAL" "$app_log"; then
                    echo "🚨 Critical alerts detected, triggering notification workflow"
                    extract_patterns "$app_log" "CRITICAL.*|FATAL.*" "json" "critical_alerts.json"
                fi
            done
            ;;

        "data-processing-pipeline")
            # Integration with data processing workflows
            for data_file in $input_sources; do
                echo "🔄 Processing data file: $data_file"

                # Data quality assessment
                analyze_data_quality "$data_file" > "data_quality_report.json"

                # Format conversion for downstream processing
                local format=$(detect_format "$data_file")
                if [[ "$format" != "json-like" ]]; then
                    export_to_structured "$data_file" "json" "$(basename "$data_file" | cut -d. -f1).json"
                fi

                # Extract metadata for cataloging
                extract_data_metadata "$data_file" > "metadata.json"
            done
            ;;
    esac
}
```

**Advanced Error Recovery and Resilience:**
```bash
# Robust error handling and recovery mechanisms
process_with_error_recovery() {
    local operation="$1"
    local input="$2"
    local parameters="$3"
    local max_retries="${4:-3}"

    local attempt=1
    local success=false
    local temp_dir=$(mktemp -d)

    while [[ $attempt -le $max_retries ]] && [[ "$success" == "false" ]]; do
        echo "🔄 Attempt $attempt/$max_retries: $operation"

        # Create checkpoint before processing
        cp "$input" "$temp_dir/checkpoint_$attempt"

        case "$operation" in
            "normalize")
                if normalize_text "$input" "$parameters" "UTF-8" "$temp_dir/result_$attempt"; then
                    success=true
                    cp "$temp_dir/result_$attempt" "$input.processed"
                fi
                ;;
            "extract")
                if extract_patterns "$input" "$parameters" "json" "$temp_dir/result_$attempt"; then
                    success=true
                    cp "$temp_dir/result_$attempt" "$input.extracted.json"
                fi
                ;;
            "analyze")
                if analyze_logs "$input" "$parameters" "" "json" "$temp_dir/result_$attempt"; then
                    success=true
                    cp "$temp_dir/result_$attempt" "$input.analysis.json"
                fi
                ;;
        esac

        if [[ "$success" == "false" ]]; then
            echo "⚠️  Attempt $attempt failed, trying recovery strategies..."

            # Recovery strategies
            case $attempt in
                1)
                    # Try with more conservative parameters
                    parameters=$(echo "$parameters" | sed 's/strict/lenient/g')
                    ;;
                2)
                    # Try processing smaller chunks
                    if [[ $(wc -l < "$input") -gt 1000 ]]; then
                        head -1000 "$input" > "$temp_dir/reduced_input"
                        input="$temp_dir/reduced_input"
                    fi
                    ;;
                3)
                    # Final attempt with minimal processing
                    parameters="basic"
                    ;;
            esac

            attempt=$((attempt + 1))
            sleep $((attempt * 2))  # Exponential backoff
        fi
    done

    if [[ "$success" == "true" ]]; then
        echo "✅ Operation succeeded after $attempt attempts"
        rm -rf "$temp_dir"
        return 0
    else
        echo "❌ Operation failed after $max_retries attempts"
        # Preserve failure state for debugging
        echo "Debug information preserved in: $temp_dir"
        return 1
    fi
}
```

</details>

