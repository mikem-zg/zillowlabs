## Advanced Psalm Patterns and Optimization Techniques

### Complex Type Scenarios

#### Union and Intersection Types
```php
/**
 * @param string|int|null $value
 * @return non-empty-string
 */
public function formatValue(string|int|null $value): string
{
    if ($value === null) {
        return 'N/A';
    }

    $formatted = (string) $value;
    assert($formatted !== ''); // Psalm understands this assertion
    return $formatted;
}

/**
 * @param array<string, mixed>&array{id: int, name: string} $data
 */
public function processRequiredData(array $data): void
{
    // Intersection type: must be array with string keys AND have id/name
    echo "Processing ID: " . $data['id'];
    echo "Processing Name: " . $data['name'];
}
```

#### Generic Type Handling
```php
/**
 * @template T
 * @param class-string<T> $className
 * @return T
 */
public function createInstance(string $className): object
{
    return new $className();
}

/**
 * @template TKey of array-key
 * @template TValue
 * @param array<TKey, TValue> $items
 * @param callable(TValue): bool $predicate
 * @return array<TKey, TValue>
 */
function filter_array(array $items, callable $predicate): array
{
    return array_filter($items, $predicate, ARRAY_FILTER_USE_BOTH);
}

// Usage with type safety
$contact = $this->createInstance(Contact::class); // Returns Contact
$activeUsers = filter_array($users, fn($user) => $user->isActive());
```

#### Conditional Return Types
```php
/**
 * @template T
 * @param T $value
 * @return (T is null ? string : T)
 */
function processValue($value)
{
    if ($value === null) {
        return 'default'; // Returns string when input is null
    }
    return $value; // Returns T when input is not null
}

/**
 * @param bool $asArray
 * @return ($asArray is true ? array<string, mixed> : object)
 */
function getData(bool $asArray)
{
    $data = ['key' => 'value'];
    return $asArray ? $data : (object) $data;
}
```

### Performance Optimization Patterns

#### Large Codebase Analysis
```bash
# Parallel processing for faster analysis
./vendor/bin/psalm --threads=4 --show-info=false

# Memory optimization for large projects
./vendor/bin/psalm --memory-limit=2G

# Incremental analysis (Git-based)
./vendor/bin/psalm --diff

# Analysis with caching optimization
./vendor/bin/psalm --use-cache --cache-directory=.psalm-cache
```

#### CI/CD Optimization Strategies
```yaml
# Optimized GitLab CI configuration
psalm:
  stage: test
  image: php:8.1-cli
  variables:
    COMPOSER_CACHE_DIR: .composer-cache
  before_script:
    - curl -sS https://getcomposer.org/installer | php
    - php composer.phar install --no-dev --optimize-autoloader --no-progress
  script:
    - php composer.phar exec psalm -- --threads=2 --show-info=false --no-progress --report=psalm-junit.xml --report-show-info=false
  cache:
    key:
      files:
        - composer.lock
      prefix: psalm
    paths:
      - .composer-cache/
      - .psalm/
  artifacts:
    reports:
      junit: psalm-junit.xml
    when: always
    expire_in: 1 week
  rules:
    - if: '$CI_PIPELINE_SOURCE != "schedule"'
```

#### Memory and Performance Profiling
```bash
# Profile memory usage during analysis
time -v ./vendor/bin/psalm --memory-limit=4G --stats 2>&1 | tee psalm-profile.txt

# Identify slow analysis areas
./vendor/bin/psalm --debug --no-cache 2>&1 | grep "took" | sort -k4 -nr | head -10

# Thread performance analysis
for threads in 1 2 4 8; do
    echo "Testing $threads threads:"
    time ./vendor/bin/psalm --threads=$threads --no-cache --show-info=false
done
```

### Baseline Reduction Strategies

#### Automated Baseline Cleanup
```bash
#!/bin/bash
# baseline-reduction.sh - Systematic baseline reduction script

set -e

BASELINE_FILE="psalm-baseline.xml"
BACKUP_FILE="psalm-baseline.backup.xml"

# Create backup
cp "$BASELINE_FILE" "$BACKUP_FILE"

echo "📊 Current baseline statistics:"
echo "Total lines: $(wc -l < "$BASELINE_FILE")"
echo "File count: $(grep -c '<file src=' "$BASELINE_FILE")"
echo "Error count: $(grep -c 'type=' "$BASELINE_FILE")"

# Analyze error distribution
echo -e "\n🔍 Error type distribution:"
grep 'type=' "$BASELINE_FILE" | sed 's/.*type="\([^"]*\)".*/\1/' | sort | uniq -c | sort -nr | head -10

# Generate new baseline to see current state
echo -e "\n🔄 Generating new baseline..."
./vendor/bin/psalm --set-baseline=psalm-baseline-new.xml

# Compare baseline files
echo -e "\n📈 Baseline comparison:"
ERRORS_FIXED=$(diff "$BASELINE_FILE" psalm-baseline-new.xml | grep "^-" | grep -c 'type=' || echo 0)
NEW_ERRORS=$(diff "$BASELINE_FILE" psalm-baseline-new.xml | grep "^+" | grep -c 'type=' || echo 0)

echo "Errors fixed: $ERRORS_FIXED"
echo "New errors: $NEW_ERRORS"

if [[ $ERRORS_FIXED -gt 0 && $NEW_ERRORS -eq 0 ]]; then
    echo "✅ Baseline improved! Updating..."
    mv psalm-baseline-new.xml "$BASELINE_FILE"
    echo "🎉 Baseline reduced by $ERRORS_FIXED errors!"
else
    echo "⚠️  No net improvement. Keeping original baseline."
    rm psalm-baseline-new.xml
fi
```

#### Targeted Error Type Reduction
```bash
# Focus on specific error types for systematic cleanup
TARGET_ERROR="MissingReturnType"

echo "🎯 Targeting $TARGET_ERROR errors..."

# Extract files with specific error type
grep -l "$TARGET_ERROR" psalm-baseline.xml | while read -r line; do
    FILE=$(echo "$line" | sed 's/.*src="\([^"]*\)".*/\1/')
    echo "📁 $FILE has $TARGET_ERROR issues"
done

# Count specific error occurrences
echo "📊 $TARGET_ERROR count: $(grep -c "$TARGET_ERROR" psalm-baseline.xml)"

# Use Psalter for automatic fixes where possible
echo "🔧 Attempting automatic fixes..."
./vendor/bin/psalter --issues="$TARGET_ERROR" --dry-run

read -p "Apply automatic fixes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./vendor/bin/psalter --issues="$TARGET_ERROR" --safe-types
    echo "✅ Automatic fixes applied"

    # Update baseline
    ./vendor/bin/psalm --set-baseline=psalm-baseline.xml
    echo "📋 Baseline updated"
else
    echo "⚠️ Manual review required"
fi
```

### Custom Configuration Patterns

#### Progressive Error Level Strategy
```xml
<!-- psalm-progressive.xml - Gradually increase strictness -->
<psalm
    errorLevel="3"
    phpVersion="8.1"
    findUnusedBaselineEntry="true"
>
    <projectFiles>
        <directory name="src" />
    </projectFiles>

    <issueHandlers>
        <!-- New code: strictest rules -->
        <MissingReturnType>
            <errorLevel type="error">
                <directory name="src/NewFeatures" />
            </errorLevel>
            <errorLevel type="info">
                <directory name="src/Legacy" />
            </errorLevel>
        </MissingReturnType>

        <!-- Critical APIs: strict -->
        <PropertyNotSetInConstructor>
            <errorLevel type="error">
                <directory name="src/Services/Critical" />
            </errorLevel>
        </PropertyNotSetInConstructor>

        <!-- Gradual migration zones -->
        <PossiblyNullReference>
            <errorLevel type="error">
                <directory name="src/Controllers/V2" />
            </errorLevel>
            <errorLevel type="suppress">
                <directory name="src/Controllers/V1" />
            </errorLevel>
        </PossiblyNullReference>
    </issueHandlers>
</psalm>
```

#### Team-Based Configuration
```xml
<!-- psalm-teams.xml - Different rules for different teams -->
<psalm errorLevel="2" phpVersion="8.1">
    <issueHandlers>
        <!-- Backend team: strict type safety -->
        <MissingReturnType>
            <errorLevel type="error">
                <directory name="src/Backend" />
            </errorLevel>
        </MissingReturnType>

        <!-- API team: null safety critical -->
        <PossiblyNullReference>
            <errorLevel type="error">
                <directory name="src/Api" />
            </errorLevel>
        </PossiblyNullReference>

        <!-- Infrastructure team: mixed types allowed -->
        <MixedAssignment>
            <errorLevel type="info">
                <directory name="src/Infrastructure/Legacy" />
            </errorLevel>
        </MixedAssignment>

        <!-- Frontend team: lenient on ActiveRecord -->
        <UndefinedMagicPropertyFetch>
            <errorLevel type="suppress">
                <directory name="src/Frontend/Controllers" />
            </errorLevel>
        </UndefinedMagicPropertyFetch>
    </issueHandlers>
</psalm>
```

### Advanced Type Patterns

#### Complex Array Shapes
```php
/**
 * @psalm-type UserData = array{
 *   id: int,
 *   name: string,
 *   email: string,
 *   profile: array{
 *     avatar?: string,
 *     bio?: string,
 *     settings: array{
 *       notifications: bool,
 *       theme: 'light'|'dark',
 *       language: string
 *     }
 *   },
 *   roles: list<string>,
 *   metadata: array<string, mixed>
 * }
 */

/**
 * @param UserData $userData
 */
function processUser(array $userData): void
{
    // Fully type-safe access to nested data
    echo "User: " . $userData['name'];
    echo "Theme: " . $userData['profile']['settings']['theme'];

    foreach ($userData['roles'] as $role) {
        // $role is string
        echo "Role: " . $role;
    }
}
```

#### Custom Assert Functions
```php
/**
 * @psalm-assert !null $value
 * @param mixed $value
 */
function assertNotNull($value): void
{
    if ($value === null) {
        throw new InvalidArgumentException('Value cannot be null');
    }
}

/**
 * @psalm-assert string $value
 * @param mixed $value
 */
function assertString($value): void
{
    if (!is_string($value)) {
        throw new InvalidArgumentException('Value must be a string');
    }
}

// Usage
function processData($input): string
{
    assertNotNull($input);  // Psalm now knows $input is not null
    assertString($input);   // Psalm now knows $input is string

    return strtoupper($input); // No type errors
}
```

#### Plugin Development Patterns
```php
// Custom Psalm plugin for ActiveRecord patterns
class ActiveRecordPlugin extends \Psalm\Plugin\PluginEntryPointInterface
{
    public function __invoke(RegistrationInterface $registration, ?\SimpleXMLElement $config = null): void
    {
        require_once __DIR__ . '/ActiveRecordPropertyProvider.php';
        $registration->registerHooksFromClass(ActiveRecordPropertyProvider::class);
    }
}

class ActiveRecordPropertyProvider implements
    \Psalm\Plugin\Hook\PropertyExistenceProviderInterface,
    \Psalm\Plugin\Hook\PropertyTypeProviderInterface
{
    public static function getClassLikeNames(): array
    {
        return ['ActiveRecord\Model'];
    }

    public static function doesPropertyExist(
        string $fq_classlike_name,
        string $property_name,
        bool $read_mode,
        ?\Psalm\StatementsSource $source = null,
        ?\Psalm\Context $context = null,
        ?\Psalm\CodeLocation $code_location = null
    ): ?bool {
        // Check if property exists in database schema
        return $this->checkDatabaseProperty($fq_classlike_name, $property_name);
    }
}
```

### Deployment and Release Patterns

#### Zero-Downtime Type Safety Migration
```bash
#!/bin/bash
# migration-strategy.sh - Safe type system migration

echo "🚀 Starting type safety migration..."

# Phase 1: Establish baseline
echo "📋 Phase 1: Baseline establishment"
./vendor/bin/psalm --set-baseline=psalm-migration-baseline.xml
git add psalm-migration-baseline.xml
git commit -m "feat: establish psalm baseline for type safety migration"

# Phase 2: Enable CI without blocking
echo "⚙️  Phase 2: Enable CI monitoring (non-blocking)"
# Update .gitlab-ci.yml to add psalm job with allow_failure: true

# Phase 3: Fix critical issues
echo "🔧 Phase 3: Fix critical type safety issues"
./vendor/bin/psalter --issues=PropertyNotSetInConstructor,InvalidReturnType --safe-types

# Phase 4: Gradual error level increase
echo "📈 Phase 4: Increase error level strictness"
# Gradually change errorLevel from 8 -> 6 -> 4 -> 2

# Phase 5: Remove baseline
echo "🎯 Phase 5: Eliminate baseline"
BASELINE_SIZE=$(wc -l < psalm-migration-baseline.xml)
echo "Current baseline: $BASELINE_SIZE lines"

while [[ $BASELINE_SIZE -gt 10 ]]; do
    echo "Baseline reduction sprint - current size: $BASELINE_SIZE"
    # Fix batch of issues
    ./vendor/bin/psalm --set-baseline=psalm-migration-baseline.xml
    NEW_SIZE=$(wc -l < psalm-migration-baseline.xml)

    if [[ $NEW_SIZE -lt $BASELINE_SIZE ]]; then
        git add psalm-migration-baseline.xml
        git commit -m "refactor: reduce psalm baseline by $((BASELINE_SIZE - NEW_SIZE)) errors"
        BASELINE_SIZE=$NEW_SIZE
    else
        echo "No progress in this iteration"
        break
    fi
done

echo "✅ Migration completed!"
```

#### Production Health Monitoring
```bash
#!/bin/bash
# psalm-health-monitor.sh - Production type safety monitoring

# Generate health report
generate_health_report() {
    local timestamp=$(date -Iseconds)
    local report_file="psalm-health-$timestamp.json"

    echo "📊 Generating Psalm health report..."

    # Run analysis and capture metrics
    local stats_output=$(./vendor/bin/psalm --stats --output-format=json 2>/dev/null)
    local baseline_size=0

    if [[ -f "psalm-baseline.xml" ]]; then
        baseline_size=$(grep -c 'type=' psalm-baseline.xml)
    fi

    # Create health report
    cat > "$report_file" << EOF
{
    "timestamp": "$timestamp",
    "baseline_size": $baseline_size,
    "analysis_stats": $stats_output,
    "configuration": {
        "error_level": $(grep 'errorLevel=' psalm.xml | sed 's/.*errorLevel="\([^"]*\)".*/\1/'),
        "php_version": $(grep 'phpVersion=' psalm.xml | sed 's/.*phpVersion="\([^"]*\)".*/\1/')
    },
    "health_score": $(calculate_health_score $baseline_size)
}
EOF

    echo "📋 Health report saved: $report_file"
}

calculate_health_score() {
    local baseline_size=$1
    local score=100

    # Penalize based on baseline size
    if [[ $baseline_size -gt 15000 ]]; then
        score=30
    elif [[ $baseline_size -gt 5000 ]]; then
        score=50
    elif [[ $baseline_size -gt 1000 ]]; then
        score=70
    elif [[ $baseline_size -gt 100 ]]; then
        score=85
    fi

    echo $score
}

# Monitor trends
monitor_trends() {
    local days=${1:-7}

    echo "📈 Psalm trends over last $days days:"

    for i in $(seq 0 $days); do
        local date=$(date -d "$i days ago" +%Y-%m-%d)
        local commit=$(git rev-list -n 1 --before="$date" HEAD)

        if [[ -n "$commit" ]]; then
            local baseline_size=$(git show "$commit:psalm-baseline.xml" 2>/dev/null | grep -c 'type=' || echo 0)
            echo "  $date: $baseline_size errors"
        fi
    done
}

# Alert on health degradation
check_health_alerts() {
    local current_size=$(grep -c 'type=' psalm-baseline.xml 2>/dev/null || echo 0)
    local last_week_size=$(git show HEAD~7:psalm-baseline.xml 2>/dev/null | grep -c 'type=' || echo 0)

    if [[ $current_size -gt $((last_week_size * 110 / 100)) ]]; then
        echo "🚨 ALERT: Baseline grew by more than 10% in the last week"
        echo "   Previous: $last_week_size errors"
        echo "   Current:  $current_size errors"
        echo "   Growth:   $((current_size - last_week_size)) errors"

        # Send notification (integrate with your alerting system)
        # send_slack_alert "Psalm baseline grew significantly"
    fi
}

# Main execution
case "${1:-report}" in
    "report")
        generate_health_report
        ;;
    "trends")
        monitor_trends "${2:-7}"
        ;;
    "alerts")
        check_health_alerts
        ;;
    *)
        echo "Usage: $0 [report|trends|alerts]"
        exit 1
        ;;
esac
```