---
name: scaling-audit
description: Conducts a comprehensive scaling and performance audit of a web application codebase. Identifies bottlenecks across memory management, database queries, caching, connection pooling, background jobs, and API design. Use when the user asks for a scaling audit, performance review, load capacity assessment, or bottleneck analysis of their application.
---

# Scaling Audit

Perform a systematic, comprehensive scaling audit of a web application. The output is a structured report with real-world impact analysis for every finding, estimating behavior under load with concrete memory/CPU/latency numbers. DONT BE LAZY I WILL GET FIRED IF THIS GOES DOWN GO OVER EVERY FILE MULTIPLE TIMES IF NEEDED.

## Process

### Phase 1: Reconnaissance (Information Gathering)

Understand the application architecture before auditing. Run these in parallel:

1. **Identify the stack**: Read `package.json`, `requirements.txt`, or equivalent to catalog the runtime, framework, and key dependencies.
2. **Map all endpoints**: Find every route definition, middleware chain, and background job.
3. **Locate data stores**: Find database connections, ORMs, connection pool configs, in-memory caches, and external API integrations.
4. **Find background processing**: Identify cron jobs, `setInterval`, worker threads, job queues, and streaming endpoints (SSE, WebSockets).
5. **Identify caching layers**: Find in-memory caches (NodeCache, Map, Redis), HTTP cache headers, and CDN configuration.

```bash
# Useful reconnaissance commands (adapt to stack)
grep -rn "app\.\(get\|post\|put\|delete\|patch\|use\)" server/ --include="*.ts" --include="*.js"
grep -rn "setInterval\|setTimeout\|cron\|schedule" server/ --include="*.ts"
grep -rn "new Map\|new Set\|NodeCache\|lru-cache\|redis" server/ --include="*.ts"
grep -rn "pool\|max.*connection\|connectionLimit\|poolSize" server/ --include="*.ts"
grep -rn "db\.select\|db\.query\|\.findMany\|\.find(" server/ --include="*.ts"
grep -rn "JSON\.stringify\|JSON\.parse" server/ --include="*.ts" | head -30
```

### Phase 2: Systematic Audit

Audit each category from the checklist in `reference/checklist.md`. For each category:

1. Read all relevant files identified in Phase 1
2. Trace data flow from request to response, estimating memory and CPU at each step
3. Calculate worst-case resource usage under target concurrency (e.g., 1,000 concurrent users)
4. Check against the bottleneck patterns in the checklist
5. Document every finding immediately — do not batch

### Phase 3: Resource Estimation

For each finding, calculate:
- **Per-request memory**: How much memory does one request allocate?
- **Concurrent impact**: Multiply by target concurrency — does it exceed available RAM?
- **Latency contribution**: How much time does this operation add to response time?
- **Throughput limit**: At what request rate does this become a bottleneck?

### Phase 4: Report Generation

Write `SCALING_AUDIT.md` using the output format below.

## Output Format

```markdown
# Scaling Audit Report — [Application Name]

**Date:** [date]
**Scope:** [what was audited]
**Target:** [scaling goal, e.g., "Support 5,000 concurrent users with sub-second response times"]

---

## Executive Summary

[2-3 sentences on overall scaling posture. State total finding count and severity distribution. Highlight the top 2-3 issues that will hit first under load.]

| Severity | Count | Description |
|----------|-------|-------------|
| CRITICAL | N | Will cause outages or data corruption under load |
| HIGH | N | Will cause significant degradation at scale |
| MEDIUM | N | Will cause noticeable latency or resource waste |
| LOW | N | Minor inefficiencies; address opportunistically |
| INFO | N | Positive patterns worth maintaining |

---

## Findings

### [SEVERITY]-[N]: [Short Title]

**File:** `path/to/file.ts` lines X-Y
**Category:** [Memory | Database | Caching | Concurrency | I/O | Background Jobs | API Design | Configuration]
**Endpoint:** `METHOD /api/path` (if applicable)

**Description:**
[What the bottleneck is. Include the specific code pattern causing the issue.]

**Real-World Impact:**
- [Concrete resource estimate: "With 1,000 concurrent users, this allocates X GB of memory"]
- [Latency estimate: "Adds Y ms to response time under load"]
- [Failure mode: "At Z requests/second, the process will OOM / the pool will be exhausted"]

**Remediation:**
1. [Specific fix with code example or SQL]
2. [Additional optimization]

---

## Positive Patterns

[List production-grade patterns found in the codebase worth maintaining.]

## Remediation Priority Matrix

### Immediate (Before scaling to N users)
| Priority | Finding | Fix | Effort |
|----------|---------|-----|--------|

### Short-term (Before scaling to M users)
| Priority | Finding | Fix | Effort |
|----------|---------|-----|--------|

### Medium-term (Infrastructure for P users)
| Priority | Finding | Fix | Effort |
|----------|---------|-----|--------|

## Database Index Recommendations

[SQL CREATE INDEX statements with comments explaining which finding they address.]

## Memory Budget Estimate

| Component | Per-Request | Concurrent (N users) | Notes |
|-----------|-------------|----------------------|-------|

```

## Severity Classification

Use these definitions consistently:

- **CRITICAL**: Will cause outages (OOM, connection exhaustion, data corruption) under moderate load. Examples: unbounded full-table scans loaded into memory, background jobs with no concurrency guard, queries without pagination returning millions of rows.
- **HIGH**: Will cause significant degradation (multi-second latency, high CPU, resource pressure) at scale. Examples: unbounded in-memory caches, N+1 query patterns on hot paths, debug logging serializing full payloads in production.
- **MEDIUM**: Will cause noticeable latency or waste resources under specific conditions. Examples: missing database indexes on filtered columns, redundant queries, non-transactional bulk operations, disabled rate limiters.
- **LOW**: Minor inefficiencies; unlikely to cause visible issues alone. Examples: O(n²) deduplication on small arrays, suboptimal cache key patterns, unnecessary object cloning.
- **INFO**: Not a bottleneck, but a positive pattern worth maintaining. Examples: circuit breakers, request collapsing, connection pooling.

## Key Principles

- **Every finding needs concrete numbers**: Estimate memory in MB/GB, latency in ms, throughput limits in req/s. Do not report vague "could be slow" concerns.
- **Check what happens at 10x and 100x current load**: Most code works fine at low traffic — audit for what breaks under growth.
- **Trace full request lifecycle**: From HTTP receive → auth → business logic → DB query → response serialization → logging. Bottlenecks hide anywhere in the chain.
- **Audit background jobs as carefully as endpoints**: Jobs that overlap, leak memory, or hold connections are silent killers.
- **Check the data path, not just the code path**: A clean function that calls `db.select().from(table)` on a 100K-row table is a bottleneck regardless of code quality.
- **Look for unbounded growth**: Any `Map`, `Set`, `Array`, cache, or queue that grows without a maximum size will eventually exhaust memory in a long-running process.
- **Verify caching actually helps**: A cache with 0% hit rate or a TTL that's too short is wasted complexity. A cache without a size limit is a memory leak.
- **Count database round-trips**: Sequential queries in a loop are a classic scaling bottleneck. Prefer batch operations and JOINs.