# Evidence Evaluation Framework

## Overview

Evidence evaluation provides systematic credibility assessment and bias detection for software investigation findings. Not all evidence is created equal - metrics carry more weight than anecdotes, and multiple independent sources are more reliable than single-source conclusions.

## Evidence Credibility Scale

### 10/10 - Direct Measurement (Critical Weight)
**Database queries, system metrics, performance counters**

- Direct quantitative measurement
- Machine-generated, minimal human interpretation
- Immediately reproducible
- High precision and accuracy

**Examples**:
```sql
-- Database connection pool exhaustion
SELECT CURRENT_CONNECTIONS, MAX_CONNECTIONS
FROM INFORMATION_SCHEMA.SESSION_STATUS;

-- API response time degradation
SELECT AVG(response_time_ms), COUNT(*)
FROM api_metrics
WHERE endpoint = '/payment' AND timestamp > '2024-01-15 14:00';
```

**Quality Indicators**:
- Query results are deterministic
- Metrics collected automatically
- No subjective interpretation required

### 9/10 - Structured Logs (Critical Weight)
**Application logs with structured format, error tracking systems**

- Programmatically generated
- Consistent format and content
- Timestamped and contextualized
- Minimal ambiguity

**Examples**:
```json
// Application error log
{
  "timestamp": "2024-01-15T14:30:15Z",
  "level": "ERROR",
  "service": "payment-processor",
  "error": "ConnectionTimeoutException",
  "context": {
    "account_id": "12345",
    "correlation_id": "abc-def-123",
    "duration_ms": 30000
  }
}
```

**Quality Indicators**:
- Machine-readable format
- Automatic timestamp correlation
- Contextual metadata included

### 8/10 - System Logs (High Weight)
**Operating system logs, infrastructure monitoring, network logs**

- System-generated events
- Standard formats (syslog, etc.)
- Good temporal accuracy
- Some interpretation required

**Examples**:
```
// System resource exhaustion
Jan 15 14:30:15 web01 kernel: Out of memory: Kill process 1234 (java)

// Network connectivity
Jan 15 14:30:16 web01 NetworkManager: Connection lost to database.internal
```

**Quality Indicators**:
- OS or infrastructure generated
- Standard log formats
- Clear event descriptions

### 7/10 - Code Analysis (High Weight)
**Static analysis, code review findings, configuration analysis**

- Logical analysis of source code
- Configuration and deployment analysis
- Reproducible analysis process
- Subject to interpretation

**Examples**:
```python
# Database connection pool configuration
DB_POOL_SIZE = 10  # Potential bottleneck for high load

# Recent changes analysis
git log --since="2024-01-15" --oneline services/payment/
```

**Quality Indicators**:
- Analysis methodology documented
- Findings reproducible by others
- Clear connection to observed behavior

### 6/10 - User Reports (Medium Weight)
**Support tickets, user feedback, error reports**

- Direct user experience data
- Human interpretation involved
- May contain useful context
- Subject to reporting bias

**Examples**:
```
User Report: "Payment failed at checkout around 2:30 PM.
Got timeout error after waiting ~30 seconds."

Support Ticket: "Multiple users reporting payment issues
starting this afternoon. Error message mentions connection timeout."
```

**Quality Indicators**:
- Consistent reports across multiple users
- Specific error messages included
- Timeline correlation with other evidence

### 5/10 - Timeline Correlation (Medium Weight)
**Event timing analysis, deployment correlation**

- Circumstantial evidence based on timing
- Requires careful correlation analysis
- Useful for narrowing hypotheses
- Can be misleading (correlation ≠ causation)

**Examples**:
```
Timeline Analysis:
- 14:25 UTC: Payment service deployment completed
- 14:30 UTC: Error rate spike began
- 14:35 UTC: User reports started arriving

Correlation: 5-minute delay suggests deployment-related issue
```

**Quality Indicators**:
- Precise timestamps available
- Multiple correlated events
- Reasonable causal mechanism

### 4/10 - Performance Trends (Medium Weight)
**Historical data analysis, trend identification**

- Long-term pattern analysis
- Useful for context and baselines
- May not reflect current state
- Requires careful interpretation

**Examples**:
```
Performance Trend Analysis:
- Database connections trending upward over 30 days
- Response times gradually degrading since last month
- Error rate baseline vs current spike comparison
```

**Quality Indicators**:
- Sufficient historical data
- Clear trend analysis methodology
- Relevance to current issue established

### 3/10 - Anecdotal Evidence (Low Weight)
**Individual observations, informal reports**

- Single-person observations
- Highly subjective interpretation
- Difficult to verify
- May contain useful insights despite low reliability

**Examples**:
```
Developer Report: "I noticed the app seemed slower yesterday"
Team Member: "I think this might be related to the database change"
Informal Observation: "Users on Slack are complaining about timeouts"
```

**Quality Indicators**:
- Multiple independent anecdotal reports
- Specific rather than general observations
- From credible sources with relevant expertise

### 2/10 - Speculation (Very Low Weight)
**Hypotheses without supporting evidence**

- Educated guesses based on experience
- No direct supporting evidence
- May be useful for hypothesis generation
- Should not influence conclusions directly

### 1/10 - Hearsay (Very Low Weight)
**Third-hand reports, rumors**

- Information passed through multiple people
- No direct verification possible
- High potential for distortion
- Generally not useful for investigation

## Evidence Collection Best Practices

### 1. Multi-Source Validation
Require evidence from at least 3 independent sources before drawing conclusions.

```bash
# Example: Payment timeout investigation
collect_evidence "database" "Connection pool at 95% capacity" "10/10" "h1"
collect_evidence "logs" "ConnectionTimeout exceptions in payment service" "9/10" "h1"
collect_evidence "monitoring" "Response time spike at 14:30 UTC" "10/10" "h1"
collect_evidence "users" "Multiple timeout reports starting 14:30" "6/10" "h1"

# Evidence supports h1 (database timeout) with high confidence
```

### 2. Evidence Independence
Ensure evidence sources are truly independent to avoid correlated errors.

**Independent Sources**:
- Database metrics + Application logs + User reports
- Multiple monitoring systems
- Different team member observations

**Non-Independent Sources** (Use Cautiously):
- Different views of same database
- Related application components
- Reports from same user or team

### 3. Temporal Validation
Verify evidence timing aligns with issue timeline.

```bash
# Temporal correlation check
echo "Issue Timeline: 2024-01-15 14:30 UTC"
echo "Database spike: 2024-01-15 14:30 UTC - MATCH"
echo "User reports: 2024-01-15 14:35 UTC - 5min delay, reasonable"
echo "Code deploy: 2024-01-15 10:00 UTC - 4.5hr earlier, unlikely cause"
```

### 4. Evidence Preservation
Document evidence with sufficient detail for independent verification.

```markdown
## Evidence Documentation Template

**Source**: Database Monitoring
**Evidence**: Connection pool utilization at 95% capacity
**Credibility**: 10/10 (Direct measurement)
**Timestamp**: 2024-01-15 14:30:15 UTC
**Query/Method**:
```sql
SELECT
  VARIABLE_NAME,
  VARIABLE_VALUE
FROM INFORMATION_SCHEMA.GLOBAL_STATUS
WHERE VARIABLE_NAME LIKE 'Threads_connected%';
```
**Supporting Data**: [Screenshot/export attached]
**Verification**: Reproducible by querying same metrics
**Context**: Occurred during payment processing error spike
```

## Bias Detection and Mitigation

### 1. Confirmation Bias
**Problem**: Only collecting evidence that supports preferred hypothesis.

**Detection**:
- Evidence all supports same hypothesis
- No contradictory evidence documented
- Rapid conclusion without alternatives testing

**Mitigation**:
```bash
# Mandatory contradictory evidence collection
collect_evidence "monitoring" "CPU usage remained normal" "9/10" "" "h1"
collect_evidence "network" "No connection errors to external APIs" "8/10" "" "h2"
```

### 2. Availability Bias
**Problem**: Overweighting recent or memorable evidence.

**Detection**:
- Emphasis on most recent events
- Ignoring historical patterns
- Overweighting dramatic events

**Mitigation**:
- Systematic historical baseline comparison
- Weight evidence by credibility, not recency
- Document patterns over time

### 3. Anchoring Bias
**Problem**: First evidence encountered influences all subsequent evaluation.

**Detection**:
- Early hypothesis never questioned
- New evidence interpreted to fit initial impression
- Confidence remains high despite contradictory evidence

**Mitigation**:
- Generate multiple hypotheses before evidence collection
- Blind evaluation when possible
- Regular hypothesis probability updates

### 4. Correlation Confusion
**Problem**: Assuming correlation implies causation.

**Detection**:
- Timeline correlation treated as causal evidence
- No mechanism explanation for correlation
- Alternative explanations not considered

**Mitigation**:
- Require causal mechanism explanation
- Test correlation with controlled experiments
- Consider common cause alternatives

## Evidence Weighting Calculations

### Simple Weighted Average
```bash
# Calculate evidence-weighted confidence
calculate_weighted_confidence() {
    local total_weight=0
    local weighted_sum=0

    # Evidence scores: (credibility * supports_hypothesis)
    # Database: 10/10 credibility, strongly supports (1.0)
    weighted_sum=$(echo "$weighted_sum + 10 * 1.0" | bc)
    total_weight=$(echo "$total_weight + 10" | bc)

    # Logs: 9/10 credibility, strongly supports (1.0)
    weighted_sum=$(echo "$weighted_sum + 9 * 1.0" | bc)
    total_weight=$(echo "$total_weight + 9" | bc)

    # Users: 6/10 credibility, moderately supports (0.8)
    weighted_sum=$(echo "$weighted_sum + 6 * 0.8" | bc)
    total_weight=$(echo "$total_weight + 6" | bc)

    # Calculate weighted average
    local confidence=$(echo "scale=1; $weighted_sum / $total_weight * 100" | bc)
    echo "Weighted confidence: ${confidence}%"
}
```

### Evidence Diversity Index
```bash
# Calculate evidence source diversity
calculate_diversity() {
    local sources=("database" "logs" "monitoring" "users" "code")
    local unique_sources=$(echo "${sources[@]}" | tr ' ' '\n' | sort -u | wc -l)
    local diversity_score=$(echo "scale=1; $unique_sources / 5 * 100" | bc)
    echo "Evidence diversity: ${diversity_score}% (${unique_sources}/5 source types)"
}
```

## Quality Assurance Checklist

### Evidence Collection
- [ ] Minimum 3 independent evidence sources
- [ ] Evidence credibility scores assigned
- [ ] Temporal correlation verified
- [ ] Contradictory evidence actively sought
- [ ] Evidence preservation with reproduction steps

### Bias Mitigation
- [ ] Multiple hypotheses considered
- [ ] Confirmation bias check performed
- [ ] Historical context included
- [ ] Independent review when possible
- [ ] Common cause alternatives evaluated

### Statistical Validation
- [ ] Evidence weights calculated
- [ ] Confidence intervals provided
- [ ] Source diversity index computed
- [ ] Uncertainty quantified
- [ ] Validation criteria pre-specified

## Integration Examples

### Support Investigation Enhancement
```bash
# Enhanced evidence collection in support investigation
source ~/.claude/skills/scientific-method-framework/scripts/core-functions.sh

init_scientific_investigation "ZYN-10585: Payment failures"

# Systematic evidence collection with credibility scoring
collect_evidence "datadog" "Error rate spike 14:30 UTC" "9/10" "h1,h2"
collect_evidence "database" "Connection pool 95% utilized" "10/10" "h1"
collect_evidence "users" "Multiple timeout reports" "6/10" "h1"
collect_evidence "code" "No recent payment service changes" "7/10" "" "h2"

# Calculate evidence-weighted confidence
validate_conclusion --confidence-interval=95 --bias-check=true
```

### Development Investigation Enhancement
```bash
# Evidence-based architectural analysis
collect_evidence "profiling" "Query execution time 2.3s avg" "10/10" "h_performance"
collect_evidence "code_analysis" "N+1 query pattern identified" "8/10" "h_performance"
collect_evidence "monitoring" "Database CPU spikes during queries" "9/10" "h_performance"

# Multi-source validation before optimization
validate_conclusion --require-sources=3 --min-credibility=8
```

This evidence evaluation framework ensures that investigation conclusions are based on reliable, diverse, and properly weighted evidence while actively mitigating common cognitive biases that can lead to incorrect diagnoses.