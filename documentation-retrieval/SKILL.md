---
name: documentation-retrieval
description: Research library and internal documentation using Context7 MCP (external libraries), Glean MCP (internal documentation), and web searches to provide developers with up-to-date API references, code examples, and conceptual guides across both internal FUB services and external libraries
---

## Overview

Research library and internal documentation using Context7 MCP (external libraries), Glean MCP (internal documentation), and web searches to provide developers with up-to-date API references, code examples, and conceptual guides across both internal FUB services and external libraries.

📋 **Research Patterns**: [templates/research-patterns.md](templates/research-patterns.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **Documentation Reference**: [reference/documentation-reference.md](reference/documentation-reference.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. External Library Research**
```bash
# Get React hook documentation with code examples
/documentation-retrieval --library="react" --mode="code" --topic="hooks"

# Research MongoDB connection patterns
/documentation-retrieval --library="mongodb" --mode="code" --topic="connection"

# Understanding library concepts and architecture
/documentation-retrieval --library="Vue.js" --mode="info" --topic="overview"
```

**2. Internal Service Documentation**
```bash
# Research internal FUB API authentication
/documentation-retrieval --library="fub-api" --topic="authentication" --internal

# Understanding internal Pegasus service architecture
/documentation-retrieval --library="pegasus" --mode="info" --topic="deployment"

# Search for internal team documentation
/documentation-retrieval --library="deployment process" --internal
```

**3. Documentation Source Strategy**
- **External Libraries**: Context7 MCP → Package Registries → GitHub → Official Sites
- **Internal Services**: Glean MCP → Internal Repositories → Team Documentation → Team Communication
- **Hybrid Approach**: Search both sources when uncertain about library classification

### Quick Reference

#### Essential Documentation Steps

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

→ **Complete research patterns and MCP tool examples**: [templates/research-patterns.md](templates/research-patterns.md)

### Mode-Specific Usage

**Code Mode (--mode="code" - Default):**
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

## Cross-Skill Integration

### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `code-development` | **Implementation Research** | Library documentation, API usage patterns, implementation examples before coding |
| `backend-test-development` | **Testing Research** | Testing framework documentation, mocking patterns, test setup guides |
| `support-investigation` | **Issue Resolution** | Error documentation, debugging guides, configuration references |
| `serena-mcp` | **Code Understanding** | Complement code analysis with external library documentation |
| `database-operations` | **Database Documentation** | SQL documentation, ORM patterns, migration guides |

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

→ **Complete integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Capabilities

### Multi-Source Research Intelligence
- Context7 MCP integration for curated external library documentation
- Glean MCP integration for comprehensive internal FUB service documentation
- Progressive fallback strategy with package registries and web search
- Quality assessment and validation across multiple sources

### Research-Driven Development Support
- Pre-development library evaluation and compatibility analysis
- Real-time documentation lookup during implementation workflows
- Evidence-based troubleshooting through official documentation
- Integration planning with comprehensive library analysis

### Internal Knowledge Discovery
- FUB service documentation through Glean MCP integration
- Team ownership and support channel identification
- Internal code example discovery and pattern analysis
- Cross-team knowledge sharing and documentation access

→ **Advanced research workflows and complex integration patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Quality Indicators

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

## Preconditions

- Context7 MCP server must be accessible for external library documentation (with automatic resilience)
- Glean MCP server must be accessible for internal FUB documentation (with automatic resilience)
- Internet connectivity for web search fallback when MCP servers are unavailable
- Understanding of FUB internal service architecture and naming conventions

### MCP Resilience Integration

**Enhanced Reliability**: This skill implements standardized MCP resilience patterns:
- Dual-server health checking for both Context7 MCP and Glean MCP
- Automatic failover between internal (Glean) and external (Context7) documentation sources
- Circuit breaker protection for failing MCP connections
- Transparent fallback to web search when both MCP servers are unavailable

## Refusal Conditions

The skill must refuse if:
- Both Context7 and Glean MCP servers are unavailable and web fallback fails
- Library parameter is empty or contains only whitespace
- Internal documentation requested but Glean MCP is inaccessible without fallback
- Request violates documentation access permissions or security policies
- Requested library or service does not exist and cannot be resolved through any source

When refusing, explain which requirement prevents execution and provide specific guidance:
- How to verify MCP server connectivity and health status
- Alternative research approaches using manual methods and direct sources
- Steps to clarify library names or internal service identification
- Recommendations for accessing documentation through alternative channels
- Fallback research strategies when automated sources are unavailable

→ **Complete troubleshooting guide and MCP resilience reference**: [reference/documentation-reference.md](reference/documentation-reference.md)

## Supporting Infrastructure

→ **Advanced patterns and complex research workflows**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Research patterns, MCP tool examples, and common workflows**: [templates/research-patterns.md](templates/research-patterns.md)
→ **Cross-skill integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

This skill provides comprehensive documentation research capabilities that enable informed development decisions through intelligent access to both external library documentation and internal FUB service knowledge.