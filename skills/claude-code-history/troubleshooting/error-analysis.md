## Troubleshooting and Error Analysis

### Error Pattern Detection

**Common error types and frequencies: **
```bash
jq -r 'select(.type == "error") | .error_type // .error_message[0:50]' \
  ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr
```

**Tool failure analysis:**
```bash
jq 'select(.type == "tool_use" and .success == false) |
  {tool: .tool_name, error: .error_message, timestamp}' \
  ~/.claude/projects/*/history.jsonl
```

### Session Recovery Analysis

**Sessions with recovery attempts:**
```bash
jq 'select(.type == "session_recovery" or .action == "retry")' \
  ~/.claude/projects/*/history.jsonl
```

**Context overflow incidents:**
```bash
jq 'select(.type == "context_overflow" or (.error_type == "context_limit"))' \
  ~/.claude/projects/*/history.jsonl
```

### MCP Server Issues

**MCP server connectivity problems:**
```bash
jq 'select(.type == "mcp_error" or (.error_message | contains("MCP")))' \
  ~/.claude/projects/*/history.jsonl
```

**Tool availability issues:**
```bash
jq 'select(.error_type == "tool_unavailable")' \
  ~/.claude/projects/*/history.jsonl |
  jq -r '.tool_name' | sort | uniq -c
```

### Advanced Error Analysis

**Error Correlation Analysis:**
```bash
# Find patterns in error sequences
jq -r '
  .sessions[] |
  select([.messages[] | select(.error)] | length > 1) |
  {
    session_id: .session_id,
    error_sequence: [.messages[] | select(.error) | {type: .error_type, tool: .tool_name, message: .error_message[0:50]}],
    recovery_actions: [.messages[] | select(.type == "recovery") | .action]
  }
' ~/.claude/projects/*/history.jsonl
```

**Tool-Specific Error Analysis:**
```bash
# Analyze errors by tool type
jq 'select(.type == "tool_use" and .success == false) |
  {tool: .tool_name, error_type: .error_type, timestamp}' \
  ~/.claude/projects/*/history.jsonl | \
jq -s 'group_by(.tool) | map({
  tool: .[0].tool,
  error_count: length,
  common_errors: (group_by(.error_type) | map({error: .[0].error_type, count: length}) | sort_by(-.count)[0:3])
})'
```

### Session Health Diagnostics

**Incomplete Session Detection:**
```bash
# Identify sessions that ended unexpectedly
jq -r '
  .sessions[] |
  select(.completed != true and (.messages | length) > 3) |
  {
    session_id: .session_id,
    duration: (.end_time - .start_time),
    message_count: (.messages | length),
    last_action: .messages[-1].type,
    potential_cause: (
      if .messages[-1].error then "error_termination"
      elif .context_used > (.context_available * 0.9) then "context_overflow"
      elif (.messages[-3:] | map(select(.tool_calls and .success == false)) | length) > 1 then "repeated_tool_failures"
      else "unknown"
      end
    )
  }
' ~/.claude/projects/*/history.jsonl
```

### Error Recovery Patterns

**Recovery Success Rate Analysis:**
```bash
# Analyze effectiveness of recovery strategies
jq -r '
  .sessions[] |
  select([.messages[] | select(.type == "error")] | length > 0) |
  {
    session_id: .session_id,
    error_count: [.messages[] | select(.error)] | length,
    recovery_attempts: [.messages[] | select(.type == "recovery" or .action == "retry")] | length,
    final_success: .completed
  }
' ~/.claude/projects/*/history.jsonl | \
jq -s 'group_by(.final_success) | map({
  outcome: (if .[0].final_success then "successful_recovery" else "failed_recovery" end),
  avg_errors: (map(.error_count) | add / length),
  avg_recovery_attempts: (map(.recovery_attempts) | add / length),
  count: length
})'
```

### Performance Impact of Errors

**Error Impact on Session Performance:**
```bash
# Measure performance impact of errors
jq -r '
  .sessions[] |
  {
    session_id: .session_id,
    has_errors: ([.messages[] | select(.error)] | length > 0),
    duration: (.end_time - .start_time),
    completion_rate: (if .completed then 1 else 0 end),
    context_efficiency: (.outcome_achieved / .context_used)
  }
' ~/.claude/projects/*/history.jsonl | \
jq -s 'group_by(.has_errors) | map({
  error_status: (if .[0].has_errors then "with_errors" else "error_free" end),
  avg_duration: (map(.duration) | add / length),
  completion_rate: (map(.completion_rate) | add / length),
  avg_context_efficiency: (map(.context_efficiency) | add / length),
  sample_size: length
})'
```

### Automated Error Monitoring

**Real-Time Error Detection:**
```bash
#!/bin/bash
# Error monitoring script for active sessions

monitor_session_errors() {
    local project_path="$1"
    local error_threshold=3

    # Check recent error rate
    recent_errors=$(jq -r '.sessions[-1].messages[-10:] | .[] | select(.error)' "$project_path/history.jsonl" | wc -l)

    if [[ $recent_errors -ge $error_threshold ]]; then
        echo "🚨 ERROR SPIKE DETECTED: $recent_errors errors in recent messages"

        # Analyze error patterns
        jq -r '.sessions[-1].messages[-10:] | .[] | select(.error) |
          {error_type: .error_type, tool: .tool_name, message: .error_message[0:100]}' \
          "$project_path/history.jsonl"

        # Suggest recovery actions
        echo "Suggested recovery actions:"
        echo "1. Check tool availability and permissions"
        echo "2. Verify MCP server connections"
        echo "3. Consider context reduction if approaching limits"
    fi
}
```

### Error Prevention Strategies

**Proactive Error Prevention:**
```bash
# Identify error-prone patterns before they occur
analyze_error_precursors() {
    jq -r '
      .sessions[] |
      select([.messages[] | select(.error)] | length > 0) |
      {
        pre_error_context: [.messages[] | select(.error) as $error |
          .messages | map(select(.timestamp < $error.timestamp)) | .[-3:]
        ],
        error_details: [.messages[] | select(.error)]
      }
    ' ~/.claude/projects/*/history.jsonl | \
    jq -s 'map(.pre_error_context[]) | group_by(.type) | map({
      pattern: .[0].type,
      frequency: length,
      associated_errors: [.[].error_type] | unique
    })'
}
```

### Error Reporting and Documentation

**Generate Error Summary Report:**
```bash
# Create comprehensive error analysis report
generate_error_report() {
    echo "=== Claude Code Error Analysis Report ==="
    echo "Generated: $(date)"
    echo ""

    # Overall error statistics
    total_sessions=$(jq -r '.sessions[]' ~/.claude/projects/*/history.jsonl | wc -l)
    sessions_with_errors=$(jq -r '.sessions[] | select([.messages[] | select(.error)] | length > 0)' ~/.claude/projects/*/history.jsonl | wc -l)
    error_rate=$(echo "scale=2; $sessions_with_errors * 100 / $total_sessions" | bc)

    echo "Total Sessions: $total_sessions"
    echo "Sessions with Errors: $sessions_with_errors"
    echo "Error Rate: ${error_rate}%"
    echo ""

    # Most common errors
    echo "Most Common Errors:"
    jq -r 'select(.type == "error") | .error_type // .error_message[0:50]' \
      ~/.claude/projects/*/history.jsonl | sort | uniq -c | sort -nr | head -5

    echo ""

    # Tool failure rates
    echo "Tool Failure Analysis:"
    jq 'select(.type == "tool_use") | {tool: .tool_name, success: .success}' \
      ~/.claude/projects/*/history.jsonl | \
    jq -s 'group_by(.tool) | map({
      tool: .[0].tool,
      total_uses: length,
      failures: (map(select(.success == false)) | length),
      failure_rate: ((map(select(.success == false)) | length) / length * 100)
    }) | sort_by(-.failure_rate)[0:5] | .[] |
    "\(.tool): \(.failures)/\(.total_uses) failures (\(.failure_rate | floor)%)"'
}
```

### Quality Assurance Integration

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

### Troubleshooting Session Issues

**Common troubleshooting commands:**
```bash
# Investigate recent problems
claude-code-history analysis_type=troubleshooting timeframe=today

# Analyze specific error patterns
jq 'select(.error_type == "timeout")' ~/.claude/projects/*/history.jsonl

# Check MCP server connectivity
jq 'select(.type == "mcp_error")' ~/.claude/projects/*/history.jsonl | head -10
```