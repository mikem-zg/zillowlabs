## Integration with Development Lifecycle

### Pre-Development Investigation Workflow

**Complex Feature Investigation → Development Execution:**
```bash
# Complex feature investigation → development execution
/development-investigation --task="Analyze contact export feature requirements" --scope="feature-planning"
/code-development --task="Implement contact export based on investigation plan" --scope="small-feature"
/backend-test-development --target="ContactExportFeature" --test_type="comprehensive"
```

**Architecture Planning Workflow:**
```bash
# Large refactoring investigation → structured implementation
/development-investigation --task="Analyze email parser modernization" --scope="refactoring" --context="email-parsing"
/code-development --task="Modernize email parser architecture" --scope="large-refactoring"
/backend-test-development --target="EmailParserModernization" --test_type="integration"
```

**Performance Investigation → Optimization:**
```bash
# Performance analysis → optimization implementation
/development-investigation --task="Database query optimization analysis" --scope="performance" --context="database-layer"
/database-operations --operation="optimize-queries" --scope="investigation-based"
/backend-test-development --target="PerformanceOptimization" --test_type="performance"
```

### Bug Resolution Investigation Workflow

**Development-Side Bug Investigation → Targeted Fix:**
```bash
# Development-side bug investigation → targeted fix
/development-investigation --task="Investigate auth session timeout bug" --scope="bug-analysis" --context="authentication"
/code-development --task="Fix authentication session timeout" --scope="bug-fix"
/backend-test-development --target="AuthSessionTest" --test_type="regression"
```

**Cross-System Bug Investigation:**
```bash
# Multi-system bug investigation
/development-investigation --task="Contact sync failure analysis" --scope="bug-analysis" --context="integration"
/zillow-integration-systems --operation="debug-sync-failures"
/support-investigation --issue="Contact sync resolution validation" --environment="development"
```

**Performance Bug Investigation:**
```bash
# Performance-related bug investigation
/development-investigation --task="Slow query investigation" --scope="performance" --context="database-layer"
/database-operations --query="Performance analysis" --scope="investigation-based"
/datadog-management --operation="correlate-performance-metrics"
```

### Cross-Skill Integration Patterns

**Primary Integration Relationships:**

| Related Skill | Integration Type | Investigation Workflows |
|---------------|------------------|------------------------|
| `code-development` | **Implementation Execution** | Architecture analysis → Development → Validation |
| `serena-mcp` | **Code Analysis Foundation** | Semantic analysis → Architecture understanding → Planning |
| `backend-test-development` | **Validation Strategy** | Investigation criteria → Test requirements → Implementation validation |
| `support-investigation` | **Cross-Context Analysis** | Production analysis → Development investigation → Resolution |
| `database-operations` | **Data Layer Investigation** | Database patterns → Query optimization → Schema planning |
| `planning-workflow` | **Structured Investigation** | Investigation planning → Execution → Accountability |

### Workflow Handoff Patterns

**To development-investigation ← Other Skills:**
- **From `support-investigation`**: Production issue analysis requiring development-side investigation
- **From `serena-mcp`**: Semantic code analysis providing architecture context
- **From `database-operations`**: Database performance issues needing architecture analysis
- **From `planning-workflow`**: Structured investigation requirements and accountability framework

**From development-investigation → Other Skills:**
- **To `code-development`**: Implementation plans with technical specifications
- **To `backend-test-development`**: Test requirements and validation criteria
- **To `database-operations`**: Database optimization requirements and query improvements
- **To `support-investigation`**: Development-side findings for production issue resolution

### Multi-Skill Operation Examples

**Production Issue → Development Investigation → Resolution:**
```bash
# Complete production-to-development resolution workflow
/support-investigation --issue="Contact import failures" --environment="production"
/development-investigation --task="Investigate contact import architecture" --scope="bug-analysis"
/serena-mcp --task="Analyze contact import code patterns" --scope="bug-investigation"
/code-development --task="Fix contact import based on findings" --scope="bug-fix"
/backend-test-development --target="ContactImportFix" --test_type="regression"
```

**Feature Development with Comprehensive Investigation:**
```bash
# End-to-end feature development workflow
/planning-workflow --task="Plan notification system feature" --scope="feature-planning"
/development-investigation --task="Analyze real-time notifications architecture" --scope="feature-planning"
/serena-mcp --task="Explore notification framework patterns" --scope="architecture-analysis"
/code-development --task="Implement notifications following investigation" --scope="small-feature"
/backend-test-development --target="NotificationSystem" --test_type="integration"
/datadog-management --operation="setup-notification-monitoring"
```

**Large-Scale Refactoring Investigation:**
```bash
# Comprehensive refactoring workflow
/development-investigation --task="Email parser modernization analysis" --scope="refactoring" --context="email-parsing"
/serena-mcp --task="Analyze current email parser structure" --scope="refactoring-analysis"
/database-operations --query="Email parser database impact assessment"
/code-development --task="Modernize email parser with investigation guidance" --scope="large-refactoring"
/backend-test-development --target="EmailParserRefactoring" --test_type="comprehensive"
```

**Performance Optimization Investigation Workflow:**
```bash
# Systematic performance optimization
/development-investigation --task="Database performance bottleneck analysis" --scope="performance" --context="database-layer"
/database-operations --operation="analyze-query-performance" --scope="investigation-guided"
/serena-mcp --task="Identify performance-critical code paths" --scope="performance-analysis"
/code-development --task="Implement performance optimizations" --scope="performance-improvement"
/backend-test-development --target="PerformanceOptimization" --test_type="performance"
/datadog-management --operation="validate-performance-improvements"
```

### Integration Workflow Patterns

**Investigation Planning Integration:**
```bash
# Structured investigation with accountability
/planning-workflow --task="Plan authentication refactor investigation" --scope="investigation-planning"
/development-investigation --task="Authentication system architecture analysis" --scope="architecture"
# → TaskUpdate completion with findings summary
# → TaskCreate follow-up development tasks
```

**Experimental Investigation Integration:**
```bash
# Scientific investigation with validation
/development-investigation --experimental=true --hypothesis_driven=true \
  --task="Payment system architecture design" --scope="architecture" --context="payments"
# → Generates statistical validation reports
# → Feeds into /code-development with confidence scores
# → Integrates with /backend-test-development for A/B validation
```

**Cross-System Investigation Integration:**
```bash
# Multi-system investigation coordination
/development-investigation --task="Zillow integration performance analysis" --scope="performance"
/zillow-integration-systems --operation="analyze-integration-bottlenecks"
/datadog-management --operation="correlate-zillow-integration-metrics"
/database-operations --query="Zillow integration query optimization"
```

### Quality Assurance Integration

**Investigation Validation Patterns:**
```bash
# Quality assurance integration
/development-investigation --task="Feature implementation requirements" --scope="feature-planning"
# → Produces structured documentation with validation criteria
# → /backend-test-development uses criteria for test requirements
# → /code-development follows implementation specifications
# → /support-investigation validates production deployment
```

**Documentation Integration Patterns:**
```bash
# Comprehensive documentation workflow
/development-investigation --task="API design investigation" --scope="architecture"
/documentation-retrieval --query="API pattern research and best practices"
/confluence-management --operation="document-api-design-decisions"
/code-development --task="Implement API following investigation design"
```

### Specialized Integration Scenarios

**Security Investigation Integration:**
```bash
# Security-focused investigation workflow
/development-investigation --task="Authentication security enhancement" --scope="architecture" --context="authentication"
/security-analysis --assessment="authentication-security-review"  # (if available)
/code-development --task="Implement security enhancements" --scope="security-improvement"
/backend-test-development --target="SecurityEnhancement" --test_type="security"
```

**Data Integration Investigation:**
```bash
# Data architecture investigation
/development-investigation --task="Data pipeline architecture analysis" --scope="architecture" --context="data-processing"
/databricks-analytics --operation="analyze-data-pipeline-performance"
/database-operations --operation="optimize-data-pipeline-queries"
/code-development --task="Implement data pipeline improvements"
```

**External System Integration Investigation:**
```bash
# Third-party integration investigation
/development-investigation --task="External API integration analysis" --scope="feature-planning" --context="external-integration"
/documentation-retrieval --query="External API documentation and patterns"
/code-development --task="Implement external API integration"
/backend-test-development --target="ExternalIntegration" --test_type="integration"
/datadog-management --operation="monitor-external-api-integration"
```