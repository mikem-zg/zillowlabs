---
name: tool-management
description: Comprehensive tool validation, availability checking, and fallback orchestration for all tool categories (MCP servers, CLI tools, Skills, Built-in tools) with intelligent alternative suggestions and seamless integration patterns for other Claude Code skills
---

## Examples

```bash
# Validate specific MCP tool before operation
/tool-management --operation="validate" --tool_name="atlassian.getJiraIssue" --suggest_alternatives=true

# Check all CLI tools availability with auth validation
/tool-management --operation="check-availability" --tool_category="cli" --validate_auth=true

# Get comprehensive fallback chain for Jira operations
/tool-management --operation="fallback-chain" --operation_context="jira-search" --suggest_alternatives=true

# Health check for all MCP servers
/tool-management --operation="health-check" --tool_category="mcp"

# Installation guidance for missing CLI tools
/tool-management --operation="install-guidance" --tool_name="glab" --tool_category="cli"

# Check comprehensive tool ecosystem status
/tool-management --operation="check-availability" --tool_category="all"
```

## Overview

Comprehensive tool validation, availability checking, and fallback orchestration for all tool categories (MCP servers, CLI tools, Skills, Built-in tools) with intelligent alternative suggestions and seamless integration patterns for other Claude Code skills. Eliminates workflow disruption through proactive validation, intelligent fallbacks, and transparent recovery mechanisms.

🔍 **Tool Matrices**: [reference/tool-matrices.md](reference/tool-matrices.md)
⚙️ **Implementation Details**: [reference/implementation-details.md](reference/implementation-details.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Usage

```bash
/tool-management [--operation=<op>] [--tool_name=<name>] [--tool_category=<category>] [--operation_context=<context>] [--suggest_alternatives=<bool>] [--validate_auth=<bool>]
```

## Core Workflow

### Essential Tool Management Steps (Most Common - 90% of Usage)

**1. Quick Tool Validation**
```bash
# Validate specific tool before operation
/tool-management --operation="validate" --tool_name="atlassian.getJiraIssue"

# Check all CLI tools availability
/tool-management --operation="check-availability" --tool_category="cli" --validate_auth=true
```

**2. Health Check and Status**
```bash
# Comprehensive system health check
/tool-management --operation="health-check" --tool_category="all"

# MCP server status validation
/tool-management --operation="health-check" --tool_category="mcp"
```

**3. Fallback and Recovery**
```bash
# Get fallback suggestions when tools fail
/tool-management --operation="suggest-fallbacks" --operation_context="jira-search"

# Get complete fallback chain
/tool-management --operation="fallback-chain" --operation_context="gitlab-mr-creation" --suggest_alternatives=true
```

**Preconditions:**
- **Tool Access**: Appropriate permissions for checking tool availability
- **Authentication**: Valid credentials for CLI tools requiring auth
- **System Access**: Ability to test tool functionality and connectivity

## Tool Categories and Validation

### 1. **MCP Tools** (Server-Dependent)
- **Atlassian MCP**: Jira, Confluence operations
- **Serena MCP**: Semantic code navigation
- **Databricks MCP**: SQL query execution
- **Glean MCP**: Documentation search
- **GitLab Sidekick MCP**: GitLab operations
- **Chrome DevTools MCP**: Browser automation
- **Context7 MCP**: Library documentation
- **Datadog MCP**: Monitoring and logs

### 2. **CLI Tools** (Installation-Dependent)
- **GitLab**: `glab` (GitLab CLI)
- **Atlassian**: `acli` (Atlassian CLI)
- **Datadog**: `datadog` (Datadog CLI)
- **Database**: `mysql`, `psql` database clients
- **Development**: `git`, `npm`, `composer`, `ssh`
- **System**: `curl`, `jq`, `grep`, `find`

### 3. **Skills** (Configuration-Dependent)
- **Claude Code Agent Skills**: All skills in `.claude/skills/`
- **Skill Dependencies**: MCP servers, CLI tools, file access
- **Configuration Validation**: Parameter validation, precondition checks

### 4. **Built-in Tools** (Always Available)
- **File Operations**: `Read`, `Write`, `Edit`, `Glob`, `Grep`
- **System**: `Bash`, `TaskCreate`, `TaskUpdate`
- **User Interaction**: `AskUserQuestion`, `WebFetch`

## Core Operations

### Essential Operations (Most Common - 90% of Usage)

**1. Pre-Operation Tool Validation**
```bash
# Before any operation, validate required tools
tool-management --operation="validate" --operation_context="jira-issue-creation" --suggest_alternatives=true

# Comprehensive validation for multi-tool operations
tool-management --operation="validate" --tool_category="all" --operation_context="support-investigation"
```

**2. Intelligent Fallback Generation**
```bash
# Get fallback chain for failed MCP operation
tool-management --operation="fallback-chain" --operation_context="confluence-page-search" --tool_category="mcp"

# Context-aware alternative recommendations
tool-management --operation="fallback-chain" --operation_context="gitlab-mr-analysis" --suggest_alternatives=true
```

**3. Installation and Authentication Guidance**
```bash
# Provide installation guidance for missing CLI tools
tool-management --operation="install-guidance" --tool_name="glab" --tool_category="cli"

# Validate authentication status and provide auth guidance
tool-management --operation="validate" --tool_category="cli" --validate_auth=true --suggest_alternatives=true
```

**4. Tool Ecosystem Health Monitoring**
```bash
# Monitor overall tool ecosystem health
tool-management --operation="health-check" --tool_category="all"

# Daily tool availability assessment
tool-management --operation="check-availability" --tool_category="all" --validate_auth=true
```

### Validation Algorithms

**MCP Tool Validation:**
1. Check MCP server connectivity using `claude mcp list`
2. Validate specific tool availability through server queries
3. Test authentication and permission status
4. Measure response times and reliability

**CLI Tool Validation:**
1. Check installation status using `which` or `command -v`
2. Validate version compatibility and functionality
3. Test authentication and credential status
4. Verify required permissions and access

**Skill Validation:**
1. Verify skill directory structure and SKILL.md existence
2. Check skill dependencies (MCP servers, CLI tools, file access)
3. Validate parameter definitions and preconditions
4. Test skill invocation and basic functionality

## Quick Reference

### Common Fallback Chains

**Jira Operations:**
1. `atlassian.getJiraIssue` (MCP) → `acli jira view` (CLI) → Browser navigation (Manual)

**GitLab Operations:**
1. `gitlab-sidekick.gitlab_mrOverview` (MCP) → `glab mr view` (CLI) → GitLab web UI (Manual)

**Confluence Operations:**
1. `atlassian.getConfluencePage` (MCP) → Browser automation (MCP) → Manual page access (Manual)

**Code Analysis:**
1. `serena-mcp` (MCP) → `grep`/`find` (CLI) → Manual code search (Manual)

**Database Operations:**
1. `databricks.execute_sql_query` (MCP) → `mysql`/`psql` clients (CLI) → Database web UI (Manual)

→ **Complete tool validation matrices**: [reference/tool-matrices.md](reference/tool-matrices.md)

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

## Integration Patterns

### Standard Integration (Add to any skill's preconditions)
```markdown
**Tool Availability Integration**: This skill implements comprehensive tool validation patterns:
- Automatic availability checking for all required tools before operations
- Intelligent fallback suggestions when tools are unavailable across all categories
- Seamless alternative recommendations (MCP → CLI → Manual workflows)
- Integration with tool-management skill for validation, recovery, and user guidance
```

### Cross-Skill Workflow Patterns

**Tool Management → All Skills:**
```bash
# Universal pre-operation validation pattern
any-skill-operation --validate-tools=true |
  tool-management --operation=validate --operation_context="skill-operation" --suggest_alternatives=true
```

**Tool Management → Support Investigation:**
```bash
# Comprehensive tool validation for investigation workflows
support-investigation --issue="Tool unavailability" --environment="development" |
  tool-management --operation=health-check --tool_category=all --validate_auth=true
```

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

### Related Skills Integration

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `mcp-server-management` | **Absorbed Functionality** | MCP-specific operations migrated to tool-management |
| `support-investigation` | **Tool Validation** | Pre-investigation tool availability checks |
| `code-development` | **Development Tools** | Validate development environment tools |
| `jira-management` | **Fallback Integration** | MCP → CLI → Web fallback chains |
| `confluence-management` | **Multi-Tier Validation** | MCP → Browser → Manual workflows |
| `databricks-analytics` | **Query Tool Validation** | MCP → CLI → Web UI alternatives |

## Quality Assurance

**Tool Management Validation Checklist:**
- ✓ All tool categories (MCP, CLI, Skills, Built-in) validated consistently
- ✓ Fallback chains provide functional alternatives for all operations
- ✓ Installation guidance specific and actionable for each tool
- ✓ Authentication validation works for all CLI tools requiring auth
- ✓ Integration patterns standardized across all dependent skills
- ✓ Error messages user-friendly and provide clear next steps

## Refusal Conditions

The skill must refuse if:
- Tool validation cache cannot be created or accessed for storing validation results
- Required system commands (claude mcp, which, command -v) are not available
- File system permissions prevent access to skill directories or MCP configuration
- Tool validation would require access to systems not covered by proper authorization
- Operation scope exceeds reasonable tool management boundaries or safety requirements

When refusing, provide specific guidance:
- How to verify system requirements for tool validation functionality
- Steps to obtain proper file system permissions for tool management operations
- Alternative approaches for tool validation that meet system constraints
- Guidance on tool management scope and security requirements
- Resources for obtaining proper system access and authorization

## Supporting Infrastructure

→ **Advanced orchestration patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Complete implementation details**: [reference/implementation-details.md](reference/implementation-details.md)

**Critical Integration Note**: This skill provides comprehensive tool validation and fallback orchestration for the entire Claude Code ecosystem, absorbing and expanding MCP server management functionality while adding CLI tools, Skills, and Built-in tool validation with intelligent context-aware alternatives and seamless integration patterns for eliminating workflow disruption from tool unavailability.