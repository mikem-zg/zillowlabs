# Evidence Matrix - [Investigation Name]

**Investigation ID**: [Auto-generated or manual ID]
**Created**: [YYYY-MM-DD HH:MM:SS UTC]
**Last Updated**: [YYYY-MM-DD HH:MM:SS UTC]
**Investigator**: [Name]

## Evidence Collection

| Source | Evidence | Credibility | Supports | Contradicts | Weight | Timestamp |
|--------|----------|-------------|----------|-------------|--------|-----------|
| [Example: database] | [Connection pool at 95% capacity] | [10/10] | [h1] | [h3] | [Critical] | [2024-01-15 14:30] |
| [Example: logs] | [ConnectionTimeout exceptions in payment service] | [9/10] | [h1] | [h2] | [Critical] | [2024-01-15 14:32] |
| [Example: monitoring] | [Response time spike at 14:30 UTC] | [9/10] | [h1,h2] | [h3] | [High] | [2024-01-15 14:35] |

## Source Credibility Scale

### 10/10 - Direct Measurement (Critical Weight)
**Database queries, system metrics, performance counters**
- Machine-generated with minimal interpretation
- Immediately reproducible and verifiable
- High precision and accuracy

**Examples**: Connection counts, response times, error counts, resource utilization

### 9/10 - Structured Logs (Critical Weight)
**Application logs with structured format, error tracking systems**
- Programmatically generated with consistent format
- Timestamped and contextualized
- Minimal ambiguity in interpretation

**Examples**: JSON-formatted application logs, structured error tracking (Sentry, Rollbar)

### 8/10 - System Logs (High Weight)
**Operating system logs, infrastructure monitoring**
- System-generated events in standard formats
- Good temporal accuracy
- Some interpretation required

**Examples**: Syslog entries, Docker logs, Kubernetes events

### 7/10 - Code Analysis (High Weight)
**Static analysis, configuration review, deployment analysis**
- Logical analysis with reproducible methodology
- Subject to interpretation but systematic
- Clear connection to observed behavior

**Examples**: Code reviews, configuration diffs, deployment correlations

### 6/10 - User Reports (Medium Weight)
**Support tickets, user feedback, error reports**
- Direct user experience data
- Human interpretation with potential bias
- Valuable context despite reliability limitations

**Examples**: Customer support tickets, user-reported error messages

### 5/10 - Timeline Correlation (Medium Weight)
**Event timing analysis, deployment correlation**
- Circumstantial evidence based on timing
- Useful for hypothesis generation
- Requires validation (correlation ≠ causation)

**Examples**: Error spikes after deployments, usage pattern correlations

### 4/10 - Performance Trends (Medium Weight)
**Historical data analysis, trend identification**
- Useful for context and baselines
- May not reflect current state
- Requires careful interpretation

**Examples**: 30-day performance trends, seasonal usage patterns

### 3/10 - Anecdotal Evidence (Low Weight)
**Individual observations, informal reports**
- Single-person observations
- Highly subjective with potential bias
- May contain insights despite low reliability

**Examples**: Developer observations, informal team discussions

### 2/10 - Speculation (Very Low Weight)
**Educated guesses without supporting data**
- Based on experience but no direct evidence
- Useful for hypothesis generation only
- Should not influence conclusions

### 1/10 - Hearsay (Very Low Weight)
**Third-hand information, unverified reports**
- Information passed through multiple people
- High potential for distortion
- Generally not useful for investigation

## Evidence Quality Assessment

### Multi-Source Validation Requirements
- **Critical Conclusions**: Minimum 3 independent sources with credibility ≥ 7/10
- **Moderate Conclusions**: Minimum 2 independent sources with credibility ≥ 6/10
- **Exploratory Findings**: Single high-credibility source acceptable for hypothesis generation

### Evidence Independence Verification
Ensure evidence sources are truly independent:

**Independent Sources** (Preferred):
- Database metrics + Application logs + User reports
- Multiple monitoring systems
- Different team member observations

**Dependent Sources** (Use Cautiously):
- Multiple views of same database
- Related application components
- Reports from same user or team

## Statistical Summary

- **Total Evidence Points**: [Calculated by evidence count]
- **Credibility Weighted Score**: [Weighted average of credibility scores]
- **Evidence Diversity Index**: [Count of unique source types]
- **Independent Source Count**: [Number of truly independent sources]
- **Temporal Span**: [Time range covered by evidence]

## Evidence Validation Checklist

### Collection Standards
- [ ] Evidence documented with sufficient detail for reproduction
- [ ] Source credibility assessed using framework scale
- [ ] Timestamp correlation verified where relevant
- [ ] Independent validation performed for critical evidence
- [ ] Contradictory evidence actively sought and documented

### Bias Mitigation
- [ ] Multiple independent sources consulted
- [ ] Confirmation bias check: evidence that contradicts preferred hypothesis
- [ ] Temporal bias check: both recent and historical evidence considered
- [ ] Source bias check: evidence from different types of sources

### Documentation Quality
- [ ] Evidence preservation includes reproduction steps
- [ ] Context and methodology clearly documented
- [ ] Assumptions and limitations explicitly stated
- [ ] Links to raw data or supporting materials provided

## Evidence Collection Examples

### High-Quality Evidence Example
```markdown
**Source**: Database Monitoring
**Evidence**: Connection pool utilization at 95% capacity during error period
**Credibility**: 10/10 (Direct measurement)
**Query Used**:
```sql
SELECT
  VARIABLE_NAME,
  VARIABLE_VALUE,
  timestamp
FROM INFORMATION_SCHEMA.GLOBAL_STATUS
WHERE VARIABLE_NAME LIKE 'Threads_connected%'
AND timestamp BETWEEN '2024-01-15 14:25:00' AND '2024-01-15 14:35:00';
```
**Supporting Data**: [Link to query results]
**Verification**: Reproducible by re-running query
**Context**: Corresponds exactly with user-reported error timeframe
```

### Evidence Integration Examples
```bash
# Using core functions to collect evidence systematically
source ~/.claude/skills/scientific-method-framework/scripts/core-functions.sh

# Collect evidence with automatic credibility scoring
collect_evidence "database" "Connection pool at 95% capacity" "10/10" "h1" "h3"
collect_evidence "logs" "ConnectionTimeout exceptions in payment service" "9/10" "h1"
collect_evidence "monitoring" "Response time spike at 14:30 UTC" "9/10" "h1,h2"
collect_evidence "users" "Multiple payment timeout reports" "6/10" "h1"

# Automatic statistical summary calculation
update_evidence_summary
```

## Cross-Reference Links

- **Hypothesis Registry**: [Link to hypothesis-registry.md]
- **Validation Report**: [Link to validation-report.md]
- **Raw Data Files**: [Links to supporting data files]
- **Related Documentation**: [Links to relevant runbooks, architecture docs]

---

## Usage Instructions

**Template Usage**:
1. Copy this template to your investigation directory
2. Replace [bracketed placeholders] with actual values
3. Document evidence as it's collected, following credibility framework
4. Use `collect_evidence()` function for automated updates
5. Regular review and summary updates

**Integration Commands**:
```bash
# Initialize investigation (creates this template)
init_scientific_investigation "Investigation Name"

# Add evidence (updates this template)
collect_evidence "source_type" "evidence_description" "credibility_score" "supports_hypotheses" "contradicts_hypotheses"

# Generate evidence summary
update_evidence_summary
```

**Quality Standards**:
- Minimum 3 evidence sources for confident conclusions
- At least 2 source types (diversity requirement)
- Credibility-weighted average ≥ 7.0 for high-confidence conclusions
- Active collection of contradictory evidence