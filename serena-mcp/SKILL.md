---
name: serena-mcp
description: Semantic code navigation and editing using Serena MCP for efficient IDE-like codebase operations with symbol-level precision
---

## Overview

Semantic code navigation and editing using Serena MCP for efficient IDE-like codebase operations with symbol-level precision. Navigate large, complex codebases efficiently using semantic tools that work with symbols (classes, functions, methods) rather than line numbers or text searches for maximum token efficiency and accuracy.

📋 **Navigation Patterns**: [templates/navigation-patterns.md](templates/navigation-patterns.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **MCP Reference**: [reference/mcp-reference.md](reference/mcp-reference.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**Key Benefits:**
- Token-efficient codebase exploration without reading entire files
- Symbol-level precision for finding and modifying code structures
- Cross-file impact analysis before refactoring
- Language-aware code understanding across 30+ programming languages

**Core Principle:** Navigate complex codebases at the symbol level. Saves tokens, improves accuracy, and enables precise editing without line numbers.

**Standard Workflow Process:**
1. **Overview** → Use `get_symbols_overview` to see file structure first
2. **Find** → Use `find_symbol` to locate specific functions/classes
3. **Check References** → Use `find_referencing_symbols` to analyze impact
4. **Edit** → Use `replace_symbol_body` or `rename_symbol` for precise changes

### Quick Reference

#### Most Common Operations (Use Daily - 90% of Tasks)

| What You Need | Tool | Example |
|---------------|------|---------|
| See file structure first | `get_symbols_overview` | `relative_path="auth/user.php"` |
| Find function/class | `find_symbol` | `name_path="UserAuth/login", include_body=true` |
| Find where it's used | `find_referencing_symbols` | `name_path="sendEmail"` |
| Replace function | `replace_symbol_body` | `name_path="Class/method", body="..."` |
| Rename everywhere | `rename_symbol` | `new_name="NewName"` |

**Standard Workflow:** Overview → Find → Check References → Edit

#### Tool Selection Matrix

| Task | Use This Tool | Why |
|------|---------------|-----|
| Find exact string | `grep` (built-in) | Faster for literal text |
| Read small file (<200 lines) | `read_file` (built-in) | Simpler, already small |
| Find files by name | `glob_file_search` (built-in) | Purpose-built |
| Find function/class | `mcp__serena__find_symbol` | Semantic understanding |
| Understand file structure | `mcp__serena__get_symbols_overview` | Symbol-level view |
| Find code usage | `mcp__serena__find_referencing_symbols` | Cross-file analysis |
| Edit specific function | `mcp__serena__replace_symbol_body` | No line numbers needed |
| Rename across codebase | `mcp__serena__rename_symbol` | Updates all references |

→ **Complete navigation patterns and examples**: [templates/navigation-patterns.md](templates/navigation-patterns.md)

## Systematic Semantic Discovery Protocol

### Task Analysis and Approach Selection

**Determine Optimal Serena Usage:**
- ✓ **Use Serena for**: Large/unfamiliar codebases, finding specific symbols, impact analysis, targeted edits, cross-file refactoring
- ✗ **Skip Serena for**: Small files (<200 lines), exact text searches, new code creation, already-loaded context

**Scope Assessment:**
- **file**: Focus on single file symbol overview and navigation
- **directory**: Multi-file exploration within bounded area
- **class/function**: Targeted symbol analysis and modification
- **full-codebase**: Comprehensive cross-file operations and refactoring

### Core Discovery Workflow

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

### Precision Editing and Code Modification

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

## Usage Examples

```bash
# Find authentication methods across the codebase
/serena-mcp --task="Find authentication methods" --scope="full-codebase"

# Refactor user validation logic in specific class
/serena-mcp --task="Refactor user validation logic" --scope="class" --target="UserValidator"

# Navigate payment processing workflow
/serena-mcp --task="Navigate payment processing flow" --scope="directory" --target="payment/"

# Find all usages of a specific function before refactoring
/serena-mcp --task="Find all usages of sendEmail function" --scope="full-codebase" --target="sendEmail"

# Understand file structure and symbols in authentication module
/serena-mcp --task="Analyze authentication module structure" --scope="file" --target="auth/AuthService.php"

# Rename a method across the entire codebase
/serena-mcp --task="Rename validateUser to validateUserCredentials" --scope="full-codebase" --target="validateUser"
```

## Performance Optimization

### Token Efficiency Guidelines

1. **Always scope searches** - Use `relative_path` when you know the area
2. **Overview first** - `get_symbols_overview` before diving into symbols
3. **Selective body retrieval** - Only use `include_body=true` when needed
4. **Filter by kind** - Use `include_kinds=[5,6,12]` to reduce noise
5. **Leverage depth** - Get child symbols in one call with `depth=1`
6. **Prefer symbols over patterns** - Use `find_symbol` instead of `search_for_pattern` when possible

### File Size Handling Strategy

- **Large files (>1,000 lines)**: Never use `read_file`. Always use `get_symbols_overview` + `find_symbol`
- **Medium files (200-1,000 lines)**: Start with overview, then selective symbol retrieval
- **Small files (<200 lines)**: Consider regular `read_file` if simpler

→ **Complete optimization guidelines and best practices**: [templates/navigation-patterns.md](templates/navigation-patterns.md)

## Cross-Skill Integration

### Primary Integration Relationships

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Code Investigation** | Bug tracing, error source identification, code flow analysis, root cause discovery |
| `database-operations` | **Data Layer Analysis** | Database access pattern discovery, migration impact analysis, query optimization |
| `backend-test-development` | **Test Discovery** | Test coverage analysis, test implementation planning, test pattern identification |
| `gitlab-collaboration` | **Code Review** | Change impact analysis, merge request preparation, code review automation |
| `code-development` | **Implementation** | Architecture discovery, refactoring planning, feature implementation guidance |
| `datadog-management` | **Performance Analysis** | Code performance correlation, error source identification, monitoring integration |

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

→ **Complete integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Capabilities

### Complex Multi-File Operations
- Cross-codebase symbol discovery and refactoring
- Impact analysis before making breaking changes
- Architecture pattern identification and replication
- Automated reference updating across all files

### Language Support
- Full semantic understanding for 30+ languages via LSP
- Language-specific navigation patterns (Python, PHP, JavaScript, Go, etc.)
- Framework-aware symbol recognition (React, Lithium, etc.)
- Multi-language project navigation

### Project Knowledge Management
- Persistent architectural insights storage
- Complex navigation pattern documentation
- Project-specific convention tracking
- Cross-team knowledge sharing

→ **Advanced implementation patterns and specialized techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Preconditions

- Serena MCP server must be running and accessible (with automatic resilience and fallback support)
- Must operate within an established codebase with semantic structure
- Target files should contain analyzable code symbols (classes, functions, methods)
- Project should have sufficient complexity to benefit from semantic navigation
- Language support must be available for the target codebase

### MCP Resilience Integration

**Enhanced Reliability**: This skill implements standardized MCP resilience patterns:
- Automatic health checking before Serena MCP operations
- Circuit breaker protection for failing Serena server instances
- Seamless fallback to direct file operations when MCP is unavailable
- Transparent error communication and recovery with manual alternatives

## Refusal Conditions

The skill must refuse if:
- Serena MCP server is not accessible after automatic recovery attempts
- Target codebase lacks sufficient semantic structure for symbol navigation
- Language support is not available for the target programming language
- Project is too small or simple to benefit from semantic navigation overhead
- Task requires capabilities beyond Serena's semantic analysis scope
- Memory or thinking operations fail despite MCP resilience mechanisms

When refusing, explain which precondition failed and provide specific guidance:
- How to verify or configure Serena MCP server connectivity
- Alternative approaches using built-in tools for simple tasks (automatic fallback)
- Steps to ensure language support is available
- Recommendations for when semantic navigation provides value
- Integration guidance with other Claude Code skills for complex workflows
- MCP resilience status and recovery options available

→ **Complete troubleshooting and MCP resilience reference**: [reference/mcp-reference.md](reference/mcp-reference.md)

## Supporting Infrastructure

→ **Advanced patterns and FUB-specific workflows**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Navigation patterns, templates, and optimization guidelines**: [templates/navigation-patterns.md](templates/navigation-patterns.md)
→ **Cross-skill integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

**Critical Integration Note**: Serena MCP excels at navigating and understanding existing code structures. It complements rather than replaces other development skills by providing efficient, token-conscious discovery and targeted modification capabilities for complex codebases.