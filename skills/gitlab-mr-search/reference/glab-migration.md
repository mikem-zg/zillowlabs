## GitLab CLI Migration Guide and Reference

### Common glab Commands → Skill Alternatives

**Replace manual glab workflows with intelligent skill-based alternatives:**

#### Daily MR Management

**Before (glab CLI):**
```bash
glab mr list --author @me --state opened
```

**After (Enhanced Skill):**
```bash
/gitlab-mr-search --query="author:me state:opened"
```

**Benefits:**
- ✅ Integrated pipeline status and merge readiness assessment
- ✅ Unresolved discussion highlighting
- ✅ Automatic conflict detection
- ✅ Cross-project MR correlation
- ⏱️ Single comprehensive view vs. multiple CLI commands

#### MR Investigation and Analysis

**Before (glab CLI):**
```bash
glab mr view 123 --comments
```

**After (Intelligent Analysis):**
```bash
/gitlab-mr-search --mr_iid="123" --operation="triage-summary"
```

**Benefits:**
- ✅ Automated comment triage and blocker identification
- ✅ Merge readiness assessment with actionable recommendations
- ✅ Pipeline integration with failure pattern analysis
- ✅ Historical context and related MR discovery
- ⏱️ Comprehensive analysis vs. raw comment listing

#### Team Collaboration and Review

**Before (glab CLI):**
```bash
glab mr list --reviewer @me
```

**After (Collaborative Workflow):**
```bash
/gitlab-mr-search --query="reviewer:me state:opened" --operation="triage-summary"
```

**Benefits:**
- ✅ Priority-based MR ordering by urgency and impact
- ✅ Automated classification of review types needed
- ✅ Integration with approval workflow status
- ✅ Cross-skill handoff to collaboration tools
- ⏱️ Intelligent review queue vs. simple list

### Cross-Skill Workflow Enhancements

#### Complete MR Discovery → Action Workflow

**Enhanced Discovery and Action Chain:**
```bash
# 1. Intelligent MR discovery
/gitlab-mr-search --query="label:ready-for-review" --operation="triage-summary"

# 2. [When gitlab-mr-management is available] Direct action
/gitlab-mr-management --operation="merge" --mr_iid="[discovered_mr]"

# 3. [Currently] Enhanced glab workflow with context
# Use rich context from step 1 to inform optimal glab commands
```

**Benefits:**
- ✅ Context-aware decision making
- ✅ Intelligent prioritization
- ✅ Automated validation before actions
- ✅ Reduced workflow friction

#### Development → Discovery → Pipeline Integration

**Coordinated Development Workflow:**
```bash
# 1. Find related existing work
/gitlab-mr-search --query="authentication feature created_after:last_month"

# 2. Coordinate with code development
# [Context from step 1 informs implementation approach]

# 3. Pipeline monitoring integration
/gitlab-pipeline-monitoring --mr_iid="[new_mr]" --operation="track-mr-progress"
```

**Benefits:**
- ✅ Avoid duplicate work through intelligent discovery
- ✅ Learn from previous implementation patterns
- ✅ Integrated monitoring from MR creation
- ✅ End-to-end workflow automation

### Progressive Enhancement Strategy

**Week 1: Replace Basic Commands**
```bash
# Old workflow
glab mr list

# New enhanced workflow
/gitlab-mr-search --query="author:me state:opened"
```
*Observe enhanced functionality and time savings*

**Week 2: Adopt Triage and Analysis**
```bash
# Old workflow
glab mr view

# New intelligent workflow
/gitlab-mr-search --operation="triage-summary"
```
*Leverage automated comment analysis and merge readiness*

**Week 3: Implement Cross-Skill Coordination**
- Combine search with pipeline monitoring and development workflows
- Experience integrated context and reduced tool switching

**Week 4+: Advanced Workflow Automation**
- Use complex queries and intelligent filtering
- Leverage cross-project correlation and team collaboration features

### Success Metrics and Feedback

**Time Efficiency:**
- **Baseline**: Time for manual glab mr list + glab mr view + manual analysis
- **Enhanced**: Single skill command with comprehensive analysis
- **Target**: 70%+ time reduction for common MR operations

**Quality Improvements:**
- Better decision making through merge readiness assessment
- Reduced missed issues through automated triage
- Improved collaboration through intelligent prioritization

**User Experience:**
- Less context switching between tools
- More actionable information per command
- Better integration with development workflow

### Integration with Available Skills

**Current Ecosystem Optimization:**

**Maximize Available Skill Coordination:**
```bash
# 1. MR Discovery (this skill)
/gitlab-mr-search --query="pipeline-failed recent"

# 2. Pipeline Investigation (available skill)
/gitlab-pipeline-monitoring --mr_iid="[from_search]" --operation="debug-failures"

# 3. Issue Tracking Integration (available skill)
/jira-management --operation="link-mr-to-issue" --mr_data="[from_search]"

# 4. Development Context (available skill)
/code-development --context="[mr_analysis]" --task="Fix identified issues"
```

**Benefits:**
- ✅ Comprehensive workflow using available registered skills
- ✅ Rich context sharing between skill operations
- ✅ Minimal glab CLI fallback for operations covered by skills
- ✅ Enhanced functionality beyond individual tool capabilities

### Future Enhancement Opportunities

**When gitlab-mr-management becomes available:**
- Complete write operation integration (create, update, merge)
- End-to-end MR lifecycle automation
- Advanced template and quality gate integration

**When gitlab-collaboration becomes available:**
- Enhanced review workflow automation
- Automated approval coordination
- Advanced discussion resolution workflows

**Current Focus:**
Maximize utilization of available skill ecosystem:
- gitlab-mr-search (this skill) for discovery and analysis
- gitlab-pipeline-monitoring for CI/CD integration
- Cross-skill workflows for comprehensive operations

### Preconditions and Setup

**GitLab Access Requirements:**
- Valid authentication to GitLab instance (https://gitlab.zgtools.net)
- SSH key or access token configured for GitLab operations
- Project access permissions for target repositories

**MCP Integration:**
- GitLab Sidekick MCP server available for advanced operations (with automatic resilience)
- Fallback to glab CLI for basic operations when MCP unavailable

**Network Requirements:**
- Stable connection to GitLab instance and MCP services
- Circuit breaker protection for failing connections

### Troubleshooting and Fallback

**MCP Server Issues:**
```bash
# Check MCP health
check_gitlab_mcp_health() {
    if mcp__gitlab-sidekick__gitlab_listMyOpenMRs > /dev/null 2>&1; then
        echo "✅ GitLab Sidekick MCP available"
        return 0
    else
        echo "❌ GitLab Sidekick MCP unavailable, using glab fallback"
        return 1
    fi
}
```

**Automatic Fallback Execution:**
```bash
# Graceful fallback to glab CLI
execute_with_fallback() {
    local operation="$1"
    shift
    
    if check_gitlab_mcp_health; then
        "mcp__gitlab-sidekick__$operation" "$@"
    else
        # Simplified glab fallback
        case "$operation" in
            "gitlab_listMyOpenMRs")
                glab mr list --author @me --state opened
                ;;
            "gitlab_mrOverview")
                glab mr view "$1"
                ;;
            *)
                echo "Operation $operation not available in fallback mode"
                return 1
                ;;
        esac
    fi
}
```

This migration guide provides comprehensive support for transitioning from manual glab CLI operations to intelligent, integrated GitLab MR search and analysis workflows.
