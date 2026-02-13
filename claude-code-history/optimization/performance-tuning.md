## Performance Analysis and Optimization

### Stats Cache Analysis

**Extract performance metrics from stats-cache.json:**
```bash
jq '.session_stats // .performance_metrics // .' ~/.claude/stats-cache.json
```

**Token usage analysis:**
```bash
jq '.token_usage | {total_tokens, avg_per_session, cost_estimate}' \
  ~/.claude/stats-cache.json
```

**Context length and efficiency metrics:**
```bash
jq '.context_metrics | {avg_context_length, max_context, efficiency_score}' \
  ~/.claude/stats-cache.json
```

### Session Performance Patterns

**Sessions with high token usage:**
```bash
jq 'select(.token_count > 10000) | {timestamp, project, token_count}' \
  ~/.claude/projects/*/history.jsonl | sort -k3 -nr
```

**Context management efficiency:**
```bash
jq 'select(.type == "context_management") |
  {action: .action, tokens_saved: .tokens_saved}' \
  ~/.claude/projects/*/history.jsonl |
  jq -s 'map(.tokens_saved) | add'
```

### Tool Performance Analysis

**Tool execution time analysis:**
```bash
jq 'select(.type == "tool_use") |
  {tool: .tool_name, duration: .duration_ms, success: .success}' \
  ~/.claude/projects/*/history.jsonl |
  jq -s 'group_by(.tool) | map({
    tool: .[0].tool,
    avg_duration: (map(.duration) | add / length),
    success_rate: (map(select(.success == true)) | length / length)
  })'
```

### Context Management Optimization

**Identify sessions needing context optimization:**
```bash
jq 'select(.context_length > 50000) |
  {project, timestamp, context_length, tools_used: [.tools[]]}' \
  ~/.claude/projects/*/history.jsonl
```

**Suggest context reduction strategies:**
```bash
echo "Context Optimization Recommendations:"
echo "1. Sessions with high context usage"
echo "2. Patterns leading to context bloat"
echo "3. Tool sequences causing inefficiency"
```

### Advanced Performance Monitoring

**Real-Time Session Monitoring Script:**
```bash
#!/bin/bash
# ~/.claude/scripts/session-monitor.sh

WATCH_INTERVAL=30
CONTEXT_THRESHOLD=0.85
TOOL_SWITCH_THRESHOLD=5

while true; do
    current_session=$(jq -r '.sessions[-1] |
      {
        context_usage: (.context_used / .context_available),
        tool_switches: [.messages[-10:] | .[] | select(.tool_calls) | .tool_calls[].tool_name] | length,
        recent_errors: [.messages[-5:] | .[] | select(.error)] | length
      }
    ' ~/.claude/projects/$(basename $(pwd))/history.jsonl 2>/dev/null)

    echo "$(date): Session Health Check"
    echo "$current_session" | jq -r '
      if .context_usage > 0.85 then "⚠️  Context usage high: \(.context_usage * 100 | floor)%" else "✅ Context usage OK" end,
      if .tool_switches > 5 then "⚠️  High tool switching: \(.tool_switches) recent switches" else "✅ Tool usage efficient" end,
      if .recent_errors > 0 then "🚨 Recent errors detected: \(.recent_errors)" else "✅ No recent errors" end
    '

    sleep $WATCH_INTERVAL
done
```

### Performance Alerting System

**Performance threshold monitoring:**
```bash
# Monitor critical performance metrics
check_performance_thresholds() {
    local project_path="$1"

    # Context usage warning
    context_usage=$(jq -r '.sessions[-1].context_used / .sessions[-1].context_available' "$project_path/history.jsonl")
    if (( $(echo "$context_usage > 0.8" | bc -l) )); then
        echo "🚨 HIGH CONTEXT USAGE: ${context_usage}% in current session"
    fi

    # Tool switching efficiency
    recent_tools=$(jq -r '.sessions[-1].messages[-10:] | .[] | select(.tool_calls) | .tool_calls[].tool_name' "$project_path/history.jsonl" | wc -l)
    if [[ $recent_tools -gt 8 ]]; then
        echo "⚠️  HIGH TOOL SWITCHING: $recent_tools tools in recent messages"
    fi

    # Error rate monitoring
    recent_errors=$(jq -r '.sessions[-1].messages[-5:] | .[] | select(.error)' "$project_path/history.jsonl" | wc -l)
    if [[ $recent_errors -gt 1 ]]; then
        echo "🚨 ERROR SPIKE: $recent_errors errors in recent messages"
    fi
}
```

### Token Optimization Strategies

**Token Usage Optimization Analysis:**
```bash
# Identify token-heavy operations
jq -r '
  .sessions[] |
  select(.token_count > 5000) |
  {
    session_id: .session_id,
    token_count: .token_count,
    message_count: (.messages | length),
    tokens_per_message: (.token_count / (.messages | length)),
    primary_operations: [.messages[] | select(.tool_calls) | .tool_calls[].tool_name] | unique
  }
' ~/.claude/projects/*/history.jsonl | \
jq -s 'sort_by(-.tokens_per_message)[0:10]'
```

**Context Efficiency Scoring:**
```bash
# Calculate context efficiency scores
jq -r '
  .sessions[] |
  select(.context_used and .outcome_achieved) |
  {
    session_id: .session_id,
    context_efficiency: (.outcome_achieved / .context_used),
    context_used: .context_used,
    tools_used: [.messages[] | select(.tool_calls) | .tool_calls[].tool_name] | length
  } |
  select(.context_efficiency < 0.3)  # Flag inefficient sessions
' ~/.claude/projects/*/history.jsonl
```

### Automated Performance Optimization

**Performance-Based Recommendations Engine:**
```bash
# Generate automated optimization recommendations
generate_optimization_recommendations() {
    local project_path="$1"

    echo "=== Performance Optimization Recommendations ==="

    # Analyze recent performance trends
    recent_performance=$(jq -r '
      .sessions[-10:] |
      {
        avg_context_usage: (map(.context_used / .context_available) | add / length),
        avg_tools_per_session: (map([.messages[] | select(.tool_calls)] | length) | add / length),
        error_rate: (map([.messages[] | select(.error)] | length) | add) / (map(.messages | length) | add),
        completion_rate: (map(select(.completed)) | length) / length
      }
    ' "$project_path/history.jsonl")

    echo "$recent_performance" | jq -r '
      if .avg_context_usage > 0.7 then "📊 Reduce context usage: Currently at \(.avg_context_usage * 100 | floor)% average" else empty end,
      if .avg_tools_per_session > 15 then "🛠️  Optimize tool selection: Average \(.avg_tools_per_session | floor) tools per session" else empty end,
      if .error_rate > 0.1 then "🚨 Improve error handling: \(.error_rate * 100 | floor)% error rate" else empty end,
      if .completion_rate < 0.8 then "✅ Increase completion rate: Currently \(.completion_rate * 100 | floor)%" else empty end
    '
}
```

### Performance Benchmarking

**Establish Performance Baselines:**
```bash
# Create performance baseline metrics
create_performance_baseline() {
    echo "=== Claude Code Performance Baseline ==="

    # Overall statistics
    total_sessions=$(find ~/.claude/projects -name "*.jsonl" | xargs jq -r '.sessions[]' | wc -l)
    avg_session_length=$(jq -r '.sessions[] | .messages | length' ~/.claude/projects/*/history.jsonl | awk '{sum+=$1} END{print sum/NR}')

    echo "Total Sessions: $total_sessions"
    echo "Average Session Length: $(printf "%.1f" $avg_session_length) messages"

    # Tool efficiency metrics
    echo "Top Performing Tools (by success rate):"
    jq 'select(.type == "tool_use") | {tool: .tool_name, success: .success}' ~/.claude/projects/*/history.jsonl | \
    jq -s 'group_by(.tool) | map({
        tool: .[0].tool,
        total: length,
        success_rate: (map(select(.success == true)) | length) / length
    }) | sort_by(-.success_rate)[0:5] | .[] | "\(.tool): \(.success_rate * 100 | floor)% (\(.total) uses)"'

    # Context efficiency benchmark
    avg_context_efficiency=$(jq -r '.sessions[] | select(.context_used and .outcome_achieved) | .outcome_achieved / .context_used' ~/.claude/projects/*/history.jsonl | awk '{sum+=$1; count++} END{print sum/count}')
    echo "Average Context Efficiency: $(printf "%.3f" $avg_context_efficiency)"
}
```

### Integration with Development Workflow

**Session Optimization Recommendations:**
1. **High Token Usage Sessions**: Identify patterns causing context bloat
2. **Tool Efficiency**: Recommend alternative tool combinations
3. **Error Reduction**: Address common failure patterns
4. **Workflow Streamlining**: Suggest skill combinations for common tasks

### Continuous Performance Monitoring

**Automated Performance Reports:**
```bash
# Weekly performance summary
generate_weekly_performance_report() {
    echo "=== Weekly Claude Code Performance Report ==="
    echo "Report Period: $(date -d '7 days ago' '+%Y-%m-%d') to $(date '+%Y-%m-%d')"

    # Performance trends
    echo "Performance Trends:"
    jq -r '
      .sessions[] |
      select(.timestamp > (now - 7*24*3600)) |
      {
        date: (.timestamp | strftime("%Y-%m-%d")),
        context_efficiency: (.outcome_achieved / .context_used),
        completion_status: .completed
      }
    ' ~/.claude/projects/*/history.jsonl | \
    jq -s 'group_by(.date) | map({
      date: .[0].date,
      avg_efficiency: (map(.context_efficiency) | add / length),
      completion_rate: (map(select(.completion_status == true)) | length) / length
    })'
}
```