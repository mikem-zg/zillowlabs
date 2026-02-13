## Cross-Skill Integration Workflows and Coordination Patterns

### Cross-Skill Workflow Patterns

**Serena MCP → Support Investigation:**
```bash
# Systematic code analysis for bug investigation
serena-mcp --task="Find authentication failure points" --scope="auth" |\
  support-investigation --issue="Login failures from code analysis" --account_id="12345"

# Trace error propagation through codebase
serena-mcp --task="Trace error flow for payment processing" --target="PaymentController" |\
  support-investigation --issue="Payment errors" --environment="production"
```

**Serena MCP → Database Operations:**
```bash
# Analyze database access patterns before schema changes
serena-mcp --task="Find all User model database queries" --scope="models" |\
  database-operations --operation="schema-migration" --table="users"

# Code impact analysis for database migrations
database-operations --operation="validate_migration" --table="contacts" |\
  serena-mcp --task="Find all Contact model references" --scope="full-codebase"
```

**Serena MCP → Backend Testing:**
```bash
# Locate test coverage before code changes
serena-mcp --task="Find tests for AuthController methods" --scope="tests" |\
  backend-test-development --target="AuthController" --test_type="unit"

# Code analysis for test implementation
serena-mcp --task="Analyze UserService methods" --target="UserService" |\
  backend-test-development --target="UserService" --test_type="integration"
```

**Serena MCP → GitLab Management:**
```bash
# Code review preparation and change analysis
gitlab-mr-management --operation="create" --source_branch="feature-auth-updates" |\
  serena-mcp --task="Analyze changes in authentication system" --scope="auth"

# Impact analysis before merge request creation
serena-mcp --task="Find references to modified functions" --target="UserAuth" |\
  gitlab-mr-management --operation="create" --title="Authentication updates"
```

### Related Skills Integration

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Code Investigation** | Bug tracing, error source identification, code flow analysis, root cause discovery |
| `database-operations` | **Data Layer Analysis** | Database access pattern discovery, migration impact analysis, query optimization |
| `backend-test-development` | **Test Discovery** | Test coverage analysis, test implementation planning, test pattern identification |
| `gitlab-collaboration` | **Code Review** | Change impact analysis, merge request preparation, code review automation |
| `code-development` | **Implementation** | Architecture discovery, refactoring planning, feature implementation guidance |
| `datadog-management` | **Performance Analysis** | Code performance correlation, error source identification, monitoring integration |
| `claude-code-maintenance` | **Code Accuracy** | Validate symbol references, check method names, verify file structures and consistency |

### Multi-Skill Operation Examples

**Complete Feature Implementation Workflow:**
1. `serena-mcp` - Analyze existing architecture and similar features in codebase
2. `database-operations` - Plan database schema changes and access patterns
3. `code-development` - Implement new feature following discovered patterns
4. `backend-test-development` - Create comprehensive tests based on code analysis
5. `serena-mcp` - Validate implementation and check cross-references
6. `gitlab-mr-management` - Prepare merge request with impact analysis documentation

**Complete Bug Investigation and Fix Workflow:**
1. `support-investigation` - Initial issue analysis and system impact assessment
2. `serena-mcp` - Locate error sources and trace code execution paths
3. `datadog-management` - Correlate code analysis with production monitoring data
4. `database-operations` - Investigate database-related aspects if applicable
5. `serena-mcp` - Plan fix implementation with impact analysis
6. `backend-test-development` - Create regression tests and validate fix
7. `gitlab-pipeline-monitoring` - Deploy fix with comprehensive documentation

**Complete Code Refactoring Workflow:**
1. `serena-mcp` - Comprehensive analysis of current code structure and dependencies
2. `backend-test-development` - Ensure test coverage before refactoring begins
3. `serena-mcp` - Execute systematic refactoring with cross-reference validation
4. `database-operations` - Update database access patterns if schema changes needed
5. `backend-test-development` - Validate all tests pass after refactoring
6. `datadog-management` - Monitor performance impact of refactored code
7. `gitlab-pipeline-monitoring` - Document refactoring rationale and deploy changes

### Systematic Semantic Discovery Protocol

**Standard Workflow Pattern: Overview → Find → References → Edit**

**Step 1: File Structure Analysis (Always Start Here)**
```bash
Use mcp__serena__get_symbols_overview with relative_path="[target_file]"
```
- Get classes, functions, methods with types and locations
- Understand code architecture before detailed analysis
- Use `depth=1` to include child symbols (class methods)
- Essential for unfamiliar files or complex structures

**Step 2: Symbol Discovery and Retrieval**
```bash
Use mcp__serena__find_symbol with:
- name_path="[pattern]" (e.g., "UserAuth/authenticate", "validate")
- relative_path="[scope_directory]" (ALWAYS when possible for speed)
- include_body=true (only when need source code)
- substring_matching=true (for partial name matches)
- include_kinds=[5,6,12] (filter: 5=class, 6=method, 12=function)
- depth=1 (include child symbols like class methods)
```

**Step 3: Impact Analysis and Reference Discovery**
```bash
Use mcp__serena__find_referencing_symbols with:
- name_path="[symbol_name]"
- relative_path="[containing_file]"
```
- Essential before refactoring or renaming
- Understand data flow and integration points
- Find test coverage for functions
- Identify breaking change impact

### Integration Architecture

**Serena MCP as Code Intelligence Hub:**
The serena-mcp skill serves as the central code intelligence and navigation hub for FUB development:

1. **Semantic Code Discovery**: Primary interface for understanding existing code structure
2. **Impact Analysis**: Cross-file dependency analysis before making changes
3. **Precision Editing**: Symbol-level modifications without line number dependencies
4. **Architecture Mapping**: Understanding complex codebase relationships and patterns
5. **Knowledge Management**: Persistent memory for architectural insights and patterns

**Multi-Skill Coordination Patterns:**

```bash
# Complete system understanding workflow
coordinate_codebase_analysis() {
    local investigation_context="$1"

    echo "=== Codebase Intelligence Coordination ==="

    # 1. Semantic code analysis (serena-mcp)
    /serena-mcp --task="Analyze system architecture" --scope="full-codebase"

    # 2. Database layer understanding (database-operations)
    /database-operations --operation="schema-analysis" --environment="development"

    # 3. Test coverage mapping (backend-test-development)
    /backend-test-development --target="All" --test_type="coverage-analysis"

    # 4. Performance correlation (datadog-management)
    /datadog-management --task_type="metrics" --query_context="code performance correlation"

    # 5. Implementation planning (planning-workflow)
    /planning-workflow --operation="create-plan" --task_context="development-architecture" --scope_estimate="large"
}
```

**Code Intelligence Integration Framework:**

All development operations integrate through serena-mcp for code understanding:

1. **Semantic Discovery**: Systematic symbol-level exploration before making changes
2. **Cross-Skill Evidence Sharing**: Code analysis results inform other skill operations
3. **Impact Assessment**: Multi-dimensional impact analysis across development, testing, and operations
4. **Knowledge Preservation**: Architectural insights and navigation patterns stored persistently
5. **Integration Validation**: Cross-reference validation ensures code consistency after modifications

This comprehensive integration framework ensures serena-mcp coordinates effectively with all development skills while providing intelligent, token-efficient semantic code navigation throughout the FUB development ecosystem.