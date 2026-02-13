---
name: email-parser-development
description: Email parser development from sample emails to tested parser implementation with production monitoring for FUB lead source integration
---

## Overview

Email parser development from sample emails to tested parser implementation with production monitoring for FUB lead source integration. Handles the complete lifecycle from sample email collection through production deployment and monitoring, following proven patterns from existing FUB email parser implementations with robust testing and comprehensive coverage analysis.

## Usage

```bash
/email-parser-development --lead_source="<source_name>" [--action=<action_type>] [--parser_path=<file_path>]
```

Common invocations:
- `/email-parser-development --lead_source="ZillowPremier" --action="create"`
- `/email-parser-development --lead_source="RealtorRDC" --action="test"`
- `/email-parser-development --lead_source="Realtor.com" --action="debug"`
- `/email-parser-development --lead_source="BoldLeads" --action="coverage-analysis"`

📁 **Implementation Patterns**: [implementation/parser-patterns.md](implementation/parser-patterns.md)

## Core Workflow

### Essential Email Parser Development Steps (Most Common - 90% of Usage)

**1. Sample Email Collection and PII Scrubbing**
```bash
# Obtain samples via CSD (https://csd.followupboss.com)
# Tools menu → Download Lead Emails → Enter message ID

# Convert .eml files if needed
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 simulateImap convertRaw /path/to/file.eml true'

# Scrub PII from samples
sed -i 's/original-email@domain.com/test@example.com/g' sample.txt
sed -i 's/John Smith/Test User/g' sample.txt
```

**2. Parser Implementation Following FUB Patterns**
```php
// Create parser class extending EmailParser
// Location: apps/richdesk/analysis/email_parser/[LeadSourceName].php
class [LeadSourceName] extends EmailParser {
    public function recognize(array $email): bool { /* recognition logic */ }
    protected function _parseEmailBody(array $email): array { /* parsing logic */ }
}

// Register in LeadEmail model
// Add to static $parsers array before 'LeadMetadata'
```

**3. Comprehensive Testing and Coverage**
```bash
# Create PHPUnit test class
# Location: apps/richdesk/tests/cases/analysis/[LeadSourceName]Test.php

# Execute tests remotely with coverage
ssh fubdev-matttu-dev-01 'cd /var/www/fub && XDEBUG_MODE=coverage ./vendor/bin/phpunit --coverage-clover phpunit-cache/cov-[parser].xml apps/richdesk/tests/cases/analysis/[LeadSourceName]Test.php'

# Analyze coverage locally
xmlstarlet sel -t -m "//class[@name=\"richdesk\\analysis\\email_parser\\[LeadSourceName]\"]" -v "concat('Coverage: ', @coverage, '%')" coverage.xml
```

**Preconditions:**
- **FUB Development Environment**: SSH access to `fubdev-matttu-dev-01`
- **Sample Repository**: Access to `test-lead-emails` repository structure
- **Local Tools**: `xmlstarlet` installed via Homebrew for coverage analysis
- **Testing Framework**: Remote PHPUnit configuration and DatabaseTestCase patterns

### Behavior

When invoked, execute this systematic parser development workflow:

**1. Sample Collection and Validation**
- Obtain sample emails via CSD tools or message ID lookup
- Convert .eml files to FUB-compatible format using remote li3 commands
- Scrub all PII (names, emails, phones, addresses) while maintaining parser functionality
- Organize samples in `test-lead-emails/emails/[ParserName]/` directory structure

**2. Parser Implementation and Registration**
- Create parser class extending EmailParser with required `recognize()` and `_parseEmailBody()` methods
- Implement recognition logic using distinctive email elements and patterns
- Use EmailParser helper methods for consistent text processing and field extraction
- Register parser in LeadEmail model with correct precedence order

**3. Testing and Coverage Validation**
- Create comprehensive PHPUnit test suite following DatabaseTestCase patterns
- Execute tests on remote FUB development server with coverage analysis
- Validate >80% coverage for parser methods using local xmlstarlet analysis
- Update parsed directory with expected JSON output for regression testing

**4. Production Deployment and Monitoring**
- Coordinate deployment with static analysis validation and quality checks
- Set up Datadog monitoring for parser success rates and error detection
- Validate lead attribution and processing pipeline in production environment
- Configure alerts for parser failures and performance degradation

## Quick Reference

📊 **Complete Reference**: [reference/quick-reference.md](reference/quick-reference.md)

| Phase | Key Actions | Success Criteria |
|-------|-------------|------------------|
| **Sample Collection** | Gather and scrub PII from emails | Multiple samples with PII removed |
| **Implementation** | Create parser class with FUB patterns | Extends EmailParser, implements required methods |
| **Registration** | Add to LeadEmail model | Parser in correct precedence order |
| **Testing** | Remote PHPUnit execution | All tests pass, >80% coverage |
| **Production** | Deployment and monitoring | No errors, >95% success rate |

### File Structure

```
apps/richdesk/analysis/email_parser/[LeadSourceName].php     # Parser class
apps/richdesk/tests/cases/analysis/[LeadSourceName]Test.php  # Tests
apps/richdesk/models/LeadEmail.php                          # Registration
test-lead-emails/emails/[LeadSourceName]/                   # Sample emails
```

### Essential Commands

```bash
# Test parser remotely
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 leads test /var/www/test-lead-emails/emails/[Parser]/sample.txt'

# Coverage analysis locally
xmlstarlet sel -t -m "//class[@name=\"richdesk\\analysis\\email_parser\\[Parser]\"]/methods/method" -v "concat(@name, ': ', @coverage, '% coverage')" -n coverage.xml
```

## Advanced Patterns

🔧 **Testing Patterns**: [testing/test-patterns.md](testing/test-patterns.md)

<details>
<summary>Click to expand advanced testing and implementation patterns</summary>

### Advanced Testing Scenarios
- Comprehensive PHPUnit test patterns with DatabaseTestCase
- Remote test execution with coverage analysis
- PII scrubbing workflow for sample email privacy
- Regression testing with JSON output validation

### Production Monitoring Integration
- Datadog monitoring setup for parser success rates
- Error pattern analysis and alerting configuration
- Performance monitoring and debugging workflows
- Lead attribution validation in FUB UI

📚 **Complete Testing Documentation**: [testing/test-patterns.md](testing/test-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Development → Testing → Monitoring:**
```bash
# Complete parser development workflow
/email-parser-development --lead_source="NewParser" --action="create" |\
  backend-static-analysis --focus="type-safety" |\
  backend-test-development --target="NewParserTest.php" --coverage_target=80 |\
  datadog-management --action="create_monitor" --service="email_parsing"
```

**Quality Assurance → Production:**
```bash
# Parser validation and deployment
/email-parser-development --lead_source="ExistingParser" --action="debug" |\
  code-development --task="Fix parser issues" --scope="bug-fix" |\
  backend-test-development --action="regression" --coverage_target=80
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `code-development` | **Implementation** | Parser class development, refactoring, bug fixes |
| `backend-test-development` | **Testing** | PHPUnit execution, coverage analysis, regression testing |
| `backend-static-analysis` | **Quality** | Psalm validation, type safety, code quality metrics |
| `datadog-management` | **Monitoring** | Production monitoring, error analysis, performance tracking |
| `support-investigation` | **Debugging** | Production issue troubleshooting, parser failure analysis |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Multi-Skill Operation Examples

**Complete Email Parser Development Workflow:**
1. `email-parser-development` - Create parser with sample collection and implementation
2. `backend-static-analysis` - Validate type safety and code quality standards
3. `backend-test-development` - Execute comprehensive testing with coverage analysis
4. `datadog-management` - Set up production monitoring and error alerting
5. `support-investigation` - Validate deployment and monitor for issues