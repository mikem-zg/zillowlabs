## Configuration Templates and Setup Guides

### FUB-Optimized Psalm Configuration

**Primary Configuration Template (`psalm.xml`)**
```xml
<?xml version="1.0"?>
<psalm
    errorLevel="2"
    resolveFromConfigFile="true"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="https://getpsalm.org/schema/config"
    xsi:schemaLocation="https://getpsalm.org/schema/config vendor/vimeo/psalm/config.xsd"
    phpVersion="8.1"
    findUnusedBaselineEntry="true"
    findUnusedCode="false"
>
    <projectFiles>
        <directory name="apps/richdesk" />
        <directory name="src" />
        <ignoreFiles>
            <directory name="vendor" />
            <directory name="apps/richdesk/tests/fixtures" />
            <directory name="node_modules" />
            <file name="bootstrap.php" />
        </ignoreFiles>
    </projectFiles>

    <issueHandlers>
        <!-- ActiveRecord dynamic properties - acceptable suppressions -->
        <UndefinedMagicPropertyFetch>
            <errorLevel type="suppress">
                <referencedClass name="ActiveRecord" />
                <referencedClass name="ActiveRecord\Model" />
            </errorLevel>
        </UndefinedMagicPropertyFetch>

        <UndefinedMagicPropertyAssignment>
            <errorLevel type="suppress">
                <referencedClass name="ActiveRecord" />
                <referencedClass name="ActiveRecord\Model" />
            </errorLevel>
        </UndefinedMagicPropertyAssignment>

        <!-- Strict on new code, lenient on legacy -->
        <MissingReturnType>
            <errorLevel type="error">
                <directory name="apps/richdesk/controllers/api/v2" />
                <directory name="src/Services" />
            </errorLevel>
        </MissingReturnType>

        <!-- Allow mixed types for legacy ActiveRecord -->
        <MixedAssignment>
            <errorLevel type="info">
                <referencedClass name="ActiveRecord" />
            </errorLevel>
        </MixedAssignment>
    </issueHandlers>

    <plugins>
        <pluginClass class="Psalm\PhpUnitPlugin\Plugin"/>
    </plugins>
</psalm>
```

**Legacy Project Configuration (`psalm-legacy.xml`)**
```xml
<?xml version="1.0"?>
<psalm
    errorLevel="4"
    resolveFromConfigFile="true"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="https://getpsalm.org/schema/config"
    xsi:schemaLocation="https://getpsalm.org/schema/config vendor/vimeo/psalm/config.xsd"
    phpVersion="7.4"
    findUnusedBaselineEntry="true"
    findUnusedCode="false"
>
    <projectFiles>
        <directory name="legacy" />
        <ignoreFiles>
            <directory name="vendor" />
            <directory name="tests/fixtures" />
            <directory name="node_modules" />
        </ignoreFiles>
    </projectFiles>

    <issueHandlers>
        <!-- More lenient for legacy code -->
        <PropertyNotSetInConstructor errorLevel="info" />
        <MissingReturnType errorLevel="info" />
        <MixedAssignment errorLevel="suppress" />
        <MixedArgument errorLevel="suppress" />

        <!-- Still catch critical issues -->
        <InvalidReturnType errorLevel="error" />
        <InvalidArgument errorLevel="error" />
    </issueHandlers>
</psalm>
```

### Composer Integration Templates

**Composer.json Psalm Configuration**
```json
{
    "require-dev": {
        "vimeo/psalm": "^5.0",
        "psalm/plugin-phpunit": "^0.18"
    },
    "scripts": {
        "psalm": "psalm",
        "psalm-baseline": "psalm --set-baseline=psalm-baseline.xml",
        "psalm-info": "psalm --show-info=true",
        "psalm-stats": "psalm --stats",
        "psalm-dry-run": "psalm --alter --issues=all --dry-run"
    }
}
```

### IDE Integration Templates

**VS Code Settings (`settings.json`)**
```json
{
    "psalm.psalmScriptArgs": [
        "--show-diagnostic-warnings=false",
        "--use-baseline=psalm-baseline.xml",
        "--on-change-debounce-ms=1000"
    ],
    "psalm.enableDebugLog": false,
    "psalm.maxAnalysisThreads": 2,
    "files.associations": {
        "psalm.xml": "xml",
        "psalm-baseline.xml": "xml"
    }
}
```

**PhpStorm Configuration**
```xml
<!-- .idea/psalm.xml -->
<component name="PsalmOptionsConfiguration">
  <option name="options" value="--show-info=false --use-baseline=psalm-baseline.xml" />
  <option name="phpExecutablePath" value="$PROJECT_DIR$/vendor/bin/psalm" />
</component>
```

### CI/CD Pipeline Templates

**GitLab CI Configuration**
```yaml
# .gitlab-ci.yml
variables:
  PSALM_THREADS: "2"

stages:
  - test
  - analyze

test:psalm:
  extends: .analyze
  stage: test
  needs: []
  rules:
    - if: '$CI_PIPELINE_SOURCE != "schedule"'
    - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME'
  script:
    - composer install --no-dev --optimize-autoloader
    - ./vendor/bin/psalm --threads=$PSALM_THREADS --no-cache --stats
  allow_failure: false
  cache:
    key: psalm-cache-$CI_COMMIT_REF_SLUG
    paths:
      - .psalm/
  artifacts:
    reports:
      junit: psalm-junit.xml
    when: always
    expire_in: 1 week

psalm:baseline-check:
  stage: analyze
  rules:
    - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME'
  script:
    - composer install --no-dev --optimize-autoloader
    # Check if baseline grew
    - |
      if [ -f psalm-baseline.xml ]; then
        BASELINE_SIZE_BEFORE=$(git show HEAD~1:psalm-baseline.xml 2>/dev/null | wc -l || echo 0)
        BASELINE_SIZE_AFTER=$(wc -l < psalm-baseline.xml)
        if [ $BASELINE_SIZE_AFTER -gt $BASELINE_SIZE_BEFORE ]; then
          echo "⚠️  Baseline grew from $BASELINE_SIZE_BEFORE to $BASELINE_SIZE_AFTER lines"
          echo "New suppressions added - please review if they're necessary"
          exit 1
        else
          echo "✅ Baseline stable or reduced ($BASELINE_SIZE_BEFORE → $BASELINE_SIZE_AFTER)"
        fi
      fi
  allow_failure: false

psalm:security-scan:
  stage: analyze
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
  script:
    - composer install --no-dev --optimize-autoloader
    - ./vendor/bin/psalm --taint-analysis --report=psalm-security.json
  artifacts:
    reports:
      security: psalm-security.json
    expire_in: 1 week
```

**GitHub Actions Configuration**
```yaml
# .github/workflows/psalm.yml
name: Static Analysis

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  psalm:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: 8.1
        tools: composer:v2
        coverage: none

    - name: Cache Composer packages
      id: composer-cache
      uses: actions/cache@v3
      with:
        path: vendor
        key: ${{ runner.os }}-php-${{ hashFiles('**/composer.lock') }}
        restore-keys: |
          ${{ runner.os }}-php-

    - name: Install dependencies
      run: composer install --prefer-dist --no-progress --no-dev --optimize-autoloader

    - name: Cache Psalm
      uses: actions/cache@v3
      with:
        path: .psalm
        key: psalm-${{ github.sha }}
        restore-keys: |
          psalm-

    - name: Run Psalm
      run: ./vendor/bin/psalm --threads=2 --output-format=github
```

### Pre-commit Hook Templates

**Git Pre-commit Hook**
```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "Running Psalm static analysis..."

# Check if psalm is available
if [ ! -f "./vendor/bin/psalm" ]; then
    echo "Psalm not found. Run 'composer install' first."
    exit 1
fi

# Run psalm on staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$')

if [ -z "$STAGED_FILES" ]; then
    echo "No PHP files staged for commit."
    exit 0
fi

# Create temporary file with staged content
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

for FILE in $STAGED_FILES; do
    TEMP_FILE="$TEMP_DIR/$FILE"
    mkdir -p "$(dirname "$TEMP_FILE")"
    git show ":$FILE" > "$TEMP_FILE"
done

# Run psalm on staged files
if ! ./vendor/bin/psalm --no-cache --show-info=false; then
    echo ""
    echo "❌ Psalm found issues in staged files."
    echo "Please fix the issues before committing."
    echo ""
    echo "To see details: ./vendor/bin/psalm"
    echo "To update baseline: ./vendor/bin/psalm --set-baseline=psalm-baseline.xml"
    echo ""
    exit 1
fi

echo "✅ Psalm analysis passed!"
exit 0
```

**Husky Configuration**
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "*.php": [
      "php-cs-fixer fix --dry-run --diff",
      "vendor/bin/psalm --find-references-to=dummy --no-cache"
    ]
  }
}
```

### Development Environment Setup

**Docker Configuration**
```dockerfile
# Dockerfile.psalm
FROM php:8.1-cli

RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_mysql

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --optimize-autoloader

COPY . .

CMD ["./vendor/bin/psalm", "--threads=4", "--show-info=false"]
```

**Docker Compose Integration**
```yaml
# docker-compose.yml
version: '3.8'
services:
  psalm:
    build:
      context: .
      dockerfile: Dockerfile.psalm
    volumes:
      - .:/app
      - psalm-cache:/app/.psalm
    command: ["./vendor/bin/psalm", "--threads=4", "--stats"]

volumes:
  psalm-cache:
```

### Helper Scripts

**Psalm Wrapper Script (`scripts/psalm.sh`)**
```bash
#!/bin/bash
# Enhanced psalm wrapper with additional functionality

set -e

PSALM_BIN="./vendor/bin/psalm"
BASELINE_FILE="psalm-baseline.xml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  check       Run standard Psalm analysis (default)"
    echo "  baseline    Update baseline file"
    echo "  info        Show info-level issues"
    echo "  stats       Show analysis statistics"
    echo "  clear       Clear Psalm cache"
    echo "  security    Run taint analysis"
    echo "  fix         Run Psalter for automated fixes"
    echo ""
    echo "Options:"
    echo "  --threads=N    Number of analysis threads (default: 2)"
    echo "  --memory=XG    Memory limit (default: 1G)"
    echo "  --help         Show this help message"
}

check_psalm() {
    if [ ! -f "$PSALM_BIN" ]; then
        echo -e "${RED}❌ Psalm not found. Run 'composer install' first.${NC}"
        exit 1
    fi
}

run_analysis() {
    local threads=${1:-2}
    local memory=${2:-1G}

    echo -e "${YELLOW}🔍 Running Psalm analysis...${NC}"

    if $PSALM_BIN --threads=$threads --memory-limit=$memory --show-info=false --stats; then
        echo -e "${GREEN}✅ Analysis completed successfully${NC}"
    else
        echo -e "${RED}❌ Analysis found issues${NC}"
        return 1
    fi
}

update_baseline() {
    echo -e "${YELLOW}📋 Updating baseline...${NC}"

    if [ -f "$BASELINE_FILE" ]; then
        local old_size=$(wc -l < "$BASELINE_FILE")
        $PSALM_BIN --set-baseline="$BASELINE_FILE"
        local new_size=$(wc -l < "$BASELINE_FILE")

        if [ $new_size -lt $old_size ]; then
            echo -e "${GREEN}✅ Baseline reduced: $old_size → $new_size lines${NC}"
        elif [ $new_size -gt $old_size ]; then
            echo -e "${YELLOW}⚠️  Baseline grew: $old_size → $new_size lines${NC}"
        else
            echo -e "${GREEN}✅ Baseline stable: $new_size lines${NC}"
        fi
    else
        $PSALM_BIN --set-baseline="$BASELINE_FILE"
        echo -e "${GREEN}✅ Baseline created${NC}"
    fi
}

show_stats() {
    echo -e "${YELLOW}📊 Analysis Statistics:${NC}"
    $PSALM_BIN --stats

    if [ -f "$BASELINE_FILE" ]; then
        local baseline_size=$(wc -l < "$BASELINE_FILE")
        echo -e "\n${YELLOW}📋 Baseline Status:${NC}"
        echo "  Size: $baseline_size lines"
        echo "  Location: $BASELINE_FILE"
    fi
}

run_security_analysis() {
    echo -e "${YELLOW}🔒 Running security taint analysis...${NC}"
    $PSALM_BIN --taint-analysis --report=psalm-security.json
    echo -e "${GREEN}✅ Security analysis completed (results in psalm-security.json)${NC}"
}

run_fixes() {
    echo -e "${YELLOW}🔧 Running automated fixes...${NC}"
    echo -e "${YELLOW}Note: This will modify your code. Commit your changes first!${NC}"
    read -p "Continue? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $PSALM_BIN --alter --issues=MissingReturnType,MissingParamType --dry-run
        echo ""
        read -p "Apply these changes? (y/N): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            $PSALM_BIN --alter --issues=MissingReturnType,MissingParamType
            echo -e "${GREEN}✅ Automated fixes applied${NC}"
        else
            echo -e "${YELLOW}⚠️  Changes not applied${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Operation cancelled${NC}"
    fi
}

# Main execution
check_psalm

COMMAND=${1:-check}
THREADS=2
MEMORY="1G"

# Parse options
for arg in "$@"; do
    case $arg in
        --threads=*)
            THREADS="${arg#*=}"
            ;;
        --memory=*)
            MEMORY="${arg#*=}"
            ;;
        --help)
            usage
            exit 0
            ;;
    esac
done

case $COMMAND in
    check)
        run_analysis $THREADS $MEMORY
        ;;
    baseline)
        update_baseline
        ;;
    info)
        $PSALM_BIN --show-info=true
        ;;
    stats)
        show_stats
        ;;
    clear)
        $PSALM_BIN --clear-cache
        echo -e "${GREEN}✅ Cache cleared${NC}"
        ;;
    security)
        run_security_analysis
        ;;
    fix)
        run_fixes
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $COMMAND${NC}"
        usage
        exit 1
        ;;
esac
```

### Team Setup Checklist

**New Project Setup**
- [ ] Install Psalm via Composer
- [ ] Create `psalm.xml` configuration
- [ ] Set up IDE integration
- [ ] Configure pre-commit hooks
- [ ] Add CI/CD pipeline job
- [ ] Document team conventions
- [ ] Train team on type annotations

**Legacy Project Migration**
- [ ] Install Psalm with lenient configuration
- [ ] Generate initial baseline
- [ ] Set up CI job (allow failure initially)
- [ ] Plan baseline reduction strategy
- [ ] Coordinate with Backend Guild
- [ ] Gradually tighten error levels
- [ ] Remove baseline when possible