## Cross-Skill Integration Workflows and Coordination Patterns

### Cross-Skill Workflow Integration

| Related Skill | Integration Type | Common Workflow Patterns |
|---------------|------------------|---------------------------|
| **`support-investigation`** | **Enhanced Investigation** | Scientific hypothesis tracking → Evidence collection → Controlled validation |
| **`development-investigation`** | **Experimental Development** | Architecture analysis → A/B testing → Data-driven decisions |
| **`backend-test-development`** | **Hypothesis-Driven Testing** | Scientific findings → Reproducible test cases → Validation protocols |
| **`database-operations`** | **Controlled Experiments** | Database optimization hypotheses → Staged testing → Statistical validation |
| **`datadog-management`** | **Evidence Collection** | Metric-based evidence → Statistical analysis → Confidence intervals |
| **`code-development`** | **Scientific Development** | Feature hypotheses → Controlled rollouts → Outcome measurement |

### Multi-Skill Operation Examples

**Scientific Support Investigation:**
```bash
# Enhanced investigation with systematic methodology
claude /support-investigation --scientific-mode=true --issue="ZYN-10585" |\
claude /scientific-method-framework --investigation_id="ZYN-10585" --methodology="hypothesis-driven" |\
claude /backend-test-development --reproduce=true --hypothesis-based=true |\
claude /datadog-management --track-experiment=true --statistical-validation=true
```

**Experimental Development Process:**
```bash
# Hypothesis-driven feature development
claude /scientific-method-framework --methodology="experimental-design" --hypothesis_count=3 |\
claude /development-investigation --experimental=true --task="performance optimization" |\
claude /code-development --a-b-test=true --metrics="response_time" |\
claude /database-operations --staged-rollout=true --success-criteria="<500ms"
```

**Production Experiment Validation:**
```bash
# Controlled production testing with scientific validation
claude /scientific-method-framework --methodology="statistical-validation" --confidence_level=95 |\
claude /datadog-management --experiment-tracking=true --significance-testing=true |\
claude /backend-test-development --validation-suite=true --control-group=true
```

### Workflow Handoff Patterns

**To scientific-method-framework ← From Other Skills:**
- **`support-investigation`**: Provides incident details requiring systematic analysis
- **`development-investigation`**: Supplies architectural questions needing experimental validation
- **`planning-workflow`**: Delivers feature requirements for hypothesis-driven development

**From scientific-method-framework → To Other Skills:**
- **`backend-test-development`**: Supplies validated hypotheses for reproducible test case generation
- **`code-development`**: Provides experimental design for controlled feature rollouts
- **`datadog-management`**: Delivers statistical requirements for experiment monitoring

### Integration Architecture

**Investigation Enhancement Framework:**
1. **Hypothesis Registry**: Systematic tracking of alternative explanations
2. **Evidence Matrix**: Multi-source validation with credibility scoring
3. **Statistical Validation**: Confidence intervals and bias checks
4. **Experimental Design**: Controlled testing protocols

**Development Process Integration:**
- **Feature Development**: Hypothesis-driven feature design with A/B testing
- **Performance Optimization**: Systematic optimization with statistical validation
- **Architecture Decisions**: Evidence-based architecture choices with controlled experiments
- **Production Rollouts**: Scientific validation before full deployment

**Team Collaboration Framework:**
- **Cross-functional Evidence**: Multiple teams contribute domain-specific evidence
- **Structured Decision Making**: Hypothesis voting and consensus building
- **Knowledge Sharing**: Investigation pattern library and best practices documentation
- **Continuous Learning**: Outcome tracking and methodology improvement

### Integration with Support Investigation

Enhances existing workflow with:
- Systematic hypothesis documentation in investigation.md
- Evidence credibility scoring for production impact analysis
- Statistical confidence intervals for user impact estimates
- Controlled testing in QA environment before production fixes

### Integration with Development Investigation

Adds scientific rigor to:
- Architectural analysis with hypothesis-driven exploration
- Performance optimization with controlled A/B testing
- Code pattern analysis with quantitative validation
- Implementation planning with experimental design

### Integration with Testing Skills

Enables scientific handoffs:
```bash
# Generate hypothesis-driven test cases
scientific_investigation_findings | /backend-test-development --reproduce=true

# Create controlled validation experiments
experimental_plan | /database-operations --a-b-test=true --metrics="response_time"

# Monitor experimental rollouts
rollout_plan | /datadog-management --track-experiment=true --significance-test=95%
```

### Framework Integration Commands

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

This framework transforms ad-hoc investigation into systematic scientific inquiry while preserving the speed and practicality required for production incident response and development workflows.