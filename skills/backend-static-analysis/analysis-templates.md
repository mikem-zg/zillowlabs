# Analysis Templates

Ready-to-use templates for different types of backend status analysis reports.

## Baseline Reduction Initiative Report Template

```markdown
# Psalm Baseline Paydown Progress Report

**Report Date**: [YYYY-MM-DD]
**Team/Initiative**: [Team Name] Baseline Reduction
**Reporting Period**: [Date Range]

## Progress Summary
- **Baseline Size**: [Current] entries (was [Previous], [+/-X] change)
- **Issues Fixed**: [X] issues resolved this period
- **Target Progress**: [X]% toward quarterly goal
- **Team Effort**: [X] hours invested in baseline reduction

## Issue Type Progress
| Error Type | Previous | Current | Fixed | Remaining |
|------------|----------|---------|-------|-----------|
| MissingReturnType | [X] | [Y] | [Z] | [Y] |
| PropertyNotSetInConstructor | [X] | [Y] | [Z] | [Y] |
| RiskyTruthyFalsyComparison | [X] | [Y] | [Z] | [Y] |
| **Total Top 3** | [X] | [Y] | [Z] | [Y] |

## Files/Areas Addressed
- **[ModuleName]**: [X] issues fixed ([error types])
- **[ModuleName]**: [X] issues fixed ([error types])
- **[ModuleName]**: [X] issues fixed ([error types])

## Lessons Learned
- **Quick Wins**: [Pattern of easily fixable issues]
- **Complex Issues**: [Issues requiring more investigation]
- **Tool Usage**: [Effectiveness of Psalter or manual fixes]

## Next Period Goals
- **Target Reduction**: [X] issues (focus on [error types])
- **Team Allocation**: [X] hours during [AI Days/Paper Cut Days]
- **Areas of Focus**: [Module/file areas for next iteration]

## Resources Used
- [Confluence: Chipping Away at the Psalm Baseline](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1042088236)
- [Google Drive: Baseline Paydown Initiative](https://docs.google.com/document/d/1YPZOXSQJznC_JVXmBf2u1JQO0G8vRvw5-ewhzPJzXHk)
- Standard Psalm: `vendor/bin/psalm`
- Helper Script: `.claude/skills/backend-static-analysis/scripts/psalm-check.sh`
```

## Executive Summary Template

```markdown
# Backend Health Assessment - [Project Name]

**Analysis Date**: [YYYY-MM-DD]
**Analyzed by**: Claude Code Backend Status Analysis
**Scope**: [Directory/Files Analyzed]

## Health Score: [A/B/C/D]

### Quick Metrics
- **Total Issues**: [X] ([+/-Y] since last analysis)
- **Critical Issues**: [X] (blocking deployment)
- **Baseline Entries**: [X] ([growing/stable/shrinking])
- **CI Status**: [Pass/Fail/Not Configured]

### Top 3 Priority Actions
1. [Action 1] - Expected effort: [time estimate]
2. [Action 2] - Expected effort: [time estimate]
3. [Action 3] - Expected effort: [time estimate]

### Configuration Status
- **Psalm Version**: [X.X]
- **Error Level**: [X] ([aligned/needs adjustment])
- **PHP Target**: [8.X] ([current/outdated])
- **Baseline**: [healthy/needs attention]
```

## Detailed Analysis Template

```markdown
# Detailed Backend Analysis Report

## Configuration Assessment

### Psalm Settings
- **Error Level**: [X] out of 8 (strictness rating)
  - Recommendation: [maintain/increase/decrease] to level [Y]
- **PHP Version Target**: [8.X]
  - Status: [✅ Current / ⚠️ Outdated / ❌ Unsupported]
- **Baseline File**: [present/missing]
  - Size: [X entries] ([trend over time])
  - Last Updated: [date]

### Suppression Analysis
Most commonly suppressed error types:
1. **[Error Type]**: [X] instances - [Acceptable/Needs Review]
2. **[Error Type]**: [X] instances - [Acceptable/Needs Review]
3. **[Error Type]**: [X] instances - [Acceptable/Needs Review]

## Error Distribution

### Critical Issues (Fix Immediately)
| Error Type | Count | Files Affected | Example Location |
|------------|-------|----------------|------------------|
| MissingReturnType | [X] | [Y] | [file:line] |
| MissingParamType | [X] | [Y] | [file:line] |
| PropertyNotSetInConstructor | [X] | [Y] | [file:line] |

### Type Safety Issues (Medium Priority)
| Error Type | Count | Files Affected | Complexity |
|------------|-------|----------------|------------|
| MixedAssignment | [X] | [Y] | [Low/Medium/High] |
| PossiblyNullReference | [X] | [Y] | [Low/Medium/High] |
| MixedArrayAccess | [X] | [Y] | [Low/Medium/High] |

### Suppressed Issues (Background)
- **UndefinedMagicProperty***: [X] instances (ActiveRecord pattern)
- **DocblockTypeContradiction**: [X] instances (documentation cleanup)
- **RiskyTruthyFalsyComparison**: [X] instances (logic review)

## Hotspot Analysis

### Files with Most Issues
1. **[filename]**: [X] issues ([error types])
2. **[filename]**: [X] issues ([error types])
3. **[filename]**: [X] issues ([error types])

### Most Common Error Locations
- **Controllers**: [X]% of issues
- **Models**: [X]% of issues
- **Services**: [X]% of issues
- **Utilities**: [X]% of issues

## CI/CD Integration Status

### Pipeline Configuration
- **Psalm Job**: [✅ Present / ❌ Missing]
- **Job Stage**: [test/quality/deploy]
- **Blocking Status**: [✅ Blocks merge / ⚠️ Warning only / ❌ No integration]
- **Branch Coverage**: [all branches/main+qa only/missing]

### Recent CI History
- **Last 10 Runs**: [X] passed, [Y] failed
- **Common Failures**: [error patterns]
- **Average Runtime**: [X] minutes

## Recommendations

### Immediate Actions (This Sprint)
- [ ] Fix [X] critical return type issues
- [ ] Add null checks for [Y] PossiblyNullReference errors
- [ ] Document [Z] array shapes for type safety

### Short-term Goals (Next 2 Sprints)
- [ ] Reduce baseline by [X]% (target: [Y] entries)
- [ ] Add type hints to all new public methods
- [ ] Configure VS Code Psalm integration for team

### Long-term Improvements (Next Quarter)
- [ ] Consider increasing error level to [X]
- [ ] Migrate remaining mixed types to specific types
- [ ] Establish team type safety training program
```

## Quick Health Check Template

```markdown
# Quick Backend Health Check

**Project**: [Name]
**Date**: [YYYY-MM-DD]

## Status Summary
🟢 **Green** - No critical issues, CI passing
🟡 **Yellow** - Some issues, manageable technical debt
🔴 **Red** - Critical issues blocking deployment

## Key Metrics
- Issues: **[Total]** ([Critical]/[Medium]/[Low])
- Baseline: **[Size]** entries ([↗️Growing/➡️Stable/↘️Shrinking])
- CI: **[Status]** ([✅Pass/❌Fail/⚠️Warning])

## Next Actions
1. **[Priority]**: [Action] ([effort estimate])
2. **[Priority]**: [Action] ([effort estimate])
3. **[Priority]**: [Action] ([effort estimate])

## Configuration Check
- Error Level: [X]/8 [✅Good/⚠️Review/❌Update]
- PHP Target: [8.X] [✅Current/⚠️Update]
- Suppressions: [X] types [✅Clean/⚠️Review/❌Cleanup]
```

## Baseline Analysis Template

```markdown
# Psalm Baseline Analysis

## Current State
- **Total Entries**: [X]
- **File**: psalm-baseline.xml
- **Last Modified**: [date]
- **Size Trend**: [Growing +X/week | Stable ±X | Shrinking -X/week]

## Error Type Breakdown
| Error Type | Count | % of Total | Trend |
|------------|-------|------------|-------|
| UndefinedMagicPropertyAssignment | [X] | [Y]% | [↗️↘️➡️] |
| MissingReturnType | [X] | [Y]% | [↗️↘️➡️] |
| MixedAssignment | [X] | [Y]% | [↗️↘️➡️] |
| [Continue for top 10 types] | | | |

## Reduction Strategy

### Low-Hanging Fruit ([X] entries, [Y] effort hours)
- **MissingReturnType**: [X] entries - Add explicit return types
- **MissingParamType**: [X] entries - Add parameter type hints
- **Simple null checks**: [X] entries - Add basic null validation

### Medium Effort ([X] entries, [Y] effort hours)
- **Array shape documentation**: [X] entries - Document complex arrays
- **Property initialization**: [X] entries - Constructor improvements
- **Mixed type resolution**: [X] entries - Replace mixed with specific types

### Large Projects ([X] entries, [Y] effort hours)
- **ActiveRecord refactoring**: [X] entries - Modern type-safe patterns
- **Legacy code modernization**: [X] entries - Architectural improvements
- **Complex generics**: [X] entries - Template type implementations

## Monthly Reduction Targets
- **Month 1**: Reduce by [X] entries ([Y]% reduction)
- **Month 2**: Reduce by [X] entries ([Y]% reduction)
- **Month 3**: Reduce by [X] entries ([Y]% reduction)

**Target**: [X]% reduction in [Y] months
```

## CI/CD Integration Report Template

```markdown
# CI/CD Static Analysis Integration Report

## Pipeline Status
- **Integration**: [✅ Fully Integrated / ⚠️ Partial / ❌ Not Configured]
- **Job Name**: [test:psalm | static-analysis | quality-check]
- **Stage**: [test | quality | deploy]
- **Execution**: [Required | Optional | Manual]

## Branch Coverage
| Branch | Psalm Required | Status | Last Run |
|--------|----------------|--------|----------|
| main | [✅ Yes / ❌ No] | [Pass/Fail] | [date] |
| qa | [✅ Yes / ❌ No] | [Pass/Fail] | [date] |
| develop | [✅ Yes / ❌ No] | [Pass/Fail] | [date] |
| feature/* | [✅ Yes / ❌ No] | [Pass/Fail] | [date] |
| hotfix/* | [✅ Yes / ❌ No] | [Pass/Fail] | [date] |

## Performance Metrics
- **Average Runtime**: [X] minutes [Y] seconds
- **Cache Hit Rate**: [X]% (when applicable)
- **Success Rate**: [X]% over last [Y] runs
- **Resource Usage**: [CPU/Memory stats if available]

## Failure Analysis
### Most Common Failures (Last 30 days)
1. **[Error Type]**: [X] occurrences - [Impact description]
2. **[Error Type]**: [X] occurrences - [Impact description]
3. **[Error Type]**: [X] occurrences - [Impact description]

### Deployment Blocks
- **Total Blocks**: [X] in last month
- **Average Resolution Time**: [X] hours
- **Most Blocking Error**: [Error type] ([X] occurrences)

## Recommendations
### Pipeline Improvements
- [ ] [Improvement 1] - [Expected benefit]
- [ ] [Improvement 2] - [Expected benefit]
- [ ] [Improvement 3] - [Expected benefit]

### Process Improvements
- [ ] Pre-commit hooks for developers
- [ ] IDE integration setup guide
- [ ] Automated baseline management
```

## Developer Guidance Template

```markdown
# Developer Quick Reference - Static Analysis

## Pre-Commit Checklist
- [ ] Run `./psalm-check.sh` locally
- [ ] No new baseline entries added
- [ ] Type hints on new public methods
- [ ] Array shapes documented for complex parameters

## Common Fixes

### Missing Return Type
```php
// Before
public function getEmail()
{
    return $this->email;
}

// After
public function getEmail(): ?string
{
    return $this->email;
}
```

### Nullable Return Handling
```php
// Before
$contact = Contact::find($id);
return $contact->name;

// After
$contact = Contact::find($id);
return $contact?->name ?? 'Unknown';
```

### Array Shape Documentation
```php
// Before
function process(array $data)
{
    return $data['email'];
}

// After
/**
 * @param array{email: string, name: string} $data
 */
function process(array $data): string
{
    return $data['email'];
}
```

## When to Suppress vs Fix
### Fix These (Always)
- MissingReturnType
- MissingParamType
- PropertyNotSetInConstructor
- Simple null checks

### Acceptable Suppressions
- ActiveRecord magic properties
- Third-party library limitations
- Complex legacy code (with TODO)

### Never Suppress
- Security-related issues
- Simple fixes (takes < 5 minutes)
- New code issues
```

## Use Case Examples

### Sprint Planning Integration
```markdown
## Static Analysis Task Estimation

**Story**: User Profile Enhancement
**Estimated Psalm Impact**:
- New methods: 3 (require return types) - 15 minutes
- Array parameters: 2 (need shape docs) - 30 minutes
- Null safety: 1 complex method - 45 minutes
**Total Quality Time**: ~1.5 hours

**Add to Definition of Done**:
- [ ] All new methods have explicit types
- [ ] No new baseline entries
- [ ] CI psalm job passes
```

### Code Review Integration
```markdown
## MR Static Analysis Review

**Branch**: feature/contact-enhancement
**Psalm Status**: ❌ Failed - 3 new errors

**Issues to Address**:
1. `ContactController::updateProfile()` missing return type
2. Array parameter in `validateContactData()` needs shape documentation
3. Possible null reference in email validation

**Reviewer Action**: Request fixes before approval
**Estimated Fix Time**: 20 minutes
```