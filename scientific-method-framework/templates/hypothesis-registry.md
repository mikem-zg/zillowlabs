# Hypothesis Registry - [Investigation Name]

**Investigation ID**: [Auto-generated or manual ID]
**Created**: [YYYY-MM-DD HH:MM:SS UTC]
**Status**: Active
**Investigator**: [Name]
**Issue/Task**: [Brief description]

## Hypothesis Tracking

| ID | Hypothesis | Priority | Evidence For | Evidence Against | Status | Confidence |
|----|-----------|----------|-------------|-----------------|--------|------------|
| h1 | [Primary hypothesis - most likely explanation] | High | [Supporting evidence] | [Contradicting evidence] | Registered | 0% |
| h2 | [Alternative hypothesis - competing explanation] | Medium | [Supporting evidence] | [Contradicting evidence] | Registered | 0% |
| h3 | [Secondary hypothesis - less likely but possible] | Low | [Supporting evidence] | [Contradicting evidence] | Registered | 0% |

## Active Testing
- **Current Focus**: [None assigned]
- **Method**: [Testing method to be determined]
- **Expected Completion**: [To be scheduled]
- **Resources Required**: [Tools, environments, personnel]

## Hypothesis Generation Guidelines

### System Component Analysis
Consider hypotheses across major system components:
- **Database**: Connection issues, query performance, schema problems
- **Application**: Logic errors, memory leaks, CPU bottlenecks
- **Network**: Connectivity, DNS, load balancer issues
- **External Dependencies**: Third-party services, API changes
- **Infrastructure**: Server health, resource constraints

### Timing Analysis
Consider temporal factors:
- **Recent Changes**: Deployments, configuration updates, data migrations
- **Cyclical Patterns**: Daily/weekly usage patterns, batch job impacts
- **Environmental Changes**: Infrastructure updates, dependency changes

### User Impact Patterns
Consider user-facing symptoms:
- **Specific User Groups**: Geographic, account type, usage pattern variations
- **Feature-Specific**: Particular workflows or functionalities affected
- **Error Patterns**: Specific error messages, failure modes

## Testing Status Definitions

- **Registered**: Hypothesis documented but not yet investigated
- **Testing**: Active investigation with evidence collection in progress
- **Validated**: Strong evidence supports hypothesis (>70% confidence)
- **Rejected**: Evidence contradicts hypothesis (<30% confidence)
- **Suspended**: Testing paused, may resume based on new information
- **Merged**: Combined with another hypothesis due to overlap

## Confidence Calibration Guide

- **90-100%**: Overwhelming evidence, ready for production implementation
- **70-89%**: Strong evidence, validate in staging environment first
- **50-69%**: Moderate evidence, continue investigation or test alternatives
- **30-49%**: Weak evidence, deprioritize unless other hypotheses fail
- **0-29%**: Very weak or contradictory evidence, consider rejection

## Testing Log

[Chronological record of testing activities - automatically populated by core functions or manually maintained]

### Example Entries:
- [2024-01-15 14:30] Registered hypothesis h1: "Database connection timeout"
- [2024-01-15 14:45] Started testing h1 with staging environment reproduction
- [2024-01-15 15:15] Collected evidence supporting h1: connection pool at 95% capacity
- [2024-01-15 15:30] Updated h1 confidence to 75% based on multiple evidence sources

## Alternative Hypothesis Requirements

To prevent confirmation bias, this investigation requires:
- [ ] Minimum 2 competing hypotheses registered
- [ ] At least 1 alternative hypothesis tested before concluding
- [ ] Evidence collected for both supporting and contradicting each hypothesis
- [ ] Independent validation of primary conclusion

## Cross-Reference Links

- **Evidence Matrix**: [Link to evidence-matrix.md]
- **Validation Report**: [Link to validation-report.md]
- **Experimental Plan**: [Link to experimental-plan.md if applicable]
- **Related Tickets**: [Links to support tickets, GitHub issues, etc.]

---

## Notes for Users

**Usage Instructions**:
1. Copy this template to your investigation directory
2. Replace [bracketed placeholders] with actual values
3. Register at least 2-3 competing hypotheses before evidence collection
4. Update status and confidence as investigation progresses
5. Use `register_hypothesis()` function from core-functions.sh for automated updates

**Integration with Core Functions**:
```bash
# Load scientific investigation tools
source ~/.claude/skills/scientific-method-framework/scripts/core-functions.sh

# Initialize investigation (creates this template automatically)
init_scientific_investigation "ZYN-10585: Payment failures"

# Register hypotheses (updates this template)
register_hypothesis "h1" "Database connection timeout" "high"
register_hypothesis "h2" "Payment gateway API changes" "medium"

# Test hypothesis (updates status in template)
test_hypothesis "h1" --method="staging_reproduction"
```

**Quality Checklist**:
- [ ] Multiple competing hypotheses considered
- [ ] Hypotheses are specific and testable
- [ ] Priority assignments based on initial evidence
- [ ] Regular updates as evidence accumulates
- [ ] Alternative testing planned before conclusion