## Scientific Methodology Templates and Patterns

### Hypothesis Registry Template
```markdown
## Hypothesis Registry - [Investigation ID]

| ID | Hypothesis | Priority | Evidence For | Evidence Against | Status | Confidence |
|----|-----------|----------|-------------|-----------------|--------|------------|
| h1 | Database timeout | High | Connection metrics | No user reports | Testing | 75% |
| h2 | API changes | Medium | Timeline correlation | No deployment logs | Tested | 40% |
| h3 | Config drift | Low | Environment diff | Recent validation | Rejected | 15% |

### Active Testing
- **Current Focus**: h1 (Database timeout)
- **Method**: Staging reproduction with load testing
- **Expected Completion**: 2024-01-15 16:00 UTC
```

### Evidence Collection Matrix
```markdown
## Evidence Matrix - [Investigation ID]

| Source | Evidence | Credibility | Supports | Contradicts | Weight |
|--------|----------|-------------|----------|-------------|--------|
| Datadog | Error spike 14:30 UTC | 9/10 | h1, h2 | h3 | High |
| Database | Connection pool metrics | 10/10 | h1 | h2 | Critical |
| Code | Recent deployments | 7/10 | h2 | h1 | Medium |
| User Reports | Timing correlation | 6/10 | h1 | - | Medium |

### Statistical Summary
- **Total Evidence Points**: 32/40
- **Credibility Weighted Score**: 8.2/10
- **Hypothesis Support**: h1 (85%), h2 (45%), h3 (10%)
```

### Evidence Credibility Scale

| Source Type | Score | Examples | Usage Guidelines |
|------------|-------|----------|------------------|
| **Database/System Metrics** | 10/10 | Query performance, error rates | Primary evidence for technical issues |
| **Monitoring Dashboards** | 9/10 | Datadog alerts, performance graphs | Strong supporting evidence |
| **Code Analysis** | 7/10 | Recent deployments, configuration changes | Good for correlation analysis |
| **User Reports** | 6/10 | Support tickets with timing data | Useful for impact validation |
| **Anecdotal Observations** | 3/10 | "It seems slower", team discussions | Requires validation with higher-credibility sources |

### Scientific Investigation Checklist

**Before Starting:**
- [ ] Define investigation ID and scope
- [ ] Identify minimum 3 competing hypotheses
- [ ] Plan evidence collection strategy
- [ ] Set up tracking templates

**During Investigation:**
- [ ] Collect evidence from multiple independent sources
- [ ] Score credibility for each piece of evidence
- [ ] Test hypotheses in controlled environment (staging/QA)
- [ ] Document bias checks and alternative explanations tested

**Before Concluding:**
- [ ] Validate findings with statistical confidence (≥95%)
- [ ] Cross-check evidence for consistency
- [ ] Plan controlled rollout with monitoring
- [ ] Generate actionable recommendations with uncertainty quantified

### Template Quick Start
```bash
# Copy investigation templates
cp ~/.claude/skills/scientific-method-framework/templates/hypothesis-registry.md ./investigation-hypothesis.md
cp ~/.claude/skills/scientific-method-framework/templates/evidence-matrix.md ./investigation-evidence.md

# Load framework utilities
source ~/.claude/skills/scientific-method-framework/scripts/core-functions.sh

# Initialize with templates
init_scientific_investigation "$(cat investigation-brief.md)"
```

### Common Investigation Patterns

**Production Issue Investigation:**
1. Register 3+ hypotheses (infrastructure, code, external)
2. Collect evidence (metrics + logs + code + user reports)
3. Test in staging with controlled reproduction
4. Validate with 95% confidence before production fix

**Performance Optimization:**
1. Baseline measurement with statistical significance
2. Hypothesis-driven optimization approaches
3. A/B testing with proper controls
4. Progressive rollout with automatic rollback

**Architecture Analysis:**
1. Alternative design approaches as competing hypotheses
2. Evidence from performance testing, maintainability analysis
3. Controlled pilot implementation
4. Data-driven architecture decisions

### Files Structure Reference

```
scientific-method-framework/
├── SKILL.md                          # Main framework overview
├── scripts/
│   └── core-functions.sh             # Reusable bash utilities
├── methodology/
│   ├── hypothesis-management.md      # Systematic hypothesis tracking
│   ├── evidence-evaluation.md        # Evidence credibility framework
│   ├── statistical-validation.md     # Quantitative analysis patterns
│   └── experimental-design.md        # Controlled experiment protocols
├── templates/
│   ├── hypothesis-registry.md        # Ready-to-use hypothesis template
│   ├── evidence-matrix.md           # Evidence collection template
│   ├── experimental-plan.md         # Experiment design template
│   └── validation-report.md         # Statistical validation template
└── integration-patterns/
    ├── support-investigation.md      # Support workflow integration
    ├── development-investigation.md  # Development workflow integration
    └── testing-integration.md       # Testing skill handoff patterns
```

This template library provides the foundation for systematic scientific investigation in software development and incident response workflows.