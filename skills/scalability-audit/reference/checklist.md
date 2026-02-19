# Scaling Audit Checklist

Systematic checklist organized by bottleneck category. For each item, search the codebase for the relevant patterns, estimate resource usage under load, and verify controls are in place.

## 1. Memory Management

- [ ] **Unbounded in-memory structures**: No `Map`, `Set`, `Array`, or cache grows without a max size or eviction policy
- [ ] **Full table loads**: No endpoint loads an entire database table into memory for filtering/aggregation
- [ ] **Response body retention**: Logging/middleware doesn't hold references to full response objects
- [ ] **Large object serialization**: `JSON.stringify` not called on large objects unnecessarily (logging, debugging)
- [ ] **Stream processing**: Large data transfers (CSV export, file upload) use streams, not in-memory buffers
- [ ] **Garbage collection pressure**: No patterns creating many short-lived large objects under high concurrency
- [ ] **Global state accumulation**: Singleton Maps/Sets cleaned up periodically; entries have TTLs or max-size caps

Search patterns:
```
grep -rn "new Map\|new Set" server/ --include="*.ts"
grep -rn "db\.select()\.from(" server/ --include="*.ts"
grep -rn "JSON\.stringify" server/ --include="*.ts"
grep -rn "\.push\|\.concat\|\.map\|\.filter" server/ --include="*.ts" | grep -i "all\|every\|entire"
```

## 2. Database Queries & Indexing

- [ ] **Full table scans**: All queries on large tables filter using indexed columns
- [ ] **N+1 queries**: No loops executing individual queries per item (use batch/JOIN instead)
- [ ] **Missing indexes**: Columns used in WHERE, JOIN, ORDER BY have appropriate indexes
- [ ] **Unbounded result sets**: All queries have LIMIT or pagination
- [ ] **JSONB filtering**: JSONB columns filtered in SQL (not loaded into JS for filtering); GIN indexes on queried JSONB paths
- [ ] **Count queries**: `COUNT(*)` not paired with a redundant data query; use window functions or estimates for large tables
- [ ] **Aggregation in SQL**: GROUP BY, SUM, AVG done in database, not in application code
- [ ] **Connection usage**: Queries don't hold connections longer than necessary; no long transactions
- [ ] **Query plan verification**: `EXPLAIN ANALYZE` on hot-path queries shows index usage

Search patterns:
```
grep -rn "db\.select\|\.findMany\|\.find(" server/ --include="*.ts"
grep -rn "for.*await.*db\.\|forEach.*await.*db\." server/ --include="*.ts"
grep -rn "\.where\|\.filter\|\.orderBy" server/ --include="*.ts"
grep -rn "count\|COUNT" server/ --include="*.ts"
```

## 3. Connection Pooling

- [ ] **Pool size**: Database connection pool `max` is appropriate for deployment (typically 10-20 per instance)
- [ ] **Idle timeout**: Idle connections released after reasonable timeout (30-60s)
- [ ] **Connection timeout**: Queries that wait too long for a connection fail fast (5-10s)
- [ ] **Keepalive**: Keepalive interval matches database provider's idle timeout
- [ ] **Pool exhaustion**: Under burst load, pool doesn't run out of connections (check waitForConnections / queue behavior)
- [ ] **Pool monitoring**: Active/idle/waiting connection counts are observable
- [ ] **Multi-instance**: If running multiple instances, total connections across all don't exceed database max

Search patterns:
```
grep -rn "max.*pool\|pool.*max\|connectionLimit\|poolSize" server/ --include="*.ts"
grep -rn "idleTimeout\|connectionTimeout\|acquireTimeout" server/ --include="*.ts"
grep -rn "pool\.query\|pool\.connect\|getConnection" server/ --include="*.ts"
```

## 4. Caching

- [ ] **Cache hit rate**: Caches are used on hot paths and have measurable hit rates
- [ ] **Max size**: All caches have a `maxKeys` or max-memory limit to prevent unbounded growth
- [ ] **TTL appropriateness**: TTLs match data freshness requirements (not too short to be useless, not too long to serve stale data)
- [ ] **Cache invalidation**: Writes invalidate relevant cache entries
- [ ] **Stale-while-revalidate**: Stale cache serves during refresh to prevent thundering herd
- [ ] **Per-user caching**: Per-user cache keys don't multiply memory beyond budget (users × key_count × avg_size)
- [ ] **Clone behavior**: Cache returns references (`useClones: false`) — mutations to returned objects don't corrupt cache
- [ ] **Cache stampede**: Concurrent requests for an expired key don't all hit the database simultaneously
- [ ] **Cache monitoring**: Cache stats (size, hit/miss ratio) are exposed for observability

Search patterns:
```
grep -rn "NodeCache\|lru-cache\|redis\|cache\.\(get\|set\|del\)" server/ --include="*.ts"
grep -rn "maxKeys\|max_keys\|maxSize" server/ --include="*.ts"
grep -rn "ttl\|TTL\|stdTTL\|maxAge" server/ --include="*.ts"
```

## 5. Background Jobs & Concurrency

- [ ] **Concurrency guard**: Long-running jobs have a mutex/lock preventing overlapping execution
- [ ] **Batch processing**: Jobs process items in batches, not one-at-a-time sequential queries
- [ ] **Failure handling**: Job failures don't leave data in an inconsistent state
- [ ] **Resource cleanup**: Jobs release DB connections, close streams, and free memory on completion and failure
- [ ] **Backpressure**: If a job falls behind, there's a mechanism to catch up or alert (not just accumulate backlog)
- [ ] **Timeout**: Jobs have a maximum execution time to prevent runaway processes
- [ ] **Idempotency**: Jobs can safely re-run without duplicating effects

Search patterns:
```
grep -rn "setInterval\|setTimeout\|cron\|schedule\|queue" server/ --include="*.ts"
grep -rn "isRunning\|mutex\|lock\|semaphore" server/ --include="*.ts"
```

## 6. API Design & Response Size

- [ ] **Pagination**: List endpoints return paginated results with configurable page size and a max limit
- [ ] **Field selection**: Large responses allow field filtering to reduce payload size
- [ ] **Compression**: gzip/brotli compression enabled for API responses
- [ ] **Streaming**: Large data transfers (exports, file downloads) use HTTP streaming, not full buffering
- [ ] **Rate limiting**: Applied to all endpoints; stricter on expensive operations
- [ ] **Rate limiter storage**: Rate limiter uses shared storage (Redis) if running multiple instances
- [ ] **Request size limits**: Body parser limits configured (e.g., `express.json({ limit: '1mb' })`)
- [ ] **Timeout**: Request-level timeouts prevent slow clients from holding connections

Search patterns:
```
grep -rn "limit\|offset\|page\|cursor" server/ --include="*.ts" | grep -i "api\|route"
grep -rn "rate.*limit\|rateLimit\|express-rate-limit" server/ --include="*.ts"
grep -rn "compression\|gzip\|brotli" server/ --include="*.ts"
grep -rn "res\.write\|pipe\|stream" server/ --include="*.ts"
```

## 7. External API Calls

- [ ] **Circuit breakers**: External API calls protected by circuit breaker pattern
- [ ] **Retry with backoff**: Retries use exponential backoff, not immediate retry
- [ ] **Timeouts**: All outbound HTTP requests have explicit timeouts
- [ ] **Request collapsing**: Concurrent identical requests deduplicated
- [ ] **Caching**: Responses from slow/expensive external APIs cached appropriately
- [ ] **Rate awareness**: Client respects upstream rate limits (429 Retry-After headers)
- [ ] **Bulkhead isolation**: Failure in one external service doesn't cascade to others
- [ ] **Connection reuse**: HTTP keep-alive enabled for repeated calls to the same host

Search patterns:
```
grep -rn "fetch\|axios\|http\.get\|request(" server/ --include="*.ts" | grep -v node_modules
grep -rn "circuit\|breaker\|retry\|backoff" server/ --include="*.ts"
grep -rn "AbortController\|timeout\|signal" server/ --include="*.ts"
```

## 8. Logging & Observability

- [ ] **Log levels**: Production uses structured logging with configurable levels (not `console.log`)
- [ ] **No payload logging**: Full request/response bodies not logged in production
- [ ] **Debug guards**: Debug logs wrapped in `NODE_ENV !== 'production'` or log-level checks
- [ ] **Async logging**: Logging doesn't block the event loop (no synchronous file writes)
- [ ] **Health endpoint**: Reports cache stats, pool utilization, memory usage, uptime
- [ ] **Metrics**: Key metrics (request latency, error rate, cache hit rate) are measurable
- [ ] **Alerting**: Memory, CPU, and error thresholds trigger alerts

Search patterns:
```
grep -rn "console\.log\|console\.debug\|console\.info" server/ --include="*.ts" | wc -l
grep -rn "JSON\.stringify.*null.*2\|JSON\.stringify.*data\|JSON\.stringify.*response" server/ --include="*.ts"
grep -rn "pino\|winston\|bunyan\|morgan\|log\.level" server/ --include="*.ts"
```

## 9. Data Operations & Transactions

- [ ] **Bulk operations**: Batch inserts/updates/deletes use multi-row operations, not loops
- [ ] **Transactional consistency**: Multi-step writes wrapped in database transactions
- [ ] **Delete-then-insert**: Table refreshes use transactions or staging tables, not delete-all then insert-all
- [ ] **Upsert efficiency**: ON CONFLICT DO UPDATE used for idempotent writes instead of SELECT-then-INSERT
- [ ] **Vacuum/maintenance**: Large tables with frequent updates have appropriate autovacuum settings

Search patterns:
```
grep -rn "db\.transaction\|BEGIN\|COMMIT\|ROLLBACK" server/ --include="*.ts"
grep -rn "db\.delete\|db\.insert\|db\.update" server/ --include="*.ts"
grep -rn "onConflict\|ON CONFLICT\|upsert\|MERGE" server/ --include="*.ts"
```

## 10. Long-Lived Connections

- [ ] **SSE/WebSocket timeouts**: Streaming connections have max duration limits
- [ ] **Connection tracking**: Number of open long-lived connections is monitored
- [ ] **Upstream timeouts**: Proxied streams have AbortController timeouts on the upstream fetch
- [ ] **Client disconnect handling**: Server cleans up resources when client disconnects
- [ ] **Keep-alive management**: HTTP keep-alive settings balance connection reuse and resource release

Search patterns:
```
grep -rn "text/event-stream\|EventSource\|WebSocket\|ws\.\|SSE" server/ --include="*.ts"
grep -rn "req\.on.*close\|res\.on.*close" server/ --include="*.ts"
grep -rn "AbortController\|abort\|signal" server/ --include="*.ts"
```
