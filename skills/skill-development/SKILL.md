---
name: skill-development
description: Comprehensive skill development from creation through maintenance, including progressive disclosure standards, quality validation, and optimization tooling. Use for creating new skills, maintaining existing skills, or validating skill quality and structure.
argument-hint: [operation] [skill-name]
allowed-tools: Write, Read, Edit, Bash, Glob, Grep
---

## Overview

Comprehensive skill development lifecycle management from creation through maintenance, including progressive disclosure standards, quality validation, and optimization tooling. Provides unified workflows for creating new Claude Code skills, maintaining existing skills, and validating skill quality and structure.

## Usage

```bash
# Skill creation operations
/skill-development create [skill-name] [description]
/skill-development template [skill-type] [skill-name]

# Maintenance operations
/skill-development validate [skill-name]
/skill-development optimize [skill-name]
/skill-development lint [scope]

# Quality assurance operations
/skill-development audit [scope]
/skill-development metrics [skill-name]
/skill-development compliance [skill-name]
```

## Core Workflow

### 1. Skill Creation Process (Primary - 60% Usage)

**Essential Creation Steps:**
1. **Project Setup and Discovery**
   ```bash
   # Detect Claude Code directory structure
   ls -la ./.claude/skills/ 2>/dev/null || ls -la ~/.claude/skills/ 2>/dev/null

   # Create skill directory
   mkdir -p [claude-dir]/skills/[skill-name]
   cd [claude-dir]/skills/[skill-name]
   ```

2. **Evaluation-First Development**
   ```bash
   # Create test scenarios BEFORE extensive documentation
   echo "Test scenarios that prove skill effectiveness" > evaluations.md

   # Establish baseline: Run Claude on tasks WITHOUT skill
   # Document specific failures and gaps
   ```

3. **Minimal SKILL.md Creation**
   ```yaml
   ---
   name: skill-name
   description: Clear description with usage trigger (max 1024 chars)
   ---

   ## Overview
   [2-3 sentences: What it does, when to use it]

   ## Usage
   ```bash
   /skill-name [arguments]
   ```

   ## Core Workflow
   [50-100 lines: Essential steps only]
   ```

4. **Progressive Content Development**
   - Start with Core Workflow (essential steps, 50-100 lines)
   - Add Quick Reference (common patterns, 100-200 lines)
   - Build Advanced Patterns as needed (200-400 lines)
   - Document Integration Points (cross-skill workflows, 100-200 lines)

5. **Quality Validation**
   ```bash
   # Structure validation
   /skill-development validate [skill-name]

   # Content quality check
   /skill-development lint [skill-name]

   # Performance assessment
   /skill-development metrics [skill-name]
   ```

**Complete Creation Workflow:** See [creation/workflows.md](creation/workflows.md)

### 2. Quality Validation and Maintenance (Secondary - 25% Usage)

**Essential Validation Steps:**
1. **Structure Assessment**
   - Verify progressive disclosure sections present
   - Check Core Workflow → Quick Reference → Advanced Patterns → Integration Points
   - Validate section length guidelines (Core: 50-100 lines, etc.)

2. **Content Quality Check**
   - Verify Overview explains purpose in 2-3 sentences
   - Ensure Usage section shows exact invocation syntax
   - Check Examples use real FUB codebase paths/classes
   - Validate all file paths use backticks

3. **Cross-Reference Validation**
   - Check skill references (`/skill-name`) exist
   - Verify Integration Points are bidirectional
   - Validate workflow chains are accurate
   - Ensure skill reference formatting follows standards

4. **Performance Optimization**
   - Measure section balance and information density
   - Identify sections that may cause context bloat
   - Validate essential information placement

**Complete Validation Guidelines:** See [maintenance/validation-checklists.md](maintenance/validation-checklists.md)

### 3. Standards Compliance and Optimization (Supporting - 15% Usage)

**Progressive Disclosure Standards:**
- **Section Length Targets**: Core Workflow (50-100), Quick Reference (100-200), Advanced Patterns (200-400), Integration Points (100-200)
- **Content Stratification**: Tier 1 (daily operations), Tier 2 (common scenarios), Tier 3 (complex edge cases), Tier 4 (integration)
- **File Organization**: Main SKILL.md under 500 lines, detailed content in support files

**Quality Assurance Framework:**
- Pre-creation: Gap identification, evaluation scenarios, baseline testing
- During creation: Structure validation, progressive disclosure, token efficiency
- Post-creation: Model testing (Haiku/Sonnet/Opus), integration validation, performance metrics

**Complete Standards Reference:** See [standards/progressive-disclosure.md](standards/progressive-disclosure.md)

## Quick Reference

### Common Operations

**Create New Skill:**
```bash
# Basic skill creation
/skill-development create api-integration "REST API integration patterns"

# From template
/skill-development template workflow email-processing "Email processing workflows"
```

**Validate Existing Skills:**
```bash
# Single skill validation
/skill-development validate email-processing

# Comprehensive audit
/skill-development audit all-skills

# Performance metrics
/skill-development metrics email-processing
```

**Maintenance Operations:**
```bash
# Structure and content optimization
/skill-development optimize email-processing

# Code quality and formatting
/skill-development lint email-processing

# FUB accuracy validation
/skill-development compliance email-processing
```

### Skill Templates

| Template Type | Use Case | Key Features |
|---------------|----------|--------------|
| **minimal** | Simple instructions, no scripts | Basic SKILL.md only |
| **workflow** | Multi-step processes | Checklists, validation steps |
| **knowledge** | Domain expertise | Reference files, auto-discovery |
| **integration** | External tools/APIs | Scripts, error handling, MCP |

**Template Details:** See [templates/](templates/)

### Validation Checklists

**Pre-Creation Checklist:**
- [ ] Identified clear usage gap requiring skill
- [ ] Created 3+ evaluation scenarios
- [ ] Tested baseline Claude performance

**Post-Creation Checklist:**
- [ ] Overview explains purpose in 2-3 sentences
- [ ] Usage section shows exact invocation
- [ ] Progressive disclosure applied correctly
- [ ] Tested with Haiku, Sonnet, Opus
- [ ] Integration points documented

**Complete Checklists:** See [maintenance/validation-checklists.md](maintenance/validation-checklists.md)

### Essential Scripts

```bash
# Structure validation
./scripts/validate-structure.sh [skill-name]

# Content linting and formatting
./scripts/lint-and-format.sh [skill-name]

# Performance analysis
./scripts/performance-analysis.sh [skill-name]

# Create skill from template
./scripts/create-skill-template.sh [template-type] [skill-name]
```

## Advanced Patterns

### Evaluation-Driven Development Methodology

**Build evaluations BEFORE writing extensive documentation** to ensure skills solve real problems:

1. **Identify Gaps**: Run Claude on representative tasks without skill, document failures
2. **Create Evaluations**: Build 3+ scenarios testing these gaps
3. **Establish Baseline**: Measure Claude performance without skill
4. **Write Minimal Instructions**: Create just enough content to pass evaluations
5. **Iterate**: Execute evaluations, compare against baseline, refine

**Evaluation Structure:**
```json
{
  "skills": ["skill-name"],
  "query": "Representative user request",
  "files": ["test-files/input.txt"],
  "expected_behavior": [
    "Specific success criteria (not implementation details)"
  ]
}
```

**Advanced Evaluation Patterns:** See [creation/evaluation-patterns.md](creation/evaluation-patterns.md)

### Complex Skill Architecture

**Content Stratification for Large Skills:**
- Tier 1: Essential daily operations (Core Workflow)
- Tier 2: Common scenarios and troubleshooting (Quick Reference)
- Tier 3: Complex edge cases and advanced techniques (Advanced Patterns)
- Tier 4: Integration coordination (Integration Points)

**Supporting File Organization:**
```
complex-skill/
├── SKILL.md                    # Main instructions (required, <500 lines)
├── reference/
│   ├── api-documentation.md    # Detailed API reference
│   └── troubleshooting.md      # Common issues and solutions
├── templates/
│   └── component.tsx          # Code templates
├── examples/
│   └── sample-workflow.md     # Usage examples
└── scripts/
    └── validate.sh           # Utility scripts
```

**Advanced Architecture Patterns:** See [standards/structure-validation.md](standards/structure-validation.md)

### Performance Optimization Strategies

**Progressive Disclosure Optimization:**
1. **Dynamic Content Loading**: Structure content for contextual relevance
2. **Token Efficiency**: Challenge every paragraph for necessity
3. **Cross-Skill Coordination**: Optimize handoff points between skills

**Session Context Management:**
- Skill invocation patterns for minimal context bloat
- Information layering reduces unnecessary loading
- Workflow coordination for efficient multi-skill operations

**Performance Guidelines:** See [maintenance/performance-optimization.md](maintenance/performance-optimization.md)

### Quality Assurance Automation

**Automated Validation Pipeline:**
```bash
# Comprehensive skill health check
./scripts/validate-structure.sh all-skills
./scripts/lint-and-format.sh check
./scripts/performance-analysis.sh generate-report
```

**Continuous Integration Patterns:**
- Pre-commit hooks for structure validation
- Scheduled maintenance runs
- FUB codebase synchronization triggers
- Usage pattern analysis and optimization

**Automation Setup:** See [scripts/](scripts/)

## Integration Points

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `text-manipulation` | **Pattern Analysis** | Extract patterns → Create skill templates → Validate references |
| `markdown-management` | **Documentation Quality** | Create documentation → Lint and format → Ensure compliance |
| `code-development` | **Implementation Support** | Package patterns → Create skills → Validate standards |
| `documentation-retrieval` | **Research Integration** | Research practices → Create domain skills → Document patterns |

#### Multi-Skill Operation Examples

**Complete Skill Development Workflow:**
```bash
# Research-driven skill creation with quality validation
/documentation-retrieval --query="API integration best practices" |\
  /skill-development create api-integration "API integration with error handling" |\
  /skill-development validate api-integration |\
  /markdown-management --operation="lint" --target="api-integration"
```

**Pattern Extraction and Skill Creation:**
```bash
# Extract existing patterns to create reusable skills
/text-manipulation --operation="extract" --patterns="common-workflows" |\
  /skill-development template workflow extracted-patterns |\
  /skill-development optimize extracted-patterns
```

**Maintenance and Optimization Workflow:**
```bash
# Comprehensive skill ecosystem maintenance
/skill-development audit all-skills |\
  /skill-development optimize high-usage-skills |\
  /skill-development compliance all-skills
```

#### Workflow Handoff Patterns

**From skill-development → Other Skills:**
- Provides validated skill structures for integration workflows
- Supplies development patterns for code standardization
- Offers quality frameworks for documentation compliance
- Delivers skill architecture for cross-skill coordination

**To skill-development ← Other Skills:**
- Receives development patterns for skill template creation
- Gets documentation standards for skill quality validation
- Obtains domain expertise for specialized skill development
- Accepts usage feedback for optimization prioritization

### Integration Architecture

#### Skill Development Ecosystem Coordination

**Central Role**: `skill-development` provides comprehensive skill lifecycle management across all Claude Code skill development activities

**Development Framework Integration:**
1. **Pattern Recognition**: Identify development patterns requiring skill automation
2. **Skill Creation**: Structured skill development with evaluation-driven methodology
3. **Quality Assurance**: Progressive disclosure compliance and structure validation
4. **Performance Optimization**: Token efficiency and context management
5. **Maintenance Coordination**: Ongoing optimization and standards compliance

#### Integration Standards

**All skill development activities integrate through:**

1. **Progressive Disclosure**: Structured information layering following complexity patterns
2. **Quality Validation**: Automated structure and content validation
3. **Performance Standards**: Token efficiency and context optimization
4. **Cross-Skill Coordination**: Integration point documentation and workflow support
5. **Continuous Improvement**: Usage-driven optimization and maintenance cycles

This skill provides comprehensive skill development capabilities while ensuring integration with FUB development practices and maintaining quality standards across all created and maintained skills.