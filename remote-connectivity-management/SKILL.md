---
name: remote-connectivity-management
description: Centralized SSH key management and VPN connectivity troubleshooting with intelligent error detection and recovery for FUB development environment
---

## Overview

Centralized SSH key management and VPN connectivity troubleshooting with intelligent error detection and recovery for FUB development environment. Provides comprehensive connectivity validation, troubleshooting workflows, and recovery procedures for SSH keys, VPN connections, and remote development server access.

## Usage

```bash
/remote-connectivity-management [--operation=<op_type>] [--server=<hostname>] [--force-key-reload=<bool>] [--skip-vpn-check=<bool>] [--interactive=<bool>]
```

## Examples

### Basic SSH/VPN Validation
```bash
# Quick validation (most common usage)
claude /remote-connectivity-management

# Validate specific server
claude /remote-connectivity-management --server=fubdev-alice-dev-01
```

### Troubleshooting Operations
```bash
# Interactive troubleshooting with step-by-step guidance
claude /remote-connectivity-management --operation=troubleshoot --interactive=true

# Quick key check without VPN validation
claude /remote-connectivity-management --operation=key-check --skip-vpn-check=true

# Cisco VPN conflict detection
claude /remote-connectivity-management --operation=cisco-conflict-detect
```

### Advanced Diagnostics
```bash
# Full system diagnosis
claude /remote-connectivity-management --operation=full-diagnosis

# VPN status only
claude /remote-connectivity-management --operation=vpn-status

# Recovery guidance
claude /remote-connectivity-management --operation=recovery-guide
```

## Overview

Centralized SSH key management and VPN connectivity troubleshooting with intelligent error detection and recovery for FUB development environment. Provides comprehensive diagnostics, automated conflict detection between Cisco VPN and Tailscale, and step-by-step recovery guidance for network and authentication issues.

## Usage

```bash
/remote-connectivity-management [--operation=<op>] [--server=<server>] [--force-key-reload=<bool>] [--skip-vpn-check=<bool>] [--interactive=<bool>]
```

## Core Workflow

### Essential Operations

**1. SSH/VPN Validation (`validate`)**
- Validates SSH agent and key availability
- Tests connectivity to target server with proper timeout handling
- Performs VPN conflict detection (Cisco vs Tailscale)
- Provides specific recovery guidance for each failure type

**2. Interactive Troubleshooting (`troubleshoot`)**
- Step-by-step diagnostic workflow with user guidance
- Detects internet connectivity, VPN status, SSH keys, and server connectivity
- Provides context-aware recovery suggestions
- Prompts user through resolution steps

**3. VPN Conflict Detection (`cisco-conflict-detect`)**
- Detects active Cisco VPN that may interfere with Tailscale
- Analyzes SSH timeout patterns specific to VPN conflicts
- Provides guidance on VPN connection order and resolution

### Quick Reference

| Operation | Purpose | Typical Usage |
|-----------|---------|---------------|
| `validate` | Standard SSH/VPN check | Before mutagen operations |
| `troubleshoot` | Interactive problem solving | When SSH connections fail |
| `key-check` | SSH key validation only | Script automation |
| `vpn-status` | VPN connectivity analysis | Network troubleshooting |
| `cisco-conflict-detect` | Specific VPN conflict detection | Cisco VPN interference |
| `recovery-guide` | Recovery instruction display | User guidance |
| `full-diagnosis` | Comprehensive system check | Complete troubleshooting |

### Error Classification and Recovery

**SSH Key Errors** → Immediate prompt to run daily SSH key command (e.g., 'addssh')
**Network Timeouts** → VPN conflict analysis and connection guidance
**Cisco VPN Conflicts** → Specific disconnect guidance with connection order
**Tailscale Offline** → Direct command to reconnect: `tailscale up`

## Integration with Other Skills

### Skill Bridge for Other Skills
```bash
# From other skills' scripts
source "$(dirname "${BASH_SOURCE[0]}")/../../remote-connectivity-management/integration/skill-bridge.sh"

# Backward compatible functions
validate_ssh_connection "$server"
validate_ssh_keys

# Enhanced VPN-aware validation
validate_ssh_with_vpn_check "$server"
```

### Supported Skills Integration
- **mutagen-management**: SSH validation before sync operations
- **mcp-server-management**: Enhanced error recovery with VPN detection
- **tool-management**: Intelligent retry with VPN conflict awareness
- **database-operations**: SSH tunnel validation with network diagnostics

## Advanced Patterns

### Complex Multi-VPN Environment Management

**Enterprise VPN Conflict Resolution:**
Advanced scenarios involving multiple VPN clients (Cisco AnyConnect, GlobalProtect, Tailscale) require sophisticated conflict detection and priority management with automated resolution workflows.

**Dynamic VPN Switching:**
Complex development environments require intelligent VPN switching based on target server requirements, network conditions, and security policies with automatic failover mechanisms.

**Cross-Platform VPN Compatibility:**
Multi-platform development teams require VPN configuration synchronization across macOS, Linux, and Windows environments with consistent connectivity validation.

### Advanced SSH Key Management Patterns

**Multi-Identity SSH Configuration:**
Complex scenarios with multiple SSH identities, different key types (RSA, Ed25519, ECDSA), and conditional key selection based on target servers and organizational policies.

**Hardware Security Module Integration:**
Advanced security environments requiring HSM-backed SSH keys, YubiKey integration, and secure key storage with proper chain-of-trust validation.

**Automated Key Rotation and Lifecycle Management:**
Enterprise scenarios requiring automated SSH key rotation, expiration monitoring, and secure key distribution across development teams.

### Network Topology Optimization

**Multi-Hop SSH Connection Management:**
Complex network architectures requiring jump hosts, bastion servers, and tunneled connections with optimized connection pooling and session reuse.

**Load-Balanced Development Server Access:**
Advanced scenarios with multiple development servers behind load balancers requiring intelligent server selection and connection health monitoring.

**Network Latency Optimization:**
High-latency network environments requiring connection optimization, TCP tuning, and intelligent timeout adjustment based on network conditions.

### Automation and CI/CD Integration

**Pipeline-Integrated Connectivity Validation:**
Advanced CI/CD integration patterns with automated SSH validation, VPN connection testing, and infrastructure readiness verification in deployment pipelines.

**Infrastructure as Code Integration:**
Advanced patterns for integrating connectivity management with Terraform, Ansible, and other infrastructure automation tools for consistent environment provisioning.

**Monitoring and Alerting Integration:**
Enterprise monitoring integration with Datadog, Prometheus, and other observability platforms for proactive connectivity issue detection and alerting.

### Security Hardening and Compliance

**Zero-Trust Network Integration:**
Advanced security patterns for zero-trust environments with continuous identity verification, conditional access policies, and risk-based authentication.

**Audit Logging and Compliance:**
Enterprise compliance requirements for SSH access logging, VPN usage tracking, and security event correlation for regulatory compliance.

**Threat Detection and Response:**
Advanced security patterns for detecting suspicious SSH activity, VPN abuse, and automated incident response with security team integration.

## Implementation Architecture

### Core Components

**SSH Core Functions** (`scripts/ssh-core-functions.sh`)
- SSH agent management and key loading
- Unified validation pipeline (agent → connectivity → capabilities)
- Timeout handling and error classification

**VPN Detection** (`scripts/vpn-detection.sh`)
- Tailscale status monitoring
- Cisco VPN conflict detection
- Network connectivity validation
- VPN priority handling

**Error Classification** (`scripts/error-classification.sh`)
- Standardized error pattern matching
- Recovery strategy mapping
- User-friendly error messages

**Interactive Troubleshooter** (`scripts/interactive-troubleshooter.sh`)
- Step-by-step user guidance
- Context-aware problem resolution
- Recovery command generation

**Skill Bridge** (`integration/skill-bridge.sh`)
- Backward compatibility for existing skills
- Enhanced VPN-aware functions
- Integration helper utilities

### Configuration

**Timeout Standardization** (`config/timeouts.conf`)
- Consolidates 6 different timeout values into standard set
- SSH connect, test, and agent timeouts
- VPN detection and network test timeouts
- Retry behavior configuration

**VPN Priority Configuration** (`config/vpn-priorities.conf`)
- VPN connection order (Tailscale first)
- Default server naming patterns
- Auto-recovery policies

## Refusal Conditions

**Prerequisites Not Met:**
- No internet connectivity detected
- SSH agent cannot be started
- Required SSH keys not found in standard locations

**Dependency Failures:**
- Target server unreachable via all connection methods
- Both Tailscale and direct network connectivity failed
- SSH keys loaded but authentication consistently fails

**Safety Considerations:**
- Will not automatically disconnect active VPN connections without user confirmation
- Will not modify SSH configuration files
- Will not attempt password-based SSH authentication

**Resolution Steps:**
1. Check network connectivity: `ping 8.8.8.8`
2. Verify Tailscale status: `tailscale status`
3. Load SSH keys: Run your daily SSH key command (e.g., 'addssh')
4. Test manual SSH connection: `ssh fubdev-{handle}-dev-01`

**Alternatives:**
- Use manual SSH connection for immediate access
- Check `.claude/core/environment/team-setup-guide.md` for environment setup
- Use support-investigation skill for advanced network diagnostics

## Integration Points

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `mutagen-management` | **File Sync Dependency** | SSH validation → File sync setup, Connectivity troubleshooting → Sync diagnostics |
| `mcp-server-management` | **Infrastructure Resilience** | Network issues → MCP reconnection, SSH failures → Service recovery patterns |
| `tool-management` | **Connectivity Tooling** | VPN management → Tool availability, Network diagnostics → Tool validation |
| `support-investigation` | **Advanced Diagnostics** | Connectivity patterns → Root cause analysis, Network troubleshooting → Incident resolution |
| `session-management` | **Complex Operations** | Multi-environment setup → Session tracking, Error recovery → Operation coordination |

#### Multi-Skill Operation Examples

**Development Environment Setup Workflow:**
```bash
# Complete environment connectivity and sync setup
claude /remote-connectivity-management --operation="validate-ssh" --environment="production" |\
  claude /mutagen-management --operation="create-session" --source="local" --destination="remote" |\
  claude /mcp-server-management --operation="health-check" --environment="development"
```

**Connectivity Troubleshooting Workflow:**
```bash
# Progressive connectivity diagnosis and resolution
claude /remote-connectivity-management --operation="diagnose" --target="vpn-connection" |\
  claude /tool-management --operation="validate" --scope="network-tools" |\
  claude /support-investigation --operation="analyze" --scope="network-connectivity"
```

**Infrastructure Resilience Workflow:**
```bash
# Comprehensive infrastructure validation and recovery
claude /remote-connectivity-management --operation="validate-all" |\
  claude /mcp-server-management --operation="resilience-check" |\
  claude /session-management --operation="coordinate" --complexity="infrastructure"
```

#### Workflow Handoff Patterns

**From remote-connectivity-management → Other Skills:**
- Provides validated SSH access for file synchronization operations
- Supplies network connectivity status for MCP server management
- Offers connectivity diagnostics for advanced troubleshooting scenarios
- Delivers infrastructure readiness confirmation for complex operations

**To remote-connectivity-management ← Other Skills:**
- Receives sync requirements from file synchronization operations
- Gets network dependency requirements from MCP server management
- Obtains connectivity requirements from development workflow coordination
- Accepts infrastructure needs from support investigation scenarios

#### Bidirectional Integration Examples

**remote-connectivity-management ↔ mutagen-management:**
- → Connectivity provides: SSH validation, network diagnostics, VPN status verification
- ← Sync provides: File sync requirements, connectivity dependency feedback, performance validation
- **Integration**: Ensures file synchronization has reliable network foundation

**remote-connectivity-management ↔ mcp-server-management:**
- → Connectivity provides: Network status validation, SSH tunnel management, infrastructure diagnostics
- ← MCP provides: Service dependency requirements, connection resilience patterns, recovery coordination
- **Integration**: Maintains reliable MCP server connectivity across network changes

**remote-connectivity-management ↔ support-investigation:**
- → Connectivity provides: Network diagnostics, infrastructure validation, connectivity patterns
- ← Investigation provides: Advanced troubleshooting requirements, root cause analysis, incident context
- **Integration**: Escalates connectivity issues to comprehensive investigation workflows

### Integration Architecture

#### FUB Development Infrastructure Coordination

**Central Role**: `remote-connectivity-management` provides the foundational network connectivity layer for all remote development operations

**Infrastructure Dependency Chain:**
1. **Network Connectivity** → Enables all remote operations
2. **SSH Validation** → Supports file synchronization and remote access
3. **VPN Management** → Provides secure access to FUB infrastructure
4. **Tool Availability** → Ensures network-dependent tools are accessible
5. **Service Coordination** → Maintains connectivity for MCP and development services

#### Integration Standards

**All infrastructure-dependent skills integrate with `remote-connectivity-management` through:**

1. **Connectivity Prerequisites**: Validated network access before remote operations
2. **SSH Dependency**: Confirmed SSH access for file synchronization and remote commands
3. **VPN Coordination**: Managed VPN connectivity for secure infrastructure access
4. **Error Recovery**: Standardized connectivity troubleshooting and resolution patterns
5. **Infrastructure Monitoring**: Continuous connectivity validation and health checking

**Reference Documentation:**
- `.claude/core/environment/team-setup-guide.md` - Environment setup requirements
- `mcp-server-management/mcp-resilience-patterns.md` - Error handling patterns