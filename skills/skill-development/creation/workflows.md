# Skill Creation Workflows

## Complete Creation Process

### Phase 1: Gap Analysis and Evaluation Design

#### 1. Identify Development Gaps
**Process:**
1. Work through representative tasks with Claude (without skill)
2. Document specific failures, missing context, or repeated information
3. Note patterns where Claude struggles or requires extensive prompting
4. Validate gaps are consistent across multiple similar tasks

**Common Gap Patterns:**
- **Domain Knowledge**: Repeated explanations of FUB-specific patterns
- **Process Workflows**: Multi-step procedures requiring consistent execution
- **Integration Patterns**: Cross-system coordination requiring specific knowledge
- **Quality Standards**: Consistent formatting, validation, or compliance requirements

#### 2. Create Evaluation Scenarios
**Before writing any documentation**, create 3+ evaluation scenarios:

**Evaluation Template:**
```json
{
  "skills": ["new-skill-name"],
  "query": "[Realistic user request that tests the gap]",
  "files": ["test-files/relevant-input.txt"],
  "expected_behavior": [
    "Successfully handles the identified gap without additional prompting",
    "Applies FUB-specific patterns correctly",
    "Produces output matching quality standards",
    "Completes task efficiently without context bloat"
  ]
}
```

**Evaluation Categories:**
- **Happy Path**: Standard usage scenarios
- **Edge Cases**: Unusual inputs or error conditions
- **Integration**: Cross-skill coordination scenarios
- **Performance**: Token efficiency and context management

### Phase 2: Iterative Development with Claude

#### 1. Collaborative Design Process
**Work with Claude A (Design Assistant):**
1. Share the gap analysis and evaluation scenarios
2. Ask Claude A to create minimal skill structure addressing the gaps
3. Request organization suggestions for complex content
4. Iterate on content structure and progressive disclosure

**Example Collaboration:**
```
You: "I've identified a gap in FUB email parsing workflows. Claude repeatedly needs
     explanation of EmailParser class patterns, ActiveRecord relationships, and
     validation rules. Here are my evaluation scenarios: [paste scenarios]

     Create a minimal skill that addresses these gaps."

Claude A: [Generates initial skill structure]

You: "The table schema section is getting large. How should we organize this for
     progressive disclosure?"

Claude A: "Split the schemas into separate reference files by domain:
          contacts.md, activities.md, email_sources.md..."
```

#### 2. Testing with Fresh Context
**Test with Claude B (Implementation Assistant):**
1. Load the skill with Claude B (fresh instance)
2. Present evaluation scenarios without additional context
3. Observe Claude B's behavior and success/failure patterns
4. Note specific areas where Claude B struggles or succeeds

#### 3. Refinement Iteration
**Return to Claude A with observations:**
```
You: "When Claude B used this skill for email parsing, it correctly found the
     EmailParser class but forgot to validate the lead_source field. The skill
     mentions validation but maybe it's not prominent enough?"

Claude A: "Let's make the validation step more explicit in the Core Workflow and
          add a validation checklist to the Quick Reference..."
```

### Phase 3: Structure and Organization

#### 1. Progressive Disclosure Architecture
**Main SKILL.md Structure:**
- **Overview**: 2-3 sentences explaining purpose and usage triggers
- **Usage**: Exact invocation syntax and parameters
- **Core Workflow**: Essential steps only (50-100 lines)
- **Quick Reference**: Common patterns and commands (100-200 lines)
- **Advanced Patterns**: Complex scenarios and edge cases (200-400 lines)
- **Integration Points**: Cross-skill coordination (100-200 lines)

**Supporting File Organization:**
```
skill-name/
├── SKILL.md                    # Main workflow (<500 lines)
├── reference/
│   ├── api-documentation.md    # Detailed API reference
│   ├── troubleshooting.md      # Common issues and solutions
│   └── fub-patterns.md        # FUB-specific implementation patterns
├── templates/
│   ├── basic-template.md       # Code/workflow templates
│   └── advanced-template.md    # Complex scenario templates
├── examples/
│   ├── common-scenarios.md     # Typical usage examples
│   └── edge-cases.md          # Unusual or complex examples
└── scripts/
    ├── validate.sh           # Validation automation
    └── setup.sh             # Environment setup
```

#### 2. Content Stratification Guidelines
**Tier 1 (Core Workflow): Daily Operations**
- Essential steps that 80% of users need
- Must-know patterns for basic functionality
- Critical error prevention measures
- Basic troubleshooting

**Tier 2 (Quick Reference): Common Scenarios**
- Frequent variations and options
- Parameter references and examples
- Standard troubleshooting procedures
- Performance optimization basics

**Tier 3 (Advanced Patterns): Expert Usage**
- Complex edge cases and specialized scenarios
- Performance tuning and optimization
- Integration with advanced tools
- Expert troubleshooting and debugging

**Tier 4 (Integration Points): Cross-Skill Coordination**
- Handoff patterns with related skills
- Multi-skill workflow examples
- Coordination protocols and standards
- Ecosystem integration patterns

### Phase 4: Quality Assurance and Testing

#### 1. Multi-Model Validation
**Test with all target models:**
- **Claude Haiku**: Verify sufficient guidance provided
- **Claude Sonnet**: Confirm clarity and efficiency
- **Claude Opus**: Ensure no over-explanation

**Model-Specific Considerations:**
- Haiku may need more explicit guidance
- Sonnet balances detail and efficiency
- Opus can infer more context but appreciates conciseness

#### 2. Evaluation Execution
**Run original evaluation scenarios:**
1. Execute evaluations with skill loaded
2. Compare performance against baseline (without skill)
3. Validate all expected behaviors are achieved
4. Measure token efficiency and context usage

#### 3. Integration Testing
**Test cross-skill workflows:**
1. Identify skills that integrate with new skill
2. Test handoff patterns and data flow
3. Validate bidirectional integration documentation
4. Update related skills' Integration Points as needed

### Phase 5: Documentation and Deployment

#### 1. Final Documentation Review
**Complete documentation checklist:**
- [ ] All file paths use forward slashes (Unix-style)
- [ ] No time-sensitive information (use "old patterns" sections instead)
- [ ] Consistent terminology throughout
- [ ] Clear separation between execution vs. reference for scripts
- [ ] Progressive disclosure properly implemented
- [ ] Integration Points bidirectional with related skills

#### 2. Performance Validation
**Final performance checks:**
- Main SKILL.md under 500 lines
- Supporting files appropriately organized
- Token efficiency optimized
- Context loading patterns tested

#### 3. Team Integration
**Share and gather feedback:**
1. Document in team skill directory (`.claude/skills/`)
2. Share with team members for feedback
3. Observe usage patterns and iterate
4. Incorporate feedback for blind spots

## Skill Type-Specific Workflows

### Workflow Skills
**Characteristics:** Multi-step processes, manual trigger, checklist-driven
**Special Considerations:**
- Use `disable-model-invocation: true`
- Provide copy-paste checklists
- Include validation steps between major phases
- Clear error recovery procedures

### Knowledge Skills
**Characteristics:** Domain expertise, auto-discovery, reference-heavy
**Special Considerations:**
- Use `user-invocable: false`
- Organize reference files by domain
- Optimize for Claude discovery patterns
- Minimize main SKILL.md, maximize reference files

### Integration Skills
**Characteristics:** External tools, MCP integration, error handling
**Special Considerations:**
- Document tool dependencies and installation
- Provide fallback strategies for tool failures
- Include authentication and setup procedures
- Test across different environments

### Utility Skills
**Characteristics:** Simple operations, frequent use, minimal overhead
**Special Considerations:**
- Keep extremely concise
- Focus on efficiency over comprehensive documentation
- Provide quick validation of common parameters
- Minimize context overhead

## Anti-Patterns to Avoid

### Content Anti-Patterns
- **Kitchen Sink Skills**: Trying to solve too many unrelated problems
- **Over-Documentation**: Explaining things Claude already knows
- **Time-Sensitive Content**: Information that becomes outdated
- **Implementation Prescription**: Being too specific about methods when flexibility is better

### Structure Anti-Patterns
- **Monolithic Files**: Putting everything in SKILL.md instead of using progressive disclosure
- **Deep Nesting**: References to references to references
- **Windows Paths**: Using backslashes instead of forward slashes
- **Magic Constants**: Unexplained configuration values in scripts

### Process Anti-Patterns
- **Documentation-First**: Writing extensive documentation before validating the need
- **Single-Model Testing**: Only testing with one Claude model
- **Isolation Development**: Creating skills without considering ecosystem integration
- **Static Development**: Not iterating based on actual usage feedback