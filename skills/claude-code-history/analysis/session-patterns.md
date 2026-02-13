## Session Analysis Patterns

### Basic Session Overview

**Count total sessions across all projects:**
```bash
find ~/.claude/projects -name "*.jsonl" | xargs wc -l | tail -1
```

**Recent session activity (last 7 days):**
```bash
find ~/.claude/projects -name "*.jsonl" -newermt "7 days ago" |
  xargs grep -l "timestamp" | wc -l
```

### Session Content Analysis with jq

**Extract session metadata:**
```bash
jq -r '.timestamp, .type, .content[0:100]' ~/.claude/projects/*/history.jsonl |
  head -20
```

**Find sessions with specific tools or errors:**
```bash
jq 'select(.type == "tool_use") | {timestamp, tool: .tool_name}' \
  ~/.claude/projects/*/history.jsonl
```

**Session duration and message count analysis:**
```bash
jq -r '[.timestamp] | group_by(.[0:10]) | map({date: .[0][0:10], count: length})' \
  ~/.claude/projects/*/history.jsonl
```

### Conversation Flow Analysis

**Identify conversation patterns:**
```bash
jq -r 'select(.type == "human_message" or .type == "assistant_message") |
  {type: .type, length: (.content | length), timestamp}' \
  ~/.claude/projects/*/history.jsonl | head -10
```

**Find incomplete or failed conversations:**
```bash
jq 'select(.type == "error" or .type == "timeout")' \
  ~/.claude/projects/*/history.jsonl
```

### Complex Multi-Session Performance Analysis

**Analyze performance trends across multiple sessions:**
```bash
jq -r '
  .sessions[] |
  select(.timestamp > (now - 7*24*3600)) |
  {
    session_id: .session_id,
    duration: .end_time - .start_time,
    tool_count: (.messages[] | select(.tool_calls) | length),
    context_efficiency: (.context_used / .context_available),
    completion_rate: (if .completed then 1 else 0 end)
  }
' ~/.claude/projects/*/history.jsonl | \
jq -s 'group_by(.completion_rate) |
  map({
    completion_status: (if .[0].completion_rate == 1 then "completed" else "incomplete" end),
    avg_duration: (map(.duration) | add / length),
    avg_context_efficiency: (map(.context_efficiency) | add / length),
    count: length
  })'
```

### Session Context Management Analysis

**Analyze context bloat patterns and optimization opportunities:**
```bash
jq -r '
  .sessions[] |
  select(.messages | length > 10) |
  {
    session_id: .session_id,
    message_count: (.messages | length),
    context_growth: [
      .messages[] |
      select(.context_used) |
      .context_used
    ],
    tool_diversity: [.messages[] | select(.tool_calls) | .tool_calls[].tool_name] | unique | length,
    efficiency_score: (.outcome_achieved / .context_used)
  } |
  select(.efficiency_score < 0.5)  # Identify inefficient sessions
' ~/.claude/projects/*/history.jsonl
```

### FUB-Specific Analysis Patterns

**Analyze FUB-specific tool usage:**
```bash
for project in fub fub-spa pegasus mutagen; do
  if [[ -d ~/.claude/projects/*$project* ]]; then
    echo "=== $project Analysis ==="
    find ~/.claude/projects -name "*$project*" -name "*.jsonl" |
      xargs jq -r 'select(.type == "tool_use") | .tool_name' |
      sort | uniq -c | sort -nr | head -5
  fi
done
```

**Development Workflow Analysis:**
```bash
# Common FUB development patterns
jq -r 'select(.type == "tool_use" and (.project | contains("fub"))) |
  .tool_name + " -> " + (.content | tostring)[0:50]' \
  ~/.claude/projects/*/history.jsonl | head -10

# Integration between Claude Code skills
grep -r "serena-mcp\|gitlab-pipeline-monitoring\|datadog-management" \
  ~/.claude/projects/*/history.jsonl | wc -l
```

### Cross-Project Performance Comparison

**Multi-Project Productivity Analysis:**
```bash
for project in ~/.claude/projects/*/; do
  project_name=$(basename "$project")
  echo "=== $project_name ==="
  jq -r --arg proj "$project_name" '
    {
      project: $proj,
      total_sessions: (.sessions | length),
      avg_session_duration: ((.sessions[] | .end_time - .start_time) | add / length),
      completion_rate: ((.sessions[] | select(.completed)) | length) / (.sessions | length),
      primary_tools: [.sessions[].messages[] | select(.tool_calls) | .tool_calls[].tool_name] |
                     group_by(.) | map({tool: .[0], count: length}) | sort_by(-.count)[0:3]
    }
  ' "$project/history.jsonl" 2>/dev/null
done | jq -s 'sort_by(-.completion_rate)'
```

### Weekly Performance Reports

**Create weekly performance reports:**
```bash
echo "=== Weekly Claude Code Performance Report ==="
echo "Date Range: $(date -d '7 days ago' '+%Y-%m-%d') to $(date '+%Y-%m-%d')"

# Sessions this week
find ~/.claude/projects -name "*.jsonl" -newermt "7 days ago" |
  xargs jq -r 'select(.timestamp > (now - 7*24*60*60))' | wc -l

# Top tools this week
find ~/.claude/projects -name "*.jsonl" -newermt "7 days ago" |
  xargs jq -r 'select(.type == "tool_use" and .timestamp > (now - 7*24*60*60)) | .tool_name' |
  sort | uniq -c | sort -nr | head -5
```