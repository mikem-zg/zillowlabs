#!/bin/bash

# MCP Server Health Check Script
# Comprehensive health assessment for all or specific MCP servers

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# Default values
SERVER_NAME=""
OUTPUT_FORMAT="text"
VERBOSE=false

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Check health status of MCP servers

OPTIONS:
    -s, --server <name>     Check specific server only
    -f, --format <format>   Output format: text, json (default: text)
    -v, --verbose          Show detailed information
    -h, --help             Show this help message

EXAMPLES:
    $0                              # Check all servers
    $0 --server atlassian          # Check specific server
    $0 --format json               # JSON output for automation
    $0 --server serena --verbose   # Detailed check for specific server
EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -s|--server)
                SERVER_NAME="$2"
                shift 2
                ;;
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
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

# Check health of a single server
check_server_health() {
    local server="$1"
    local health response_time error_count

    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        generate_server_report "$server"
        return
    fi

    # Text output
    health=$(get_server_health "$server")
    response_time=$(get_server_response_time "$server")
    error_count=$(count_server_errors "$server" 1)

    case "$health" in
        "healthy")
            echo -e "✅ ${GREEN}$server${NC}: healthy (${response_time}ms)"
            ;;
        "degraded")
            echo -e "⚠️  ${YELLOW}$server${NC}: degraded (${response_time}ms, $error_count recent errors)"
            ;;
        "failed")
            echo -e "❌ ${RED}$server${NC}: failed (not responding)"
            ;;
        *)
            echo -e "❓ ${YELLOW}$server${NC}: unknown status"
            ;;
    esac

    # Verbose output
    if [[ "$VERBOSE" == "true" ]]; then
        echo "    Response time: ${response_time}ms"
        echo "    Recent errors (1h): $error_count"

        if has_tool_filtering_warnings "$server"; then
            echo -e "    ${YELLOW}Tool filtering warnings detected${NC}"
        fi

        # Recent error patterns
        local recent_errors=$(count_server_errors "$server" 1)
        if [[ $recent_errors -gt 0 ]]; then
            echo "    Recent error patterns:"
            grep "MCP server \"$server\"" "$DEBUG_LOG_PATH" 2>/dev/null | \
                grep -E "(Failed|Error|timeout)" | tail -3 | \
                sed 's/^/      /'
        fi
        echo
    fi
}

# Check health of all servers
check_all_servers() {
    local servers healthy_count=0 total_count=0
    local failed_servers=() degraded_servers=()

    # Get server list (compatible with macOS)
    local servers=()
    while IFS= read -r server; do
        [[ -n "$server" ]] && servers+=("$server")
    done < <(get_mcp_servers)

    if [[ ${#servers[@]} -eq 0 ]]; then
        log_warning "No MCP servers configured"
        return 0
    fi

    # JSON output header
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        echo "{"
        echo "  \"timestamp\": \"$(date -Iseconds)\","
        echo "  \"total_servers\": ${#servers[@]},"
        echo "  \"servers\": ["
    else
        log_info "Checking health of ${#servers[@]} MCP servers..."
        echo
    fi

    # Check each server
    for i in "${!servers[@]}"; do
        local server="${servers[i]}"
        total_count=$((total_count + 1))

        if [[ "$OUTPUT_FORMAT" == "json" ]]; then
            if [[ $i -gt 0 ]]; then
                echo ","
            fi
            echo -n "    "
            generate_server_report "$server" | tr '\n' ' ' | sed 's/ //g'
        else
            check_server_health "$server"
        fi

        # Track server status for summary
        local health=$(get_server_health "$server")
        case "$health" in
            "healthy")
                healthy_count=$((healthy_count + 1))
                ;;
            "degraded")
                degraded_servers+=("$server")
                ;;
            "failed")
                failed_servers+=("$server")
                ;;
        esac
    done

    # JSON output footer
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        echo ""
        echo "  ],"
        echo "  \"summary\": {"
        echo "    \"healthy\": $healthy_count,"
        echo "    \"degraded\": ${#degraded_servers[@]},"
        echo "    \"failed\": ${#failed_servers[@]},"
        echo "    \"health_percentage\": $(( (healthy_count * 100) / total_count ))"
        echo "  }"
        echo "}"
        return 0
    fi

    # Text summary
    echo
    echo "=== Health Summary ==="
    echo "Total servers: $total_count"
    echo -e "Healthy: ${GREEN}$healthy_count${NC}"
    echo -e "Degraded: ${YELLOW}${#degraded_servers[@]}${NC}"
    echo -e "Failed: ${RED}${#failed_servers[@]}${NC}"

    local health_percentage=$(( (healthy_count * 100) / total_count ))
    echo "Health percentage: $health_percentage%"

    # Show problematic servers
    if [[ ${#degraded_servers[@]} -gt 0 ]]; then
        echo
        echo -e "${YELLOW}Degraded servers requiring attention:${NC}"
        printf '  %s\n' "${degraded_servers[@]}"
    fi

    if [[ ${#failed_servers[@]} -gt 0 ]]; then
        echo
        echo -e "${RED}Failed servers requiring restart:${NC}"
        printf '  %s\n' "${failed_servers[@]}"
        echo
        log_info "To restart failed servers, run:"
        for server in "${failed_servers[@]}"; do
            echo "  /mcp-server-management --operation=restart-server --server_name=$server"
        done
    fi

    # Overall health assessment
    echo
    if [[ $health_percentage -ge 90 ]]; then
        echo -e "Overall system health: ${GREEN}Excellent${NC}"
    elif [[ $health_percentage -ge 75 ]]; then
        echo -e "Overall system health: ${GREEN}Good${NC}"
    elif [[ $health_percentage -ge 50 ]]; then
        echo -e "Overall system health: ${YELLOW}Fair${NC} - some servers need attention"
    else
        echo -e "Overall system health: ${RED}Poor${NC} - immediate action required"
        log_info "Run diagnostics: /mcp-server-management --operation=diagnose-failures"
    fi
}

# Main function
main() {
    parse_args "$@"

    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi

    # Run health check
    if [[ -n "$SERVER_NAME" ]]; then
        # Check specific server
        if [[ "$OUTPUT_FORMAT" == "json" ]]; then
            generate_server_report "$SERVER_NAME"
        else
            log_info "Checking health of MCP server: $SERVER_NAME"
            echo
            check_server_health "$SERVER_NAME"
        fi
    else
        # Check all servers
        check_all_servers
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi