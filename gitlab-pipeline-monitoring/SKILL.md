---
name: gitlab-pipeline-monitoring
description: GitLab CI/CD pipeline monitoring, debugging, and status tracking with comprehensive job analysis, failure investigation, and performance optimization using GitLab Sidekick MCP integration
---

## Examples

```bash
# Monitor current branch pipeline status
/gitlab-pipeline-monitoring --operation="status" --project_path="fub/fub"

# Debug failed pipeline for specific MR
/gitlab-pipeline-monitoring --operation="jobs" --mr_iid="123" --status="failed" --project_path="fub/fub-spa"

# Get logs for failed job
/gitlab-pipeline-monitoring --operation="logs" --job_id="456789" --project_path="fub/fub"

# Monitor production deployment pipeline
/gitlab-pipeline-monitoring --operation="monitor" --branch="main" --environment="production"

# List all failed pipelines from today
/gitlab-pipeline-monitoring --operation="list" --status="failed" --timeframe="today" --project_path="fub/fub-api"
```

## Overview

GitLab CI/CD pipeline monitoring, debugging, and status tracking with comprehensive job analysis, failure investigation, and performance optimization using GitLab Sidekick MCP integration. Provides real-time pipeline status monitoring, automated failure detection, and intelligent retry mechanisms optimized for FUB deployment workflows.

🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📋 **Troubleshooting Guide**: [reference/troubleshooting-guide.md](reference/troubleshooting-guide.md)
⚡ **glab CLI Alternatives**: [workflows/glab-alternatives.md](workflows/glab-alternatives.md)

## Usage

```bash
/gitlab-pipeline-monitoring [--operation=<op>] [--project_path=<path>] [--branch=<branch>] [--mr_iid=<id>] [--pipeline_id=<id>] [--job_id=<id>] [--status=<status>] [--timeframe=<range>] [--environment=<env>]
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Pipeline Status Monitoring**
```bash
# Source GitLab resilience utilities for MCP failover support
source "$(dirname "${BASH_SOURCE[0]}")/scripts/gitlab-resilience.sh"

# Check current branch pipeline health with automatic MCP/glab fallback
gitlab_operation_with_fallback "list_pipelines" "fub/fub"

# Monitor MR pipeline progress with resilience
gitlab_operation_with_fallback "list_pipelines" "fub/fub"

# Real-time pipeline monitoring with health check
gitlab_health_check
monitor_pipeline "fub/fub" "12345" 30
```

**2. Failure Investigation and Debugging**
```bash
# Source GitLab resilience utilities
source "$(dirname "${BASH_SOURCE[0]}")/scripts/gitlab-resilience.sh"

# Analyze failed pipeline jobs with MCP → glab fallback
gitlab_operation_with_fallback "pipeline_jobs" "fub/fub" "12345"

# Get detailed job logs for debugging with resilience
get_job_logs "fub/fub" "67890"

# Find failed jobs across recent pipelines
find_failed_jobs "fub/fub" 10
```

**3. Pipeline Management and Optimization**
```bash
# Retry failed jobs selectively
gitlab-pipeline-monitoring --operation="retry" --job_id="11111" --pipeline_id="12345"

# Cancel long-running or stuck pipelines
gitlab-pipeline-monitoring --operation="cancel" --pipeline_id="54321"

# Performance analysis and optimization recommendations
gitlab-pipeline-monitoring --operation="performance" --project_path="fub/fub" --timeframe="past_month"
```

### Preconditions

- **GitLab CI/CD**: Active CI/CD configuration with `.gitlab-ci.yml` in target project
- **Pipeline Access**: User permissions to view pipelines and job logs
- **GitLab Sidekick MCP**: Available for advanced pipeline operations and analysis
- **glab CLI**: Installed and configured for basic pipeline operations
- **Project Context**: Valid GitLab project with active pipeline history

### MCP Resilience Integration

**Enhanced GitLab Sidekick Reliability**: This skill implements robust MCP resilience patterns:
- Automatic health checking of GitLab Sidekick MCP before operations
- Circuit breaker protection for frequently failing MCP connections
- Seamless fallback to `glab` CLI when MCP servers are unavailable
- Intelligent retry mechanisms for network timeouts and connection drops
- Transparent error communication with specific recovery guidance

**GitLab Operations with Automatic Failover:**
```bash
# Source the enhanced GitLab resilience script
source "$(dirname "${BASH_SOURCE[0]}")/scripts/gitlab-resilience.sh"

# Comprehensive health check before operations
gitlab_health_check

# Get pipeline jobs with automatic MCP → glab failover
gitlab_operation_with_fallback "pipeline_jobs" "fub/fub" "12345"

# Get job logs with circuit breaker protection and enhanced error handling
get_job_logs "fub/fub" "67890"

# Interactive pipeline browser for complex investigations
interactive_pipeline_browser "fub/fub"

# Monitor pipeline in real-time with fallback support
monitor_pipeline "fub/fub" "12345" 30
```

## Pipeline Analysis Framework

**Health Assessment Indicators:**
```markdown
✅ **Healthy**: >90% success rate, <15min average duration
⚠️  **Degraded**: 70-90% success rate, 15-30min duration
❌ **Problematic**: <70% success rate, >30min duration
🔄 **Unstable**: Frequent retries, intermittent failures
```

## Quick Reference

### Pipeline Status Interpretation

| Status | Indicator | Description | Action Required |
|--------|-----------|-------------|-----------------|
| `running` | 🔄 | Pipeline in progress | Monitor for completion |
| `pending` | ⏳ | Waiting for runners | Check runner availability |
| `success` | ✅ | All jobs passed | Ready for next stage |
| `failed` | ❌ | One or more jobs failed | Investigate and fix |
| `canceled` | 🚫 | Manually cancelled | Determine if restart needed |
| `skipped` | ⏭️ | Skipped due to conditions | Review skip conditions |

→ **Complete failure analysis patterns**: [reference/troubleshooting-guide.md](reference/troubleshooting-guide.md)

### FUB Pipeline Architecture Overview

**Standard Pipeline Stages:**
```markdown
FUB CI/CD Pipeline Flow:
1. **Prepare**: Environment setup, dependency caching
2. **Build**: Code compilation, asset generation
3. **Test**: Unit tests, integration tests, linting
4. **Security**: Security scanning, vulnerability assessment
5. **Package**: Docker image building, artifact creation
6. **Deploy**: Environment-specific deployment
7. **Verify**: Post-deployment testing, health checks
```

**Environment-Specific Configurations:**
```markdown
Development: Fast builds, basic tests, automatic deployment
Staging: Full test suite, security scans, manual approval gates
Production: Comprehensive validation, manual deployment, rollback capability
```

→ **Detailed architecture and troubleshooting**: [reference/troubleshooting-guide.md](reference/troubleshooting-guide.md)

## Integration Patterns

### Cross-Skill Workflow Integration

**Development → Pipeline → Deployment Lifecycle:**
```bash
# Complete development workflow with pipeline validation
code-development --task="Fix authentication bug" |\
  gitlab-mr-management --operation="create" --title="Auth bug fix" |\
  gitlab-pipeline-monitoring --operation="monitor" |\
  gitlab-mr-management --operation="merge" --condition="pipeline_success"
```

**Pipeline Failure → Investigation → Resolution:**
```bash
# Automated failure investigation workflow
gitlab-pipeline-monitoring --operation="status" --status="failed" |\
  backend-static-analysis --baseline |\
  code-development --task="Fix identified issues" --scope="bug-fix" |\
  gitlab-pipeline-monitoring --operation="retry"
```

### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `gitlab-mr-management` | **MR Lifecycle** | Create MR → Monitor pipeline → Update based on results → Merge when ready |
| `gitlab-mr-search` | **Discovery Integration** | Search problematic MRs → Analyze pipeline failures → Coordinate fixes |
| `code-development` | **Development Feedback** | Code changes → Pipeline validation → Development iteration → Success confirmation |
| `backend-static-analysis` | **Static Analysis Monitoring** | Psalm job failures → Code quality analysis → Fix implementation → Pipeline re-run validation |
| `datadog-management` | **Infrastructure Monitoring** | Pipeline failures → Infrastructure analysis → Performance optimization |
| `support-investigation` | **Issue Resolution** | Production issues → Pipeline analysis → Deployment correlation → Root cause analysis |

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

### Workflow Handoff Patterns

**From gitlab-pipeline-monitoring → Other Skills:**
- Provides pipeline failure notifications for development iteration
- Supplies performance metrics for infrastructure optimization
- Delivers deployment status for monitoring and alerting systems
- Offers failure analysis for debugging and resolution workflows

**To gitlab-pipeline-monitoring ← Other Skills:**
- Receives code changes from development for pipeline triggering
- Gets MR updates for pipeline association and tracking
- Obtains infrastructure changes for pipeline impact assessment
- Accepts deployment requests for production pipeline monitoring

## Integration Architecture

**FUB CI/CD Ecosystem Integration:**
```markdown
gitlab-pipeline-monitoring serves as the CI/CD observability hub:

1. **Development Feedback Loop**: Immediate pipeline feedback for development iterations
2. **Quality Gateway**: Pipeline-based quality assurance and compliance validation
3. **Deployment Orchestration**: Controlled deployment progression with validation gates
4. **Performance Monitoring**: Continuous pipeline performance optimization and alerting
5. **Issue Correlation**: Connection between deployment issues and pipeline problems
```

**Pipeline State Integration:**
```markdown
Pipeline Events Integrated Across Skills:
- **Pipeline Start**: Notification to monitoring and collaboration systems
- **Job Failures**: Immediate feedback to development and investigation workflows
- **Success Completion**: Trigger for merge readiness and deployment coordination
- **Performance Issues**: Alerts to infrastructure and optimization workflows
- **Security Failures**: Escalation to security and compliance processes
```

## Supporting Infrastructure

→ **Advanced monitoring and orchestration**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **glab CLI workflow enhancements**: [workflows/glab-alternatives.md](workflows/glab-alternatives.md)

This focused skill provides comprehensive pipeline monitoring and debugging capabilities while maintaining efficient integration with the broader FUB development and deployment ecosystem.