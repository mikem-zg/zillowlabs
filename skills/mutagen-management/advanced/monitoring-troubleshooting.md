## Advanced Monitoring and Troubleshooting Patterns

### Comprehensive Setup Workflow

**Initial Mutagen Configuration:**
- Detect existing configuration or create new `.mutagen.yml`
- Configure FUB-specific session parameters
- Set up appropriate ignore patterns for FUB development
- Establish SSH-based sync sessions
- Verify initial synchronization completion

**Setup Implementation:**
1. Verify prerequisites (Mutagen installed, SSH access, Tailscale connection)
2. Create or update `.mutagen.yml` configuration
3. Create sync sessions using `mutagen sync create`
4. Perform initial sync and verify completion
5. Test bidirectional synchronization with small test files
6. Integrate with existing development workflow documentation

### Automated Troubleshooting Workflows

**Diagnostic and Resolution Workflow:**
- Identify specific sync problems through automated analysis
- Apply common fixes for typical issues
- Verify resolution and restore healthy sync state
- Provide detailed reporting on actions taken

#### Sync Paused or Stalled Resolution
```bash
# Diagnose paused sessions
PAUSED_SESSIONS=$(mutagen sync list | grep "Paused" | awk '{print $1}')

# Resume and flush paused sessions
for session in $PAUSED_SESSIONS; do
    echo "Resuming session: $session"
    mutagen sync resume "$session"
    mutagen sync flush "$session"
done
```

#### Permission Error Resolution
```bash
# Check remote permissions
ssh ${server} 'ls -la /var/www/fub | head -5'

# Fix ownership if needed (with user confirmation)
echo "Checking file ownership on remote server..."
ssh ${server} 'sudo chown -R $USER:$USER /var/www/fub'
```

#### SSH Connection Troubleshooting
```bash
# Use Remote Connectivity Management Skill for enhanced SSH validation and troubleshooting
# Interactive SSH troubleshooting with VPN conflict detection and automated fixes
claude /remote-connectivity-management --operation=troubleshoot --interactive=true --server="${server}"

# Alternative: Quick validation with specific error guidance
claude /remote-connectivity-management --operation=validate --server="${server}" || {
    echo "SSH validation failed - see guidance above"
    claude /remote-connectivity-management --operation=recovery-guide
}
```

#### Conflict Resolution Protocol
```bash
# Identify conflicted sessions
CONFLICTED=$(mutagen sync list --long | grep -B2 "Conflicts detected" | grep "Name:" | awk '{print $2}')

# Reset conflicts (accepting local changes)
for session in $CONFLICTED; do
    echo "Resolving conflicts in session: $session"
    echo "This will accept local (alpha) changes and overwrite remote conflicts."
    mutagen sync reset "$session"
done
```

### Real-Time Monitoring Implementation

**Continuous Sync Monitoring:**
- Launch real-time sync status monitoring
- Display live statistics on file transfers, conflicts, and performance
- Alert on status changes or performance degradation
- Integrate with development workflow notifications

```bash
# Launch interactive monitoring
echo "Starting real-time sync monitoring. Press Ctrl+C to stop."
mutagen sync monitor

# Alternative: Status polling for integration
while true; do
    STATUS=$(mutagen sync list | grep -E "(Problems|Conflicts|Disconnected)")
    if [ -n "$STATUS" ]; then
        echo "[$(date)] Sync issues detected:"
        echo "$STATUS"
    fi
    sleep 10
done
```

### Performance Monitoring and Optimization

**Performance Metrics:**
- Monitor file transfer rates and sync latency
- Identify performance bottlenecks in ignore patterns
- Analyze disk usage and sync directory sizes
- Report on daemon resource utilization

```bash
# Analyze sync performance
mutagen sync list --long | grep -E "(Session|Total|Scanned|Problems)"

# Check daemon resource usage
ps aux | grep mutagen | grep -v grep

# Analyze sync directory sizes
du -sh fub/ fub-spa/ 2>/dev/null || echo "Checking local workspace sizes..."
```

**Optimization Recommendations:**
- **Ignore Pattern Optimization**: Analyze frequently changing files that should be ignored
- **Resource Usage Optimization**: Monitor concurrent session limits and suggest consolidation
- **Performance Tuning**: Recommend staging file thresholds for large files

### Comprehensive Error Recovery

**Error Classification and Response:**
1. **Transient Errors**: Automatic retry with exponential backoff
2. **Configuration Errors**: Guide user through config fixes
3. **Connectivity Errors**: Verify SSH and Tailscale connectivity
4. **Permission Errors**: Provide specific commands to resolve
5. **Daemon Errors**: Complete daemon restart and state recovery

**Recovery Protocols:**
```bash
# Comprehensive error recovery workflow
recover_mutagen_sync() {
    local session=${1:-fub}

    echo "Starting Mutagen sync recovery for session: $session"

    # Step 1: Stop any problematic operations
    mutagen sync pause "$session" 2>/dev/null || true

    # Step 2: Check daemon health
    if ! mutagen daemon status >/dev/null 2>&1; then
        echo "Restarting Mutagen daemon..."
        mutagen daemon stop 2>/dev/null || true
        mutagen daemon start
    fi

    # Step 3: Reset session state
    echo "Resetting session state..."
    mutagen sync reset "$session"

    # Step 4: Resume operations
    echo "Resuming synchronization..."
    mutagen sync resume "$session"

    # Step 5: Verify recovery
    sleep 5
    if mutagen sync list | grep -q "$session.*Connected"; then
        echo "✓ Sync recovery successful"
        return 0
    else
        echo "✗ Sync recovery failed - manual intervention required"
        return 1
    fi
}
```

### Test Execution Coordination

**Pre-Test Sync Verification:**
- Verify sync health before executing remote tests
- Ensure coverage report paths are properly synchronized
- Coordinate with `backend-test-development` skill for seamless integration

```bash
# Pre-test sync check
if ! mutagen sync list | grep -q "fub.*Connected"; then
    echo "⚠ Mutagen sync not healthy. Running troubleshoot operation..."
    # Execute troubleshoot workflow
fi

# Ensure coverage directory sync
mutagen sync flush fub
echo "✓ Ready for remote test execution with coverage sync"
```

**Post-Test Coverage Synchronization:**
- Monitor coverage report generation on remote server
- Ensure coverage files sync back to local workspace
- Verify coverage reports are accessible for local analysis

```bash
# Post-test coverage sync verification
COVERAGE_LOCAL="fub/phpunit-cache/cov.xml"
COVERAGE_REMOTE="/var/www/fub/phpunit-cache/cov.xml"

# Check if coverage file exists remotely
if ssh ${server} "test -f $COVERAGE_REMOTE"; then
    echo "Coverage file exists on remote, ensuring sync..."
    mutagen sync flush fub

    # Wait for sync and verify local access
    sleep 3
    if [ -f "$COVERAGE_LOCAL" ]; then
        echo "✓ Coverage report synchronized: $COVERAGE_LOCAL"
    else
        echo "⚠ Coverage report sync incomplete"
    fi
else
    echo "ℹ No coverage report found on remote server"
fi
```

### Advanced Configuration Patterns

**Multi-Project Configuration:**
```yaml
# Advanced .mutagen.yml for multiple projects
sync:
  defaults:
    mode: "two-way-resolved"
    ignore:
      vcs: true
      paths: ["node_modules/", "vendor/", ".git/", "*.swp", "*.tmp", "*.log"]
    permissions:
      defaultFileMode: 0644
      defaultDirectoryMode: 0755
    watchMode: "portable"
    watchPollingInterval: "10s"

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
        - "storage/logs/"
        - "storage/framework/cache/"
        - "storage/framework/sessions/"
        - "storage/framework/views/"

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

**Performance-Optimized Configuration:**
```yaml
# High-performance sync configuration
sync:
  fub-optimized:
    alpha: "${PWD}/fub"
    beta: "ssh://fubdev-matttu-dev-01/var/www/fub"
    mode: "two-way-resolved"
    scanMode: "accelerated"
    stageMode: "neighboring"
    ignore:
      paths:
        - ".git/"
        - "vendor/"
        - "node_modules/"
        - "storage/framework/"
        - "bootstrap/cache/"
        - "phpunit-cache/"
        - "*.log"
        - "*.tmp"
        - "*.swp"
        - "*.swo"
    permissions:
      defaultFileMode: 0644
      defaultDirectoryMode: 0755
    watchMode: "portable"
    watchPollingInterval: "5s"
```

These advanced patterns provide comprehensive monitoring, troubleshooting, and optimization capabilities for managing complex Mutagen synchronization workflows in FUB development environments.