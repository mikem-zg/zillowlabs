# Support Investigation Integration with Scientific Method Framework

## Overview

This document describes how to integrate the scientific method framework with the existing `support-investigation` skill to enhance methodological rigor while maintaining the speed and practicality required for production incident response.

## Integration Architecture

### Progressive Enhancement Approach
The scientific framework enhances rather than replaces existing support investigation workflows:

**Traditional Flow**:
```
Issue Report → Investigation → Root Cause → Fix → Documentation
```

**Enhanced Scientific Flow**:
```
Issue Report → Hypothesis Generation → Evidence Collection →
Statistical Validation → Experimental Verification → Fix → Calibration Tracking
```

## Enhanced Support Investigation Usage

### Basic Scientific Mode
Add scientific rigor to standard support investigations:

```bash
# Enhanced support investigation with scientific methodology
/support-investigation --scientific-mode=true --issue="ZYN-10585"
```

**What this adds**:
- Systematic hypothesis registry instead of ad-hoc investigation
- Evidence credibility scoring for reliability assessment
- Statistical confidence intervals for impact estimates
- Validation requirements before production changes

### Advanced Scientific Parameters
For critical incidents requiring maximum rigor:

```bash
# Maximum scientific rigor for critical incidents
/support-investigation --scientific-mode=true \
  --require-alternatives=3 \
  --evidence-threshold=3-sources \
  --confidence-minimum=85 \
  --experimental-validation=true \
  --issue="ZYN-10585"
```

**Advanced Parameters**:
- `--require-alternatives=N`: Minimum number of competing hypotheses
- `--evidence-threshold=N-sources`: Minimum independent evidence sources
- `--confidence-minimum=N`: Required confidence level for recommendations
- `--experimental-validation=true`: Require staging/canary validation

## Workflow Integration Patterns

### 1. Initial Investigation Enhancement

**Traditional Approach**:
```
1. Read issue description
2. Check logs and monitoring
3. Form initial hypothesis
4. Test hypothesis
5. Implement fix
```

**Scientific Enhancement**:
```bash
# Initialize scientific investigation
source ~/.claude/skills/scientific-method-framework/scripts/core-functions.sh
init_scientific_investigation "ZYN-10585: Payment processing timeouts"

# Generate competing hypotheses before evidence collection
register_hypothesis "h1" "Database connection pool exhaustion" "high"
register_hypothesis "h2" "Payment gateway API degradation" "medium"
register_hypothesis "h3" "Network connectivity issues" "medium"
register_hypothesis "h4" "Application memory leak" "low"
```

### 2. Evidence Collection Enhancement

**Traditional Evidence Gathering**:
- Check Datadog dashboards
- Review application logs
- Query database metrics
- Check recent deployments

**Scientific Evidence Collection**:
```bash
# Systematic evidence collection with credibility scoring
collect_evidence "datadog" "Error rate spike from 0.1% to 2.3% at 14:30 UTC" "9/10" "h1,h2"
collect_evidence "database" "Connection pool utilization at 95% during incident" "10/10" "h1" "h2,h3"
collect_evidence "logs" "ConnectionTimeout exceptions in payment-processor service" "9/10" "h1" "h2"
collect_evidence "deployment" "No deployments in 48 hours preceding incident" "8/10" "" "h1,h2,h3,h4"
collect_evidence "users" "Customer reports concentrated in 14:30-15:00 timeframe" "6/10" "h1,h2"
```

### 3. Hypothesis Testing Integration

**Enhanced Testing Workflow**:
```bash
# Test primary hypothesis with staging reproduction
test_hypothesis "h1" --method="staging_reproduction" --control="baseline_traffic"

# If h1 validates, still test h2 to ensure single root cause
test_hypothesis "h2" --method="external_api_analysis" --parallel=true

# Statistical validation of findings
validate_conclusion --confidence-interval=95 --bias-check=true
```

### 4. User Impact Quantification

**Traditional Impact Assessment**:
- "Multiple users affected"
- "Payment processing down"
- "Customer complaints received"

**Scientific Impact Quantification**:
```bash
# Quantify user impact with confidence intervals
source ~/.claude/skills/scientific-method-framework/scripts/statistical-validation.sh
estimate_affected_users 150 2 12 50000
# Output: Affected users: 892 (714 - 1071, 80% CI)
# Impact rate: 1.78% of user base

# Calculate error rate with confidence bounds
calculate_error_rate_ci 150 6500 95
# Output: Error rate: 2.31% (1.98% - 2.67%, 95% CI)
```

## Documentation Integration

### Enhanced Investigation.md Template

The scientific framework enhances the standard investigation.md with structured sections:

```markdown
# Investigation: ZYN-10585 - Payment Processing Timeouts

## Executive Summary
**Status**: Complete
**Root Cause**: Database connection pool exhaustion
**Confidence**: 89% (High confidence - validated in staging)
**Impact**: 892 users affected (714-1071, 80% CI) over 12 hours

## Scientific Analysis
**Investigation ID**: ZYN-10585_Payment_processing_timeouts_20241215_1430
**Hypothesis Registry**: ./investigation_ZYN-10585_20241215_1430/hypothesis_registry.md
**Evidence Matrix**: ./investigation_ZYN-10585_20241215_1430/evidence_matrix.md
**Validation Report**: ./investigation_ZYN-10585_20241215_1430/validation_report.md

## [Existing investigation sections continue...]
```

### Integration with Existing Tools

**Datadog Integration**:
```bash
# Enhanced Datadog analysis with evidence collection
/datadog-management --investigate --timeframe="2024-01-15T14:00:00Z to 2024-01-15T16:00:00Z" | \
  while read metric value; do
    collect_evidence "datadog" "$metric: $value" "9/10" "h1" ""
  done
```

**Database Operations Integration**:
```bash
# Scientific validation before database changes
calculate_investigation_confidence 8 9 4 2
if confidence_score >= 7.0; then
    /database-operations --change="increase_connection_pool" --validation="staging_first"
else
    echo "Insufficient confidence for database changes. Additional investigation required."
fi
```

## Validation and Testing Integration

### Staging Validation
Before production fixes, validate in staging with controlled conditions:

```bash
# Generate staging validation plan
generate_test_cases --hypothesis-driven=true --target="backend-test-development"

# Execute staging validation
/backend-test-development --scenario="database_connection_load_test" \
  --hypothesis="Connection pool increase resolves timeout errors" \
  --success-criteria="<1% error rate under peak load"
```

### Production Deployment with Monitoring

```bash
# Create experimental plan for production deployment
cat > experimental_plan.md << EOF
# Production Validation: Database Connection Pool Increase

## Hypothesis
Increasing connection pool from 20 to 40 will reduce timeout errors by >50%

## Deployment Strategy
1. Canary deployment (10% traffic, 2 hours)
2. Gradual rollout (25% → 50% → 100%)
3. Automatic rollback if error rate >1.5%

## Success Metrics
- Error rate <1.0% (down from 2.3%)
- Response time <250ms (maintain current 245ms)
- No memory usage increase >10%
EOF

# Execute with monitoring
/database-operations --experimental-deployment=true --plan="experimental_plan.md"
```

## Calibration and Learning

### Continuous Improvement
Track investigation accuracy to improve future confidence calibration:

```bash
# After fix validation, track calibration
track_calibration "ZYN-10585" 89 1  # 89% confidence, successful outcome

# Review calibration accuracy periodically
echo "## Investigation Calibration Review"
track_calibration "review" 0 0  # Shows recent calibration statistics
```

### Knowledge Capture
Convert investigation findings into reusable patterns:

```bash
# Export investigation data for pattern analysis
export_investigation_data "json" > ZYN-10585_data.json

# Add to team knowledge base
echo "Database connection pool exhaustion pattern detected and resolved" >> \
  ~/.claude/investigation_patterns.md
```

## Anti-Patterns and Pitfalls

### Don't Over-Scientify Simple Issues

**Bad Example**:
```bash
# Overkill for obvious issues
/support-investigation --scientific-mode=true \
  --require-alternatives=5 \
  --experimental-validation=true \
  --issue="Typo in configuration file causing 500 errors"
```

**Good Example**:
```bash
# Appropriate for simple issues
/support-investigation --issue="Configuration typo" --quick-fix=true
```

### Don't Skip Scientific Rigor for Critical Issues

**Bad Example**:
```bash
# Insufficient rigor for critical production issue
/support-investigation --issue="Payment system completely down"
# No hypothesis testing, single evidence source, no validation
```

**Good Example**:
```bash
# Appropriate scientific rigor for critical issues
/support-investigation --scientific-mode=true \
  --require-alternatives=2 \
  --evidence-threshold=3-sources \
  --experimental-validation=true \
  --issue="Payment system completely down"
```

## Integration Success Metrics

### Investigation Quality Improvements
- **Alternative Hypothesis Testing**: Target 85% of investigations test competing hypotheses
- **Evidence Diversity**: Average 4+ independent evidence sources per investigation
- **Validation Rate**: 90% of critical fixes validated in staging first
- **False Positive Reduction**: <10% of deployed fixes require additional investigation

### Operational Efficiency
- **Time to Resolution**: Scientific investigation overhead <20% for 90%+ accuracy improvement
- **Rework Rate**: <5% of scientifically validated fixes require rework
- **Team Learning**: Improved pattern recognition and faster hypothesis generation over time
- **Calibration Accuracy**: Confidence levels accurate within ±10% over 20+ investigations

## Example Integration Workflows

### High-Severity Incident
```bash
# 1. Initialize with multiple hypotheses
/support-investigation --scientific-mode=true --issue="ZYN-10585" --severity="high"

# 2. Systematic evidence collection
for source in datadog database logs deployment; do
  echo "Collecting evidence from $source..."
  # Evidence collection integrated with existing tools
done

# 3. Statistical validation
validate_conclusion --confidence-interval=95 --bias-check=true

# 4. Experimental verification
if confidence >= 85; then
  setup_ab_test "Database pool fix" "Error rate" 5000
fi

# 5. Track learning
track_calibration "ZYN-10585" $confidence $outcome
```

### Medium-Severity Investigation
```bash
# Balanced approach for medium severity
/support-investigation --scientific-mode=true \
  --require-alternatives=2 \
  --evidence-threshold=2-sources \
  --issue="ZYN-10586"
```

### Low-Severity or Obvious Issues
```bash
# Standard investigation for clear-cut issues
/support-investigation --issue="ZYN-10587" --standard-mode=true
```

This integration pattern ensures that the scientific method framework enhances rather than hinders support investigation effectiveness, providing the right level of methodological rigor for each situation while building institutional knowledge and improving team calibration over time.