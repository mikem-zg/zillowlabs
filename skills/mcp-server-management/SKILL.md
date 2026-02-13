---
name: mcp-server-management
description: Comprehensive MCP server management for Claude Code including connection monitoring, automatic restart capabilities, health checks, and fallback mechanisms for handling MCP server failures in FUB development environment
---

# MCP Server Management Skill

## Overview

Comprehensive MCP server management for Claude Code that provides connection monitoring, automatic restart capabilities, health checks, and fallback mechanisms for handling MCP server failures. Designed specifically for FUB development environment with automated recovery protocols and intelligent failure detection.

**Key Capabilities:**
- Real-time MCP server health monitoring and status checking
- Automatic restart/reconnection using built-in `claude mcp` commands
- Connection failure detection and recovery protocols
- Intelligent fallback mechanism suggestions (acli, glab, direct APIs)
- Integration with error handling patterns for MCP-dependent skills

**Core Principle:** Minimize workflow disruption from MCP failures through proactive monitoring and automated recovery.

## Usage

```bash
# Quick health check of all MCP servers
/mcp-server-management

# Check specific server health
/mcp-server-management --operation=health-check --server_name=atlassian

# Restart failed server
/mcp-server-management --operation=restart-server --server_name=atlassian

# Comprehensive failure diagnosis
/mcp-server-management --operation=diagnose-failures

# Setup fallback mechanisms
/mcp-server-management --operation=setup-fallbacks --enable_fallbacks=true

# Start continuous performance monitoring
/mcp-server-management --operation=monitor-performance

# Session complexity management
/mcp-server-management --operation=session-summary      # Current session status
/mcp-server-management --operation=session-optimize     # Get optimization recommendations
/mcp-server-management --operation=session-reset        # Start fresh session
/mcp-server-management --operation=session-analyze      # Analyze session patterns

# Enhanced error recovery and analysis
/mcp-server-management --operation=error-analysis       # Analyze recent error patterns
/mcp-server-management --operation=error-report         # Generate comprehensive error report
/mcp-server-management --operation=recovery-test        # Test error recovery mechanisms

# MCP operation accountability and tracking
/mcp-server-management --operation=operation-report     # Generate MCP operation accountability report
/mcp-server-management --operation=check-incomplete     # Check for incomplete MCP operations
```

## Core Workflow

### 1. MCP Server Health Assessment

**Essential health monitoring steps:**

1. **Quick Health Check**
   - Run health check script for all configured servers
   - Check connection status and response times
   - Identify servers requiring attention

2. **Connection Status Verification**
   - Test individual server connectivity
   - Examine debug logs for connection failures
   - Validate tool availability for each server

3. **Performance Analysis**
   - Measure server response times
   - Analyze recent error patterns
   - Generate health status reports

### 2. Automatic Failure Detection and Recovery

**Intelligent failure handling:**

1. **Real-time Failure Detection**
   - Monitor debug logs for connection failures
   - Detect tool filtering warnings (server unavailable)
   - Track error frequency and patterns

2. **Automated Recovery Protocol**
   - Attempt graceful reconnection first
   - Perform safe server restart using `claude mcp` commands
   - Verify recovery success with health checks

3. **Circuit Breaker Protection**
   - Prevent cascade failures with circuit breaker pattern
   - Automatically switch to fallback mechanisms
   - Track failure patterns for predictive analysis

### 3. Intelligent Fallback Mechanisms

**Server-specific fallback strategies:**

1. **Atlassian MCP → acli Fallback**
   - Jira operations: Use `acli jira` commands
   - Confluence: Use `acli confluence` commands
   - Seamless operation switching with user notification

2. **GitLab Sidekick → glab CLI Fallback**
   - Pipeline operations: Use `glab ci` commands
   - Merge request operations: Use `glab mr` commands
   - Maintain full functionality through CLI

3. **Dynamic Fallback Selection**
   - Automatically suggest appropriate alternatives
   - Provide ready-to-use command examples
   - Support progressive degradation strategies

### 4. Enhanced Error Recovery and Analysis

**Intelligent error handling with adaptive recovery:**

1. **Advanced Error Classification**
   - Automatic error pattern recognition (connection, timeout, authentication, etc.)
   - Context-aware error analysis and classification
   - Historical error pattern tracking and analysis

2. **Intelligent Retry Logic**
   - Adaptive backoff with jitter for different error types
   - Error-specific recovery strategies (MCP restart, SSH key loading, etc.)
   - Circuit breaker pattern to prevent cascade failures

3. **Comprehensive Error Tracking**
   - Persistent error logging and pattern analysis
   - Error frequency and trend monitoring
   - Automated recovery success rate tracking

### 5. MCP Operation Accountability and Tracking

**Comprehensive operation validation and execution tracking:**

1. **Pre-Operation Validation**
   - Dynamic MCP server discovery using `claude mcp list`
   - Server health verification before operation execution
   - Operation scope and success criteria validation

2. **Execution Tracking**
   - Automatic logging of all MCP operations with timestamps
   - Real-time success/failure tracking and outcome validation
   - Integration with enhanced error recovery mechanisms

3. **Accountability Reporting**
   - Success rate analysis by server and operation type
   - Identification of problematic servers and patterns
   - Incomplete operation detection and follow-up recommendations

### 6. Performance Monitoring and Optimization

**Continuous improvement through monitoring:**

1. **Real-time Performance Tracking**
   - Monitor response times and success rates
   - Track connection stability over time
   - Generate performance metrics and trends

2. **Predictive Failure Analysis**
   - Analyze historical failure patterns
   - Predict potential server issues
   - Recommend proactive maintenance

3. **Optimization Recommendations**
   - Identify servers needing attention
   - Suggest configuration improvements
   - Provide maintenance scheduling guidance

## Quick Reference

### Health Check Commands

| Operation | Command | Purpose |
|-----------|---------|---------|
| **All Servers** | `/mcp-server-management` | Quick health check of all MCP servers |
| **Specific Server** | `/mcp-server-management --server_name=atlassian` | Check individual server status |
| **Failure Analysis** | `/mcp-server-management --operation=diagnose-failures` | Analyze recent failure patterns |
| **Performance Monitor** | `/mcp-server-management --operation=monitor-performance` | Start continuous monitoring |
| **Setup Fallbacks** | `/mcp-server-management --operation=setup-fallbacks` | Configure fallback mechanisms |

### Error Recovery Commands

| Operation | Command | Purpose |
|-----------|---------|---------|
| **Error Analysis** | `/mcp-server-management --operation=error-analysis` | Analyze recent error patterns and trends |
| **Error Report** | `/mcp-server-management --operation=error-report` | Generate comprehensive error recovery report |
| **Recovery Test** | `/mcp-server-management --operation=recovery-test` | Test error recovery mechanisms |

### Operation Accountability Commands

| Operation | Command | Purpose |
|-----------|---------|---------|
| **Operation Report** | `/mcp-server-management --operation=operation-report` | Generate MCP operation accountability report |
| **Check Incomplete** | `/mcp-server-management --operation=check-incomplete` | Check for incomplete MCP operations needing follow-up |

### Common Server Issues and Solutions

#### Atlassian MCP Connection Failures
**Symptoms:** `ENOTFOUND mcp.atlassian.com`, frequent timeouts
**Recovery:**
- Automatic restart via MCP management
- Fallback to `acli` commands for Jira/Confluence operations
- Network connectivity verification

#### Serena MCP File Access Issues
**Symptoms:** `FileNotFoundError`, project configuration issues
**Recovery:**
- Project configuration validation
- Automatic server restart
- Fallback to direct file operations with `find` and `grep`

#### GitLab Sidekick Connection Drops
**Symptoms:** `terminated: other side closed`, pipeline failures
**Recovery:**
- Automatic reconnection attempts
- Fallback to `glab` CLI for all GitLab operations
- Manual pipeline log retrieval options

### MCP Server Configuration Reference

| Server | Transport | Primary Use | Fallback Tool |
|--------|-----------|-------------|---------------|
| **atlassian** | HTTP (SSE) | Jira/Confluence | `acli` |
| **serena** | stdio | Code navigation | Direct file ops |
| **glean-tools** | HTTP | Documentation search | Manual search |
| **gitlab-sidekick** | stdio | GitLab operations | `glab` CLI |
| **databricks** | stdio | Data analytics | Direct SQL |
| **datadog-production** | stdio | Production monitoring | `datadog` CLI |

### Automated Recovery Integration

**Error handling for MCP-dependent skills:**

```bash
# Standard error handler for any skill using MCP
if ! mcp_operation_with_fallback "server_name" "operation"; then
    echo "MCP operation failed - check /mcp-server-management for recovery options"
fi
```

**Proactive monitoring setup:**

```bash
# Add to development environment startup
/mcp-server-management --operation=health-check

# Continuous monitoring (background process)
/mcp-server-management --operation=monitor-performance &
```

## Advanced Patterns

<details>
<summary>Click to expand advanced MCP management techniques</summary>

### Enterprise Monitoring Integration

**Comprehensive health reporting:**
- JSON-formatted health reports for automation
- Performance trend analysis and alerting
- Integration with existing FUB monitoring systems

### Predictive Maintenance

**Failure prediction and prevention:**
- Historical pattern analysis for failure prediction
- Proactive server restart based on performance metrics
- Maintenance window scheduling recommendations

### Circuit Breaker Protection

**Resilience patterns:**
- Automatic failover to prevent cascade failures
- Exponential backoff for connection retries
- Smart recovery timing based on failure patterns

### Performance Optimization

**Resource efficiency:**
- Parallel health checks for faster assessment
- Cached status to avoid redundant operations
- Smart restart logic with minimal downtime

</details>

## Integration Points

### Cross-Skill MCP Error Handling

**Standardized integration pattern for all MCP-dependent skills:**

```bash
# Add to any skill using MCP servers
handle_mcp_failure() {
    local skill_name="$1"
    local mcp_server="$2"

    /mcp-server-management --operation=restart-server --server_name="$mcp_server"

    if [[ $? -ne 0 ]]; then
        /mcp-server-management --operation=setup-fallbacks --server_name="$mcp_server"
    fi
}
```

### Related Skills Integration

| Skill | MCP Dependencies | Integration Pattern |
|-------|------------------|-------------------|
| `jira-management` | atlassian | Auto-retry with acli fallback |
| `confluence-management` | atlassian | Graceful degradation to acli |
| `gitlab-pipeline-monitoring` | gitlab-sidekick | Transparent glab failover |
| `datadog-management` | datadog servers | Circuit breaker with CLI fallback |
| `serena-mcp` | serena | File operation fallback |
| `support-investigation` | multiple | Multi-server resilience |

### Multi-Skill Operation Examples

**Complete MCP-aware workflow:**

1. **Development Session Startup**
   ```bash
   /mcp-server-management --operation=health-check
   # Ensures all MCP servers are ready before development work
   ```

2. **Incident Investigation with Resilience**
   ```bash
   /support-investigation --issue="Production slowdown"
   # Will automatically handle any MCP failures during investigation
   ```

3. **Proactive Maintenance**
   ```bash
   /mcp-server-management --operation=diagnose-failures
   # Identifies servers needing attention before they fail
   ```

## FUB Environment Specifics

### Critical MCP Servers for FUB Development

**Production environment dependencies:**
- **atlassian**: ZYN project Jira issues and Confluence documentation
- **glean-tools**: Internal FUB knowledge base and documentation search
- **gitlab-sidekick**: FUB repository access and CI/CD pipeline monitoring
- **databricks**: FUB data warehouse queries and analytics
- **serena**: FUB codebase navigation and semantic analysis

### FUB-Specific Recovery Procedures

**Environment-aware failover strategies:**
- Prioritize critical servers (atlassian, gitlab-sidekick, serena) for faster recovery
- Use FUB-specific CLI tools (acli configured for FUB, glab with FUB projects)
- Integrate with existing FUB development toolchain and workflows

## Quality Assurance

**MCP management validation checklist:**
- ✓ Health checks work for all configured servers
- ✓ Restart procedures are safe and effective
- ✓ Fallback mechanisms provide full functionality
- ✓ Error handling integrates seamlessly with existing skills
- ✓ Performance monitoring captures relevant metrics
- ✓ Recovery procedures maintain workflow continuity

## Supporting Scripts

The MCP server management functionality is implemented through several standalone scripts:

- `health-check.sh` - Comprehensive server health assessment
- `restart-server.sh` - Safe server restart procedures
- `diagnose-failures.sh` - Failure pattern analysis and reporting
- `setup-fallbacks.sh` - Fallback mechanism configuration
- `monitor-performance.sh` - Continuous performance monitoring
- `mcp-utils.sh` - Common utility functions for MCP operations
- `mcp-resilience-utils.sh` - Standardized resilience patterns for cross-skill integration
- `session-management.sh` - Session complexity tracking and optimization
- `enhanced-error-recovery.sh` - Advanced error classification and intelligent retry logic
- `error-pattern-analysis.sh` - Error pattern analysis and recovery recommendations
- `mcp-operation-accountability.sh` - MCP operation validation, tracking, and accountability reporting

All scripts are located in the skill's `scripts/` directory and can be executed independently or through the skill interface.