---
name: claude-code-history
description: Analyze Claude Code session history and usage patterns for optimization, troubleshooting, and performance insights using ~/.claude/ files
---

## Overview

Analyze Claude Code session history and usage patterns for optimization, troubleshooting, and performance insights using ~/.claude/ files. Provides systematic analysis of session patterns, tool usage analytics, token optimization opportunities, and workflow efficiency insights through jq queries on Claude Code's internal logging and caching system.!

🔍 **Session Analysis**: [analysis/session-patterns.md](analysis/session-patterns.md)
📊 **Usage Analytics**: [patterns/usage-analytics.md](patterns/usage-analytics.md)
⚡ **Performance Tuning**: [optimization/performance-tuning.md](optimization/performance-tuning.md)
🚨 **Error Analysis**: [troubleshooting/error-analysis.md](troubleshooting/error-analysis.md)
📖 **Quick Reference**: [reference/quick-reference.md](reference/quick-reference.md)

## Usage

```bash
/claude-code-history --analysis_type=<analysis_type> [--timeframe=<timeframe>] [--project=<project_filter>]
```

## Examples

```bash
# Analyze today's session patterns and workflows
/claude-code-history --analysis_type="session-analysis" --timeframe="today"

# Review tool usage patterns over the past week
/claude-code-history --analysis_type="usage-patterns" --timeframe="past-week"

# Optimize performance for a specific project
/claude-code-history --analysis_type="performance-optimization" --project="fub-main" --timeframe="past-month"

# Troubleshoot recent session errors and failures
/claude-code-history --analysis_type="troubleshooting" --timeframe="past-week"

# Analyze token usage and cost optimization opportunities
/claude-code-history --analysis_type="token-usage" --timeframe="past-month"

# Deep dive into specific project development patterns
/claude-code-history --analysis_type="session-analysis" --project="email-parser" --timeframe="past-week"
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Session Analysis and Review**
```bash
# Analyze recent Claude Code sessions for patterns and insights
claude-code-history --analysis_type="session-analysis" --timeframe="today"

# Review specific project development sessions
claude-code-history --analysis_type="session-analysis" --project="email-parser" --timeframe="past-week"

# Quick session performance check
claude-code-history --analysis_type="performance-optimization" --focus="recent"
```

**2. Usage Pattern Analysis**
```bash
# Analyze tool usage patterns and workflow efficiency
claude-code-history --analysis_type="usage-patterns" --timeframe="past-month"

# Compare usage patterns across different time periods
claude-code-history --analysis_type="usage-patterns" --compare="past-week,past-month"

# Focus on specific skill usage patterns
claude-code-history --analysis_type="usage-patterns" --filter="skill-usage"
```

**3. Performance and Optimization Analysis**
```bash
# Identify token usage optimization opportunities
claude-code-history --analysis_type="token-usage" --optimization="suggest"

# Analyze context management efficiency
claude-code-history --analysis_type="performance-optimization" --focus="context"

# Generate optimization recommendations
claude-code-history --analysis_type="performance-optimization" --report="detailed"
```

### Preconditions

- Claude Code must be installed and have been used (creating ~/.claude/ directory)
- Access to ~/.claude/ directory and its contents (history.jsonl, stats-cache.json)
- `jq` command-line tool available for JSON processing
- Bash environment for file analysis commands
- Session history files should contain meaningful data (at least 1-2 Claude Code sessions)

## Quick Reference

| Analysis Type | Purpose | Key Files | Output |
|---------------|---------|-----------|---------|
| `session-analysis` | Review session interactions and patterns | `history.jsonl` | Session summaries, conversation flows |
| `usage-patterns` | Analyze tool usage and workflow efficiency | `history.jsonl`, `stats-cache.json` | Tool frequency, optimization suggestions |
| `performance-optimization` | Token usage and context management insights | `stats-cache.json`, `history.jsonl` | Performance recommendations, bottlenecks |
| `troubleshooting` | Investigate session errors and failures | `history.jsonl`, logs | Error patterns, resolution guidance |
| `token-usage` | Analyze token consumption and efficiency | `stats-cache.json`, `history.jsonl` | Token metrics, cost optimization |

## Behavior

When invoked, execute this systematic Claude Code history analysis workflow:

### 1. Environment Discovery and Validation

**Locate Claude Code Directory:**
```bash
# Verify Claude Code installation and usage
ls -la ~/.claude/
find ~/.claude -name "*.jsonl" -o -name "stats-cache.json" | head -10
```

**Directory Structure Assessment:**
- `~/.claude/projects/` - Project-specific configurations and history
- `~/.claude/stats-cache.json` - Usage statistics and performance metrics
- `~/.claude/projects/*/history.jsonl` - Session conversation logs
- `~/.claude/projects/*/settings.local.json` - Project-specific settings
- `~/.claude/mcp_servers/` - MCP server configurations

### 2. Analysis Type Routing

**Route to Specialized Analysis:**
```bash
case "$analysis_type" in
    "session-analysis")
        → analysis/session-patterns.md - Session content and flow analysis
        ;;
    "usage-patterns")
        → patterns/usage-analytics.md - Tool usage and workflow optimization
        ;;
    "performance-optimization")
        → optimization/performance-tuning.md - Context and token optimization
        ;;
    "troubleshooting")
        → troubleshooting/error-analysis.md - Error detection and recovery
        ;;
    "token-usage")
        → optimization/performance-tuning.md - Token efficiency analysis
        ;;
esac
```

### 3. Core Analysis Framework

**Session Discovery and Filtering:**
```bash
# Apply timeframe and project filters
filter_sessions() {
    local timeframe="$1"
    local project_filter="$2"

    case "$timeframe" in
        "today")
            find ~/.claude/projects -name "*.jsonl" -newermt "1 day ago"
            ;;
        "past-week")
            find ~/.claude/projects -name "*.jsonl" -newermt "7 days ago"
            ;;
        "past-month")
            find ~/.claude/projects -name "*.jsonl" -newermt "30 days ago"
            ;;
        *)
            find ~/.claude/projects -name "*.jsonl"
            ;;
    esac | if [[ -n "$project_filter" ]]; then
        grep -E "$project_filter"
    else
        cat
    fi
}
```

**Essential jq Queries Framework:**
```bash
# Session metadata extraction
jq -r '.timestamp, .type, .content[0:100]' ~/.claude/projects/*/history.jsonl

# Tool usage frequency analysis
jq -r 'select(.type == "tool_use") | .tool_name' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr

# Performance metrics from stats cache
jq '.session_stats // .performance_metrics // .' ~/.claude/stats-cache.json

# Error pattern detection
jq -r 'select(.type == "error") | .error_type // .error_message[0:50]' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr
```

### 4. FUB-Specific Analysis Integration

**FUB Project Pattern Recognition:**
```bash
# Analyze FUB-specific tool usage across projects
for project in fub fub-spa pegasus mutagen; do
    if [[ -d ~/.claude/projects/*$project* ]]; then
        echo "=== $project Analysis ==="
        find ~/.claude/projects -name "*$project*" -name "*.jsonl" |
          xargs jq -r 'select(.type == "tool_use") | .tool_name' |
          sort | uniq -c | sort -nr | head -5
    fi
done
```

**Skill Integration Analytics:**
```bash
# Integration between Claude Code skills
grep -r "serena-mcp\|gitlab-pipeline-monitoring\|datadog-management" \
  ~/.claude/projects/*/history.jsonl | wc -l
```

### 5. Optimization Recommendation Engine

**Performance Optimization Suggestions:**
```bash
# Context management optimization
jq 'select(.context_length > 50000) |
  {project, timestamp, context_length, tools_used: [.tools[]]}' \
  ~/.claude/projects/*/history.jsonl

# Tool usage optimization patterns
jq -r 'select(.type == "tool_use") | .tool_name + " " + .timestamp' \
  ~/.claude/projects/*/history.jsonl |
  awk '{
    tools[NR] = $1;
    times[NR] = $2;
    if(NR > 1 && tools[NR] == tools[NR-1]) {
      time_diff = times[NR] - times[NR-1];
      if(time_diff < 60) print "Redundant: " tools[NR] " within " time_diff "s"
    }
  }'
```

## Progressive Analysis Framework

### Level 1: Quick Health Check (Most Common)

**Daily Performance Summary:**
```bash
# Quick daily health check - essential metrics only
echo "=== Claude Code Daily Summary ==="
echo "Sessions Today: $(find ~/.claude/projects -name "*.jsonl" -newermt "1 day ago" | wc -l)"
echo "Active Projects: $(ls ~/.claude/projects | wc -l)"
echo "Most Used Tools Today:"
jq -r 'select(.type == "tool_use" and .timestamp > (now - 24*3600)) | .tool_name' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr | head -3
```

### Level 2: Targeted Analysis (Medium Complexity)

**Weekly Pattern Analysis:**
- **Tool Usage Trends**: Identify workflow changes and efficiency patterns
- **Context Management**: Session efficiency and optimization opportunities
- **Error Pattern Detection**: Common failures and resolution patterns
- **Project Performance**: Cross-project productivity comparison

→ **Detailed Queries**: [patterns/usage-analytics.md](patterns/usage-analytics.md)

### Level 3: Comprehensive Optimization (Advanced)

**Multi-Session Performance Analysis:**
- **Advanced Context Analysis**: Context bloat patterns and optimization
- **Cross-Project Correlation**: Development velocity and Claude Code usage
- **Tool Effectiveness Scoring**: Success rates and duration analysis
- **Automated Dashboard Generation**: HTML performance dashboards

→ **Advanced Patterns**: [optimization/performance-tuning.md](optimization/performance-tuning.md)

## Quality Assurance and Validation

**Analysis Quality Checklist:**
- ✓ All history.jsonl files accessible and readable?
- ✓ jq queries returning expected data structures?
- ✓ Stats-cache.json contains performance metrics?
- ✓ Error analysis identifying actionable issues?
- ✓ Optimization recommendations specific and implementable?

**Data Integrity Verification:**
- ✓ Session timestamps in chronological order?
- ✓ Tool usage records complete with success/failure status?
- ✓ Project mappings accurate and consistent?
- ✓ Token usage calculations mathematically sound?

## Common Usage Patterns

**Daily Optimization Review:**
```bash
# Quick daily health check
claude-code-history analysis_type=usage-patterns timeframe=today
```

**Weekly Performance Analysis:**
```bash
# Comprehensive weekly review
claude-code-history analysis_type=performance-optimization timeframe=past-week
```

**Troubleshooting Session Issues:**
```bash
# Investigate recent problems
claude-code-history analysis_type=troubleshooting timeframe=today
```

**Project-Specific Analysis:**
```bash
# Focus on specific project
claude-code-history analysis_type=session-analysis project=fub
```

## Advanced Patterns

<details>
<summary>Click to expand advanced Claude Code history analysis techniques and optimization strategies</summary>

### Advanced Session Analysis and Optimization

**Complex Multi-Session Performance Analysis:**
Advanced performance trend analysis across multiple sessions with completion rate correlation, context efficiency scoring, and tool usage diversity metrics. Pattern matching identifies workflow optimization opportunities and session management improvements.

**Automated Performance Optimization Suggestions:**
Machine learning-based recommendation engine that analyzes session patterns to suggest context management improvements, tool selection optimization, and workflow streamlining based on historical effectiveness data.

**Real-Time Session Monitoring:**
Live session performance monitoring with configurable thresholds for context usage, tool switching frequency, and error rates with automated alerting and optimization recommendations.

📊 **Complete Analysis Guide**: [optimization/performance-tuning.md](optimization/performance-tuning.md)
🔍 **Session Patterns**: [analysis/session-patterns.md](analysis/session-patterns.md)
📈 **Usage Analytics**: [patterns/usage-analytics.md](patterns/usage-analytics.md)

</details>

## Refusal Conditions

The skill must refuse if:
- ~/.claude/ directory doesn't exist or is inaccessible
- No history.jsonl files found (Claude Code never used)
- jq command-line tool not available in environment
- Insufficient permissions to read Claude Code internal files
- Stats-cache.json missing or corrupted (for performance analysis)
- Analysis type not supported or invalid parameters provided

When refusing, explain which precondition failed and provide specific guidance:
- How to verify Claude Code installation and usage
- Steps to install jq for JSON processing
- Permission requirements for accessing ~/.claude/ directory
- Alternative approaches for analyzing Claude Code usage
- Integration guidance with Claude Code's built-in analytics

## Integration Points

### Cross-Skill Workflow Patterns

**Claude Code History → Support Investigation:**
```bash
# Analyze Claude Code performance issues
claude-code-history --analysis_type="session_performance" --timeframe="past_week" |\
  support-investigation --issue="Claude Code session timeouts" --environment="development"

# Investigate Claude Code usage patterns during incidents
support-investigation --issue="Development productivity decline" --environment="development" |\
  claude-code-history --analysis_type="tool_usage" --timeframe="past_month"
```

**Claude Code History → Serena MCP:**
```bash
# Analyze Serena MCP usage effectiveness
claude-code-history --analysis_type="tool_effectiveness" --focus="serena-mcp" |\
  serena-mcp --task="Evaluate semantic navigation patterns" --scope="usage-optimization"

# Optimize Serena MCP workflow based on usage data
claude-code-history --analysis_type="session_context" --focus="serena-usage" |\
  serena-mcp --task="Refine symbol navigation strategy" --scope="performance-optimization"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Performance Analysis** | Claude Code issue investigation, productivity analysis, workflow debugging |
| `serena-mcp` | **Tool Effectiveness** | Semantic navigation analysis, symbol usage patterns, codebase exploration efficiency |
| `datadog-management` | **Monitoring Integration** | Correlate Claude Code usage with system performance, development velocity tracking |
| `gitlab-pipeline-monitoring` | **Development Correlation** | Correlate Claude Code usage with commit patterns, deployment efficiency |
| `code-development` | **Workflow Optimization** | Development efficiency analysis, tool selection optimization, session management |

### Multi-Skill Operation Examples

**Complete Development Productivity Analysis:**
1. `claude-code-history` - Analyze recent Claude Code usage patterns and performance metrics
2. `support-investigation` - Investigate any productivity issues or session problems
3. `serena-mcp` - Optimize code navigation workflows based on usage data
4. `datadog-management` - Monitor correlation between Claude Code usage and development velocity
5. `code-development` - Implement workflow improvements and tool selection optimization

**Complete Session Optimization Workflow:**
1. `claude-code-history` - Analyze session context management and tool usage effectiveness
2. `serena-mcp` - Identify opportunities for better semantic navigation patterns
3. `code-development` - Implement session management improvements
4. `claude-code-history` - Validate optimization effectiveness through follow-up analysis