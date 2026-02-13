# Progressive Disclosure Standards

## Core Principles

### Token Efficiency as Public Good
The context window is shared among conversation history, system prompts, other skills, and user requests. Every token in a skill must justify its existence and contribute meaningfully to Claude's ability to complete tasks.

### Information Stratification
Content should be organized by frequency of use and complexity level, with the most essential information prioritized in the main SKILL.md file and specialized content pushed to supporting files.

### Progressive Loading
Claude should access information incrementally, loading only what's needed for the current task rather than consuming entire skill contents regardless of relevance.

## Section Structure Standards

### Required Progressive Disclosure Sections

#### 1. Overview Section (15-30 lines)
**Purpose**: Immediate skill understanding and usage triggers
**Content Requirements:**
- 2-3 sentences explaining what the skill does
- Clear usage triggers ("Use when..." statements)
- Brief mention of key capabilities
- No implementation details or examples

**Quality Standards:**
- Assumes Claude has general knowledge (don't explain basic concepts)
- Focuses on "what" and "when", not "how"
- Uses concrete, specific language
- Avoids marketing language or superlatives

#### 2. Usage Section (5-15 lines)
**Purpose**: Exact invocation patterns and syntax
**Content Requirements:**
- Precise command syntax with parameter examples
- Common parameter variations
- Brief parameter descriptions (detailed docs go in Quick Reference)

**Quality Standards:**
- Uses exact syntax that users will type
- Shows realistic parameter examples
- Avoids explaining what parameters "mean" (that's for Quick Reference)

#### 3. Core Workflow Section (50-100 lines)
**Purpose**: Essential daily operations covering 80% of use cases
**Content Requirements:**
- Step-by-step procedures for most common tasks
- Critical error prevention measures
- Essential troubleshooting steps
- Must-know patterns for basic functionality

**Quality Standards:**
- Actionable steps, not explanations
- Focuses on "how to succeed" not "why things work"
- Includes copy-paste commands and code where appropriate
- References detailed documentation in supporting files

#### 4. Quick Reference Section (100-200 lines)
**Purpose**: Common patterns, variations, and troubleshooting
**Content Requirements:**
- Parameter references with examples
- Common workflow variations
- Standard troubleshooting procedures
- Performance optimization basics
- Template patterns and examples

**Quality Standards:**
- Organized for quick scanning and lookup
- Uses tables, lists, and code blocks for easy parsing
- Focuses on "how" rather than "why"
- Practical examples over theoretical explanations

#### 5. Advanced Patterns Section (200-400 lines)
**Purpose**: Complex scenarios, edge cases, and expert usage
**Content Requirements:**
- Complex multi-step workflows
- Edge case handling and error recovery
- Performance tuning and optimization
- Integration with advanced tools
- Expert troubleshooting and debugging

**Quality Standards:**
- Assumes expertise with basic operations
- Provides comprehensive coverage of complex scenarios
- Includes detailed examples and code samples
- May reference external documentation for deep technical details

#### 6. Integration Points Section (100-200 lines)
**Purpose**: Cross-skill coordination and ecosystem integration
**Content Requirements:**
- Primary integration relationships table
- Multi-skill operation examples
- Workflow handoff patterns (from/to other skills)
- Bidirectional integration examples
- Integration architecture documentation

**Quality Standards:**
- Documents actual workflow patterns, not theoretical possibilities
- Includes concrete examples of multi-skill operations
- Maintains bidirectional references with related skills
- Focuses on coordination patterns and data flow

## File Organization Standards

### Main SKILL.md Requirements
- **Size Limit**: Under 500 lines for optimal performance
- **Content Focus**: Essential workflow and navigation to supporting files
- **Structure**: All six progressive disclosure sections required
- **References**: Clear pathways to supporting documentation

### Supporting File Organization

#### Reference Files (`reference/`)
**Purpose**: Detailed documentation, API references, comprehensive guides
**Content**: Information that's accessed occasionally but needs to be comprehensive
**Examples**:
- `api-documentation.md` - Complete API reference
- `troubleshooting.md` - Comprehensive error resolution
- `fub-patterns.md` - FUB-specific implementation details

#### Templates (`templates/`)
**Purpose**: Reusable code, configuration, or workflow templates
**Content**: Copy-paste ready templates for common scenarios
**Examples**:
- `basic-template.md` - Standard workflow template
- `component.tsx` - React component template
- `config-template.yaml` - Configuration file template

#### Examples (`examples/`)
**Purpose**: Complete usage examples and sample outputs
**Content**: Real-world usage scenarios with full context
**Examples**:
- `common-scenarios.md` - Typical usage patterns
- `edge-cases.md` - Unusual or complex examples
- `sample-outputs/` - Example results and outputs

#### Scripts (`scripts/`)
**Purpose**: Executable utilities and automation
**Content**: Scripts that Claude executes (not reads as documentation)
**Examples**:
- `validate.sh` - Validation automation
- `setup.sh` - Environment preparation
- `analyze.py` - Data analysis utilities

### File Naming Conventions

#### Markdown Files
**Standard**: Lowercase with hyphens as word separators
- ✅ `api-reference.md`, `troubleshooting-guide.md`, `mcp-resilience-patterns.md`
- ❌ `API_Reference.md`, `TroubleshootingGuide.md`, `MCP_RESILIENCE_PATTERNS.md`
- **Exception**: `SKILL.md` must remain uppercase per Agent Skills standard

#### Other Files
**Standard**: Follow standard conventions for file type
- Scripts: `validate.sh`, `health-check.sh`
- Templates: `component.tsx`, `api-endpoint.php`
- Examples: `sample-output.json`, `example-config.yaml`

## Content Stratification Guidelines

### Tier 1: Essential Operations (Core Workflow)
**Frequency**: Daily usage, 80% of skill invocations
**Complexity**: Basic to intermediate
**Content Type**: Step-by-step procedures, critical patterns, error prevention
**Examples**: User authentication, basic queries, standard workflows

### Tier 2: Common Scenarios (Quick Reference)
**Frequency**: Weekly usage, common variations and troubleshooting
**Complexity**: Intermediate
**Content Type**: Parameter references, variations, standard troubleshooting
**Examples**: Configuration options, common errors, performance basics

### Tier 3: Expert Usage (Advanced Patterns)
**Frequency**: Monthly usage, complex scenarios and optimization
**Complexity**: Advanced to expert
**Content Type**: Complex workflows, edge cases, performance tuning
**Examples**: Multi-system integration, advanced debugging, optimization strategies

### Tier 4: Ecosystem Integration (Integration Points)
**Frequency**: Project-based, cross-skill coordination
**Complexity**: Varies based on integration scenario
**Content Type**: Workflow coordination, handoff patterns, ecosystem documentation
**Examples**: Multi-skill workflows, data sharing patterns, coordination protocols

## Reference and Navigation Patterns

### Internal References
**Format**: Use relative paths from SKILL.md location
- `See [creation/workflows.md](creation/workflows.md) for detailed creation process`
- `Complete validation guidelines: [maintenance/validation-checklists.md](maintenance/validation-checklists.md)`

### Cross-Skill References
**Format**: Use skill name format for cross-references
- `**skills/skill-name/SKILL.md**` for formal references
- `/skill-name` for command examples
- `[skill description](path)` for navigation links

### Progressive Disclosure Navigation
**Pattern**: Provide clear pathways from general to specific
```markdown
## Quick Reference
Basic operations and common patterns.

**Detailed API Reference**: See [reference/api-documentation.md](reference/api-documentation.md)
**Complex Scenarios**: See [Advanced Patterns](#advanced-patterns) section below
**Cross-Skill Integration**: See [Integration Points](#integration-points) section
```

## Performance Optimization Standards

### Context Loading Efficiency
**Principle**: Load information only when needed for current task
**Implementation**:
- Main SKILL.md provides navigation and essential operations
- Supporting files loaded on-demand based on task requirements
- Avoid deep nesting (references to references to references)

### Token Budget Management
**Main SKILL.md**: 500 lines maximum (~2,000-2,500 tokens)
**Supporting Files**: No hard limit, but optimize for actual usage patterns
**Total Skill Context**: Measure actual token consumption in typical usage scenarios

### Information Density Optimization
**High-Density Sections**: Quick Reference (tables, lists, code blocks)
**Medium-Density Sections**: Core Workflow (procedures and steps)
**Lower-Density Sections**: Advanced Patterns (explanations and complex examples)

## Quality Assurance Standards

### Content Validation Criteria
- **Necessity Test**: Can Claude complete tasks without this information?
- **Frequency Test**: How often is this information actually used?
- **Specificity Test**: Is this information specific enough to be actionable?
- **Duplication Test**: Is this information available elsewhere in the skill ecosystem?

### Structure Compliance Validation
- All required progressive disclosure sections present
- Section length guidelines followed
- Supporting files appropriately utilized
- File naming conventions followed
- Navigation patterns implemented correctly

### Performance Validation
- Main SKILL.md under 500 lines
- Typical usage scenarios measured for token efficiency
- Context loading patterns optimized for common workflows
- Cross-skill integration tested for efficiency

## Migration Guidelines

### Existing Skills to Progressive Disclosure
1. **Assess Current Structure**: Identify existing content and organization
2. **Content Categorization**: Sort content by frequency and complexity
3. **Section Redistribution**: Move content to appropriate progressive disclosure sections
4. **Supporting File Creation**: Extract detailed content to supporting files
5. **Navigation Implementation**: Add clear references and pathways
6. **Validation and Testing**: Ensure functionality and performance standards met

### Best Practices for Migration
- Maintain existing functionality while improving structure
- Test with real usage scenarios during migration
- Preserve essential information accessibility
- Update integration points with related skills
- Validate performance improvements post-migration

## Anti-Patterns to Avoid

### Structure Anti-Patterns
- **Monolithic SKILL.md**: Putting everything in main file instead of using progressive disclosure
- **Deep Reference Nesting**: References to references to references
- **Poor Section Balance**: Overly long Core Workflow, thin Quick Reference
- **Missing Navigation**: No clear pathways between content layers

### Content Anti-Patterns
- **Over-Explanation**: Explaining concepts Claude already knows
- **Time-Sensitive Information**: Content that becomes outdated
- **Implementation Prescription**: Being too specific when flexibility is better
- **Duplicate Information**: Repeating content across sections or skills

### Performance Anti-Patterns
- **Context Bloat**: Loading unnecessary information for simple tasks
- **Poor Information Architecture**: Inefficient access patterns to common information
- **Redundant Cross-References**: Excessive linking that doesn't improve navigation
- **Inefficient File Organization**: Supporting files that don't match actual usage patterns