---
name: code-development
description: Comprehensive coding workflow with safe development practices, quality standards, and verification protocols for feature implementation, bug fixes, and refactoring in FUB's Lithium framework backend and TypeScript frontend development environments
---

## Overview

Comprehensive coding workflow with safe development practices, quality standards, and verification protocols for feature implementation, bug fixes, and refactoring in FUB's Lithium framework backend and TypeScript frontend development environments.

## Usage

```bash
/code-development --task="<description>" [--scope=<type>] [--files=<context>]
```

**Parameters:**
- `--task` (required): Task description (e.g., "Add user export feature", "Fix parsing bug in PROJ-12345", "Refactor authentication logic")
- `--scope` (optional): Scope specification
  - `small-feature`: Single component changes, minor additions
  - `large-refactoring`: Multiple files, structural changes
  - `bug-fix`: Error corrections and issue resolution
  - `critical-path`: Urgent, security-related, or production fixes
- `--files` (optional): Specific files to modify or project context

📁 **Comprehensive Examples**: [examples/basic-usage-examples.md](examples/basic-usage-examples.md)

## Core Workflow

### Essential Development Process (Most Common - 90% of Usage)

**1. Task Analysis and Planning**
```bash
# Feature implementation with scope specification
/code-development --task="Add user export feature" --scope="small-feature" --files="UserController.php,ExportService.php"

# Bug fix with issue reference
/code-development --task="Fix parsing bug in PROJ-12345" --scope="bug-fix" --files="ImportParser.php"

# Refactoring with architectural changes
/code-development --task="Refactor authentication logic" --scope="large-refactoring" --files="AuthController.php,AuthService.php,middleware/"
```

**2. Safe Development Process**
- **Analysis**: Understand task scope, identify affected components, assess impact and dependencies
- **Planning**: Create implementation strategy, identify potential risks, plan testing approach
- **Implementation**: Make targeted changes with safety checks, follow FUB coding standards
- **Verification**: Run comprehensive tests, validate functionality, ensure security standards

**3. Quality Assurance and Standards**
```bash
# Automated quality checks during development
- Code style validation (Lithium framework standards)
- Type safety verification (PHP strict types, TypeScript)
- Security vulnerability scanning (OWASP guidelines)
- Performance impact assessment
- Test coverage requirements
```

**4. FUB-Specific Integration**
- **Backend**: Lithium framework patterns, PHP 8+ features, MariaDB integration
- **Frontend**: TypeScript, modern JavaScript standards, component-based architecture
- **Testing**: Comprehensive test suites, automated validation, performance benchmarks
- **Security**: Authentication, authorization, input validation, data protection

### Behavior

When invoked, execute this systematic development workflow:

**1. Task Assessment and Planning**
- Parse task description and identify scope (feature, bug-fix, refactoring, performance)
- Analyze affected files and dependencies within FUB codebase
- Determine implementation strategy and identify potential risks
- Plan testing approach and validation requirements

**2. Implementation with Safety Checks**
- Apply FUB coding standards and Lithium framework patterns
- Implement changes with proper error handling and validation
- Ensure security compliance (authentication, authorization, input validation)
- Maintain backward compatibility and performance standards

**3. Verification and Quality Assurance**
- Execute comprehensive test suites (unit, integration, end-to-end)
- Validate functionality against requirements and acceptance criteria
- Perform security scanning and vulnerability assessment
- Measure performance impact and optimization opportunities

**4. Integration and Handoff**
- Prepare code for review and deployment processes
- Generate documentation and update relevant technical specifications
- Coordinate with CI/CD pipelines and deployment automation
- Provide integration guidance for downstream development workflows

## Quick Reference

📊 **Complete Reference**: [reference/detailed-reference.md](reference/detailed-reference.md)

| Scope | Purpose | Common Tasks | Validation Requirements |
|-------|---------|--------------|------------------------|
| `small-feature` | Single component additions | Form fields, API endpoints, utility functions | Unit tests, integration tests |
| `large-feature` | Multi-component features | Complete workflows, new modules | Full test suite, performance testing |
| `bug-fix` | Error corrections | Logic fixes, data validation, error handling | Regression tests, root cause validation |
| `refactoring` | Code improvements | Structure optimization, pattern updates | Existing functionality preservation |
| `performance` | Optimization tasks | Query optimization, caching, algorithms | Performance benchmarks, load testing |
| `security` | Security enhancements | Authentication, authorization, validation | Security scanning, penetration testing |

### FUB Development Environment Standards

**Backend (Lithium Framework):**
- PHP 8+ with strict typing and modern language features
- Lithium MVC patterns and framework conventions
- MariaDB with optimized queries and proper indexing
- Comprehensive error handling and logging

**Frontend (TypeScript):**
- Modern TypeScript with strict type checking
- Component-based architecture and reusable patterns
- Performance optimization and lazy loading
- Accessibility compliance and responsive design

## Advanced Patterns

🔧 **Advanced Techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced development patterns and optimization strategies</summary>

### Complex Refactoring and Architectural Patterns

**Advanced architectural changes with dependency analysis:**
```bash
# Large-scale refactoring with impact assessment
/code-development --task="Migrate to microservices architecture" --scope="large-refactoring" --files="services/,controllers/,models/"
```

**Performance optimization and profiling:**
```bash
# Performance-critical optimization with benchmarking
/code-development --task="Optimize database query performance" --scope="performance" --files="QueryBuilder.php,DatabaseService.php"
```

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Development → Quality Assurance:**
```bash
# Code development with integrated testing
/code-development --task="Add user authentication" --scope="small-feature" |\
  backend-test-development --test-type="integration" --coverage="auth-module"

# Development with static analysis
/code-development --task="Refactor payment processing" --scope="refactoring" |\
  backend-static-analysis --focus="security,performance" --psalm-level="1"
```

**Planning → Development → Deployment:**
```bash
# Complete development workflow integration
/planning-workflow --task="User management feature" --phase="implementation" |\
  code-development --task="Implement user CRUD operations" --scope="large-feature" |\
  database-operations --task="Deploy user schema changes" --environment="staging"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `backend-test-development` | **Quality Assurance** | Test implementation, coverage analysis, integration testing |
| `backend-static-analysis` | **Code Quality** | Type safety validation, security scanning, performance analysis |
| `database-operations` | **Data Layer** | Schema changes, migration implementation, query optimization |
| `planning-workflow` | **Project Management** | Task planning, scope management, accountability tracking |
| `gitlab-pipeline-monitoring` | **CI/CD Integration** | Pipeline configuration, deployment automation, build monitoring |
| `support-investigation` | **Incident Response** | Bug investigation, root cause analysis, hotfix implementation |
| `fub-integrations` | **Domain Knowledge** | Codebase navigation, integration patterns, business logic implementation |
| `confluence-management` | **Documentation** | Technical documentation, API documentation, development guides |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Specialized Development Areas

🏗️ **FUB-Specific Patterns**: [fub-specific/](fub-specific/)

**Lithium framework patterns, TypeScript standards, database interaction patterns**

🔧 **Quality Standards**: [quality/](quality/)

**Testing requirements, code review processes, security guidelines**

⚒️ **Development Tools**: [tools/](tools/)

**Tool configuration, CI/CD integration, development environment setup**

### Multi-Skill Operation Examples

**Complete Feature Development Workflow:**
1. `planning-workflow` - Plan feature implementation with scope and timeline
2. `code-development` - Implement feature with quality standards and testing
3. `backend-test-development` - Create comprehensive test coverage
4. `database-operations` - Deploy database schema changes if required
5. `gitlab-pipeline-monitoring` - Monitor CI/CD pipeline and deployment

**Complete Bug Resolution Workflow:**
1. `support-investigation` - Analyze incident and identify root cause
2. `code-development` - Implement fix with proper testing and validation
3. `backend-static-analysis` - Validate fix quality and security compliance
4. `database-operations` - Apply data fixes or schema corrections if needed
5. `confluence-management` - Update troubleshooting documentation

**Complete Refactoring Workflow:**
1. `backend-static-analysis` - Analyze current code quality and identify improvements
2. `code-development` - Implement refactoring with architectural improvements
3. `backend-test-development` - Ensure comprehensive test coverage for changes
4. `planning-workflow` - Update project timeline and coordinate team communication
5. `gitlab-pipeline-monitoring` - Monitor deployment and performance impact