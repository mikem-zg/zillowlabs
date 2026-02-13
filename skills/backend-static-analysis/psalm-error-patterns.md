# Psalm Error Patterns Reference

Comprehensive reference for common Psalm error types in FUB codebase with remediation strategies.

## Critical Error Types (Fix Immediately)

### MissingReturnType
**Description**: Function/method missing explicit return type declaration.
**Impact**: High - Reduces type safety and IDE support.
**Fix**: Add explicit return type annotation.

```php
// Error
public function getContactName($id)
{
    return Contact::find($id)?->name;
}

// Fixed
public function getContactName(int $id): ?string
{
    return Contact::find($id)?->name;
}
```

### MissingParamType
**Description**: Function parameter missing type declaration.
**Impact**: High - Loss of type information at function boundaries.
**Fix**: Add parameter type hints.

```php
// Error
public function updateContact($id, $data)
{
    // ...
}

// Fixed
/**
 * @param array{name?: string, email?: string} $data
 */
public function updateContact(int $id, array $data): void
{
    // ...
}
```

### PropertyNotSetInConstructor
**Description**: Class property declared but not initialized in constructor.
**Impact**: High - Potential null reference errors.
**Fix**: Initialize in constructor or mark as nullable.

```php
// Error
class ContactProcessor
{
    private Logger $logger; // Not initialized

    public function __construct()
    {
        // Missing logger initialization
    }
}

// Fixed
class ContactProcessor
{
    private Logger $logger;

    public function __construct()
    {
        $this->logger = LoggerFactory::getLogger(static::class);
    }
}
```

## Type Safety Issues (Medium Priority)

### MixedAssignment
**Description**: Assignment loses type information.
**Impact**: Medium - Reduces type checking effectiveness.
**Fix**: Use explicit types or assertions.

```php
// Error
$data = json_decode($json); // Returns mixed
$email = $data['email']; // Mixed assignment

// Fixed
/** @var array{email: string, name: string} $data */
$data = json_decode($json, true);
assert(is_array($data));
$email = $data['email']; // Now string
```

### PossiblyNullReference
**Description**: Accessing property/method on potentially null object.
**Impact**: Medium - Runtime null pointer exceptions.
**Fix**: Add null checks or use null-safe operators.

```php
// Error
$contact = Contact::find($id);
echo $contact->name; // $contact could be null

// Fixed - Option 1: Null check
$contact = Contact::find($id);
if ($contact !== null) {
    echo $contact->name;
}

// Fixed - Option 2: Null-safe operator
$contact = Contact::find($id);
echo $contact?->name ?? 'Unknown';
```

### MixedArrayAccess
**Description**: Array access without type information.
**Impact**: Medium - No type checking on array operations.
**Fix**: Document array shapes or use typed objects.

```php
// Error
function processLead(array $data)
{
    return $data['email']; // Mixed array access
}

// Fixed
/**
 * @param array{email: string, phone?: string, name?: string} $data
 * @return string
 */
function processLead(array $data): string
{
    return $data['email']; // Type-safe access
}
```

## Legacy/Suppressed Issues (Background Cleanup)

### UndefinedMagicPropertyAssignment
**Description**: Assignment to dynamic ActiveRecord properties.
**Impact**: Low - Expected behavior in ActiveRecord pattern.
**Acceptable Suppression**: Yes, for ActiveRecord models.

```php
// Acceptable pattern (suppressed globally)
class Contact extends ActiveRecord
{
    /** @property string $email */
    /** @property string $name */

    public function updateFromForm(array $data): void
    {
        $this->email = $data['email']; // Magic property assignment
        $this->name = $data['name'];
    }
}
```

### DocblockTypeContradiction
**Description**: Docblock type conflicts with inferred type.
**Impact**: Low - Documentation vs runtime mismatch.
**Fix**: Align docblock with actual return type.

```php
// Error
/**
 * @return string
 */
public function getStatus(): bool  // Contradiction
{
    return $this->active;
}

// Fixed
/**
 * @return bool
 */
public function getStatus(): bool
{
    return $this->active;
}
```

### RiskyTruthyFalsyComparison
**Description**: Loose boolean comparisons that may have unexpected results.
**Impact**: Low - Potential logic errors in edge cases.
**Fix**: Use strict comparisons when possible.

```php
// Error (but often acceptable)
if ($value) {
    // Could be risky for 0, "0", [], null
}

// Fixed (when stricter logic needed)
if ($value !== null && $value !== false) {
    // More explicit comparison
}
```

## FUB-Specific Patterns

### ActiveRecord Dynamic Properties
Pattern for handling ActiveRecord magic properties:

```php
class Contact extends ActiveRecord
{
    // Document all dynamic properties
    /** @property int $id */
    /** @property string $email */
    /** @property string $name */
    /** @property ?string $phone */
    /** @property \DateTime $created_at */
    /** @property \DateTime $updated_at */

    public function getDisplayName(): string
    {
        // Use assertion for type safety when needed
        assert(is_string($this->name));
        return ucwords($this->name);
    }
}
```

### Database Result Handling
Pattern for safe database query results:

```php
public function findActiveContact(int $contactId): ?Contact
{
    $contact = Contact::find($contactId);

    // Type assertion for ActiveRecord patterns
    if ($contact instanceof Contact && $contact->active) {
        return $contact;
    }

    return null;
}
```

### Array Shape Documentation
Required patterns for complex data structures:

```php
/**
 * Lead data structure from external APIs
 * @param array{
 *   email: string,
 *   phone?: string,
 *   name?: string,
 *   source: 'zillow'|'zhl'|'manual',
 *   metadata: array<string, mixed>,
 *   created_at: string
 * } $leadData
 */
function importLead(array $leadData): int
{
    // Type-safe processing with documented shape
    $contact = new Contact();
    $contact->email = $leadData['email']; // Safe - guaranteed string
    $contact->phone = $leadData['phone'] ?? null; // Safe - optional
    $contact->source = $leadData['source']; // Safe - union type

    return $contact->save() ? $contact->id : 0;
}
```

## Baseline Management Strategies

### When to Add to Baseline
- **Legacy code** being modified but not fully refactored
- **Third-party integration** limitations that can't be resolved
- **Complex refactoring** planned for future sprint

### When NOT to Add to Baseline
- **New code** - must pass without baseline additions
- **Simple fixes** - missing return types, basic null checks
- **Security issues** - nullable passwords, unvalidated inputs

### Baseline Reduction Process
1. **Identify low-hanging fruit**: MissingReturnType, MissingParamType
2. **Batch similar fixes**: All getters in a class, all setters
3. **Test thoroughly**: Each fix batch should have test coverage
4. **Update baseline incrementally**: Remove fixed issues in small commits

## Error Priority Matrix

| Error Type | Frequency | Impact | Fix Effort | Priority |
|------------|-----------|--------|------------|----------|
| MissingReturnType | High | High | Low | **Critical** |
| MissingParamType | High | High | Low | **Critical** |
| PropertyNotSetInConstructor | Medium | High | Medium | **High** |
| PossiblyNullReference | High | Medium | Low | **High** |
| MixedAssignment | Medium | Medium | Medium | **Medium** |
| MixedArrayAccess | Medium | Medium | High | **Medium** |
| UndefinedMagicProperty* | High | Low | N/A | **Suppress** |
| DocblockTypeContradiction | Low | Low | Low | **Low** |

## CI/CD Integration Patterns

### Required for All Branches
- Psalm must pass on `main` and `qa` branches
- Blocking CI job prevents merges with failures
- Exception: Hotfix branches may bypass (with approval)

### Merge Request Requirements
- No new baseline entries without justification comment
- Type hints required on new public methods
- Array shapes documented for complex parameters
- Suppressions include TODO tracking reference

### Deployment Gates
- Critical issues resolved before production deployment
- Baseline stable or decreasing trend
- No emergency suppressions in production code
- CI integration confirmed functional