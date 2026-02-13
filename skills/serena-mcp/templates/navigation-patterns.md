## Serena MCP Navigation Patterns and Templates

### LSP Symbol Kinds Reference

Common filters for `include_kinds` and `exclude_kinds` parameters:

| Kind | Value | Description | Example Usage |
|------|-------|-------------|---------------|
| Class | 5 | Class definitions | `include_kinds=[5]` - Find only classes |
| Method | 6 | Class methods | `include_kinds=[6]` - Find only methods |
| Function | 12 | Standalone functions | `include_kinds=[12]` - Find only functions |
| Variable | 13 | Variables and fields | `exclude_kinds=[13]` - Skip variables |
| Constant | 14 | Constants | `include_kinds=[14]` - Find only constants |
| Struct | 22 | Struct definitions | `include_kinds=[22]` - C/Go structs |
| Event | 23 | Event definitions | `include_kinds=[23]` - Event handlers |

**Combined Example:**
```python
# Find methods and functions, exclude variables
include_kinds=[6, 12], exclude_kinds=[13]
```

### Name Path Syntax Rules

- `"method"` - Matches anywhere in codebase
- `"Class/method"` - Matches method inside specific Class
- `"/Class/method"` - Matches only top-level Class (absolute path)
- `"Class/method[0]` - Specific overload for Java/C# methods

### Detailed Parameter Examples

**Find with specific scope:**
```yaml
# Find specific symbol with code
mcp__serena__find_symbol:
  name_path: "UserAuth/authenticate"
  relative_path: "auth/"
  include_body: true
```

**Find all methods named "validate":**
```yaml
mcp__serena__find_symbol:
  name_path: "validate"
  substring_matching: true
  relative_path: "auth/"
```

**Filter by symbol type:**
```yaml
# Find only classes
mcp__serena__find_symbol:
  name_path: "User"
  include_kinds: [5]

# Find methods and functions, exclude variables
mcp__serena__find_symbol:
  name_path: "process"
  include_kinds: [6, 12]
  exclude_kinds: [13]
```

### Common Workflow Patterns

**Bug Investigation Pattern:**
```markdown
1. mcp__serena__search_for_pattern: "[error_message]" → Locate error sources
2. mcp__serena__get_symbols_overview → Understand file structure
3. mcp__serena__find_symbol with include_body=true → Get exact implementation
4. mcp__serena__find_referencing_symbols → Trace error propagation
5. mcp__serena__replace_symbol_body → Apply targeted fix
```

**Feature Implementation Pattern:**
```markdown
1. mcp__serena__get_symbols_overview → Understand existing architecture
2. mcp__serena__find_symbol → Locate similar existing functionality
3. mcp__serena__find_referencing_symbols → Understand integration patterns
4. mcp__serena__insert_after_symbol → Add new functionality
5. mcp__serena__rename_symbol → Refactor if needed for consistency
```

**Code Review and Refactoring Pattern:**
```markdown
1. mcp__serena__find_symbol → Locate functions needing review
2. mcp__serena__find_referencing_symbols → Assess impact radius
3. mcp__serena__write_memory → Document refactoring decisions
4. mcp__serena__replace_symbol_body → Implement improvements
5. mcp__serena__think_about_whether_you_are_done → Final validation
```

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

### Language-Specific Patterns

**Fully Supported Languages:**
Python, TypeScript/JavaScript, PHP, Go, Rust, C/C++, C#, Java, Kotlin, Swift, Ruby, R, Bash, Lua, Elixir, Scala, and 25+ more via Language Server Protocol (LSP).

**Language-Specific Navigation:**
- **Python**: Use class paths like `MyClass/__init__` for constructors
- **Java/C#**: Handle method overloading with index notation `MyClass/method[0]`
- **JavaScript/TypeScript**: Navigate module exports and function expressions
- **PHP**: Work with namespaced classes and trait usage
- **Go**: Handle package-level functions and struct methods

### Optimal Workflow Templates

**Multi-Step Discovery (Most Common):**
```markdown
1. get_symbols_overview → Understand file structure
2. find_symbol with include_body=true → Get exact code
3. find_referencing_symbols → Check impact before changes
4. replace_symbol_body → Make precise edits
```

**Large File Navigation (Essential):**
```markdown
# Never do this for large files
❌ read_file("/path/to/large_controller.php")

# Always do this instead
✓ get_symbols_overview → relative_path="/path/to/large_controller.php"
✓ find_symbol → name_path="ControllerName/method", relative_path="/path/to/"
```

**Performance Optimization:**
```markdown
# Slow: Unscoped search
❌ find_symbol: name_path="authenticate"

# Fast: Scoped and filtered search
✓ find_symbol:
    name_path: "authenticate"
    relative_path: "auth/"
    include_kinds: [6, 12]  # methods and functions only
```

This pattern library provides the foundation for efficient semantic code navigation and editing with Serena MCP.