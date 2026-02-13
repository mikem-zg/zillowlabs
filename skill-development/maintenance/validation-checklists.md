# Skill Validation Checklists

## Comprehensive Skill Health Assessment

### Structure Validation Checklist

#### Progressive Disclosure Sections
- [ ] **Overview section present** - Explains purpose in 2-3 sentences
- [ ] **Usage section present** - Shows exact invocation syntax
- [ ] **Core Workflow section present** - Essential steps (50-100 lines)
- [ ] **Quick Reference section present** - Common patterns (100-200 lines)
- [ ] **Advanced Patterns section present** - Complex scenarios (200-400 lines)
- [ ] **Integration Points section present** - Cross-skill workflows (100-200 lines)

#### Section Quality Validation
- [ ] **Overview clarity** - Clear purpose statement and usage triggers
- [ ] **Usage specificity** - Exact command syntax with parameter examples
- [ ] **Core Workflow completeness** - Essential daily operations covered
- [ ] **Quick Reference utility** - Common patterns easily accessible
- [ ] **Advanced Patterns depth** - Expert scenarios and edge cases covered
- [ ] **Integration Points comprehensiveness** - Cross-skill workflows documented

#### File Organization Standards
- [ ] **Main SKILL.md size** - Under 500 lines for optimal performance
- [ ] **Supporting files present** - Appropriate use of progressive disclosure
- [ ] **File naming conventions** - Lowercase with hyphens (except SKILL.md)
- [ ] **Directory structure** - Logical organization by content type
- [ ] **File path formats** - Forward slashes (Unix-style) throughout

### Content Quality Validation

#### FUB-Specific Accuracy
- [ ] **File paths current** - Match actual FUB codebase structure
  - `apps/richdesk/analysis/email_parser/` (correct)
  - `apps/richdesk/tests/cases/analysis/` (correct)
- [ ] **Class names accurate** - Match actual implementation
  - `EmailParser` (correct, not `EmailParser`)
  - ActiveRecord patterns (not PDO)
- [ ] **Database references valid** - Current table and column names
- [ ] **API endpoints current** - Match active FUB service endpoints
- [ ] **Tool availability verified** - Confirm required tools are accessible

#### Cross-Reference Integrity
- [ ] **Skill references valid** - All `/skill-name` references exist
- [ ] **Integration Points bidirectional** - Related skills reference back
- [ ] **Workflow chains accurate** - Multi-skill operations tested
- [ ] **Link formatting consistent** - Follow standard patterns:
  - Cross-references: `**skills/skill-name/SKILL.md**`
  - Navigation links: `[description](path)`
  - Command examples: `/skill-name`
  - Technical names: backtick format

#### Code Quality Standards
- [ ] **Code blocks validated** - All code is syntactically correct
- [ ] **Language indicators correct** - Proper syntax highlighting tags
- [ ] **Examples FUB-relevant** - Based on actual usage patterns
- [ ] **Scripts executable** - Utility scripts run without errors
- [ ] **No placeholder code** - All examples are complete and functional

### Performance Validation

#### Token Efficiency Assessment
- [ ] **Section length compliance** - Meet progressive disclosure guidelines
- [ ] **Content necessity** - Every paragraph justified for inclusion
- [ ] **Redundancy elimination** - No duplicate information across sections
- [ ] **Context optimization** - Efficient skill loading patterns

#### Progressive Disclosure Effectiveness
- [ ] **Essential information prioritized** - Core Workflow contains daily operations
- [ ] **Content stratification** - Information layered by complexity/frequency
- [ ] **Reference file optimization** - Detailed content appropriately separated
- [ ] **Navigation efficiency** - Clear pathways between content layers

### Integration Validation

#### Cross-Skill Coordination
- [ ] **Integration table complete** - All related skills documented
- [ ] **Workflow examples tested** - Multi-skill operations validated
- [ ] **Handoff patterns documented** - Clear input/output specifications
- [ ] **Bidirectional relationships** - Mutual integration points established

#### Ecosystem Consistency
- [ ] **Naming conventions aligned** - Consistent with FUB standards
- [ ] **Quality standards uniform** - Meets skill development framework
- [ ] **Integration patterns standardized** - Follows established coordination protocols

## Maintenance-Specific Validation

### Ongoing Quality Assurance

#### Regular Health Checks (Monthly)
- [ ] **Structure integrity** - All required sections present and properly formatted
- [ ] **Content freshness** - No outdated information or broken references
- [ ] **Performance metrics** - Token usage and loading efficiency within targets
- [ ] **Usage patterns** - Skill activation frequency and success rates

#### FUB Codebase Synchronization (Quarterly)
- [ ] **File path validation** - Verify all FUB paths exist and are current
- [ ] **Class reference accuracy** - Confirm class names match implementation
- [ ] **Database schema currency** - Validate table/column references
- [ ] **API endpoint verification** - Test endpoint availability and accuracy
- [ ] **Service integration currency** - Confirm external service patterns

#### Cross-Reference Maintenance (Quarterly)
- [ ] **Skill reference audit** - Verify all skill references are valid
- [ ] **Integration point validation** - Test cross-skill workflow examples
- [ ] **Link integrity check** - Confirm all internal and external links work
- [ ] **Workflow chain testing** - Validate multi-skill operation sequences

### Performance Optimization Checklist

#### Context Efficiency Optimization
- [ ] **Section balance assessment** - Optimal information density per section
- [ ] **Content bloat identification** - Sections causing context overflow
- [ ] **Essential information placement** - Most important content prioritized
- [ ] **Progressive loading optimization** - Content accessed only when needed

#### Usage Pattern Analysis
- [ ] **Activation frequency tracking** - Which skills are used most often
- [ ] **Success rate monitoring** - Skill effectiveness measurements
- [ ] **Context usage patterns** - Token consumption and efficiency metrics
- [ ] **Integration workflow performance** - Multi-skill operation effectiveness

## Quality Issue Resolution

### Common Issues and Solutions

#### Structure Violations
**Issue:** Missing progressive disclosure sections
**Solution:** Add missing sections with appropriate content distribution

**Issue:** Main SKILL.md exceeds 500 lines
**Solution:** Extract detailed content to supporting files with proper references

**Issue:** Poor section length balance
**Solution:** Redistribute content according to progressive disclosure guidelines

#### Content Quality Issues
**Issue:** Outdated FUB references
**Solution:** Systematic validation against current FUB codebase structure

**Issue:** Broken cross-skill references
**Solution:** Comprehensive skill reference audit and correction

**Issue:** Inconsistent formatting
**Solution:** Apply standardized formatting patterns and conventions

#### Performance Problems
**Issue:** High token consumption
**Solution:** Content optimization and progressive disclosure improvement

**Issue:** Poor context loading patterns
**Solution:** Restructure information architecture for efficient access

**Issue:** Integration inefficiencies
**Solution:** Optimize cross-skill handoff patterns and coordination

### Validation Automation

#### Automated Checks
```bash
# Structure validation
./scripts/validate-structure.sh [skill-name]

# Content quality checks
./scripts/lint-and-format.sh [skill-name]

# Performance analysis
./scripts/performance-analysis.sh [skill-name]

# Cross-reference validation
./scripts/validate-references.sh [skill-name]

# FUB accuracy validation
./scripts/validate-fub-references.sh [skill-name]
```

#### Continuous Integration
- Pre-commit hooks for structure validation
- Scheduled maintenance runs for accuracy checks
- Performance monitoring and alerting
- Integration testing for cross-skill workflows

## Validation Reporting

### Health Report Template
```markdown
# Skill Health Report: [skill-name]

## Summary
- Overall Health: [Excellent/Good/Fair/Poor]
- Compliance Status: [Compliant/Non-compliant]
- Performance Rating: [Optimized/Adequate/Needs Improvement]

## Structure Assessment
- Progressive Disclosure: ✅/❌
- Section Lengths: ✅/❌
- File Organization: ✅/❌

## Content Quality
- FUB Accuracy: ✅/❌
- Cross-References: ✅/❌
- Code Quality: ✅/❌

## Performance Metrics
- Main File Size: [lines]
- Token Efficiency: [rating]
- Context Usage: [rating]

## Recommendations
- [Specific improvement recommendations]

## Next Review: [date]
```

### Ecosystem Health Dashboard
Track overall skill ecosystem health:
- Total skills under management
- Compliance rate percentage
- Average skill health rating
- Performance trends over time
- Most/least used skills
- Integration effectiveness metrics