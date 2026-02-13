---
name: development-investigation
description: Systematic development investigation and architecture analysis workflow with evidence-based documentation, code pattern analysis, and structured implementation planning for FUB's Lithium framework development environment
---

## Overview

Systematic development investigation and architecture analysis workflow with evidence-based documentation, code pattern analysis, and structured implementation planning for FUB's Lithium framework development environment. Integrates with Serena MCP for semantic code analysis, providing systematic codebase investigation with clear fact/inference separation and structured implementation planning.

🔬 **Experimental Methods**: [methodologies/experimental-framework.md](methodologies/experimental-framework.md)
📋 **Investigation Templates**: [templates/investigation-patterns.md](templates/investigation-patterns.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
✅ **Quality Standards**: [reference/quality-standards.md](reference/quality-standards.md)

## Usage

```bash
/development-investigation --task=<description> [--scope=<scope>] [--context=<area>] [--experimental=<bool>] [--hypothesis_driven=<bool>] [--baseline_required=<bool>] [--a_b_validation=<bool>] [--confidence_threshold=<percentage>]
```

## Examples

### Standard Investigation Mode
```bash
# Architecture investigation for new feature
/development-investigation --task="Analyze MFA integration points in current auth system" --scope="architecture" --context="authentication"

# Performance analysis for optimization
/development-investigation --task="Investigate contact import bottlenecks" --scope="performance" --context="contact-import"

# Feature planning with framework analysis
/development-investigation --task="Plan real-time notifications implementation" --scope="feature-planning" --context="notifications"

# Refactoring investigation
/development-investigation --task="Analyze email parser architecture for modernization" --scope="refactoring" --context="email-parsing"

# Bug analysis in development context
/development-investigation --task="Investigate authentication session timeout issues" --scope="bug-analysis" --context="authentication"
```

### Experimental Investigation Mode
```bash
# Experimental architecture analysis with multiple approaches
/development-investigation --experimental=true --hypothesis_driven=true \
  --task="Design payment system architecture" --scope="architecture" --context="payments"

# Performance optimization with statistical validation
/development-investigation --experimental=true --baseline_required=true \
  --a_b_validation=true --task="Database query optimization" --scope="performance" --context="database-layer"

# Critical architecture decision with high confidence requirement
/development-investigation --experimental=true --hypothesis_driven=true \
  --confidence_threshold=85 --task="Authentication system redesign" --scope="architecture" --context="authentication"
```

## Quick Reference

| Investigation Type | Primary Tools | Key Outputs | Success Criteria |
|-------------------|---------------|-------------|------------------|
| **Architecture** | Serena MCP symbol analysis | System integration strategy | Clear integration approach, no conflicts |
| **Feature Planning** | Code pattern analysis | Implementation roadmap | Specific development approach, validation criteria |
| **Bug Analysis** | Code flow tracing | Root cause identification | Reproducible issue, targeted fix strategy |
| **Performance** | Query and code analysis | Optimization strategy | Measurable improvement targets, implementation plan |
| **Refactoring** | Legacy pattern analysis | Modernization plan | Migration strategy, backwards compatibility plan |

## Preconditions

- FUB development environment access with Serena MCP semantic tools
- Access to investigation notebook directory structure (`/Users/matttu/Documents/Work/FUB/notebook/development/`)
- Understanding of FUB Lithium framework patterns and coding standards
- Task tracking integration for systematic investigation progress
- Development context differentiation from production support investigation

## Core Workflow

When invoked, execute this systematic development investigation workflow:

### 1. Investigation Setup and Context Establishment

**Create structured documentation environment:**
```bash
# Phase 1: Investigation Directory Structure
TASK_DATE=$(date +%Y-%m-%d)
TASK_NAME=$(echo "$task" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]')
INVESTIGATION_DIR="/Users/matttu/Documents/Work/FUB/notebook/development/${TASK_DATE}-${TASK_NAME}"

mkdir -p "$INVESTIGATION_DIR"
cd "$INVESTIGATION_DIR"

# Initialize investigation files
touch investigation.md architecture-analysis.md implementation-plan.md validation-criteria.md

# Phase 2: Task Tracking Integration
TaskCreate --subject="Development investigation: [$task]" \
           --description="Systematic investigation and analysis for development task. Success: Clear architectural understanding, documented implementation approach, validation criteria established." \
           --activeForm="Investigating development requirements"
```

**Experimental Framework Integration** (if --experimental=true):
→ **Complete setup guide**: [methodologies/experimental-framework.md](methodologies/experimental-framework.md)

### 2. Codebase Analysis and Pattern Discovery

**Use semantic tools for systematic code exploration:**
```bash
# Core semantic analysis workflow
analyze_codebase() {
    local analysis_scope="$1"
    local context_area="$2"

    # Serena MCP semantic analysis
    serena-mcp --task="Analyze $context_area patterns and structure" --scope="$analysis_scope"

    # Framework pattern identification
    identify_lithium_patterns "$context_area"

    # Integration point mapping
    map_system_integrations "$context_area"
}
```

### 3. Framework Pattern Analysis

**Document FUB Lithium framework usage patterns:**
- ActiveRecord usage patterns and relationship mappings
- Controller structure and naming conventions
- Namespace organization and import patterns
- Performance optimization opportunities
- Security implementation patterns

→ **Detailed analysis templates**: [templates/investigation-patterns.md](templates/investigation-patterns.md)

### 4. Evidence-Based Implementation Planning

**Structured approach to development execution:**
```bash
# Generate implementation plan
create_implementation_plan() {
    local investigation_findings="$1"
    local scope="$2"

    # Technical approach definition
    document_technical_approach "$investigation_findings" "$scope"

    # Implementation steps with dependencies
    create_dependency_ordered_tasks "$investigation_findings"

    # Framework integration strategy
    plan_lithium_integration "$investigation_findings"

    # Validation criteria establishment
    define_success_criteria "$investigation_findings"
}
```

### 5. Investigation Type Routing

**Route to Specialized Investigation Patterns:**
```bash
case "$scope" in
    "architecture")
        → templates/investigation-patterns.md#architecture-investigation-template
        ;;
    "performance")
        → templates/investigation-patterns.md#performance-investigation-template
        ;;
    "bug-analysis")
        → templates/investigation-patterns.md#bug-analysis-investigation-template
        ;;
    "feature-planning")
        → templates/investigation-patterns.md#feature-planning-investigation-template
        ;;
    "refactoring")
        → templates/investigation-patterns.md#refactoring-investigation-template
        ;;
esac
```

### 6. Cross-Skill Integration Handoff

**Seamless transition to development execution:**
- Document investigation findings for development handoff
- Create development tasks based on investigation analysis
- Establish validation criteria for implementation verification
- Provide framework-specific guidance for FUB patterns

→ **Complete integration guide**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Progressive Investigation Framework

### Level 1: Standard Investigation (Most Common - 85% of Usage)

**Quick Architecture Analysis:**
```bash
# Standard investigation workflow
/development-investigation --task="Feature requirements analysis" --scope="feature-planning"

# Performance bottleneck identification
/development-investigation --task="Query optimization analysis" --scope="performance" --context="database-layer"

# Bug root cause analysis
/development-investigation --task="Authentication issue investigation" --scope="bug-analysis" --context="authentication"
```

### Level 2: Comprehensive Analysis (Medium Complexity)

**Framework Pattern Analysis:**
- **ActiveRecord Usage**: Relationship patterns and query optimization
- **Controller Organization**: Structure and naming convention compliance
- **Integration Patterns**: External system connection analysis
- **Security Implementation**: Authentication and authorization patterns

→ **Pattern analysis templates**: [templates/investigation-patterns.md](templates/investigation-patterns.md)

### Level 3: Experimental Investigation (Advanced)

**Hypothesis-Driven Architecture Exploration:**
- **Multiple Architectural Approaches**: Systematic comparison of competing solutions
- **Statistical Validation**: Quantitative confidence in architecture decisions
- **Baseline Measurement**: Performance impact assessment
- **A/B Testing Integration**: Controlled validation of architectural changes

→ **Experimental methodology**: [methodologies/experimental-framework.md](methodologies/experimental-framework.md)

## Integration Patterns

### Pre-Development Investigation Workflow
```bash
# Complex feature investigation → development execution
/development-investigation --task="Analyze contact export feature requirements" --scope="feature-planning"
/code-development --task="Implement contact export based on investigation plan" --scope="small-feature"
/backend-test-development --target="ContactExportFeature" --test_type="comprehensive"
```

### Bug Resolution Investigation Workflow
```bash
# Development-side bug investigation → targeted fix
/development-investigation --task="Investigate auth session timeout bug" --scope="bug-analysis" --context="authentication"
/code-development --task="Fix authentication session timeout" --scope="bug-fix"
/backend-test-development --target="AuthSessionTest" --test_type="regression"
```

### Architecture Planning Workflow
```bash
# Large refactoring investigation → structured implementation
/development-investigation --task="Analyze email parser modernization" --scope="refactoring" --context="email-parsing"
/code-development --task="Modernize email parser architecture" --scope="large-refactoring"
/backend-test-development --target="EmailParserModernization" --test_type="integration"
```

## Quality Assurance Standards

### Investigation Documentation Requirements
- **Code Reference Precision**: Include exact file paths and line numbers (e.g., `ContactsController.php:142`)
- **Framework Pattern Documentation**: Record Lithium framework usage patterns
- **Fact vs Inference Separation**: Clear labeling of speculation as "(Inference)"
- **Performance Measurements**: Specific metrics and benchmarks
- **Integration Mapping**: Document dependencies and external system connections

### Investigation Validation Checklist
- [ ] Investigation scope clearly defined and achievable
- [ ] Code analysis includes specific file:line references
- [ ] Framework patterns analyzed for Lithium compliance
- [ ] Implementation recommendations include technical approaches
- [ ] Validation criteria established with measurable metrics
- [ ] Cross-skill handoff information documented
- [ ] All speculation marked as "(Inference)" with reasoning
- [ ] Performance considerations documented with metrics

→ **Complete quality standards**: [reference/quality-standards.md](reference/quality-standards.md)

## Advanced Patterns

<details>
<summary>Click to expand advanced development investigation techniques and enterprise-scale analysis</summary>

### Enterprise-Scale Architecture Investigation

**Multi-System Integration Analysis:**
Complex investigations spanning multiple microservices, API boundaries, and external integrations require advanced dependency mapping, cross-system impact analysis, and distributed architecture validation.

**Legacy Modernization Planning:**
Advanced patterns for systematic legacy system analysis with migration risk assessment, compatibility matrix development, and phased modernization roadmap creation.

**Performance at Scale Investigation:**
Enterprise-level performance analysis requiring advanced profiling techniques, distributed system bottleneck identification, and scalability constraint analysis with quantitative validation.

### Advanced Experimental Methodologies

**Hypothesis-Driven Architecture Exploration:**
Sophisticated experimental frameworks for evaluating competing architectural approaches with statistical validation, A/B testing integration, and quantitative decision criteria.

**Statistical Architecture Validation:**
Advanced statistical methods for architecture decision-making including confidence intervals, hypothesis testing, and risk-based architecture selection with measurable outcomes.

🚀 **Complete advanced patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔬 **Experimental methodology**: [methodologies/experimental-framework.md](methodologies/experimental-framework.md)

</details>

## Cross-Skill Integration Points

### Primary Integration Relationships

| Related Skill | Integration Type | Investigation Workflows |
|---------------|------------------|------------------------|
| `code-development` | **Implementation Execution** | Architecture analysis → Development → Validation |
| `serena-mcp` | **Code Analysis Foundation** | Semantic analysis → Architecture understanding → Planning |
| `backend-test-development` | **Validation Strategy** | Investigation criteria → Test requirements → Implementation validation |
| `support-investigation` | **Cross-Context Analysis** | Production analysis → Development investigation → Resolution |
| `database-operations` | **Data Layer Investigation** | Database patterns → Query optimization → Schema planning |
| `planning-workflow` | **Structured Investigation** | Investigation planning → Execution → Accountability |

### Multi-Skill Operation Examples

**Production Issue → Development Investigation → Resolution:**
```bash
/support-investigation --issue="Contact import failures" --environment="production"
/development-investigation --task="Investigate contact import architecture" --scope="bug-analysis"
/code-development --task="Fix contact import based on findings" --scope="bug-fix"
```

**Feature Development with Investigation:**
```bash
/development-investigation --task="Analyze real-time notifications architecture" --scope="feature-planning"
/code-development --task="Implement notifications following investigation" --scope="small-feature"
/backend-test-development --target="NotificationSystem" --test_type="integration"
```

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Refusal Conditions

The skill must refuse if:
- Investigation scope is too broad or undefined for systematic analysis
- Required development environment access or tools are not available
- Investigation task lacks sufficient context for meaningful code analysis
- Requested analysis exceeds reasonable investigation boundaries
- Framework or codebase access is not properly configured
- Investigation would require access to unauthorized systems or data

When refusing, provide specific guidance on:
- How to refine investigation scope for effective analysis
- Steps to verify development environment access and tool configuration
- Alternative investigation approaches within scope and access limits
- Resources for obtaining proper development environment access
- Clarification needed for meaningful architectural analysis

**Investigation Principle**: Development investigations prioritize systematic architecture analysis, evidence-based planning, and structured development execution. When uncertain about code patterns, framework compliance, or implementation approaches, always err on the side of thorough analysis and seek verification before making recommendations that could impact system architecture or development direction.