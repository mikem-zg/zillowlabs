## Scientific Method Framework Reference Guide

### Essential Commands Quick Reference

#### Core Investigation Commands
```bash
# Initialize investigation
init_scientific_investigation "ID: Description"

# Hypothesis management
register_hypothesis "h1" "Description" "priority"  # priority: high|medium|low
list_hypotheses                                    # Show current hypothesis registry
update_hypothesis_status "h1" "testing|confirmed|rejected"

# Evidence collection
collect_evidence "source" "description" "credibility/10"
validate_evidence --cross-reference=true --source-check=true

# Statistical validation
test_hypothesis "h1" --method="METHOD" --control="CONTROL"
validate_conclusion --confidence-interval=95 --bias-check=true
```

#### Framework Integration Commands
```bash
# Standalone scientific investigation
/scientific-method-framework --investigation_id="ZYN-10585"

# Enhanced support investigation
/support-investigation --scientific-mode=true --issue="ISSUE_ID"

# Enhanced development investigation
/development-investigation --experimental=true --task="TASK"

# Generate test cases from findings
generate_test_cases --hypothesis-driven=true --target="backend-test-development"
```

### Core Components Reference

#### 1. Hypothesis Management
- **Systematic Registration**: Track multiple competing hypotheses
- **Alternative Testing**: Ensure exploration of competing explanations
- **Success Metrics**: Quantify hypothesis validation success rates

#### 2. Evidence Evaluation Framework
- **Source Credibility Scoring**: Database (10/10), Logs (9/10), Code (7/10), Anecdotal (3/10)
- **Multi-source Validation**: Require corroboration across evidence types
- **Bias Detection**: Systematic checks for confirmation bias

#### 3. Statistical Validation
- **Confidence Intervals**: Quantify uncertainty in findings
- **Significance Testing**: Validate claims with statistical rigor
- **Effect Size Measurement**: Distinguish statistical from practical significance

#### 4. Controlled Experimentation
- **Staging Validation**: Reproduce findings in controlled environments
- **A/B Testing**: Compare solutions with statistical validation
- **Progressive Rollout**: Monitor implementation with automatic rollback

### Success Metrics

#### Investigation Quality Metrics
- **Hypothesis Success Rate**: % of investigations that test alternatives
- **Evidence Diversity**: Average number of independent evidence sources
- **Validation Rate**: % of findings validated in controlled environments
- **False Positive Rate**: % of conclusions later proven incorrect

#### Efficiency Metrics
- **Time to Resolution**: Scientific vs traditional investigation duration
- **Rework Rate**: % of fixes requiring additional investigation
- **Team Learning**: Knowledge transfer and pattern recognition improvement
- **Automation Rate**: % of routine validation automated

### Integration Standards

#### Framework Parameters
- `investigation_id`: Unique investigation identifier (e.g., "ZYN-10585", "auth-performance-analysis")
- `methodology`: Approach (hypothesis-driven, experimental-design, evidence-evaluation, statistical-validation)
- `confidence_level`: Statistical confidence percentage (default: 95%)
- `hypothesis_count`: Expected number of competing hypotheses (default: 3)
- `integration_mode`: Integration with other skills (standalone, support-investigation, development-investigation)

#### Evidence Quality Standards
| Source Type | Minimum Score | Required Validation |
|-------------|---------------|---------------------|
| Database/System Metrics | 9/10 | Automated collection with timestamps |
| Monitoring Dashboards | 8/10 | Cross-reference with raw metrics |
| Code Analysis | 6/10 | Version control correlation |
| User Reports | 5/10 | Multiple independent reports |
| Anecdotal | 3/10 | Requires higher-credibility corroboration |

#### Statistical Requirements
- **Minimum Confidence Level**: 95% for production decisions
- **Hypothesis Testing**: Minimum 3 competing hypotheses required
- **Evidence Sources**: Minimum 2 independent high-credibility sources
- **Controlled Validation**: Required for all production changes

### Troubleshooting Guide

#### Common Issues and Solutions

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Insufficient Hypotheses** | Single hypothesis investigation | Generate minimum 3 competing explanations |
| **Low Evidence Credibility** | Anecdotal evidence only | Seek database metrics and monitoring data |
| **Confirmation Bias** | Evidence supports only one hypothesis | Actively search for contradictory evidence |
| **Statistical Significance** | Inconclusive results | Increase sample size or extend observation period |
| **Staging Environment Mismatch** | Results don't reproduce in production | Validate environment parity and data differences |

#### Validation Checklist
- [ ] Investigation has unique ID and clear scope
- [ ] Minimum 3 competing hypotheses registered
- [ ] Evidence collected from multiple independent sources
- [ ] Credibility scores assigned to all evidence
- [ ] Hypothesis testing completed in controlled environment
- [ ] Statistical confidence meets minimum threshold (95%)
- [ ] Bias checks documented and addressed
- [ ] Alternative explanations explored and tested

### Best Practices

#### Investigation Setup
1. **Define Clear Scope**: Specific problem statement with measurable outcomes
2. **Generate Diverse Hypotheses**: Include infrastructure, code, and process explanations
3. **Plan Evidence Collection**: Identify sources before starting investigation
4. **Set Success Criteria**: Define what constitutes validated findings

#### Evidence Collection
1. **Prioritize High-Credibility Sources**: Start with database metrics and system logs
2. **Seek Independent Validation**: Multiple sources for critical evidence
3. **Document Timestamps**: Correlate evidence timing with incident timeline
4. **Score Consistently**: Use standardized credibility scale across team

#### Hypothesis Testing
1. **Test in Isolation**: Validate one hypothesis at a time when possible
2. **Use Controls**: Compare against known-good baseline
3. **Document Negative Results**: Record what was tested and disproven
4. **Quantify Confidence**: Provide statistical confidence for all conclusions

This reference guide provides the essential information for implementing systematic scientific methodology in software investigation and development workflows.