## Cross-Skill Integration Workflows and Coordination Patterns

### Cross-Skill Workflow Coordination

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `code-development` | **Implementation Research** | Library documentation, API usage patterns, implementation examples before coding |
| `backend-test-development` | **Testing Research** | Testing framework documentation, mocking patterns, test setup guides |
| `frontend-test-development` | **Frontend Testing** | React Testing Library docs, Jest patterns, testing best practices |
| `support-investigation` | **Issue Resolution** | Error documentation, debugging guides, configuration references |
| `database-operations` | **Database Documentation** | SQL documentation, ORM patterns, migration guides |
| `serena-mcp` | **Code Understanding** | Complement code analysis with external library documentation |
| `email-parser-development` | **Email Processing** | Email parsing libraries, RFC documentation, format specifications |

### Multi-Skill Operation Examples

**Complete Feature Implementation with Research:**
```bash
# 1. Research library patterns and best practices
/documentation-retrieval --library="React Query" --mode="code" --topic="data fetching patterns"

# 2. Analyze existing codebase integration points
/serena-mcp --operation="find-symbol" --name_path="ApiClient" --include_body=true

# 3. Implement feature following researched patterns
/code-development --task="Implement API data layer" --scope="small-feature"

# 4. Create tests based on documented patterns
/backend-test-development --target="ApiServiceTest" --test_type="integration"
```

**Complete Bug Investigation with Documentation:**
```bash
# 1. Initial issue analysis
/support-investigation --issue="Redis timeout errors" --environment="production"

# 2. Research known issues and solutions
/documentation-retrieval --library="Redis" --mode="info" --topic="timeout configuration"

# 3. Analyze implementation against patterns
/serena-mcp --operation="find-symbol" --name_path="RedisConnection" --include_body=true

# 4. Implement fix based on documented solutions
/code-development --task="Fix Redis timeout configuration" --scope="bugfix"
```

**Complete Library Integration Workflow:**
```bash
# 1. Comprehensive library research
/documentation-retrieval --library="Guzzle HTTP" --mode="info" --topic="getting started"

# 2. Plan integration with existing systems
/database-operations --operation="schema-review" --context="HTTP client integration"

# 3. Implement integration following patterns
/code-development --task="Add HTTP client service" --scope="medium-feature"

# 4. Create tests based on library documentation
/backend-test-development --target="HttpClientTest" --test_type="unit"
```

### Workflow Handoff Patterns

**From documentation-retrieval → Other Skills:**
- **API Documentation**: Provides library APIs, method signatures, configuration examples for implementation
- **Best Practices**: Supplies coding patterns, architecture guidelines, security recommendations
- **Integration Examples**: Delivers working code examples, setup procedures, troubleshooting guides
- **Team Context**: Offers internal service ownership, support channels, recent changes

**To documentation-retrieval ← Other Skills:**
- **Implementation Context**: Receives specific use cases, integration requirements, technical constraints
- **Bug Context**: Gets error patterns, failure scenarios, system configuration details
- **Library Requirements**: Obtains feature needs, performance requirements, compatibility constraints
- **Team Needs**: Receives team-specific research focus, internal service questions

### Bidirectional Integration Examples

**documentation-retrieval ↔ code-development:**
```bash
→ Provides: Library APIs, implementation patterns, configuration examples, security guidelines
← Receives: Specific implementation requirements, integration constraints, feature specifications
Integration: Research-driven development with documented patterns and examples
```

**documentation-retrieval ↔ support-investigation:**
```bash
→ Provides: Known issue documentation, troubleshooting guides, configuration references, debugging patterns
← Receives: Specific error contexts, system symptoms, investigation focus areas, affected components
Integration: Evidence-based troubleshooting using official documentation and community solutions
```

**documentation-retrieval ↔ backend-test-development:**
```bash
→ Provides: Testing framework docs, mocking patterns, test examples, assertion libraries
← Receives: Testing requirements, framework constraints, specific test scenarios, coverage goals
Integration: Documentation-guided test development with verified testing patterns and examples
```

### Multi-Stage Research Workflows

**Comprehensive Library Evaluation:**
```bash
# Stage 1: Initial assessment
/documentation-retrieval --library="Vue.js" --mode="info" --topic="overview"

# Stage 2: Technical deep dive
/documentation-retrieval --library="Vue.js" --mode="code" --topic="composition API"

# Stage 3: Integration planning
/serena-mcp --operation="find-symbol" --name_path="FrontendFramework" --include_body=true

# Stage 4: Implementation research
/documentation-retrieval --library="Vue.js" --mode="code" --topic="build configuration"

# Stage 5: Testing strategy
/frontend-test-development --target="VueComponent" --test_type="unit"
```

**Issue Resolution Research Cycle:**
```bash
# Cycle 1: Problem understanding
/support-investigation --issue="Performance degradation" --environment="production"

# Cycle 2: Library-specific research
/documentation-retrieval --library="Redis" --mode="info" --topic="performance tuning"

# Cycle 3: Internal pattern analysis
/serena-mcp --operation="find-referencing-symbols" --name_path="CacheManager"

# Cycle 4: Solution implementation
/code-development --task="Optimize cache configuration" --scope="bugfix"

# Cycle 5: Monitoring setup
/datadog-management --task_type="monitor" --query_context="cache performance"
```

### Integration Architecture

**Documentation as Development Intelligence:**
The documentation-retrieval skill serves as the central research and information intelligence hub for FUB development:

1. **Pre-Development Research**: Primary source for library evaluation, API understanding, and pattern discovery
2. **Implementation Support**: Real-time documentation lookup during development workflows
3. **Issue Resolution**: Evidence-based troubleshooting through official documentation and community solutions
4. **Integration Planning**: Comprehensive library analysis for system integration decisions
5. **Knowledge Preservation**: Internal documentation discovery for team knowledge sharing

**Multi-Source Research Coordination:**

```bash
# Complete research coordination workflow
coordinate_comprehensive_research() {
    local research_context="$1"

    echo "=== Research Intelligence Coordination ==="

    # 1. External library research (documentation-retrieval)
    /documentation-retrieval --library="$research_context" --mode="info"

    # 2. Internal codebase analysis (serena-mcp)
    /serena-mcp --task="Analyze existing $research_context integration" --scope="full-codebase"

    # 3. Implementation guidance (code-development)
    /code-development --task="Plan $research_context integration" --scope="research"

    # 4. Testing strategy (backend-test-development)
    /backend-test-development --target="$research_context" --test_type="integration-planning"

    # 5. Monitoring integration (datadog-management)
    /datadog-management --task_type="investigate" --query_context="$research_context monitoring"
}
```

**Research-Driven Development Framework:**

All development operations integrate through documentation-retrieval for informed decision-making:

1. **Informed Implementation**: All coding decisions backed by official documentation and best practices
2. **Evidence-Based Troubleshooting**: Issue resolution guided by official debugging guides and community solutions
3. **Pattern-Based Integration**: System integrations following documented patterns and examples
4. **Knowledge-Driven Testing**: Test development informed by framework documentation and testing patterns
5. **Documentation-Guided Architecture**: Architectural decisions supported by comprehensive library analysis

### Comprehensive Research Integration Examples

**Research → Development → Testing Pipeline:**
```bash
# Pipeline 1: Research phase
research_pipeline_phase1() {
    /documentation-retrieval --library="$1" --mode="info" --topic="architecture"
    /documentation-retrieval --library="$1" --mode="code" --topic="integration patterns"
}

# Pipeline 2: Development phase
research_pipeline_phase2() {
    /serena-mcp --task="Analyze integration requirements for $1" --scope="directory"
    /code-development --task="Implement $1 integration" --scope="medium-feature"
}

# Pipeline 3: Validation phase
research_pipeline_phase3() {
    /backend-test-development --target="$1Integration" --test_type="integration"
    /documentation-retrieval --library="$1" --mode="code" --topic="testing patterns"
}
```

**Issue Investigation → Research → Resolution Pipeline:**
```bash
# Investigation pipeline with documentation intelligence
issue_resolution_pipeline() {
    local issue_context="$1"

    # Phase 1: Initial investigation
    /support-investigation --issue="$issue_context" --environment="production"

    # Phase 2: Documentation research
    /documentation-retrieval --library="affected_library" --mode="info" --topic="troubleshooting"

    # Phase 3: Code analysis
    /serena-mcp --task="Find $issue_context implementation" --scope="full-codebase"

    # Phase 4: Solution implementation
    /code-development --task="Fix $issue_context" --scope="bugfix"

    # Phase 5: Validation
    /backend-test-development --target="FixValidation" --test_type="regression"
}
```

This comprehensive integration framework ensures documentation-retrieval coordinates effectively with all development skills while providing intelligent, research-driven development support throughout the FUB development ecosystem.