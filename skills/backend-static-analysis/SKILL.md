---
name: backend-static-analysis
description: Comprehensive static analysis health assessment for PHP codebases using Psalm, focusing on type safety, error patterns, and code quality metrics in FUB development environment
argument-hint: [target-directory] [--baseline] [--ci-check]
allowed-tools: Read, Glob, Grep, Bash
---

## Overview

Analyzes backend code health through static analysis tools, particularly Psalm, to assess type safety, identify error patterns, and provide actionable insights for improving code quality in PHP projects. Integrated with FUB's development workflow and Backend Guild coordination.

🔍 **Error Analysis**: [methodologies/error-analysis.md](methodologies/error-analysis.md)
⚙️ **Configuration Templates**: [templates/configuration-templates.md](templates/configuration-templates.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
🔧 **Troubleshooting**: [reference/troubleshooting.md](reference/troubleshooting.md)

## Usage

```bash
/backend-static-analysis [target-directory] [--baseline] [--ci-check]
```

## Core Analysis Areas

### Error Pattern Analysis
Categorize and prioritize common Psalm error types:

**Critical Issues** (should be fixed immediately):
- `MissingReturnType` - Missing return type declarations
- `MissingParamType` - Missing parameter type declarations
- `PropertyNotSetInConstructor` - Uninitialized properties
- `InvalidReturnType` - Type mismatches in returns

**Type Safety Issues** (moderate priority):
- `MixedAssignment` / `MixedArgument` - Loss of type information
- `PossiblyNullReference` - Potential null pointer access
- `PossiblyUndefinedArrayOffset` - Array access without key validation
- `MixedArrayAccess` - Untyped array operations

**Legacy/Suppressed Issues** (background cleanup):
- `UndefinedMagicProperty*` - ActiveRecord dynamic properties
- `DocblockTypeContradiction` - Docblock vs runtime type conflicts
- `RiskyTruthyFalsyComparison` - Loose boolean comparisons

→ **Complete error analysis methodology**: [methodologies/error-analysis.md](methodologies/error-analysis.md)

### Configuration Assessment
- **Error Level**: Evaluate strictness settings (1-8 scale)
- **PHP Version**: Verify target version alignment (8.1+)
- **Baseline Status**: Check baseline file size and growth trends
- **Suppression Patterns**: Identify most common suppressed error types

## Essential Workflow

### 1. Initialize Analysis
```bash
# Basic health check on current directory
/backend-static-analysis

# Target specific directory with baseline analysis
/backend-static-analysis apps/richdesk/analysis --baseline

# CI/CD integration verification
/backend-static-analysis . --ci-check
```

### 2. Error Priority Matrix
| Error Type | Priority | Typical Fix Time | Impact |
|------------|----------|------------------|---------|
| `MissingReturnType` | Critical | 5-15 min | High - Type Safety |
| `PropertyNotSetInConstructor` | Critical | 15-30 min | High - Runtime Errors |
| `InvalidReturnType` | Critical | 30-60 min | High - Type Safety |
| `PossiblyNullReference` | Medium | 15-45 min | Medium - Runtime Errors |
| `MixedAssignment` | Medium | 30-90 min | Medium - Type Information Loss |
| `UndefinedMagicProperty*` | Low | Suppress | Low - ActiveRecord Legacy |

### 3. Common Commands
```bash
# Basic analysis (recommended default)
/backend-static-analysis

# Directory-specific analysis
/backend-static-analysis apps/richdesk/analysis

# Include baseline analysis and recommendations
/backend-static-analysis . --baseline

# CI/CD integration verification
/backend-static-analysis . --ci-check

# Manual Psalm execution
cd project-root && ./vendor/bin/psalm --show-info=false
```

## FUB-Specific Patterns

### ActiveRecord Integration
FUB uses ActiveRecord with dynamic properties requiring specific handling:

```php
// Acceptable suppression pattern
class Contact extends ActiveRecord
{
    /** @property string $email */  // Document dynamic properties
    /** @property string $name */

    public function getFormattedName(): string
    {
        assert($this->name !== null);  // Type assertion for safety
        return ucwords($this->name);
    }
}
```

### Array Shape Documentation
Required for complex data structures:

```php
/**
 * @param array{
 *   email: string,
 *   phone: string,
 *   name?: string,
 *   metadata: array<string, mixed>
 * } $leadData
 */
function processLead(array $leadData): void
{
    // Type-safe processing
}
```

### Null Safety Patterns
```php
public function findContactEmail(int $contactId): ?string
{
    $contact = Contact::find($contactId);
    return $contact?->email; // Safe null propagation
}

// Safe array access
return $leadData['source'] ?? 'unknown';

// Null safety with assertions
assert($contact->email !== null);
return strtolower($contact->email);
```

## Quality Gates and Standards

### Pre-Commit Standards
- New code must pass Psalm without baseline additions
- Public methods require explicit return types
- Array parameters need shape documentation
- Null safety patterns must be used consistently

### Code Review Requirements
- Psalm CI job must pass (except hotfix branches)
- No new baseline entries without justification
- Type annotations on modified methods
- Suppression comments include TODO references

### Quick Fixes Checklist
**For New Code:**
- [ ] All public methods have explicit return types
- [ ] Parameters have type declarations
- [ ] Array parameters use shape syntax when complex
- [ ] Null safety patterns applied consistently
- [ ] No new baseline entries

**For Legacy Code:**
- [ ] Focus on critical errors first (MissingReturnType, PropertyNotSetInConstructor)
- [ ] Document suppressions with TODO references
- [ ] Target 10-20% baseline reduction per sprint
- [ ] Coordinate large changes with Backend Guild

## Common Remediation Patterns

### Type Declaration Fixes
```php
// Before: MissingReturnType
public function getStatus()
{
    return $this->active ? 'active' : 'inactive';
}

// After: Explicit typing
public function getStatus(): string
{
    return $this->active ? 'active' : 'inactive';
}
```

### Null Safety Improvements
```php
// Before: PossiblyNullReference
$user = User::find($id);
echo $user->name; // Could be null

// After: Safe null handling
$user = User::find($id);
if ($user !== null) {
    echo $user->name;
}
// Or: echo $user?->name ?? 'Unknown';
```

### Array Shape Documentation
```php
// Before: MixedArrayAccess
function processData(array $data)
{
    return $data['email']; // Unsafe access
}

// After: Documented shape
/**
 * @param array{email: string, name: string} $data
 */
function processData(array $data): string
{
    return $data['email']; // Type-safe access
}
```

## Recent Developments & Initiatives

### Psalm Baseline Paydown Initiative (2025)
**Status**: Active cross-team initiative led by Backend Guild
**Goal**: Eliminate 30,000+ baseline issues to remove baseline file entirely
**Approach**: Distributed effort across FUB+ teams during tech initiative time

**Top Priority Issues**:
1. **RiskyTruthyFalsyComparison**: 5,948 issues (highest volume)
2. **MissingReturnType**: 5,697 issues (highest development impact)
3. **PropertyNotSetInConstructor**: 1,815 issues (type safety critical)

**Tools Available**:
- [Psalter](https://psalm.dev/docs/manipulating_code/fixing/) for automated fixes
- Team coordination through Backend Guild monthly syncs
- Progress tracking via tech initiative metrics

### Community Resources
**Documentation**:
- [Confluence: "Chipping Away at the Psalm Baseline"](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1042088236)
- [Google Drive: Psalm Baseline Paydown Initiative](https://docs.google.com/document/d/1YPZOXSQJznC_JVXmBf2u1JQO0G8vRvw5-ewhzPJzXHk)
- [Official Psalm Documentation](https://psalm.dev/docs/)

## Configuration and Setup

### Basic Configuration Example
```xml
<!-- psalm.xml optimized for FUB ActiveRecord patterns -->
<psalm errorLevel="2" phpVersion="8.1">
    <projectFiles>
        <directory name="apps/richdesk" />
        <ignoreFiles>
            <directory name="vendor" />
            <directory name="apps/richdesk/tests/fixtures" />
        </ignoreFiles>
    </projectFiles>

    <issueHandlers>
        <!-- ActiveRecord dynamic properties - acceptable suppressions -->
        <UndefinedMagicPropertyFetch>
            <errorLevel type="suppress">
                <referencedClass name="ActiveRecord" />
            </errorLevel>
        </UndefinedMagicPropertyFetch>

        <!-- Strict on new code, lenient on legacy -->
        <MissingReturnType>
            <errorLevel type="error">
                <directory name="apps/richdesk/controllers/api/v2" />
            </errorLevel>
        </MissingReturnType>
    </issueHandlers>
</psalm>
```

→ **Complete configuration templates**: [templates/configuration-templates.md](templates/configuration-templates.md)

### Daily Development Workflow
```bash
# Quick health check before committing
vendor/bin/psalm

# Update baseline after fixing issues
vendor/bin/psalm --set-baseline=psalm-baseline.xml

# Comprehensive analysis with statistics
vendor/bin/psalm --stats

# Clear cache for fresh analysis
vendor/bin/psalm --clear-cache && vendor/bin/psalm
```

### CI/CD Integration Pattern
```yaml
test:psalm:
  extends: .analyze
  stage: test
  needs: []
  rules:
    - if: '$CI_PIPELINE_SOURCE != "schedule"'
  script:
    - vendor/bin/psalm --threads=2 --no-cache --stats
  allow_failure: false  # Blocks deployment on failure
```

## Integration Points

### Cross-Skill Workflow Patterns

**Code Development Integration:**
```bash
# Pre-development type safety assessment
/backend-static-analysis --baseline |\
  code-development --workflow="feature" --include_type_safety=true

# Validate type safety during development iterations
/code-development --operation="review-changes" |\
  backend-static-analysis --target="modified-files" --strict=true
```

**Planning Workflow Integration:**
```bash
# Include type safety effort in sprint planning
/backend-static-analysis . --baseline |\
  planning-workflow --project="Psalm Baseline Reduction" --scope="tech-debt" --estimate_effort=true
```

**Database Operations Integration:**
```bash
# Validate type safety implications of database schema changes
/database-operations --operation="schema-migration" --environment="development" |\
  backend-static-analysis --validate-model-types --strict=true
```

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

### Related Skills
| Skill | Relationship | Common Workflows |
|-------|--------------|---------------------|
| **`code-development`** | **Quality Gates** | Pre-commit static analysis → Code review → Merge validation |
| **`planning-workflow`** | **Estimation Support** | Include type safety effort in story pointing and sprint planning |
| **`backend-test-development`** | **Test Quality** | Static analysis on test code, type safety for test utilities |
| **`database-operations`** | **Schema Validation** | Type safety for model properties, migration type checking |
| **`gitlab-pipeline-monitoring`** | **CI/CD Integration** | Psalm job monitoring, deployment gate enforcement |
| **`datadog-management`** | **Quality Metrics** | Baseline size tracking, error reduction progress monitoring |

## Advanced Features

→ **Advanced type patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Complete troubleshooting guide**: [reference/troubleshooting.md](reference/troubleshooting.md)

This skill provides systematic static analysis that integrates seamlessly with FUB's development workflow while supporting both immediate code quality improvements and long-term technical debt reduction strategies.