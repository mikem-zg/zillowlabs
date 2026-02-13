## Documentation Retrieval Reference Guide

### Parameters and Usage Reference

#### Required Parameters
- `--library` (required): Name of library/framework or internal service (e.g., "react", "mongodb", "fub-api", "pegasus")

#### Optional Parameters
- `--mode` (optional): Documentation mode - "code" (default) for API reference/examples, "info" for conceptual explanations
- `--topic` (optional): Focus area (e.g., "authentication", "hooks", "connection", "deployment")
- `--page` (optional): Pagination for additional results (1-10)
- `--internal` (optional): Force search internal documentation only via Glean

### Usage Examples Reference

```bash
# Get React hook documentation with code examples (external)
/documentation-retrieval --library="react" --mode="code" --topic="hooks"

# Research internal FUB API authentication
/documentation-retrieval --library="fub-api" --topic="authentication" --internal

# Understanding internal Pegasus service architecture
/documentation-retrieval --library="pegasus" --mode="info" --topic="deployment"

# Search for internal team documentation
/documentation-retrieval --library="deployment process" --internal

# Get additional pages of results
/documentation-retrieval --library="lodash" --mode="code" --page="2"
```

### MCP Resilience Integration

**Enhanced Reliability**: This skill implements standardized MCP resilience patterns:
- Dual-server health checking for both Context7 MCP and Glean MCP
- Automatic failover between internal (Glean) and external (Context7) documentation sources
- Circuit breaker protection for failing MCP connections
- Transparent fallback to web search when both MCP servers are unavailable

### Source Determination Logic

**Internal Documentation Detection:**
- Check for `--internal` flag or FUB-specific terms (fub, pegasus, mapture)
- **If Internal**: Use Glean MCP for internal documentation
- **If External**: Use Context7 MCP for library documentation
- **If Uncertain**: Search both sources

### MCP Tool Reference

#### Context7 MCP (External Libraries)
```javascript
// Step 1: Resolve library ID
await mcp__context7__resolve_library_id({
  query: "user's original question",
  libraryName: "library-name"
});

// Step 2: Get documentation
await mcp__context7__query_docs({
  libraryId: "/org/project",
  query: "focused query with topic"
});
```

#### Glean MCP (Internal Documentation)
```javascript
// Search internal docs
await mcp__glean_tools__search({
  query: "library-name + topic + mode intent",
  app: "confluence",
  updated: "past_month"
});

// Search internal code
await mcp__glean_tools__code_search({
  query: "library-name + code patterns",
  owner: "me",
  after: "2024-01-01"
});

// Read full documents
await mcp__glean_tools__read_document({
  urls: ["url1", "url2"]
});
```

### Fallback Research Methods

When MCP servers are unavailable:
- **Package Registries**: npm, Packagist, PyPI for official information
- **GitHub Search**: Repository documentation, README files, issues
- **Web Search**: Official sites, community resources, tutorials

### Quality Assessment Indicators

**High Quality Documentation:**
- ✅ Working code examples
- ✅ Clear API signatures and parameters
- ✅ Recent updates (within last year)
- ✅ Official maintainer sources
- ✅ Migration guides between versions

**Red Flags:**
- ❌ No examples, only descriptions
- ❌ Outdated information (>2 years external, >1 year internal)
- ❌ Broken links or missing pages
- ❌ Conflicting information between sources

### Troubleshooting Guide

#### Common Issues and Solutions

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Context7 MCP Unavailable** | External library research fails | Fallback to package registries and GitHub |
| **Glean MCP Unavailable** | Internal documentation search fails | Use direct repository search and team contacts |
| **Library Not Found** | No results from Context7 resolution | Try alternative library names or web search |
| **Outdated Information** | Documentation doesn't match current version | Cross-reference with package registry versions |
| **Access Permissions** | Glean returns empty results | Verify team permissions and document access |

#### MCP Server Health Checking

```javascript
// Health check workflow
const checkMCPHealth = async () => {
  const health = {
    context7: await testContext7Connection(),
    glean: await testGleanConnection()
  };

  if (!health.context7 && !health.glean) {
    console.log("Both MCP servers unavailable - using web fallback");
    return 'web_fallback';
  }

  return health;
};
```

### Structured Response Format

All documentation retrieval responses should include:
- **Library Overview**: Name, type, description, official links
- **Key Information**: Installation, basic usage, authentication
- **Code Examples**: Working snippets, imports, configuration
- **Next Steps**: Related topics, additional resources, team contacts

### Best Practices

#### Effective Research Queries
- **Be Specific**: Include version numbers, specific methods, or use cases
- **Use Mode Appropriately**: "code" for implementation, "info" for understanding
- **Leverage Topics**: Focus searches with specific topics like "authentication" or "performance"
- **Paginate When Needed**: Use `--page` parameter for additional results

#### Source Validation
- **Cross-Reference**: Verify information across multiple sources when critical
- **Check Recency**: Ensure external documentation is current (within 1 year)
- **Validate Internal**: Confirm internal docs are maintained and accurate
- **Test Examples**: Verify code examples work with current versions

### Integration Standards

#### Response Structure Standards
- Always provide working code examples when available
- Include installation/setup instructions
- Reference official documentation sources
- Provide next steps for deeper learning
- Include team contacts for internal services

#### Cross-Skill Handoff Standards
- Format responses for easy consumption by development skills
- Include implementation-ready code snippets
- Provide configuration examples and troubleshooting guidance
- Reference related documentation for comprehensive understanding

### Preconditions Reference

- Context7 MCP server must be accessible for external library documentation (with automatic resilience)
- Glean MCP server must be accessible for internal FUB documentation (with automatic resilience)
- Internet connectivity for web search fallback when MCP servers are unavailable
- Understanding of FUB internal service architecture and naming conventions

### Fallback URLs Reference

**Package Registries:**
- JavaScript: `https://www.npmjs.com/package/{package-name}`
- PHP: `https://packagist.org/packages/{vendor}/{package}`
- Python: `https://pypi.org/project/{package-name}/`

**Documentation Sites:**
- Read the Docs: `https://{project}.readthedocs.io/`
- GitHub Search: `https://github.com/search?q={library-name}&type=repositories`

This reference guide provides comprehensive support for understanding and utilizing the documentation retrieval capabilities effectively across external libraries and internal FUB services.