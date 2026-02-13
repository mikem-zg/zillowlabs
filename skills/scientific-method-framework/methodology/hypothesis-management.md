# Hypothesis Management in Software Investigation

## Overview

Systematic hypothesis management is the cornerstone of scientific investigation methodology. Rather than pursuing the first plausible explanation, rigorous hypothesis management ensures comprehensive exploration of alternative explanations and reduces confirmation bias.

## Core Principles

### 1. Multiple Hypothesis Generation
Never investigate with just one hypothesis. Generate at least 2-3 competing explanations before beginning evidence collection.

**Good Example**:
```
Issue: API timeouts after deployment

Hypotheses:
- h1: Database connection pool exhaustion (high priority)
- h2: New API route causing resource contention (medium priority)
- h3: Network configuration change (low priority)
- h4: Third-party service degradation (medium priority)
```

**Poor Example**:
```
Issue: API timeouts after deployment

Hypothesis: Must be the database because we see connection errors
```

### 2. Hypothesis Prioritization
Rank hypotheses by likelihood based on initial evidence, but test them systematically regardless of priority.

**Priority Levels**:
- **High**: Strong initial evidence, known failure patterns
- **Medium**: Some supporting evidence, plausible mechanism
- **Low**: Weak evidence but possible, worth investigating

### 3. Evidence-Based Refinement
Update hypothesis probability as evidence accumulates, but avoid early closure.

## Hypothesis Registry System

### Registration Format
```markdown
| ID | Hypothesis | Priority | Evidence For | Evidence Against | Status | Confidence |
|----|-----------|----------|-------------|-----------------|--------|------------|
| h1 | Database timeout | High | Connection metrics | No user reports | Testing | 75% |
| h2 | API changes | Medium | Timeline correlation | No deployment logs | Registered | 30% |
| h3 | Config drift | Low | Environment diff | Recent validation | Testing | 20% |
```

### Status Workflow
1. **Registered**: Added to investigation, no testing yet
2. **Testing**: Active investigation with evidence collection
3. **Validated**: Strong evidence supports hypothesis
4. **Rejected**: Evidence contradicts hypothesis
5. **Suspended**: Testing paused, may resume later

### Confidence Calibration
- **90-100%**: Overwhelming evidence, ready for production fix
- **70-89%**: Strong evidence, validate in staging first
- **50-69%**: Moderate evidence, needs more investigation
- **30-49%**: Weak evidence, deprioritize unless other hypotheses fail
- **0-29%**: Very weak evidence, consider suspending

## Testing Strategies

### Sequential Testing
Test hypotheses in priority order, but don't stop at the first confirmed hypothesis.

```bash
# Test highest priority first
test_hypothesis "h1" --method="staging_reproduction"

# If h1 validates, still test h2 if evidence suggests multiple causes
test_hypothesis "h2" --method="code_analysis" --parallel=true
```

### Parallel Testing
When resources allow, test multiple hypotheses simultaneously.

```bash
# Launch parallel investigations
test_hypothesis "h1" --method="database_analysis" &
test_hypothesis "h2" --method="performance_profiling" &
test_hypothesis "h3" --method="configuration_audit" &
wait  # Wait for all to complete
```

### Elimination Testing
Design tests that can rule out multiple hypotheses efficiently.

**Example**: If testing h1 (database) and h2 (API changes):
- Test with database isolation → Rules out h1 if issue persists
- Test with API rollback → Rules out h2 if issue persists

## Bias Mitigation Techniques

### 1. Devil's Advocate Testing
For each preferred hypothesis, actively seek contradicting evidence.

```bash
# After finding evidence supporting h1
collect_evidence "monitoring" "No correlation with DB metrics" "8/10" "" "h1"
```

### 2. Alternative Explanation Requirement
Require at least one alternative hypothesis to be tested before concluding.

### 3. Fresh Eyes Review
Have another team member review hypotheses and evidence without revealing your preferred conclusion.

### 4. Historical Pattern Analysis
Check if similar issues had different root causes to avoid pattern fixation.

## Advanced Hypothesis Techniques

### Compound Hypotheses
Some issues have multiple contributing causes.

```markdown
| ID | Hypothesis | Type |
|----|-----------|------|
| h1a | Database timeout | Primary |
| h1b | Connection pool too small | Contributing to h1a |
| h1c | Query optimization needed | Contributing to h1a |
```

### Negative Hypotheses
Test what the problem is NOT to constrain the solution space.

```markdown
| ID | Hypothesis | Type |
|----|-----------|------|
| h_neg1 | NOT a network issue | Negative |
| h_neg2 | NOT related to user load | Negative |
```

### Meta-Hypotheses
Hypotheses about the investigation process itself.

```markdown
| ID | Hypothesis |
|----|-----------|
| h_meta1 | We lack monitoring data for the critical component |
| h_meta2 | The issue is intermittent and requires long-term observation |
```

## Quality Metrics

### Hypothesis Coverage
- **Breadth**: Number of different system components considered
- **Depth**: Number of potential causes within each component
- **Diversity**: Variety of failure modes explored

### Testing Completeness
- **Alternative Testing Rate**: % investigations that test multiple hypotheses
- **Evidence Diversity**: Average number of evidence types per hypothesis
- **Validation Rate**: % of conclusions validated before implementation

### Calibration Accuracy
Track how often confidence levels match actual outcomes:
- 90% confidence should be correct 9/10 times
- 70% confidence should be correct 7/10 times

## Common Anti-Patterns

### 1. Single Hypothesis Fixation
Investigating only the first plausible explanation.

**Fix**: Mandatory generation of 2+ competing hypotheses.

### 2. Priority Tunnel Vision
Only investigating high-priority hypotheses.

**Fix**: Test at least one lower-priority hypothesis per investigation.

### 3. Confirmation Bias
Seeking only supporting evidence for preferred hypothesis.

**Fix**: Mandatory collection of contradicting evidence.

### 4. Early Closure
Stopping investigation after first validation.

**Fix**: Test alternative hypotheses even after finding one cause.

### 5. Evidence Cherry-Picking
Ignoring evidence that doesn't fit the narrative.

**Fix**: Document all evidence with credibility scores.

## Integration with Investigation Skills

### Support Investigation
```bash
# Enhanced support investigation with hypothesis management
/support-investigation --scientific-mode=true \
  --require-alternatives=2 \
  --evidence-threshold=3-sources \
  --issue="ZYN-10585"
```

### Development Investigation
```bash
# Development investigation with architectural hypotheses
/development-investigation --hypothesis-driven=true \
  --test-alternatives=true \
  --task="performance optimization"
```

## Templates and Tools

### Quick Hypothesis Generator
```bash
# Generate initial hypotheses from issue description
generate_hypotheses() {
    local issue="$1"
    echo "## Generated Hypotheses for: $issue"
    echo ""
    echo "### System Component Hypotheses"
    echo "- Database: Connection, query, schema issues"
    echo "- Application: Logic, memory, CPU issues"
    echo "- Network: Connectivity, DNS, load balancer issues"
    echo "- External: Third-party service, API changes"
    echo ""
    echo "### Timing Hypotheses"
    echo "- Recent deployment causing regression"
    echo "- Configuration drift over time"
    echo "- External dependency change"
    echo "- Load pattern change"
    echo ""
    echo "### Environmental Hypotheses"
    echo "- Production vs staging differences"
    echo "- Resource constraints (memory, disk, CPU)"
    echo "- Security or access changes"
}
```

### Hypothesis Testing Checklist
- [ ] At least 2 competing hypotheses registered
- [ ] Each hypothesis has testable predictions
- [ ] Testing method defined for each hypothesis
- [ ] Evidence collected from multiple sources
- [ ] Contradicting evidence actively sought
- [ ] Alternative hypotheses tested before concluding
- [ ] Confidence level calibrated against evidence strength

## Success Indicators

### Investigation Quality
- **Multiple hypotheses tested**: 85%+ of investigations
- **Evidence diversity**: Average 4+ evidence types per investigation
- **Alternative validation**: 60%+ of investigations test alternatives
- **Bias detection**: Regular calibration reviews show well-calibrated confidence

### Team Learning
- **Pattern recognition**: Improved speed of hypothesis generation over time
- **Calibration improvement**: Confidence levels become more accurate
- **Knowledge sharing**: Common hypothesis patterns documented and reused

This hypothesis management system transforms reactive debugging into proactive scientific investigation, leading to more reliable conclusions and better system understanding.