# Statistical Validation for Software Investigation

## Overview

Statistical validation transforms subjective investigation conclusions into quantified, confidence-bounded findings. Rather than binary "fixed/not fixed" assessments, scientific investigation provides probabilistic conclusions with explicit uncertainty ranges and statistical significance testing.

## Core Principles

### Confidence Intervals Over Point Estimates
Express uncertainty around investigation conclusions using confidence intervals rather than absolute statements.

**Traditional Approach**:
- "This fix will resolve the issue"
- "The database is the problem"
- "Users are affected"

**Statistical Approach**:
- "This fix will resolve 85-95% of related errors (90% confidence)"
- "Database issues explain 70-90% of observed symptoms (95% confidence)"
- "Impact affects 1,200-1,800 users based on error log sampling"

### Significance Testing
Determine whether observed differences are statistically meaningful or could occur by chance.

**Performance Improvement Example**:
```
Before fix: Response time = 2.3s ± 0.4s (n=1000)
After fix:  Response time = 1.1s ± 0.2s (n=1000)
Difference: 1.2s improvement
p-value: < 0.001 (highly significant)
Effect size: Large (Cohen's d = 2.1)
```

### Effect Size Assessment
Distinguish between statistical significance and practical importance:
- **Small effect**: Statistically significant but minimal practical impact
- **Medium effect**: Noticeable improvement in key metrics
- **Large effect**: Dramatic improvement with clear business value

## Statistical Analysis Tools

### Error Rate Analysis
Use `calculate_error_rate_ci()` from `scripts/statistical-validation.sh` to quantify error impacts with confidence intervals:

```bash
source ~/.claude/skills/scientific-method-framework/scripts/statistical-validation.sh

# Calculate error rate with 95% confidence interval
calculate_error_rate_ci 150 10000 95
# Output: Error rate: 1.50% (1.24% - 1.80%, 95% CI)
```

**When to Use**:
- Quantifying production error impacts
- Comparing before/after fix error rates
- Estimating improvement confidence bounds

### User Impact Estimation
Use `estimate_affected_users()` to project issue impact across user base:

```bash
# Estimate affected users from error sample
estimate_affected_users 150 2 12 50000
# Sample: 150 errors in 2h
# Extrapolated: 900 total errors over 12h
# Affected users: 892 (714 - 1071, 80% CI)
# Impact rate: 1.78% of user base
```

**When to Use**:
- Prioritizing issue severity
- Estimating business impact
- Planning rollout strategies

### Investigation Confidence Scoring
Use `calculate_investigation_confidence()` to quantify investigation reliability:

```bash
# Calculate confidence: hypothesis_support, evidence_quality, diversity, alternatives
calculate_investigation_confidence 8 9 4 2
# Investigation Confidence Score: 8.3/10
# **Interpretation**: High confidence - proceed with production fix
```

**Scoring Criteria**:
- **Hypothesis Support** (1-10): Strength of evidence supporting conclusion
- **Evidence Quality** (1-10): Average credibility of evidence sources
- **Diversity Count**: Number of independent evidence source types
- **Alternatives Tested**: Number of competing hypotheses investigated

### Performance Impact Analysis
Use `analyze_performance_improvement()` to validate optimization claims:

```bash
# Analyze performance before/after files
analyze_performance_improvement before_response_times.txt after_response_times.txt
# Before Fix:
# - Mean: 2.34ms, Median: 2.10ms, 95th percentile: 4.20ms
# After Fix:
# - Mean: 1.15ms, Median: 1.05ms, 95th percentile: 2.10ms
# Statistical Comparison: [requires statistical software for complete analysis]
```

## Advanced Statistical Methods

### Bayesian Confidence Updates
Use `bayesian_update()` to update hypothesis probabilities as evidence accumulates:

```bash
# Update hypothesis probability with new evidence
bayesian_update 0.6 0.8 0.4
# Prior P(H): 0.6 (initial hypothesis probability)
# Likelihood P(E|H): 0.8 (evidence likelihood given hypothesis)
# Evidence P(E): 0.4 (overall evidence probability)
# Posterior P(H|E): 1.200 (updated hypothesis probability)
```

**Applications**:
- Systematic hypothesis probability updates
- Incorporating contradictory evidence
- Multi-stage investigation confidence tracking

### Multi-Factor Analysis
Use `multi_factor_analysis()` to quantify contributing causes:

```bash
# Analyze multiple contributing factors (database, network, code)
multi_factor_analysis 60 25 15
# Database contribution: 60.0%
# Network contribution: 25.0%
# Code contribution: 15.0%
# **Recommendation**: Address factors in order of contribution magnitude
```

### Calibration Tracking
Use `track_calibration()` to improve confidence accuracy over time:

```bash
# Track prediction accuracy
track_calibration "ZYN-10585" 85 1  # 85% confidence, successful outcome
# Recent calibration accuracy (last 20 investigations):
# - High Confidence (80%+): 89% correct (8/9)
# - Medium Confidence (60-79%): 71% correct (5/7)
```

## Quality Assurance Framework

### Confidence Level Interpretation
- **90-100%**: Overwhelming evidence, ready for production fix
- **70-89%**: Strong evidence, validate in staging first
- **50-69%**: Moderate evidence, needs more investigation
- **30-49%**: Weak evidence, deprioritize unless alternatives fail
- **0-29%**: Very weak evidence, consider suspending

### A/B Testing Setup
Use `setup_ab_test()` for controlled validation:

```bash
# Set up controlled experiment
setup_ab_test "Database connection pool fix" "Error rate" 5000
# A/B Test Setup: Database connection pool fix
# **Primary Metric**: Error rate
# **Sample Size**: 5000 per group
# **Minimum Duration**: 3 days
# **Success Metric**: Error rate improvement > 5%
```

### Statistical Validation Checklist
- [ ] Confidence intervals calculated for key metrics
- [ ] Statistical significance testing performed
- [ ] Effect size assessed for practical importance
- [ ] Multiple evidence sources with credibility weighting
- [ ] Investigation confidence score calculated
- [ ] Calibration tracking updated

## Integration Patterns

### Enhanced Support Investigation
```bash
# Load statistical tools
source ~/.claude/skills/scientific-method-framework/scripts/statistical-validation.sh

# Quantify error impact with confidence bounds
calculate_error_rate_ci 150 10000 95
estimate_affected_users 150 2 12 50000

# Calculate investigation confidence
calculate_investigation_confidence 8 9 4 2

# Track calibration for future improvement
track_calibration "ZYN-10585" 85 1
```

### Development Investigation Enhancement
```bash
# Validate performance optimization with statistical rigor
analyze_performance_improvement baseline.txt optimized.txt

# Multi-factor analysis for complex performance issues
multi_factor_analysis 45 30 25  # database, cache, query contributions
```

### Cross-Skill Integration
```bash
# Generate statistical validation for testing skills
calculate_investigation_confidence 8 9 4 2 > validation_report.md
/backend-test-development --validation-report=validation_report.md --confidence-threshold=70
```

## Common Patterns

### Error Investigation Workflow
1. **Initial Impact**: `calculate_error_rate_ci` for current error rate
2. **User Impact**: `estimate_affected_users` for business impact
3. **Investigation**: `calculate_investigation_confidence` for reliability
4. **Fix Validation**: `setup_ab_test` for controlled rollout
5. **Outcome Tracking**: `track_calibration` for learning

### Performance Optimization Workflow
1. **Baseline Analysis**: `analyze_performance_improvement` with before/after data
2. **Factor Analysis**: `multi_factor_analysis` for complex issues
3. **Confidence Assessment**: `calculate_investigation_confidence` for reliability
4. **Bayesian Updates**: `bayesian_update` as evidence accumulates
5. **Validation**: A/B testing with statistical significance requirements

## Anti-Patterns to Avoid

### False Precision
Don't provide overly precise confidence intervals without sufficient data:
```bash
# Bad: 150 samples, claiming 87.3% confidence
# Good: 150 samples, confidence range 80-95%
```

### Significance Misinterpretation
Statistical significance ≠ practical importance:
- A 0.01ms response time improvement might be statistically significant but practically irrelevant
- Always assess effect size alongside significance

### Single-Source Statistics
Don't base statistical conclusions on single evidence sources:
- Combine multiple independent measurements
- Weight evidence by source credibility
- Validate with diverse evidence types

This statistical validation framework ensures investigation conclusions are quantified, confidence-bounded, and properly validated while avoiding common statistical pitfalls in software investigation contexts.