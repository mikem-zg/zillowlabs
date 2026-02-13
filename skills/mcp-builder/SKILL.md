---
name: mcp-builder
description: "Build production-ready MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Covers TypeScript, Python, and Go SDKs with the latest 2025-11-25 spec including outputSchema, structuredContent, tool annotations, async Tasks, OAuth 2.1, and deployment to Cloudflare Workers, Docker, or cloud platforms."
---

# MCP Server Development Guide

Build MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. The quality of an MCP server is measured by how well it enables LLMs to accomplish real-world tasks.

## When to Use This Skill

- Building MCP servers to integrate external APIs or services
- Creating tool interfaces for LLMs (Claude, GPT, Gemini, etc.)
- Connecting AI agents to databases, SaaS platforms, or internal systems
- Deploying MCP servers for production use (remote or local)

## MCP Protocol Overview

MCP is an open protocol for connecting LLMs to external tools and data. Think of it as "USB-C for AI" — one standard interface for any AI client to connect to any service.

### Core Primitives

| Primitive | Purpose | Example |
|-----------|---------|---------|
| **Tools** | Functions the LLM can call | `search_issues`, `create_ticket` |
| **Resources** | Data sources the LLM can read | Files, database records, API responses |
| **Prompts** | Reusable prompt templates | Analysis templates, report generators |

### Spec Version: 2025-11-25

Key features in the latest spec:
- **outputSchema** — Define expected tool output structure (JSON Schema)
- **structuredContent** — Return typed structured data alongside text content
- **Tool annotations** — `readOnlyHint`, `destructiveHint`, `idempotentHint`, `openWorldHint`
- **Async Tasks** — Long-running operations with progress tracking
- **OAuth 2.1** — Authorization Code + PKCE with Resource Indicators (RFC 8707)
- **Extension framework** — Experimental feature support

## Architecture

```
┌─────────────────────┐
│   MCP Host          │  (Claude Desktop, VS Code, Cursor, custom app)
│  ┌───────────────┐  │
│  │  MCP Client   │  │  Manages connections to servers
│  └───────┬───────┘  │
└──────────┼──────────┘
           │
    ┌──────┴──────┬────────────┐
    │             │            │
┌───▼───┐    ┌───▼───┐   ┌───▼───┐
│Server1│    │Server2│   │Server3│
│(GitHub)│   │(Slack)│   │(Custom)│
└───────┘    └───────┘   └───────┘
```

- **Host** — Runtime environment (e.g., Claude Desktop)
- **Client** — Built into host, manages server connections
- **Server** — Exposes tools/resources/prompts via MCP protocol

---

# Development Process

## Phase 1: Research and Planning

### 1.1 Choose Your SDK

| Language | SDK | Transport Support | Best For |
|----------|-----|-------------------|----------|
| **TypeScript** (recommended) | `@modelcontextprotocol/sdk` | stdio, HTTP+SSE, Streamable HTTP (pending) | Node.js stacks, broad ecosystem |
| **Python** | `mcp` (includes FastMCP) | stdio, HTTP+SSE, Streamable HTTP | Data science, ML pipelines |
| **Go** | `github.com/modelcontextprotocol/go-sdk` | stdio, HTTP+SSE, Streamable HTTP | High-performance microservices |

### 1.2 Choose Your Transport

| Transport | Use Case | Auth | When to Use |
|-----------|----------|------|-------------|
| **stdio** | Local servers | OS process security | Claude Desktop, VS Code, dev tools |
| **Streamable HTTP** | Remote servers | OAuth 2.1 | Production SaaS, multi-client |
| **HTTP+SSE** | Legacy remote | OAuth 2.0 | Backwards compatibility only |

### 1.3 Study the Target API

- Review API documentation for endpoints, auth, and data models
- Identify key operations: CRUD, search, aggregation
- Map API rate limits and pagination patterns
- Note authentication requirements (OAuth, API key, token)

### 1.4 Plan Tool Selection

**Balance API coverage vs. workflow tools:**

| Approach | Pros | Cons |
|----------|------|------|
| **Comprehensive API coverage** | Agents compose flexibly | More tools to discover |
| **Workflow tools** | Convenient for specific tasks | Less flexible |
| **Hybrid** (recommended) | Best of both | More implementation work |

**Prioritize comprehensive API coverage when uncertain.** Some clients benefit from code execution that combines basic tools, while others work better with higher-level workflows.

### 1.5 Study SDK Documentation

**Load framework documentation:**

- [📋 Best Practices](./reference/best-practices.md) — Universal MCP guidelines
- [🔒 Security & Deployment](./reference/security-deployment.md) — Production hardening

**For TypeScript (recommended):**
- Fetch: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- [⚡ TypeScript Guide](./reference/typescript-server.md) — Patterns and examples
- [📦 TypeScript Template](./examples/typescript-template.md) — Copy-paste starter

**For Python:**
- Fetch: `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`
- [🐍 Python Guide](./reference/python-server.md) — Patterns and examples
- [📦 Python Template](./examples/python-template.md) — Copy-paste starter

**MCP Protocol Spec:**
- Sitemap: `https://modelcontextprotocol.io/sitemap.xml`
- Fetch specific pages with `.md` suffix: `https://modelcontextprotocol.io/specification/2025-11-25.md`

---

## Phase 2: Implementation

### 2.1 Set Up Project Structure

**TypeScript:** `{service}-mcp-server` (lowercase with hyphens)
```
github-mcp-server/
├── package.json
├── tsconfig.json
├── README.md
├── src/
│   ├── index.ts           # McpServer init + transport setup
│   ├── types.ts           # TypeScript interfaces
│   ├── constants.ts       # API_URL, CHARACTER_LIMIT, etc.
│   ├── tools/             # Tool implementations (one file per domain)
│   ├── services/          # API clients and shared utilities
│   └── schemas/           # Zod validation schemas
└── dist/                  # Built JS (entry: dist/index.js)
```

**Python:** `{service}_mcp` (lowercase with underscores)
```
github_mcp/
├── pyproject.toml
├── README.md
├── server.py              # FastMCP server + tool definitions
├── models.py              # Pydantic input models
├── client.py              # API client with httpx
└── constants.py           # Configuration values
```

### 2.2 Implement Core Infrastructure

Create shared utilities first:
- API client with authentication and retry logic
- Error handling helpers with actionable messages
- Response formatting (JSON and Markdown)
- Pagination support with `has_more`, `next_offset`, `total_count`
- Character limit enforcement (default: 25,000 chars)

### 2.3 Implement Tools

For each tool, provide:

**Input Schema:**
- Use Zod (TypeScript) or Pydantic (Python) for runtime validation
- Include constraints, defaults, and clear `.describe()` annotations
- Use `.strict()` (Zod) or `extra='forbid'` (Pydantic) to reject unknown fields

**Output Schema (2025-11-25 spec):**
- Define `outputSchema` for structured data tools
- Return both `content` (text) and `structuredContent` (typed JSON)
- Text content provides backwards compatibility for older clients

**Tool Description:**
- Concise summary of what the tool does
- When to use / when NOT to use
- Parameter descriptions with examples
- Return type schema documentation
- Error handling behavior

**Annotations:**
```typescript
annotations: {
  readOnlyHint: true,      // Does NOT modify environment
  destructiveHint: false,  // Does NOT perform destructive updates
  idempotentHint: true,    // Repeated calls = same result
  openWorldHint: true      // Interacts with external entities
}
```

### 2.4 Tool Registration Patterns

**TypeScript (McpServer):**
```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({ name: "github-mcp-server", version: "1.0.0" });

server.registerTool("github_search_issues", {
  title: "Search GitHub Issues",
  description: "Search issues by query, labels, assignee, or state...",
  inputSchema: {
    query: z.string().min(1).describe("Search query"),
    state: z.enum(["open", "closed", "all"]).default("open"),
    limit: z.number().int().min(1).max(100).default(20)
  },
  outputSchema: {
    total: z.number(),
    issues: z.array(z.object({ id: z.number(), title: z.string() }))
  },
  annotations: { readOnlyHint: true, idempotentHint: true }
}, async ({ query, state, limit }) => {
  const result = await searchIssues(query, state, limit);
  return {
    content: [{ type: "text", text: formatAsMarkdown(result) }],
    structuredContent: result
  };
});
```

**Python (FastMCP):**
```python
from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field

mcp = FastMCP("github_mcp")

class SearchInput(BaseModel):
    query: str = Field(..., min_length=1, description="Search query")
    state: str = Field(default="open", pattern="^(open|closed|all)$")
    limit: int = Field(default=20, ge=1, le=100)

@mcp.tool(name="github_search_issues", annotations={"readOnlyHint": True})
async def search_issues(params: SearchInput) -> str:
    """Search issues by query, labels, assignee, or state."""
    result = await api_search(params.query, params.state, params.limit)
    return json.dumps(result, indent=2)
```

---

## Phase 3: Review and Test

### 3.1 Code Quality Checklist

- [ ] No duplicated code (DRY)
- [ ] Consistent error handling across all tools
- [ ] Full type coverage (no `any` types in TypeScript)
- [ ] Clear, comprehensive tool descriptions
- [ ] Input validation on all parameters
- [ ] Pagination on list operations
- [ ] Character limits on large responses
- [ ] Service-prefixed tool names (`github_`, `slack_`, etc.)
- [ ] Both JSON and Markdown response formats supported
- [ ] Tool annotations set correctly

### 3.2 Build and Test

**TypeScript:**
```bash
npm run build
npx @modelcontextprotocol/inspector  # Interactive testing UI
```

**Python:**
```bash
python -m py_compile server.py
npx @modelcontextprotocol/inspector  # Works for Python too
```

**MCP Inspector** provides an interactive UI to:
- List available tools and their schemas
- Call tools with test inputs
- Inspect responses and error handling
- Verify pagination behavior

### 3.3 Integration Testing

Test with a real MCP client:
- Claude Desktop (stdio)
- VS Code with MCP extension
- Custom client using SDK

---

## Phase 4: Create Evaluations

After implementing your MCP server, create comprehensive evaluations to test its effectiveness.

**Load [✅ Evaluation Guide](./reference/evaluation.md) for complete guidelines.**

### Quick Summary

1. Create **10 complex, realistic questions** that test tool effectiveness
2. Questions must be **READ-ONLY, INDEPENDENT, NON-DESTRUCTIVE, IDEMPOTENT**
3. Each question requires **multiple tool calls** (potentially dozens)
4. Answers must be **single, verifiable values** (stable over time)
5. Output as XML:

```xml
<evaluation>
  <qa_pair>
    <question>Find the repository archived in Q3 2023 that was previously the most forked. What language?</question>
    <answer>Python</answer>
  </qa_pair>
</evaluation>
```

---

## Reference Files

### Core Documentation (Load First)
- [📋 Best Practices](./reference/best-practices.md) — Naming, pagination, response formats, transport
- [🔒 Security & Deployment](./reference/security-deployment.md) — OAuth, hardening, deployment patterns, antipatterns

### SDK-Specific Guides (Load During Phase 2)
- [⚡ TypeScript Guide](./reference/typescript-server.md) — McpServer, Zod, registerTool patterns
- [🐍 Python Guide](./reference/python-server.md) — FastMCP, Pydantic, decorator patterns

### Templates (Copy-Paste Starters)
- [📦 TypeScript Template](./examples/typescript-template.md) — Complete project scaffold
- [📦 Python Template](./examples/python-template.md) — Complete project scaffold

### Evaluation (Load During Phase 4)
- [✅ Evaluation Guide](./reference/evaluation.md) — Question creation, answer verification, XML format

### External Resources (Fetch as Needed)
- MCP Sitemap: `https://modelcontextprotocol.io/sitemap.xml`
- TypeScript SDK: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- Python SDK: `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`
- Go SDK: `https://raw.githubusercontent.com/modelcontextprotocol/go-sdk/main/README.md`

---

## NEVER Do

| NEVER | ALWAYS Instead |
|-------|----------------|
| Generic tool names (`send_message`) | Service-prefixed (`slack_send_message`) |
| 1:1 REST endpoint mapping | Goal-oriented workflow tools |
| No input validation | Zod/Pydantic schemas with constraints |
| Return all records (no pagination) | Paginate with `limit`, `offset`, `has_more` |
| Complex nested argument objects | Flat top-level primitives and enums |
| Human-focused error messages | Agent-actionable error messages with next steps |
| Hardcoded API keys in source | Environment variables or secret vaults |
| Bind to `0.0.0.0` for local servers | Bind to `127.0.0.1` |
| `server.tool()` (deprecated) | `server.registerTool()` (modern API) |
| Skip tool annotations | Set `readOnlyHint`, `destructiveHint`, etc. |
| Skip `outputSchema` | Define structured output schemas for typed tools |
| Deploy without auth | OAuth 2.1 for remote, OS security for stdio |
| Log to stdout in stdio mode | Use stderr for logging |
| Trust tool annotations blindly | Validate annotations from untrusted servers |
