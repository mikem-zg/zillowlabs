## Cross-Skill Integration Workflows and Patterns

### Integration Patterns for Other Skills

**Standard Integration (Add to any skill's preconditions):**
```markdown
**Tool Availability Integration**: This skill implements comprehensive tool validation patterns:
- Automatic availability checking for all required tools before operations
- Intelligent fallback suggestions when tools are unavailable across all categories
- Seamless alternative recommendations (MCP → CLI → Manual workflows)
- Integration with tool-management skill for validation, recovery, and user guidance
```

**Advanced Integration (For complex multi-tool skills):**
```markdown
**Comprehensive Tool Ecosystem**: This skill requires multiple tool categories:
- MCP Tools: [list specific MCP tools needed]
- CLI Tools: [list specific CLI tools needed]
- Dependencies: [list skill dependencies]
- Fallback Strategy: Automatic degradation through tool hierarchy with user notification
- Recovery: Integration with tool-management for automated validation and alternative workflows
```

### Error Messages and User Guidance

**MCP Server Unavailable:**
```
❌ MCP Server 'atlassian' unavailable
✅ Alternative: Use 'acli jira view ZYN-10585'
📖 Setup: Run '/tool-management --operation=install-guidance --tool_name=acli'
🔄 Recovery: Run '/tool-management --operation=health-check --tool_category=mcp'
```

**CLI Tool Missing:**
```
❌ CLI tool 'glab' not installed
✅ Alternative: Use GitLab web interface at https://gitlab.zgtools.net
📦 Install: Run 'brew install glab' or '/tool-management --operation=install-guidance --tool_name=glab'
🔐 Auth: Run 'glab auth login' after installation
```

**Skill Configuration Issues:**
```
❌ Skill 'serena-mcp' dependencies unavailable
✅ Alternative: Use 'grep' and 'find' for code search
🔧 Fix: Check MCP server configuration and skill dependencies
📖 Guide: Run '/tool-management --operation=validate --tool_name=serena-mcp'
```

### Cross-Skill Workflow Patterns

**Tool Management → All Skills:**
```bash
# Universal pre-operation validation pattern
any-skill-operation --validate-tools=true |
  tool-management --operation=validate --operation_context="skill-operation" --suggest_alternatives=true
```

**Tool Management → MCP Server Management:**
```bash
# Enhanced MCP management with broader tool context
mcp-server-management --operation=health-check |
  tool-management --operation=validate --tool_category=mcp --suggest_alternatives=true
```

**Tool Management → Support Investigation:**
```bash
# Comprehensive tool validation for investigation workflows
support-investigation --issue="Tool unavailability" --environment="development" |
  tool-management --operation=health-check --tool_category=all --validate_auth=true
```

**Tool Management → Development Workflows:**
```bash
# Pre-development environment validation
code-development --operation="environment-check" |
  tool-management --operation=validate --tool_category=all --operation_context="development-setup"

# Database operation tool preparation
database-operations --operation="connection-check" |
  tool-management --operation=validate --tool_category=cli --tool_name="mysql" --validate_auth=true
```

### Related Skills Integration

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `mcp-server-management` | **Absorbed Functionality** | MCP-specific operations migrated to tool-management |
| `support-investigation` | **Tool Validation** | Pre-investigation tool availability checks |
| `code-development` | **Development Tools** | Validate development environment tools |
| `jira-management` | **Fallback Integration** | MCP → CLI → Web fallback chains |
| `confluence-management` | **Multi-Tier Validation** | MCP → Browser → Manual workflows |
| `databricks-analytics` | **Query Tool Validation** | MCP → CLI → Web UI alternatives |

### Integration Points

#### Pre-Operation Tool Validation
```bash
# Standard pre-operation check for any skill
validate_prerequisites() {
    local skill_name="$1"
    local operation="$2"

    # Get skill-specific tool requirements
    local required_tools=$(get_skill_requirements "$skill_name")

    # Validate each required tool
    for tool in $required_tools; do
        if ! /tool-management --operation=validate --tool_name="$tool" --suggest_alternatives=false; then
            echo "❌ Required tool '$tool' unavailable for $skill_name"
            /tool-management --operation=suggest-fallbacks --tool_name="$tool" --operation_context="$operation"
            return 1
        fi
    done

    echo "✅ All prerequisites validated for $skill_name"
    return 0
}
```

#### Fallback Chain Integration
```bash
# Intelligent fallback chain execution
execute_with_fallbacks() {
    local operation_context="$1"
    shift
    local fallback_chain=("$@")

    for tool in "${fallback_chain[@]}"; do
        echo "🔄 Attempting operation with $tool..."

        if /tool-management --operation=validate --tool_name="$tool"; then
            if execute_operation_with_tool "$tool" "$operation_context"; then
                echo "✅ Operation completed successfully with $tool"
                return 0
            else
                echo "❌ Operation failed with $tool, trying next fallback..."
            fi
        else
            echo "⚠️ Tool $tool unavailable, skipping to next fallback..."
        fi
    done

    echo "💥 All fallback options exhausted"
    return 1
}
```

### Skill-Specific Integration Patterns

#### Jira Management Integration
```bash
# Comprehensive Jira operation with fallbacks
execute_jira_operation() {
    local operation="$1"
    local issue_key="$2"

    # Primary: MCP Atlassian tools
    if /tool-management --operation=validate --tool_name="atlassian.getJiraIssue"; then
        # Execute with MCP tools
        return 0
    fi

    # Fallback: CLI tools
    if /tool-management --operation=validate --tool_name="acli" --validate_auth=true; then
        acli jira view "$issue_key"
        return 0
    fi

    # Manual: Web interface
    echo "🌐 Opening Jira web interface for manual operation..."
    open "https://zillowgroup.atlassian.net/browse/$issue_key"
}
```

#### GitLab Operations Integration
```bash
# GitLab operation with intelligent fallbacks
execute_gitlab_operation() {
    local operation="$1"
    local mr_id="$2"

    # Primary: GitLab Sidekick MCP
    if /tool-management --operation=validate --tool_name="gitlab-sidekick.gitlab_mrOverview"; then
        # Execute with MCP tools
        return 0
    fi

    # Fallback: glab CLI
    if /tool-management --operation=validate --tool_name="glab" --validate_auth=true; then
        glab mr view "$mr_id"
        return 0
    fi

    # Manual: Web interface
    echo "🌐 Opening GitLab web interface for manual operation..."
    open "https://gitlab.zgtools.net/-/merge_requests/$mr_id"
}
```

#### Database Operations Integration
```bash
# Database operation with comprehensive tool validation
execute_database_operation() {
    local operation="$1"
    local query="$2"
    local environment="$3"

    # Validate environment-specific requirements
    /tool-management --operation=validate --operation_context="database-$environment" --tool_category=all

    # Primary: Databricks MCP for analytics
    if [[ "$operation" == "analytics" ]] && /tool-management --operation=validate --tool_name="databricks.execute_sql_query"; then
        # Execute with Databricks MCP
        return 0
    fi

    # Fallback: Direct database connection
    if /tool-management --operation=validate --tool_name="mysql" --validate_auth=true; then
        mysql -e "$query"
        return 0
    fi

    # Manual: Database web interface
    echo "🌐 Use database web interface for manual query execution"
    echo "Query: $query"
}
```

### Tool Ecosystem Health Monitoring

#### Continuous Integration with Skills
```bash
# Monitor tool health across all skills
monitor_ecosystem_health() {
    local skills_directory=".claude/skills"

    echo "🔍 Monitoring tool ecosystem health..."

    # Check each skill's tool dependencies
    for skill_dir in "$skills_directory"/*/; do
        local skill_name=$(basename "$skill_dir")

        echo "Checking $skill_name dependencies..."

        # Validate skill-specific tools
        /tool-management --operation=validate --tool_name="$skill_name" --tool_category=skill

        # Check critical dependencies
        validate_skill_dependencies "$skill_name"
    done

    # Generate health report
    generate_ecosystem_health_report
}

# Proactive maintenance scheduling
schedule_maintenance() {
    local maintenance_type="$1"  # daily|weekly|monthly

    case "$maintenance_type" in
        "daily")
            validate_critical_tools
            refresh_authentication_tokens
            ;;
        "weekly")
            comprehensive_health_check
            update_tool_cache
            ;;
        "monthly")
            full_ecosystem_audit
            generate_optimization_recommendations
            ;;
    esac
}
```

### Quality Assurance Integration

**Tool Management Validation Checklist:**
- ✓ All tool categories (MCP, CLI, Skills, Built-in) validated consistently
- ✓ Fallback chains provide functional alternatives for all operations
- ✓ Installation guidance specific and actionable for each tool
- ✓ Authentication validation works for all CLI tools requiring auth
- ✓ Integration patterns standardized across all dependent skills
- ✓ Error messages user-friendly and provide clear next steps

### Integration Testing Patterns

#### Automated Integration Testing
```bash
# Test tool management integration across skills
test_skill_integrations() {
    local test_scope="$1"  # basic|comprehensive

    case "$test_scope" in
        "basic")
            test_core_tool_validation
            test_basic_fallback_chains
            ;;
        "comprehensive")
            test_all_skill_integrations
            test_complex_fallback_scenarios
            test_authentication_flows
            test_error_handling
            ;;
    esac

    generate_integration_test_report
}
```

This comprehensive integration framework ensures seamless tool management across all Claude Code skills with intelligent fallbacks, proactive monitoring, and standardized error handling patterns.