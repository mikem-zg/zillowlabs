# TypeScript MCP Server Guide

## Quick Reference

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "my-service-mcp-server",
  version: "1.0.0",
});

server.registerTool("service_get_item", {
  title: "Get Item",
  description: "Retrieve an item by ID.",
  inputSchema: {
    id: z.string().min(1).describe("Item ID"),
  },
  outputSchema: {
    id: z.string(),
    name: z.string(),
    status: z.string(),
  },
  annotations: {
    readOnlyHint: true,
    destructiveHint: false,
    idempotentHint: true,
    openWorldHint: true,
  },
}, async ({ id }) => {
  const item = await fetchItem(id);
  return {
    content: [{ type: "text", text: `# ${item.name}\nStatus: ${item.status}` }],
    structuredContent: { id: item.id, name: item.name, status: item.status },
  };
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

---

## SDK Overview

### Package: `@modelcontextprotocol/sdk`

Version 1.x — stable, production-ready. Provides `McpServer` (high-level) and `Server` (low-level protocol handler).

**Always use `McpServer`** with its registration methods:

| Method | Purpose |
|--------|---------|
| `server.registerTool()` | Register a callable tool |
| `server.registerResource()` | Register a readable resource |
| `server.registerResourceTemplate()` | Register a parameterized resource |
| `server.registerPrompt()` | Register a prompt template |

**NEVER use `server.tool()`, `server.resource()`, or `server.prompt()`** — these are deprecated aliases.

### Transport Packages

| Package | Purpose |
|---------|---------|
| `@modelcontextprotocol/sdk/server/stdio.js` | stdio transport (built-in) |
| `@modelcontextprotocol/sdk/server/streamableHttp.js` | Streamable HTTP transport (built-in) |
| `@modelcontextprotocol/sdk/server/sse.js` | SSE transport (legacy, built-in) |

### Middleware Packages (Optional)

| Package | Purpose |
|---------|---------|
| `@modelcontextprotocol/express` | Express.js middleware for Streamable HTTP |
| `@modelcontextprotocol/hono` | Hono middleware for Streamable HTTP |

---

## Server Naming Convention

Format: `{service}-mcp-server` (lowercase with hyphens)

| Service | Server Name |
|---------|-------------|
| GitHub | `github-mcp-server` |
| Slack | `slack-mcp-server` |
| Stripe | `stripe-mcp-server` |
| Jira | `jira-mcp-server` |

Tool names use underscores with a service prefix: `github_search_issues`, `slack_send_message`.

---

## Project Structure

```
{service}-mcp-server/
├── package.json
├── tsconfig.json
├── README.md
├── src/
│   ├── index.ts           # Main entry point
│   ├── types.ts           # TypeScript interfaces
│   ├── constants.ts       # API_URL, CHARACTER_LIMIT
│   ├── tools/             # Tool implementations
│   │   ├── issues.ts      # Issue-related tools
│   │   └── repos.ts       # Repository-related tools
│   ├── services/          # API clients
│   │   └── api-client.ts  # HTTP client with auth
│   └── schemas/           # Zod schemas
│       ├── common.ts      # Shared schemas (pagination, format)
│       └── issues.ts      # Domain-specific schemas
└── dist/                  # Compiled JS (entry: dist/index.js)
```

---

## Tool Registration with registerTool

### Full Registration Pattern

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({
  name: "github-mcp-server",
  version: "1.0.0",
});

const IssueSchema = z.object({
  id: z.number(),
  title: z.string(),
  state: z.string(),
  body: z.string(),
  assignee: z.string().nullable(),
  labels: z.array(z.string()),
  created_at: z.string(),
  updated_at: z.string(),
  html_url: z.string(),
});

type Issue = z.infer<typeof IssueSchema>;

server.registerTool("github_get_issue", {
  title: "Get GitHub Issue",
  description: `Retrieve a single GitHub issue by number.

Args:
  owner: Repository owner (user or organization)
  repo: Repository name
  issue_number: Issue number (not ID)

Returns:
  Issue object with id, title, state, body, assignee, labels, timestamps, and URL.

Examples:
  - Get issue #42 from octocat/hello-world
  - Retrieve a specific bug report by number

Error Handling:
  - Returns error if issue not found (404)
  - Returns error if repository is private and token lacks access (403)`,
  inputSchema: {
    owner: z.string().min(1).describe("Repository owner (user or org)"),
    repo: z.string().min(1).describe("Repository name"),
    issue_number: z.number().int().positive().describe("Issue number"),
  },
  outputSchema: {
    id: z.number(),
    title: z.string(),
    state: z.string(),
    body: z.string(),
    assignee: z.string().nullable(),
    labels: z.array(z.string()),
    created_at: z.string(),
    updated_at: z.string(),
    html_url: z.string(),
  },
  annotations: {
    readOnlyHint: true,
    destructiveHint: false,
    idempotentHint: true,
    openWorldHint: true,
  },
}, async ({ owner, repo, issue_number }) => {
  const issue = await getIssue(owner, repo, issue_number);
  const markdown = [
    `# #${issue_number}: ${issue.title}`,
    `**State:** ${issue.state}`,
    `**Assignee:** ${issue.assignee ?? "Unassigned"}`,
    `**Labels:** ${issue.labels.join(", ") || "None"}`,
    `**Created:** ${issue.created_at}`,
    "",
    issue.body,
  ].join("\n");

  return {
    content: [{ type: "text", text: markdown }],
    structuredContent: issue,
  };
});
```

### Annotation Reference

| Annotation | Type | Default | Meaning |
|------------|------|---------|---------|
| `readOnlyHint` | boolean | `false` | Tool does NOT modify any state |
| `destructiveHint` | boolean | `true` | Tool may perform destructive operations |
| `idempotentHint` | boolean | `false` | Repeated calls with same args produce same result |
| `openWorldHint` | boolean | `true` | Tool interacts with external systems |

Common patterns:

| Tool Type | readOnly | destructive | idempotent | openWorld |
|-----------|----------|-------------|------------|-----------|
| Search/Get | `true` | `false` | `true` | `true` |
| Create | `false` | `false` | `false` | `true` |
| Update | `false` | `false` | `true` | `true` |
| Delete | `false` | `true` | `true` | `true` |
| List | `true` | `false` | `true` | `true` |

---

## Zod Schemas for Input Validation

### Basic Schemas with Constraints

```typescript
import { z } from "zod";

const SearchSchema = {
  query: z.string().min(1).max(256).describe("Search query string"),
  email: z.string().email().describe("User email address"),
  count: z.number().int().min(1).max(100).describe("Number of results"),
  score: z.number().min(0).max(1).describe("Relevance score threshold"),
  url: z.string().url().describe("Resource URL"),
};
```

### Enums with z.nativeEnum

```typescript
enum IssueState {
  Open = "open",
  Closed = "closed",
  All = "all",
}

const FilterSchema = {
  state: z.nativeEnum(IssueState).default(IssueState.Open)
    .describe("Filter by issue state"),
  sort: z.enum(["created", "updated", "comments"]).default("created")
    .describe("Sort field"),
  direction: z.enum(["asc", "desc"]).default("desc")
    .describe("Sort direction"),
};
```

### Optional Fields with Defaults

```typescript
const ListSchema = {
  owner: z.string().min(1).describe("Repository owner"),
  repo: z.string().min(1).describe("Repository name"),
  state: z.enum(["open", "closed", "all"]).default("open")
    .describe("Filter by state"),
  labels: z.string().optional()
    .describe("Comma-separated label names to filter by"),
  assignee: z.string().optional()
    .describe("Filter by assignee username"),
  limit: z.number().int().min(1).max(100).default(20)
    .describe("Maximum results to return"),
  offset: z.number().int().min(0).default(0)
    .describe("Number of results to skip for pagination"),
};
```

### Strict Schemas

Use `.strict()` on `z.object()` to reject unknown fields. For `registerTool` input schemas (which accept a plain object of Zod types), strict mode is not directly applicable — the SDK validates only declared fields.

When defining reusable schemas as `z.object()`:

```typescript
const CreateIssueInput = z.object({
  owner: z.string().min(1),
  repo: z.string().min(1),
  title: z.string().min(1).max(256),
  body: z.string().optional(),
  labels: z.array(z.string()).optional(),
  assignees: z.array(z.string()).optional(),
}).strict();

type CreateIssueParams = z.infer<typeof CreateIssueInput>;
```

### Using .describe() for Documentation

Every parameter should have a `.describe()` annotation. The description appears in the tool's JSON Schema and helps LLMs understand how to use each parameter.

```typescript
const inputSchema = {
  owner: z.string().min(1)
    .describe("Repository owner — a GitHub username or organization name"),
  repo: z.string().min(1)
    .describe("Repository name (not the full path, just the repo name)"),
  since: z.string().datetime().optional()
    .describe("ISO 8601 timestamp — only return items updated after this date"),
  format: z.enum(["json", "markdown"]).default("markdown")
    .describe("Response format: 'json' for raw data, 'markdown' for human-readable"),
};
```

---

## outputSchema and structuredContent (2025-11-25 Spec)

### Defining Output Schema

`outputSchema` declares the shape of `structuredContent`. Define it alongside the input schema using Zod types. The SDK converts Zod to JSON Schema for the protocol.

```typescript
server.registerTool("github_list_repos", {
  title: "List Repositories",
  description: "List repositories for a user or organization.",
  inputSchema: {
    owner: z.string().min(1).describe("GitHub username or org"),
    limit: z.number().int().min(1).max(100).default(20),
    offset: z.number().int().min(0).default(0),
  },
  outputSchema: {
    total: z.number(),
    count: z.number(),
    has_more: z.boolean(),
    next_offset: z.number(),
    repos: z.array(z.object({
      id: z.number(),
      name: z.string(),
      full_name: z.string(),
      description: z.string().nullable(),
      language: z.string().nullable(),
      stars: z.number(),
      forks: z.number(),
      html_url: z.string(),
    })),
  },
  annotations: { readOnlyHint: true, idempotentHint: true },
}, async ({ owner, limit, offset }) => {
  const result = await listRepos(owner, limit, offset);
  return {
    content: [{ type: "text", text: formatReposMarkdown(result) }],
    structuredContent: result,
  };
});
```

### Backwards Compatibility

Always return **both** `content` and `structuredContent`. Older clients that don't support `outputSchema` will use the `content` array (text). Newer clients use `structuredContent` for typed data.

```typescript
return {
  content: [{ type: "text", text: formatAsMarkdown(data) }],
  structuredContent: data,
};
```

If a tool has no structured output (e.g., a tool that returns only a status message), omit `outputSchema` and `structuredContent`:

```typescript
server.registerTool("github_star_repo", {
  title: "Star Repository",
  description: "Star a GitHub repository.",
  inputSchema: {
    owner: z.string().min(1),
    repo: z.string().min(1),
  },
  annotations: { readOnlyHint: false, destructiveHint: false, idempotentHint: true },
}, async ({ owner, repo }) => {
  await starRepo(owner, repo);
  return {
    content: [{ type: "text", text: `Starred ${owner}/${repo}` }],
  };
});
```

---

## Response Format Options

### ResponseFormat Enum

```typescript
enum ResponseFormat {
  JSON = "json",
  Markdown = "markdown",
}
```

Add a `format` parameter to tools that return data:

```typescript
server.registerTool("github_search_issues", {
  title: "Search Issues",
  description: "Search GitHub issues across repositories.",
  inputSchema: {
    query: z.string().min(1).describe("Search query"),
    format: z.enum(["json", "markdown"]).default("markdown")
      .describe("Response format: 'json' for raw data, 'markdown' for readable output"),
  },
  outputSchema: {
    total: z.number(),
    issues: z.array(z.object({
      id: z.number(),
      number: z.number(),
      title: z.string(),
      state: z.string(),
      repository: z.string(),
    })),
  },
  annotations: { readOnlyHint: true, idempotentHint: true },
}, async ({ query, format }) => {
  const result = await searchIssues(query);

  const text = format === "json"
    ? JSON.stringify(result, null, 2)
    : formatIssuesMarkdown(result);

  return {
    content: [{ type: "text", text }],
    structuredContent: result,
  };
});
```

### Markdown Formatting Guidelines

```typescript
function formatIssuesMarkdown(data: SearchResult): string {
  const lines: string[] = [];
  lines.push(`# Search Results (${data.total} total)`);
  lines.push("");

  for (const issue of data.issues) {
    lines.push(`## ${issue.title} (#${issue.number})`);
    lines.push(`- **State:** ${issue.state}`);
    lines.push(`- **Repository:** ${issue.repository}`);
    lines.push(`- **ID:** ${issue.id}`);
    lines.push("");
  }

  if (data.has_more) {
    lines.push(`_Showing ${data.count} of ${data.total}. Use offset=${data.next_offset} for more._`);
  }

  return lines.join("\n");
}
```

Key Markdown rules:
- Use `#` headers for sections, `##` for items
- Display names with IDs: `Repository Name (repo-id-123)`
- Use bold for labels: `**State:** open`
- Use lists for attributes
- Include pagination info at the bottom

### JSON Formatting Guidelines

- Return complete data objects with all fields
- Use consistent field names across tools (`created_at`, not sometimes `createdAt`)
- Use `null` for missing values, not empty strings
- Include IDs for all entities
- Use ISO 8601 for timestamps

---

## Pagination Implementation

### Pagination Schema Pattern

```typescript
const PaginationInputSchema = {
  limit: z.number().int().min(1).max(100).default(20)
    .describe("Maximum number of results to return (1-100)"),
  offset: z.number().int().min(0).default(0)
    .describe("Number of results to skip for pagination"),
};

const PaginationOutputSchema = {
  total: z.number().describe("Total number of matching results"),
  count: z.number().describe("Number of results in this page"),
  has_more: z.boolean().describe("Whether more results are available"),
  next_offset: z.number().describe("Offset value for the next page"),
};
```

### Character Limit Enforcement

```typescript
const CHARACTER_LIMIT = 25_000;

function truncateContent(text: string): string {
  if (text.length <= CHARACTER_LIMIT) return text;
  return text.slice(0, CHARACTER_LIMIT) + "\n\n...[truncated — use pagination to retrieve more results]";
}
```

### Complete Paginated Tool

```typescript
server.registerTool("github_list_issues", {
  title: "List GitHub Issues",
  description: "List issues in a repository with pagination.",
  inputSchema: {
    owner: z.string().min(1).describe("Repository owner"),
    repo: z.string().min(1).describe("Repository name"),
    state: z.enum(["open", "closed", "all"]).default("open"),
    limit: z.number().int().min(1).max(100).default(20),
    offset: z.number().int().min(0).default(0),
    format: z.enum(["json", "markdown"]).default("markdown"),
  },
  outputSchema: {
    total: z.number(),
    count: z.number(),
    has_more: z.boolean(),
    next_offset: z.number(),
    issues: z.array(z.object({
      id: z.number(),
      number: z.number(),
      title: z.string(),
      state: z.string(),
    })),
  },
  annotations: { readOnlyHint: true, idempotentHint: true },
}, async ({ owner, repo, state, limit, offset, format }) => {
  const allIssues = await fetchIssues(owner, repo, state);
  const total = allIssues.length;
  const paged = allIssues.slice(offset, offset + limit);
  const count = paged.length;
  const has_more = offset + limit < total;
  const next_offset = offset + limit;

  const result = { total, count, has_more, next_offset, issues: paged };

  const text = format === "json"
    ? JSON.stringify(result, null, 2)
    : formatIssuesMarkdown(result);

  return {
    content: [{ type: "text", text: truncateContent(text) }],
    structuredContent: result,
  };
});
```

---

## Error Handling

### handleApiError Function

```typescript
import axios, { AxiosError } from "axios";

interface ApiErrorData {
  message?: string;
  documentation_url?: string;
}

function handleApiError(error: unknown): { content: Array<{ type: "text"; text: string }>; isError: true } {
  if (error instanceof AxiosError) {
    const status = error.response?.status;
    const data = error.response?.data as ApiErrorData | undefined;
    const message = data?.message ?? error.message;

    const statusMessages: Record<number, string> = {
      400: `Bad Request: ${message}. Check the input parameters and try again.`,
      401: `Unauthorized: ${message}. The API token may be invalid or expired. Set a valid token in the GITHUB_TOKEN environment variable.`,
      403: `Forbidden: ${message}. The token may lack required permissions, or a rate limit was exceeded. Check X-RateLimit-Remaining headers.`,
      404: `Not Found: ${message}. Verify the owner, repo, and resource identifiers are correct.`,
      409: `Conflict: ${message}. The resource may already exist or be in a conflicting state.`,
      422: `Validation Error: ${message}. One or more input parameters failed server-side validation.`,
      429: `Rate Limited: ${message}. Too many requests. Wait before retrying. Check the Retry-After header.`,
    };

    const text = status && statusMessages[status]
      ? statusMessages[status]
      : `API Error (${status ?? "unknown"}): ${message}`;

    return { content: [{ type: "text", text }], isError: true };
  }

  if (error instanceof Error && error.message.includes("timeout")) {
    return {
      content: [{ type: "text", text: `Request timed out. The API may be slow or unreachable. Try again later.` }],
      isError: true,
    };
  }

  const fallback = error instanceof Error ? error.message : String(error);
  return {
    content: [{ type: "text", text: `Unexpected error: ${fallback}` }],
    isError: true,
  };
}
```

### Using isError in Tool Handlers

```typescript
server.registerTool("github_get_issue", {
  title: "Get GitHub Issue",
  description: "Retrieve a single issue by number.",
  inputSchema: {
    owner: z.string().min(1),
    repo: z.string().min(1),
    issue_number: z.number().int().positive(),
  },
  annotations: { readOnlyHint: true, idempotentHint: true },
}, async ({ owner, repo, issue_number }) => {
  try {
    const issue = await getIssue(owner, repo, issue_number);
    return {
      content: [{ type: "text", text: formatIssueMarkdown(issue) }],
      structuredContent: issue,
    };
  } catch (error) {
    return handleApiError(error);
  }
});
```

---

## Shared Utilities

### makeApiRequest Generic Function

```typescript
import axios, { AxiosInstance, AxiosRequestConfig } from "axios";

const API_URL = process.env.API_URL ?? "https://api.github.com";
const API_TOKEN = process.env.GITHUB_TOKEN;
const REQUEST_TIMEOUT_MS = 30_000;
const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 1_000;

const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  timeout: REQUEST_TIMEOUT_MS,
  headers: {
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    ...(API_TOKEN ? { "Authorization": `Bearer ${API_TOKEN}` } : {}),
  },
});

async function makeApiRequest<T>(
  method: "GET" | "POST" | "PUT" | "PATCH" | "DELETE",
  path: string,
  data?: unknown,
  config?: AxiosRequestConfig,
): Promise<T> {
  let lastError: unknown;

  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    try {
      const response = await apiClient.request<T>({
        method,
        url: path,
        data,
        ...config,
      });
      return response.data;
    } catch (error) {
      lastError = error;
      if (error instanceof AxiosError) {
        const status = error.response?.status;
        if (status && status >= 400 && status < 500 && status !== 429) {
          throw error;
        }
      }
      if (attempt < MAX_RETRIES - 1) {
        await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS * (attempt + 1)));
      }
    }
  }

  throw lastError;
}
```

### Usage in Tools

```typescript
interface GitHubIssue {
  id: number;
  number: number;
  title: string;
  state: string;
  body: string | null;
  assignee: { login: string } | null;
  labels: Array<{ name: string }>;
  created_at: string;
  updated_at: string;
  html_url: string;
}

async function getIssue(owner: string, repo: string, issueNumber: number) {
  const raw = await makeApiRequest<GitHubIssue>("GET", `/repos/${owner}/${repo}/issues/${issueNumber}`);
  return {
    id: raw.id,
    number: raw.number,
    title: raw.title,
    state: raw.state,
    body: raw.body ?? "",
    assignee: raw.assignee?.login ?? null,
    labels: raw.labels.map((l) => l.name),
    created_at: raw.created_at,
    updated_at: raw.updated_at,
    html_url: raw.html_url,
  };
}
```

---

## Transport Setup

### stdio Transport (Local Servers)

Used with Claude Desktop, VS Code, and other local MCP hosts.

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "github-mcp-server",
  version: "1.0.0",
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

**Important:** In stdio mode, `stdout` is reserved for the MCP protocol. All logging must go to `stderr`:

```typescript
console.error("[INFO] Server started");
```

### Streamable HTTP Transport with Express

```typescript
import express from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { randomUUID } from "node:crypto";

const app = express();
app.use(express.json());

const server = new McpServer({
  name: "github-mcp-server",
  version: "1.0.0",
});

const transports = new Map<string, StreamableHTTPServerTransport>();

app.post("/mcp", async (req, res) => {
  const sessionId = req.headers["mcp-session-id"] as string | undefined;

  if (sessionId && transports.has(sessionId)) {
    const transport = transports.get(sessionId)!;
    await transport.handleRequest(req, res);
    return;
  }

  const transport = new StreamableHTTPServerTransport({
    sessionId: randomUUID(),
    onsessioninitialized: (id) => {
      transports.set(id, transport);
    },
  });

  transport.onclose = () => {
    if (transport.sessionId) {
      transports.delete(transport.sessionId);
    }
  };

  await server.connect(transport);
  await transport.handleRequest(req, res);
});

app.get("/mcp", async (req, res) => {
  const sessionId = req.headers["mcp-session-id"] as string;
  const transport = transports.get(sessionId);
  if (!transport) {
    res.status(400).json({ error: "No active session" });
    return;
  }
  await transport.handleRequest(req, res);
});

app.delete("/mcp", async (req, res) => {
  const sessionId = req.headers["mcp-session-id"] as string;
  const transport = transports.get(sessionId);
  if (transport) {
    await transport.close();
    transports.delete(sessionId);
  }
  res.status(200).end();
});

app.listen(3000, "127.0.0.1", () => {
  console.error("[INFO] MCP server listening on http://127.0.0.1:3000/mcp");
});
```

### Environment-Based Transport Selection

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "github-mcp-server",
  version: "1.0.0",
});

async function main() {
  const transportType = process.env.MCP_TRANSPORT ?? "stdio";

  if (transportType === "stdio") {
    const transport = new StdioServerTransport();
    await server.connect(transport);
  } else if (transportType === "http") {
    const { default: express } = await import("express");
    const { StreamableHTTPServerTransport } = await import(
      "@modelcontextprotocol/sdk/server/streamableHttp.js"
    );
    const { randomUUID } = await import("node:crypto");

    const app = express();
    app.use(express.json());

    const transports = new Map<string, InstanceType<typeof StreamableHTTPServerTransport>>();

    app.post("/mcp", async (req, res) => {
      const sessionId = req.headers["mcp-session-id"] as string | undefined;
      if (sessionId && transports.has(sessionId)) {
        await transports.get(sessionId)!.handleRequest(req, res);
        return;
      }
      const transport = new StreamableHTTPServerTransport({
        sessionId: randomUUID(),
        onsessioninitialized: (id) => transports.set(id, transport),
      });
      transport.onclose = () => {
        if (transport.sessionId) transports.delete(transport.sessionId);
      };
      await server.connect(transport);
      await transport.handleRequest(req, res);
    });

    const port = parseInt(process.env.MCP_PORT ?? "3000", 10);
    app.listen(port, "127.0.0.1", () => {
      console.error(`[INFO] MCP HTTP server on http://127.0.0.1:${port}/mcp`);
    });
  }
}

main().catch((err) => {
  console.error("[FATAL]", err);
  process.exit(1);
});
```

---

## Complete Working Example

### src/index.ts

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import axios, { AxiosError, AxiosInstance } from "axios";

const API_URL = "https://api.github.com";
const API_TOKEN = process.env.GITHUB_TOKEN;
const CHARACTER_LIMIT = 25_000;

const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 30_000,
  headers: {
    Accept: "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    ...(API_TOKEN ? { Authorization: `Bearer ${API_TOKEN}` } : {}),
  },
});

async function makeApiRequest<T>(method: string, path: string, params?: Record<string, unknown>): Promise<T> {
  const response = await apiClient.request<T>({ method, url: path, params });
  return response.data;
}

function handleApiError(error: unknown) {
  if (error instanceof AxiosError) {
    const status = error.response?.status;
    const message = (error.response?.data as { message?: string })?.message ?? error.message;
    const statusMap: Record<number, string> = {
      401: `Unauthorized: ${message}. Check GITHUB_TOKEN.`,
      403: `Forbidden: ${message}. Token may lack permissions or rate limit exceeded.`,
      404: `Not Found: ${message}. Verify owner/repo/resource names.`,
      422: `Validation Error: ${message}. Check input parameters.`,
      429: `Rate Limited. Wait and retry.`,
    };
    const text = (status && statusMap[status]) ?? `API Error (${status}): ${message}`;
    return { content: [{ type: "text" as const, text }], isError: true as const };
  }
  const msg = error instanceof Error ? error.message : String(error);
  return { content: [{ type: "text" as const, text: `Error: ${msg}` }], isError: true as const };
}

function truncate(text: string): string {
  if (text.length <= CHARACTER_LIMIT) return text;
  return text.slice(0, CHARACTER_LIMIT) + "\n\n...[truncated]";
}

const server = new McpServer({
  name: "github-mcp-server",
  version: "1.0.0",
});

server.registerTool("github_get_repo", {
  title: "Get Repository",
  description: `Retrieve metadata for a GitHub repository.

Args:
  owner: Repository owner (user or organization)
  repo: Repository name

Returns:
  Repository metadata including name, description, language, stars, forks, and URL.`,
  inputSchema: {
    owner: z.string().min(1).describe("Repository owner"),
    repo: z.string().min(1).describe("Repository name"),
  },
  outputSchema: {
    id: z.number(),
    name: z.string(),
    full_name: z.string(),
    description: z.string().nullable(),
    language: z.string().nullable(),
    stars: z.number(),
    forks: z.number(),
    open_issues: z.number(),
    default_branch: z.string(),
    html_url: z.string(),
  },
  annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: true },
}, async ({ owner, repo }) => {
  try {
    const raw = await makeApiRequest<{
      id: number; name: string; full_name: string;
      description: string | null; language: string | null;
      stargazers_count: number; forks_count: number;
      open_issues_count: number; default_branch: string; html_url: string;
    }>("GET", `/repos/${owner}/${repo}`);

    const result = {
      id: raw.id,
      name: raw.name,
      full_name: raw.full_name,
      description: raw.description,
      language: raw.language,
      stars: raw.stargazers_count,
      forks: raw.forks_count,
      open_issues: raw.open_issues_count,
      default_branch: raw.default_branch,
      html_url: raw.html_url,
    };

    const md = [
      `# ${result.full_name}`,
      result.description ?? "_No description_",
      "",
      `- **Language:** ${result.language ?? "N/A"}`,
      `- **Stars:** ${result.stars}`,
      `- **Forks:** ${result.forks}`,
      `- **Open Issues:** ${result.open_issues}`,
      `- **Default Branch:** ${result.default_branch}`,
      `- **URL:** ${result.html_url}`,
    ].join("\n");

    return { content: [{ type: "text", text: md }], structuredContent: result };
  } catch (error) {
    return handleApiError(error);
  }
});

server.registerTool("github_list_issues", {
  title: "List Repository Issues",
  description: `List issues in a GitHub repository with pagination and filtering.

Args:
  owner: Repository owner
  repo: Repository name
  state: Filter by state (open, closed, all). Default: open
  limit: Max results per page (1-100). Default: 20
  offset: Skip N results for pagination. Default: 0
  format: Response format (json, markdown). Default: markdown

Returns:
  Paginated list of issues with total count and pagination metadata.`,
  inputSchema: {
    owner: z.string().min(1).describe("Repository owner"),
    repo: z.string().min(1).describe("Repository name"),
    state: z.enum(["open", "closed", "all"]).default("open").describe("Issue state filter"),
    limit: z.number().int().min(1).max(100).default(20).describe("Max results"),
    offset: z.number().int().min(0).default(0).describe("Pagination offset"),
    format: z.enum(["json", "markdown"]).default("markdown").describe("Response format"),
  },
  outputSchema: {
    total: z.number(),
    count: z.number(),
    has_more: z.boolean(),
    next_offset: z.number(),
    issues: z.array(z.object({
      id: z.number(),
      number: z.number(),
      title: z.string(),
      state: z.string(),
      assignee: z.string().nullable(),
      labels: z.array(z.string()),
      created_at: z.string(),
    })),
  },
  annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: true },
}, async ({ owner, repo, state, limit, offset, format }) => {
  try {
    const perPage = 100;
    const page = Math.floor(offset / perPage) + 1;
    const raw = await makeApiRequest<Array<{
      id: number; number: number; title: string; state: string;
      assignee: { login: string } | null;
      labels: Array<{ name: string }>;
      created_at: string;
    }>>("GET", `/repos/${owner}/${repo}/issues`, { state, per_page: perPage, page });

    const issues = raw.map((i) => ({
      id: i.id,
      number: i.number,
      title: i.title,
      state: i.state,
      assignee: i.assignee?.login ?? null,
      labels: i.labels.map((l) => l.name),
      created_at: i.created_at,
    }));

    const sliced = issues.slice(offset % perPage, (offset % perPage) + limit);
    const total = raw.length;
    const count = sliced.length;
    const has_more = offset + limit < total;
    const next_offset = offset + limit;

    const result = { total, count, has_more, next_offset, issues: sliced };

    let text: string;
    if (format === "json") {
      text = JSON.stringify(result, null, 2);
    } else {
      const lines = [`# Issues for ${owner}/${repo} (${total} total)`, ""];
      for (const issue of sliced) {
        lines.push(`## #${issue.number}: ${issue.title}`);
        lines.push(`- **State:** ${issue.state}`);
        lines.push(`- **Assignee:** ${issue.assignee ?? "Unassigned"}`);
        lines.push(`- **Labels:** ${issue.labels.join(", ") || "None"}`);
        lines.push(`- **Created:** ${issue.created_at}`);
        lines.push("");
      }
      if (has_more) {
        lines.push(`_Showing ${count} of ${total}. Use offset=${next_offset} for more._`);
      }
      text = lines.join("\n");
    }

    return { content: [{ type: "text", text: truncate(text) }], structuredContent: result };
  } catch (error) {
    return handleApiError(error);
  }
});

server.registerTool("github_create_issue", {
  title: "Create GitHub Issue",
  description: `Create a new issue in a GitHub repository.

Args:
  owner: Repository owner
  repo: Repository name
  title: Issue title
  body: Issue body (optional, Markdown supported)
  labels: Array of label names (optional)
  assignees: Array of usernames to assign (optional)

Returns:
  The created issue with its number and URL.`,
  inputSchema: {
    owner: z.string().min(1).describe("Repository owner"),
    repo: z.string().min(1).describe("Repository name"),
    title: z.string().min(1).max(256).describe("Issue title"),
    body: z.string().optional().describe("Issue body in Markdown"),
    labels: z.array(z.string()).optional().describe("Label names"),
    assignees: z.array(z.string()).optional().describe("Assignee usernames"),
  },
  outputSchema: {
    id: z.number(),
    number: z.number(),
    title: z.string(),
    html_url: z.string(),
  },
  annotations: { readOnlyHint: false, destructiveHint: false, idempotentHint: false, openWorldHint: true },
}, async ({ owner, repo, title, body, labels, assignees }) => {
  try {
    const raw = await makeApiRequest<{
      id: number; number: number; title: string; html_url: string;
    }>("POST", `/repos/${owner}/${repo}/issues`);

    const result = { id: raw.id, number: raw.number, title: raw.title, html_url: raw.html_url };
    return {
      content: [{ type: "text", text: `Created issue #${result.number}: ${result.title}\n${result.html_url}` }],
      structuredContent: result,
    };
  } catch (error) {
    return handleApiError(error);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("[INFO] github-mcp-server started on stdio");
}

main().catch((err) => {
  console.error("[FATAL]", err);
  process.exit(1);
});
```

### package.json

```json
{
  "name": "github-mcp-server",
  "version": "1.0.0",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx src/index.ts",
    "inspect": "npx @modelcontextprotocol/inspector node dist/index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.12.0",
    "axios": "^1.7.0",
    "zod": "^3.24.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "tsx": "^4.19.0",
    "typescript": "^5.7.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Build and Run

```bash
npm install
npm run build
npm start

# Development with hot reload
npm run dev

# Interactive testing
npm run inspect

# With environment variables
GITHUB_TOKEN=ghp_xxx npm start

# HTTP transport
MCP_TRANSPORT=http MCP_PORT=3000 npm start
```

### Claude Desktop Configuration

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["/path/to/github-mcp-server/dist/index.js"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```
