## Serena MCP Reference Guide and Troubleshooting

### Tool Selection Matrix

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
| Broad code search | `codebase_search` (built-in) | Semantic search across files |

### MCP Resilience Integration

**Enhanced Reliability**: This skill implements standardized MCP resilience patterns:
- Automatic health checking before Serena MCP operations
- Circuit breaker protection for failing Serena server instances
- Seamless fallback to direct file operations when MCP is unavailable
- Transparent error communication and recovery with manual alternatives

**MCP Resilience Features:**
- Automatic Serena MCP health checking and restart attempts
- Fallback to direct file operations (`Read`, `Grep`, `Glob`) when MCP fails
- Circuit breaker protection prevents repeated failures on unhealthy connections
- Transparent error recovery with user notification of fallback mechanisms

### Refusal Conditions

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

**For tasks outside Serena's scope, coordinate with appropriate skills:**
- Simple file operations → Use built-in file tools
- New code creation → Use `code-development` skill
- Database schema work → Use `database-operations` skill
- Test implementation → Use appropriate test development skills
- Project management → Use `gitlab-mr-management` or `jira-management` skills

### Task Analysis Guidelines

**Determine Optimal Serena Usage:**
- ✓ **Use Serena for**: Large/unfamiliar codebases, finding specific symbols, impact analysis, targeted edits, cross-file refactoring
- ✗ **Skip Serena for**: Small files (<200 lines), exact text searches, new code creation, already-loaded context

**Scope Assessment:**
- **file**: Focus on single file symbol overview and navigation
- **directory**: Multi-file exploration within bounded area
- **class/function**: Targeted symbol analysis and modification
- **full-codebase**: Comprehensive cross-file operations and refactoring

### Essential Preconditions

- Serena MCP server must be running and accessible (with automatic resilience and fallback support)
- Must operate within an established codebase with semantic structure
- Target files should contain analyzable code symbols (classes, functions, methods)
- Project should have sufficient complexity to benefit from semantic navigation
- Language support must be available for the target codebase

### Troubleshooting Common Issues

#### MCP Connection Issues
**Symptoms**: Tool timeouts, connection errors, MCP server unavailable
**Solutions**:
- Check MCP server status and restart if needed
- Verify Serena MCP configuration
- Use automatic fallback to built-in file tools
- Retry with exponential backoff

#### Symbol Not Found
**Symptoms**: Empty search results, symbol discovery failures
**Solutions**:
- Verify correct name_path syntax
- Check spelling and case sensitivity
- Use substring_matching=true for partial matches
- Broaden search scope with relative_path
- Use get_symbols_overview to understand file structure first

#### Performance Issues
**Symptoms**: Slow searches, high token usage, timeout errors
**Solutions**:
- Always use relative_path to scope searches
- Filter by symbol kind (include_kinds=[5,6,12])
- Avoid include_body=true unless necessary
- Use get_symbols_overview before detailed symbol search

#### Language Support Issues
**Symptoms**: Poor symbol recognition, missing symbols
**Solutions**:
- Verify language is supported by LSP
- Check file extensions are recognized
- Ensure project has proper language configuration
- Consider using pattern search for unsupported languages

### Best Practices Checklist

**Before Starting:**
- [ ] Project has sufficient complexity to benefit from semantic navigation
- [ ] Target language is supported by Serena MCP
- [ ] Codebase contains analyzable symbols (not just configuration files)
- [ ] MCP server connectivity verified

**During Operation:**
- [ ] Always start with get_symbols_overview for unfamiliar files
- [ ] Use relative_path to scope searches when possible
- [ ] Filter searches with include_kinds/exclude_kinds
- [ ] Check references with find_referencing_symbols before editing
- [ ] Document architectural insights in memories

**After Completion:**
- [ ] Validate symbol references are still valid
- [ ] Check for unintended side effects in dependent code
- [ ] Document patterns and decisions for future reference

### Performance Optimization Guidelines

1. **Always scope searches** - Use relative_path when you know the area
2. **Overview first** - get_symbols_overview before diving into symbols
3. **Selective body retrieval** - Only use include_body=true when needed
4. **Filter by kind** - Use include_kinds=[5,6,12] to reduce noise
5. **Leverage depth** - Get child symbols in one call with depth=1
6. **Prefer symbols over patterns** - Use find_symbol instead of search_for_pattern when possible

**Critical Integration Note**: Serena MCP excels at navigating and understanding existing code structures. It complements rather than replaces other development skills by providing efficient, token-conscious discovery and targeted modification capabilities for complex codebases.