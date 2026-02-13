## Documentation Research Patterns and Templates

### MCP Tool Commands

**Context7 (External Libraries):**
```javascript
// Step 1: Resolve library ID
await mcp__context7__resolve_library_id({
  query: "React hooks for state management",
  libraryName: "react"
});

// Step 2: Get documentation
await mcp__context7__query_docs({
  libraryId: "/facebook/react",
  query: "useState and useEffect hook patterns"
});
```

**Glean (Internal Documentation):**
```javascript
// Search internal docs
await mcp__glean_tools__search({
  query: "fub-api authentication patterns",
  app: "confluence",
  updated: "past_month"
});

// Search internal code
await mcp__glean_tools__code_search({
  query: "EmailParser configuration examples",
  owner: "me",
  after: "2024-01-01"
});

// Read full documents
await mcp__glean_tools__read_document({
  urls: ["https://confluence.company.com/display/API/Auth"]
});
```

### Common Search Patterns

**External Library Research:**
- **API Documentation**: `--mode="code"` + specific method names
- **Getting Started**: `--mode="info"` + "tutorial" or "setup"
- **Integration Examples**: `--mode="code"` + "integration" or "configuration"
- **Troubleshooting**: Library name + "common issues" or "debugging"

**Internal Service Research:**
- **Service APIs**: Service name + "API" + `--internal` flag
- **Configuration**: Service name + "config" or "setup" + `--internal`
- **Deployment**: Service name + "deployment" + `--mode="info"`
- **Team Documentation**: Team name + "runbook" or "procedures" + `--internal`

### Source Priority Strategy

**For External Libraries:**
1. **Context7 MCP** - Primary curated documentation source
2. **Package Registries** - npm, Packagist, PyPI for official info
3. **GitHub Repository** - README, docs/, issues for details
4. **Official Websites** - Project sites for comprehensive guides

**For Internal Services:**
1. **Glean MCP** - Primary internal documentation source
2. **Internal Repositories** - Code, README, configuration files
3. **Team Documentation** - Confluence, wikis, internal sites
4. **Team Communication** - Recent Slack discussions, decisions

### Mode-Specific Usage

**Code Mode (--mode="code"):**
- API reference documentation
- Function signatures and parameters
- Executable code examples
- Configuration options and setup
- Import statements and initialization

**Info Mode (--mode="info"):**
- Conceptual explanations and architecture
- Design patterns and best practices
- Migration guides and changelogs
- Getting started tutorials
- Operational procedures (for internal services)

### Fallback Research URLs

**Package Registries:**
- JavaScript: `https://www.npmjs.com/package/{package-name}`
- PHP: `https://packagist.org/packages/{vendor}/{package}`
- Python: `https://pypi.org/project/{package-name}/`

**Documentation Sites:**
- Read the Docs: `https://{project}.readthedocs.io/`
- GitHub Search: `https://github.com/search?q={library-name}&type=repositories`

### Quality Indicators

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

### Essential Documentation Retrieval Steps

**1. Determine Documentation Source**
- Check for `--internal` flag or FUB-specific terms (fub, pegasus, mapture)
- **If Internal**: Use Glean MCP for internal documentation
- **If External**: Use Context7 MCP for library documentation
- **If Uncertain**: Search both sources

**2. External Library Research (Context7 MCP)**
```bash
# Resolve library ID first
mcp__context7__resolve-library-id --query="user's original question" --libraryName="library-name"

# Get documentation with resolved ID
mcp__context7__query-docs --libraryId="/org/project" --query="focused query with topic"
```

**3. Internal Documentation Research (Glean MCP)**
```bash
# Search internal documentation
mcp__glean-tools__search --query="library-name + topic + mode intent"

# Get code examples
mcp__glean-tools__code_search --query="library-name + code patterns"

# Read full documentation
mcp__glean-tools__read_document --urls=["url1", "url2"]
```

**4. Fallback Research Methods**
- **Package Registries**: npm, Packagist, PyPI for official information
- **GitHub Search**: Repository documentation, README files, issues
- **Web Search**: Official sites, community resources, tutorials

**5. Structure Response**
- **Library Overview**: Name, type, description, official links
- **Key Information**: Installation, basic usage, authentication
- **Code Examples**: Working snippets, imports, configuration
- **Next Steps**: Related topics, additional resources, team contacts

This template library provides the foundation for systematic documentation retrieval across external libraries and internal FUB services.