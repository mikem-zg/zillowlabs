## Troubleshooting Guide and Best Practices

### Common Issues and Solutions

| **Issue** | **Symptoms** | **Solution** |
|-----------|-------------|--------------|
| **Psalm not found** | `command not found: psalm` | Install via Composer: `composer require --dev vimeo/psalm` |
| **Configuration not found** | `Could not locate a config XML file` | Create `psalm.xml` or use `./vendor/bin/psalm --init` |
| **Memory limit exceeded** | `Fatal error: Allowed memory size exhausted` | Increase memory: `--memory-limit=2G` or modify php.ini |
| **Analysis too slow** | Long execution times | Use `--threads=4` and `--no-cache` for troubleshooting |
| **Cache corruption** | Inconsistent results | Clear cache: `./vendor/bin/psalm --clear-cache` |
| **Baseline file locked** | Cannot update baseline | Check file permissions, ensure no concurrent processes |

### Error-Specific Troubleshooting

#### MissingReturnType Issues
```bash
# Quick fix for simple cases
./vendor/bin/psalter --issues=MissingReturnType --dry-run
./vendor/bin/psalter --issues=MissingReturnType --safe-types

# Manual verification for complex cases
grep -r "MissingReturnType" psalm-baseline.xml | head -5
```

**Common Causes:**
- Legacy code without type declarations
- Dynamic return types that Psalm can't infer
- Methods that return mixed types based on conditions

**Solutions:**
```php
// Before: Missing return type
public function getUserData($id) {
    return $this->findUser($id);
}

// After: Explicit return type
public function getUserData(int $id): ?User {
    return $this->findUser($id);
}

// Complex case: Union types
public function getResponse(): array|string {
    return $this->format === 'json' ? ['data' => $this->data] : 'formatted text';
}
```

#### PropertyNotSetInConstructor Issues
**Diagnostic Commands:**
```bash
# Find all uninitialized property errors
grep "PropertyNotSetInConstructor" psalm-baseline.xml | \
  sed 's/.*src="\([^"]*\)".*/\1/' | sort | uniq -c | sort -nr
```

**Common Patterns and Fixes:**
```php
// Before: Uninitialized property
class UserService {
    private Logger $logger;  // Not set in constructor

    public function __construct() {
        // Missing logger initialization
    }
}

// After: Proper initialization
class UserService {
    private Logger $logger;

    public function __construct() {
        $this->logger = LoggerFactory::create(static::class);
    }
}

// Alternative: Default values
class UserService {
    private array $cache = [];  // Default value
    private ?Logger $logger = null;  // Nullable with default
}
```

#### PossiblyNullReference Issues
**Analysis Tools:**
```bash
# Find null reference patterns
grep -A 2 -B 2 "PossiblyNullReference" psalm-baseline.xml
```

**Safe Patterns:**
```php
// Before: Unsafe null access
$user = User::find($id);
return $user->name;  // Could be null

// After: Safe null handling
$user = User::find($id);
return $user?->name ?? 'Unknown';

// With assertion for performance-critical code
$user = User::find($id);
assert($user !== null, "User $id must exist");
return $user->name;
```

#### Mixed Type Issues
**Detection Strategy:**
```bash
# Analyze mixed type sources
./vendor/bin/psalm --show-info=true | grep -i "mixed" | head -10
```

**Resolution Patterns:**
```php
// Before: Mixed assignment
$data = json_decode($jsonString);  // Returns mixed
$result = $data['key'];  // Mixed access

// After: Proper typing
/** @var array<string, mixed> $data */
$data = json_decode($jsonString, true);
assert(is_array($data), 'JSON must decode to array');

$result = $data['key'] ?? null;  // Controlled access
```

### Performance Troubleshooting

#### Slow Analysis Performance
**Diagnostic Commands:**
```bash
# Profile analysis time
time ./vendor/bin/psalm --threads=1 --no-cache
time ./vendor/bin/psalm --threads=4 --no-cache

# Identify slow files
./vendor/bin/psalm --debug 2>&1 | grep "took" | sort -k4 -nr | head -10
```

**Optimization Strategies:**
```xml
<!-- psalm.xml optimizations -->
<psalm errorLevel="2" phpVersion="8.1">
    <projectFiles>
        <directory name="src" />
        <ignoreFiles>
            <!-- Exclude slow/irrelevant files -->
            <directory name="src/Legacy/VeryLarge" />
            <file name="src/Generated/huge_file.php" />
        </ignoreFiles>
    </projectFiles>
</psalm>
```

#### Memory Issues
**Memory Optimization:**
```bash
# Progressive memory allocation testing
for mem in 1G 2G 4G; do
    echo "Testing with $mem memory:"
    timeout 300 ./vendor/bin/psalm --memory-limit=$mem --threads=2
done
```

**PHP Configuration:**
```ini
; php.ini optimizations for Psalm
memory_limit = 2G
max_execution_time = 300
opcache.enable_cli = 1
opcache.jit_buffer_size = 256M
```

### CI/CD Integration Troubleshooting

#### GitLab CI Issues
**Common Pipeline Failures:**
```yaml
# Debug GitLab CI Psalm issues
psalm-debug:
  stage: test
  script:
    - composer install --no-dev
    - ./vendor/bin/psalm --debug --no-cache 2>&1 | tee psalm-debug.log
    - echo "Exit code: $?"
  artifacts:
    paths:
      - psalm-debug.log
    when: always
```

**Performance Issues in CI:**
```yaml
# Optimized CI configuration
psalm:
  stage: test
  variables:
    PSALM_THREADS: "2"
    PSALM_MEMORY: "1G"
  script:
    - composer install --no-dev --optimize-autoloader
    - ./vendor/bin/psalm --threads=$PSALM_THREADS --memory-limit=$PSALM_MEMORY --no-progress
  cache:
    key: "psalm-$CI_COMMIT_REF_SLUG"
    paths:
      - .psalm/
      - vendor/
  timeout: 10 minutes
```

#### Docker Environment Issues
**Container Debugging:**
```dockerfile
# Debug Dockerfile for Psalm issues
FROM php:8.1-cli

# Install debugging tools
RUN apt-get update && apt-get install -y \
    htop \
    strace \
    time

# PHP optimizations
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/php.ini
RUN echo 'max_execution_time = 600' >> /usr/local/etc/php/php.ini

WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Debug command
CMD ["time", "./vendor/bin/psalm", "--stats", "--threads=2"]
```

### Configuration Troubleshooting

#### XML Configuration Validation
```bash
# Validate psalm.xml syntax
xmllint --schema vendor/vimeo/psalm/config.xsd psalm.xml

# Test configuration changes
./vendor/bin/psalm --config=psalm-test.xml --dry-run
```

#### Issue Handler Debugging
```xml
<!-- Debug issue handler configuration -->
<psalm errorLevel="1" phpVersion="8.1">
    <issueHandlers>
        <!-- Test specific error handling -->
        <MissingReturnType>
            <errorLevel type="info">
                <directory name="src/Debug" />
            </errorLevel>
        </MissingReturnType>
    </issueHandlers>
</psalm>
```

### IDE Integration Troubleshooting

#### VS Code Issues
**Common Problems:**
- Extension not finding Psalm binary
- Incorrect configuration path
- Performance issues with large codebases

**Solutions:**
```json
{
    "psalm.psalmScriptPath": "./vendor/bin/psalm",
    "psalm.enableDebugLog": true,
    "psalm.maxAnalysisThreads": 1,
    "files.watcherExclude": {
        ".psalm/**": true
    }
}
```

#### PhpStorm Integration
```xml
<!-- .idea/psalm.xml -->
<component name="PsalmOptionsConfiguration">
    <option name="options" value="--show-info=false --threads=1" />
    <option name="phpExecutablePath" value="$PROJECT_DIR$/vendor/bin/psalm" />
    <option name="timeout" value="30" />
</component>
```

### Baseline Management Troubleshooting

#### Baseline Corruption
**Diagnostic Steps:**
```bash
# Check baseline file integrity
xmllint psalm-baseline.xml
wc -l psalm-baseline.xml
grep -c '<file src=' psalm-baseline.xml

# Validate baseline entries
./vendor/bin/psalm --use-baseline=psalm-baseline.xml --show-info=false
```

**Recovery Procedures:**
```bash
# Backup and regenerate baseline
cp psalm-baseline.xml psalm-baseline.backup.xml
./vendor/bin/psalm --set-baseline=psalm-baseline-new.xml

# Compare and merge if needed
diff psalm-baseline.xml psalm-baseline-new.xml
```

#### Baseline Growth Issues
**Monitoring Script:**
```bash
#!/bin/bash
# baseline-monitor.sh

BASELINE_FILE="psalm-baseline.xml"
ALERT_THRESHOLD=50  # Alert if baseline grows by more than 50 errors

if [[ ! -f "$BASELINE_FILE" ]]; then
    echo "No baseline file found"
    exit 0
fi

# Get current size
CURRENT_SIZE=$(grep -c 'type=' "$BASELINE_FILE")

# Get size from last week
LAST_WEEK_SIZE=$(git show HEAD~7:"$BASELINE_FILE" 2>/dev/null | grep -c 'type=' || echo $CURRENT_SIZE)

# Calculate growth
GROWTH=$((CURRENT_SIZE - LAST_WEEK_SIZE))

echo "Baseline monitoring report:"
echo "Current size: $CURRENT_SIZE errors"
echo "Last week: $LAST_WEEK_SIZE errors"
echo "Growth: $GROWTH errors"

if [[ $GROWTH -gt $ALERT_THRESHOLD ]]; then
    echo "⚠️ ALERT: Baseline grew by $GROWTH errors (threshold: $ALERT_THRESHOLD)"
    echo "Recent contributors:"
    git log --since="7 days ago" --oneline -- "$BASELINE_FILE" | head -5
    exit 1
else
    echo "✅ Baseline growth within acceptable limits"
fi
```

### Development Workflow Troubleshooting

#### Pre-commit Hook Issues
**Common Problems:**
- Hook not executable
- Wrong path to Psalm
- Performance issues blocking commits

**Solutions:**
```bash
#!/bin/sh
# .git/hooks/pre-commit

set -e

# Quick performance check
if [[ $(find . -name "*.php" -newer .psalm/cache | wc -l) -gt 100 ]]; then
    echo "Large changeset detected, running focused analysis..."
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$' | tr '\n' ' ')
    if [[ -n "$STAGED_FILES" ]]; then
        ./vendor/bin/psalm --threads=1 --no-cache $STAGED_FILES
    fi
else
    echo "Running full Psalm analysis..."
    ./vendor/bin/psalm --threads=2 --show-info=false
fi
```

### Recovery and Emergency Procedures

#### Emergency Psalm Bypass
```bash
# Temporary bypass for hotfix deployments
echo "⚠️ EMERGENCY: Temporarily bypassing Psalm for hotfix"

# Document the bypass
echo "$(date): Emergency Psalm bypass for hotfix" >> psalm-bypass-log.txt
echo "Reason: $HOTFIX_REASON" >> psalm-bypass-log.txt

# Create temporary lenient configuration
cat > psalm-emergency.xml << 'EOF'
<psalm errorLevel="8" phpVersion="8.1">
    <projectFiles>
        <directory name="src" />
    </projectFiles>
</psalm>
EOF

# Run with lenient config
./vendor/bin/psalm --config=psalm-emergency.xml
```

#### Baseline Recovery from Backup
```bash
# Automated baseline recovery
recover_baseline() {
    local backup_file="$1"
    local current_baseline="psalm-baseline.xml"

    echo "🔄 Recovering baseline from $backup_file"

    if [[ ! -f "$backup_file" ]]; then
        echo "❌ Backup file not found: $backup_file"
        return 1
    fi

    # Validate backup
    if xmllint "$backup_file" >/dev/null 2>&1; then
        echo "✅ Backup file is valid XML"
        cp "$backup_file" "$current_baseline"

        # Test recovery
        if ./vendor/bin/psalm --use-baseline="$current_baseline" >/dev/null 2>&1; then
            echo "✅ Baseline recovery successful"
            return 0
        else
            echo "❌ Recovered baseline doesn't work with current code"
            return 1
        fi
    else
        echo "❌ Backup file is corrupted"
        return 1
    fi
}
```

### Best Practices for Troubleshooting

#### Systematic Debugging Approach
1. **Isolate the Problem**: Start with a minimal configuration
2. **Check Dependencies**: Ensure Composer packages are up to date
3. **Verify Environment**: Check PHP version and memory limits
4. **Test Incrementally**: Add complexity step by step
5. **Document Solutions**: Record fixes for team knowledge base

#### Preventive Measures
- Regular baseline health checks
- Automated performance monitoring
- Configuration validation in CI/CD
- Team training on common issues
- Documented escalation procedures

#### Emergency Contacts and Resources
- **Backend Guild**: Monthly coordination meeting for major issues
- **Psalm Community**: GitHub issues and Slack channel
- **Internal Documentation**: Confluence space for FUB-specific patterns
- **Escalation Path**: Tech Lead → Senior Engineer → Backend Guild Lead