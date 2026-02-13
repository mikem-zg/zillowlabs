## Quality Assurance Standards

### Investigation Documentation Requirements

**Code Reference Precision:**
- Include exact file paths and line numbers (e.g., `ContactsController.php:142`)
- Reference specific function names and class methods
- Document code patterns with actual code snippets
- Link related code sections across files

**Framework Pattern Documentation:**
- Record Lithium framework usage patterns and compliance
- Document ActiveRecord relationship patterns
- Identify controller and service layer organization
- Note namespace and import pattern consistency

**Fact vs Inference Separation:**
- Mark all speculation clearly as "(Inference)" with supporting reasoning
- Separate direct code analysis from interpretation
- Document assumptions and their basis
- Provide evidence for architectural conclusions

**Performance Measurements:**
- Include specific metrics and benchmarks where available
- Document query execution times and resource usage
- Provide baseline measurements for comparison
- Quantify performance improvements or degradations

**Integration Mapping:**
- Document all system dependencies and external connections
- Map API endpoints and data exchange patterns
- Identify authentication and authorization touch points
- Record configuration dependencies and environment requirements

### Evidence Collection Standards

**Required Investigation Evidence:**

**Code Samples:**
```markdown
# Code Analysis Evidence Format
**File**: `path/to/file.php:line_number`
**Pattern**: [Framework pattern or architectural pattern]
**Code Sample**:
```php
// Actual code snippet with syntax highlighting
class ExampleController extends BaseController {
    public function exampleMethod() {
        // Relevant code section
    }
}
\```
**Analysis**: [What this code reveals about architecture/patterns]
**Implications**: [Impact on investigation findings]
```

**Architecture Analysis:**
- System interaction patterns and service boundaries
- Data flow diagrams and component relationships
- Integration patterns and external system connections
- Framework compliance and pattern adherence

**Query Examples:**
```markdown
# Database Query Analysis Format
**Query Type**: [SELECT/INSERT/UPDATE/DELETE, or ActiveRecord method]
**Performance**: [Execution time, row count, index usage]
**Query**:
```sql
-- Actual query with proper formatting
SELECT c.*, u.name
FROM contacts c
JOIN users u ON c.user_id = u.id
WHERE c.status = 'active'
\```
**Analysis**: [Performance characteristics, optimization opportunities]
**Framework Pattern**: [ActiveRecord usage pattern]
```

**Performance Data:**
- Specific execution times and resource consumption metrics
- Memory usage patterns and allocation analysis
- Database query performance and optimization opportunities
- Framework overhead and efficiency measurements

**Framework Compliance:**
- Lithium pattern adherence assessment
- Naming convention compliance
- Project structure and organization validation
- Security pattern implementation verification

### Investigation Validation Checklist

**Scope and Planning:**
- [ ] Investigation scope clearly defined and achievable
- [ ] Success criteria established with measurable outcomes
- [ ] Timeline and resource requirements documented
- [ ] Cross-skill integration requirements identified

**Code Analysis Quality:**
- [ ] Code analysis includes specific file:line references
- [ ] Framework patterns analyzed for Lithium compliance
- [ ] All code samples include proper syntax highlighting
- [ ] Related code sections linked and cross-referenced

**Architecture Documentation:**
- [ ] System integration points documented with evidence
- [ ] Framework usage patterns recorded with examples
- [ ] Performance characteristics quantified where possible
- [ ] Security implications assessed and documented

**Implementation Guidance:**
- [ ] Implementation recommendations include technical approaches
- [ ] Validation criteria established with measurable metrics
- [ ] Testing strategy defined with specific requirements
- [ ] Cross-skill handoff information documented and clear

**Scientific Rigor:**
- [ ] All speculation marked as "(Inference)" with reasoning
- [ ] Evidence-based conclusions with supporting data
- [ ] Alternative approaches considered and compared
- [ ] Assumptions documented with validation approaches

**Cross-Skill Integration:**
- [ ] Handoff requirements clearly documented
- [ ] Dependencies on other skills identified
- [ ] Integration workflows tested and validated
- [ ] Communication requirements established

### Documentation Quality Standards

**Investigation Report Structure:**
```markdown
# Investigation Report Template

## Executive Summary
**Investigation Goal**: [Clear statement of investigation purpose]
**Key Findings**: [3-5 bullet points of major discoveries]
**Recommendations**: [Specific actionable recommendations]
**Confidence Level**: [High/Medium/Low with supporting reasoning]

## Investigation Details
### Scope and Methodology
**Investigation Approach**: [Tools and methods used]
**Code Areas Analyzed**: [Specific files and components examined]
**Framework Analysis**: [Lithium pattern compliance assessment]
**Performance Analysis**: [Metrics and measurements taken]

### Findings and Evidence
**Code Analysis**: [Detailed findings with file:line references]
**Architecture Patterns**: [Framework usage and architectural patterns]
**Integration Points**: [System integration analysis]
**Performance Characteristics**: [Quantified performance analysis]

### Recommendations and Implementation
**Technical Approach**: [Specific implementation strategy]
**Validation Criteria**: [How to measure success]
**Testing Strategy**: [Required testing approach]
**Cross-Skill Integration**: [Handoff requirements and dependencies]
```

**Code Documentation Standards:**
- All code references must include file paths and line numbers
- Code samples must be properly formatted with syntax highlighting
- Related code sections should be linked and cross-referenced
- Framework patterns must be explicitly identified and documented

**Performance Documentation Standards:**
- All performance claims must be supported by specific measurements
- Baseline performance must be established before optimization recommendations
- Performance improvement estimates must include confidence intervals
- Resource usage patterns must be quantified where possible

### Experimental Investigation Quality Standards

**Hypothesis Formation:**
- [ ] Multiple competing hypotheses registered (minimum 2 for complex decisions)
- [ ] Each hypothesis clearly stated with specific architectural approach
- [ ] Priority levels assigned based on initial analysis
- [ ] Success criteria defined for each hypothesis

**Evidence Collection:**
- [ ] Evidence credibility scores assigned based on analysis type
- [ ] Supporting and contradicting evidence documented for each hypothesis
- [ ] Evidence sources clearly identified and validated
- [ ] Statistical significance assessed where applicable

**Statistical Validation:**
- [ ] Confidence intervals calculated for architecture decisions
- [ ] Baseline measurements established before recommendations
- [ ] A/B testing framework setup for critical architectural changes
- [ ] Bias assessment conducted for investigation conclusions

**Calibration and Follow-up:**
- [ ] Prediction confidence recorded for future calibration
- [ ] Success tracking mechanism established
- [ ] Learning feedback loop implemented
- [ ] Decision outcome tracking prepared

### Integration Quality Standards

**Cross-Skill Handoff Quality:**
- All handoff requirements clearly documented with specific deliverables
- Integration dependencies explicitly identified and validated
- Communication protocols established with other skill teams
- Success criteria for handoff completion defined and measurable

**Multi-Skill Workflow Validation:**
- Workflow dependencies tested and validated
- Resource requirements communicated across skills
- Timeline coordination established with dependent skills
- Quality gates implemented at each workflow transition

**Documentation Integration Standards:**
- All investigation documentation accessible to downstream skills
- Standard formats used for cross-skill communication
- Version control implemented for shared investigation assets
- Archive and retrieval system established for investigation history

### Continuous Improvement Standards

**Investigation Process Improvement:**
- [ ] Investigation methodology effectiveness tracked
- [ ] Tool usage efficiency measured and optimized
- [ ] Framework pattern analysis accuracy validated
- [ ] Cross-skill integration effectiveness assessed

**Quality Metrics Tracking:**
- [ ] Investigation completion rate and timeline adherence
- [ ] Accuracy of implementation predictions
- [ ] Effectiveness of architectural recommendations
- [ ] Cross-skill handoff success rate

**Learning and Calibration:**
- [ ] Decision accuracy tracking for calibration improvement
- [ ] Investigation pattern effectiveness analysis
- [ ] Tool and methodology refinement based on outcomes
- [ ] Cross-skill coordination improvement based on feedback