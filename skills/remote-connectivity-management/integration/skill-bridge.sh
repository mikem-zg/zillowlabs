#!/bin/bash

# Skill Bridge for Remote Connectivity Management
# Provides integration layer for other FUB skills to use remote connectivity management
# Offers both backward compatibility and enhanced VPN-aware functions

# Set strict error handling
set -euo pipefail

# Source the remote connectivity management skill functions
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source all skill modules with error handling
source_with_fallback() {
    local script_path="$1"
    local script_name="$2"

    if [[ -f "$script_path" ]]; then
        # Temporarily disable strict mode for sourcing
        set +e
        source "$script_path" 2>/dev/null
        local source_result=$?
        set -e

        if [[ $source_result -ne 0 ]]; then
            echo "Warning: Could not source $script_name - some functions may not be available"
            return 1
        fi
    else
        echo "Warning: $script_name not found - some functions may not be available"
        return 1
    fi

    return 0
}

# Source skill modules
source_with_fallback "$SKILL_DIR/scripts/ssh-core-functions.sh" "SSH core functions"
source_with_fallback "$SKILL_DIR/scripts/vpn-detection.sh" "VPN detection functions"
source_with_fallback "$SKILL_DIR/scripts/interactive-troubleshooter.sh" "Interactive troubleshooter"

# ============================================================================
# Backward Compatibility Functions
# ============================================================================

# These functions maintain compatibility with existing skill implementations
# They wrap new functionality with the original function names

# Original function from mutagen-management/scripts/ssh-validation.sh
# Usage: validate_ssh_connection [server]
validate_ssh_connection() {
    ssh_full_validation "$@"
}

# Original function from mutagen-management/scripts/ssh-validation.sh
# Usage: validate_ssh_keys
validate_ssh_keys() {
    ssh_validate_keys "$@"
}

# Original function from mutagen-management/scripts/ssh-validation.sh
# Usage: test_ssh_connection <server>
test_ssh_connection() {
    ssh_test_connectivity "$@"
}

# Original function from mutagen-management/scripts/ssh-validation.sh
# Usage: verify_mutagen_ssh_requirements <server>
verify_mutagen_ssh_requirements() {
    ssh_verify_remote_requirements "$@"
}

# Original function from mutagen-management/scripts/ssh-validation.sh
# Usage: fix_ssh_issues [server]
fix_ssh_issues() {
    apply_ssh_key_recovery "$@"
}

# Original function from tool-management/scripts/intelligent-retry-controller.sh
# Usage: apply_ssh_key_recovery [server] [force_reload]
apply_ssh_key_recovery() {
    # Enhanced version that includes VPN awareness
    local server="${1:-$DEFAULT_SSH_SERVER}"
    local force_reload="${2:-false}"

    log_info "🔧 Enhanced SSH recovery with VPN awareness..."

    # Pre-flight VPN check
    local vpn_status
    vpn_status=$(vpn_comprehensive_check 2>/dev/null || echo "vpn_check_failed")

    if [[ "$vpn_status" == "vpn_check_failed" ]] || echo "$vpn_status" | grep -q "internet:failed"; then
        log_error "❌ Network connectivity issues - check internet connection"
        return 1
    fi

    # VPN conflict pre-check
    if echo "$vpn_status" | grep -q "tailscale:.*offline\|tailscale:.*stopped"; then
        log_warning "⚠️ Tailscale offline - SSH may fail for FUB servers"
        echo "   → Run: tailscale up"
    fi

    if echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        log_warning "⚠️ Cisco VPN active - may cause conflicts with Tailscale"
        echo "   → Consider disconnecting Cisco VPN temporarily"
    fi

    # Proceed with SSH recovery using enhanced functions
    if ! ssh_ensure_agent_running; then
        return 1
    fi

    if ssh_load_common_keys "$force_reload"; then
        log_success "✅ SSH keys loaded successfully"
    else
        log_error "❌ Failed to load SSH keys"
        provide_ssh_key_guidance
        return 1
    fi

    # Test connection with VPN conflict detection
    if ssh_full_validation "$server"; then
        log_success "✅ SSH issues resolved successfully"
        return 0
    else
        local ssh_exit_code=$?
        log_error "❌ SSH validation failed after recovery attempt"

        # Enhanced error analysis with VPN awareness
        if detect_cisco_vpn_conflict "$ssh_exit_code"; then
            log_warning "⚠️ VPN conflict detected - see guidance below"
            provide_vpn_conflict_guidance
        fi

        return $ssh_exit_code
    fi
}

# ============================================================================
# Enhanced VPN-Aware Functions
# ============================================================================

# These functions provide new capabilities with VPN conflict awareness

# Enhanced SSH validation with comprehensive VPN checking
# Usage: validate_ssh_with_vpn_check [server]
validate_ssh_with_vpn_check() {
    local server="${1:-$DEFAULT_SSH_SERVER}"

    log_info "🔑 Enhanced SSH validation with VPN conflict detection for $server"

    # Pre-flight VPN comprehensive check
    local vpn_status
    vpn_status=$(vpn_comprehensive_check)

    # Check for critical network issues first
    if echo "$vpn_status" | grep -q "internet:failed"; then
        log_error "❌ No internet connectivity - check network connection"
        return 1
    fi

    # Tailscale connectivity check
    if echo "$vpn_status" | grep -q "tailscale:logged_out\|tailscale:stopped"; then
        log_error "❌ Tailscale offline - FUB servers require Tailscale"
        echo "   → Run: tailscale up"
        return 1
    fi

    if echo "$vpn_status" | grep -q "tailscale:not_installed"; then
        log_error "❌ Tailscale not installed - required for FUB development"
        echo "   → Install: brew install tailscale"
        return 1
    fi

    # Proceed with SSH validation
    local ssh_result
    ssh_result=$(ssh_full_validation "$server")
    local ssh_exit_code=$?

    # Post-failure VPN conflict analysis
    if [[ $ssh_exit_code -ne 0 ]]; then
        if detect_cisco_vpn_conflict "$ssh_exit_code"; then
            log_warning "⚠️ Cisco VPN conflict detected"
            provide_vpn_conflict_guidance
            return 2  # Specific exit code for VPN conflicts
        fi
    fi

    return $ssh_exit_code
}

# SSH validation with timeout and retry logic (from tool-management patterns)
# Usage: validate_ssh_with_retry <server> [max_retries]
validate_ssh_with_retry() {
    local server="$1"
    local max_retries="${2:-$SSH_MAX_RETRIES}"
    local attempt=1

    while [[ $attempt -le $max_retries ]]; do
        log_info "SSH validation attempt $attempt/$max_retries for $server"

        if validate_ssh_with_vpn_check "$server"; then
            log_success "✅ SSH validation successful on attempt $attempt"
            return 0
        else
            local exit_code=$?

            # If it's a VPN conflict (exit code 2), don't retry immediately
            if [[ $exit_code -eq 2 ]]; then
                log_warning "⚠️ VPN conflict detected - manual resolution required"
                return $exit_code
            fi

            if [[ $attempt -lt $max_retries ]]; then
                log_info "Retrying in 5 seconds... (attempt $((attempt + 1))/$max_retries)"
                sleep 5
            fi

            ((attempt++))
        fi
    done

    log_error "❌ SSH validation failed after $max_retries attempts"
    return 1
}

# Quick connectivity check for scripts (minimal output)
# Usage: quick_connectivity_check [server]
quick_connectivity_check() {
    local server="${1:-$DEFAULT_SSH_SERVER}"

    # Silent checks - return exit codes only
    test_internet_connectivity >/dev/null 2>&1 || return 1
    ssh_validate_keys >/dev/null 2>&1 || return 2
    ssh_test_connectivity "$server" >/dev/null 2>&1 || return 3

    return 0
}

# Pre-operation connectivity validation (used by other skills before major operations)
# Usage: ensure_connectivity_for_operation <operation_name> [server]
ensure_connectivity_for_operation() {
    local operation_name="$1"
    local server="${2:-$DEFAULT_SSH_SERVER}"

    log_info "🔍 Validating connectivity for $operation_name..."

    # Quick check first
    if quick_connectivity_check "$server"; then
        log_success "✅ Connectivity validated for $operation_name"
        return 0
    else
        local quick_exit_code=$?
        log_warning "⚠️ Connectivity issues detected for $operation_name"

        # Provide specific guidance based on quick check results
        case $quick_exit_code in
            1)
                log_error "❌ Internet connectivity failed"
                echo "   → Check network connection before proceeding with $operation_name"
                ;;
            2)
                log_error "❌ SSH keys not available"
                echo "   → Load SSH keys before proceeding with $operation_name"
                provide_ssh_key_guidance
                ;;
            3)
                log_error "❌ SSH connection failed to $server"
                echo "   → Resolve SSH issues before proceeding with $operation_name"

                # Check for VPN conflicts
                if detect_cisco_vpn_conflict; then
                    provide_vpn_conflict_guidance
                fi
                ;;
        esac

        return $quick_exit_code
    fi
}

# ============================================================================
# Integration Helper Functions
# ============================================================================

# Check if enhanced features are available
# Usage: has_enhanced_connectivity_features
has_enhanced_connectivity_features() {
    # Check if VPN detection functions are available
    if command -v detect_cisco_vpn_conflict >/dev/null 2>&1 && \
       command -v vpn_comprehensive_check >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Get skill version information
# Usage: get_connectivity_skill_info
get_connectivity_skill_info() {
    echo "Remote Connectivity Management Skill"
    echo "Version: 1.0.0"
    echo "Features: SSH validation, VPN conflict detection, interactive troubleshooting"

    if has_enhanced_connectivity_features; then
        echo "Enhanced VPN features: Available"
    else
        echo "Enhanced VPN features: Not available"
    fi
}

# Skill health check
# Usage: connectivity_skill_health_check
connectivity_skill_health_check() {
    local health_status=0

    # Check if core functions are available
    if ! command -v ssh_full_validation >/dev/null 2>&1; then
        log_error "❌ SSH core functions not available"
        health_status=1
    fi

    if ! command -v vpn_comprehensive_check >/dev/null 2>&1; then
        log_error "❌ VPN detection functions not available"
        health_status=1
    fi

    # Check if configuration is loaded
    if [[ -z "${SSH_CONNECT_TIMEOUT:-}" ]]; then
        log_warning "⚠️ Configuration not loaded - using fallback values"
    fi

    if [[ $health_status -eq 0 ]]; then
        log_success "✅ Remote connectivity management skill is healthy"
    else
        log_error "❌ Remote connectivity management skill has issues"
    fi

    return $health_status
}

# ============================================================================
# Export All Functions
# ============================================================================

# Export backward compatibility functions
export -f validate_ssh_connection validate_ssh_keys test_ssh_connection
export -f verify_mutagen_ssh_requirements fix_ssh_issues apply_ssh_key_recovery

# Export enhanced VPN-aware functions
export -f validate_ssh_with_vpn_check validate_ssh_with_retry
export -f quick_connectivity_check ensure_connectivity_for_operation

# Export integration helpers
export -f has_enhanced_connectivity_features get_connectivity_skill_info
export -f connectivity_skill_health_check

# Set integration marker for other scripts to detect
export REMOTE_CONNECTIVITY_SKILL_LOADED=true