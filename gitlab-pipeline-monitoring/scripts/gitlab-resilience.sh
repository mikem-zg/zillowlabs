#!/bin/bash

# GitLab Resilience Utility - MCP to glab CLI fallback
# Provides seamless failover from GitLab Sidekick MCP to glab CLI commands

# Set strict error handling
set -euo pipefail

# Source MCP resilience utilities with error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" ]]; then
    # Temporarily disable strict mode for sourcing
    set +e
    source "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" 2>/dev/null
    source_result=$?
    set -e

    if [[ $source_result -ne 0 ]]; then
        echo "Warning: Could not source MCP resilience utilities"
        # Define fallback logging functions
        log_info() { echo "ℹ️ $*"; }
        log_success() { echo "✅ $*"; }
        log_error() { echo "❌ $*"; }
        log_warning() { echo "⚠️ $*"; }
    fi
else
    echo "Warning: MCP resilience utilities not found"
    # Define fallback logging functions
    log_info() { echo "ℹ️ $*"; }
    log_success() { echo "✅ $*"; }
    log_error() { echo "❌ $*"; }
    log_warning() { echo "⚠️ $*"; }
fi

# GitLab configuration
GITLAB_SERVER="gitlab-sidekick"
GLAB_TIMEOUT=30
DEFAULT_PROJECT_PATH="fub/fub"

# Check if glab CLI is available
check_glab_availability() {
    if ! command -v glab >/dev/null 2>&1; then
        log_error "glab CLI not installed - cannot use fallback"
        echo "Install with: brew install glab"
        echo "Or visit: https://github.com/profclems/glab"
        return 1
    fi

    # Check if glab is authenticated
    if ! glab auth status >/dev/null 2>&1; then
        log_error "glab CLI not authenticated"
        echo "Authenticate with: glab auth login"
        return 1
    fi

    log_success "✅ glab CLI available and authenticated"
    return 0
}

# GitLab operation with MCP → glab fallback
# Usage: gitlab_operation_with_fallback "operation" "project_path" [additional_args...]
gitlab_operation_with_fallback() {
    local operation="$1"
    local project_path="${2:-$DEFAULT_PROJECT_PATH}"
    shift 2
    local additional_args=("$@")

    log_info "GitLab operation: $operation for project $project_path"

    # Check if we should use fallback immediately (circuit breaker)
    if should_use_fallback "$GITLAB_SERVER"; then
        log_info "🔄 Using glab CLI fallback due to MCP server issues"
        execute_glab_fallback "$operation" "$project_path" "${additional_args[@]}"
        return $?
    fi

    # Try MCP operation first
    case "$operation" in
        "list_pipelines")
            local mcp_command="mcp__gitlab-sidekick__gitlab_listPipelines --project='$project_path'"
            local fallback_command="glab pipeline list --project='$project_path'"
            ;;
        "pipeline_jobs")
            local pipeline_id="${additional_args[0]:-}"
            if [[ -z "$pipeline_id" ]]; then
                log_error "Pipeline ID required for pipeline_jobs operation"
                return 1
            fi
            local mcp_command="mcp__gitlab-sidekick__gitlab_listPipelineJobs --pipeline_id='$pipeline_id'"
            local fallback_command="glab pipeline ci view --pipeline-id '$pipeline_id' --project '$project_path'"
            ;;
        "job_logs")
            local job_id="${additional_args[0]:-}"
            if [[ -z "$job_id" ]]; then
                log_error "Job ID required for job_logs operation"
                return 1
            fi
            local mcp_command="mcp__gitlab-sidekick__gitlab_getJobLog --job_id='$job_id'"
            local fallback_command="glab ci trace --job-id '$job_id' --project '$project_path'"
            ;;
        "mr_overview")
            local mr_id="${additional_args[0]:-}"
            if [[ -z "$mr_id" ]]; then
                log_error "MR ID required for mr_overview operation"
                return 1
            fi
            local mcp_command="mcp__gitlab-sidekick__gitlab_mrOverview --mr_id='$mr_id'"
            local fallback_command="glab mr view '$mr_id' --project '$project_path'"
            ;;
        "list_notes")
            local mr_id="${additional_args[0]:-}"
            if [[ -z "$mr_id" ]]; then
                log_error "MR ID required for list_notes operation"
                return 1
            fi
            local mcp_command="mcp__gitlab-sidekick__gitlab_listNotes --mr_id='$mr_id'"
            local fallback_command="glab mr note list '$mr_id' --project '$project_path'"
            ;;
        "search_mrs")
            local search_query="${additional_args[0]:-}"
            local mcp_command="mcp__gitlab-sidekick__gitlab_searchOpenMRs --query='$search_query'"
            local fallback_command="glab mr list --search='$search_query' --project '$project_path'"
            ;;
        *)
            log_error "Unknown GitLab operation: $operation"
            return 1
            ;;
    esac

    # Execute with MCP failover to glab
    if mcp_operation_with_fallback "$GITLAB_SERVER" "$mcp_command" "$fallback_command" "gitlab-pipeline-monitoring"; then
        return 0
    else
        log_error "Both MCP and fallback operations failed"
        return 1
    fi
}

# Execute glab CLI fallback operation
execute_glab_fallback() {
    local operation="$1"
    local project_path="$2"
    shift 2
    local additional_args=("$@")

    # Ensure glab is available
    if ! check_glab_availability; then
        return 1
    fi

    log_info "🔧 Executing glab CLI fallback for $operation"

    case "$operation" in
        "list_pipelines")
            timeout $GLAB_TIMEOUT glab pipeline list --project="$project_path"
            ;;
        "pipeline_jobs")
            local pipeline_id="${additional_args[0]}"
            timeout $GLAB_TIMEOUT glab pipeline ci view --pipeline-id "$pipeline_id" --project="$project_path"
            ;;
        "job_logs")
            local job_id="${additional_args[0]}"
            timeout $GLAB_TIMEOUT glab ci trace --job-id "$job_id" --project="$project_path"
            ;;
        "mr_overview")
            local mr_id="${additional_args[0]}"
            timeout $GLAB_TIMEOUT glab mr view "$mr_id" --project="$project_path"
            ;;
        "list_notes")
            local mr_id="${additional_args[0]}"
            timeout $GLAB_TIMEOUT glab mr note list "$mr_id" --project="$project_path"
            ;;
        "search_mrs")
            local search_query="${additional_args[0]}"
            timeout $GLAB_TIMEOUT glab mr list --search="$search_query" --project="$project_path"
            ;;
        *)
            log_error "Fallback not implemented for operation: $operation"
            return 1
            ;;
    esac
}

# Get pipeline status with comprehensive fallback
get_pipeline_status() {
    local project_path="${1:-$DEFAULT_PROJECT_PATH}"
    local pipeline_id="${2:-latest}"

    log_info "Getting pipeline status for $project_path (pipeline: $pipeline_id)"

    if [[ "$pipeline_id" == "latest" ]]; then
        # Get latest pipeline
        gitlab_operation_with_fallback "list_pipelines" "$project_path" | head -1
    else
        # Get specific pipeline jobs
        gitlab_operation_with_fallback "pipeline_jobs" "$project_path" "$pipeline_id"
    fi
}

# Monitor pipeline with real-time updates
monitor_pipeline() {
    local project_path="${1:-$DEFAULT_PROJECT_PATH}"
    local pipeline_id="$2"
    local check_interval="${3:-30}"

    if [[ -z "$pipeline_id" ]]; then
        log_error "Pipeline ID required for monitoring"
        return 1
    fi

    log_info "🔍 Monitoring pipeline $pipeline_id every ${check_interval}s"
    echo "Press Ctrl+C to stop monitoring"
    echo ""

    while true; do
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Pipeline Status at $(date '+%H:%M:%S')"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        if gitlab_operation_with_fallback "pipeline_jobs" "$project_path" "$pipeline_id"; then
            echo ""
            echo "Next update in ${check_interval}s..."
        else
            log_error "Failed to get pipeline status"
        fi

        sleep "$check_interval"
    done
}

# Get job logs with fallback
get_job_logs() {
    local project_path="${1:-$DEFAULT_PROJECT_PATH}"
    local job_id="$2"

    if [[ -z "$job_id" ]]; then
        log_error "Job ID required"
        return 1
    fi

    log_info "📄 Getting logs for job $job_id"
    gitlab_operation_with_fallback "job_logs" "$project_path" "$job_id"
}

# Search for failed jobs in recent pipelines
find_failed_jobs() {
    local project_path="${1:-$DEFAULT_PROJECT_PATH}"
    local limit="${2:-10}"

    log_info "🔍 Searching for failed jobs in recent $limit pipelines"

    if check_glab_availability; then
        # Use glab for complex filtering
        glab pipeline list --project="$project_path" --status=failed,canceled --limit="$limit" --output=json 2>/dev/null | \
        jq -r '.[] | select(.status == "failed" or .status == "canceled") | "\(.id): \(.status) - \(.ref)"' 2>/dev/null || \
        gitlab_operation_with_fallback "list_pipelines" "$project_path"
    else
        gitlab_operation_with_fallback "list_pipelines" "$project_path"
    fi
}

# Health check for GitLab operations
gitlab_health_check() {
    log_info "🏥 GitLab Operations Health Check"
    echo ""

    # Check MCP server
    if test_mcp_server "$GITLAB_SERVER" 5; then
        log_success "✅ GitLab Sidekick MCP server is healthy"
    else
        log_warning "⚠️ GitLab Sidekick MCP server is unhealthy"
        if restart_mcp_server "$GITLAB_SERVER"; then
            log_success "✅ MCP server restart successful"
        else
            log_error "❌ MCP server restart failed"
        fi
    fi

    # Check glab CLI fallback
    echo ""
    if check_glab_availability; then
        log_success "✅ glab CLI fallback is available"
    else
        log_error "❌ glab CLI fallback is not available"
    fi

    echo ""
    log_info "Testing basic operations..."

    # Test list pipelines
    if gitlab_operation_with_fallback "list_pipelines" "$DEFAULT_PROJECT_PATH" >/dev/null 2>&1; then
        log_success "✅ Pipeline listing works"
    else
        log_error "❌ Pipeline listing failed"
    fi
}

# Interactive pipeline browser
interactive_pipeline_browser() {
    local project_path="${1:-$DEFAULT_PROJECT_PATH}"

    echo ""
    echo "🔍 Interactive Pipeline Browser"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    while true; do
        echo "Recent pipelines for $project_path:"
        echo ""

        # Get recent pipelines
        if gitlab_operation_with_fallback "list_pipelines" "$project_path"; then
            echo ""
            echo "Options:"
            echo "  1) Enter pipeline ID to view jobs"
            echo "  2) Enter job ID to view logs"
            echo "  3) Search for specific pipelines"
            echo "  4) Monitor specific pipeline"
            echo "  5) Find failed jobs"
            echo "  q) Quit"
            echo ""
            echo -n "Choose option: "
            read -r choice

            case "$choice" in
                1)
                    echo -n "Enter pipeline ID: "
                    read -r pipeline_id
                    if [[ -n "$pipeline_id" ]]; then
                        gitlab_operation_with_fallback "pipeline_jobs" "$project_path" "$pipeline_id"
                    fi
                    ;;
                2)
                    echo -n "Enter job ID: "
                    read -r job_id
                    if [[ -n "$job_id" ]]; then
                        get_job_logs "$project_path" "$job_id"
                    fi
                    ;;
                3)
                    echo -n "Enter search query: "
                    read -r query
                    if [[ -n "$query" ]]; then
                        gitlab_operation_with_fallback "search_mrs" "$project_path" "$query"
                    fi
                    ;;
                4)
                    echo -n "Enter pipeline ID to monitor: "
                    read -r pipeline_id
                    if [[ -n "$pipeline_id" ]]; then
                        monitor_pipeline "$project_path" "$pipeline_id"
                    fi
                    ;;
                5)
                    find_failed_jobs "$project_path"
                    ;;
                q|Q)
                    echo "Exiting..."
                    break
                    ;;
                *)
                    echo "Invalid option"
                    ;;
            esac
        else
            log_error "Failed to get pipeline information"
            break
        fi

        echo ""
        echo -n "Press Enter to continue..."
        read -r
        echo ""
    done
}

# Main function for command-line usage
main() {
    local operation="${1:-health-check}"
    local project_path="${2:-$DEFAULT_PROJECT_PATH}"

    case "$operation" in
        "health-check"|"health")
            gitlab_health_check
            ;;
        "list-pipelines"|"pipelines")
            gitlab_operation_with_fallback "list_pipelines" "$project_path"
            ;;
        "pipeline-jobs"|"jobs")
            local pipeline_id="$3"
            if [[ -z "$pipeline_id" ]]; then
                log_error "Pipeline ID required: $0 pipeline-jobs PROJECT_PATH PIPELINE_ID"
                return 1
            fi
            gitlab_operation_with_fallback "pipeline_jobs" "$project_path" "$pipeline_id"
            ;;
        "job-logs"|"logs")
            local job_id="$3"
            if [[ -z "$job_id" ]]; then
                log_error "Job ID required: $0 job-logs PROJECT_PATH JOB_ID"
                return 1
            fi
            get_job_logs "$project_path" "$job_id"
            ;;
        "monitor")
            local pipeline_id="$3"
            local interval="${4:-30}"
            monitor_pipeline "$project_path" "$pipeline_id" "$interval"
            ;;
        "find-failed"|"failed")
            local limit="${3:-10}"
            find_failed_jobs "$project_path" "$limit"
            ;;
        "interactive"|"browse")
            interactive_pipeline_browser "$project_path"
            ;;
        "test-fallback")
            check_glab_availability
            ;;
        *)
            echo "Usage: $0 {health-check|list-pipelines|pipeline-jobs|job-logs|monitor|find-failed|interactive|test-fallback} [project_path] [args...]"
            echo ""
            echo "Operations:"
            echo "  health-check     - Check MCP server and glab CLI status"
            echo "  list-pipelines   - List recent pipelines"
            echo "  pipeline-jobs    - List jobs for specific pipeline"
            echo "  job-logs         - Get logs for specific job"
            echo "  monitor          - Monitor pipeline in real-time"
            echo "  find-failed      - Find recently failed jobs"
            echo "  interactive      - Interactive pipeline browser"
            echo "  test-fallback    - Test glab CLI availability"
            echo ""
            echo "Default project: $DEFAULT_PROJECT_PATH"
            return 1
            ;;
    esac
}

# Export functions for use by other scripts
export -f gitlab_operation_with_fallback execute_glab_fallback check_glab_availability
export -f get_pipeline_status monitor_pipeline get_job_logs find_failed_jobs gitlab_health_check

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi