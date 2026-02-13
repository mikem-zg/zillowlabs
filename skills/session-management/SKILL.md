---
name: session-management
description: Comprehensive session efficiency and context management for Claude Code with automatic complexity tracking, proactive guidance, and workflow optimization across all skills and operations
---

## Overview

Comprehensive session efficiency and context management system for Claude Code that provides automatic complexity tracking, proactive workflow guidance, and intelligent optimization recommendations across all skills and operations to maximize development productivity.

## Usage

```bash
/session-management [--operation=<op>] [--context=<ctx>] [--skill_name=<skill>] [--tool_name=<tool>] [--reset_confirmation=<bool>]
```

## Examples

```bash
# Session analysis and monitoring
/session-management --operation="summary"
/session-management --operation="optimize"
/session-management --operation="check-complexity"

# Session lifecycle management
/session-management --operation="reset" --reset_confirmation=true
/session-management --operation="new-session"

# Context-specific efficiency guidance
/session-management --operation="guidelines" --context="jira"
/session-management --operation="guidelines" --context="gitlab"
/session-management --operation="guidelines" --context="code"
/session-management --operation="guidelines" --context="databricks"

# Internal tracking (used by other skills)
/session-management --operation="track-operation" --skill_name="jira-management" --tool_name="atlassian.getJiraIssue" --context="jira-search"
```

## Core Workflow

### 1. Session Monitoring and Analysis
**Essential session management operations:**

1. **Real-Time Complexity Tracking**
   ```bash
   # Check current session status
   /session-management --operation="summary"

   # Quick complexity verification
   /session-management --operation="check-complexity"
   ```

2. **Proactive Optimization**
   ```bash
   # Get optimization recommendations
   /session-management --operation="optimize"

   # Context-specific guidance
   /session-management --operation="guidelines" --context="code"
   ```

3. **Session Lifecycle Management**
   ```bash
   # Reset session when complexity exceeds thresholds
   /session-management --operation="reset" --reset_confirmation=true

   # Start new session for clean slate
   /session-management --operation="new-session"
   ```

### 2. Complexity Threshold Management
**Progressive alert system for session efficiency:**

- **20+ operations**: 💡 Optimization suggestions
- **30+ operations**: ⚠️ Approaching limits warning
- **50+ operations**: 🚨 Mandatory intervention
- **High diversity (15+ tools)**: 🔄 Tool consolidation guidance

### 3. Cross-Skill Integration
**Automatic tracking for participating skills:**

```bash
# Internal API for skill integration
/session-management --operation="track-operation" --skill_name="skill-name" --tool_name="tool-used"
```

**Integration benefits:**
- Automatic complexity tracking across all skills
- Cross-skill awareness for optimization
- Proactive guidance to prevent context overload
- Data-driven efficiency insights

## Quick Reference

### Common Operations

#### Session Analysis Commands
```bash
# View current session status and complexity
/session-management --operation="summary"

# Get detailed optimization analysis with recommendations
/session-management --operation="optimize"

# Quick complexity check without full analysis
/session-management --operation="check-complexity"
```

#### Session Management Commands
```bash
# Reset session tracking (requires confirmation)
/session-management --operation="reset" --reset_confirmation=true

# Start new session (automatic if >2 hours old)
/session-management --operation="new-session"
```

#### Context-Specific Guidance
```bash
# Jira/Atlassian operations efficiency
/session-management --operation="guidelines" --context="jira"

# GitLab operations optimization
/session-management --operation="guidelines" --context="gitlab"

# Code development workflow guidance
/session-management --operation="guidelines" --context="code"

# Data analysis (Databricks) efficiency
/session-management --operation="guidelines" --context="databricks"

# General development efficiency
/session-management --operation="guidelines" --context="general"
```

### Session Efficiency Rules

**Core Principles:**
- **Tool Call Limits**: Stay under 50 tool calls per session
- **Warning System**: Automatic alerts at 30+ tools used
- **Optimization Focus**: Prioritize targeted tools over exploration
- **Context Awareness**: Specialized guidance for different domains
- **Recovery Patterns**: Smart session break suggestions

**Context-Aware Optimization:**

| Context | Preferred Tools | Optimization Strategy |
|---------|-----------------|----------------------|
| **Jira** | jira-management, confluence-management | Batch operations, MCP → CLI → Web fallback |
| **GitLab** | gitlab-mr-search, gitlab-pipeline-monitoring | Combine operations, GitLab Sidekick → glab CLI |
| **Code** | serena-mcp, code-development | Semantic navigation, batch file operations |
| **Databricks** | databricks-analytics | Batch SQL queries, catalog navigation |
| **General** | Built-in → Skills → MCP → CLI → Manual | Regular complexity checks, proactive breaks |

### Session Metrics and Analytics

**Key Metrics:**
- **Tool Diversity Ratio**: (unique_tools * 100) / tool_calls
- **Average Calls Per Tool**: tool_calls / unique_tools
- **Category Distribution**: MCP, CLI, Skills, Built-in breakdown
- **Context Specialization**: Domain focus level

**Optimization Thresholds:**
- **Low Diversity** (<20%): Use more specialized tools
- **High Diversity** (>80%): Focus on fewer tools
- **High Complexity** (>threshold): Session break recommended

### Integration API for Skills

**Tracking Integration:**
```bash
# Add to skill workflows for automatic session tracking
/session-management --operation="track-operation" \
  --skill_name="your-skill" \
  --tool_name="tool-used" \
  --context="operation-context"
```

**Complexity Checking:**
```bash
# Check before complex operations
if ! /session-management --operation="check-complexity" --context="your-context"; then
  echo "Consider session optimization before proceeding"
fi
```

## Advanced Patterns

### Custom Session Analytics

#### Session State Management
**Session tracking data structure:**
```json
{
  "session_id": "timestamp-pid",
  "start_time": "unix_timestamp",
  "duration": "formatted_duration",
  "tool_calls": "total_operations",
  "unique_tools": ["tool1", "tool2"],
  "operations": [
    {
      "skill": "skill_name",
      "tool": "tool_name",
      "context": "operation_context",
      "timestamp": "operation_time"
    }
  ],
  "complexity_score": "calculated_score",
  "warnings_issued": ["warning_type1", "warning_type2"]
}
```

#### Advanced Analytics Scripts
```bash
# Access session analytics utilities
source ~/.claude/skills/session-management/scripts/session-utils.sh

# Advanced complexity analysis
analyze_session_patterns "detailed"

# Generate efficiency recommendations
generate_optimization_report

# Export session data for analysis
export_session_metrics "csv"
```

### Complex Session Scenarios

#### High-Complexity Workflow Management
**When approaching session limits:**

1. **Proactive Session Breaking**
   - Break complex tasks into focused sessions
   - Use session reset strategically
   - Maintain workflow context across sessions

2. **Tool Consolidation Strategies**
   - Batch similar operations together
   - Use specialized skills for complex workflows
   - Prefer fewer, more powerful tools

3. **Context Switching Optimization**
   - Minimize domain switching within sessions
   - Group related operations by context
   - Use context-specific guidance proactively

#### Integration with Development Workflows

**Pre-Operation Complexity Checks:**
```bash
# Before starting complex development tasks
if /session-management --operation="check-complexity" --context="code"; then
  echo "Session optimized for development work"
else
  /session-management --operation="optimize"
fi
```

**Workflow-Specific Optimization:**
```bash
# For GitLab-heavy workflows
/session-management --operation="guidelines" --context="gitlab"
# Implement GitLab-specific efficiency recommendations

# For Databricks analysis sessions
/session-management --operation="guidelines" --context="databricks"
# Apply data analysis optimization strategies
```

### Performance Optimization Techniques

#### Session Efficiency Monitoring
**Continuous efficiency tracking:**

1. **Real-time complexity monitoring** with tool usage limits
2. **Proactive guidance** when approaching thresholds
3. **Intelligent optimization recommendations** for workflows
4. **Context-aware efficiency suggestions** by operation type
5. **Cross-skill complexity tracking** for comprehensive analysis

#### Advanced Recovery Patterns
**When sessions become complex:**

1. **Intelligent Session Reset**
   - Preserve critical context
   - Clean slate for focused work
   - Strategic checkpoint creation

2. **Workflow Focus Restoration**
   - Identify core objectives
   - Eliminate non-essential operations
   - Streamline tool usage patterns

3. **Context Consolidation**
   - Group related operations
   - Minimize context switching
   - Use domain-specific skills

### Script Integration and Automation

#### Supporting Scripts Architecture
**Core session management scripts:**

- `scripts/session-complexity.sh` - Real-time complexity tracking and analysis
- `scripts/session-utils.sh` - Common utility functions and operations
- `scripts/main-entrypoint.sh` - Primary session management coordination

**Advanced integration capabilities:**
```bash
# Source session utilities in other skills
source ~/.claude/skills/session-management/scripts/session-utils.sh

# Use session tracking functions
track_skill_operation "skill-name" "tool-name" "context"
check_session_complexity "operation-context"
get_optimization_recommendations "context"
```

#### Automated Session Optimization
**Proactive efficiency management:**

1. **Threshold-based automation** - Automatic optimization triggers
2. **Context-aware suggestions** - Domain-specific efficiency guidance
3. **Cross-skill coordination** - Integrated complexity management
4. **Data-driven insights** - Analytics-based recommendations

## Integration Points

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `claude-code-maintenance` | **Performance Monitoring** | Session efficiency analysis, optimization validation, maintenance decision support |
| `jira-management` | **Context Optimization** | Atlassian operation batching, MCP fallback coordination |
| `gitlab-mr-search` | **Workflow Efficiency** | GitLab operation consolidation, pipeline monitoring coordination |
| `serena-mcp` | **Code Session Management** | Semantic navigation optimization, file operation batching |
| `databricks-analytics` | **Analytics Session Optimization** | SQL query batching, catalog navigation efficiency |
| `database-operations` | **Operation Complexity Management** | Database session safety, transaction coordination |
| `support-investigation` | **Investigation Session Management** | Multi-tool investigation coordination, context preservation |

#### Multi-Skill Operation Examples

**Development Workflow Optimization:**
```bash
# Optimize code development session
/session-management --operation="guidelines" --context="code" |\
  /serena-mcp --task="Navigate codebase efficiently" |\
  /session-management --operation="track-operation" --skill_name="serena-mcp" --tool_name="semantic-search"
```

**GitLab Workflow Efficiency:**
```bash
# Coordinate GitLab operations
/session-management --operation="check-complexity" --context="gitlab" |\
  /gitlab-mr-search --query="active merge requests" |\
  /session-management --operation="track-operation" --skill_name="gitlab-mr-search" --tool_name="gitlab-api"
```

**Investigation Session Management:**
```bash
# Manage complex support investigation
/session-management --operation="summary" |\
  /support-investigation --issue="complex-issue" |\
  /session-management --operation="optimize" --context="investigation"
```

**Maintenance Integration:**
```bash
# Session efficiency analysis for maintenance
/claude-code-maintenance --operation="analyze-session-efficiency" |\
  /session-management --operation="optimize" |\
  /claude-code-maintenance --operation="optimize-performance"
```

#### Workflow Handoff Patterns

**From session-management → Other Skills:**
- Provides session complexity status for operation planning
- Supplies context-specific efficiency recommendations
- Offers tool usage optimization guidance
- Delivers proactive session management alerts

**To session-management ← Other Skills:**
- Receives operation tracking data for complexity analysis
- Gets tool usage patterns for optimization recommendations
- Obtains context information for specialized guidance
- Accepts session efficiency feedback and metrics

### Bidirectional Integration Examples

**session-management ↔ claude-code-maintenance:**
- → Session provides: Real-time complexity data, tool usage patterns, efficiency metrics
- ← Maintenance provides: Optimization targets, session analysis results, performance standards
- **Integration**: Data-driven maintenance decisions and session optimization prioritization

**session-management ↔ jira-management:**
- → Session provides: Atlassian operation efficiency guidance, batching recommendations
- ← Jira provides: Operation complexity feedback, tool usage patterns, context requirements
- **Integration**: Optimized Atlassian workflows with proactive session management

**session-management ↔ serena-mcp:**
- → Session provides: Code development efficiency guidance, file operation batching suggestions
- ← Serena provides: Semantic navigation complexity data, symbol operation tracking
- **Integration**: Optimized code development sessions with intelligent complexity management

**session-management ↔ database-operations:**
- → Session provides: Database session complexity monitoring, transaction efficiency guidance
- ← Database provides: Operation safety requirements, transaction complexity feedback
- **Integration**: Safe and efficient database operations with session complexity awareness

### Integration Architecture

#### Session Management Coordination Framework

**System-Wide Session Efficiency Management:**

1. **Cross-Skill Tracking**: All participating skills contribute to session complexity analysis
2. **Context-Aware Optimization**: Specialized efficiency guidance for different operation domains
3. **Proactive Management**: Early warning system prevents context overload across all skills
4. **Data-Driven Insights**: Analytics-based efficiency improvements for entire skill ecosystem
5. **Workflow Coordination**: Intelligent session management across multi-skill operations

#### Session Management Integration Standards

**All skills can integrate with session-management through:**

1. **Operation Tracking API**: `--operation="track-operation" --skill_name="skill" --tool_name="tool"`
2. **Complexity Checking**: `--operation="check-complexity" --context="operation-context"`
3. **Context Guidance**: `--operation="guidelines" --context="domain-specific"`
4. **Optimization Coordination**: Automated efficiency recommendations and session management
5. **Analytics Integration**: Session metrics and performance data for continuous improvement

**System Requirements:**
- File system permissions for session state storage (`~/.claude/session-management/`)
- JSON processing capability (jq) for session analytics
- Integration with Claude Code skill ecosystem for cross-skill tracking

This skill provides comprehensive session efficiency management that **prevents context overload**, **maintains workflow focus**, and **provides intelligent optimization guidance** across the entire Claude Code skill ecosystem for maximum development productivity.