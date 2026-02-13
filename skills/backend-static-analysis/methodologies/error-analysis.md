## Error Pattern Analysis and Prioritization

### Error Categorization Matrix

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

### Priority Assessment Framework

**Error Priority Matrix**
| Error Type | Priority | Typical Fix Time | Impact |
|------------|----------|------------------|---------|
| `MissingReturnType` | Critical | 5-15 min | High - Type Safety |
| `PropertyNotSetInConstructor` | Critical | 15-30 min | High - Runtime Errors |
| `InvalidReturnType` | Critical | 30-60 min | High - Type Safety |
| `PossiblyNullReference` | Medium | 15-45 min | Medium - Runtime Errors |
| `MixedAssignment` | Medium | 30-90 min | Medium - Type Information Loss |
| `UndefinedMagicProperty*` | Low | Suppress | Low - ActiveRecord Legacy |

### Health Scoring Methodology

**Health Score Calculation (A/B/C/D Grade)**

**Grade A** (90-100 points):
- Error Level: 2 or higher (30 points)
- Baseline Size: < 1000 errors (25 points)
- CI Integration: Blocking deployment (25 points)
- New Code Compliance: 100% pass rate (20 points)

**Grade B** (70-89 points):
- Error Level: 3-4 (20 points)
- Baseline Size: 1000-5000 errors (15 points)
- CI Integration: Warning only (15 points)
- New Code Compliance: 80-99% pass rate (15 points)

**Grade C** (50-69 points):
- Error Level: 5-6 (10 points)
- Baseline Size: 5000-15000 errors (10 points)
- CI Integration: Present but not enforced (10 points)
- New Code Compliance: 60-79% pass rate (10 points)

**Grade D** (< 50 points):
- Error Level: 7-8 or no configuration
- Baseline Size: > 15000 errors
- CI Integration: Not present
- New Code Compliance: < 60% pass rate

### Analysis Workflow Methodology

**Step 1: Configuration Assessment**
1. **Locate Configuration Files**:
   - Primary: `psalm.xml` in project root
   - Fallback: `psalm.xml.dist`
   - Composer: `composer.json` psalm configuration

2. **Evaluate Critical Settings**:
   - Error level (target: 2 for production, 3-4 for legacy)
   - PHP version alignment (should match production)
   - Baseline file presence and size
   - Ignored directories and patterns

3. **Baseline Analysis**:
   - Total error count and trends
   - Error type distribution
   - Growth pattern over time
   - Team ownership patterns

**Step 2: Error Pattern Analysis**

1. **Volume Analysis**:
   ```bash
   # Parse baseline for error type distribution
   grep 'type=' psalm-baseline.xml | sort | uniq -c | sort -nr
   ```

2. **Impact Assessment**:
   - Runtime error potential (null references, array access)
   - Type safety degradation (mixed types, missing annotations)
   - Development velocity impact (unclear APIs, debugging difficulty)

3. **Remediation Feasibility**:
   - Automated fix potential (Psalter compatibility)
   - Breaking change risk
   - Team coordination requirements

**Step 3: Trend Analysis**

1. **Historical Baseline Growth**:
   ```bash
   # Track baseline size over time
   git log --oneline --stat psalm-baseline.xml | head -10
   ```

2. **Team Contribution Patterns**:
   - New error introduction rates by team
   - Cleanup effort distribution
   - Recurring problem areas

3. **CI Integration Effectiveness**:
   - Psalm job success/failure rates
   - Bypass frequency and justification
   - Performance impact on pipeline

### Prioritization Strategies

**Immediate Actions (Sprint-level)**:
1. **Critical Path Focus**: Fix errors in frequently modified files
2. **New Code Standards**: Ensure zero new baseline additions
3. **High-Impact, Low-Effort**: Target `MissingReturnType` for quick wins

**Short-term Goals (1-2 Sprints)**:
1. **Baseline Reduction**: Target 10-20% reduction per sprint
2. **Pattern Standardization**: Establish consistent null-safety patterns
3. **Tool Integration**: Improve IDE and CI integration

**Long-term Strategic Goals (Quarter)**:
1. **Error Level Advancement**: Progress from level 4 to level 2
2. **Baseline Elimination**: Remove baseline file entirely
3. **Team Capability**: Train developers on advanced type patterns

### Common Remediation Patterns

**Type Declaration Fixes**
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

**Null Safety Improvements**
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

**Array Shape Documentation**
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

### Quality Gates and Enforcement

**Pre-Commit Standards**
- New code must pass Psalm without baseline additions
- Public methods require explicit return types
- Array parameters need shape documentation
- Null safety patterns must be used consistently

**Code Review Requirements**
- Psalm CI job must pass (except hotfix branches)
- No new baseline entries without justification
- Type annotations on modified methods
- Suppression comments include TODO references

**Production Deployment Gates**
- All critical issues resolved
- Baseline stable or decreasing
- CI integration confirmed working
- No emergency suppressions without tracking

### FUB-Specific Analysis Patterns

**ActiveRecord Integration Patterns**
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

**Array Shape for Complex Data**
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
    // Type-safe processing with documented structure
}
```

**Nullable Return Handling**
```php
public function findContactEmail(int $contactId): ?string
{
    $contact = Contact::find($contactId);
    return $contact?->email; // Safe null propagation
}
```

### Team Coordination Methodology

**Ownership Models**
- **Individual Ownership**: Developers own baseline entries they create
- **Team Cleanup**: Monthly Backend Guild sessions for collective reduction
- **Migration Planning**: Coordinate large type system migrations across teams

**Progress Tracking**
```bash
# Weekly baseline metrics for team reporting
echo "Baseline Progress Report - $(date)"
echo "Current errors: $(grep -c '<file src=' psalm-baseline.xml)"
echo "Week-over-week change: $(git diff HEAD~7 psalm-baseline.xml | grep '^+<file\|^-<file' | wc -l)"
```

**Communication Strategies**
- Weekly baseline size reports in team standups
- Monthly Backend Guild coordination sessions
- Quarterly tech initiative planning with error reduction goals
- Individual developer coaching on type safety patterns