#!/bin/bash

# Main Entry Point for Remote Connectivity Management Skill
# Handles parameter parsing and operation dispatching

# Set strict error handling
set -euo pipefail

# Source common utilities and environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all skill modules
source "$SCRIPT_DIR/ssh-core-functions.sh"
source "$SCRIPT_DIR/vpn-detection.sh"
source "$SCRIPT_DIR/interactive-troubleshooter.sh"

# Default values from skill configuration
OPERATION="validate"
SERVER=""
FORCE_KEY_RELOAD=false
SKIP_VPN_CHECK=false
INTERACTIVE=false

# ============================================================================
# Parameter Parsing Function
# ============================================================================

parse_skill_parameters() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --operation=*)
                OPERATION="${1#*=}"
                ;;
            --server=*)
                SERVER="${1#*=}"
                ;;
            --force-key-reload=*|--force_key_reload=*)
                FORCE_KEY_RELOAD="${1#*=}"
                ;;
            --skip-vpn-check=*|--skip_vpn_check=*)
                SKIP_VPN_CHECK="${1#*=}"
                ;;
            --interactive=*)
                INTERACTIVE="${1#*=}"
                ;;
            *)
                log_warning "Unknown parameter: $1"
                ;;
        esac
        shift
    done

    # Set default server if not specified
    if [[ -z "$SERVER" ]]; then
        SERVER="$DEFAULT_SSH_SERVER"
    fi

    # Export parameters for use by other functions
    export SKILL_OPERATION="$OPERATION"
    export SKILL_SERVER="$SERVER"
    export SKILL_FORCE_KEY_RELOAD="$FORCE_KEY_RELOAD"
    export SKILL_SKIP_VPN_CHECK="$SKIP_VPN_CHECK"
    export SKILL_INTERACTIVE="$INTERACTIVE"
}

# ============================================================================
# Operation Dispatch Functions
# ============================================================================

# Execute validate operation
execute_validate() {
    log_info "🔑 SSH/VPN Validation for $SERVER"

    if [[ "$SKIP_VPN_CHECK" == "true" ]]; then
        log_info "Skipping VPN checks (--skip-vpn-check=true)"
        ssh_full_validation "$SERVER"
    else
        # Use VPN-aware validation from skill bridge
        source "$SCRIPT_DIR/../integration/skill-bridge.sh"
        validate_ssh_with_vpn_check "$SERVER"
    fi
}

# Execute key-check operation
execute_key_check() {
    log_info "🔑 SSH Key Validation"

    if [[ "$FORCE_KEY_RELOAD" == "true" ]]; then
        ssh_load_common_keys true
    fi

    ssh_validate_keys
}

# Execute troubleshoot operation
execute_troubleshoot() {
    if [[ "$INTERACTIVE" == "true" ]]; then
        interactive_ssh_troubleshoot "$SERVER"
    else
        quick_ssh_diagnostic "$SERVER"
    fi
}

# Execute vpn-status operation
execute_vpn_status() {
    display_vpn_status_report
}

# Execute cisco-conflict-detect operation
execute_cisco_conflict_detect() {
    log_info "🔍 Cisco VPN Conflict Detection"

    local vpn_status
    vpn_status=$(vpn_comprehensive_check)

    if detect_cisco_vpn_conflict; then
        log_warning "⚠️ Cisco VPN conflict detected"
        provide_vpn_conflict_guidance
        return 1
    else
        log_success "✅ No Cisco VPN conflicts detected"
        return 0
    fi
}

# Execute recovery-guide operation
execute_recovery_guide() {
    echo ""
    echo "🔧 Remote Connectivity Recovery Guide"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Common SSH/VPN connectivity issues and solutions:"
    echo ""

    echo "1. SSH Key Issues:"
    provide_ssh_key_guidance

    echo "2. VPN Configuration Issues:"
    provide_tailscale_recovery_guidance

    echo "3. VPN Conflicts:"
    provide_vpn_conflict_guidance

    echo "4. For interactive troubleshooting:"
    echo "   claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
    echo ""
}

# Execute full-diagnosis operation
execute_full_diagnosis() {
    log_info "🔍 Full System Diagnosis"
    echo ""

    # Step 1: Network connectivity
    echo "=== Network Connectivity ==="
    test_internet_connectivity
    test_dns_resolution
    echo ""

    # Step 2: VPN status
    echo "=== VPN Status ==="
    display_vpn_status_report
    echo ""

    # Step 3: SSH validation
    echo "=== SSH Validation ==="
    if [[ "$INTERACTIVE" == "true" ]]; then
        interactive_ssh_troubleshoot "$SERVER"
    else
        ssh_full_validation "$SERVER"
    fi
}

# ============================================================================
# Main Execution Function
# ============================================================================

main() {
    # Parse parameters
    parse_skill_parameters "$@"

    log_info "Remote Connectivity Management - Operation: $OPERATION"

    # Dispatch to appropriate operation
    case "$OPERATION" in
        "validate")
            execute_validate
            ;;
        "key-check")
            execute_key_check
            ;;
        "troubleshoot")
            execute_troubleshoot
            ;;
        "vpn-status")
            execute_vpn_status
            ;;
        "cisco-conflict-detect")
            execute_cisco_conflict_detect
            ;;
        "recovery-guide")
            execute_recovery_guide
            ;;
        "full-diagnosis")
            execute_full_diagnosis
            ;;
        *)
            log_error "Unknown operation: $OPERATION"
            echo ""
            echo "Available operations:"
            echo "  validate              - Standard SSH/VPN validation (default)"
            echo "  key-check             - SSH key validation only"
            echo "  troubleshoot          - Interactive problem diagnosis"
            echo "  vpn-status            - VPN connectivity analysis"
            echo "  cisco-conflict-detect - Cisco VPN conflict detection"
            echo "  recovery-guide        - Display recovery guidance"
            echo "  full-diagnosis        - Comprehensive system check"
            echo ""
            echo "Examples:"
            echo "  claude /remote-connectivity-management"
            echo "  claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
            echo "  claude /remote-connectivity-management --operation=key-check --skip-vpn-check=true"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi