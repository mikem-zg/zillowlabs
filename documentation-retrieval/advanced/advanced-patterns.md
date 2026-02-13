## Advanced Documentation Research Patterns

### Complex Research Workflows

#### Multi-Source Validation Strategy
```javascript
// 1. Primary research via Context7/Glean
const primaryResults = await mcp__context7__query_docs({
  libraryId: "/mongodb/docs",
  query: "connection pooling configuration"
});

// 2. Cross-reference with package registry
const registryInfo = await WebFetch("https://www.npmjs.com/package/mongodb");

// 3. Verify with GitHub repository
const repoInfo = await WebFetch("https://github.com/mongodb/node-mongodb-native");

// 4. Synthesize and validate across sources
```

#### Advanced Glean Research for Internal Services
```javascript
// Comprehensive internal service research
const serviceResearch = async (serviceName) => {
  // Search documentation
  const docs = await mcp__glean_tools__search({
    query: `${serviceName} API documentation`,
    app: "confluence",
    updated: "past_6_months"
  });

  // Search code examples
  const code = await mcp__glean_tools__code_search({
    query: `${serviceName} configuration implementation`,
    from: "team_members",
    after: "2024-01-01"
  });

  // Get team context
  const teamInfo = await mcp__glean_tools__employee_search({
    query: `${serviceName} team owner maintainer`
  });

  // Read comprehensive documentation
  const fullDocs = await mcp__glean_tools__read_document({
    urls: docs.results.slice(0, 3).map(r => r.url)
  });

  return { docs, code, teamInfo, fullDocs };
};
```

### Progressive Research Strategies

#### Library Evaluation Workflow
1. **Initial Assessment** - Context7 overview and basic compatibility
2. **Deep Dive** - GitHub repository analysis, issue tracking, community health
3. **Integration Planning** - FUB-specific patterns, security considerations
4. **Implementation Research** - Detailed API documentation and examples
5. **Deployment Research** - Production considerations, monitoring patterns

#### Troubleshooting and Debugging Research
```javascript
// Systematic issue resolution research
const troubleshootingWorkflow = async (library, issue) => {
  // 1. Official documentation for known issues
  const officialDocs = await mcp__context7__query_docs({
    libraryId: library.id,
    query: `${issue} troubleshooting debugging common problems`
  });

  // 2. Community issue tracking
  const githubIssues = await WebFetch(
    `https://github.com/search?q=${library.name}+${issue}&type=Issues`
  );

  // 3. Stack Overflow patterns
  const stackOverflow = await WebFetch(
    `https://stackoverflow.com/search?q=${library.name}+${issue}`
  );

  // 4. Internal team experience (if applicable)
  const internalExp = await mcp__glean_tools__search({
    query: `${library.name} ${issue} problem solution`,
    from: "myteam",
    updated: "past_year"
  });

  return { officialDocs, githubIssues, stackOverflow, internalExp };
};
```

### Advanced Integration Research

#### Migration and Update Research
```javascript
// Comprehensive migration documentation research
const migrationResearch = async (library, fromVersion, toVersion) => {
  // Official migration guides
  const migrationGuide = await mcp__context7__query_docs({
    libraryId: library.id,
    query: `migration guide ${fromVersion} to ${toVersion} breaking changes`
  });

  // Changelog analysis
  const changelog = await WebFetch(`${library.repository}/blob/main/CHANGELOG.md`);

  // Community migration experiences
  const communityExp = await WebFetch(
    `https://github.com/search?q=${library.name}+migration+${toVersion}&type=Issues`
  );

  // Internal team migration notes
  const internalNotes = await mcp__glean_tools__search({
    query: `${library.name} upgrade migration ${toVersion}`,
    from: "myteam",
    updated: "past_2_years"
  });

  return { migrationGuide, changelog, communityExp, internalNotes };
};
```

#### Security and Compliance Research
```javascript
// Security-focused library research
const securityResearch = async (library) => {
  // Security documentation
  const securityDocs = await mcp__context7__query_docs({
    libraryId: library.id,
    query: "security authentication authorization vulnerabilities"
  });

  // Vulnerability databases
  const vulnDb = await WebFetch(`https://www.npmjs.com/advisories?search=${library.name}`);

  // License compatibility
  const licenseInfo = await WebFetch(`${library.repository}/blob/main/LICENSE`);

  // Internal security guidelines
  const internalSec = await mcp__glean_tools__search({
    query: `${library.name} security approval compliance`,
    app: "confluence",
    updated: "past_year"
  });

  return { securityDocs, vulnDb, licenseInfo, internalSec };
};
```

### Performance and Optimization Research

#### Performance Documentation Research
```javascript
// Comprehensive performance research
const performanceResearch = async (library, context) => {
  // Performance guides and benchmarks
  const perfDocs = await mcp__context7__query_docs({
    libraryId: library.id,
    query: "performance optimization benchmarks best practices"
  });

  // Real-world performance discussions
  const perfDiscussions = await WebFetch(
    `https://github.com/search?q=${library.name}+performance+optimization&type=Issues`
  );

  // Alternative library comparisons
  const alternatives = await mcp__context7__resolve_library_id({
    query: `${context} alternatives to ${library.name} comparison`,
    libraryName: library.name
  });

  return { perfDocs, perfDiscussions, alternatives };
};
```

### Error Handling and Rate Limits

#### Progressive Search with Fallbacks
```javascript
// Intelligent fallback research strategy
const smartResearch = async (query, options = {}) => {
  const maxAttempts = { context7: 3, glean: 5, webFetch: 8 };
  const results = {};

  try {
    // Primary: Context7 for external libraries
    if (!options.internal) {
      results.context7 = await attemptContext7Research(query, maxAttempts.context7);
    }

    // Primary: Glean for internal documentation
    if (options.internal || options.includeInternal) {
      results.glean = await attemptGleanResearch(query, maxAttempts.glean);
    }

    // Fallback: Web research if primary sources insufficient
    if (!results.context7?.length && !results.glean?.length) {
      results.web = await attemptWebResearch(query, maxAttempts.webFetch);
    }

  } catch (error) {
    console.log(`Research error: ${error.message}`);
    // Provide manual research guidance
    results.manual = generateManualResearchGuidance(query, options);
  }

  return results;
};
```

#### Advanced Error Handling Patterns
```javascript
// Resilient MCP research with circuit breakers
const resilientResearch = async (query, source) => {
  const circuitBreaker = new CircuitBreaker(source, {
    timeout: 30000,
    errorThresholdPercentage: 50,
    resetTimeoutMs: 30000
  });

  try {
    switch (source) {
      case 'context7':
        return await circuitBreaker.execute(async () => {
          const libraryId = await mcp__context7__resolve_library_id(query);
          return await mcp__context7__query_docs(libraryId, query);
        });

      case 'glean':
        return await circuitBreaker.execute(async () => {
          return await mcp__glean_tools__search(query);
        });

      default:
        throw new Error(`Unknown source: ${source}`);
    }
  } catch (error) {
    console.log(`Circuit breaker open for ${source}: ${error.message}`);
    return await fallbackResearch(query, source);
  }
};
```

### Comprehensive Library Analysis

#### Full Library Assessment
```javascript
// Complete library evaluation workflow
const comprehensiveLibraryAnalysis = async (libraryName, context) => {
  const analysis = {};

  // 1. Basic library information
  analysis.overview = await mcp__context7__resolve_library_id({
    query: `${libraryName} overview features`,
    libraryName: libraryName
  });

  // 2. Technical documentation
  analysis.technical = await mcp__context7__query_docs({
    libraryId: analysis.overview.libraryId,
    query: `${libraryName} API documentation examples ${context}`
  });

  // 3. Security assessment
  analysis.security = await securityResearch(analysis.overview);

  // 4. Performance evaluation
  analysis.performance = await performanceResearch(analysis.overview, context);

  // 5. Community health
  analysis.community = await WebFetch(`${analysis.overview.repository}/graphs/contributors`);

  // 6. Internal usage patterns (if applicable)
  analysis.internal = await mcp__glean_tools__search({
    query: `${libraryName} usage examples implementation`,
    from: "myteam",
    updated: "past_year"
  });

  return analysis;
};
```

#### Integration Planning Research
```javascript
// Research for integrating library into existing FUB systems
const integrationPlanningResearch = async (library, targetSystem) => {
  const integration = {};

  // 1. Compatibility analysis
  integration.compatibility = await mcp__context7__query_docs({
    libraryId: library.id,
    query: `${library.name} compatibility requirements dependencies ${targetSystem}`
  });

  // 2. Architecture patterns
  integration.patterns = await mcp__context7__query_docs({
    libraryId: library.id,
    query: `${library.name} integration patterns architecture examples`
  });

  // 3. Configuration requirements
  integration.config = await mcp__context7__query_docs({
    libraryId: library.id,
    query: `${library.name} configuration setup production deployment`
  });

  // 4. Internal integration examples
  integration.internal = await mcp__glean_tools__code_search({
    query: `${library.name} integration ${targetSystem} configuration`,
    from: "myteam",
    after: "2024-01-01"
  });

  // 5. Monitoring and observability
  integration.monitoring = await mcp__glean_tools__search({
    query: `${library.name} monitoring metrics observability`,
    app: "confluence",
    updated: "past_6_months"
  });

  return integration;
};
```

These advanced patterns enable sophisticated documentation research workflows for complex library evaluation, security compliance, performance optimization, and system integration planning.