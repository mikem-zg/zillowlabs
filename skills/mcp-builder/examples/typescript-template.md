# TypeScript MCP Server Template

Copy-paste template for building a production-ready MCP server. Replace `example` with your service name throughout.

---

## Project Setup

```bash
mkdir example-mcp-server && cd example-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk zod axios
npm install -D @types/node typescript tsx
```

---

## File: `package.json`

```json
{
  "name": "example-mcp-server",
  "version": "1.0.0",
  "description": "MCP server for the Example API",
  "type": "module",
  "bin": {
    "example-mcp-server": "dist/index.js"
  },
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx watch src/index.ts"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.6.1",
    "zod": "^3.23.8",
    "axios": "^1.7.9"
  },
  "devDependencies": {
    "@types/node": "^22.10.0",
    "tsx": "^4.19.2",
    "typescript": "^5.7.2"
  }
}
```

---

## File: `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./dist",
    "rootDir": "./src",
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

---

## File: `src/constants.ts`

```typescript
export const API_BASE_URL = process.env.EXAMPLE_API_URL ?? "https://api.example.com/v1";
export const CHARACTER_LIMIT = 25_000;
export const DEFAULT_LIMIT = 20;
export const MAX_LIMIT = 100;
```

---

## File: `src/types.ts`

```typescript
export enum ResponseFormat {
  MARKDOWN = "markdown",
  JSON = "json",
}

export interface PaginatedResponse<T> {
  total: number;
  count: number;
  has_more: boolean;
  next_offset: number;
  items: T[];
}

export interface ApiError {
  status: number;
  message: string;
  details?: string;
}
```

---

## File: `src/services/api-client.ts`

```typescript
import axios, { AxiosError, AxiosInstance, AxiosRequestConfig } from "axios";
import { API_BASE_URL } from "../constants.js";

const API_TOKEN = process.env.EXAMPLE_API_TOKEN;
const REQUEST_TIMEOUT_MS = 30_000;
const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 1_000;

const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: REQUEST_TIMEOUT_MS,
  headers: {
    "Accept": "application/json",
    "Content-Type": "application/json",
    ...(API_TOKEN ? { "Authorization": `Bearer ${API_TOKEN}` } : {}),
  },
});

export async function makeApiRequest<T>(
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

interface ApiErrorData {
  message?: string;
}

export function handleApiError(error: unknown): { content: Array<{ type: "text"; text: string }>; isError: true } {
  if (error instanceof AxiosError) {
    const status = error.response?.status;
    const data = error.response?.data as ApiErrorData | undefined;
    const message = data?.message ?? error.message;

    const statusMessages: Record<number, string> = {
      400: `Bad Request: ${message}. Check the input parameters and try again.`,
      401: `Unauthorized: ${message}. The API token may be invalid or expired. Set a valid token in the EXAMPLE_API_TOKEN environment variable.`,
      403: `Forbidden: ${message}. The token may lack required permissions or a rate limit was exceeded.`,
      404: `Not Found: ${message}. Verify the resource identifiers are correct.`,
      409: `Conflict: ${message}. The resource may already exist or be in a conflicting state.`,
      422: `Validation Error: ${message}. One or more input parameters failed server-side validation.`,
      429: `Rate Limited: ${message}. Too many requests. Wait before retrying.`,
    };

    const text = status && statusMessages[status]
      ? statusMessages[status]
      : `API Error (${status ?? "unknown"}): ${message}`;

    return { content: [{ type: "text", text }], isError: true };
  }

  if (error instanceof Error && error.message.includes("timeout")) {
    return {
      content: [{ type: "text", text: "Request timed out. The API may be slow or unreachable. Try again later." }],
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

---

## File: `src/schemas/common.ts`

```typescript
import { z } from "zod";

export const PaginationSchema = {
  limit: z.number().int().min(1).max(100).default(20)
    .describe("Maximum number of results to return (1-100)"),
  offset: z.number().int().min(0).default(0)
    .describe("Number of results to skip for pagination"),
};

export const ResponseFormatSchema = z.enum(["json", "markdown"]).default("markdown")
  .describe("Response format: 'json' for raw data, 'markdown' for human-readable output");

export const PaginationOutputSchema = {
  total: z.number().describe("Total number of matching results"),
  count: z.number().describe("Number of results in this page"),
  has_more: z.boolean().describe("Whether more results are available"),
  next_offset: z.number().describe("Offset value for the next page"),
};
```

---

## File: `src/tools/users.ts`

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { makeApiRequest, handleApiError } from "../services/api-client.js";
import { PaginationSchema, ResponseFormatSchema, PaginationOutputSchema } from "../schemas/common.js";
import { CHARACTER_LIMIT } from "../constants.js";

interface ExampleUser {
  id: string;
  username: string;
  email: string;
  display_name: string;
  role: string;
  created_at: string;
}

function truncateContent(text: string): string {
  if (text.length <= CHARACTER_LIMIT) return text;
  return text.slice(0, CHARACTER_LIMIT) + "\n\n...[truncated — use pagination to retrieve more results]";
}

export function registerUserTools(server: McpServer) {
  server.registerTool("example_search_users", {
    title: "Search Users",
    description: `Search for users in the Example service by query string.

Args:
  query: Search query — matches against username, email, and display name
  role: Filter by user role (admin, member, viewer). Optional
  limit: Max results per page (1-100). Default: 20
  offset: Skip N results for pagination. Default: 0
  format: Response format (json, markdown). Default: markdown

Returns:
  Paginated list of users matching the query with total count and pagination metadata.

Examples:
  - Search for users named "john"
  - Find all admin users
  - List users with offset for pagination

Error Handling:
  - Returns error if query is empty
  - Returns error if API token is invalid (401)`,
    inputSchema: {
      query: z.string().min(1).max(256).describe("Search query — matches username, email, and display name"),
      role: z.enum(["admin", "member", "viewer"]).optional()
        .describe("Filter by user role"),
      ...PaginationSchema,
      format: ResponseFormatSchema,
    },
    outputSchema: {
      ...PaginationOutputSchema,
      users: z.array(z.object({
        id: z.string(),
        username: z.string(),
        email: z.string(),
        display_name: z.string(),
        role: z.string(),
        created_at: z.string(),
      })),
    },
    annotations: {
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: true,
    },
  }, async ({ query, role, limit, offset, format }) => {
    try {
      const params: Record<string, unknown> = { q: query, limit, offset };
      if (role) params.role = role;

      const raw = await makeApiRequest<{ total: number; users: ExampleUser[] }>(
        "GET", "/users/search", undefined, { params },
      );

      const users = raw.users;
      const total = raw.total;
      const count = users.length;
      const has_more = offset + limit < total;
      const next_offset = offset + limit;

      const result = { total, count, has_more, next_offset, users };

      let text: string;
      if (format === "json") {
        text = JSON.stringify(result, null, 2);
      } else {
        const lines = [`# User Search Results (${total} total)`, ""];
        for (const user of users) {
          lines.push(`## ${user.display_name} (@${user.username})`);
          lines.push(`- **ID:** ${user.id}`);
          lines.push(`- **Email:** ${user.email}`);
          lines.push(`- **Role:** ${user.role}`);
          lines.push(`- **Created:** ${user.created_at}`);
          lines.push("");
        }
        if (has_more) {
          lines.push(`_Showing ${count} of ${total}. Use offset=${next_offset} for more._`);
        }
        text = lines.join("\n");
      }

      return {
        content: [{ type: "text", text: truncateContent(text) }],
        structuredContent: result,
      };
    } catch (error) {
      return handleApiError(error);
    }
  });

  server.registerTool("example_get_user", {
    title: "Get User",
    description: `Retrieve a single user by their unique ID.

Args:
  user_id: The unique identifier for the user
  format: Response format (json, markdown). Default: markdown

Returns:
  User object with id, username, email, display_name, role, and created_at.

Error Handling:
  - Returns error if user not found (404)
  - Returns error if API token is invalid (401)`,
    inputSchema: {
      user_id: z.string().min(1).describe("Unique user identifier"),
      format: ResponseFormatSchema,
    },
    outputSchema: {
      id: z.string(),
      username: z.string(),
      email: z.string(),
      display_name: z.string(),
      role: z.string(),
      created_at: z.string(),
    },
    annotations: {
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: true,
    },
  }, async ({ user_id, format }) => {
    try {
      const user = await makeApiRequest<ExampleUser>("GET", `/users/${user_id}`);

      let text: string;
      if (format === "json") {
        text = JSON.stringify(user, null, 2);
      } else {
        text = [
          `# ${user.display_name} (@${user.username})`,
          "",
          `- **ID:** ${user.id}`,
          `- **Email:** ${user.email}`,
          `- **Role:** ${user.role}`,
          `- **Created:** ${user.created_at}`,
        ].join("\n");
      }

      return {
        content: [{ type: "text", text }],
        structuredContent: user,
      };
    } catch (error) {
      return handleApiError(error);
    }
  });
}
```

---

## File: `src/tools/projects.ts`

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { makeApiRequest, handleApiError } from "../services/api-client.js";
import { PaginationSchema, ResponseFormatSchema, PaginationOutputSchema } from "../schemas/common.js";
import { CHARACTER_LIMIT } from "../constants.js";

interface ExampleProject {
  id: string;
  name: string;
  description: string;
  status: string;
  owner_id: string;
  created_at: string;
  updated_at: string;
}

function truncateContent(text: string): string {
  if (text.length <= CHARACTER_LIMIT) return text;
  return text.slice(0, CHARACTER_LIMIT) + "\n\n...[truncated — use pagination to retrieve more results]";
}

export function registerProjectTools(server: McpServer) {
  server.registerTool("example_list_projects", {
    title: "List Projects",
    description: `List projects in the Example service with pagination and optional filtering.

Args:
  status: Filter by project status (active, archived, draft). Optional
  owner_id: Filter by owner user ID. Optional
  limit: Max results per page (1-100). Default: 20
  offset: Skip N results for pagination. Default: 0
  format: Response format (json, markdown). Default: markdown

Returns:
  Paginated list of projects with total count and pagination metadata.

Examples:
  - List all active projects
  - List projects owned by a specific user
  - Paginate through archived projects`,
    inputSchema: {
      status: z.enum(["active", "archived", "draft"]).optional()
        .describe("Filter by project status"),
      owner_id: z.string().optional()
        .describe("Filter by owner user ID"),
      ...PaginationSchema,
      format: ResponseFormatSchema,
    },
    outputSchema: {
      ...PaginationOutputSchema,
      projects: z.array(z.object({
        id: z.string(),
        name: z.string(),
        description: z.string(),
        status: z.string(),
        owner_id: z.string(),
        created_at: z.string(),
        updated_at: z.string(),
      })),
    },
    annotations: {
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: true,
    },
  }, async ({ status, owner_id, limit, offset, format }) => {
    try {
      const params: Record<string, unknown> = { limit, offset };
      if (status) params.status = status;
      if (owner_id) params.owner_id = owner_id;

      const raw = await makeApiRequest<{ total: number; projects: ExampleProject[] }>(
        "GET", "/projects", undefined, { params },
      );

      const projects = raw.projects;
      const total = raw.total;
      const count = projects.length;
      const has_more = offset + limit < total;
      const next_offset = offset + limit;

      const result = { total, count, has_more, next_offset, projects };

      let text: string;
      if (format === "json") {
        text = JSON.stringify(result, null, 2);
      } else {
        const lines = [`# Projects (${total} total)`, ""];
        for (const project of projects) {
          lines.push(`## ${project.name} (${project.id})`);
          lines.push(`- **Status:** ${project.status}`);
          lines.push(`- **Description:** ${project.description}`);
          lines.push(`- **Owner:** ${project.owner_id}`);
          lines.push(`- **Created:** ${project.created_at}`);
          lines.push(`- **Updated:** ${project.updated_at}`);
          lines.push("");
        }
        if (has_more) {
          lines.push(`_Showing ${count} of ${total}. Use offset=${next_offset} for more._`);
        }
        text = lines.join("\n");
      }

      return {
        content: [{ type: "text", text: truncateContent(text) }],
        structuredContent: result,
      };
    } catch (error) {
      return handleApiError(error);
    }
  });

  server.registerTool("example_get_project", {
    title: "Get Project",
    description: `Retrieve a single project by its unique ID.

Args:
  project_id: The unique identifier for the project
  format: Response format (json, markdown). Default: markdown

Returns:
  Project object with id, name, description, status, owner_id, and timestamps.

Error Handling:
  - Returns error if project not found (404)
  - Returns error if API token is invalid (401)`,
    inputSchema: {
      project_id: z.string().min(1).describe("Unique project identifier"),
      format: ResponseFormatSchema,
    },
    outputSchema: {
      id: z.string(),
      name: z.string(),
      description: z.string(),
      status: z.string(),
      owner_id: z.string(),
      created_at: z.string(),
      updated_at: z.string(),
    },
    annotations: {
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: true,
    },
  }, async ({ project_id, format }) => {
    try {
      const project = await makeApiRequest<ExampleProject>("GET", `/projects/${project_id}`);

      let text: string;
      if (format === "json") {
        text = JSON.stringify(project, null, 2);
      } else {
        text = [
          `# ${project.name} (${project.id})`,
          "",
          `- **Status:** ${project.status}`,
          `- **Description:** ${project.description}`,
          `- **Owner:** ${project.owner_id}`,
          `- **Created:** ${project.created_at}`,
          `- **Updated:** ${project.updated_at}`,
        ].join("\n");
      }

      return {
        content: [{ type: "text", text }],
        structuredContent: project,
      };
    } catch (error) {
      return handleApiError(error);
    }
  });
}
```

---

## File: `src/index.ts`

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { registerUserTools } from "./tools/users.js";
import { registerProjectTools } from "./tools/projects.js";

const server = new McpServer({
  name: "example-mcp-server",
  version: "1.0.0",
});

registerUserTools(server);
registerProjectTools(server);

async function startStdio() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("[INFO] example-mcp-server started on stdio");
}

async function startHttp(port: number) {
  const express = await import("express");
  const { StreamableHTTPServerTransport } = await import(
    "@modelcontextprotocol/sdk/server/streamableHttp.js"
  );
  const { randomUUID } = await import("node:crypto");

  const app = express.default();
  app.use(express.default.json());

  const transports = new Map<string, StreamableHTTPServerTransport>();

  app.post("/mcp", async (req, res) => {
    const sessionId = req.headers["mcp-session-id"] as string | undefined;
    let transport: StreamableHTTPServerTransport;

    if (sessionId && transports.has(sessionId)) {
      transport = transports.get(sessionId)!;
    } else if (!sessionId && isInitializeRequest(req.body)) {
      const newSessionId = randomUUID();
      transport = new StreamableHTTPServerTransport({
        sessionIdGenerator: () => newSessionId,
        onsessioninitialized: (id) => {
          transports.set(id, transport);
        },
      });
      transport.onclose = () => {
        transports.delete(newSessionId);
      };
      const mcpServer = new McpServer({
        name: "example-mcp-server",
        version: "1.0.0",
      });
      registerUserTools(mcpServer);
      registerProjectTools(mcpServer);
      await mcpServer.connect(transport);
    } else {
      res.status(400).json({ error: "Bad Request: No valid session or initialize request" });
      return;
    }

    await transport.handleRequest(req, res, req.body);
  });

  app.get("/mcp", async (req, res) => {
    const sessionId = req.headers["mcp-session-id"] as string | undefined;
    if (!sessionId || !transports.has(sessionId)) {
      res.status(400).json({ error: "Bad Request: No valid session" });
      return;
    }
    const transport = transports.get(sessionId)!;
    await transport.handleRequest(req, res);
  });

  app.delete("/mcp", async (req, res) => {
    const sessionId = req.headers["mcp-session-id"] as string | undefined;
    if (!sessionId || !transports.has(sessionId)) {
      res.status(400).json({ error: "Bad Request: No valid session" });
      return;
    }
    const transport = transports.get(sessionId)!;
    await transport.handleRequest(req, res);
  });

  app.listen(port, "127.0.0.1", () => {
    console.error(`[INFO] example-mcp-server HTTP listening on http://127.0.0.1:${port}/mcp`);
  });
}

function isInitializeRequest(body: unknown): boolean {
  if (typeof body === "object" && body !== null && "method" in body) {
    return (body as { method: string }).method === "initialize";
  }
  if (Array.isArray(body)) {
    return body.some((msg) => typeof msg === "object" && msg !== null && msg.method === "initialize");
  }
  return false;
}

const httpPort = process.env.HTTP_PORT ? parseInt(process.env.HTTP_PORT, 10) : undefined;

if (httpPort) {
  startHttp(httpPort).catch((err) => {
    console.error("[FATAL]", err);
    process.exit(1);
  });
} else {
  startStdio().catch((err) => {
    console.error("[FATAL]", err);
    process.exit(1);
  });
}

process.on("SIGINT", async () => {
  console.error("[INFO] Shutting down...");
  await server.close();
  process.exit(0);
});

process.on("SIGTERM", async () => {
  console.error("[INFO] Shutting down...");
  await server.close();
  process.exit(0);
});
```

---

## File: `README.md`

````markdown
# example-mcp-server

MCP server for the Example API — provides tools for searching users and managing projects.

## Installation

```bash
npm install
npm run build
```

## Configuration

Set the following environment variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `EXAMPLE_API_TOKEN` | Yes | API authentication token |
| `EXAMPLE_API_URL` | No | API base URL (default: `https://api.example.com/v1`) |
| `HTTP_PORT` | No | Set to enable HTTP transport (e.g., `3000`) |

## Usage

### stdio mode (Claude Desktop, VS Code)

```bash
node dist/index.js
```

### HTTP mode

```bash
HTTP_PORT=3000 node dist/index.js
```

### Development

```bash
npm run dev
```

### Testing with MCP Inspector

```bash
npx @modelcontextprotocol/inspector node dist/index.js
```

## Claude Desktop Configuration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "example": {
      "command": "node",
      "args": ["/absolute/path/to/example-mcp-server/dist/index.js"],
      "env": {
        "EXAMPLE_API_TOKEN": "your-token-here"
      }
    }
  }
}
```

## Available Tools

| Tool | Description |
|------|-------------|
| `example_search_users` | Search users by query, role, with pagination |
| `example_get_user` | Get a single user by ID |
| `example_list_projects` | List projects with status/owner filtering and pagination |
| `example_get_project` | Get a single project by ID |
````

---

## Build and Run

```bash
npm run build
node dist/index.js                    # stdio mode
HTTP_PORT=3000 node dist/index.js     # HTTP mode
npx @modelcontextprotocol/inspector   # Test with inspector
```

---

## Project Structure

```
example-mcp-server/
├── package.json
├── tsconfig.json
├── README.md
├── src/
│   ├── index.ts              # Server init + transport setup
│   ├── constants.ts          # API URL, limits
│   ├── types.ts              # Enums, interfaces
│   ├── services/
│   │   └── api-client.ts     # HTTP client + error handling
│   ├── schemas/
│   │   └── common.ts         # Reusable Zod schemas
│   └── tools/
│       ├── users.ts          # User search and get tools
│       └── projects.ts       # Project list and get tools
└── dist/                     # Compiled output
```

---

## Customization Checklist

When adapting this template for a new service:

1. **Rename** `example` → `yourservice` in package.json, server name, and all tool name prefixes
2. **Update** `API_BASE_URL` in `constants.ts` to point to your real API
3. **Update** `EXAMPLE_API_TOKEN` → `YOURSERVICE_API_TOKEN` in `api-client.ts`
4. **Replace** the user/project interfaces and tool implementations with your API's domain objects
5. **Add** service-specific headers in `api-client.ts` (e.g., API version headers)
6. **Add** additional tool files under `src/tools/` for each domain area
7. **Update** `src/index.ts` to import and register your new tool modules
