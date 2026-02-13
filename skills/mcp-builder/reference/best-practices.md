# MCP Best Practices

Universal best practices for building production-quality MCP servers. These guidelines apply regardless of implementation language (TypeScript, Python, Go).

---

## 1. Server Naming Conventions

Use lowercase, descriptive names that identify the service. Never include version numbers in the server name.

| Language | Convention | Example |
|----------|-----------|---------|
| **Python** | `{service}_mcp` (underscores) | `github_mcp`, `slack_mcp`, `jira_mcp` |
| **TypeScript** | `{service}-mcp-server` (hyphens) | `github-mcp-server`, `slack-mcp-server` |
| **Go** | `{service}-mcp-server` (hyphens) | `github-mcp-server`, `stripe-mcp-server` |

**Rules:**
- Lowercase only — no `GitHub_MCP` or `SlackMcpServer`
- Use the service's common short name — `github` not `github-dot-com`
- No version numbers — `slack_mcp` not `slack_mcp_v2`
- No generic suffixes — `slack_mcp` not `slack_mcp_tool_collection`

| ✅ Good | ❌ Bad | Why |
|---------|--------|-----|
| `github_mcp` | `GitHubMCP` | Must be lowercase |
| `slack-mcp-server` | `slack-server-v2` | No version numbers; include `mcp` |
| `stripe_mcp` | `payment_processor_mcp` | Use service name, not category |
| `jira-mcp-server` | `atlassian-jira-mcp-server` | Use common short name |

---

## 2. Tool Naming and Design

### Naming Rules

Use `snake_case` with a service prefix to avoid conflicts when multiple MCP servers are connected.

**Pattern:** `{service}_{verb}_{noun}`

```
slack_send_message
github_create_issue
jira_search_tickets
stripe_list_invoices
```

**Action verbs (use consistently):**

| Verb | Purpose | Example |
|------|---------|---------|
| `get` | Retrieve single item by ID | `github_get_issue` |
| `list` | Retrieve multiple items (paginated) | `slack_list_channels` |
| `search` | Query with filters | `jira_search_tickets` |
| `create` | Create new resource | `github_create_issue` |
| `update` | Modify existing resource | `jira_update_ticket` |
| `delete` | Remove resource | `slack_delete_message` |

### What to Avoid

| ❌ Avoid | ✅ Use Instead | Reason |
|----------|---------------|--------|
| `sendMessage` | `slack_send_message` | No camelCase |
| `send_message` | `slack_send_message` | Must have service prefix |
| `slack.send.message` | `slack_send_message` | No dots |
| `slack send message` | `slack_send_message` | No spaces |
| `slack[send]` | `slack_send_message` | No brackets |
| `do_stuff` | `github_create_issue` | Must be specific and descriptive |
| `handle_request` | `stripe_create_payment` | Must describe the actual operation |

### Design Principles

- **Flat parameters** — Use top-level primitives and enums, not deeply nested objects
- **Sensible defaults** — Every optional parameter should have a documented default
- **Strict validation** — Reject unknown fields (`strict()` in Zod, `extra='forbid'` in Pydantic)
- **Atomic operations** — Each tool does one thing well

---

## 3. Tool Description Standards

Tool descriptions are critical — they are the primary way LLMs understand when and how to use each tool. Write descriptions for an AI agent, not a human developer.

### Required Elements

1. **Concise summary** (first line) — What the tool does in one sentence
2. **When to use** — Scenarios where this tool is the right choice
3. **When NOT to use** — Common mistakes or better alternatives
4. **Parameter details** — Constraints, formats, examples for non-obvious params
5. **Return format** — What the response contains
6. **Error behavior** — What happens on failure

### Example Format

```
Search GitHub issues and pull requests by query string, labels, assignee, or state.

Use this tool to find existing issues before creating new ones, to check for
duplicates, or to gather context about a topic across repositories.

Do NOT use this tool to get a single issue by number — use github_get_issue instead.

Parameters:
- query: Search terms (e.g., "memory leak", "label:bug assignee:octocat")
- state: Filter by state. Default: "open"
- repo: Optional. Scope search to a specific repo (e.g., "owner/repo")
- limit: Max results to return (1-100). Default: 20

Returns a list of matching issues with id, title, state, author, labels, and
created/updated timestamps. Results are ordered by relevance.

On error, returns an error message with the failed query and suggested corrections.
```

### Guidelines

- Write in plain English, not code jargon
- Keep the summary under 160 characters for display in tool lists
- Be specific about parameter formats — "ISO 8601 date" not just "date"
- Mention related tools by name — "Use `github_get_issue` for single lookups"
- Include example values inline — `(e.g., "owner/repo")`

---

## 4. Tool Annotations

Annotations are metadata hints that help clients understand a tool's behavior. They inform UI decisions (confirmation dialogs, safety warnings) and agent planning.

| Annotation | Type | Default | Meaning |
|------------|------|---------|---------|
| `readOnlyHint` | boolean | `false` | Tool does NOT modify any state or data |
| `destructiveHint` | boolean | `true` | Tool may perform irreversible destructive operations |
| `idempotentHint` | boolean | `false` | Repeated calls with same args produce same result |
| `openWorldHint` | boolean | `true` | Tool interacts with external entities beyond its control |

### When to Set Each Annotation

**`readOnlyHint: true`** — Search, get, list, and query operations:
```
github_search_issues, slack_list_channels, jira_get_ticket
```

**`destructiveHint: true`** — Delete, revoke, and permanent operations:
```
github_delete_repo, slack_delete_message, stripe_cancel_subscription
```

**`destructiveHint: false`** — Create and update operations (reversible):
```
github_create_issue, slack_send_message, jira_update_ticket
```

**`idempotentHint: true`** — Operations safe to retry:
```
github_get_issue (same result each call)
jira_update_ticket (setting same values = same state)
```

**`idempotentHint: false`** — Operations that create side effects:
```
slack_send_message (sends duplicate messages)
github_create_issue (creates duplicate issues)
```

**`openWorldHint: true`** — Most tools that call external APIs

**`openWorldHint: false`** — Tools that operate on purely local data

### ⚠️ Security Note

Annotations are **untrusted hints**, not security guarantees. A tool claiming `readOnlyHint: true` might still modify data. Clients and hosts:
- SHOULD use annotations for UX decisions (showing confirmation dialogs)
- MUST NOT rely on annotations for security enforcement
- SHOULD validate annotations against known behavior for untrusted servers

---

## 5. Response Format Guidelines

Support both JSON and Markdown response formats. Let the caller choose via a `response_format` parameter.

### ResponseFormat Pattern

```
response_format: "markdown" | "json"   (default varies by tool type)
```

### Markdown Format (default for display-oriented tools)

Best when agents will present results to users or need human-readable summaries.

- Use headers (`##`) to separate sections
- Use bullet lists for properties
- Format timestamps as human-readable: "Jan 15, 2025 at 3:42 PM" not "2025-01-15T15:42:00Z"
- Show display names with IDs: "Alice Chen (user_abc123)"
- Use tables for tabular data
- Bold key information: **Status: Open**

```markdown
## Issue #42: Fix memory leak in worker pool

- **Status:** Open
- **Author:** Alice Chen (user_abc123)
- **Labels:** bug, priority-high
- **Created:** Jan 15, 2025 at 3:42 PM
- **Assignee:** Bob Smith (user_def456)

### Description
The worker pool leaks memory when tasks are cancelled mid-execution...
```

### JSON Format (default for data-pipeline tools)

Best when agents will process results programmatically or pass data to other tools.

- Return complete structured data
- Use consistent field names across all tools (`created_at`, not sometimes `created` and sometimes `timestamp`)
- Include IDs for all referenced entities
- Use ISO 8601 for timestamps
- Use `null` for absent values, not empty strings

```json
{
  "id": 42,
  "title": "Fix memory leak in worker pool",
  "state": "open",
  "author": { "login": "alice-chen", "id": "user_abc123" },
  "labels": ["bug", "priority-high"],
  "created_at": "2025-01-15T15:42:00Z",
  "assignee": { "login": "bob-smith", "id": "user_def456" }
}
```

### Default Format by Tool Type

| Tool Type | Default Format | Rationale |
|-----------|---------------|-----------|
| Search / List | Markdown | Results are typically presented to users |
| Get (single item) | Markdown | Detailed view for user consumption |
| Create / Update | JSON | Agent needs structured data for follow-up actions |
| Delete | Markdown | Simple confirmation message |
| Data export | JSON | Programmatic consumption |

---

## 6. Pagination Best Practices

All list and search operations MUST support pagination. Never load all results into memory.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `limit` | integer | Max items to return. Default: 20-50. Max: 100 |
| `offset` | integer | Number of items to skip (offset-based) |
| `cursor` | string | Opaque cursor for next page (cursor-based) |

### Response Metadata

Always return pagination metadata so agents know whether to fetch more:

```json
{
  "data": [...],
  "pagination": {
    "has_more": true,
    "next_offset": 20,
    "total_count": 142,
    "limit": 20
  }
}
```

For cursor-based pagination:

```json
{
  "data": [...],
  "pagination": {
    "has_more": true,
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "total_count": 142,
    "limit": 20
  }
}
```

### Rules

- **Always respect the `limit` parameter** — never return more items than requested
- **Default to 20-50 items** — large enough to be useful, small enough to fit in context
- **Cap at 100 items per request** — even if the API supports more
- **Return `has_more: true/false`** — so agents know whether to paginate
- **Include `total_count` when available** — helps agents plan their strategy
- **Use cursor-based pagination** when the underlying API supports it (more reliable for real-time data)
- **Use offset-based pagination** for static datasets or APIs that don't support cursors

### Choosing Offset vs Cursor

| Factor | Offset | Cursor |
|--------|--------|--------|
| Underlying API | REST with page/offset params | GraphQL or cursor-based APIs |
| Data stability | Static or slow-changing | Real-time, frequently updated |
| Random access | Yes (jump to page N) | No (sequential only) |
| Consistency | May skip/duplicate on mutation | Consistent snapshots |

---

## 7. Character Limits and Truncation

Define a `CHARACTER_LIMIT` constant (recommended: **25,000 characters**) and enforce it on all tool responses.

### Truncation Strategy

When a response exceeds the character limit:

1. Truncate the content at the limit boundary
2. Append a clear notification explaining the truncation
3. Guide the agent to use pagination or filters to get complete data

```
[TRUNCATED] Response exceeded 25,000 character limit.
Showing 15 of 42 results. Use `limit` and `offset` parameters to paginate,
or add filters to narrow results.
```

### Guidelines

- Apply truncation **after** formatting (Markdown or JSON)
- Truncate at logical boundaries (end of an item, not mid-sentence)
- Always include the truncation notice so agents know data is incomplete
- Include counts: "Showing X of Y results"
- Suggest specific parameters the agent can use to get remaining data

---

## 8. Transport Selection

### Decision Matrix

| Factor | stdio | Streamable HTTP | HTTP+SSE (Legacy) |
|--------|-------|----------------|-------------------|
| **Deployment** | Local process | Remote server | Remote server |
| **Clients** | Single (1:1) | Multiple concurrent | Multiple concurrent |
| **Auth model** | OS process security | OAuth 2.1 / API keys | OAuth 2.0 |
| **Complexity** | Lowest | Moderate | Moderate |
| **Real-time** | Via notifications | Streaming + notifications | SSE streaming |
| **Firewall** | No network needed | Requires HTTP access | Requires HTTP access |
| **Best for** | Desktop apps, dev tools, CLI | Production SaaS, shared services | Legacy compatibility only |

### When to Use Each

**stdio** — Local, single-user scenarios:
- Claude Desktop integration
- VS Code / Cursor extensions
- CLI developer tools
- Personal automation scripts

**Streamable HTTP** — Remote, multi-client scenarios:
- Production SaaS deployments
- Shared team services
- Cloud-hosted MCP servers
- Multi-tenant applications

**HTTP+SSE** — Legacy only:
- Existing deployments that haven't migrated
- Clients that don't yet support Streamable HTTP
- Deprecated in favor of Streamable HTTP

### ⚠️ Critical: stdio Logging

Servers using stdio transport **MUST NOT** write anything to `stdout` except MCP protocol messages. All logging, debug output, and diagnostics MUST go to `stderr`.

Writing non-protocol data to stdout will corrupt the MCP message stream and break the connection.

```python
import sys
print("debug info", file=sys.stderr)
```

```typescript
console.error("debug info");
```

---

## 9. Error Handling Standards

### Principles

1. **Actionable messages** — Tell the agent what went wrong AND what to do about it
2. **Tool-level errors in result objects** — Use `isError: true` in the tool response, not protocol-level JSON-RPC errors
3. **Protocol-level errors for protocol issues** — Reserve JSON-RPC error codes for actual protocol failures
4. **No internal details** — Never expose stack traces, internal paths, or implementation specifics

### Error Message Examples

| ❌ Bad | ✅ Good |
|--------|---------|
| `Error: 404` | `Repository "owner/repo" not found. Verify the owner and repository name are correct.` |
| `Internal server error` | `GitHub API rate limit exceeded. Retry after 60 seconds or authenticate for higher limits.` |
| `NullPointerException at line 42` | `Issue #99 does not exist in repository "owner/repo". Use github_search_issues to find valid issue numbers.` |
| `Invalid input` | `Parameter "state" must be one of: open, closed, all. Received: "pending".` |
| `ECONNREFUSED 127.0.0.1:5432` | `Database connection failed. The service is temporarily unavailable. Retry in a few seconds.` |

### Standard JSON-RPC Error Codes

Use these codes for **protocol-level** errors only:

| Code | Name | When to Use |
|------|------|-------------|
| `-32700` | Parse error | Malformed JSON received |
| `-32600` | Invalid request | Request structure is invalid |
| `-32601` | Method not found | Unknown method name |
| `-32602` | Invalid params | Method params are invalid |
| `-32603` | Internal error | Unexpected server failure |

### Tool Execution Errors

For errors that occur during tool execution (API failures, not-found, validation), return them as tool results with `isError: true`:

```json
{
  "content": [
    {
      "type": "text",
      "text": "Repository \"owner/repo\" not found. Verify the owner and repository name are correct. Use github_search_repos to find valid repository names."
    }
  ],
  "isError": true
}
```

This keeps the MCP protocol healthy while giving the agent actionable error context.

---

## 10. Context Management

LLMs have finite context windows. Every tool description, parameter, and response consumes tokens. Design for minimal context overhead.

### Tool Descriptions
- Keep descriptions concise but complete — avoid redundant phrasing
- Front-load the most important information
- Omit obvious details (don't explain what "search" means)

### Response Data
- **Filter** results to relevant fields — don't return entire API responses
- **Paginate** all list operations (see Section 6)
- **Truncate** oversized responses (see Section 7)
- Return focused data — if the agent asked for issue titles, don't include full issue bodies
- Flatten unnecessary nesting — `{ "author": "alice" }` not `{ "author": { "user": { "profile": { "name": "alice" } } } }`

### Avoid Context Waste
- Don't return metadata the agent will never use (rate limit headers, request IDs, ETags)
- Don't duplicate information across fields
- Don't include null/empty fields unless their absence is meaningful
- Summarize large text fields when the full content isn't requested

---

## 11. API Coverage vs Workflow Tools

### Comprehensive API Coverage

Map individual API operations to MCP tools. Gives agents maximum flexibility to compose operations.

**When to prioritize:**
- The service has a well-structured API with clear operations
- Agents need flexibility to handle unanticipated use cases
- Multiple different workflows use the same underlying operations
- The client supports code execution for composing tool calls

**Examples:** `github_get_issue`, `github_list_issues`, `github_create_issue`, `github_update_issue`, `github_add_label`

### Workflow Tools

Combine multiple API calls into a single high-level operation.

**When to create:**
- A common task requires 3+ API calls in a fixed sequence
- The intermediate results are not useful to the agent
- Error handling across steps is complex
- The workflow has clear, well-defined inputs and outputs

**Examples:** `github_triage_issue` (get issue → analyze → add labels → assign → comment)

### Hybrid Approach (Recommended)

Provide comprehensive API coverage as the foundation, then add workflow tools for common multi-step operations.

```
Foundation (always provide):
  github_get_issue, github_list_issues, github_create_issue,
  github_update_issue, github_add_label, github_create_comment

Convenience (add for common workflows):
  github_triage_issue    → combines get + analyze + label + assign
  github_close_as_dupe   → finds duplicate, links, closes, comments
```

---

## 12. Documentation Requirements

Every MCP server must include clear documentation covering:

### Tool Documentation
- Complete description for every tool (see Section 3)
- All parameters with types, constraints, defaults, and examples
- Response format with sample output
- Error cases and how they're reported

### Working Examples
- Provide **3+ working examples per major feature**
- Show realistic inputs, not toy data
- Include expected outputs
- Cover both success and error cases
- Demonstrate pagination for list operations

### Security Documentation
- Authentication method and setup instructions
- Required permissions and access scopes
- Data handling: what's read, what's stored, what's transmitted
- Rate limits enforced by the server
- Audit logging behavior

### Operational Documentation
- Required environment variables
- Deployment instructions per target (Docker, Cloudflare Workers, etc.)
- Health check and monitoring endpoints
- Performance characteristics and known limitations
- Rate limits from upstream APIs

---

## 13. Testing Requirements

### Functional Testing
- **Valid inputs** — Verify correct responses for all tools
- **Invalid inputs** — Verify proper error messages for missing/wrong/out-of-range params
- **Edge cases** — Empty results, max limits, special characters, Unicode
- **Default values** — Verify defaults apply when optional params are omitted

### Integration Testing
- **API connectivity** — Verify connection to external services
- **Authentication flows** — Test OAuth, API key, and token-based auth
- **Rate limit handling** — Verify graceful behavior when rate-limited
- **Pagination** — Verify multi-page retrieval returns consistent results
- **Data consistency** — Verify created/updated resources reflect changes

### Security Testing
- **Authentication enforcement** — Verify unauthenticated requests are rejected
- **Input sanitization** — Verify injection attempts are handled safely
- **Rate limiting** — Verify server-side rate limits prevent abuse
- **Permission boundaries** — Verify tools respect access scopes
- **Secret handling** — Verify no secrets in logs, errors, or responses

### Performance Testing
- **Load testing** — Verify server handles expected concurrent connections
- **Timeout handling** — Verify long-running operations timeout gracefully
- **Memory usage** — Verify pagination prevents unbounded memory growth
- **Response size** — Verify character limits are enforced

### Error Handling Verification
- **API downtime** — Verify graceful degradation when external APIs are unavailable
- **Malformed responses** — Verify handling of unexpected API response formats
- **Network failures** — Verify retry logic and timeout behavior
- **Partial failures** — Verify handling when some items in a batch operation fail
