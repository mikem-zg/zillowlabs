---
name: support-investigation
description: Systematic support investigation with scientific methodology, MCP integration, and evidence-based root cause analysis for FUB production, QA, and development environments. Includes comprehensive documentation, cross-skill workflow integration, and quality assurance protocols.
argument-hint: --issue <issue_description> --account_id <fub_account_id> [--environment <dev|qa|prod>] [--scientific_mode <true|advanced>] [--evidence_threshold <strict|standard|preliminary>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, TaskCreate, TaskUpdate, TaskList, TaskGet, ToolSearch, Skill
---

## Overview

Systematic support investigation workflow with scientific methodology integration, comprehensive MCP server utilization, and evidence-based root cause analysis for FUB environments. Provides structured investigation patterns, quality assurance protocols, and cross-skill integration for effective issue resolution and knowledge management.

🔬 **Scientific Methods**: [methodologies/scientific-methods.md](methodologies/scientific-methods.md)
📋 **Investigation Patterns**: [investigation/investigation-patterns.md](investigation/investigation-patterns.md)
🛠️ **MCP Integration**: [tools/mcp-integration.md](tools/mcp-integration.md)
🔧 **Debugging Workflows**: [workflows/debugging-workflows.md](workflows/debugging-workflows.md)

## Core Workflow

### Essential Investigation Operations (Daily Usage - 90% of Cases)

**1. Basic Issue Investigation**
```bash
# Standard investigation with systematic evidence collection
/support-investigation --issue="ZYN-10585" --account_id="12345" --environment="production"

# Scientific methodology for complex issues
/support-investigation --issue="auth-failures" --account_id="12345" --scientific_mode=true --evidence_threshold=standard

# Advanced scientific investigation with multiple hypotheses
/support-investigation --issue="performance-degradation" --scientific_mode=advanced --require_alternatives=true --confidence_minimum=high
```

**2. Environment-Specific Debugging**
```bash
# Production investigation with Datadog integration
/support-investigation --issue="zillow-sync-failure" --account_id="12345" --environment="production"

# Development environment with local debugging
/support-investigation --issue="migration-failure" --environment="development" --experimental_validation=true

# QA environment investigation with staging tools
/support-investigation --issue="test-failures" --account_id="17" --environment="qa"
```

**3. Integration-Specific Investigation**
```bash
# Zillow integration debugging
/support-investigation --issue="zillow-auth-timeout" --account_id="12345" --environment="production"

# Webhook investigation with external service correlation
/support-investigation --issue="webhook-delivery-failure" --account_id="12345" --require_alternatives=true
```

**Preconditions:**
- **Critical Information**: FUB account ID, issue timeframe, environment context
- **MCP Server Access**: Configured connections to Datadog, Databricks, Serena, Atlassian, GitLab Sidekick
- **Investigation Directory**: Write access to `/Users/matttu/Documents/Work/FUB/notebook/support/`
- **System Access**: Appropriate credentials for CSD, database connections, and monitoring tools

### Behavior

When invoked, execute this systematic support investigation workflow:

**1. Investigation Setup and Critical Information Gathering**
- Create timestamped investigation directory with structured documentation files
- Validate critical requirements: FUB account ID, issue timeframe, environment context
- Initialize investigation log (`investigation.md`) and stakeholder summary (`root-cause-summary.md`)
- Gather issue context using Jira Management, Glean MCP, and Confluence Management skills

**2. Systematic Evidence Collection Using MCP Integration**
- **Production Analysis**: Datadog Production MCP for log analysis and performance metrics (15-day retention)
- **Database Investigation**: Databricks MCP for account configuration, user data, and feature flag validation
- **Code Analysis**: Serena MCP for semantic code search, recent changes, and integration point analysis
- **Deployment Correlation**: GitLab Sidekick MCP for pipeline analysis and timing correlation

**3. Scientific Methodology and Root Cause Analysis**
- Apply hypothesis-driven investigation with explicit evidence classification
- Generate multiple working hypotheses with systematic testing approach
- Document evidence vs. inference with clear confidence levels and uncertainty quantification
- Implement experimental validation where possible using controlled test scenarios

**4. Comprehensive Documentation and Quality Assurance**
- Maintain append-only investigation log with timestamped entries and MCP tool usage documentation
- Create executive summary suitable for stakeholders with evidence-based conclusions and resolution plan
- Apply quality assurance checklist with markdown linting and completeness validation
- Integrate with Jira Management and Confluence Management for knowledge base enhancement

## Quick Reference

### Essential Parameters

| Parameter | Description | Values | Default |
|-----------|-------------|---------|---------|
| `issue` | Issue description or Jira ticket ID | String | Required |
| `account_id` | FUB account ID for investigation | Integer | Required |
| `environment` | Target environment for investigation | dev/qa/prod | prod |
| `scientific_mode` | Scientific methodology level | true/advanced | false |
| `require_alternatives` | Require multiple hypotheses | true/false | false |
| `evidence_threshold` | Evidence requirements | strict/standard/preliminary | standard |
| `confidence_minimum` | Minimum confidence level | high/medium/low | medium |
| `experimental_validation` | Enable controlled testing | true/false | false |

### MCP Server Integration Quick Commands

**Datadog Analysis:**
```bash
# Production log search
datadog-production --operation="search-logs" --query="account_id:12345 error" --timeframe="past_24h"

# Performance metrics correlation
datadog-production --operation="get-metrics" --metric="fub.api.response_time" --tags="account_id:12345"
```

**Databricks Investigation:**
```bash
# Account configuration validation
databricks --query="SELECT * FROM accounts WHERE id = 12345" --timeout="15min"

# Feature flag analysis
databricks --query="SELECT flag_name, enabled FROM feature_flags WHERE account_id = 12345"
```

**Serena Code Analysis:**
```bash
# Find recent authentication changes
serena-mcp --task="Find recent authentication changes" --scope="auth"

# Integration point analysis
serena-mcp --task="Find webhook integration code" --scope="integrations"
```

### FUB Environment Access

**Account-Specific URLs:**
- **Development**: `https://csd.richdesk.com` (account 1)
- **QA**: `https://csd.reclients.com` (account 17)
- **Production**: `https://csd.followupboss.com` (real accounts)

**System Limitations:**
- **Datadog**: 15-day retention (critical constraint)
- **CSD**: 30-day account history
- **Database**: Production requires safety protocols
- **GitLab**: Full pipeline history available

## Advanced Patterns

<details>
<summary>Click to expand comprehensive investigation methodologies and cross-skill integration</summary>

### Scientific Investigation Enhancement

**Advanced Methodology Options:**
- **Statistical Analysis**: Error pattern frequency and distribution analysis
- **Controlled Experiments**: A/B testing and canary deployment validation
- **Peer Review Process**: Critical findings verification for system-wide issues
- **Reproducibility Testing**: Cross-environment validation and consistency checks

**Evidence Classification System:**
- **Direct Evidence**: Log entries, database records, configuration screenshots
- **Circumstantial Evidence**: Timing correlations, behavioral patterns
- **Statistical Evidence**: Error rates, performance trends, anomaly detection
- **Experimental Evidence**: Controlled testing results and validation scenarios

### Comprehensive MCP Server Utilization

**Cross-Tool Investigation Patterns:**
1. **Context Discovery**: Glean MCP → Historical issue patterns and team expertise
2. **Code Analysis**: Serena MCP → Implementation details and recent change correlation
3. **Data Validation**: Databricks MCP → Account configuration and integrity verification
4. **Log Analysis**: Datadog MCP → Error patterns, performance metrics, timeline correlation
5. **User Replication**: Chrome DevTools MCP → CSD navigation and issue scenario recreation
6. **Deployment Analysis**: GitLab Sidekick MCP → Pipeline correlation and feature deployment timing
7. **Documentation**: Atlassian MCP → Knowledge base creation and ticket management integration

**Investigation Automation Examples:**
```bash
# Automated investigation workflow
investigate_issue() {
    local issue_id="$1"
    local account_id="$2"

    # Comprehensive context gathering
    glean --operation="search" --query="$issue_id" --max_results=10
    gitlab-sidekick --operation="list_pipelines" --timeframe="past_48h"
    databricks --query="SELECT * FROM accounts WHERE id = $account_id" --timeout="15min"
    datadog-production --operation="search-logs" --query="account_id:$account_id error" --timeframe="past_24h"

    # Documentation and tracking
    atlassian --operation="add_comment_to_jira_issue" --issue_key="$issue_id" --comment="Investigation completed"
}
```

📊 **Complete MCP Integration Guide**: [tools/mcp-integration.md](tools/mcp-integration.md)
🔬 **Scientific Methodology Details**: [methodologies/scientific-methods.md](methodologies/scientific-methods.md)

</details>

## Integration Points

🔗 **Cross-Skill Patterns**: [reference/integration-patterns.md](reference/integration-patterns.md)

### Cross-Skill Workflow Examples

**Support Investigation → Backend Testing:**
```bash
# Issue reproduction with targeted tests
/support-investigation --issue="ZYN-10585" --account_id="12345" |
  /backend-test-development --target="AuthController::authenticate" --test_type="api" --auth_mode="fub-spa"

# Validation testing after resolution
/support-investigation document_root_cause |
  /backend-test-development --target="validate_fix" --test_type="regression" --coverage_analysis=true
```

**Support Investigation → Datadog Analysis:**
```bash
# Performance correlation analysis
/support-investigation --issue="performance-degradation" --environment="production" |
  /datadog-management --analysis_type="performance" --service="fub-api" --timeframe="past-24h"

# Alert creation based on patterns
/support-investigation document_error_patterns |
  /datadog-management --operation="create_monitor" --alert_type="error_rate"
```

**Support Investigation → Code Analysis:**
```bash
# Code change correlation
/support-investigation --issue="authentication-failures" |
  /serena-mcp --task="Find recent authentication changes"

# Deployment timeline analysis
/support-investigation timeline_analysis |
  /gitlab-pipeline-monitoring --operation="list" --branch="main" --timeframe="past-week"
```

### Related Skills

| Skill | Integration Type | Common Workflows |
|-------|-----------------|------------------|
| `backend-test-development` | **Issue Reproduction** | Create targeted tests, validate fixes, regression testing |
| `datadog-management` | **Log Analysis** | Performance monitoring, error pattern analysis, alert creation |
| `serena-mcp` | **Code Investigation** | Semantic search, change analysis, deployment correlation |
| `database-operations` | **Data Investigation** | Production queries, integrity checks, configuration validation |
| `jira-management` | **Issue Tracking** | Ticket updates, progress documentation, resolution tracking |
| `confluence-management` | **Knowledge Base** | Investigation documentation, team knowledge sharing |
| `zillow-oauth-diagnosis` | **Specialized Debugging** | Zillow authentication failures, token validation |
| `fub-integrations` | **System Knowledge** | Codebase navigation, integration patterns, architectural context |

### Multi-Skill Operation Examples

**Complete Issue Resolution Workflow:**
1. `support-investigation` - Systematic evidence collection and root cause analysis
2. `serena-mcp` - Code analysis and recent change correlation
3. `datadog-management` - Performance metrics and log analysis
4. `database-operations` - Data integrity validation and configuration verification
5. `backend-test-development` - Issue reproduction and fix validation
6. `jira-management` - Progress tracking and resolution documentation
7. `confluence-management` - Knowledge base creation and team sharing

## Refusal Conditions

The skill must refuse if:
- **Critical Information Missing**: Account ID, issue timeframe, or environment context unavailable
- **MCP Server Unavailability**: Required servers not accessible after automatic recovery attempts
- **Investigation Directory Access**: Cannot create or write to documentation directory
- **Issue Description Clarity**: Too vague to determine appropriate investigation approach
- **System Access Authorization**: FUB credentials or permissions not verified
- **Safety Requirements**: Investigation scope exceeds authorized access boundaries
- **Resource Limitations**: Task complexity beyond reasonable investigation boundaries

When refusing, provide specific resolution steps:
- How to gather required critical information (account ID, timeframe, environment)
- MCP server configuration verification and credential validation procedures
- Alternative investigation approaches within current access limitations
- Issue description refinement guidance for clearer scope definition
- Resources for obtaining proper system authorization and access

**Critical Investigation Note**: Support investigations prioritize evidence-based analysis, systematic documentation, and comprehensive resolution over completion speed. When uncertain about evidence interpretation or system access safety, always seek additional verification or team consultation before proceeding with potentially impactful analysis or conclusions.