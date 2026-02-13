#!/bin/bash

# Error Pattern Analysis for MCP Server Management
# Analyzes error patterns and provides insights for improving error recovery

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# Error tracking directory
ERROR_LOG_DIR="$HOME/.claude/error-tracking"
ERROR_HISTORY="$ERROR_LOG_DIR/error-history.log"
ERROR_STATS="$ERROR_LOG_DIR/error-stats.json"

# Analysis functions

# Analyze error patterns from the last N days
# Usage: analyze_error_patterns [days]
analyze_error_patterns() {
    local days="${1:-7}"
    local since_date

    if command -v gdate >/dev/null 2>&1; then
        since_date=$(gdate -d "$days days ago" "+%Y-%m-%d")
    else
        since_date=$(date -v-${days}d "+%Y-%m-%d")
    fi

    if [[ ! -f "$ERROR_HISTORY" ]]; then
        log_warning "No error history found at $ERROR_HISTORY"
        return 1
    fi

    echo "=== Error Pattern Analysis (Last $days days) ==="
    echo "Analysis period: $since_date to $(date "+%Y-%m-%d")"
    echo

    # Extract and analyze recent errors
    awk -F'|' -v since="$since_date" '
    $1 >= since {
        error_classes[$2]++
        contexts[$3]++
        total_errors++

        # Track errors by day
        day = substr($1, 1, 10)
        daily_errors[day]++

        # Track error combinations
        combo = $2 ":" $3
        combinations[combo]++
    }
    END {
        print "=== Summary ==="
        print "Total errors:", total_errors
        print ""

        print "=== Most Common Error Classes ==="
        PROCINFO["sorted_in"] = "@val_num_desc"
        for (class in error_classes) {
            printf "  %-20s: %d occurrences\n", class, error_classes[class]
        }
        print ""

        print "=== Most Affected Contexts ==="
        for (context in contexts) {
            printf "  %-30s: %d errors\n", context, contexts[context]
        }
        print ""

        print "=== Daily Error Distribution ==="
        PROCINFO["sorted_in"] = "@ind_str_asc"
        for (day in daily_errors) {
            printf "  %s: %d errors\n", day, daily_errors[day]
        }
        print ""

        print "=== Error Class + Context Combinations ==="
        PROCINFO["sorted_in"] = "@val_num_desc"
        count = 0
        for (combo in combinations) {
            if (count++ >= 10) break
            split(combo, parts, ":")
            printf "  %-15s in %-20s: %d times\n", parts[1], parts[2], combinations[combo]
        }
    }
    ' "$ERROR_HISTORY"
}

# Generate error recovery recommendations
# Usage: generate_recovery_recommendations
generate_recovery_recommendations() {
    if [[ ! -f "$ERROR_HISTORY" ]]; then
        log_warning "No error history available for analysis"
        return 1
    fi

    echo "=== Error Recovery Recommendations ==="
    echo

    # Analyze recent error patterns (last 24 hours)
    local recent_errors
    recent_errors=$(awk -F'|' -v cutoff="$(date -v-1d "+%Y-%m-%d" 2>/dev/null || date -d "1 day ago" "+%Y-%m-%d")" '
    $1 >= cutoff {
        error_classes[$2]++
    }
    END {
        for (class in error_classes) {
            if (error_classes[class] >= 3) {
                print class, error_classes[class]
            }
        }
    }
    ' "$ERROR_HISTORY")

    if [[ -n "$recent_errors" ]]; then
        echo "🚨 High-frequency errors detected (3+ occurrences in 24h):"
        echo "$recent_errors" | while read -r error_class count; do
            echo "   - $error_class: $count occurrences"
            suggest_improvement_for_error "$error_class"
        done
        echo
    fi

    # Check for error trends
    local trend_analysis
    trend_analysis=$(awk -F'|' '
    {
        day = substr($1, 1, 10)
        daily_count[day]++
    }
    END {
        # Calculate trend over last 7 days
        total_days = 0
        total_errors = 0
        for (day in daily_count) {
            total_days++
            total_errors += daily_count[day]
        }
        if (total_days > 0) {
            avg_daily_errors = total_errors / total_days
            print avg_daily_errors, total_errors, total_days
        }
    }
    ' "$ERROR_HISTORY")

    if [[ -n "$trend_analysis" ]]; then
        local avg_daily total_errors total_days
        read -r avg_daily total_errors total_days <<< "$trend_analysis"

        echo "📊 Error Trend Analysis:"
        echo "   Average daily errors: $(printf "%.1f" "$avg_daily")"
        echo "   Total errors (period): $total_errors"
        echo "   Days analyzed: $total_days"

        # Suggest actions based on error rate
        if (( $(echo "$avg_daily > 10" | bc -l 2>/dev/null) )); then
            echo "   ⚠️ High error rate detected - recommend immediate investigation"
        elif (( $(echo "$avg_daily > 5" | bc -l 2>/dev/null) )); then
            echo "   📈 Moderate error rate - monitor closely"
        else
            echo "   ✅ Error rate within acceptable range"
        fi
        echo
    fi

    # Identify error patterns that might benefit from circuit breaker tuning
    echo "🔧 Circuit Breaker Tuning Recommendations:"
    awk -F'|' '
    {
        error_class = $2
        context = $3
        hour = substr($1, 12, 2)

        # Count errors by hour for each class
        hourly_errors[error_class][hour]++
        total_by_class[error_class]++
    }
    END {
        for (class in total_by_class) {
            max_hourly = 0
            for (hour in hourly_errors[class]) {
                if (hourly_errors[class][hour] > max_hourly) {
                    max_hourly = hourly_errors[class][hour]
                }
            }

            if (max_hourly >= 5) {
                printf "   - %s: Peak %d errors/hour - consider lowering threshold\n", class, max_hourly
            } else if (total_by_class[class] <= 2) {
                printf "   - %s: Low frequency (%d total) - consider raising threshold\n", class, total_by_class[class]
            }
        }
    }
    ' "$ERROR_HISTORY"
}

# Suggest specific improvements for error types
# Usage: suggest_improvement_for_error "error_class"
suggest_improvement_for_error() {
    local error_class="$1"

    case "$error_class" in
        "mcp_specific")
            echo "      💡 Consider: Implementing MCP server health monitoring"
            echo "      💡 Consider: Adding MCP server auto-restart on boot"
            echo "      💡 Consider: Implementing MCP connection pooling"
            ;;
        "timeout")
            echo "      💡 Consider: Increasing default timeout values"
            echo "      💡 Consider: Implementing adaptive timeout based on operation type"
            echo "      💡 Consider: Adding timeout prediction based on historical data"
            ;;
        "authentication")
            echo "      💡 Consider: Implementing credential refresh automation"
            echo "      💡 Consider: Adding credential expiration monitoring"
            echo "      💡 Consider: Implementing backup authentication methods"
            ;;
        "network_error")
            echo "      💡 Consider: Adding network connectivity pre-checks"
            echo "      💡 Consider: Implementing automatic VPN reconnection"
            echo "      💡 Consider: Adding offline mode capabilities"
            ;;
        "ssh_key")
            echo "      💡 Consider: Implementing SSH key auto-loading on startup"
            echo "      💡 Consider: Adding SSH key health monitoring"
            echo "      💡 Consider: Implementing SSH key rotation automation"
            ;;
        *)
            echo "      💡 Consider: Adding more specific error detection for: $error_class"
            ;;
    esac
}

# Generate detailed error report
# Usage: generate_error_report [days] [output_file]
generate_error_report() {
    local days="${1:-7}"
    local output_file="${2:-}"
    local report_content

    report_content=$(cat << EOF
# MCP Server Management - Error Analysis Report

Generated: $(date)
Analysis Period: Last $days days

$(analyze_error_patterns "$days")

$(generate_recovery_recommendations)

## Error History Sample
$(tail -20 "$ERROR_HISTORY" 2>/dev/null | head -10)

## Recommended Actions

### Immediate Actions (High Priority)
1. Review high-frequency errors and their root causes
2. Update circuit breaker thresholds if needed
3. Implement missing error recovery strategies

### Medium-term Improvements
1. Enhance error pattern detection
2. Add predictive error analysis
3. Implement proactive error prevention

### Long-term Enhancements
1. Machine learning for error prediction
2. Automated error recovery optimization
3. Cross-system error correlation analysis

---
Report generated by enhanced-error-recovery system
EOF
)

    if [[ -n "$output_file" ]]; then
        echo "$report_content" > "$output_file"
        log_success "Error report saved to: $output_file"
    else
        echo "$report_content"
    fi
}

# Clear old error logs
# Usage: cleanup_error_logs [days_to_keep]
cleanup_error_logs() {
    local days_to_keep="${1:-30}"

    if [[ ! -f "$ERROR_HISTORY" ]]; then
        log_info "No error history to clean up"
        return 0
    fi

    local cutoff_date
    if command -v gdate >/dev/null 2>&1; then
        cutoff_date=$(gdate -d "$days_to_keep days ago" "+%Y-%m-%d")
    else
        cutoff_date=$(date -v-${days_to_keep}d "+%Y-%m-%d")
    fi

    # Backup original file
    cp "$ERROR_HISTORY" "${ERROR_HISTORY}.backup"

    # Keep only recent errors
    awk -F'|' -v cutoff="$cutoff_date" '$1 >= cutoff' "$ERROR_HISTORY" > "${ERROR_HISTORY}.tmp"
    mv "${ERROR_HISTORY}.tmp" "$ERROR_HISTORY"

    local lines_removed
    lines_removed=$(( $(wc -l < "${ERROR_HISTORY}.backup") - $(wc -l < "$ERROR_HISTORY") ))

    log_success "Cleaned up $lines_removed old error log entries (kept last $days_to_keep days)"
}

# Export analysis functions
export -f analyze_error_patterns generate_recovery_recommendations
export -f generate_error_report cleanup_error_logs suggest_improvement_for_error

# Main execution when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-analyze}" in
        "analyze")
            analyze_error_patterns "${2:-7}"
            ;;
        "report")
            generate_error_report "${2:-7}" "${3:-}"
            ;;
        "recommendations")
            generate_recovery_recommendations
            ;;
        "cleanup")
            cleanup_error_logs "${2:-30}"
            ;;
        *)
            echo "Usage: $0 {analyze|report|recommendations|cleanup} [args...]"
            echo "  analyze [days]              - Analyze error patterns"
            echo "  report [days] [output_file] - Generate comprehensive report"
            echo "  recommendations             - Generate recovery recommendations"
            echo "  cleanup [days_to_keep]      - Clean up old error logs"
            exit 1
            ;;
    esac
fi