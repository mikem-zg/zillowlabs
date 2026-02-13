## Mutagen Management Reference Guide

### Parameters Reference

#### Required Parameters
- `--operation` (required): Operation to perform - status (check sync health), setup (initial configuration), troubleshoot (diagnose and fix issues), monitor (real-time monitoring), reset (force resync), flush (immediate sync)

#### Optional Parameters
- `--session_name` (optional): Specific session name to target (defaults to 'fub' for FUB development)
- `--server` (optional): Remote server hostname (defaults to FUB_DEV_HOST environment variable or fubdev-matttu-dev-01)
- `--config_path` (optional): Path to Mutagen configuration file (defaults to .mutagen.yml in project root)

### Usage Examples Reference

```bash
# Check sync health for default FUB development session
/mutagen-management --operation="status"

# Check status for specific session with custom server
/mutagen-management --operation="status" --session_name="fub-backend" --server="fubdev-matttu-dev-02"

# Set up initial Mutagen configuration for new development environment
/mutagen-management --operation="setup" --server="fubdev-matttu-dev-01"

# Troubleshoot sync issues and apply automatic fixes
/mutagen-management --operation="troubleshoot" --session_name="fub"

# Monitor real-time sync activity for debugging
/mutagen-management --operation="monitor" --session_name="fub"

# Force immediate sync flush for testing changes
/mutagen-management --operation="flush" --session_name="fub"

# Reset sync session when conflicts are unresolvable
/mutagen-management --operation="reset" --session_name="fub"

# Set up sync with custom configuration file
/mutagen-management --operation="setup" --config_path="/path/to/custom/.mutagen.yml"
```

### Complete Configuration Templates

#### Standard FUB Development Configuration
```yaml
# .mutagen.yml (Standard FUB Development)
sync:
  defaults:
    mode: "two-way-resolved"
    ignore:
      vcs: true
      paths: ["node_modules/", "vendor/", ".git/", "*.swp", "*.tmp"]
    permissions:
      defaultFileMode: 0644
      defaultDirectoryMode: 0755

  fub:
    alpha: "${PWD}/fub"
    beta: "ssh://fubdev-matttu-dev-01/var/www/fub"
    mode: "two-way-resolved"
    ignore:
      paths:
        - ".git/"
        - "phpunit-cache/"
        - "apps/richdesk/tests/coverage/"
        - "apps/richdesk/resources/tmp/"

  fub-spa:
    alpha: "${PWD}/fub-spa"
    beta: "ssh://fubdev-matttu-dev-01/var/www/fub-spa"
    mode: "two-way-resolved"
    ignore:
      paths:
        - ".git/"
        - "node_modules/"
        - "dist/"
        - ".nuxt/"
        - ".output/"
```

#### High-Performance Configuration
```yaml
# .mutagen.yml (High-Performance)
sync:
  defaults:
    mode: "two-way-resolved"
    scanMode: "accelerated"
    stageMode: "neighboring"
    ignore:
      vcs: true
      paths: ["node_modules/", "vendor/", ".git/", "*.log", "*.tmp", "*.swp", "*.swo"]
    permissions:
      defaultFileMode: 0644
      defaultDirectoryMode: 0755
    watchMode: "portable"
    watchPollingInterval: "5s"

  fub-optimized:
    alpha: "${PWD}/fub"
    beta: "ssh://fubdev-matttu-dev-01/var/www/fub"
    mode: "two-way-resolved"
    ignore:
      paths:
        - ".git/"
        - "vendor/"
        - "storage/framework/"
        - "bootstrap/cache/"
        - "phpunit-cache/"
        - "apps/richdesk/tests/coverage/"
        - "apps/richdesk/resources/tmp/"
        - "storage/logs/"
```

### Comprehensive Troubleshooting Guide

#### Common Issues and Solutions

| Issue | Symptoms | Diagnostic Commands | Solution |
|-------|----------|-------------------|----------|
| **Session Paused** | "Paused" in status output | `mutagen sync list` | `mutagen sync resume fub` |
| **Conflicts Detected** | "Conflicts detected" message | `mutagen sync list --long` | `mutagen sync reset fub` (local wins) |
| **Daemon Not Running** | Command fails, no output | `mutagen daemon status` | `mutagen daemon stop && mutagen daemon start` |
| **SSH Connection Failed** | Connection timeout errors | `ssh fubdev-matttu-dev-01` | Check Tailscale: `tailscale status` |
| **Permission Denied** | "Permission denied" on remote | `ssh server 'ls -la /var/www/fub'` | `ssh server 'sudo chown -R $USER:$USER /var/www/fub'` |
| **High CPU Usage** | Mutagen consuming excessive CPU | `ps aux \| grep mutagen` | Optimize ignore patterns, restart daemon |
| **Slow Sync Speed** | Long sync times | `mutagen sync list --long` | Check ignore patterns, network connectivity |
| **File Not Syncing** | Specific files not appearing | Check ignore patterns | Verify file not in ignore list |

#### Diagnostic Command Reference

```bash
# Status and Health Checks
mutagen sync list                    # Quick session overview
mutagen sync list --long            # Detailed session information
mutagen daemon status               # Daemon health check
mutagen sync monitor                # Real-time sync monitoring

# Session Management
mutagen sync create alpha beta      # Create new sync session
mutagen sync resume session_name    # Resume paused session
mutagen sync pause session_name     # Pause active session
mutagen sync flush session_name     # Force immediate sync
mutagen sync reset session_name     # Reset session (resolve conflicts)
mutagen sync terminate session_name # Terminate session permanently

# Daemon Management
mutagen daemon start               # Start Mutagen daemon
mutagen daemon stop                # Stop Mutagen daemon
mutagen daemon status              # Check daemon status

# Configuration Management
mutagen sync create --configuration-file=.mutagen.yml  # Use config file
mutagen project list               # List project-based configurations
```

#### Environment Validation Commands

```bash
# SSH Connectivity Check
ssh -o ConnectTimeout=10 fubdev-matttu-dev-01 'echo "SSH connection successful"'

# Tailscale VPN Status
tailscale status | grep "fubdev.*online"

# Remote Directory Permissions
ssh fubdev-matttu-dev-01 'ls -la /var/www/ | grep fub'

# Local Directory Status
ls -la fub/ fub-spa/ 2>/dev/null || echo "Local directories not found"

# Network Connectivity
ping -c 3 fubdev-matttu-dev-01

# Mutagen Installation Check
mutagen version
```

### Best Practices and Standards

#### Sync Management Standards
- **Always verify sync status** before major development operations
- **Use flush operations** before test execution and deployment
- **Monitor sync health** during heavy file operations
- **Reset sessions** to resolve conflicts quickly (local wins)
- **Coordinate with team** on shared remote environment modifications

#### Performance Guidelines
- **Limit Active Sessions**: Maintain fewer than 5 concurrent sessions
- **Optimize Ignore Patterns**: Regularly update patterns to exclude unnecessary files
- **Monitor Resource Usage**: Track daemon CPU and memory usage
- **Clean Up Regularly**: Remove unused sessions and clear daemon state when needed

#### Integration Requirements
- **Test Coordination**: Ensure sync completion before remote test execution
- **Coverage Integration**: Verify coverage report synchronization after test runs
- **Git Coordination**: Maintain sync state during git operations
- **Environment Alignment**: Use consistent server and path configurations

### Error Recovery Procedures

#### Complete Session Recovery
```bash
# Complete session recovery procedure
recover_mutagen_session() {
    local session=${1:-fub}

    echo "Starting complete recovery for session: $session"

    # 1. Pause problematic session
    mutagen sync pause "$session" 2>/dev/null || true

    # 2. Verify daemon health
    if ! mutagen daemon status >/dev/null 2>&1; then
        echo "Restarting daemon..."
        mutagen daemon stop 2>/dev/null || true
        sleep 2
        mutagen daemon start
    fi

    # 3. Reset session state
    echo "Resetting session state..."
    mutagen sync reset "$session"

    # 4. Resume operations
    echo "Resuming synchronization..."
    mutagen sync resume "$session"

    # 5. Verify recovery
    sleep 5
    if mutagen sync list | grep -q "$session.*Connected"; then
        echo "✓ Recovery successful"
        return 0
    else
        echo "✗ Recovery failed - manual intervention required"
        return 1
    fi
}
```

#### Emergency Daemon Restart
```bash
# Emergency daemon restart with state preservation
emergency_daemon_restart() {
    echo "Performing emergency daemon restart..."

    # 1. Save current session list
    mutagen sync list > /tmp/mutagen_sessions_backup.txt 2>/dev/null || true

    # 2. Stop daemon gracefully
    mutagen daemon stop 2>/dev/null || true

    # 3. Wait for complete shutdown
    sleep 5

    # 4. Force kill if necessary
    pkill -f mutagen 2>/dev/null || true

    # 5. Start fresh daemon
    mutagen daemon start

    # 6. Wait for initialization
    sleep 3

    # 7. Verify daemon health
    if mutagen daemon status >/dev/null 2>&1; then
        echo "✓ Daemon restart successful"
        echo "Note: You may need to recreate sessions if they don't auto-restore"
    else
        echo "✗ Daemon restart failed"
        return 1
    fi
}
```

### Refusal Conditions

The skill must refuse if:
- Mutagen is not installed locally (`brew install mutagen-io/mutagen/mutagen`)
- SSH validation fails using the Remote Connectivity Management Skill (includes SSH keys, VPN connectivity, and Mutagen requirements)
- Tailscale VPN connection is not active (for FUB development)
- Required environment variables (`FUB_DEV_HOST`, `FUB_PROJECT_PATH`) are not set and no alternatives provided
- Mutagen daemon cannot be started or is in an unrecoverable state
- Specified session names don't exist and operation requires existing sessions
- Remote server is not accessible or responds with authentication errors after SSH validation and troubleshooting attempts

#### Refusal Response Template

When refusing, explain which requirement prevents execution and provide specific steps to resolve the issue, including:

**Installation Issues:**
```bash
# Install Mutagen if missing
brew install mutagen-io/mutagen/mutagen

# Verify installation
mutagen version
```

**Connectivity Issues:**
```bash
# Use Remote Connectivity Management for SSH validation
/remote-connectivity-management --operation=validate --server=fubdev-matttu-dev-01

# Activate Tailscale VPN
tailscale up
tailscale status
```

**Configuration Issues:**
```bash
# Set required environment variables
export FUB_DEV_HOST="fubdev-matttu-dev-01"
export FUB_PROJECT_PATH="/var/www/fub"

# Or provide alternatives via parameters
/mutagen-management --operation=status --server=fubdev-matttu-dev-01
```

**Critical Note**: Mutagen management prioritizes file synchronization integrity and development workflow continuity. When in doubt about sync state or potential data conflicts, always err on the side of caution and request explicit user confirmation before proceeding with destructive operations.

This reference guide provides comprehensive support for understanding, configuring, and troubleshooting Mutagen synchronization management in FUB development environments.