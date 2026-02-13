## Mutagen Sync Patterns and Common Operations

### Essential Daily Operations

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

### Mutagen Operations Quick Reference

| **Operation** | **Command** | **Use Case** | **Frequency** |
|---------------|-------------|--------------|---------------|
| **status** | `mutagen sync list --long` | Health check, issue identification | Daily |
| **flush** | `mutagen sync flush fub` | Pre-test, pre-deploy sync | Before tests |
| **setup** | Create `.mutagen.yml` + sessions | Initial configuration | One-time |
| **troubleshoot** | Automated diagnosis + fixes | Resolve sync issues | As needed |
| **reset** | `mutagen sync reset fub` | Clear conflicts (local wins) | When conflicted |
| **monitor** | `mutagen sync monitor` | Real-time status tracking | During heavy ops |

### FUB Environment Configuration

| **Environment** | **Local Path** | **Remote Path** | **Server** |
|-----------------|----------------|-----------------|------------|
| **FUB** | `${PWD}/fub` | `/var/www/fub` | fubdev-matttu-dev-01 |
| **FUB SPA** | `${PWD}/fub-spa` | `/var/www/fub-spa` | fubdev-matttu-dev-01 |

### Common Troubleshooting Quick Fixes

| **Issue** | **Symptoms** | **Quick Fix** |
|-----------|-------------|---------------|
| **Session Paused** | "Paused" in status | `mutagen sync resume fub` |
| **Conflicts** | "Conflicts detected" | `mutagen sync reset fub` (local wins) |
| **Daemon Down** | Command fails, no output | `mutagen daemon stop && mutagen daemon start` |
| **SSH Connection** | Connection timeout | Check Tailscale: `tailscale status` |
| **Permission Issues** | "Permission denied" | `ssh ${server} 'sudo chown -R $USER:$USER /var/www/fub'` |

### FUB Integration Commands

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

### Basic Configuration Template

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

These patterns cover the essential daily operations for Mutagen synchronization management in FUB development environments, providing quick reference for the most common use cases and immediate issue resolution.