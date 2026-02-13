## Investigation Patterns and Templates

### Standard Investigation Template

**Investigation Step Template:**
```markdown
### Investigation Step Template:
YYYY-MM-DD HH:MM - [Analysis Phase]
**Tools Used**: [Serena MCP tools with specific queries]
**Code Analysis**: [Direct findings with file:line references]
**Patterns Identified**: [Framework patterns and conventions]
**Integration Points**: [Dependencies and external connections]
**Inference**: [Mark speculation clearly with supporting reasoning]
```

### Architecture Investigation Template

```markdown
# Architecture Investigation: [System/Feature Name]

## Current State Analysis
**Existing Implementation**: [Current code structure and patterns - file:line references]
**Framework Usage**: [Lithium framework utilization patterns]
**Integration Points**: [External system connections]
**Performance Characteristics**: [Query patterns and bottlenecks]

## Implementation Strategy
**Architecture Modifications**: [Required structural changes]
**Framework Alignment**: [Lithium best practices compliance]
**Migration Approach**: [Safe implementation strategy]
**Testing Integration**: [Validation approach with DatabaseTestCase]
```

### Performance Investigation Template

```markdown
# Performance Investigation: [Component Name]

## Performance Baseline
**Current Metrics**: [Existing performance measurements]
**Bottleneck Analysis**: [Specific performance issues with file:line references]
**Query Patterns**: [ActiveRecord usage and N+1 query analysis]
**Framework Efficiency**: [Lithium-specific optimization opportunities]

## Optimization Strategy
**Query Optimization**: [Specific ActiveRecord improvements]
**Caching Strategy**: [Framework-appropriate caching approach]
**Code Efficiency**: [Algorithm and logic optimizations]
**Validation Methods**: [How to measure improvement]
```

### Bug Analysis Investigation Template

```markdown
# Bug Analysis: [Issue Description]

## Issue Analysis
**Reproduction Steps**: [Exact reproduction method]
**Code Flow Trace**: [Execution path with file:line references]
**Framework Interaction**: [Lithium framework involvement]
**Data State Analysis**: [ActiveRecord and database examination]

## Fix Strategy
**Root Cause**: [Specific code issue identified]
**Fix Approach**: [Technical resolution strategy]
**Testing Strategy**: [Validation with DatabaseTestCase patterns]
**Prevention**: [How to prevent similar issues]
```

### Multi-System Integration Investigation

```markdown
# Integration Analysis: [System A] ↔ [System B]

## Integration State Analysis
**Data Flow Mapping**: [Current data movement patterns - file:line references]
**API Usage Patterns**: [Current API contract analysis]
**Error Handling**: [Integration failure handling patterns]
**Performance Impact**: [Integration bottlenecks and metrics]

## Integration Strategy
**API Standardization**: [Consistent API pattern implementation]
**Error Enhancement**: [Improved error handling and recovery]
**Performance Optimization**: [Caching, batching, async processing]
**Monitoring Integration**: [Health monitoring approach]
```

### Security Implementation Investigation

```markdown
# Security Investigation: [Security Requirement]

## Security Assessment
**Current Implementation**: [Existing security patterns - file:line references]
**Framework Security**: [Lithium security feature utilization]
**Vulnerability Analysis**: [Security gaps and risks identified]
**Compliance Requirements**: [Security standards and regulations]

## Security Strategy
**Authentication Enhancement**: [Improved authentication mechanisms]
**Authorization Patterns**: [Access control improvements]
**Data Protection**: [Encryption and data protection measures]
**Input Validation**: [Enhanced validation and sanitization]
```

### Database Performance Investigation

```markdown
# Database Performance: [Performance Issue]

## Performance Assessment
**Query Analysis**: [Current query patterns with execution metrics]
**ActiveRecord Usage**: [Framework usage pattern assessment]
**Schema Efficiency**: [Database schema and indexing analysis]
**N+1 Query Detection**: [Identify and analyze N+1 patterns - file:line references]

## Optimization Strategy
**Query Enhancement**: [Specific query optimization approaches]
**ActiveRecord Patterns**: [Improved framework usage patterns]
**Caching Implementation**: [Database caching strategy]
**Schema Improvements**: [Index and schema optimizations]
```

### Feature Planning Investigation Template

```markdown
# Feature Planning Investigation: [Feature Name]

## Requirements Analysis
**Functional Requirements**: [Core feature functionality needed]
**Non-Functional Requirements**: [Performance, security, scalability needs]
**User Experience Requirements**: [Interface and interaction patterns]
**Integration Requirements**: [External system dependencies]

## Technical Analysis
**Framework Alignment**: [How feature fits with Lithium patterns]
**Database Schema Impact**: [Required schema changes and migrations]
**API Design**: [Required API endpoints and contracts]
**Testing Strategy**: [Comprehensive testing approach]

## Implementation Strategy
**Development Phases**: [Logical implementation phases]
**Risk Assessment**: [Technical risks and mitigation strategies]
**Performance Considerations**: [Expected performance impact]
**Rollout Plan**: [Safe feature deployment strategy]
```

### Refactoring Investigation Template

```markdown
# Refactoring Investigation: [Component/System Name]

## Legacy Analysis
**Current Implementation**: [Existing code structure and patterns]
**Technical Debt Assessment**: [Identified issues and maintenance burden]
**Framework Compliance**: [Areas not following Lithium best practices]
**Performance Issues**: [Current performance bottlenecks]

## Modernization Strategy
**Target Architecture**: [Desired end-state architecture]
**Migration Approach**: [Safe refactoring strategy]
**Framework Alignment**: [Improved Lithium pattern usage]
**Backwards Compatibility**: [Maintaining compatibility during transition]

## Implementation Plan
**Refactoring Phases**: [Step-by-step modernization approach]
**Testing Strategy**: [Ensuring functionality preservation]
**Risk Mitigation**: [Strategies for safe refactoring]
**Success Metrics**: [How to measure refactoring success]
```

### Implementation Plan Structure Template

```markdown
# Implementation Plan Structure

## Technical Approach
1. **Architecture**: [Design decisions and integration strategy]
2. **Implementation Steps**: [Specific tasks in dependency order]
3. **Framework Integration**: [Lithium pattern leverage]
4. **Testing Strategy**: [DatabaseTestCase validation approach]

## Validation Criteria
- **Functional Requirements**: [Specific behavior requirements]
- **Performance Benchmarks**: [Measurable targets]
- **Security Standards**: [Security requirements]
- **Code Quality**: [Psalm compliance, coverage targets]
```

### Framework Pattern Analysis Template

```markdown
# Framework Pattern Analysis: [Component Name]

## Current Framework Usage
**ActiveRecord Patterns**: [Current ORM usage and relationship patterns]
**Controller Structure**: [Current controller organization and naming]
**Service Layer**: [Business logic organization patterns]
**Namespace Organization**: [Current namespace structure and imports]

## Framework Compliance Assessment
**Best Practices Alignment**: [Areas following Lithium conventions]
**Pattern Inconsistencies**: [Areas not following framework patterns]
**Performance Implications**: [Framework usage affecting performance]
**Modernization Opportunities**: [Areas for framework pattern improvement]

## Recommendations
**Pattern Improvements**: [Specific framework pattern enhancements]
**Structure Optimization**: [Organization and architecture improvements]
**Performance Optimization**: [Framework-specific performance improvements]
**Consistency Enhancement**: [Standardization across similar components]
```

### Cross-System Impact Analysis Template

```markdown
# Cross-System Impact Analysis: [Change Description]

## System Dependency Mapping
**Direct Dependencies**: [Systems directly affected by changes]
**Indirect Dependencies**: [Systems potentially affected through integration]
**Data Dependencies**: [Shared data structures and formats]
**API Dependencies**: [API contracts and integration points]

## Impact Assessment
**Breaking Changes**: [Changes that break existing functionality]
**Performance Impact**: [Expected performance effects on dependent systems]
**Security Implications**: [Security considerations across system boundaries]
**Migration Requirements**: [Changes needed in dependent systems]

## Mitigation Strategy
**Backwards Compatibility**: [Maintaining compatibility during transition]
**Communication Plan**: [Coordination with dependent system teams]
**Testing Strategy**: [Cross-system integration testing approach]
**Rollout Coordination**: [Synchronized deployment across systems]
```