# Security & Deployment Guide for MCP Servers

Production security hardening and deployment patterns for MCP servers. Reflects 2025-11-25 spec best practices.

---

## 1. Authentication & Authorization

### OAuth 2.1 (Remote HTTP Servers)

OAuth 2.1 is the required authentication method for production remote MCP servers. Despite this, only ~8.5% of deployed MCP servers currently use OAuth — most rely on static API keys, which is a significant security risk.

**Authorization Code + PKCE Flow:**

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";

const server = new McpServer({ name: "my-mcp-server", version: "1.0.0" });

const transport = new StreamableHTTPServerTransport({
  oauth: {
    authorizationEndpoint: "https://idp.example.com/authorize",
    tokenEndpoint: "https://idp.example.com/token",
    clientId: process.env.OAUTH_CLIENT_ID!,
    clientSecret: process.env.OAUTH_CLIENT_SECRET!,
    scopes: ["read", "write"],
    pkce: true,
    resourceIndicators: ["https://my-mcp-server.example.com"]
  }
});
```

**Key requirements:**

- Use Authorization Code grant with PKCE (Proof Key for Code Exchange) — never use implicit grant
- Bind tokens to specific servers using Resource Indicators (RFC 8707) so a token issued for Server A cannot be replayed against Server B
- Publish protected resource metadata at `/.well-known/oauth-protected-resource` so clients can discover auth requirements automatically
- Issue short-lived access tokens (5–15 minutes) with refresh tokens for session continuity
- Never use long-lived API keys in production remote deployments

**Protected Resource Metadata Discovery:**

```json
// GET /.well-known/oauth-protected-resource
{
  "resource": "https://my-mcp-server.example.com",
  "authorization_servers": ["https://idp.example.com"],
  "scopes_supported": ["read", "write", "admin"],
  "bearer_methods_supported": ["header"]
}
```

**Integration with Identity Providers:**

Use established IdPs (Auth0, Okta, Azure AD, Google Identity) instead of building custom auth:

```typescript
// Auth0 configuration example
const oauthConfig = {
  authorizationEndpoint: `https://${process.env.AUTH0_DOMAIN}/authorize`,
  tokenEndpoint: `https://${process.env.AUTH0_DOMAIN}/oauth/token`,
  clientId: process.env.AUTH0_CLIENT_ID!,
  audience: "https://my-mcp-server.example.com/api",
  pkce: true
};
```

### API Keys (Simpler Deployments)

For internal or development deployments where OAuth is impractical:

```typescript
const API_KEY = process.env.MCP_API_KEY;
if (!API_KEY || API_KEY.length < 32) {
  console.error("MCP_API_KEY must be set and at least 32 characters");
  process.exit(1);
}

function authenticateRequest(req: Request): boolean {
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return false;
  }
  const token = authHeader.slice(7);
  return timingSafeEqual(Buffer.from(token), Buffer.from(API_KEY));
}
```

Rules:
- Store keys in environment variables or secret managers, never in source code
- Validate key presence and minimum length on server startup — fail fast with a clear error
- Use constant-time comparison to prevent timing attacks
- Return clear, actionable error messages: `{"error": "missing_api_key", "message": "Set MCP_API_KEY environment variable"}`

### stdio (Local Servers)

stdio servers run as child processes of the MCP client and rely on OS-level process security:

- The client spawns the server process — no network exposure
- Pass API keys and credentials to the server via environment variables set by the client
- The client is responsible for securely storing and managing credentials
- Never log credentials to stdout (stdout is the MCP transport channel) — use stderr for all logging

```json
// claude_desktop_config.json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["dist/index.js"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

---

## 2. Input Validation & Injection Prevention

Every parameter received from an MCP client must be validated before use.

### File Path Sanitization

```typescript
import path from "path";

// VULNERABLE — directory traversal
function readFileUnsafe(filePath: string): string {
  return fs.readFileSync(filePath, "utf-8");
}

// SAFE — resolve and validate against allowed root
function readFileSafe(filePath: string, allowedRoot: string): string {
  const resolved = path.resolve(allowedRoot, filePath);
  if (!resolved.startsWith(path.resolve(allowedRoot))) {
    throw new Error(`Path traversal blocked: ${filePath}`);
  }
  return fs.readFileSync(resolved, "utf-8");
}
```

### Command Injection Prevention

```typescript
// VULNERABLE — string concatenation
import { exec } from "child_process";
function runCommandUnsafe(userInput: string) {
  exec(`grep -r "${userInput}" /data`);
}

// SAFE — parameterized API, no shell
import { execFile } from "child_process";
function runCommandSafe(userInput: string) {
  execFile("grep", ["-r", userInput, "/data"]);
}
```

**Never** use string concatenation or template literals to construct shell commands, SQL queries, or file paths from user input. Always use parameterized APIs.

### Schema Validation

Use strict schemas to reject unknown fields and enforce constraints:

**TypeScript (Zod):**
```typescript
const SearchParams = z.object({
  query: z.string().min(1).max(500).describe("Search query text"),
  limit: z.number().int().min(1).max(100).default(20),
  offset: z.number().int().min(0).default(0)
}).strict();
```

**Python (Pydantic):**
```python
class SearchParams(BaseModel):
    model_config = ConfigDict(extra="forbid")
    query: str = Field(..., min_length=1, max_length=500)
    limit: int = Field(default=20, ge=1, le=100)
    offset: int = Field(default=0, ge=0)
```

### Additional Validation Rules

- Validate URLs against an allowlist of schemes (`https://` only) and domains
- Check parameter sizes to prevent memory exhaustion (e.g., max 25,000 character responses)
- Validate external identifiers (IDs, slugs) against expected patterns
- Reject requests with unexpected content types

---

## 3. DNS Rebinding Protection

For MCP servers exposed over HTTP on localhost (development or hybrid setups):

**Bind to `127.0.0.1`, never `0.0.0.0`:**

```typescript
app.listen(3000, "127.0.0.1", () => {
  console.error("MCP server listening on 127.0.0.1:3000");
});
```

**Validate the Origin header:**

```typescript
function validateOrigin(req: Request): boolean {
  const origin = req.headers.get("Origin");
  if (!origin) return true;
  const allowed = ["http://localhost:3000", "http://127.0.0.1:3000"];
  return allowed.includes(origin);
}
```

**Additional protections:**
- Use short-lived session tokens (expire within minutes)
- Return `403 Forbidden` for requests with unexpected `Host` headers
- Never bind local development servers to `0.0.0.0` — a malicious website could exploit DNS rebinding to reach your server through the browser

---

## 4. Rate Limiting

Protect your server and downstream APIs from runaway AI agents that may call tools in tight loops.

```typescript
import { RateLimiter } from "rate-limiter-flexible";

const rateLimiter = new RateLimiter({
  points: 100,
  duration: 60,
  keyPrefix: "mcp-tool"
});

async function handleToolCall(userId: string, toolName: string) {
  try {
    await rateLimiter.consume(`${userId}:${toolName}`);
  } catch (rejRes) {
    const retryAfter = Math.ceil(rejRes.msBeforeNext / 1000);
    return {
      isError: true,
      content: [{
        type: "text",
        text: `Rate limit exceeded. Retry after ${retryAfter} seconds.`
      }],
      _meta: { retryAfter }
    };
  }
}
```

**Rate limiting strategy:**

| Layer | Limit | Purpose |
|-------|-------|---------|
| Per-user per-tool | 100 req/min | Prevent individual abuse |
| Per-user global | 500 req/min | Cap total user activity |
| Per-server global | 5,000 req/min | Protect infrastructure |
| Cost-based | $10/hour per user | Prevent billing runaway |

- Return HTTP `429 Too Many Requests` with `Retry-After` header for HTTP transports
- For stdio, return an `isError: true` result with a clear retry message
- Implement resource quotas (e.g., max 50 file reads per session, max 10MB total data)
- Log rate limit hits to detect runaway agent behavior

---

## 5. Prompt Injection Defense

MCP servers operate in a "confused deputy" threat model: the LLM sits between the user and the server, and malicious content in external data can manipulate LLM behavior.

**Sanitize external data:**

```typescript
function sanitizeForLLM(externalData: string): string {
  const truncated = externalData.slice(0, 25000);
  return truncated
    .replace(/```/g, "\\`\\`\\`")
    .replace(/<\/?script[^>]*>/gi, "[removed]");
}

server.registerTool("read_document", {
  title: "Read Document",
  description: "Reads a document. Content is external and untrusted.",
  inputSchema: { id: z.string().uuid() },
  annotations: { readOnlyHint: true }
}, async ({ id }) => {
  const doc = await fetchDocument(id);
  return {
    content: [{
      type: "text",
      text: `Document content (external, untrusted):\n\n${sanitizeForLLM(doc.body)}`
    }]
  };
});
```

**Defense-in-depth rules:**

- Label all external data as untrusted when returning it to the LLM
- Require human-in-the-loop confirmation for destructive operations (delete, modify, send)
- Set `destructiveHint: true` and `readOnlyHint: false` on mutating tools so clients can prompt for approval
- Treat stored content (database records, files, API responses) as untrusted — it may contain injected instructions
- Never expose internal server state, configuration, or credentials in `structuredContent` or `_meta` fields
- Don't include system prompts, internal tool IDs, or server architecture details in tool responses

---

## 6. Supply Chain Security

### Package Verification

- Verify package names and publishers before installing — typosquatting is common (e.g., `@modeicontextprotocol/sdk` vs `@modelcontextprotocol/sdk`)
- Check npm download counts, GitHub stars, and publisher verification badges
- Use `npm audit` or `pip audit` before deploying

### Dependency Pinning

```json
// package.json — pin exact versions
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "1.12.0",
    "zod": "3.24.0"
  }
}
```

- Always commit lock files (`package-lock.json`, `poetry.lock`, `go.sum`)
- Use `npm ci` (not `npm install`) in CI/CD for reproducible builds
- Pin Docker base images by SHA-256 digest, not tags

```dockerfile
FROM node:22-slim@sha256:a1b2c3d4e5f6... AS runtime
```

### Automated Scanning

- Run SAST (static analysis) tools: Semgrep, CodeQL
- Run SCA (software composition analysis): Snyk, Trivy, Dependabot
- Integrate scanning into CI/CD pipelines — block deploys on critical vulnerabilities
- Verify SHA-256 checksums of downloaded artifacts
- Use PGP signature verification for critical dependencies when available

---

## 7. Deployment Patterns

### Cloudflare Workers (Edge Deployment)

The fastest path from development to production. Runs at 300+ global edge locations.

**Free tier:** 100k requests/day, 10ms CPU time per request, 128MB memory.

```bash
npm create cloudflare@latest -- my-mcp --template=cloudflare/ai/demos/remote-mcp-authless
```

**Limitations:**
- 10ms CPU time per invocation (free tier), 30ms on paid
- 128MB memory limit
- Limited Node.js API surface (no `fs`, `child_process`, `net`)
- Cold starts are minimal (~0ms) compared to other serverless platforms

**Storage options:** KV (key-value), D1 (SQLite), R2 (object storage)

**Built-in features:** OAuth support, rate limiting, WAF, DDoS protection, automatic HTTPS.

```typescript
// wrangler.toml
// name = "my-mcp-server"
// main = "src/index.ts"
// compatibility_date = "2025-01-01"

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const transport = new CloudflareWorkerTransport();
    const server = new McpServer({ name: "my-mcp", version: "1.0.0" });
    return transport.handleRequest(request, server, env);
  }
};
```

### Docker / Kubernetes (Container Deployment)

**Multi-stage Dockerfile:**

```dockerfile
FROM node:22-slim@sha256:a4b5c6... AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY tsconfig.json ./
COPY src/ ./src/
RUN npm run build

FROM node:22-slim@sha256:a4b5c6... AS runtime
RUN addgroup --system mcp && adduser --system --ingroup mcp mcp
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
USER mcp
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]
```

**Health check endpoint:**

```typescript
app.get("/health", (req, res) => {
  res.json({ status: "ok", version: "1.0.0", uptime: process.uptime() });
});
```

**Kubernetes Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mcp-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mcp-server
  template:
    metadata:
      labels:
        app: mcp-server
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
      containers:
        - name: mcp-server
          image: registry.example.com/mcp-server@sha256:abc123...
          ports:
            - containerPort: 3000
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 15
            periodSeconds: 20
          env:
            - name: MCP_API_KEY
              valueFrom:
                secretKeyRef:
                  name: mcp-secrets
                  key: api-key
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - ALL
          volumeMounts:
            - name: tmp
              mountPath: /tmp
      volumes:
        - name: tmp
          emptyDir: {}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mcp-server-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mcp-server
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

**Secrets management:**
- Use Kubernetes Secrets (base64-encoded, not encrypted at rest by default)
- For production: use External Secrets Operator with AWS Secrets Manager, HashiCorp Vault, or Google Secret Manager
- Mount secrets as environment variables, never as command-line arguments (visible in `ps` output)

### Other Platforms

**Vercel Functions:**
- Best for Next.js-based MCP servers
- Built-in OAuth support via Vercel Auth
- Free tier: 100 GB-hours compute
- Pro tier: $20/mo with higher limits
- Automatic HTTPS, edge caching, and preview deployments

**Google Cloud Run:**
- Enterprise-grade with VPC integration
- Auto-scales to zero (pay only for requests)
- Free tier: 2M requests/month
- Integrates with Google Cloud IAM, Secret Manager, Cloud Armor WAF
- Best for organizations already on Google Cloud

**AWS ECS (Elastic Container Service):**
- Full container orchestration with Fargate (serverless) or EC2
- Integrates with CloudWatch (monitoring), Cognito (auth), WAF
- No free tier for ECS itself
- Best for AWS-native organizations with complex infrastructure needs

**Northflank:**
- Quick containerized deployments with multi-cloud support
- Built-in CI/CD, secrets management, and scaling
- Good middle ground between managed serverless and full K8s

---

## 8. Cost Comparison

| Platform | Free Tier | Production (~10k req/day) | Best For |
|----------|-----------|--------------------------|----------|
| **Cloudflare Workers** | 100k req/day | $5–15/mo | Edge-first, low latency |
| **Vercel Functions** | 100 GB-hours | $20/mo | Next.js stacks |
| **Google Cloud Run** | 2M requests/mo | $50–100/mo | Enterprise, VPC |
| **AWS ECS** | None | $100–200/mo | AWS-native orgs |
| **Docker (self-hosted)** | Server cost only | $5–50/mo (VPS) | Full control |
| **Northflank** | Limited | $20–50/mo | Quick container deploys |

---

## 9. Production Checklist

Before going to production, verify every item:

- [ ] **OAuth 2.1 enabled** — Authorization Code + PKCE for all remote HTTP servers
- [ ] **Secrets in vault** — Use a dedicated secrets manager (Vault, AWS SM, GCP SM), not plain environment variables
- [ ] **Input validation on all parameters** — Zod/Pydantic schemas with `.strict()`/`extra='forbid'`
- [ ] **Rate limiting configured** — Per-user, per-tool, and global limits with 429 responses
- [ ] **Running as non-root** — Container runs as unprivileged user with dropped capabilities
- [ ] **Structured logging** — JSON format with correlation IDs and user attribution
- [ ] **Dependency scanning in CI/CD** — SAST and SCA scans block deploys on critical findings
- [ ] **Human-in-the-loop for destructive operations** — Tools with `destructiveHint: true` require approval
- [ ] **Health check endpoint** — `/health` returns status, version, and uptime
- [ ] **HTTPS enforced** — TLS termination at load balancer or edge, no plaintext HTTP
- [ ] **Token passthrough protection** — Server never forwards user tokens to untrusted third parties
- [ ] **Read-only filesystem** — Container filesystem is read-only with explicit writable mounts
- [ ] **Network isolation** — Server has egress rules limiting outbound connections to known APIs
- [ ] **Audit logging** — All tool invocations logged with user identity and outcome

---

## 10. Common Antipatterns and Pitfalls

### 1. No Authentication

**Problem:** Server accepts any request without verifying identity. Anyone who discovers the endpoint can invoke tools.

**Fix:** Implement OAuth 2.1 for remote servers. For stdio, rely on OS process isolation with credentials passed via environment variables.

### 2. Static/Hardcoded Credentials

**Problem:** API keys embedded in source code, committed to version control, or shared across environments.

**Fix:** Use environment variables at minimum, secrets managers (Vault, AWS Secrets Manager) for production. Rotate keys on a schedule. Never commit `.env` files.

### 3. Command Injection from Unsanitized Inputs

**Problem:** User-supplied values concatenated into shell commands, SQL queries, or file paths.

**Fix:** Use parameterized APIs (`execFile` not `exec`, parameterized SQL not string interpolation). Validate all inputs against strict schemas before use.

### 4. Prompt Injection / Confused Deputy

**Problem:** External data (database records, API responses, file contents) contains instructions that manipulate the LLM into calling unintended tools or leaking information.

**Fix:** Label all external data as untrusted. Require human confirmation for destructive actions. Never include sensitive internal state in tool responses.

### 5. Over-Permissioning / Excessive Agency

**Problem:** Server exposes powerful tools (delete database, send emails, deploy code) without access controls or approval gates.

**Fix:** Apply principle of least privilege. Set `destructiveHint: true` on mutating tools. Implement per-user permission scoping. Gate dangerous operations behind human approval.

### 6. Typosquatting / Supply Chain Attacks

**Problem:** Installing a malicious package with a name similar to a legitimate one (e.g., `@modelcontextprotocl/sdk`).

**Fix:** Verify package names, publishers, and download counts. Use lock files. Run `npm audit` / `pip audit`. Pin dependencies to exact versions.

### 7. 1:1 REST API Mapping (Too Many Tools)

**Problem:** Exposing every REST endpoint as a separate tool. LLMs struggle with large tool sets (>20 tools) and waste tokens discovering the right one.

**Fix:** Design workflow-oriented tools that combine multiple API calls. Group related operations. Prioritize the 10–15 most impactful tools.

### 8. Generic Tool Names (Collisions)

**Problem:** Using names like `search`, `create`, `update` that collide with tools from other MCP servers connected to the same client.

**Fix:** Prefix all tool names with the service name: `github_search_issues`, `slack_send_message`, `jira_create_ticket`.

### 9. No Pagination (Overwhelming Context)

**Problem:** Returning thousands of records in a single response, consuming the LLM's entire context window and degrading quality.

**Fix:** Implement pagination with `limit`, `offset`, `has_more`, `next_offset`, and `total_count` in every list operation. Default to 20 items.

### 10. Complex Nested Arguments

**Problem:** Deeply nested input objects that are difficult for LLMs to construct correctly.

**Fix:** Flatten arguments to top-level primitives and enums. Use `dot.notation` field names if grouping is needed. Keep required parameters minimal.

### 11. Human-Focused Error Messages (Not Agent-Actionable)

**Problem:** Returning errors like "Something went wrong" or "Invalid input" without enough detail for the LLM to self-correct.

**Fix:** Return structured errors with the error type, which parameter failed, what was expected, and suggested next steps: `{"error": "validation_error", "field": "limit", "message": "Must be 1-100, got 500", "suggestion": "Retry with limit=100"}`.

### 12. Poor/No Documentation

**Problem:** Tool descriptions are missing, vague, or don't explain when to use vs. not use a tool.

**Fix:** Write tool descriptions that include: what the tool does, when to use it, when NOT to use it, parameter descriptions with examples, and return value documentation.

### 13. No Logging/Observability

**Problem:** No visibility into tool invocations, errors, latency, or user behavior. Impossible to debug issues or detect abuse.

**Fix:** Implement structured JSON logging with correlation IDs, tool name, latency, success/failure, and user identity. Forward logs to a centralized system.

### 14. Missing Rate Limiting

**Problem:** An AI agent enters a tight loop calling the same tool hundreds of times per minute, exhausting API quotas or running up costs.

**Fix:** Implement per-user and per-tool rate limits. Return clear retry-after information. Set cost ceilings per user per hour.

### 15. Running as Root / Privileged Containers

**Problem:** Container runs as root, so any code execution vulnerability gives the attacker full system access.

**Fix:** Run as a non-root user (`USER mcp` in Dockerfile). Drop all Linux capabilities. Use `readOnlyRootFilesystem: true`. Mount only necessary writable volumes.

### 16. No Sandboxing / Network Isolation

**Problem:** Server can make arbitrary outbound network requests, potentially exfiltrating data or accessing internal services.

**Fix:** Use network policies (Kubernetes NetworkPolicy, security groups) to restrict egress to known API endpoints. Run in isolated VPCs. Block access to cloud metadata endpoints (`169.254.169.254`).

### 17. Session IDs in URLs

**Problem:** Session identifiers included in URL paths or query parameters, visible in logs, browser history, and referrer headers.

**Fix:** Transmit session IDs in HTTP headers only (Authorization header or secure cookies). Never include tokens in URLs.

### 18. No Token Passthrough Protection

**Problem:** Server receives a user's OAuth token and forwards it to a third-party service the user didn't authorize.

**Fix:** Use Resource Indicators (RFC 8707) to bind tokens to specific servers. Never forward received tokens to other services. Request separate tokens for each downstream API.

### 19. Inconsistent Tool Naming (Spaces, Dots, Brackets)

**Problem:** Tool names contain spaces, dots, brackets, or mixed casing (`search Issues`, `get.user`, `list[repos]`), causing parsing failures in clients.

**Fix:** Use `snake_case` with service prefix: `github_search_issues`. Only lowercase letters, numbers, and underscores. No spaces, dots, hyphens, or brackets.

### 20. Version Pinning Neglect

**Problem:** Using `latest` tags for Docker images or `^` ranges for npm packages. Builds break silently when upstream publishes breaking changes.

**Fix:** Pin Docker images by SHA-256 digest. Pin npm packages to exact versions. Use lock files. Update dependencies deliberately with testing, not automatically in production.

---

## 11. Observability

### Structured Logging

Use JSON-formatted logs for machine parseability:

```typescript
import { randomUUID } from "crypto";

interface LogEntry {
  timestamp: string;
  level: "info" | "warn" | "error";
  correlationId: string;
  tool?: string;
  userId?: string;
  duration_ms?: number;
  success?: boolean;
  message: string;
  error?: string;
}

function log(entry: LogEntry) {
  process.stderr.write(JSON.stringify(entry) + "\n");
}

async function executeToolWithLogging(
  toolName: string,
  userId: string,
  handler: () => Promise<unknown>
) {
  const correlationId = randomUUID();
  const start = Date.now();

  log({
    timestamp: new Date().toISOString(),
    level: "info",
    correlationId,
    tool: toolName,
    userId,
    message: `Tool invocation started`
  });

  try {
    const result = await handler();
    log({
      timestamp: new Date().toISOString(),
      level: "info",
      correlationId,
      tool: toolName,
      userId,
      duration_ms: Date.now() - start,
      success: true,
      message: `Tool invocation completed`
    });
    return result;
  } catch (err) {
    log({
      timestamp: new Date().toISOString(),
      level: "error",
      correlationId,
      tool: toolName,
      userId,
      duration_ms: Date.now() - start,
      success: false,
      message: `Tool invocation failed`,
      error: err instanceof Error ? err.message : String(err)
    });
    throw err;
  }
}
```

### Correlation IDs

Assign a unique ID to each request and propagate it through all downstream calls:

```typescript
function createCorrelationMiddleware() {
  return (req: Request, res: Response, next: () => void) => {
    const correlationId = req.headers.get("x-correlation-id") || randomUUID();
    res.headers.set("x-correlation-id", correlationId);
    (req as any).correlationId = correlationId;
    next();
  };
}
```

### What to Log

| Event | Fields | Purpose |
|-------|--------|---------|
| Tool invocation start | `correlationId`, `tool`, `userId`, `timestamp` | Request tracing |
| Tool invocation end | `correlationId`, `tool`, `duration_ms`, `success` | Performance monitoring |
| Auth failure | `correlationId`, `userId`, `reason`, `ip` | Security auditing |
| Rate limit hit | `correlationId`, `userId`, `tool`, `retryAfter` | Abuse detection |
| Validation error | `correlationId`, `tool`, `field`, `value` | Debugging |
| External API call | `correlationId`, `service`, `endpoint`, `duration_ms`, `status` | Dependency monitoring |

### Centralized Monitoring

Forward logs to a centralized platform for alerting and dashboards:

- **Datadog** — Full-stack observability with APM, logs, and metrics
- **Grafana + Loki** — Open-source log aggregation with Grafana dashboards
- **AWS CloudWatch** — Native for AWS deployments
- **Google Cloud Logging** — Native for GCP deployments

### Audit Trails

For compliance and security forensics, maintain an immutable audit log of:

- Every tool invocation with user identity, parameters (redacted if sensitive), and outcome
- Authentication events (login, logout, token refresh, auth failures)
- Configuration changes (tool registration, permission updates)
- Rate limit enforcement actions

Store audit logs separately from application logs with longer retention (90+ days) and restricted access.
