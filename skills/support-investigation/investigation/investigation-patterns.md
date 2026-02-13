## Comprehensive Investigation Workflow

### Investigation Setup and Information Gathering

**Create Investigation Directory Structure:**
- Create directory: `/Users/matttu/Documents/Work/FUB/notebook/support/YYYY-MM-DD-descriptive-name/`
- Initialize files: `investigation.md` (append-only log), `root-cause-summary.md` (stakeholder report)
- Set up proper markdown structure with investigation metadata

**Critical Information Requirements Validation:**
- **FUB account ID** (essential for all debugging - extract from issue or request)
- **FUB user email(s)** (for user-specific issues)
- **Timeframe** when issue occurred (Datadog only indexes logs for 15 days)
- **Environment** (Development, QA, Production - infer from context if not specified)

**Fetch Issue Details Using Specialized Skills:**
- **Jira Issues**: Use `jira-management` skill with issue key
- **Slack Threads**: Use Glean MCP for search
- **Confluence Pages**: Use `confluence-management` skill with page_id
- **Similar Issues**: Use Glean MCP to search for related historical issues

### Investigation Tool Decision Tree and System Analysis

**Inspect Production Configuration Using CSD:**
- Navigate to appropriate CSD environment
- Inspect systematically: Settings, Lead Flows, Automations, Integrations, Users
- Document with screenshots using Chrome DevTools MCP
- User impersonation to replicate issue scenarios when appropriate

### Systematic Data Collection and Log Analysis

**Query Databases and Application Data:**
- **Production Environment**: Use Databricks MCP with 15-minute timeout
- **QA/Development**: Direct connection via development environment or Adminer
- **Data Integrity**: Compare source vs synced data, check timestamps and values
- **Account Configuration**: Review feature flags, settings, and recent changes

**Comprehensive Log Analysis Using Datadog:**
- **Production Logs**: Use Datadog Production MCP tools (15-day retention limit)
- **Staging Logs**: Use Datadog Staging MCP for non-production issues
- **Systematic Search Patterns**: Account ID filtering, correlation ID tracking
- **Error Pattern Analysis**: Identify frequency, timing, and affected operations

### Code and Deployment Analysis

**Source Code Investigation:**
- **Semantic Code Search**: Use Serena MCP for understanding code behavior
- **Exact String Searches**: Use Grep for error messages, function names
- **Recent Changes**: Correlate issue timing with recent deployments
- **Integration Points**: Identify and analyze external service dependencies

**Deployment and Pipeline Correlation:**
- **GitLab Pipeline Analysis**: Use GitLab Sidekick MCP to review recent deployments
- **Deployment Timeline**: Correlate issue reports with deployment timing
- **Feature Flag Analysis**: Review feature flag changes and account enablement timing

### Evidence-Based Root Cause Analysis

**Systematic Evidence Collection:**
- **Direct Evidence**: Log entries, database records, configuration screenshots
- **Circumstantial Evidence**: Timing correlations, user behavior patterns
- **Inference Labeling**: Clearly mark speculative conclusions as (Inference)
- **Multiple Confirmation**: Seek multiple sources of evidence for critical conclusions

**Root Cause Determination Process:**
- **Hypothesis Formation**: Based on collected evidence and system knowledge
- **Hypothesis Testing**: Use additional queries and analysis to validate theories
- **Impact Assessment**: Determine scope (single account, multiple accounts, system-wide)
- **Confidence Level**: Rate confidence in root cause determination

### Comprehensive Documentation and Quality Assurance

**Investigation Documentation (`investigation.md`):**
- **Append-only format** with timestamps for each investigation step
- **Inline SQL/code/data** with proper markdown formatting
- **MCP tool usage** documented with specific queries and results
- **Screenshot references** with descriptive filenames and contexts
- **Evidence vs inference** clearly labeled throughout documentation

**Root Cause Summary (`root-cause-summary.md`):**
- **Executive summary** suitable for stakeholders and team members
- **Clear problem statement** with business impact assessment
- **Evidence-based conclusions** with supporting data and analysis
- **Resolution plan** with immediate, short-term, and long-term actions
- **Prevention measures** to avoid similar issues in the future

### Issue Resolution and Knowledge Management

**Jira and Confluence Integration:**
- **Confluence Page Creation**: Create comprehensive documentation
- **Jira Ticket Updates**: Update original ticket with findings and Confluence link
- **Cross-Reference Linking**: Link related tickets and documentation
- **Resolution Documentation**: Record resolution steps and verification procedures

**Knowledge Base Enhancement:**
- **Investigation Patterns**: Document reusable investigation patterns
- **Tool Usage Examples**: Create examples for effective MCP tool utilization
- **System Architecture**: Update system documentation based on insights
- **Training Materials**: Contribute to team knowledge base

### Investigation Timeframes and Limitations

| System | Data Retention | Time Limit | Notes |
|--------|---------------|------------|-------|
| **Datadog** | 15 days | Critical constraint | Request specific timestamps, use relative time queries |
| **CSD** | 30 days | Account-specific | Login required, environment-dependent URLs |
| **Database** | Indefinite | Safe queries only | Production requires approve_destructive=true for changes |
| **GitLab** | Indefinite | Project access | Use MR/pipeline correlation for deployment timing |
| **Jira** | Indefinite | Ticket context | Link tickets to deployment/incident timeline |

### FUB Environment Quick Access

**Account-Specific Debugging:**
- **Development**: `https://csd.richdesk.com` (account 1)
- **QA**: `https://csd.reclients.com` (account 17)
- **Production**: `https://csd.followupboss.com` (real accounts)

**Database Access Patterns:**
- **Development**: Direct localhost connection via ArConnections
- **QA**: SSH via Tailscale to `fub-control-qa-01`
- **Production**: Established production database protocols only

**Service Health Monitoring:**
```bash
# Quick service status check
datadog-management --task_type="metrics" --query_context="fub-api service health"

# Recent deployment correlation
gitlab-pipeline-monitoring --operation="list" --environment="production" --timeframe="past_24h"
```

### Investigation Decision Tree

```
1. Issue Type Classification
   ├── User-specific → Requires account_id → CSD + Database inspection
   ├── System-wide → Datadog metrics + Recent deployment analysis
   ├── Integration → External service status + Webhook/API logs
   └── Performance → Database query analysis + Code performance review

2. Environment Determination
   ├── Development → Local debugging + ArConnections
   ├── QA → Tailscale access + Test account validation
   └── Production → Datadog logs + Limited database inspection

3. Timeframe Analysis
   ├── Recent (< 15 days) → Full Datadog analysis possible
   ├── Historical (> 15 days) → Database logs + GitLab deployment correlation
   └── Real-time → Live monitoring + Immediate code analysis
```