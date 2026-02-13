## Quick Reference

### Essential Commands

**Daily Health Check:**
```bash
# Quick session overview
find ~/.claude/projects -name "*.jsonl" -newermt "1 day ago" | wc -l

# Most used tools today
jq -r 'select(.type == "tool_use" and .timestamp > (now - 24*3600)) | .tool_name' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr | head -3

# Performance summary
jq '.session_stats // .performance_metrics' ~/.claude/stats-cache.json
```

**Common jq Queries:**
```bash
# Session metadata
jq -r '.timestamp, .type, .content[0:100]' ~/.claude/projects/*/history.jsonl

# Tool usage frequency
jq -r 'select(.type == "tool_use") | .tool_name' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr

# Error analysis
jq 'select(.type == "error")' ~/.claude/projects/*/history.jsonl

# Context usage patterns
jq 'select(.context_length > 30000)' ~/.claude/projects/*/history.jsonl
```

### Analysis Types Quick Guide

| Type | Purpose | Key Output |
|------|---------|------------|
| `session-analysis` | Session patterns and flows | Conversation summaries, interaction patterns |
| `usage-patterns` | Tool usage and efficiency | Frequency analysis, workflow optimization |
| `performance-optimization` | Context and token analysis | Performance bottlenecks, recommendations |
| `troubleshooting` | Error investigation | Error patterns, resolution guidance |
| `token-usage` | Cost optimization | Token metrics, efficiency scoring |

### File Locations

**Claude Code Data Structure:**
```
~/.claude/
├── projects/
│   ├── project-name/
│   │   ├── history.jsonl          # Session logs
│   │   └── settings.local.json    # Project settings
│   └── .../
├── stats-cache.json               # Performance metrics
└── mcp_servers/                   # MCP configurations
```

### FUB Project Patterns

**Common FUB Projects:**
- `fub` - Main FUB application
- `fub-spa` - Frontend application
- `pegasus` - Integration services
- `mutagen` - Development tools

**FUB-Specific Analysis:**
```bash
# Analyze FUB project usage
for project in fub fub-spa pegasus mutagen; do
  find ~/.claude/projects -name "*$project*" -name "*.jsonl" |
    xargs jq -r 'select(.type == "tool_use") | .tool_name' |
    sort | uniq -c | sort -nr | head -3
done

# Integration skill usage
grep -r "serena-mcp\|datadog-management\|gitlab-pipeline" \
  ~/.claude/projects/*/history.jsonl | wc -l
```

### Troubleshooting Quick Checks

**Common Issues:**
1. **No data found**: Check if ~/.claude/ directory exists
2. **jq errors**: Verify jq installation (`brew install jq`)
3. **Permission denied**: Check file permissions on ~/.claude/
4. **Empty results**: Verify Claude Code has been used recently
5. **Corrupted data**: Check file integrity with `file ~/.claude/projects/*/history.jsonl`

**Validation Commands:**
```bash
# Verify Claude Code installation
ls -la ~/.claude/

# Check data availability
find ~/.claude -name "*.jsonl" -o -name "stats-cache.json"

# Test jq functionality
echo '{"test": "value"}' | jq '.test'

# Validate file format
head -1 ~/.claude/projects/*/history.jsonl | jq '.'
```

### Performance Optimization Quick Wins

**Context Optimization:**
```bash
# Find high-context sessions
jq 'select(.context_length > 50000)' ~/.claude/projects/*/history.jsonl

# Identify context bloat patterns
jq 'select(.context_used / .context_available > 0.8)' ~/.claude/projects/*/history.jsonl
```

**Tool Efficiency:**
```bash
# Find redundant tool usage
jq -r 'select(.type == "tool_use") | .tool_name + " " + (.timestamp | tostring)' \
  ~/.claude/projects/*/history.jsonl | \
  awk 'NR>1 && $1==prev_tool && $2-prev_time<60 {print "Redundant:", $1}'
```

### Integration Patterns

**Cross-Skill Workflows:**
```bash
# Performance → Support Investigation
claude-code-history --analysis_type="troubleshooting" | \
  support-investigation --issue="session-performance"

# Usage → Serena Optimization
claude-code-history --analysis_type="usage-patterns" --focus="serena" | \
  serena-mcp --task="optimize-navigation"

# History → Development Optimization
claude-code-history --analysis_type="performance-optimization" | \
  code-development --task="workflow-improvement"
```

### Emergency Diagnostics

**Critical Session Issues:**
```bash
# Recent failures
jq 'select(.type == "error" and .timestamp > (now - 24*3600))' \
  ~/.claude/projects/*/history.jsonl

# Context overflow incidents
jq 'select(.error_type == "context_limit")' ~/.claude/projects/*/history.jsonl

# MCP connectivity issues
jq 'select(.error_message | contains("MCP"))' ~/.claude/projects/*/history.jsonl
```

**System Health:**
```bash
# Session completion rates
jq -r 'select(.type == "session_end") | .completed' \
  ~/.claude/projects/*/history.jsonl | \
  awk '{total++; if($1=="true") success++} END{print success/total*100 "% completion rate"}'

# Average session duration
jq -r 'select(.type == "session_end") | .duration' \
  ~/.claude/projects/*/history.jsonl | \
  awk '{sum+=$1; count++} END{print sum/count/60 " minutes average"}'
```