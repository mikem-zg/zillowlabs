#!/bin/bash

# Health Monitoring - Continuous tool ecosystem health monitoring
# Provides comprehensive health checks, automated problem detection, and recovery suggestions

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPT_DIR/tool-utils.sh"
source "$SCRIPT_DIR/tool-validation.sh"
source "$SCRIPT_DIR/fallback-generation.sh"

# Health check configuration
HEALTH_CHECK_CACHE_TTL=300  # 5 minutes
HEALTH_REPORT_PATH="$TOOL_CACHE_DIR/health-report.json"
HEALTH_LOG_PATH="$TOOL_CACHE_DIR/health-monitoring.log"

# Comprehensive health check
perform_comprehensive_health_check() {
    local category="${1:-all}"
    local include_auth_check="${2:-true}"
    local output_format="${3:-text}"

    log_info "Starting comprehensive health check (category: $category)"

    local health_results=()
    local total_tools=0
    local available_tools=0
    local unavailable_tools=0
    local auth_issues=0
    local warnings=0

    # Initialize results structure
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [[ "$category" == "all" || "$category" == "mcp" ]]; then
        log_info "Checking MCP servers..."
        while IFS= read -r server_name; do
            ((total_tools++))
            local status="unknown"
            local details=""

            if validate_mcp_tool "$server_name"; then
                status="available"
                ((available_tools++))
            else
                status="unavailable"
                ((unavailable_tools++))
                details="Server not responding or misconfigured"
            fi

            health_results+=("{\"category\": \"mcp\", \"name\": \"$server_name\", \"status\": \"$status\", \"details\": \"$details\", \"timestamp\": \"$timestamp\"}")
        done < <(get_mcp_servers)
    fi

    if [[ "$category" == "all" || "$category" == "cli" ]]; then
        log_info "Checking CLI tools..."
        for tool in glab acli datadog git mysql psql npm composer ssh curl jq; do
            ((total_tools++))
            local status="unknown"
            local details=""

            # Check installation
            if ! command -v "$tool" >/dev/null 2>&1; then
                status="unavailable"
                details="Not installed"
                ((unavailable_tools++))
            elif [[ "$include_auth_check" == "true" ]]; then
                # Check authentication if requested
                case $(validate_cli_tool "$tool" "true"; echo $?) in
                    0)
                        status="available"
                        details="Installed and authenticated"
                        ((available_tools++))
                        ;;
                    2)
                        status="auth_required"
                        details="Installed but requires authentication"
                        ((auth_issues++))
                        ;;
                    *)
                        status="unavailable"
                        details="Installation or functionality issues"
                        ((unavailable_tools++))
                        ;;
                esac
            else
                status="available"
                details="Installed"
                ((available_tools++))
            fi

            health_results+=("{\"category\": \"cli\", \"name\": \"$tool\", \"status\": \"$status\", \"details\": \"$details\", \"timestamp\": \"$timestamp\"}")
        done
    fi

    if [[ "$category" == "all" || "$category" == "skill" ]]; then
        log_info "Checking skills..."
        for skill_dir in ~/.claude/skills/*/; do
            [[ -d "$skill_dir" ]] || continue
            local skill_name=$(basename "$skill_dir")
            ((total_tools++))
            local status="unknown"
            local details=""

            case $(validate_skill_dependencies "$skill_name"; echo $?) in
                0)
                    status="available"
                    details="All dependencies satisfied"
                    ((available_tools++))
                    ;;
                1)
                    status="unavailable"
                    details="Skill not found or invalid"
                    ((unavailable_tools++))
                    ;;
                2)
                    status="warning"
                    details="Some dependencies missing"
                    ((warnings++))
                    ;;
            esac

            health_results+=("{\"category\": \"skill\", \"name\": \"$skill_name\", \"status\": \"$status\", \"details\": \"$details\", \"timestamp\": \"$timestamp\"}")
        done
    fi

    if [[ "$category" == "all" || "$category" == "builtin" ]]; then
        log_info "Checking built-in tools..."
        for tool in Read Write Edit Bash Glob Grep TaskCreate TaskUpdate AskUserQuestion WebFetch; do
            ((total_tools++))
            status="available"
            details="Always available"
            ((available_tools++))

            health_results+=("{\"category\": \"builtin\", \"name\": \"$tool\", \"status\": \"$status\", \"details\": \"$details\", \"timestamp\": \"$timestamp\"}")
        done
    fi

    # Generate health report
    local overall_status="healthy"
    if [[ $unavailable_tools -gt 0 ]]; then
        overall_status="degraded"
    fi
    if [[ $unavailable_tools -gt $((available_tools / 2)) ]]; then
        overall_status="critical"
    fi

    # Output results
    case "$output_format" in
        "json")
            generate_json_health_report "$overall_status" "$timestamp" "$total_tools" "$available_tools" "$unavailable_tools" "$auth_issues" "$warnings" "${health_results[@]}"
            ;;
        "summary")
            generate_summary_health_report "$overall_status" "$total_tools" "$available_tools" "$unavailable_tools" "$auth_issues" "$warnings"
            ;;
        *)
            generate_detailed_health_report "$overall_status" "$total_tools" "$available_tools" "$unavailable_tools" "$auth_issues" "$warnings" "${health_results[@]}"
            ;;
    esac

    # Cache results
    cache_health_results "$overall_status" "$timestamp" "${health_results[@]}"

    # Return appropriate exit code
    case "$overall_status" in
        "healthy") return 0 ;;
        "degraded") return 1 ;;
        "critical") return 2 ;;
    esac
}

# Generate detailed health report
generate_detailed_health_report() {
    local overall_status="$1"
    local total_tools="$2"
    local available_tools="$3"
    local unavailable_tools="$4"
    local auth_issues="$5"
    local warnings="$6"
    shift 6
    local health_results=("$@")

    echo "🏥 Tool Ecosystem Health Report"
    echo "================================"
    echo ""

    # Overall status
    case "$overall_status" in
        "healthy") echo "✅ Overall Status: HEALTHY" ;;
        "degraded") echo "⚠️  Overall Status: DEGRADED" ;;
        "critical") echo "❌ Overall Status: CRITICAL" ;;
    esac
    echo ""

    # Summary statistics
    echo "📊 Summary Statistics:"
    echo "   Total tools checked: $total_tools"
    echo "   Available tools: $available_tools"
    [[ $unavailable_tools -gt 0 ]] && echo "   Unavailable tools: $unavailable_tools"
    [[ $auth_issues -gt 0 ]] && echo "   Authentication issues: $auth_issues"
    [[ $warnings -gt 0 ]] && echo "   Warnings: $warnings"
    echo ""

    # Detailed results by category
    local current_category=""
    for result in "${health_results[@]}"; do
        local category=$(echo "$result" | jq -r '.category')
        local name=$(echo "$result" | jq -r '.name')
        local status=$(echo "$result" | jq -r '.status')
        local details=$(echo "$result" | jq -r '.details')

        # Print category header if changed
        if [[ "$category" != "$current_category" ]]; then
            current_category="$category"
            echo "📂 ${category^^} Tools:"
        fi

        # Format status output
        format_tool_status "$category:$name" "$status" "$details"
    done

    echo ""

    # Generate recommendations if there are issues
    if [[ $unavailable_tools -gt 0 || $auth_issues -gt 0 || $warnings -gt 0 ]]; then
        echo "🔧 Recommendations:"
        generate_health_recommendations "$unavailable_tools" "$auth_issues" "$warnings"
    fi
}

# Generate summary health report
generate_summary_health_report() {
    local overall_status="$1"
    local total_tools="$2"
    local available_tools="$3"
    local unavailable_tools="$4"
    local auth_issues="$5"
    local warnings="$6"

    case "$overall_status" in
        "healthy")
            echo "✅ All systems operational ($available_tools/$total_tools tools available)"
            ;;
        "degraded")
            echo "⚠️  System degraded ($available_tools/$total_tools tools available"
            [[ $unavailable_tools -gt 0 ]] && echo -n ", $unavailable_tools unavailable"
            [[ $auth_issues -gt 0 ]] && echo -n ", $auth_issues auth issues"
            echo ")"
            ;;
        "critical")
            echo "❌ Critical issues detected ($available_tools/$total_tools tools available, $unavailable_tools unavailable)"
            ;;
    esac
}

# Generate JSON health report
generate_json_health_report() {
    local overall_status="$1"
    local timestamp="$2"
    local total_tools="$3"
    local available_tools="$4"
    local unavailable_tools="$5"
    local auth_issues="$6"
    local warnings="$7"
    shift 7
    local health_results=("$@")

    cat << EOF
{
  "timestamp": "$timestamp",
  "overall_status": "$overall_status",
  "summary": {
    "total_tools": $total_tools,
    "available_tools": $available_tools,
    "unavailable_tools": $unavailable_tools,
    "auth_issues": $auth_issues,
    "warnings": $warnings
  },
  "tools": [
EOF

    # Add tool results
    local first=true
    for result in "${health_results[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo ","
        fi
        echo -n "    $result"
    done

    cat << EOF

  ]
}
EOF
}

# Cache health results
cache_health_results() {
    local overall_status="$1"
    local timestamp="$2"
    shift 2
    local health_results=("$@")

    # Create cache directory if needed
    mkdir -p "$(dirname "$HEALTH_REPORT_PATH")"

    # Generate and save health report
    generate_json_health_report "$overall_status" "$timestamp" "0" "0" "0" "0" "0" "${health_results[@]}" > "$HEALTH_REPORT_PATH"

    # Log health check
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Health check completed - Status: $overall_status" >> "$HEALTH_LOG_PATH"
}

# Get cached health status
get_cached_health_status() {
    local max_age="${1:-$HEALTH_CHECK_CACHE_TTL}"

    if [[ -f "$HEALTH_REPORT_PATH" ]]; then
        local file_age=$(($(date +%s) - $(stat -f "%m" "$HEALTH_REPORT_PATH" 2>/dev/null || echo "0")))

        if [[ $file_age -le $max_age ]]; then
            cat "$HEALTH_REPORT_PATH"
            return 0
        fi
    fi

    return 1
}

# Automated problem detection and recovery
detect_and_recover_issues() {
    local auto_recovery="${1:-false}"

    log_info "Detecting and analyzing tool ecosystem issues..."

    local issues_detected=()
    local recovery_actions=()

    # Check MCP servers
    while IFS= read -r server_name; do
        if ! validate_mcp_tool "$server_name"; then
            issues_detected+=("MCP server '$server_name' unavailable")

            if [[ "$auto_recovery" == "true" ]]; then
                log_info "Attempting automatic recovery for MCP server: $server_name"
                if claude mcp restart "$server_name" 2>/dev/null; then
                    recovery_actions+=("✅ Restarted MCP server: $server_name")
                else
                    recovery_actions+=("❌ Failed to restart MCP server: $server_name")
                fi
            else
                recovery_actions+=("💡 Suggestion: Restart MCP server with 'claude mcp restart $server_name'")
            fi
        fi
    done < <(get_mcp_servers)

    # Check CLI authentication
    for tool in glab acli; do
        if command -v "$tool" >/dev/null 2>&1; then
            case $(validate_cli_tool "$tool" "true"; echo $?) in
                2)
                    issues_detected+=("CLI tool '$tool' requires authentication")
                    recovery_actions+=("💡 Suggestion: Run '$tool auth login' to authenticate")
                    ;;
            esac
        fi
    done

    # Report findings
    if [[ ${#issues_detected[@]} -eq 0 ]]; then
        log_success "No issues detected - tool ecosystem is healthy"
        return 0
    else
        echo "⚠️  Issues detected in tool ecosystem:"
        printf '   %s\n' "${issues_detected[@]}"
        echo ""

        if [[ ${#recovery_actions[@]} -gt 0 ]]; then
            echo "🔧 Recovery actions:"
            printf '   %s\n' "${recovery_actions[@]}"
        fi
        return 1
    fi
}

# Generate health recommendations
generate_health_recommendations() {
    local unavailable_tools="$1"
    local auth_issues="$2"
    local warnings="$3"

    if [[ $unavailable_tools -gt 0 ]]; then
        echo "   📦 Install missing tools:"
        echo "      /tool-management --operation=install-guidance --tool_category=cli"
        echo "      /tool-management --operation=install-guidance --tool_category=mcp"
    fi

    if [[ $auth_issues -gt 0 ]]; then
        echo "   🔐 Resolve authentication issues:"
        echo "      glab auth login"
        echo "      acli auth login"
        echo "      /tool-management --operation=validate --validate_auth=true"
    fi

    if [[ $warnings -gt 0 ]]; then
        echo "   ⚠️  Address dependency warnings:"
        echo "      /tool-management --operation=validate --tool_category=skill"
    fi

    echo "   🔄 Run comprehensive recovery:"
    echo "      /tool-management --operation=health-check --suggest_alternatives=true"
}

# Continuous monitoring
start_continuous_monitoring() {
    local interval="${1:-300}"  # 5 minutes default
    local output_file="${2:-$TOOL_CACHE_DIR/continuous-monitoring.log}"

    log_info "Starting continuous tool monitoring (interval: ${interval}s)"

    while true; do
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] Running health check..." >> "$output_file"

        if perform_comprehensive_health_check "all" "true" "summary" >> "$output_file" 2>&1; then
            echo "[$timestamp] Health check passed" >> "$output_file"
        else
            echo "[$timestamp] Health check found issues" >> "$output_file"
            detect_and_recover_issues "false" >> "$output_file" 2>&1
        fi

        echo "" >> "$output_file"
        sleep "$interval"
    done
}

# Tool performance monitoring
monitor_tool_performance() {
    local tool_category="${1:-all}"
    local iterations="${2:-5}"

    log_info "Monitoring tool performance ($iterations iterations)"

    local performance_results=()

    case "$tool_category" in
        "all"|"mcp")
            while IFS= read -r server_name; do
                log_info "Testing MCP server performance: $server_name"
                local avg_time=0
                local successful_tests=0

                for ((i=1; i<=iterations; i++)); do
                    local start_time=$(date +%s%N)
                    if validate_mcp_tool "$server_name"; then
                        local end_time=$(date +%s%N)
                        local duration=$(( (end_time - start_time) / 1000000 ))  # Convert to ms
                        avg_time=$((avg_time + duration))
                        ((successful_tests++))
                    fi
                done

                if [[ $successful_tests -gt 0 ]]; then
                    avg_time=$((avg_time / successful_tests))
                    performance_results+=("MCP $server_name: ${avg_time}ms avg (${successful_tests}/${iterations} successful)")
                else
                    performance_results+=("MCP $server_name: Failed all tests")
                fi
            done < <(get_mcp_servers)
            ;;
    esac

    echo "🚀 Performance Results:"
    printf '   %s\n' "${performance_results[@]}"
}

# Main execution function
main() {
    local operation="${1:-health-check}"
    local category="${2:-all}"
    local include_auth="${3:-true}"
    local format="${4:-text}"

    case "$operation" in
        "health-check")
            perform_comprehensive_health_check "$category" "$include_auth" "$format"
            ;;
        "detect-issues")
            detect_and_recover_issues "${5:-false}"
            ;;
        "monitor")
            start_continuous_monitoring "${5:-300}"
            ;;
        "performance")
            monitor_tool_performance "$category" "${5:-5}"
            ;;
        "cached-status")
            if get_cached_health_status "${5:-300}"; then
                return 0
            else
                log_info "No cached status available, running fresh health check..."
                perform_comprehensive_health_check "$category" "$include_auth" "$format"
            fi
            ;;
        *)
            log_error "Unknown operation: $operation"
            echo "Usage: $0 {health-check|detect-issues|monitor|performance|cached-status} [category] [include_auth] [format] [extra_params]"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    main "$@"
fi