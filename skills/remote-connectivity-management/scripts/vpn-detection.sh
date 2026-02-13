#!/bin/bash

# VPN Detection and Conflict Resolution for Remote Connectivity Management
# Provides comprehensive VPN status checking, conflict detection, and recovery guidance
# Focuses on Tailscale and Cisco VPN interactions common in FUB development environment

# Set strict error handling
set -euo pipefail

# Source common utilities and environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Try to source MCP resilience utilities with comprehensive error handling
MCP_RESILIENCE_AVAILABLE=false

if [[ -f "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" ]]; then
    # Temporarily disable all error handling for sourcing attempt
    set +euo pipefail
    (
        source "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" 2>/dev/null
        # Test if the functions are actually available
        type log_info >/dev/null 2>&1 && type log_success >/dev/null 2>&1
    )
    source_result=$?

    if [[ $source_result -eq 0 ]]; then
        # Source again in the main shell if test passed
        source "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" 2>/dev/null || true

        # Verify functions are available
        if type log_info >/dev/null 2>&1; then
            MCP_RESILIENCE_AVAILABLE=true
        fi
    fi

    # Restore strict error handling
    set -euo pipefail
fi

# Define fallback logging functions if MCP resilience not available
if [[ "$MCP_RESILIENCE_AVAILABLE" != "true" ]]; then
    # Define fallback logging functions
    log_info() { echo "ℹ️ $*"; }
    log_success() { echo "✅ $*"; }
    log_error() { echo "❌ $*"; }
    log_warning() { echo "⚠️ $*"; }
fi

# Load configuration from centralized config
if [[ -f "$SCRIPT_DIR/../config/timeouts.conf" ]]; then
    source "$SCRIPT_DIR/../config/timeouts.conf"
else
    # Fallback timeout values
    VPN_STATUS_TIMEOUT=3
    NETWORK_TEST_TIMEOUT=5
    CISCO_VPN_DETECTION_TIMEOUT=2
fi

# Load VPN priority configuration
if [[ -f "$SCRIPT_DIR/../config/vpn-priorities.conf" ]]; then
    source "$SCRIPT_DIR/../config/vpn-priorities.conf"
else
    # Fallback VPN configuration
    VPN_CONNECTION_ORDER="tailscale,cisco"
    TAILSCALE_FIRST_POLICY=true
    AUTO_CISCO_VPN_DISCONNECT=false
    CISCO_VPN_CONFLICT_AUTO_DETECT=true
    TAILSCALE_AUTO_RECONNECT_SUGGEST=true
fi

# ============================================================================
# Basic Network Connectivity Functions
# ============================================================================

# Test internet connectivity
# Usage: test_internet_connectivity
test_internet_connectivity() {
    log_info "Testing internet connectivity..."

    # Test multiple DNS servers for reliability
    local test_hosts=("8.8.8.8" "1.1.1.1" "8.8.4.4")
    local success_count=0

    for host in "${test_hosts[@]}"; do
        if timeout $NETWORK_TEST_TIMEOUT ping -c 1 "$host" >/dev/null 2>&1; then
            ((success_count++))
        fi
    done

    if [[ $success_count -gt 0 ]]; then
        log_success "✅ Internet connectivity OK ($success_count/3 DNS servers reachable)"
        return 0
    else
        log_error "❌ No internet connectivity detected"
        return 1
    fi
}

# Test DNS resolution
# Usage: test_dns_resolution
test_dns_resolution() {
    log_info "Testing DNS resolution..."

    local test_domains=("google.com" "github.com" "tailscale.com")
    local success_count=0

    for domain in "${test_domains[@]}"; do
        if timeout $NETWORK_TEST_TIMEOUT nslookup "$domain" >/dev/null 2>&1; then
            ((success_count++))
        fi
    done

    if [[ $success_count -gt 0 ]]; then
        log_success "✅ DNS resolution working ($success_count/3 domains resolved)"
        return 0
    else
        log_error "❌ DNS resolution failed"
        return 1
    fi
}

# ============================================================================
# Tailscale Detection and Status Functions
# ============================================================================

# Get comprehensive Tailscale status
# Usage: get_tailscale_status
get_tailscale_status() {
    local status_info=()

    # Check if Tailscale is installed
    if ! command -v tailscale >/dev/null 2>&1; then
        status_info+=("tailscale:not_installed")
        printf '%s\n' "${status_info[@]}"
        return 1
    fi

    # Get Tailscale status with timeout
    local tailscale_output
    if tailscale_output=$(timeout $VPN_STATUS_TIMEOUT tailscale status 2>/dev/null); then
        # Parse status output to determine state
        if echo "$tailscale_output" | grep -q "Logged out"; then
            status_info+=("tailscale:logged_out")
        elif echo "$tailscale_output" | grep -q "Stopped"; then
            status_info+=("tailscale:stopped")
        elif echo "$tailscale_output" | grep -q "Running"; then
            status_info+=("tailscale:connected")
            # Get device count for additional info
            local device_count
            device_count=$(echo "$tailscale_output" | grep -c "^[[:space:]]*[0-9]" || echo "0")
            status_info+=("tailscale_devices:$device_count")
        else
            status_info+=("tailscale:unknown_state")
        fi
    else
        # Check if it's a permission issue or service down
        if timeout $VPN_STATUS_TIMEOUT tailscale status 2>&1 | grep -q "permission denied"; then
            status_info+=("tailscale:permission_denied")
        else
            status_info+=("tailscale:service_down")
        fi
    fi

    printf '%s\n' "${status_info[@]}"
    return 0
}

# Check if Tailscale is properly connected
# Usage: is_tailscale_connected
is_tailscale_connected() {
    local tailscale_status
    tailscale_status=$(get_tailscale_status)

    if echo "$tailscale_status" | grep -q "tailscale:connected"; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# Cisco VPN Detection Functions
# ============================================================================

# Detect Cisco VPN connection
# Usage: detect_cisco_vpn
detect_cisco_vpn() {
    local cisco_indicators=()

    # Method 1: Check for utun interfaces (common Cisco VPN indicator on macOS)
    if route -n get default 2>/dev/null | grep -q "interface: utun"; then
        cisco_indicators+=("cisco_vpn:utun_interface_active")
    fi

    # Method 2: Check for Cisco AnyConnect processes
    if pgrep -f "Cisco.*AnyConnect" >/dev/null 2>&1; then
        cisco_indicators+=("cisco_vpn:anyconnect_process")
    fi

    # Method 3: Check for VPN-specific routing patterns
    if route -n show -inet 2>/dev/null | grep -q "10\.\|172\.\|192\.168\." | head -1 | grep -q "utun"; then
        cisco_indicators+=("cisco_vpn:vpn_routing_detected")
    fi

    # Method 4: Check for Cisco VPN adapter names
    if ifconfig 2>/dev/null | grep -q "utun.*Cisco\|cscotun"; then
        cisco_indicators+=("cisco_vpn:cisco_adapter_found")
    fi

    if [[ ${#cisco_indicators[@]} -gt 0 ]]; then
        printf '%s\n' "${cisco_indicators[@]}"
        return 0
    else
        echo "cisco_vpn:inactive"
        return 1
    fi
}

# Check if Cisco VPN is active
# Usage: is_cisco_vpn_active
is_cisco_vpn_active() {
    local cisco_status
    cisco_status=$(detect_cisco_vpn)

    if echo "$cisco_status" | grep -v -q "cisco_vpn:inactive"; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# Comprehensive VPN Status Check
# ============================================================================

# Get comprehensive VPN and network status
# Usage: vpn_comprehensive_check
vpn_comprehensive_check() {
    local results=()

    # Internet connectivity check
    if test_internet_connectivity; then
        results+=("internet:ok")
    else
        results+=("internet:failed")
        # If no internet, skip VPN checks as they may be unreliable
        printf '%s\n' "${results[@]}"
        return 1
    fi

    # DNS resolution check
    if test_dns_resolution; then
        results+=("dns:ok")
    else
        results+=("dns:failed")
    fi

    # Tailscale status
    local tailscale_info
    tailscale_info=$(get_tailscale_status)
    results+=("${tailscale_info[@]}")

    # Cisco VPN detection
    local cisco_info
    if cisco_info=$(detect_cisco_vpn 2>/dev/null); then
        results+=("$cisco_info")
    else
        results+=("cisco_vpn:inactive")
    fi

    printf '%s\n' "${results[@]}"
    return 0
}

# ============================================================================
# VPN Conflict Detection Functions
# ============================================================================

# Detect Cisco VPN conflicts with Tailscale
# Usage: detect_cisco_vpn_conflict [ssh_exit_code]
detect_cisco_vpn_conflict() {
    local ssh_exit_code="${1:-}"
    local vpn_status

    vpn_status=$(vpn_comprehensive_check)

    log_info "Analyzing VPN configuration for conflicts..."

    # Pattern 1: Tailscale connected + Cisco VPN active + SSH timeout
    if echo "$vpn_status" | grep -q "tailscale:connected" && \
       echo "$vpn_status" | grep -v -q "cisco_vpn:inactive" && \
       [[ "$ssh_exit_code" == "124" ]]; then
        log_warning "⚠️ VPN Conflict Detected: Tailscale + Cisco VPN + SSH Timeout"
        return 0
    fi

    # Pattern 2: Multiple VPN interfaces causing routing conflicts
    local active_vpn_count=0
    if echo "$vpn_status" | grep -q "tailscale:connected"; then
        ((active_vpn_count++))
    fi
    if echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        ((active_vpn_count++))
    fi

    if [[ $active_vpn_count -gt 1 ]]; then
        log_warning "⚠️ Multiple VPN connections detected (may cause routing conflicts)"
        return 0
    fi

    # Pattern 3: DNS resolution issues with VPN active
    if echo "$vpn_status" | grep -q "dns:failed" && \
       echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        log_warning "⚠️ DNS issues detected with Cisco VPN active"
        return 0
    fi

    log_info "No VPN conflicts detected"
    return 1
}

# ============================================================================
# VPN Recovery and Guidance Functions
# ============================================================================

# Provide VPN conflict resolution guidance
# Usage: provide_vpn_conflict_guidance
provide_vpn_conflict_guidance() {
    echo ""
    log_info "🔧 VPN Conflict Resolution:"
    echo ""
    echo "Recommended resolution order (FUB best practices):"
    echo ""
    echo "1. Disconnect Cisco VPN temporarily:"
    echo "   • Close Cisco AnyConnect client"
    echo "   • Or use: sudo pkill -f 'Cisco.*AnyConnect'"
    echo ""
    echo "2. Verify Tailscale connectivity:"
    echo "   tailscale status"
    echo ""
    echo "3. Test SSH connection:"
    echo "   ssh fubdev-{handle}-dev-01"
    echo ""
    echo "4. If successful, reconnect Cisco VPN after SSH session:"
    echo "   • Order matters: Tailscale first, then Cisco VPN"
    echo "   • Consider using SSH multiplexing for persistent connections"
    echo ""
}

# Provide Tailscale recovery guidance
# Usage: provide_tailscale_recovery_guidance [status]
provide_tailscale_recovery_guidance() {
    local status="${1:-unknown}"

    echo ""
    log_info "🔧 Tailscale Recovery:"
    echo ""

    case "$status" in
        "not_installed")
            echo "Tailscale not installed. Install with:"
            echo "• macOS: brew install tailscale"
            echo "• Linux: curl -fsSL https://tailscale.com/install.sh | sh"
            ;;
        "logged_out")
            echo "Tailscale is logged out. Authenticate with:"
            echo "• tailscale up"
            echo "• Follow browser authentication flow"
            ;;
        "stopped")
            echo "Tailscale service is stopped. Start with:"
            echo "• tailscale up"
            ;;
        "service_down")
            echo "Tailscale service is not running. Restart with:"
            echo "• sudo launchctl start com.tailscale.tailscaled  # macOS"
            echo "• sudo systemctl start tailscaled  # Linux"
            ;;
        "permission_denied")
            echo "Permission denied accessing Tailscale. Try:"
            echo "• sudo tailscale status"
            echo "• Check if you're in the tailscale group (Linux)"
            ;;
        *)
            echo "General Tailscale troubleshooting:"
            echo "• Check status: tailscale status"
            echo "• Restart connection: tailscale down && tailscale up"
            echo "• Check logs: tailscale debug logs"
            ;;
    esac

    echo ""
}

# ============================================================================
# VPN Status Reporting Functions
# ============================================================================

# Display comprehensive VPN status report
# Usage: display_vpn_status_report
display_vpn_status_report() {
    echo ""
    echo "🌐 VPN and Network Status Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local vpn_status
    vpn_status=$(vpn_comprehensive_check)

    # Internet connectivity
    if echo "$vpn_status" | grep -q "internet:ok"; then
        echo "✅ Internet Connectivity: OK"
    else
        echo "❌ Internet Connectivity: FAILED"
        echo "   → Check network connection"
    fi

    # DNS resolution
    if echo "$vpn_status" | grep -q "dns:ok"; then
        echo "✅ DNS Resolution: OK"
    else
        echo "❌ DNS Resolution: FAILED"
        echo "   → Check DNS settings or VPN configuration"
    fi

    echo ""

    # Tailscale status
    if echo "$vpn_status" | grep -q "tailscale:connected"; then
        echo "✅ Tailscale: Connected"
        local device_count
        device_count=$(echo "$vpn_status" | grep "tailscale_devices:" | cut -d: -f2 || echo "unknown")
        echo "   → Devices visible: $device_count"
    elif echo "$vpn_status" | grep -q "tailscale:logged_out"; then
        echo "❌ Tailscale: Logged Out"
        echo "   → Run: tailscale up"
    elif echo "$vpn_status" | grep -q "tailscale:stopped"; then
        echo "❌ Tailscale: Stopped"
        echo "   → Run: tailscale up"
    elif echo "$vpn_status" | grep -q "tailscale:not_installed"; then
        echo "❌ Tailscale: Not Installed"
        echo "   → Install: brew install tailscale"
    else
        echo "⚠️ Tailscale: Status Unknown"
        echo "   → Check: tailscale status"
    fi

    # Cisco VPN status
    if echo "$vpn_status" | grep -v -q "cisco_vpn:inactive"; then
        echo "⚠️ Cisco VPN: Active"
        echo "   → May cause conflicts with Tailscale"
        if echo "$vpn_status" | grep -q "tailscale:connected"; then
            echo "   → Conflict detected - consider disconnecting Cisco VPN temporarily"
        fi
    else
        echo "✅ Cisco VPN: Inactive"
    fi

    echo ""

    # VPN conflict analysis
    if detect_cisco_vpn_conflict; then
        echo "⚠️ VPN Conflict Status: DETECTED"
        provide_vpn_conflict_guidance
    else
        echo "✅ VPN Conflict Status: No conflicts detected"
    fi

    echo ""
}

# ============================================================================
# Export Functions for Other Scripts
# ============================================================================

# Export all functions for use by other scripts
export -f test_internet_connectivity test_dns_resolution
export -f get_tailscale_status is_tailscale_connected
export -f detect_cisco_vpn is_cisco_vpn_active
export -f vpn_comprehensive_check detect_cisco_vpn_conflict
export -f provide_vpn_conflict_guidance provide_tailscale_recovery_guidance
export -f display_vpn_status_report