#!/bin/bash

# SSH Validation Utility for Mutagen Management
# Now powered by Remote Connectivity Management Skill
# Provides comprehensive SSH connection validation and troubleshooting with VPN awareness

# Set strict error handling
set -euo pipefail

# Source common utilities and environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Try to source Remote Connectivity Management Skill Bridge with circular dependency protection
if [[ -z "${MUTAGEN_SSH_SOURCING:-}" ]] && [[ -f "$SCRIPT_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" ]]; then
    export MUTAGEN_SSH_SOURCING=true
    # Temporarily disable strict mode for sourcing
    set +e
    source "$SCRIPT_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" 2>/dev/null
    source_result=$?
    set -e
    unset MUTAGEN_SSH_SOURCING

    if [[ $source_result -eq 0 ]] && command -v ssh_validate_keys >/dev/null 2>&1; then
        log_info "Using Remote Connectivity Management Skill (Enhanced with VPN detection)"
    else
        echo "Warning: Remote Connectivity Management Skill functions not available"
        # Define basic fallback functions
        log_info() { echo "ℹ️ $*"; }
        log_success() { echo "✅ $*"; }
        log_error() { echo "❌ $*"; }
        log_warning() { echo "⚠️ $*"; }

        # Basic SSH validation fallback
        validate_ssh_connection() {
            local server="${1:-fubdev-matttu-dev-01}"
            log_info "Basic SSH validation for $server"
            timeout 10 ssh -o ConnectTimeout=5 -o BatchMode=yes "$server" 'echo "SSH test successful"'
        }

        validate_ssh_keys() {
            if ssh-add -l >/dev/null 2>&1; then
                log_success "SSH keys are available"
                return 0
            else
                log_error "No SSH keys available"
                return 1
            fi
        }

        test_ssh_connection() {
            validate_ssh_connection "$@"
        }

        verify_mutagen_ssh_requirements() {
            validate_ssh_connection "$@"
        }

        fix_ssh_issues() {
            log_error "Enhanced SSH recovery unavailable - load SSH keys manually"
            return 1
        }
    fi
else
    echo "Info: Using fallback SSH functions (circular dependency protection or skill unavailable)"
    # Define basic logging and SSH functions
    log_info() { echo "ℹ️ $*"; }
    log_success() { echo "✅ $*"; }
    log_error() { echo "❌ $*"; }
    log_warning() { echo "⚠️ $*"; }

    validate_ssh_connection() {
        local server="${1:-fubdev-matttu-dev-01}"
        log_info "Basic SSH validation for $server"
        timeout 10 ssh -o ConnectTimeout=5 -o BatchMode=yes "$server" 'echo "SSH test successful"'
    }

    validate_ssh_keys() {
        if ssh-add -l >/dev/null 2>&1; then
            log_success "SSH keys are available"
            return 0
        else
            log_error "No SSH keys available"
            return 1
        fi
    }

    test_ssh_connection() {
        validate_ssh_connection "$@"
    }

    verify_mutagen_ssh_requirements() {
        validate_ssh_connection "$@"
    }

    fix_ssh_issues() {
        log_error "Enhanced SSH recovery unavailable - load SSH keys manually"
        return 1
    }
fi

# Source FUB CLI environment for SSH configuration (preserve compatibility)
if [[ -f "$PWD/fub-dev/cli/env.sh" ]]; then
    source "$PWD/fub-dev/cli/env.sh"
fi

# Mutagen-specific SSH validation wrapper
# Usage: mutagen_validate_ssh_connection [server_hostname]
mutagen_validate_ssh_connection() {
    local server="${1:-${ENV:-fubdev-matttu-dev-01}}"

    log_info "🔄 Mutagen SSH Validation with VPN conflict detection"

    # Use enhanced validation with VPN awareness if available
    if command -v validate_ssh_with_vpn_check >/dev/null 2>&1; then
        validate_ssh_with_vpn_check "$server"
    else
        # Fallback to basic validation
        validate_ssh_connection "$server"
    fi
}

# Interactive troubleshooting for Mutagen users
# Usage: mutagen_ssh_troubleshoot [server_hostname]
mutagen_ssh_troubleshoot() {
    local server="${1:-${ENV:-fubdev-matttu-dev-01}}"

    log_info "🔧 Mutagen SSH Troubleshooting"
    echo "Target server: $server"
    echo ""

    # Use enhanced troubleshooting if available
    if command -v interactive_ssh_troubleshoot >/dev/null 2>&1; then
        interactive_ssh_troubleshoot "$server"
    else
        log_error "Enhanced troubleshooting unavailable"
        echo "Try manual SSH connection: ssh $server"
        return 1
    fi
}

# Enhanced Mutagen connection check with pre-sync validation
# Usage: mutagen_pre_sync_check [server_hostname]
mutagen_pre_sync_check() {
    local server="${1:-${ENV:-fubdev-matttu-dev-01}}"

    log_info "🔍 Pre-sync connectivity check for $server"

    # Use enhanced connectivity validation if available
    if command -v ensure_connectivity_for_operation >/dev/null 2>&1; then
        ensure_connectivity_for_operation "mutagen sync" "$server"
    else
        # Fallback to basic validation
        validate_ssh_connection "$server"
    fi
}

# Main function for command-line usage
main() {
    local operation="${1:-validate}"
    local server="${2:-${ENV:-fubdev-matttu-dev-01}}"

    case "$operation" in
        "validate")
            mutagen_validate_ssh_connection "$server"
            ;;
        "keys")
            validate_ssh_keys
            ;;
        "test")
            test_ssh_connection "$server"
            ;;
        "fix")
            fix_ssh_issues "$server"
            ;;
        "interactive"|"troubleshoot")
            mutagen_ssh_troubleshoot "$server"
            ;;
        "pre-sync")
            mutagen_pre_sync_check "$server"
            ;;
        *)
            echo "Usage: $0 {validate|keys|test|fix|interactive|pre-sync} [server]"
            echo ""
            echo "Operations:"
            echo "  validate    - Full SSH validation with VPN conflict detection (default)"
            echo "  keys        - Check SSH key availability"
            echo "  test        - Test SSH connection only"
            echo "  fix         - Attempt automated issue resolution"
            echo "  interactive - Interactive troubleshooting guide"
            echo "  pre-sync    - Pre-sync connectivity validation for Mutagen"
            echo ""
            echo "Default server: $server"
            echo ""
            echo "Enhanced by Remote Connectivity Management Skill"
            return 1
            ;;
    esac
}

# Export functions for use by other scripts (backward compatibility)
export -f validate_ssh_connection validate_ssh_keys test_ssh_connection
export -f verify_mutagen_ssh_requirements fix_ssh_issues
export -f mutagen_validate_ssh_connection mutagen_ssh_troubleshoot mutagen_pre_sync_check

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi