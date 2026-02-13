---
name: confluence-management
description: Comprehensive Confluence page management including search, retrieval, creation, updates, and space management with Atlassian MCP integration and browser fallback
---

## Overview

Comprehensive Confluence page management system with seamless integration between Atlassian MCP, Glean MCP, and browser automation for search, retrieval, creation, updates, and space management. Optimized for FUB documentation workflows with intelligent content format conversion and multiple fallback mechanisms for maximum reliability.

## Usage

```bash
/confluence-management [--operation=<op>] [--page_id=<id>] [--query=<search>] [--space_key=<key>] [--space_id=<id>] [--space_type=<type>] [--content_format=<format>] [--cloud_id=<id>]
```

📁 **Comprehensive Examples**: [examples/basic-usage-examples.md](examples/basic-usage-examples.md)

## ⚠️ CRITICAL REQUIREMENT: TITLE DUPLICATION PREVENTION

**BLOCKING RULE**: Before creating or updating ANY Confluence page, you MUST:

1. **VALIDATE**: Check if the page title appears as a heading (# Title) at the start of the body content
2. **REMOVE**: If found, completely remove the title from the body content
3. **VERIFY**: Confirm the body content starts with ## headings, never # headings
4. **FAIL**: If you cannot guarantee title is not duplicated, REFUSE the operation and ask user to provide content without the title

**NEVER PROCEED** with page creation/update if the title appears in the body content.

**Example Validation Process**:
```
Title: "API Setup Guide"
Body: "# API Setup Guide\n\n## Overview..."
❌ FAIL - Title duplicated, remove "# API Setup Guide\n\n"

Title: "API Setup Guide"
Body: "## Overview..."
✅ PASS - No title duplication
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Search and Discovery**
```bash
# Search for recent FUB documentation
/confluence-management --operation="search" --query="space=FUB AND updated >= -7d"

# Find pages by content type or author
/confluence-management --operation="search" --query="type=page AND creator=username"

# Natural language search with space filtering
/confluence-management --operation="search" --query="API documentation" --space_key="FUB"
```

**2. Page Retrieval and Content Access**
```bash
# Get specific page content as markdown
/confluence-management --operation="get" --page_id="123456789" --content_format="markdown"

# Retrieve page with all metadata
/confluence-management --operation="get" --page_id="123456789"

# Get page by title within space
/confluence-management --operation="search" --query="title='API Guide'" --space_key="FUB"
```

**3. Content Creation and Updates**
```bash
# Create new API documentation page
/confluence-management --operation="create" --space_key="FUB" --title="User Service API" --content_format="markdown"

# Update existing page content
/confluence-management --operation="update" --page_id="123456789" --content_format="markdown"

# Create page in personal space
/confluence-management --operation="create" --space_type="personal" --title="Personal Notes"
```

**4. Space Management and Organization**
```bash
# List all accessible spaces
/confluence-management --operation="spaces"

# Get space information and page structure
/confluence-management --operation="spaces" --space_key="FUB"

# Find pages within specific space
/confluence-management --operation="search" --space_key="FUB"
```

### Behavior

When invoked, execute this systematic Confluence management workflow:

**1. Operation Routing and Authentication**
- Determine operation type (search, get, create, update, spaces, comments)
- Authenticate with Atlassian MCP (primary) or fallback to browser automation
- Validate required parameters for selected operation

**2. Content Processing and Validation**
- For create/update operations: **CRITICAL** - validate title duplication prevention
- Convert content between markdown and Confluence format as needed
- Resolve space keys to space IDs when required
- Apply FUB-specific content standards and formatting

**3. Operation Execution with Fallbacks**
- Execute operation using primary MCP integration
- If MCP fails, attempt Glean MCP search integration
- If both fail, use browser automation as final fallback
- Provide detailed error context and recovery suggestions

**4. Results Processing and Integration**
- Format results for optimal readability and downstream integration
- Extract key metadata (page ID, URLs, modification dates)
- Prepare content for cross-skill workflow integration
- Generate operation summaries and next-step recommendations

## Quick Reference

📊 **Complete Reference**: [reference/quick-reference.md](reference/quick-reference.md)

| Operation | Purpose | Primary Parameters | Output |
|-----------|---------|-------------------|---------|
| `search` | Find pages by query/content | `query`, `space_key` | List of matching pages with metadata |
| `get` | Retrieve specific page content | `page_id`, `content_format` | Full page content and metadata |
| `create` | Create new page | `space_key`, `title`, content | New page ID and URL |
| `update` | Modify existing page | `page_id`, content | Updated page metadata |
| `spaces` | List/manage spaces | `space_key` (optional) | Space information and structure |
| `comments` | Manage page comments | `page_id` | Page comments and metadata |

### Authentication and Access

- **Primary**: Atlassian MCP integration (zillowgroup.atlassian.net)
- **Secondary**: Glean MCP for search operations
- **Fallback**: Browser automation for complex operations
- **Permissions**: Inherits user's Confluence access level

## Advanced Patterns

🔧 **Advanced Techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced Confluence management techniques and automation strategies</summary>

### Complex Search and Discovery Patterns

**Advanced CQL queries for precise content discovery:**
```bash
# Multi-criteria search with date ranges and content types
/confluence-management --operation="search" --query="space=FUB AND type=page AND updated >= -30d AND title ~ 'API'"
```

**Content classification and bulk operations:**
```bash
# Find and categorize documentation by patterns
/confluence-management --operation="search" --query="label in ('api','documentation') AND space=FUB"
```

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Confluence → Documentation Skills:**
```bash
# Extract Confluence content for processing
/confluence-management --operation="get" --page_id="123456789" --content_format="markdown" |\
  markdown-management --operation="lint" --fix="links,formatting"

# Search and analyze documentation patterns
/confluence-management --operation="search" --query="space=FUB AND type=page" |\
  text-manipulation --operation="extract" --patterns="api-endpoints,error-codes"
```

**Development → Confluence Publishing:**
```bash
# Generate and publish API documentation
/code-development --task="Generate API docs" --format="markdown" |\
  confluence-management --operation="create" --space_key="FUB" --title="API Reference"

# Publish troubleshooting guides from investigation results
/support-investigation --export="markdown" --include="solutions,steps" |\
  confluence-management --operation="update" --page_id="troubleshooting-guide"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `jira-management` | **Atlassian Integration** | Issue → documentation linking, requirement tracking, project documentation |
| `markdown-management` | **Content Processing** | Markdown validation, link checking, format conversion, documentation workflows |
| `text-manipulation` | **Content Analysis** | Text extraction, pattern analysis, content cleanup, format normalization |
| `documentation-retrieval` | **Information Discovery** | Documentation search, API reference lookup, knowledge base integration |
| `support-investigation` | **Knowledge Capture** | Incident documentation, troubleshooting guides, solution publishing |
| `code-development` | **Development Workflow** | API documentation, code example publishing, development guide creation |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Specialized Operations

🏗️ **Space Management**: [operations/space-management.md](operations/space-management.md)

**Personal space operations, space creation, and organizational workflows**

🔧 **Troubleshooting Guide**: [troubleshooting/common-issues.md](troubleshooting/common-issues.md)

**Common authentication issues, content formatting problems, and resolution strategies**

### Multi-Skill Operation Examples

**Complete Documentation Workflow:**
1. `confluence-management` - Search and retrieve existing documentation for analysis
2. `markdown-management` - Validate and format documentation content
3. `text-manipulation` - Extract and normalize key information patterns
4. `code-development` - Generate updated API examples and documentation
5. `confluence-management` - Publish updated comprehensive documentation

**Complete Support Documentation Workflow:**
1. `support-investigation` - Analyze incident and generate resolution documentation
2. `text-manipulation` - Extract key patterns and error signatures
3. `confluence-management` - Create or update troubleshooting knowledge base
4. `jira-management` - Link documentation to relevant issues and epics
5. `datadog-management` - Add monitoring context and related metrics

**Complete API Documentation Pipeline:**
1. `code-development` - Generate API documentation from code annotations
2. `markdown-management` - Validate and format generated documentation
3. `confluence-management` - Publish to team documentation space
4. `text-manipulation` - Extract API endpoints for monitoring configuration
5. `datadog-management` - Create monitoring dashboards with API documentation links