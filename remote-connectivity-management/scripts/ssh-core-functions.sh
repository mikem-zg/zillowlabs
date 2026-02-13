#!/bin/bash

# SSH Core Functions for Remote Connectivity Management
# Consolidates SSH validation logic from across FUB skills
# Provides centralized SSH agent management, key loading, and connection validation

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
    # Fallback timeout values (consolidating from multiple implementations)
    SSH_CONNECT_TIMEOUT=5
    SSH_TEST_TIMEOUT=10
    SSH_AGENT_TIMEOUT=43200        # 12 hours (from team-setup-guide.md)
    SSH_MAX_RETRIES=2              # From intelligent-retry-controller.sh
fi

# Source FUB CLI environment for SSH configuration
if [[ -f "$PWD/fub-dev/cli/env.sh" ]]; then
    source "$PWD/fub-dev/cli/env.sh"
fi

# Default server determination (following FUB patterns)
DEFAULT_SSH_SERVER="${ENV:-fubdev-matttu-dev-01}"

# ============================================================================
# SSH Agent Management Functions
# ============================================================================

# Ensure SSH agent is running and accessible
# Usage: ssh_ensure_agent_running
ssh_ensure_agent_running() {
    if ! ssh-add -l >/dev/null 2>&1; then
        local ssh_add_status=$?

        case $ssh_add_status in
            1)
                log_info "SSH agent running but no keys loaded"
                return 1
                ;;
            2)
                log_info "🔑 Starting SSH agent..."
                eval "$(ssh-agent -s)" >/dev/null 2>&1
                log_success "✅ SSH agent started"
                return 0
                ;;
            *)
                log_error "SSH agent check failed with status $ssh_add_status"
                return 1
                ;;
        esac
    fi

    log_info "SSH agent already running"
    return 0
}

# Load common SSH keys following FUB patterns
# Usage: ssh_load_common_keys [force_reload]
ssh_load_common_keys() {
    local force_reload="${1:-false}"
    local keys_loaded=0

    # If agent has keys and not forcing reload, check if we have keys
    if [[ "$force_reload" != "true" ]] && ssh-add -l >/dev/null 2>&1; then
        log_info "SSH keys already loaded in agent"
        ssh-add -l | sed 's/^/   /'
        return 0
    fi

    # Standard FUB SSH key locations
    local key_paths=(
        "${HOME}/.ssh/id_rsa"
        "${HOME}/.ssh/id_ed25519"
        "${HOME}/.ssh/id_ecdsa"
        "${HOME}/.ssh/id_ed25519_fub"
    )

    # Add FUB-specific key if SSH_RSA is set
    if [[ -n "${SSH_RSA:-}" ]]; then
        key_paths=("${HOME}/.ssh/$SSH_RSA" "${key_paths[@]}")
    fi

    for key_path in "${key_paths[@]}"; do
        if [[ -f "$key_path" ]]; then
            log_info "Attempting to load SSH key: $key_path"
            if ssh-add "$key_path" >/dev/null 2>&1; then
                ((keys_loaded++))
                log_success "✅ Loaded SSH key: $key_path"
            else
                log_warning "⚠️ Failed to load SSH key: $key_path"
            fi
        fi
    done

    if [[ $keys_loaded -eq 0 ]]; then
        log_error "❌ No SSH keys could be loaded"
        return 1
    fi

    log_success "✅ Loaded $keys_loaded SSH key(s)"
    return 0
}

# ============================================================================
# SSH Key Validation Functions
# ============================================================================

# Validate SSH keys are available in agent
# Usage: ssh_validate_keys
ssh_validate_keys() {
    log_info "Checking SSH keys..."

    # Ensure agent is running
    if ! ssh_ensure_agent_running; then
        provide_ssh_key_guidance
        return 1
    fi

    # Check if keys are loaded
    if ! ssh-add -l >/dev/null 2>&1; then
        local ssh_add_status=$?

        case $ssh_add_status in
            1)
                log_error "SSH agent is running but no keys are loaded"
                provide_ssh_key_guidance
                return 1
                ;;
            2)
                log_error "SSH agent is not accessible"
                provide_ssh_key_guidance
                return 1
                ;;
            *)
                log_error "SSH agent check failed with status $ssh_add_status"
                provide_ssh_key_guidance
                return 1
                ;;
        esac
    fi

    # Show loaded keys for verification
    log_success "✅ SSH keys loaded in agent:"
    ssh-add -l | sed 's/^/   /'

    return 0
}

# ============================================================================
# SSH Connection Testing Functions
# ============================================================================

# Test SSH connectivity with proper timeout and error handling
# Usage: ssh_test_connectivity <server>
ssh_test_connectivity() {
    local server="$1"

    log_info "Testing SSH connection to $server..."

    # Test with timeout and batch mode (no interactive prompts)
    if timeout $SSH_TEST_TIMEOUT ssh -o ConnectTimeout=$SSH_CONNECT_TIMEOUT \
        -o BatchMode=yes -o StrictHostKeyChecking=no \
        "$server" 'echo "SSH connection test successful"' >/dev/null 2>&1; then

        log_success "✅ SSH connection test passed"
        return 0
    else
        local ssh_exit_code=$?
        log_error "❌ SSH connection failed to $server (exit code: $ssh_exit_code)"
        return $ssh_exit_code
    fi
}

# Verify remote server capabilities
# Usage: ssh_verify_remote_requirements <server>
ssh_verify_remote_requirements() {
    local server="$1"

    log_info "Verifying remote server requirements..."

    # Check if server has required tools (consolidated from multiple skills)
    local required_commands="rsync find ls mkdir rm cat head tail"
    local missing_commands=()

    for cmd in $required_commands; do
        if ! timeout $SSH_TEST_TIMEOUT ssh -o ConnectTimeout=$SSH_CONNECT_TIMEOUT \
            -o BatchMode=yes "$server" "command -v $cmd" >/dev/null 2>&1; then
            missing_commands+=("$cmd")
        fi
    done

    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_error "❌ Missing required commands on $server: ${missing_commands[*]}"
        echo "Contact system administrator to install missing tools"
        return 1
    fi

    # Test file operations capability
    local test_dir="/tmp/remote-connectivity-test-$$"
    if timeout $SSH_TEST_TIMEOUT ssh -o ConnectTimeout=$SSH_CONNECT_TIMEOUT \
        -o BatchMode=yes "$server" "mkdir -p $test_dir && touch $test_dir/test && rm -rf $test_dir" >/dev/null 2>&1; then

        log_success "✅ Remote server requirements verified"
        return 0
    else
        log_error "❌ Cannot perform required file operations on $server"
        echo "Check file system permissions and disk space"
        return 1
    fi
}

# ============================================================================
# Unified SSH Validation Function
# ============================================================================

# Full SSH validation pipeline (3-step process from ssh-validation.sh)
# Usage: ssh_full_validation [server]
ssh_full_validation() {
    local server="${1:-$DEFAULT_SSH_SERVER}"

    log_info "🔑 Validating SSH connection to $server"

    # Step 1: Validate SSH keys
    if ! ssh_validate_keys; then
        return 1
    fi

    # Step 2: Test connectivity
    if ! ssh_test_connectivity "$server"; then
        local ssh_exit_code=$?
        provide_ssh_troubleshooting "$server" "$ssh_exit_code"
        return 2
    fi

    # Step 3: Verify remote capabilities
    if ! ssh_verify_remote_requirements "$server"; then
        return 3
    fi

    log_success "✅ SSH validation successful for $server"
    return 0
}

# ============================================================================
# SSH Recovery and Guidance Functions
# ============================================================================

# Provide SSH key loading guidance (following FUB patterns)
# Usage: provide_ssh_key_guidance
provide_ssh_key_guidance() {
    echo ""
    log_info "🔧 SSH Key Setup:"
    echo "1. Add your SSH key to the agent:"

    if [[ -n "${SSH_RSA:-}" ]]; then
        echo "   ssh-add ~/.ssh/$SSH_RSA"
    else
        echo "   ssh-add ~/.ssh/id_rsa"
        echo "   # Or for specific key: ssh-add ~/.ssh/your_key_name"
    fi

    echo ""
    echo "2. Verify key is loaded:"
    echo "   ssh-add -l"
    echo ""
    echo "3. For persistent keys (12 hour timeout per team-setup-guide.md):"
    echo "   ssh-add -t $SSH_AGENT_TIMEOUT ~/.ssh/id_rsa"
    echo ""
}

# Provide SSH connection troubleshooting guidance
# Usage: provide_ssh_troubleshooting <server> <exit_code>
provide_ssh_troubleshooting() {
    local server="$1"
    local exit_code="$2"

    echo ""
    log_info "🔧 SSH Troubleshooting for $server:"

    case $exit_code in
        124)  # timeout
            echo "• Connection timed out - check network connectivity"
            echo "• Verify Tailscale is connected: tailscale status"
            echo "• Check for VPN conflicts (use /remote-connectivity-management --operation=cisco-conflict-detect)"
            echo "• Try connecting manually: ssh $server"
            ;;
        255)  # SSH connection error
            echo "• SSH connection refused or host unreachable"
            echo "• Check if Tailscale is running: tailscale status"
            echo "• Verify server hostname: $server"
            echo "• Test manual connection: ssh $server"
            ;;
        *)
            echo "• Unexpected SSH error (exit code: $exit_code)"
            echo "• Try manual connection for more details: ssh $server"
            echo "• Check SSH client configuration"
            ;;
    esac

    echo ""
    echo "Common fixes:"
    echo "• Ensure Tailscale is connected and authenticated"
    echo "• Run VPN diagnostics: /remote-connectivity-management --operation=vpn-status"
    echo "• Verify SSH key has correct permissions (600 for private key)"
    echo "• Check ~/.ssh/config for any conflicting settings"
    echo ""
}

# Automated SSH problem resolution
# Usage: apply_ssh_key_recovery [server] [force_reload]
apply_ssh_key_recovery() {
    local server="${1:-$DEFAULT_SSH_SERVER}"
    local force_reload="${2:-false}"

    log_info "🔧 Attempting automated SSH issue resolution..."

    # Ensure SSH agent is running
    if ! ssh_ensure_agent_running; then
        return 1
    fi

    # Try to load keys
    if ssh_load_common_keys "$force_reload"; then
        log_success "✅ SSH keys loaded successfully"
    else
        log_error "❌ Failed to load SSH keys"
        provide_ssh_key_guidance
        return 1
    fi

    # Test connection again after fixes
    if ssh_full_validation "$server"; then
        log_success "✅ SSH issues resolved automatically"
        return 0
    else
        log_error "❌ Automated resolution failed - manual intervention required"
        return 1
    fi
}

# ============================================================================
# Export Functions for Other Scripts
# ============================================================================

# Export all functions for use by other scripts (following FUB patterns)
export -f ssh_ensure_agent_running ssh_load_common_keys ssh_validate_keys
export -f ssh_test_connectivity ssh_verify_remote_requirements ssh_full_validation
export -f provide_ssh_key_guidance provide_ssh_troubleshooting apply_ssh_key_recovery

# Backward compatibility aliases (for existing skill integration)
validate_ssh_connection() { ssh_full_validation "$@"; }
validate_ssh_keys() { ssh_validate_keys "$@"; }
test_ssh_connection() { ssh_test_connectivity "$@"; }
verify_mutagen_ssh_requirements() { ssh_verify_remote_requirements "$@"; }
fix_ssh_issues() { apply_ssh_key_recovery "$@"; }

export -f validate_ssh_connection validate_ssh_keys test_ssh_connection
export -f verify_mutagen_ssh_requirements fix_ssh_issues