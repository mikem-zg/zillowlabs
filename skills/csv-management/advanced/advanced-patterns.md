## Advanced Patterns

### Complex Data Processing Pipelines

#### Multi-Stage Data Analysis Workflows
```bash
# Comprehensive sales analysis pipeline
analyze_sales_performance() {
    local input_file="$1"
    local output_dir="$2"

    # Stage 1: Data cleaning and preparation
    mlr --csv --from "$input_file" \
        filter 'NF == 8' \
        then put 'if ($amount == "") {$amount = "0"}' \
        then put '$amount = float($amount)' \
        then filter '$amount >= 0' \
        then uniq -a > "$output_dir/clean_data.csv"

    # Stage 2: Time-based aggregation
    mlr --csv --from "$output_dir/clean_data.csv" \
        put '$month = strftime(strptime($date, "%Y-%m-%d"), "%Y-%m")' \
        then stats1 -a sum,mean,count -f amount -g month,region \
        then sort -f month > "$output_dir/monthly_summary.csv"

    # Stage 3: Performance ranking and insights
    mlr --csv --from "$output_dir/monthly_summary.csv" \
        put '$performance_score = $amount_sum / $amount_count' \
        then top -n 10 -f performance_score \
        then put '$rank = NR' > "$output_dir/top_performers.csv"
}
```

#### Advanced Data Joining and Enrichment
```bash
# Multi-table data enrichment workflow
enrich_customer_data() {
    local customers="$1"
    local orders="$2"
    local products="$3"
    local output="$4"

    # Create temporary enriched dataset
    temp_dir=$(mktemp -d)

    # Stage 1: Customer-Order join with aggregation
    mlr --csv join -j customer_id -f "$orders" "$customers" \
        | mlr --csv stats1 -a sum,count,mean -f order_amount -g customer_id \
        > "$temp_dir/customer_metrics.csv"

    # Stage 2: Add product category insights
    mlr --csv join -j product_id -f "$products" "$orders" \
        | mlr --csv stats1 -a count -f product_id -g customer_id,category \
        | mlr --csv reshape -s category,product_id_count \
        > "$temp_dir/category_preferences.csv"

    # Stage 3: Final enrichment join
    mlr --csv join -j customer_id -f "$temp_dir/category_preferences.csv" \
        "$temp_dir/customer_metrics.csv" \
        > "$output"

    rm -rf "$temp_dir"
}
```

### Large-Scale Data Processing

#### Memory-Efficient Processing for Big Data
```bash
# Process files too large for memory
process_large_dataset() {
    local input_file="$1"
    local chunk_size=100000
    local temp_dir=$(mktemp -d)

    # Split large file into manageable chunks
    total_lines=$(wc -l < "$input_file")
    header=$(head -n 1 "$input_file")

    for ((start=2; start<=total_lines; start+=chunk_size)); do
        end=$((start + chunk_size - 1))
        chunk_file="$temp_dir/chunk_$(printf "%05d" $start).csv"

        # Add header to each chunk
        echo "$header" > "$chunk_file"
        sed -n "${start},${end}p" "$input_file" >> "$chunk_file"

        # Process chunk independently
        process_chunk "$chunk_file" "$temp_dir/processed_$(printf "%05d" $start).csv" &

        # Limit concurrent processes
        (($(jobs -r | wc -l) >= 4)) && wait
    done

    wait  # Wait for all background jobs to complete

    # Combine results
    combine_processed_chunks "$temp_dir" "final_output.csv"
    rm -rf "$temp_dir"
}

process_chunk() {
    local input="$1"
    local output="$2"

    mlr --csv --from "$input" \
        filter '$status == "active"' \
        then put '$processed_date = strftime(systime(), "%Y-%m-%d")' \
        then stats1 -a sum,count -f amount -g category \
        > "$output"
}
```

#### Streaming Data Processing
```bash
# Real-time CSV stream processing
process_csv_stream() {
    local named_pipe="$1"
    local output_dir="$2"

    # Set up named pipe for streaming data
    mkfifo "$named_pipe" 2>/dev/null || true

    # Process stream with sliding window analysis
    tail -f "$named_pipe" | \
    mlr --csv --implicit-csv-header \
        put '$timestamp = systime()' \
        then put '$window = int($timestamp / 300)' \
        then stats1 -a sum,count,mean -f value -g window \
        then put 'if ($window != @last_window) {print > "'"$output_dir"'/window_" . $window . ".csv"; @last_window = $window}'
}
```

### Advanced Analytics and Data Science Integration

#### Statistical Analysis and Correlation
```bash
# Advanced statistical analysis pipeline
perform_correlation_analysis() {
    local dataset="$1"
    local target_variable="$2"
    local output_report="$3"

    # Calculate correlations with target variable
    temp_file=$(mktemp)

    # Extract numeric columns for correlation analysis
    numeric_columns=$(mlr --csv --from "$dataset" \
        put 'for (k,v in $*) {if (typeof(v) == "float" || typeof(v) == "int") print k}' \
        | head -n 1 | tr ' ' '\n' | grep -v "$target_variable")

    echo "variable,correlation,p_value,sample_size" > "$temp_file"

    for column in $numeric_columns; do
        correlation=$(mlr --csv --from "$dataset" \
            stats2 -a corr -f "$column","$target_variable" | \
            mlr --csv cut -f "${column}_${target_variable}_corr")

        echo "${column},${correlation},0.05,$(mlr --csv count "$dataset")" >> "$temp_file"
    done

    # Rank by correlation strength
    mlr --csv --from "$temp_file" \
        put '$abs_correlation = abs($correlation)' \
        then sort -nr abs_correlation \
        then put '$rank = NR' \
        > "$output_report"
}
```

#### Time Series Analysis and Forecasting
```bash
# Time series decomposition and trend analysis
analyze_time_series() {
    local timeseries_data="$1"
    local date_column="$2"
    local value_column="$3"
    local output_dir="$4"

    # Prepare time series data
    mlr --csv --from "$timeseries_data" \
        put '$timestamp = strptime($'"$date_column"', "%Y-%m-%d")' \
        then sort -n timestamp \
        then put '$day_of_week = strftime($timestamp, "%w")' \
        then put '$month = strftime($timestamp, "%m")' \
        > "$output_dir/prepared_timeseries.csv"

    # Calculate rolling averages and trends
    mlr --csv --from "$output_dir/prepared_timeseries.csv" \
        put 'begin {@window = []} {
            @window = [@window, $'"$value_column"'];
            if (length(@window) > 7) {@window = @window[2:]};
            $rolling_7day = avg(@window)
        }' \
        then put '$trend = $'"$value_column"' - $rolling_7day' \
        > "$output_dir/trend_analysis.csv"

    # Seasonal decomposition
    for season in "day_of_week" "month"; do
        mlr --csv --from "$output_dir/trend_analysis.csv" \
            stats1 -a mean,stddev -f "$value_column" -g "$season" \
            > "$output_dir/seasonal_${season}.csv"
    done
}
```

### Data Quality and Validation Automation

#### Comprehensive Data Quality Assessment
```bash
# Automated data quality report generation
generate_data_quality_report() {
    local input_file="$1"
    local report_file="$2"

    temp_dir=$(mktemp -d)

    # Basic data profiling
    mlr --csv count "$input_file" > "$temp_dir/row_count.txt"
    mlr --csv --from "$input_file" put '$1=""' | head -1 | tr ',' '\n' | wc -l > "$temp_dir/column_count.txt"

    # Missing value analysis
    column_names=$(mlr --csv --from "$input_file" put '$1=""' | head -1 | tr ',' '\n')
    echo "column,missing_count,missing_percentage" > "$temp_dir/missing_analysis.csv"

    for column in $column_names; do
        missing_count=$(mlr --csv filter '$'"$column"' == ""' "$input_file" | mlr --csv count)
        total_count=$(mlr --csv count "$input_file")
        missing_pct=$(echo "scale=2; $missing_count * 100 / $total_count" | bc)
        echo "$column,$missing_count,$missing_pct%" >> "$temp_dir/missing_analysis.csv"
    done

    # Data type validation
    echo "column,expected_type,violations,violation_percentage" > "$temp_dir/type_validation.csv"

    # Duplicate detection
    mlr --csv uniq -c "$input_file" | mlr --csv filter '$count > 1' > "$temp_dir/duplicates.csv"

    # Generate comprehensive report
    {
        echo "# Data Quality Report"
        echo "Generated: $(date)"
        echo ""
        echo "## Summary Statistics"
        echo "- Total Rows: $(cat "$temp_dir/row_count.txt")"
        echo "- Total Columns: $(cat "$temp_dir/column_count.txt")"
        echo "- Duplicates Found: $(mlr --csv count "$temp_dir/duplicates.csv")"
        echo ""
        echo "## Missing Value Analysis"
        mlr --csv --ots cat "$temp_dir/missing_analysis.csv"
        echo ""
        echo "## Duplicate Records"
        mlr --csv --ots head -n 10 "$temp_dir/duplicates.csv"
    } > "$report_file"

    rm -rf "$temp_dir"
}
```

### Integration with External Systems and APIs

#### Database Integration Patterns
```bash
# CSV to database sync with conflict resolution
sync_csv_to_database() {
    local csv_file="$1"
    local table_name="$2"
    local primary_key="$3"
    local conflict_resolution="$4"  # merge, overwrite, skip

    temp_dir=$(mktemp -d)

    # Prepare data for database insert
    mlr --csv --from "$csv_file" \
        put '$sync_timestamp = strftime(systime(), "%Y-%m-%d %H:%M:%S")' \
        then put '$checksum = md5(joinv($*, ""))' \
        > "$temp_dir/prepared_data.csv"

    case "$conflict_resolution" in
        "merge")
            # Generate UPSERT statements
            mlr --csv --from "$temp_dir/prepared_data.csv" \
                put '$sql = "INSERT INTO '"$table_name"' (...) VALUES (...) ON DUPLICATE KEY UPDATE ..."' \
                > "$temp_dir/upsert_statements.sql"
            ;;
        "overwrite")
            # Generate DELETE + INSERT statements
            mlr --csv --from "$temp_dir/prepared_data.csv" \
                put '$sql = "REPLACE INTO '"$table_name"' (...) VALUES (...)"' \
                > "$temp_dir/replace_statements.sql"
            ;;
        "skip")
            # Generate INSERT IGNORE statements
            mlr --csv --from "$temp_dir/prepared_data.csv" \
                put '$sql = "INSERT IGNORE INTO '"$table_name"' (...) VALUES (...)"' \
                > "$temp_dir/insert_statements.sql"
            ;;
    esac

    # Execute via database operations skill
    /database-operations --operation="batch_execute" --sql_file="$temp_dir/*.sql"

    rm -rf "$temp_dir"
}
```

#### API Integration and Data Exchange
```bash
# CSV data exchange with REST APIs
exchange_csv_with_api() {
    local csv_file="$1"
    local api_endpoint="$2"
    local auth_token="$3"
    local batch_size=100

    temp_dir=$(mktemp -d)

    # Split CSV into API-friendly batches
    total_rows=$(mlr --csv count "$csv_file")
    header=$(head -n 1 "$csv_file")

    for ((start=2; start<=total_rows; start+=batch_size)); do
        end=$((start + batch_size - 1))
        batch_file="$temp_dir/batch_$start.csv"

        echo "$header" > "$batch_file"
        sed -n "${start},${end}p" "$csv_file" >> "$batch_file"

        # Convert to JSON for API submission
        mlr --icsv --ojson cat "$batch_file" > "$temp_dir/batch_$start.json"

        # Submit to API with retry logic
        submit_batch_to_api "$temp_dir/batch_$start.json" "$api_endpoint" "$auth_token" &
    done

    wait  # Wait for all API calls to complete

    # Aggregate API responses
    combine_api_responses "$temp_dir" "$csv_file.results.csv"
    rm -rf "$temp_dir"
}
```

