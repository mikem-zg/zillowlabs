# Psalm Best Practices & Recent Developments

Comprehensive reference for FUB's Psalm static analysis including recent baseline reduction initiatives, official documentation, and proven remediation strategies.

## Recent Developments & Initiatives

### Psalm Baseline Paydown Initiative (2025)
**Source**: [Google Drive - Psalm Baseline Paydown Initiative](https://docs.google.com/document/d/1YPZOXSQJznC_JVXmBf2u1JQO0G8vRvw5-ewhzPJzXHk)
**Lead**: Steven Wade, Charles Zink

**Key Points**:
- **Goal**: Remove 30,000 baseline issues across ~128 rules in 2025
- **Approach**: Distributed across FUB+ teams with tech initiatives
- **Ultimate Objective**: Remove baseline entirely and surface all errors as MR blockers
- **Tool**: Potential use of [Psalter](https://psalm.dev/docs/manipulating_code/fixing/) for auto-correction

**Issue Priority Breakdown**:
1. **RiskyTruthyFalsyComparison**: 5,948 issues (977 files)
2. **MissingReturnType**: 5,697 issues (1,069 files)
3. **PropertyNotSetInConstructor**: 1,815 issues (896 files)
4. **PossiblyNullPropertyFetch**: 1,169 issues (218 files)
5. **PossiblyInvalidPropertyFetch**: 1,153 issues (160 files)

### "Chipping Away at the Psalm Baseline" Guide
**Source**: [Confluence - FUB Dev Environment](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1042088236)

**Step-by-Step Baseline Reduction Process**:

1. **Start Clean**: Branch from main or existing feature branch
2. **Remove Specific Entries**: Target individual errors or entire files
3. **Rerun Psalm**: From `/var/www/fub/apps/richdesk` directory:
   ```bash
   ../../vendor/bin/psalm --no-cache
   ```
4. **Fix Issues**: Address Psalm feedback systematically
5. **Commit Changes**: Include both code fixes and baseline modifications

**VS Code Integration**:
- Use `cmd + shift + p` → "Psalm: Restart Psalm Language Server"
- Alternative to command line execution

### Testing Guild Developments (2024)
**Source**: [Google Drive - Testing Guild Sync](https://docs.google.com/document/d/1AM_QhOi3FgnR5gldSwNST_pZRZ44hg5fQIPjWvbXpmQ)

**Key Initiatives**:
- Re-enable Psalm for test classes with appropriate error suppression
- Address PHP warnings and notices in test suite
- Improved type annotations through static analysis feedback
- Controller tester migration project extended to Q4 2024

## Official Psalm Documentation References

### Core Documentation
- **Homepage**: https://psalm.dev/
- **Main Documentation**: https://psalm.dev/docs/
- **Error Levels**: https://psalm.dev/docs/running_psalm/error_levels/
- **Baseline Files**: https://psalm.dev/docs/running_psalm/dealing_with_code_issues/#using-a-baseline-file
- **Fixing Code**: https://psalm.dev/docs/manipulating_code/fixing/

### Configuration References
- **Configuration Guide**: https://psalm.dev/docs/running_psalm/configuration/
- **Suppressing Issues**: https://psalm.dev/docs/running_psalm/dealing_with_code_issues/
- **IDE Integration**: https://psalm.dev/docs/running_psalm/ide_support/

### Error Type Documentation
- **All Error Types**: https://psalm.dev/docs/running_psalm/error_levels/
- **Mixed Types**: https://psalm.dev/docs/running_psalm/issues/MixedAssignment/
- **Null Safety**: https://psalm.dev/docs/running_psalm/issues/PossiblyNullReference/
- **Type Annotations**: https://psalm.dev/docs/annotating_code/type_syntax/

## FUB-Specific Best Practices

### Current Configuration Standards
**Error Level**: 2 (moderate strictness)
**PHP Target Version**: 8.1
**Baseline File**: `psalm-baseline.xml`
**Configuration File**: `psalm.xml`

### Acceptable Suppression Patterns

#### ActiveRecord Dynamic Properties
```php
class Contact extends ActiveRecord
{
    /** @property string $email */  // Document dynamic properties
    /** @property string $name */
    /** @property ?\DateTime $created_at */

    public function getFormattedName(): string
    {
        // Type assertion for safety when needed
        assert(is_string($this->name));
        return ucwords($this->name);
    }
}
```

#### Dynamic Class References
```php
$class = 'richdesk\\communications\\notifications\\' . $name;
/**
 * @psalm-suppress InvalidStringClass
 */
return $class::DEFAULT_PREFERENCES[$type] ?? null;
```

#### Container Type Safety
```php
public static function fromContainer(): InboxAppHelper
{
    $container = Container::instance();
    $helper = $container->get(self::class);
    // Type check ensures we have correct type
    assert($helper instanceof self);
    return $helper;
}
```

### Required Patterns for New Code

#### Explicit Return Types
```php
// Required for all new public methods
public function getContactStatus(int $contactId): ?string
{
    $contact = Contact::find($contactId);
    return $contact?->status;
}
```

#### Array Shape Documentation
```php
/**
 * @param array{
 *   email: string,
 *   phone?: string,
 *   name?: string,
 *   source: 'zillow'|'zhl'|'manual',
 *   metadata: array<string, mixed>
 * } $leadData
 */
function processLead(array $leadData): int
{
    // Type-safe processing with documented shape
    $contact = new Contact();
    $contact->email = $leadData['email'];
    $contact->source = $leadData['source'];

    return $contact->save() ? $contact->id : 0;
}
```

#### Null Safety Patterns
```php
// Preferred null-safe operator usage
$user = User::find($id);
$displayName = $user?->name ?? 'Unknown User';

// Or explicit null checking for complex logic
if ($user !== null && $user->isActive()) {
    return $user->getPreferences();
}

return [];
```

## Common Usage Examples

### Standard Psalm Commands & Helper Script
**Primary Tool**: `vendor/bin/psalm` (included with composer)
**Helper Script**: `.claude/skills/backend-static-analysis/scripts/psalm-check.sh`

```bash
# Standard Psalm commands (recommended)
vendor/bin/psalm                    # Standard analysis
vendor/bin/psalm --set-baseline=psalm-baseline.xml  # Update baseline
vendor/bin/psalm --show-info=true   # Show comprehensive issues
vendor/bin/psalm --clear-cache      # Clear cache
vendor/bin/psalm --stats --threads=4 # With performance options

# Helper script (provides additional convenience)
.claude/skills/backend-static-analysis/scripts/psalm-check.sh check
.claude/skills/backend-static-analysis/scripts/psalm-check.sh baseline
.claude/skills/backend-static-analysis/scripts/psalm-check.sh info --stats
.claude/skills/backend-static-analysis/scripts/psalm-check.sh clear
```

### VS Code Configuration
**File**: `.vscode/settings.json`

```json
{
  "psalm.psalmScriptArgs": [
    "--on-change-debounce-ms=1000",
    "--show-diagnostic-warnings=false",
    "--use-baseline=psalm-baseline.xml"
  ]
}
```

### CI/CD Integration
**File**: `.gitlab/.gitlab-ci.yml`

```yaml
test:psalm:
  extends: .analyze
  stage: test
  rules:
    - if: '$CI_PIPELINE_SOURCE != "schedule"'
  script:
    - vendor/bin/psalm --threads=2 --no-cache
```

## Error Resolution Workflows

### Priority 1: Critical Issues (Fix Immediately)

#### Missing Return Types (5,697 issues)
```php
// Before
public function cancel()
{
    $this->status = 'cancelled';
    return $this->save();
}

// After
public function cancel(): bool
{
    $this->status = 'cancelled';
    return $this->save();
}
```

#### Property Not Set in Constructor (1,815 issues)
```php
// Before
class ContactProcessor
{
    private Logger $logger; // Not initialized

    public function __construct()
    {
        // Missing initialization
    }
}

// After
class ContactProcessor
{
    private Logger $logger;

    public function __construct()
    {
        $this->logger = LoggerFactory::getLogger(static::class);
    }
}
```

### Priority 2: Type Safety Issues

#### Mixed Assignment Resolution
```php
// Before
$data = json_decode($json); // Returns mixed
$email = $data['email']; // Mixed assignment

// After
/** @var array{email: string, name: string} $data */
$data = json_decode($json, true);
assert(is_array($data));
$email = $data['email']; // Now type-safe
```

#### Null Reference Safety
```php
// Before
$user = User::find($id);
echo $user->name; // PossiblyNullReference

// After - Option 1: Null-safe operator
$user = User::find($id);
echo $user?->name ?? 'Unknown';

// After - Option 2: Explicit check
$user = User::find($id);
if ($user !== null) {
    echo $user->name;
}
```

## Baseline Management Strategies

### When to Add to Baseline
- **Legacy code** being modified but not fully refactored
- **Third-party integration** limitations that can't be resolved
- **Complex refactoring** planned for future sprint
- **Gradual refactoring** where fixing would expand scope significantly

### When NOT to Add to Baseline
- **New code** - must pass without baseline additions
- **Simple fixes** - missing return types, basic null checks
- **Security issues** - nullable passwords, unvalidated inputs
- **Quick wins** - issues that take < 15 minutes to resolve

### Gradual Reduction Process

#### Monthly Targets (Based on Initiative)
- **Month 1**: Focus on MissingReturnType (5,697 → 4,000)
- **Month 2**: PropertyNotSetInConstructor (1,815 → 1,000)
- **Month 3**: PossiblyNullReference patterns (837 → 500)
- **Quarterly Goal**: 25% baseline reduction (30,000 → 22,500 issues)

#### Team Distribution Strategy
- **Backend Guild**: Coordinate cross-team efforts
- **AI/Paper Cut Days**: Dedicated time for baseline reduction
- **Incremental Approach**: 10-20 issues per MR to avoid scope creep
- **Documentation**: Track progress with team impact metrics

## Integration with Development Workflow

### Pre-Commit Standards
- Run `psalm-check.sh` before submitting MRs
- New code must pass without baseline additions
- Public methods require explicit return types
- Complex arrays need shape documentation

### Code Review Requirements
- Verify no new baseline entries without justification
- Check type annotations on modified methods
- Ensure suppression comments include TODO references
- Validate null safety patterns are used consistently

### CI/CD Quality Gates
- Psalm job must pass (except hotfix branches)
- Failures block deployment to main/qa branches
- Statistics tracking for baseline size trends
- Integration with SonarQube for quality metrics

## Team Resources & Training

### Documentation Links
- **Confluence**: [Setting up Psalm locally](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/858259457)
- **Google Doc**: [FUB Psalm Announcement](https://docs.google.com/document/d/18C806jYnwCNhOmFvZuVge0wLwsTtX4f6EukjC_6uRIE/edit)
- **Codebase**: [psalm-readme.md](https://github.com/FollowUpBoss/fub/blob/main/psalm-readme.md)

### Team Coordination
- **Backend Guild**: Monthly sync on baseline reduction progress
- **Testing Guild**: Coordination on test class Psalm enablement
- **Tech Initiative Tracking**: Progress metrics and team allocation
- **Cross-Team Support**: Shared knowledge base and troubleshooting

This comprehensive reference ensures teams have access to the latest developments, official documentation, and proven strategies for maintaining high code quality through effective static analysis practices.