## Usage Pattern Extraction

### Tool Usage Frequency Analysis

**Most frequently used tools:**
```bash
jq -r 'select(.type == "tool_use") | .tool_name' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr
```

**Tool usage by project:**
```bash
find ~/.claude/projects -name "*.jsonl" -exec basename {} \; -exec \
  jq -r 'select(.type == "tool_use") | .tool_name' {} \; |
  paste - - | sort | uniq -c
```

### Workflow Pattern Detection

**Common tool sequences (workflow chains):**
```bash
jq -r 'select(.type == "tool_use") | .tool_name' \
  ~/.claude/projects/*/history.jsonl |
  awk 'BEGIN{prev=""} {if(prev) print prev "->" $0; prev=$0}' |
  sort | uniq -c | sort -nr | head -20
```

**Session complexity analysis (tools per session):**
```bash
jq -r 'select(.type == "tool_use") | .session_id + " " + .tool_name' \
  ~/.claude/projects/*/history.jsonl |
  awk '{count[$1]++} END{for(i in count) print count[i], i}' |
  sort -nr
```

### Project-Specific Usage Patterns

**Tool usage by project type:**
```bash
for project in ~/.claude/projects/*/; do
  echo "Project: $(basename "$project")"
  jq -r 'select(.type == "tool_use") | .tool_name' "$project/history.jsonl" |
    sort | uniq -c | head -5
  echo "---"
done
```

### Advanced Tool Usage Pattern Analysis

**Identify tool usage optimization opportunities:**
```bash
jq -r '
  [.sessions[].messages[] | select(.tool_calls) | .tool_calls[]] |
  group_by(.tool_name) |
  map({
    tool: .[0].tool_name,
    usage_count: length,
    avg_duration: (map(.duration // 0) | add / length),
    success_rate: (map(select(.status == "success")) | length) / length,
    common_patterns: (group_by(.parameters) | map({params: .[0].parameters, freq: length}) | sort_by(-.freq)[0:3])
  }) |
  sort_by(-.usage_count)
' ~/.claude/projects/*/history.jsonl
```

### Skill Usage Analytics

**Most Effective Skills for FUB:**
```bash
# Skill invocation success rates
jq 'select(.type == "skill_invocation") |
  {skill: .skill_name, success: .completed_successfully, duration: .duration_ms}' \
  ~/.claude/projects/*/history.jsonl |
  jq -s 'group_by(.skill) | map({
    skill: .[0].skill,
    total_uses: length,
    success_rate: (map(select(.success == true)) | length / length),
    avg_duration: (map(.duration) | add / length)
  }) | sort_by(-.success_rate)'
```

### Tool Usage Optimization

**Identify redundant tool usage patterns:**
```bash
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

### Project-Specific Optimization Recommendations

**Generate optimization recommendations per project:**
```bash
jq -r '
  .sessions[] |
  {
    project: input_filename | split("/")[-2],
    session_patterns: {
      frequent_restarts: (if (.messages | length) < 5 then 1 else 0 end),
      context_overflow: (if .context_used > (.context_available * 0.9) then 1 else 0 end),
      tool_switching: ([.messages[] | select(.tool_calls) | .tool_calls[].tool_name] | length),
      error_recovery: ([.messages[] | select(.error)] | length)
    }
  } |
  .session_patterns
' ~/.claude/projects/*/history.jsonl | \
jq -s 'group_by(.project) |
  map({
    project: .[0].project,
    optimization_opportunities: {
      reduce_context_bloat: (map(.context_overflow) | add) > (length * 0.3),
      minimize_tool_switching: (map(.tool_switching) | add / length) > 5,
      improve_error_handling: (map(.error_recovery) | add) > 0
    },
    recommendations: [
      (if (map(.context_overflow) | add) > (length * 0.3) then "Implement progressive context loading" else empty end),
      (if (map(.tool_switching) | add / length) > 5 then "Use more focused tool selection" else empty end),
      (if (map(.error_recovery) | add) > 0 then "Improve error handling patterns" else empty end)
    ]
  })'
```

### Common Usage Pattern Analysis

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

**Project-Specific Analysis:**
```bash
# Focus on specific project
claude-code-history analysis_type=session-analysis project=fub
```

### Workflow Efficiency Metrics

**Performance Benchmarking:**
```bash
# Generate performance baseline metrics
echo "=== Claude Code Performance Summary ==="
echo "Total Sessions: $(find ~/.claude/projects -name "*.jsonl" | xargs wc -l | tail -1 | awk '{print $1}')"
echo "Active Projects: $(ls ~/.claude/projects | wc -l)"
echo "Average Tools/Session: $(jq -r 'select(.type == "tool_use")' ~/.claude/projects/*/history.jsonl | wc -l)"
echo "Most Used Tools:"
jq -r 'select(.type == "tool_use") | .tool_name' ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr | head -5
```

### Continuous Improvement Process

**Based on Analysis Results:**
1. **High Token Usage Sessions**: Identify patterns causing context bloat
2. **Tool Efficiency**: Recommend alternative tool combinations
3. **Error Reduction**: Address common failure patterns
4. **Workflow Streamlining**: Suggest skill combinations for common tasks