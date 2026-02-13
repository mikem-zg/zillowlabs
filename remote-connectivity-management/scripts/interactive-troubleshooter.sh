#!/bin/bash

# Interactive SSH/VPN Troubleshooter for Remote Connectivity Management
# Provides step-by-step user-guided diagnostic and resolution workflow
# Follows FUB patterns for user interaction and problem resolution

# Set strict error handling
set -euo pipefail

# Source common utilities and environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source SSH core functions
if [[ -f "$SCRIPT_DIR/ssh-core-functions.sh" ]]; then
    source "$SCRIPT_DIR/ssh-core-functions.sh"
else
    echo "Error: SSH core functions not found"
    exit 1
fi

# Source VPN detection functions
if [[ -f "$SCRIPT_DIR/vpn-detection.sh" ]]; then
    source "$SCRIPT_DIR/vpn-detection.sh"
else
    echo "Error: VPN detection functions not found"
    exit 1
fi

# ============================================================================
# Interactive Helper Functions
# ============================================================================

# Wait for user confirmation before proceeding
# Usage: wait_for_user_confirmation [message]
wait_for_user_confirmation() {
    local message="${1:-Press Enter to continue...}"
    echo ""
    read -r -p "$message " </dev/tty
}

# Ask user a yes/no question
# Usage: ask_yes_no "question" [default_answer]
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response

    echo ""
    if [[ "$default" == "y" ]]; then
        read -r -p "$question (Y/n): " response </dev/tty
        response="${response:-y}"
    else
        read -r -p "$question (y/N): " response </dev/tty
        response="${response:-n}"
    fi

    [[ "${response,,}" =~ ^(y|yes)$ ]]
}

# Display step header
# Usage: display_step_header <step_number> <step_title>
display_step_header() {
    local step_number="$1"
    local step_title="$2"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Step $step_number: $step_title"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# ============================================================================
# Main Interactive Troubleshooting Workflow
# ============================================================================

# Interactive SSH/VPN troubleshooting guide
# Usage: interactive_ssh_troubleshoot [server]
interactive_ssh_troubleshoot() {
    local server="${1:-$DEFAULT_SSH_SERVER}"

    echo ""
    echo "🔧 Interactive SSH/VPN Troubleshooting Assistant"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This guide will walk you through diagnosing and resolving"
    echo "SSH connectivity issues with VPN conflict detection."
    echo ""
    echo "Target server: $server"
    echo ""

    wait_for_user_confirmation "Press Enter to start the diagnostic process..."

    # Step 1: Basic connectivity check
    display_step_header "1" "Internet Connectivity Check"

    log_info "Checking basic internet connectivity..."
    if test_internet_connectivity; then
        log_success "✅ Internet connection is working"
    else
        log_error "❌ No internet connectivity detected"
        echo ""
        echo "Please check your network connection and try again."
        echo "Common fixes:"
        echo "• Check WiFi/Ethernet connection"
        echo "• Restart network adapter"
        echo "• Check network settings"
        return 1
    fi

    # Step 2: VPN status analysis
    display_step_header "2" "VPN Status Analysis"

    log_info "Analyzing VPN configuration..."
    local vpn_status
    vpn_status=$(vpn_comprehensive_check)

    # Tailscale analysis
    if echo "$vpn_status" | grep -q "tailscale:connected"; then
        log_success "✅ Tailscale is connected"
        local device_count
        device_count=$(echo "$vpn_status" | grep "tailscale_devices:" | cut -d: -f2 || echo "unknown")
        echo "   → Devices visible: $device_count"
    elif echo "$vpn_status" | grep -q "tailscale:logged_out"; then
        log_error "❌ Tailscale is logged out"
        echo ""
        if ask_yes_no "Would you like to connect Tailscale now?" "y"; then
            echo "Run this command to connect Tailscale:"
            echo "   tailscale up"
            echo ""
            wait_for_user_confirmation "Press Enter after connecting Tailscale..."
        else
            echo "SSH connection may fail without Tailscale for FUB servers"
        fi
    elif echo "$vpn_status" | grep -q "tailscale:stopped"; then
        log_error "❌ Tailscale service is stopped"
        echo ""
        if ask_yes_no "Would you like to start Tailscale now?" "y"; then
            echo "Run this command to start Tailscale:"
            echo "   tailscale up"
            echo ""
            wait_for_user_confirmation "Press Enter after starting Tailscale..."
        fi
    elif echo "$vpn_status" | grep -q "tailscale:not_installed"; then
        log_error "❌ Tailscale is not installed"
        echo ""
        echo "Install Tailscale with:"
        echo "   brew install tailscale"
        echo ""
        if ask_yes_no "Continue without Tailscale installation?" "n"; then
            echo "Note: SSH to FUB servers will likely fail without Tailscale"
        else
            echo "Please install Tailscale and run this troubleshooter again"
            return 1
        fi
    fi

    # Cisco VPN analysis
    if echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        log_warning "⚠️ Cisco VPN is active"
        echo ""
        echo "Cisco VPN may interfere with Tailscale connections to FUB servers."
        echo ""
        if ask_yes_no "Would you like to disconnect Cisco VPN temporarily?" "y"; then
            echo "Disconnect Cisco VPN through the AnyConnect client, then continue."
            wait_for_user_confirmation "Press Enter after disconnecting Cisco VPN..."
        else
            echo "Note: SSH connections may timeout due to VPN routing conflicts"
        fi
    else
        log_success "✅ Cisco VPN is inactive (no conflicts expected)"
    fi

    # Step 3: SSH keys validation
    display_step_header "3" "SSH Keys Validation"

    log_info "Checking SSH keys..."
    if ssh_validate_keys; then
        log_success "✅ SSH keys are properly loaded"
    else
        log_error "❌ SSH key issues detected"
        echo ""
        if ask_yes_no "Would you like to load SSH keys now?" "y"; then
            provide_ssh_key_guidance
            wait_for_user_confirmation "Press Enter after loading SSH keys..."

            # Re-check keys
            if ssh_validate_keys; then
                log_success "✅ SSH keys now loaded successfully"
            else
                log_error "❌ SSH keys still not available"
                echo "Please resolve SSH key issues before continuing"
                return 1
            fi
        else
            echo "Note: SSH connection will fail without proper keys"
            return 1
        fi
    fi

    # Step 4: SSH connection test
    display_step_header "4" "SSH Connection Test"

    log_info "Testing SSH connection to $server..."

    echo "Attempting SSH connection test..."
    echo "If this hangs, you may need to press Ctrl+C and check VPN settings"
    echo ""

    if ssh_test_connectivity "$server"; then
        log_success "✅ SSH connection test successful!"
    else
        local ssh_exit_code=$?
        log_error "❌ SSH connection test failed (exit code: $ssh_exit_code)"

        # Provide specific troubleshooting based on error
        provide_ssh_troubleshooting "$server" "$ssh_exit_code"

        # Check for VPN conflicts
        if detect_cisco_vpn_conflict "$ssh_exit_code"; then
            echo ""
            log_warning "⚠️ VPN conflict detected!"
            provide_vpn_conflict_guidance
        fi

        # Offer manual connection test
        echo ""
        if ask_yes_no "Would you like to try a manual SSH connection for more details?" "y"; then
            echo ""
            echo "Running manual SSH test with verbose output:"
            echo "Command: ssh -v $server 'echo Manual SSH test successful'"
            echo ""
            echo "Press Ctrl+C if the connection hangs"
            wait_for_user_confirmation "Press Enter to proceed with manual test..."

            # Manual SSH test with verbose output
            if ssh -v "$server" 'echo "Manual SSH test successful"'; then
                log_success "✅ Manual SSH connection successful!"
            else
                log_error "❌ Manual SSH connection also failed"
                echo ""
                echo "Review the verbose output above for specific error details"
            fi
        fi

        return 1
    fi

    # Step 5: Remote capabilities verification
    display_step_header "5" "Remote Server Capabilities"

    log_info "Verifying remote server capabilities..."
    if ssh_verify_remote_requirements "$server"; then
        log_success "✅ Remote server has all required capabilities"
    else
        log_error "❌ Remote server missing required tools or permissions"
        echo ""
        echo "Contact your system administrator to resolve server issues"
        return 1
    fi

    # Step 6: Final validation and recommendations
    display_step_header "6" "Final Validation and Recommendations"

    log_info "Running complete SSH validation..."
    if ssh_full_validation "$server"; then
        log_success "🎉 SSH connection fully validated and working!"
        echo ""
        echo "Recommendations for maintaining connectivity:"
        echo "• Keep Tailscale connected during development"
        echo "• Use SSH key agent with 12-hour timeout: ssh-add -t 43200"
        echo "• Consider SSH multiplexing for persistent connections"
        echo "• Disconnect Cisco VPN when working with FUB servers"
        echo ""
        return 0
    else
        log_error "❌ Complete validation failed"
        echo ""
        echo "Some issues remain unresolved. Consider:"
        echo "• Running this troubleshooter again"
        echo "• Checking the team setup guide: .claude/core/environment/team-setup-guide.md"
        echo "• Contacting support with the error details above"
        return 1
    fi
}

# Quick SSH diagnostic (non-interactive)
# Usage: quick_ssh_diagnostic [server]
quick_ssh_diagnostic() {
    local server="${1:-$DEFAULT_SSH_SERVER}"

    echo "🔍 Quick SSH Diagnostic for $server"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Quick connectivity check
    if test_internet_connectivity; then
        echo "✅ Internet: OK"
    else
        echo "❌ Internet: Failed"
        return 1
    fi

    # Quick VPN status
    local vpn_status
    vpn_status=$(vpn_comprehensive_check)

    if echo "$vpn_status" | grep -q "tailscale:connected"; then
        echo "✅ Tailscale: Connected"
    else
        echo "❌ Tailscale: Not connected"
    fi

    if echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        echo "⚠️ Cisco VPN: Active (may cause conflicts)"
    else
        echo "✅ Cisco VPN: Inactive"
    fi

    # Quick SSH check
    if ssh_validate_keys >/dev/null 2>&1; then
        echo "✅ SSH Keys: Loaded"
    else
        echo "❌ SSH Keys: Not available"
    fi

    if ssh_test_connectivity "$server" >/dev/null 2>&1; then
        echo "✅ SSH Connection: Working"
        return 0
    else
        echo "❌ SSH Connection: Failed"

        # Quick conflict check
        if detect_cisco_vpn_conflict; then
            echo "⚠️ VPN Conflict: Detected"
        fi

        return 1
    fi
}

# VPN-only diagnostic
# Usage: interactive_vpn_diagnostic
interactive_vpn_diagnostic() {
    echo ""
    echo "🌐 Interactive VPN Diagnostic"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Step 1: Basic connectivity
    display_step_header "1" "Network Connectivity"

    if test_internet_connectivity; then
        log_success "✅ Internet connectivity is working"
    else
        log_error "❌ No internet connectivity"
        echo "Check your network connection before proceeding"
        return 1
    fi

    if test_dns_resolution; then
        log_success "✅ DNS resolution is working"
    else
        log_warning "⚠️ DNS resolution issues detected"
    fi

    # Step 2: VPN analysis
    display_step_header "2" "VPN Configuration Analysis"

    display_vpn_status_report

    # Step 3: Conflict resolution
    if detect_cisco_vpn_conflict; then
        display_step_header "3" "VPN Conflict Resolution"
        provide_vpn_conflict_guidance

        if ask_yes_no "Would you like guidance on resolving VPN conflicts?" "y"; then
            echo ""
            echo "Follow these steps to resolve VPN conflicts:"
            echo ""
            echo "1. Disconnect Cisco VPN:"
            echo "   • Close Cisco AnyConnect application"
            echo "   • Wait 10-15 seconds for routing to clear"
            echo ""
            echo "2. Verify Tailscale connectivity:"
            echo "   tailscale status"
            echo ""
            echo "3. Test connection to FUB resources"
            echo ""
            echo "4. Reconnect Cisco VPN only if needed for other resources"
            echo ""
        fi
    else
        echo ""
        log_success "✅ No VPN conflicts detected"
    fi
}

# ============================================================================
# Export Functions for Other Scripts
# ============================================================================

# Export functions for use by other scripts
export -f interactive_ssh_troubleshoot quick_ssh_diagnostic interactive_vpn_diagnostic
export -f wait_for_user_confirmation ask_yes_no display_step_header