## Advanced Serena MCP Patterns and Specialized Techniques

### Integration with FUB Development Workflow

#### Codebase-Specific Usage Patterns

**FUB PHP Backend (Lithium Framework):**
- Navigate Models: `find_symbol` with name_path like `User/save` or `Contact/validate`
- Controller Actions: Use `UserController/create` pattern for MVC navigation
- Helper Functions: Search utility classes and shared function libraries
- Database Layer: Find repository patterns and query construction methods

**FUB JavaScript/TypeScript Frontend:**
- React Components: Navigate component hierarchies with `ComponentName/render`
- Hook Logic: Find custom hooks with `use*` patterns via substring matching
- API Integration: Locate service layer functions and HTTP client usage
- State Management: Navigate Redux/Context patterns and state updates

**Cross-Project Navigation (FUB Ecosystem):**
- Multi-repository symbol discovery across fub, fub-spa, pegasus projects
- Shared library integration and common utility discovery
- API contract validation between frontend and backend
- Testing pattern consistency across different project types

### Advanced Symbol Operations

#### Complex Pattern Search (When Symbol Search Insufficient)
```markdown
Use mcp__serena__search_for_pattern with:
- substring_pattern="[regex_pattern]" (e.g., "LIMIT\\s+\\d+")
- relative_path="[search_scope]"
- restrict_search_to_code_files=true
- context_lines_before=2, context_lines_after=2
```
**Use for**: Code patterns, configuration files (YAML, JSON), complex regex matching

#### Multi-Step Operation Management
```markdown
# After complex discovery sequences
Use mcp__serena__think_about_collected_information

# Before making code changes
Use mcp__serena__think_about_task_adherence

# Before task completion
Use mcp__serena__think_about_whether_you_are_done
```

#### Project Knowledge Management
```markdown
# Save architectural insights
Use mcp__serena__write_memory with:
- memory_file_name="[descriptive_name].md"
- content="[architectural_knowledge]"

# Retrieve project knowledge
Use mcp__serena__read_memory with memory_file_name="[name].md"
Use mcp__serena__list_memories  # View all saved knowledge
```

### Quality Assurance and Verification

**Before Symbol Modifications:**
- ✓ Impact analysis completed with `find_referencing_symbols`?
- ✓ Understanding of symbol boundaries and dependencies?
- ✓ Backup/versioning strategy for complex changes?

**After Symbol Changes:**
- ✓ Symbol references still valid across codebase?
- ✓ Integration points maintained and functional?
- ✓ No unintended side effects in dependent modules?

**Memory and Knowledge Management:**
- ✓ Architectural insights documented in memories?
- ✓ Complex navigation patterns saved for future reference?
- ✓ Project-specific conventions and patterns captured?

### Common Anti-Patterns to Avoid

**❌ Critical Mistakes:**
- **Reading entire large files** - Never use `read_file` on files >1,000 lines. Use `get_symbols_overview` + `find_symbol` instead
- **Skipping relative_path** - Always scope searches with `relative_path` when you know the area. Makes searches 10x faster
- **Using pattern search for symbols** - Don't use `search_for_pattern` when `find_symbol` works. Symbol search is semantic and more accurate
- **Editing by line numbers** - Never edit code using line numbers. Use `replace_symbol_body` for precise, structure-aware editing
- **Forgetting impact analysis** - Always run `find_referencing_symbols` before refactoring to understand breaking change impact
- **Body retrieval overuse** - Don't use `include_body=true` unless you actually need the source code. Wastes tokens significantly
- **No structure overview** - Don't dive into symbol search without understanding file structure via `get_symbols_overview` first

**❌ Performance Anti-Patterns:**
- **Unfiltered searches** - Use `include_kinds=[5,6,12]` to reduce noise and improve relevance
- **Missing depth optimization** - Use `depth=1` to get child symbols (class methods) in one call instead of multiple
- **Pattern search overuse** - Only use `search_for_pattern` for regex, config files, or when symbol search is insufficient
- **Ignoring substring matching** - Use `substring_matching=true` for partial name matches instead of exact string searches

### Symbol Editing Best Practices

**Symbol-Level Editing (Preferred Approach)**
```markdown
# Replace entire function/method/class
Use mcp__serena__replace_symbol_body with:
- name_path="[symbol_path]"
- relative_path="[file_path]"
- body="[complete_definition_including_signature]"
```
**CRITICAL**: Body = complete definition including signature. NO docstrings/comments/imports.

**Strategic Code Insertion**
```markdown
# Add new method after existing one
Use mcp__serena__insert_after_symbol with:
- name_path="[existing_symbol]"
- relative_path="[file_path]"
- body="[new_code_block]"

# Add imports or code at file beginning
Use mcp__serena__insert_before_symbol with:
- name_path="[first_symbol]"
- relative_path="[file_path]"
- body="[imports_or_code]"
```

**Cross-Codebase Refactoring**
```
# Rename symbol everywhere automatically
Use mcp__serena__rename_symbol with:
- name_path="[current_name]"
- relative_path="[defining_file]"
- new_name="[new_name]"
```
Automatically updates all references, imports, usages across all files.

### Project Onboarding and Knowledge Discovery

**First-Time Codebase Analysis:**
```markdown
# Check if project analysis already performed
Use mcp__serena__check_onboarding_performed

# If not performed, run comprehensive analysis
Use mcp__serena__onboarding
```

**Onboarding Analysis Includes:**
- Project structure and architectural patterns
- Key files and entry points identification
- Testing setup and framework discovery
- Build processes and dependency analysis
- Common coding patterns and conventions
- Integration point mapping

### Symbol Editing Best Practices

**Check references first (always):**
```markdown
1. find_referencing_symbols → name_path="methodName"
2. replace_symbol_body → Complete function replacement
3. think_about_whether_you_are_done → Validate changes
```

### Advanced Performance Optimization

**Filter by Symbol Type (LSP Kinds) - Common Values:**
- `5` = Class
- `6` = Method
- `12` = Function
- `13` = Variable
- `14` = Constant
- `22` = Struct
- `23` = Event

**Complex Symbol Discovery Patterns:**
```yaml
# Find all authentication-related methods
mcp__serena__find_symbol:
  name_path: "auth"
  substring_matching: true
  include_kinds: [6, 12]  # methods and functions
  relative_path: "auth/"

# Find all validation functions excluding variables
mcp__serena__find_symbol:
  name_path: "valid"
  substring_matching: true
  include_kinds: [6, 12]
  exclude_kinds: [13]
  depth: 1
```

**Memory Management for Complex Projects:**
```yaml
# Document architectural decisions
mcp__serena__write_memory:
  memory_file_name: "auth_architecture.md"
  content: |
    ## Authentication Architecture Insights
    - Primary auth controller: UserController/authenticate
    - Token validation: TokenService/validate
    - Session management: SessionManager/create
    - Integration points: [list discovered patterns]

# Retrieve for future reference
mcp__serena__read_memory:
  memory_file_name: "auth_architecture.md"
```

These advanced patterns enable sophisticated semantic navigation and editing workflows for complex enterprise codebases like FUB's multi-repository ecosystem.