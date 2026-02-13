---
name: mutagen-management
description: Manage Mutagen file synchronization sessions with status monitoring, troubleshooting, and integration with FUB development workflows
---

## Overview

Manage Mutagen file synchronization sessions with status monitoring, troubleshooting, and integration with FUB development workflows. Provides comprehensive Mutagen session management including setup, monitoring, troubleshooting, and optimization for efficient remote development synchronization with FUB environments.

📝 **Sync Patterns**: [templates/sync-patterns.md](templates/sync-patterns.md)
🔧 **Advanced Monitoring**: [advanced/monitoring-troubleshooting.md](advanced/monitoring-troubleshooting.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **Reference Guide**: [reference/mutagen-reference.md](reference/mutagen-reference.md)

## Usage

```bash
/mutagen-management --operation=<op_type> [--session_name=<name>] [--server=<hostname>] [--config_path=<path>]
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Status Check and Health Monitoring**
```bash
# SSH validation first (automatic pre-flight check) - Enhanced with VPN conflict detection
claude /remote-connectivity-management --operation=validate --server="${server:-fubdev-matttu-dev-01}"
if [[ $? -ne 0 ]]; then
    echo "❌ SSH validation failed - aborting Mutagen operations"
    echo "Run: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
    exit 1
fi

# Check sync health (most frequent operation)
mutagen sync list --long

# Quick status with health indicators
mutagen sync list | grep -E "(Problems|Conflicts|Paused|Connected)"

# Verify daemon and connectivity
mutagen daemon status
```

**2. Immediate Synchronization (Pre-Test/Deploy)**
```bash
# SSH validation before sync operations - Enhanced with VPN conflict detection
claude /remote-connectivity-management --operation=validate --server="${server:-fubdev-matttu-dev-01}" || exit 1

# Force sync before operations (essential for test coordination)
SESSION=${session_name:-fub}
mutagen sync flush "$SESSION"

# Verify completion
sleep 2
mutagen sync list --long | grep -A5 "$SESSION"
```

**3. Quick Issue Resolution**
```bash
# Resume paused sessions
mutagen sync resume fub 2>/dev/null || true

# Reset conflicts (local wins)
mutagen sync reset fub

# Restart daemon if needed
mutagen daemon stop && sleep 2 && mutagen daemon start
```

**4. Daily Development Setup**
```bash
# Morning initialization
tailscale status | grep "fubdev.*online"  # Verify VPN
mutagen sync list --long                  # Check sessions
mutagen sync resume fub                   # Restore session
mutagen sync flush fub                    # Sync changes
```

### Quick Reference

#### Mutagen Operations

| **Operation** | **Command** | **Use Case** | **Frequency** |
|---------------|-------------|--------------|---------------|
| **status** | `mutagen sync list --long` | Health check, issue identification | Daily |
| **flush** | `mutagen sync flush fub` | Pre-test, pre-deploy sync | Before tests |
| **setup** | Create `.mutagen.yml` + sessions | Initial configuration | One-time |
| **troubleshoot** | Automated diagnosis + fixes | Resolve sync issues | As needed |
| **reset** | `mutagen sync reset fub` | Clear conflicts (local wins) | When conflicted |
| **monitor** | `mutagen sync monitor` | Real-time status tracking | During heavy ops |

#### FUB Environment Configuration

| **Environment** | **Local Path** | **Remote Path** | **Server** |
|-----------------|----------------|-----------------|------------|
| **FUB** | `${PWD}/fub` | `/var/www/fub` | fubdev-matttu-dev-01 |
| **FUB SPA** | `${PWD}/fub-spa` | `/var/www/fub-spa` | fubdev-matttu-dev-01 |

#### Common Troubleshooting

| **Issue** | **Symptoms** | **Quick Fix** |
|-----------|-------------|---------------|
| **Session Paused** | "Paused" in status | `mutagen sync resume fub` |
| **Conflicts** | "Conflicts detected" | `mutagen sync reset fub` (local wins) |
| **Daemon Down** | Command fails, no output | `mutagen daemon stop && mutagen daemon start` |
| **SSH Connection** | Connection timeout | Check Tailscale: `tailscale status` |
| **Permission Issues** | "Permission denied" | `ssh ${server} 'sudo chown -R $USER:$USER /var/www/fub'` |

#### FUB Integration Commands

```bash
# Pre-Test Integration (backend-test-development)
mutagen sync flush fub
echo "✓ Ready for remote test execution"

# Post-Test Coverage Sync
mutagen sync flush fub
ls -la fub/phpunit-cache/cov.xml  # Verify coverage sync

# Git Operation Coordination
mutagen sync flush fub             # Sync before git operations
mutagen sync list | grep "Connected"  # Verify health

# Performance Monitoring
mutagen sync list --long | grep -E "(Session|Total|Scanned)"
ps aux | grep mutagen | grep -v grep
```

#### Basic Configuration Template

```yaml
# .mutagen.yml (FUB Development)
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
```

→ **Complete sync patterns and daily operations**: [templates/sync-patterns.md](templates/sync-patterns.md)

## Cross-Skill Integration

### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `backend-test-development` | **Test Coordination** | Pre-test sync, coverage report synchronization, remote test execution |
| `support-investigation` | **Issue Resolution** | Sync troubleshooting, environment diagnosis, development workflow issues |
| `serena-mcp` | **Code Synchronization** | File change monitoring, project structure analysis, code deployment |
| `remote-connectivity-management` | **Connection Management** | SSH validation, VPN troubleshooting, connection recovery |

### Multi-Skill Operation Examples

**Complete Development Session Workflow:**
1. `mutagen-management` - Initialize daily sync status and ensure healthy connections
2. `serena-mcp` - Analyze and modify code with real-time file synchronization
3. `backend-test-development` - Execute tests with coordinated coverage synchronization
4. `mutagen-management` - Verify sync completion and resolve any issues
5. `support-investigation` - Diagnose and resolve any sync-related development issues

→ **Complete integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Capabilities

### Automated Troubleshooting Intelligence
- Intelligent sync problem diagnosis and automated resolution
- SSH connectivity validation with VPN conflict detection
- Performance monitoring with resource usage optimization
- Comprehensive error recovery with session state preservation

### Development Workflow Integration
- Pre-test synchronization verification and coordination
- Post-test coverage report synchronization and validation
- Git operation coordination with sync state management
- Real-time monitoring with development workflow notifications

→ **Advanced monitoring workflows and troubleshooting patterns**: [advanced/monitoring-troubleshooting.md](advanced/monitoring-troubleshooting.md)

## Best Practices

**Sync Management Standards:**
- Always verify sync status before major development operations
- Use flush operations before test execution and deployment
- Monitor sync health during heavy file operations
- Reset sessions to resolve conflicts quickly (local wins)
- Coordinate with team on shared remote environment modifications

**Performance Guidelines:**
- Limit Active Sessions: Maintain fewer than 5 concurrent sessions
- Optimize Ignore Patterns: Regularly update patterns to exclude unnecessary files
- Monitor Resource Usage: Track daemon CPU and memory usage
- Clean Up Regularly: Remove unused sessions and clear daemon state when needed

## Refusal Conditions

The skill must refuse if:
- Mutagen is not installed locally (`brew install mutagen-io/mutagen/mutagen`)
- SSH validation fails using the Remote Connectivity Management Skill
- Tailscale VPN connection is not active (for FUB development)
- Required environment variables are not set and no alternatives provided
- Mutagen daemon cannot be started or is in an unrecoverable state
- Specified session names don't exist and operation requires existing sessions
- Remote server is not accessible after SSH validation and troubleshooting attempts

→ **Complete troubleshooting guide and configuration reference**: [reference/mutagen-reference.md](reference/mutagen-reference.md)

## Supporting Infrastructure

→ **Advanced monitoring and troubleshooting patterns**: [advanced/monitoring-troubleshooting.md](advanced/monitoring-troubleshooting.md)
→ **Essential sync patterns and daily operations**: [templates/sync-patterns.md](templates/sync-patterns.md)
→ **Cross-skill integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

This skill provides comprehensive Mutagen synchronization management with intelligent troubleshooting, seamless development workflow integration, and automated coordination with FUB remote development environments.