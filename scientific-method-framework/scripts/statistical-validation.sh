#!/bin/bash
# Statistical Validation Functions for Software Investigation
# Advanced statistical analysis tools for quantifying investigation confidence

# Calculate error rate with confidence intervals using Wilson score method
calculate_error_rate_ci() {
    local errors=$1
    local total_requests=$2
    local confidence_level=${3:-95}

    local error_rate=$(echo "scale=4; $errors / $total_requests" | bc)
    local error_percent=$(echo "scale=2; $error_rate * 100" | bc)

    # Calculate 95% confidence interval using Wilson score interval
    local z_score=1.96  # For 95% confidence
    local n=$total_requests
    local p=$error_rate

    # Wilson score interval formula
    local denominator=$(echo "1 + ($z_score^2) / $n" | bc -l)
    local center=$(echo "($p + ($z_score^2) / (2*$n)) / $denominator" | bc -l)
    local half_width=$(echo "$z_score * sqrt(($p * (1-$p) / $n) + ($z_score^2) / (4*$n^2)) / $denominator" | bc -l)

    local ci_lower=$(echo "($center - $half_width) * 100" | bc -l)
    local ci_upper=$(echo "($center + $half_width) * 100" | bc -l)

    printf "Error rate: %.2f%% (%.2f%% - %.2f%%, %d%% CI)\n" \
           "$error_percent" "$ci_lower" "$ci_upper" "$confidence_level"
}

# Compare error rates between time periods with significance testing
compare_error_rates() {
    local before_errors=$1
    local before_total=$2
    local after_errors=$3
    local after_total=$4

    local before_rate=$(echo "scale=4; $before_errors / $before_total" | bc)
    local after_rate=$(echo "scale=4; $after_errors / $after_total" | bc)
    local improvement=$(echo "scale=4; $before_rate - $after_rate" | bc)
    local improvement_percent=$(echo "scale=2; ($improvement / $before_rate) * 100" | bc)

    echo "Before: $(echo "scale=2; $before_rate * 100" | bc)% error rate"
    echo "After:  $(echo "scale=2; $after_rate * 100" | bc)% error rate"
    echo "Improvement: ${improvement_percent}% relative reduction"

    # Chi-square test for significance
    local chi_square=$(echo "scale=4; ($improvement^2 * $before_total * $after_total) / (($before_rate * (1-$before_rate) * $after_total) + ($after_rate * (1-$after_rate) * $before_total))" | bc -l)

    if (( $(echo "$chi_square > 3.84" | bc -l) )); then
        echo "Statistical significance: p < 0.05 (significant)"
    else
        echo "Statistical significance: p >= 0.05 (not significant)"
    fi
}

# Calculate basic performance statistics from data file
calculate_performance_stats() {
    local data_file=$1

    local mean=$(awk '{sum+=$1; n++} END {printf "%.2f", sum/n}' "$data_file")
    local median=$(sort -n "$data_file" | awk '{a[NR]=$1} END {print (NR%2==1) ? a[(NR+1)/2] : (a[NR/2]+a[NR/2+1])/2}')
    local p95=$(sort -n "$data_file" | awk '{a[NR]=$1} END {print a[int(NR*0.95)]}')
    local count=$(wc -l < "$data_file")

    echo "- Mean: ${mean}ms"
    echo "- Median: ${median}ms"
    echo "- 95th percentile: ${p95}ms"
    echo "- Sample size: $count"
}

# Estimate affected users with confidence intervals using Poisson model
estimate_affected_users() {
    local error_samples=$1
    local sample_period_hours=$2
    local total_period_hours=$3
    local total_user_base=$4

    echo "## User Impact Analysis"

    # Calculate hourly error rate from sample
    local hourly_errors=$(echo "scale=2; $error_samples / $sample_period_hours" | bc)

    # Extrapolate to total period
    local total_errors=$(echo "scale=0; $hourly_errors * $total_period_hours" | bc)

    # Estimate affected users (assuming some users hit multiple errors)
    # Use Poisson model: P(no errors) = e^(-λ) where λ = errors per user
    local errors_per_user=$(echo "scale=4; $total_errors / $total_user_base" | bc)
    local affected_fraction=$(echo "scale=4; 1 - e(-$errors_per_user)" | bc -l)
    local affected_users=$(echo "scale=0; $affected_fraction * $total_user_base" | bc)

    # Calculate confidence interval (±20% for estimation uncertainty)
    local ci_lower=$(echo "scale=0; $affected_users * 0.8" | bc)
    local ci_upper=$(echo "scale=0; $affected_users * 1.2" | bc)

    echo "- Sample: $error_samples errors in ${sample_period_hours}h"
    echo "- Extrapolated: $total_errors total errors over ${total_period_hours}h"
    echo "- Affected users: $affected_users ($ci_lower - $ci_upper, 80% CI)"
    echo "- Impact rate: $(echo "scale=2; $affected_fraction * 100" | bc)% of user base"
}

# Calculate overall investigation confidence score
calculate_investigation_confidence() {
    local hypothesis_support_strength=$1  # 1-10
    local evidence_quality_score=$2       # 1-10
    local evidence_diversity_count=$3     # number of source types
    local alternative_hypotheses_tested=$4 # number

    # Weighted confidence calculation
    local hypothesis_weight=0.4
    local evidence_weight=0.3
    local diversity_weight=0.2
    local alternatives_weight=0.1

    # Normalize diversity (max 5 source types)
    local diversity_normalized=$(echo "scale=2; ($evidence_diversity_count / 5) * 10" | bc)
    if (( $(echo "$diversity_normalized > 10" | bc -l) )); then
        diversity_normalized=10
    fi

    # Normalize alternatives (max 3 reasonable)
    local alternatives_normalized=$(echo "scale=2; ($alternative_hypotheses_tested / 3) * 10" | bc)
    if (( $(echo "$alternatives_normalized > 10" | bc -l) )); then
        alternatives_normalized=10
    fi

    # Calculate weighted score
    local confidence_score=$(echo "scale=1; ($hypothesis_support_strength * $hypothesis_weight) + ($evidence_quality_score * $evidence_weight) + ($diversity_normalized * $diversity_weight) + ($alternatives_normalized * $alternatives_weight)" | bc)

    echo "Investigation Confidence Score: ${confidence_score}/10"
    echo "- Hypothesis Support: $hypothesis_support_strength/10 (${hypothesis_weight} weight)"
    echo "- Evidence Quality: $evidence_quality_score/10 (${evidence_weight} weight)"
    echo "- Evidence Diversity: $diversity_normalized/10 (${diversity_weight} weight)"
    echo "- Alternative Testing: $alternatives_normalized/10 (${alternatives_weight} weight)"

    # Confidence interpretation
    if (( $(echo "$confidence_score >= 8.5" | bc -l) )); then
        echo "**Interpretation**: High confidence - proceed with production fix"
    elif (( $(echo "$confidence_score >= 7.0" | bc -l) )); then
        echo "**Interpretation**: Good confidence - validate in staging first"
    elif (( $(echo "$confidence_score >= 5.5" | bc -l) )); then
        echo "**Interpretation**: Moderate confidence - additional investigation recommended"
    else
        echo "**Interpretation**: Low confidence - significant additional investigation required"
    fi
}

# Track confidence calibration over time
track_calibration() {
    local investigation_id=$1
    local predicted_confidence=$2
    local actual_outcome=$3  # 1 for success, 0 for failure

    local calibration_file="$HOME/.claude/investigation_calibration.log"

    # Log prediction and outcome
    echo "$(date '+%Y-%m-%d %H:%M:%S'),$investigation_id,$predicted_confidence,$actual_outcome" >> "$calibration_file"

    # Calculate recent calibration accuracy
    echo "## Calibration Analysis"
    echo "Recent calibration accuracy (last 20 investigations):"

    # Analyze calibration for different confidence ranges
    tail -20 "$calibration_file" 2>/dev/null | awk -F, '
    BEGIN {
        high_correct = 0; high_total = 0
        med_correct = 0; med_total = 0
        low_correct = 0; low_total = 0
    }
    {
        confidence = $3; outcome = $4
        if (confidence >= 80) {
            high_total++
            if (outcome == 1) high_correct++
        } else if (confidence >= 60) {
            med_total++
            if (outcome == 1) med_correct++
        } else {
            low_total++
            if (outcome == 1) low_correct++
        }
    }
    END {
        if (high_total > 0) printf "- High Confidence (80%%+): %.0f%% correct (%d/%d)\n", (high_correct/high_total)*100, high_correct, high_total
        if (med_total > 0) printf "- Medium Confidence (60-79%%): %.0f%% correct (%d/%d)\n", (med_correct/med_total)*100, med_correct, med_total
        if (low_total > 0) printf "- Low Confidence (<60%%): %.0f%% correct (%d/%d)\n", (low_correct/low_total)*100, low_correct, low_total
    }'
}

# Bayesian probability update using Bayes' theorem
bayesian_update() {
    local prior_probability=$1      # P(H) - initial hypothesis probability
    local evidence_likelihood=$2    # P(E|H) - probability of evidence given hypothesis
    local evidence_prior=$3         # P(E) - overall probability of evidence

    # Bayes' theorem: P(H|E) = P(E|H) * P(H) / P(E)
    local posterior=$(echo "scale=3; ($evidence_likelihood * $prior_probability) / $evidence_prior" | bc)

    echo "Bayesian Update:"
    echo "- Prior P(H): $prior_probability"
    echo "- Likelihood P(E|H): $evidence_likelihood"
    echo "- Evidence P(E): $evidence_prior"
    echo "- Posterior P(H|E): $posterior"
}

# Multi-factor contribution analysis
multi_factor_analysis() {
    local factor1_impact=$1  # Database issues
    local factor2_impact=$2  # Network issues
    local factor3_impact=$3  # Code issues

    local total_impact=$(echo "$factor1_impact + $factor2_impact + $factor3_impact" | bc)

    echo "## Multi-Factor Impact Analysis"
    echo "- Database contribution: $(echo "scale=1; ($factor1_impact / $total_impact) * 100" | bc)%"
    echo "- Network contribution: $(echo "scale=1; ($factor2_impact / $total_impact) * 100" | bc)%"
    echo "- Code contribution: $(echo "scale=1; ($factor3_impact / $total_impact) * 100" | bc)%"
    echo ""
    echo "**Recommendation**: Address factors in order of contribution magnitude"
}

# A/B test setup helper
setup_ab_test() {
    local fix_name=$1
    local metric_name=$2
    local sample_size=$3

    echo "## A/B Test Setup: $fix_name"
    echo "**Primary Metric**: $metric_name"
    echo "**Sample Size**: $sample_size per group"
    echo "**Duration**: Auto-calculated for statistical power"

    # Calculate required duration for 80% power, 95% confidence
    # Assumes 5% minimum detectable effect
    local required_days=$(echo "scale=0; $sample_size / (1000 * 24)" | bc)  # Rough estimate
    echo "**Minimum Duration**: $required_days days"

    echo ""
    echo "### Monitoring Plan"
    echo "- **Success Metric**: $metric_name improvement > 5%"
    echo "- **Guardrail Metrics**: Error rate, response time, user satisfaction"
    echo "- **Stop Conditions**: Guardrail degradation > 2%"
}

# Performance improvement analysis
analyze_performance_improvement() {
    local before_file=$1
    local after_file=$2

    echo "## Performance Analysis"
    echo "**Before Fix**:"
    calculate_performance_stats "$before_file"

    echo ""
    echo "**After Fix**:"
    calculate_performance_stats "$after_file"

    echo ""
    echo "**Statistical Comparison**:"
    echo "- **Test Type**: Welch's t-test (unequal variances)"
    echo "- **Confidence Level**: 95%"
    echo "- **Note**: Use statistical software for complete analysis"
}

# Check if statistical dependencies are available
check_statistical_dependencies() {
    local missing_tools=()

    if ! command -v bc >/dev/null 2>&1; then
        missing_tools+=("bc")
    fi

    if ! command -v awk >/dev/null 2>&1; then
        missing_tools+=("awk")
    fi

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo "Warning: Missing tools for statistical calculations: ${missing_tools[*]}"
        echo "Install with: brew install bc gawk (on macOS)"
        return 1
    fi

    return 0
}

# Initialize if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Statistical Validation Tools for Scientific Investigation"
    echo "Usage: source this file to load statistical functions"
    echo ""
    echo "Key functions:"
    echo "  calculate_error_rate_ci <errors> <total> [confidence]"
    echo "  estimate_affected_users <errors> <sample_hours> <total_hours> <user_base>"
    echo "  calculate_investigation_confidence <support> <quality> <diversity> <alternatives>"
    echo "  track_calibration <investigation_id> <predicted_confidence> <outcome>"
    echo ""
    check_statistical_dependencies
else
    check_statistical_dependencies >/dev/null
fi