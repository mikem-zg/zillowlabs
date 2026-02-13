## Advanced Patterns

<details>
<summary>Click to expand detailed implementation and configuration options</summary>

### Environment Detection and Tool Selection

**Primary Tool Detection:**
```bash
# Check MCP server availability (prefer Atlassian MCP over Glean for comprehensive data)
atlassian_available=$(atlassian.atlassianUserInfo 2>/dev/null && echo "true" || echo "false")

# Check Glean MCP availability as secondary option for search
glean_available=$(glean.search 2>/dev/null && echo "true" || echo "false")

# Check Chrome DevTools MCP for browser automation fallback
chrome_available=$(chrome_devtools.list_pages 2>/dev/null && echo "true" || echo "false")

# Select primary tool with fallback hierarchy
if [ "$atlassian_available" = "true" ]; then
    primary_tool="atlassian_mcp"
elif [ "$glean_available" = "true" ]; then
    primary_tool="glean_mcp"
elif [ "$chrome_available" = "true" ]; then
    primary_tool="browser"
else
    echo "Error: No available Confluence access method (Atlassian MCP, Glean MCP, or browser automation)"
    exit 1
fi
```

**Cloud ID Resolution:**
```javascript
// Auto-detect available Atlassian instances
const resources = await atlassian.getAccessibleAtlassianResources();

// Default to zillowgroup.atlassian.net for FUB workflows
const defaultCloudId = resources.find(r =>
    r.url === "https://zillowgroup.atlassian.net"
)?.id || resources[0]?.id;

const cloudId = provided_cloud_id || defaultCloudId || "d93b2b6a-611e-47a6-ade8-4d31b9e33e08";
```

**MCP Connection Verification (Critical for Atlassian MCP):**
```javascript
// Always verify Atlassian MCP availability before operations
const mcpResources = await mcp.list_resources();
const atlassianAvailable = mcpResources.some(r => r.server === 'atlassian');

if (!atlassianAvailable) {
    // Prompt user for reconnection
    console.log(`I cannot access the Atlassian MCP. Please reconnect it:

1. Open Cursor Settings → Features → Model Context Protocol
2. Find "Atlassian" in the MCP server list
3. Click "Reconnect" or restart the MCP server
4. Once connected, I can ${operation} the Confluence page

Alternatively, I can create/search content using Glean MCP (abridged content) or browser automation. Which would you prefer?`);

    // Fall back to alternative methods or create local content
}
```

**Tool Installation and Configuration:**

*Atlassian MCP Setup:*
```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://mcp.atlassian.com/v1/sse"
      ]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    },
    "glean-tools": {
      "type": "http",
      "url": "https://zillow-be.glean.com/mcp/default"
    }
  }
}
```

### 2. Space Discovery and Management

**Space Resolution and Auto-Detection:**
```javascript
// Get all accessible spaces to understand available context
const allSpaces = await atlassian.getConfluenceSpaces({
    cloudId: cloudId,
    limit: 250  // Get comprehensive space list
});

// Auto-detect space from context or default to common FUB spaces
const spaceResolution = {
    // Common FUB spaces
    'FUB': { key: 'FUB', name: 'Follow Up Boss' },
    'ENG': { key: 'ENG', name: 'Engineering' },
    'DEV': { key: 'DEV', name: 'Development' },

    // User personal spaces (by pattern matching)
    personal: allSpaces.results?.filter(s => s.type === 'personal') || [],

    // Project spaces (by naming patterns)
    projects: allSpaces.results?.filter(s =>
        s.key.match(/^[A-Z]{2,4}$/) || s.name.includes('Project')
    ) || []
};

// Default space resolution hierarchy
const resolveSpaceId = async (spaceKeyOrId) => {
    if (!spaceKeyOrId) {
        // Default to FUB space or user's personal space
        const fubSpace = allSpaces.results?.find(s => s.key === 'FUB');
        if (fubSpace) return fubSpace.id;

        const personalSpace = spaceResolution.personal[0];
        if (personalSpace) return personalSpace.id;

        throw new Error('No default space available');
    }

    // If it's already a numeric ID, return it
    if (/^\d+$/.test(spaceKeyOrId)) {
        return spaceKeyOrId;
    }

    // Look up space by key
    const space = allSpaces.results?.find(s => s.key === spaceKeyOrId);
    if (!space) {
        throw new Error(`Space not found: ${spaceKeyOrId}`);
    }

    return space.id;
};
```

### 3. Content Search and Discovery

**Natural Language to CQL Conversion:**
```javascript
function convertToCQL(query, spaceKey = null) {
    // Handle common search patterns
    const patterns = {
        'recent': 'lastModified >= "-7d"',
        'my pages': 'creator = currentUser()',
        'updated today': 'lastModified >= "today"',
        'this week': 'lastModified >= "-7d"',
        'last month': 'lastModified >= "-30d"',
        'api documentation': 'title ~ "API" OR title ~ "api" OR text ~ "endpoint"',
        'getting started': 'title ~ "getting started" OR title ~ "setup" OR title ~ "installation"',
        'troubleshooting': 'title ~ "troubleshoot" OR title ~ "error" OR title ~ "problem"',
        'meeting notes': 'title ~ "meeting" OR title ~ "notes" OR label = "meeting-notes"'
    };

    let cql = query;

    // Apply pattern transformations
    Object.entries(patterns).forEach(([pattern, replacement]) => {
        const regex = new RegExp(pattern, 'gi');
        cql = cql.replace(regex, replacement);
    });

    // Add space filter if specified
    if (spaceKey) {
        cql = `space = "${spaceKey}" AND (${cql})`;
    }

    // Add default content type filter
    cql = `type = page AND (${cql})`;

    return cql;
}
```

**Search Execution Patterns:**

*Using Atlassian MCP (Preferred for comprehensive data):*
```javascript
// CQL search with comprehensive field selection
const searchResults = await atlassian.searchConfluenceUsingCql({
    cloudId: cloudId,
    cql: convertToCQL(query, spaceKey),
    expand: "space,history,body.view,metadata.labels,ancestors",
    limit: 50
});

// Alternative: Use unified search for natural language (fallback within Atlassian)
const unifiedResults = await atlassian.search({
    query: `confluence ${query}`
});
```

*Using Glean MCP (Search Fallback - may provide abridged content):*
```javascript
// Use Glean MCP for searching Confluence content when direct Confluence access is unavailable
// Note: Content may be abridged compared to direct Confluence API access
const gleanResults = await glean.search({
    query: `confluence ${query}`,
    app: "confluence"  // Filter specifically to Confluence content
});

// Can also use Glean chat for more complex analysis
const gleanAnalysis = await glean.chat({
    message: `Search for Confluence pages related to: ${query}`,
    context: []
});
```

*Using Browser Automation (Third Fallback):*
```javascript
// Navigate to Confluence search and extract results
const searchConfluenceViaUI = async (query, spaceKey) => {
    const searchUrl = spaceKey
        ? `https://zillowgroup.atlassian.net/wiki/spaces/${spaceKey}/search?text=${encodeURIComponent(query)}`
        : `https://zillowgroup.atlassian.net/wiki/search?text=${encodeURIComponent(query)}`;

    await chrome_devtools.navigate_page({
        type: "url",
        url: searchUrl
    });

    await chrome_devtools.wait_for({
        text: "Search results"
    });

    // Extract search results from page
    const results = await chrome_devtools.evaluate_script({
        function: `() => {
            const resultElements = document.querySelectorAll('[data-test-id="search-result"]');
            return Array.from(resultElements).map(element => ({
                title: element.querySelector('h3')?.textContent?.trim(),
                url: element.querySelector('a')?.href,
                space: element.querySelector('[data-test-id="space-name"]')?.textContent?.trim(),
                excerpt: element.querySelector('.search-result-excerpt')?.textContent?.trim()
            })).filter(result => result.title && result.url);
        }`
    });

    return {
        success: true,
        method: 'browser_search',
        results: results
    };
};
```

### 4. Individual Page Retrieval

**Comprehensive Page Fetching:**

*Using Atlassian MCP (Primary):*
```javascript
const page = await atlassian.getConfluencePage({
    cloudId: cloudId,
    pageId: pageId,
    contentFormat: "markdown"  // Get as markdown for easier processing
});

// Get additional context for comprehensive analysis
const comments = await atlassian.getConfluencePageFooterComments({
    cloudId: cloudId,
    pageId: pageId,
    limit: 50
});

const inlineComments = await atlassian.getConfluencePageInlineComments({
    cloudId: cloudId,
    pageId: pageId,
    resolutionStatus: "open"
});

// Get page hierarchy context
const descendants = await atlassian.getConfluencePageDescendants({
    cloudId: cloudId,
    pageId: pageId,
    depth: 2
});
```

*Using Glean MCP (Secondary):*
```javascript
// Search for specific page by ID or title in Glean
const pageResults = await glean.search({
    query: `confluence page:${pageId}`,
    app: "confluence"
});

// Get full document content if available
if (pageResults.length > 0) {
    const pageContent = await glean.read_document({
        urls: [pageResults[0].url]
    });
}
```

*Using Browser Automation (Third Fallback):*
```javascript
// Navigate to Confluence page and extract content
const getPageViaUI = async (pageId) => {
    const pageUrl = `https://zillowgroup.atlassian.net/wiki/spaces/*/pages/${pageId}/*`;

    await chrome_devtools.navigate_page({
        type: "url",
        url: pageUrl
    });

    await chrome_devtools.wait_for({
        text: pageId
    });

    // Extract page content using developer tools console method from FUB patterns
    const pageContent = await chrome_devtools.evaluate_script({
        function: `() => {
            // Use FUB's documented approach for extracting Confluence content
            const content = $("#content").html();
            return {
                title: document.title.replace(' - Confluence', ''),
                content: content,
                url: window.location.href
            };
        }`
    });

    return {
        success: true,
        method: 'browser_extract',
        page: pageContent,
        message: `Page content extracted via browser. Use HTML to Markdown conversion for easier processing.`
    };
};
```

### 5. Content Format Conversion and Helpers

**Enhanced Markdown to Confluence Conversion:**
```javascript
function markdownToConfluenceFormat(markdown) {
    // Confluence uses specific formatting patterns
    let confluence = markdown;

    // Convert headers (start with ## for pages, never duplicate title)
    confluence = confluence.replace(/^# (.+)/gm, ''); // Remove H1 (page titles)
    confluence = confluence.replace(/^## (.+)/gm, '<h2>$1</h2>');
    confluence = confluence.replace(/^### (.+)/gm, '<h3>$1</h3>');
    confluence = confluence.replace(/^#### (.+)/gm, '<h4>$1</h4>');

    // Convert code blocks with language specification
    confluence = confluence.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, lang, code) => {
        const language = lang || 'text';
        return `<ac:structured-macro ac:name="code" ac:schema-version="1">
<ac:parameter ac:name="language">${language}</ac:parameter>
<ac:plain-text-body><![CDATA[${code.trim()}]]></ac:plain-text-body>
</ac:structured-macro>`;
    });

    // Convert inline code
    confluence = confluence.replace(/`([^`]+)`/g, '<code>$1</code>');

    // Convert bold and italic
    confluence = confluence.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    confluence = confluence.replace(/\*([^*]+)\*/g, '<em>$1</em>');

    // Convert links
    confluence = confluence.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

    // Convert lists
    confluence = confluence.replace(/^- (.+)/gm, '<li>$1</li>');
    confluence = confluence.replace(/(<li>.*<\/li>)/s, '<ul>$1</ul>');

    // Convert quotes
    confluence = confluence.replace(/^> (.+)/gm, '<blockquote>$1</blockquote>');

    // Convert tables (basic support)
    confluence = confluence.replace(/^\|(.+)\|$/gm, (match, content) => {
        const cells = content.split('|').map(cell => cell.trim());
        return '<tr>' + cells.map(cell => `<td>${cell}</td>`).join('') + '</tr>';
    });
    confluence = confluence.replace(/(<tr>.*<\/tr>)/s, '<table>$1</table>');

    return confluence;
}
```

**Content Quality Standards (Based on FUB Patterns):**
```javascript
const confluenceTemplates = {
    apiDocumentation: {
        title: "API Documentation Template",
        content: `## Overview

Brief description of the API and its purpose.

