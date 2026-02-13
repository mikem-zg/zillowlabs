#!/bin/bash

# MCP Failure Diagnosis Script
# Analyze failure patterns and provide actionable recommendations

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# Default values
ANALYSIS_HOURS=24
OUTPUT_FORMAT="text"
SERVER_NAME=""
DETAILED=false

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Analyze MCP server failure patterns and provide recommendations

OPTIONS:
    -p, --period <hours>    Analysis period in hours (default: 24)
    -s, --server <name>     Analyze specific server only
    -f, --format <format>   Output format: text, json (default: text)
    -d, --detailed         Show detailed failure analysis
    -h, --help             Show this help message

EXAMPLES:
    $0                              # Analyze last 24 hours
    $0 --period 72                 # Analyze last 3 days
    $0 --server atlassian          # Focus on specific server
    $0 --detailed --format json    # Detailed JSON output
EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--period)
                ANALYSIS_HOURS="$2"
                shift 2
                ;;
            -s|--server)
                SERVER_NAME="$2"
                shift 2
                ;;
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -d|--detailed)
                DETAILED=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

# Extract failure timeline from debug logs
extract_failure_timeline() {
    local period_hours="$1"
    local server_filter="$2"
    local timeline_file="/tmp/mcp_failure_timeline_$$.csv"

    if [[ ! -f "$DEBUG_LOG_PATH" ]]; then
        log_error "Debug log not found: $DEBUG_LOG_PATH"
        return 1
    fi

    # Calculate since time
    local since_time
    if command -v gdate >/dev/null 2>&1; then
        since_time=$(gdate -d "$period_hours hours ago" "+%Y-%m-%dT%H:%M:%S")
    elif date -d "$period_hours hours ago" >/dev/null 2>&1; then
        since_time=$(date -d "$period_hours hours ago" "+%Y-%m-%dT%H:%M:%S")
    else
        # Fallback for macOS
        since_time=$(date -v-${period_hours}H "+%Y-%m-%dT%H:%M:%S")
    fi

    # Extract failure events
    grep -E "MCP server.*Failed|Error.*MCP|timeout.*MCP|Filtering out tool_reference" "$DEBUG_LOG_PATH" | \
    awk -v since="$since_time" -v server_filter="$server_filter" '
        $1 " " $2 >= since {
            # Extract timestamp, server name, and error type
            timestamp = $1 " " $2
            server = ""
            error_type = ""

            if (match($0, /MCP server "([^"]+)"/, server_match)) {
                server = server_match[1]
            } else if (match($0, /mcp__([^_]+)__/, server_match)) {
                server = server_match[1]
            }

            if (match($0, /(Failed|Error|timeout|Filtering)/, error_match)) {
                error_type = error_match[1]
            }

            # Apply server filter if specified
            if (server_filter == "" || server == server_filter) {
                if (server != "" && error_type != "") {
                    print timestamp "," server "," error_type "," $0
                }
            }
        }
    ' > "$timeline_file"

    echo "$timeline_file"
}

# Analyze failure frequency by server
analyze_failure_frequency() {
    local timeline_file="$1"
    local period_hours="$2"

    if [[ ! -s "$timeline_file" ]]; then
        return 0
    fi

    # Count failures per server
    awk -F',' '{print $2}' "$timeline_file" | sort | uniq -c | sort -rn | \
    while read count server; do
        local failure_rate
        failure_rate=$(echo "scale=2; $count / $period_hours" | bc -l 2>/dev/null || echo "0")

        local risk_level="low"
        if (( $(echo "$failure_rate > 1.0" | bc -l 2>/dev/null || echo "0") )); then
            risk_level="high"
        elif (( $(echo "$failure_rate > 0.5" | bc -l 2>/dev/null || echo "0") )); then
            risk_level="medium"
        fi

        echo "$server,$count,$failure_rate,$risk_level"
    done
}

# Analyze error patterns
analyze_error_patterns() {
    local timeline_file="$1"

    if [[ ! -s "$timeline_file" ]]; then
        return 0
    fi

    # Most common error types
    echo "=== Most Common Error Types ==="
    awk -F',' '{print $3}' "$timeline_file" | sort | uniq -c | sort -rn | head -10

    echo
    echo "=== Error Types by Server ==="
    awk -F',' '{print $2 ":" $3}' "$timeline_file" | sort | uniq -c | sort -rn | head -15
}

# Generate recommendations based on analysis
generate_recommendations() {
    local timeline_file="$1"
    local period_hours="$2"

    if [[ ! -s "$timeline_file" ]]; then
        echo "No failures detected in the last $period_hours hours"
        return 0
    fi

    echo "=== Recommendations ==="

    # Analyze high-frequency failures
    analyze_failure_frequency "$timeline_file" "$period_hours" | \
    while IFS=',' read server count rate risk; do
        case "$risk" in
            "high")
                echo "🚨 URGENT: $server has $count failures ($rate/hr) - immediate restart recommended"
                echo "   Action: /mcp-server-management --operation=restart-server --server_name=$server"
                ;;
            "medium")
                echo "⚠️  WARNING: $server has $count failures ($rate/hr) - monitor closely"
                echo "   Action: /mcp-server-management --operation=health-check --server_name=$server"
                ;;
            "low")
                if [[ $count -gt 1 ]]; then
                    echo "ℹ️  INFO: $server has $count failures ($rate/hr) - normal monitoring"
                fi
                ;;
        esac
    done

    # Specific error pattern recommendations
    echo
    echo "=== Specific Issue Recommendations ==="

    # Check for DNS resolution issues
    if grep -q "ENOTFOUND" "$timeline_file"; then
        echo "🌐 Network/DNS Issues Detected:"
        echo "   - Check internet connectivity"
        echo "   - Verify DNS resolution for MCP endpoints"
        echo "   - Consider using fallback mechanisms"
    fi

    # Check for authentication issues
    if grep -q -E "401|403|Unauthorized|Forbidden" "$timeline_file"; then
        echo "🔐 Authentication Issues Detected:"
        echo "   - Refresh authentication tokens"
        echo "   - Verify API keys and credentials"
        echo "   - Check access permissions"
    fi

    # Check for timeout patterns
    local timeout_count=$(grep -c "timeout" "$timeline_file" 2>/dev/null || echo "0")
    if [[ $timeout_count -gt 5 ]]; then
        echo "⏱️  Excessive Timeouts Detected ($timeout_count):"
        echo "   - Network latency issues possible"
        echo "   - Consider increasing timeout values"
        echo "   - Check server load and performance"
    fi

    # Check for tool filtering warnings
    local filtering_count=$(grep -c "Filtering out tool_reference" "$timeline_file" 2>/dev/null || echo "0")
    if [[ $filtering_count -gt 3 ]]; then
        echo "🔧 Tool Availability Issues Detected ($filtering_count):"
        echo "   - MCP servers may be partially functional"
        echo "   - Consider server restart to restore full functionality"
        echo "   - Use fallback mechanisms for affected operations"
    fi
}

# Generate JSON report
generate_json_report() {
    local timeline_file="$1"
    local period_hours="$2"

    local total_failures
    total_failures=$(wc -l < "$timeline_file" 2>/dev/null || echo "0")

    echo "{"
    echo "  \"analysis_period_hours\": $period_hours,"
    echo "  \"total_failures\": $total_failures,"
    echo "  \"generated_at\": \"$(date -Iseconds)\","

    # Server failure summary
    echo "  \"servers\": {"
    local first_server=true

    analyze_failure_frequency "$timeline_file" "$period_hours" | \
    while IFS=',' read server count rate risk; do
        if [[ "$first_server" == "true" ]]; then
            first_server=false
        else
            echo ","
        fi

        # Get most common error types for this server
        local common_errors
        common_errors=$(grep ",$server," "$timeline_file" | \
            awk -F',' '{print $3}' | sort | uniq -c | sort -rn | head -3 | \
            awk '{printf "\"%s\":%d", $2, $1}' | sed 's/$/,/g' | sed 's/,$//')

        cat << EOF
    "$server": {
      "failure_count": $count,
      "failure_rate_per_hour": $rate,
      "risk_level": "$risk",
      "common_errors": { $common_errors },
      "recommendation": "$(
        case "$risk" in
          "high") echo "Immediate restart required" ;;
          "medium") echo "Monitor closely, consider restart" ;;
          "low") echo "Normal monitoring sufficient" ;;
        esac
      )"
    }
EOF
    done

    echo "  },"

    # Error pattern analysis
    echo "  \"error_patterns\": {"
    echo "    \"dns_issues\": $(grep -q "ENOTFOUND" "$timeline_file" && echo "true" || echo "false"),"
    echo "    \"auth_issues\": $(grep -q -E "401|403|Unauthorized|Forbidden" "$timeline_file" && echo "true" || echo "false"),"
    echo "    \"timeout_count\": $(grep -c "timeout" "$timeline_file" 2>/dev/null || echo "0"),"
    echo "    \"tool_filtering_count\": $(grep -c "Filtering out tool_reference" "$timeline_file" 2>/dev/null || echo "0")"
    echo "  }"

    echo "}"
}

# Show detailed failure analysis
show_detailed_analysis() {
    local timeline_file="$1"
    local period_hours="$2"

    if [[ ! -s "$timeline_file" ]]; then
        log_info "No failures found in the last $period_hours hours"
        return 0
    fi

    echo "=== Detailed Failure Analysis ==="
    echo "Analysis period: $period_hours hours"
    echo "Total failures: $(wc -l < "$timeline_file")"
    echo

    # Failure timeline (recent failures first)
    echo "=== Recent Failures (last 10) ==="
    tail -10 "$timeline_file" | \
    while IFS=',' read timestamp server error_type full_message; do
        echo "[$timestamp] $server: $error_type"
        if [[ "$DETAILED" == "true" ]]; then
            echo "  Details: $full_message"
        fi
    done

    echo
    analyze_error_patterns "$timeline_file"

    echo
    echo "=== Failure Frequency by Hour ==="
    awk -F',' '{print $1}' "$timeline_file" | \
    awk '{print substr($0, 1, 13)}' | sort | uniq -c | sort -rn | head -10 | \
    while read count hour; do
        echo "$hour: $count failures"
    done
}

# Main analysis function
main() {
    parse_args "$@"

    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi

    log_info "MCP Failure Diagnosis"
    log_info "Analysis period: $ANALYSIS_HOURS hours"
    if [[ -n "$SERVER_NAME" ]]; then
        log_info "Server filter: $SERVER_NAME"
    fi
    echo

    # Extract failure timeline
    local timeline_file
    timeline_file=$(extract_failure_timeline "$ANALYSIS_HOURS" "$SERVER_NAME")

    if [[ ! -f "$timeline_file" ]]; then
        log_error "Failed to extract failure timeline"
        exit 1
    fi

    # Generate output based on format
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        generate_json_report "$timeline_file" "$ANALYSIS_HOURS"
    else
        # Text output
        if [[ "$DETAILED" == "true" ]]; then
            show_detailed_analysis "$timeline_file" "$ANALYSIS_HOURS"
            echo
        fi

        # Show failure frequency analysis
        local failure_analysis
        failure_analysis=$(analyze_failure_frequency "$timeline_file" "$ANALYSIS_HOURS")

        if [[ -n "$failure_analysis" ]]; then
            echo "=== Server Failure Summary ==="
            echo "Server                 Failures  Rate/hr  Risk Level"
            echo "----------------------------------------------------"
            echo "$failure_analysis" | \
            while IFS=',' read server count rate risk; do
                printf "%-20s %8s %8s  %s\n" "$server" "$count" "$rate" "$risk"
            done
            echo
        fi

        # Generate recommendations
        generate_recommendations "$timeline_file" "$ANALYSIS_HOURS"

        # Show fallback options for failed servers
        echo
        echo "=== Available Fallback Options ==="
        if [[ -n "$SERVER_NAME" ]]; then
            suggest_fallback "$SERVER_NAME"
        else
            analyze_failure_frequency "$timeline_file" "$ANALYSIS_HOURS" | \
            while IFS=',' read server count rate risk; do
                if [[ "$risk" != "low" ]]; then
                    echo
                    echo "Fallbacks for $server:"
                    suggest_fallback "$server" | sed 's/^/  /'
                fi
            done
        fi
    fi

    # Cleanup
    rm -f "$timeline_file"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi