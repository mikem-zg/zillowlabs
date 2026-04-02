---
name: airbyte-lowcode-connector
description: Generate production-ready Airbyte low-code connector YAML manifests for REST APIs - creates complete YAML files ready for import into Connector Builder interface
---

# Airbyte Low-Code Connector Builder (Production-Ready)

Build complete, production-ready Airbyte low-code connectors using the modern Connector Builder interface. This skill is based on real-world experience building connectors and includes solutions to common pitfalls.

## When to Use This Skill

- Building new Airbyte connectors for REST APIs
- Converting curl commands to Airbyte connectors  
- Fixing schema validation errors in existing connectors
- Adding pagination support to connectors
- Deploying to Airbyte Cloud/Enterprise instances

## Phase 1: API Discovery & Testing

### 1.1 Test All API Endpoints First

**Critical Step:** Before building anything, systematically test every endpoint to identify working ones:

```bash
# Test each endpoint systematically  
curl -X GET "https://api.example.com/endpoint" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Accept: application/json"
```

**Document results in a spreadsheet:**
- ✅ Working endpoints (with record counts)
- ❌ Failed endpoints (with error types: 404, 401, etc.)
- 🔍 Response structures and pagination metadata

### 1.2 Analyze Response Patterns

Look for these key patterns:
- **Data location**: `{"list": [...]}` vs `{"data": [...]}` vs `{"results": [...]}`
- **Pagination info**: `next_token`, `has_more`, `page_info`, `cursor`
- **Schema complexity**: nested objects, mixed-type fields, nullable values

### 1.3 Authentication Testing

Test different auth methods systematically:
```bash
# API Key in header (most common)
-H "X-API-Key: your_key"
-H "Authorization: Bearer token"  
-H "Custom-Auth-Header: value"

# API Key in query params
"?api_key=your_key&other=param"
```

## Phase 2: Modern Connector Builder Setup

### 2.1 Access Connector Builder Interface

**Airbyte Cloud:** Go to `Sources` → `+ New source` → `Connector Builder`
**Airbyte Enterprise:** Navigate to workspace → `Sources` → `Connector Builder`

### 2.2 Choose Your Approach

**Option A: Start from scratch (recommended for learning)**
- Use for completely new APIs
- Build step-by-step in UI to understand each component

**Option B: Import YAML manifest (recommended for production)**  
- Use for complex connectors with many streams
- Import pre-built manifest files
- Faster for experienced users

## Phase 3: Build Core Connector (Modern Approach)

### 3.1 Basic Configuration

Use the **latest stable version** (not 0.1.0):

```yaml
version: "6.48.15"  # Always use latest 6.x version
type: DeclarativeSource

spec:
  type: Spec
  connection_specification:
    type: object
    $schema: http://json-schema.org/draft-07/schema#
    required: ["api_key"]
    properties:
      api_key:
        type: string
        title: "API Key"
        description: "Your API key for authentication"
        airbyte_secret: true
        order: 0
```

### 3.2 Authentication Setup (Updated Syntax)

```yaml
definitions:
  base_requester:
    type: HttpRequester
    url_base: "https://api.example.com"
    authenticator:
      type: ApiKeyAuthenticator
      api_token: "{{ config['api_key'] }}"
      inject_into:
        type: RequestOption
        field_name: "Your-Auth-Header"  # Check API docs for exact header name
        inject_into: "header"  # Note: quotes required in modern version
```

### 3.3 Add Streams (Start with 2-3 Working Endpoints)

**Begin with simple, reliable endpoints:**

```yaml
streams:
  - type: DeclarativeStream
    name: "departments"  # Use working endpoint from your testing
    primary_key: ["id"]  # Array format in modern version
    retriever:
      type: SimpleRetriever
      requester:
        $ref: "#/definitions/base_requester"
        path: "/departments"
      record_selector:
        type: RecordSelector
        extractor:
          type: DpathExtractor
          field_path: ["list"]  # Adjust based on your API structure testing
      decoder:
        type: JsonDecoder  # Explicit decoder in modern version
```

## Phase 4: Schema Strategy (CRITICAL LESSONS!)

### 4.1 Schema Design Philosophy (Battle-Tested)

**❌ AVOID: Complex predefined schemas (causes most failures)**
- Mixed-type fields: `type: ["object", "string"]`  
- Deep nested object definitions with properties
- `anyOf` / `oneOf` constructs
- Custom datetime parsing with `strptime`

**✅ PREFER: Auto-discovery approach (works reliably)**
```yaml
schema_loader:
  type: InlineSchemaLoader
  schema:
    type: object
    $schema: http://json-schema.org/draft-07/schema#
    additionalProperties: true  # This is the magic setting!
    properties: {}  # Empty - let Airbyte auto-discover everything
```

### 4.2 Handle Complex Fields (Real-World Solution)

When you get `KeyError: 'type'` errors, use **field removal**:

```yaml
transformations:
  - type: RemoveFields
    field_pointers:
      - ["attributes"]  # Remove problematic nested objects
      - ["complex_metadata"]
      - ["mixed_type_arrays"]
```

### 4.3 Schema Troubleshooting (Common Errors & Solutions)

| Error | Root Cause | Solution |
|-------|------------|----------|
| `KeyError: 'type'` | Complex nested schema validation | Simplify schema, use auto-discovery |
| `No filter named 'strptime'` | Datetime parsing in templates | Remove custom datetime parsing |
| Schema inference failure | Mixed-type fields in arrays | Remove problematic fields with transformations |
| Version incompatibility | Using version 0.1.0 | Update to version 6.x+ |

## Phase 5: Add Pagination (Future-Proofing)

### 5.1 Identify Pagination Pattern from API Testing

Based on your API response analysis:
- **Cursor-based:** `next_token`, `next_cursor`, `next_page_token`
- **Offset-based:** `offset`, `limit`, `page`, `page_size`  
- **Link-based:** `next_url`, `links.next`

### 5.2 Configure Pagination (Modern Syntax)

**Cursor-based (most common and reliable):**
```yaml
definitions:
  base_paginator:
    type: DefaultPaginator
    page_token_option:
      type: RequestOption
      inject_into: "request_parameter"  # Quotes required
      field_name: "next_token"  # API-specific field name from your testing
    pagination_strategy:
      type: CursorPagination
      cursor_value: "{{ response.next_token }}"
      stop_condition: "{{ not response.get('has_more', False) or not response.get('next_token') }}"
      page_size: 100

  base_retriever:
    type: SimpleRetriever
    requester:
      $ref: "#/definitions/base_requester"
    record_selector:
      type: RecordSelector
      extractor:
        type: DpathExtractor
        field_path: ["list"]
    paginator:
      $ref: "#/definitions/base_paginator"  # Add to all streams
    decoder:
      type: JsonDecoder
```

## YAML Manifest Complete

Your Airbyte low-code connector YAML manifest is now ready! The generated YAML file contains:

✅ **Modern syntax** (version 6.x+) with proper configuration
✅ **Authentication setup** configured for your API's auth method
✅ **Stream definitions** with auto-discovery schemas 
✅ **Pagination support** to handle large datasets
✅ **Error handling** for production reliability

## Next Steps

1. **Save the YAML manifest** to a file (e.g., `my-connector-manifest.yaml`)
2. **Open Airbyte Connector Builder UI** in your Airbyte instance
3. **Import the manifest** using the "Import" button in Connector Builder
4. **Test streams individually** in the Builder interface 
5. **Publish your connector** when testing is complete

Your connector is ready for import into Airbyte!

## Battle-Tested Best Practices for YAML Generation

### ✅ ALWAYS DO:
- Test API endpoints thoroughly before building YAML
- Start with 2-3 simple, working endpoints  
- Use auto-discovery for schemas (`additionalProperties: true`)
- Add pagination from the start (even if current data is small)
- Use latest manifest version (6.x+, never 0.1.0)
- Remove problematic fields rather than trying to fix schemas

### ❌ NEVER DO:
- Define complex nested schemas upfront (causes validation errors)
- Use mixed-type fields in schema definitions  
- Skip API endpoint testing phase
- Use old manifest versions (0.x versions cause compatibility issues)
- Try to model every API quirk in predefined schemas

### 🔧 YAML Generation Troubleshooting:

**Schema Validation Errors:**
1. Remove all schema definitions → use auto-discovery only
2. Add `additionalProperties: true` to all schema objects
3. Use `RemoveFields` transformations for problematic nested objects

**Authentication Issues:**
1. Verify exact header name from API documentation (case-sensitive)
2. Test auth with curl first, then replicate exact headers
3. Check if API key needs specific prefix (e.g., "Bearer ", "Token ")

**Missing Data:**
1. Check `field_path` matches actual API response structure
2. Verify endpoint URLs (common: underscore vs dash confusion)  
3. Add pagination configuration for APIs with large datasets
4. Check if API requires additional parameters for full data

**Version Compatibility:**
1. Always use version 6.48.15 or latest 6.x
2. Update inject_into syntax to use quotes: `inject_into: "header"`
3. Use array format for primary_key: `primary_key: ["id"]`

## Complete YAML Manifest Template

Generate a production-ready YAML manifest using this template structure:

```yaml
version: "6.48.15"
type: DeclarativeSource

definitions:
  base_requester:
    type: HttpRequester  
    url_base: "https://api.example.com"
    authenticator:
      type: ApiKeyAuthenticator
      api_token: "{{ config['api_key'] }}"
      inject_into:
        type: RequestOption
        field_name: "API-Key"  # Your API's specific header name
        inject_into: "header"
    error_handler:
      type: CompositeErrorHandler
      error_handlers:
        - type: DefaultErrorHandler
          max_retries: 3
          backoff_strategies:
            - type: ExponentialBackoffStrategy
              factor: 2
          response_filters:
            - type: HttpResponseFilter
              action: RETRY
              http_codes: [429, 500, 502, 503, 504]
        
  base_paginator:
    type: DefaultPaginator
    page_token_option:
      type: RequestOption
      inject_into: "request_parameter"
      field_name: "next_token"  # Your API's pagination field
    pagination_strategy:
      type: CursorPagination
      cursor_value: "{{ response.next_token }}"
      stop_condition: "{{ not response.get('has_more', False) }}"
      
  base_retriever:
    type: SimpleRetriever
    requester:
      $ref: "#/definitions/base_requester"
    record_selector:
      type: RecordSelector
      extractor:
        type: DpathExtractor
        field_path: ["list"]  # Your API's data array field
    paginator:
      $ref: "#/definitions/base_paginator"
    decoder:
      type: JsonDecoder

streams:
  - type: DeclarativeStream
    name: "departments"
    primary_key: ["id"]
    retriever:
      $ref: "#/definitions/base_retriever"
      requester:
        $ref: "#/definitions/base_requester"
        path: "/departments"
    schema_loader:
      type: InlineSchemaLoader
      schema:
        type: object
        $schema: http://json-schema.org/draft-07/schema#
        additionalProperties: true
        properties: {}
        
  # Add more streams following the same pattern...

check:
  type: CheckStream
  stream_names: ["departments"]

spec:
  type: Spec
  connection_specification:
    type: object
    $schema: http://json-schema.org/draft-07/schema#
    required: ["api_key"]
    properties:
      api_key:
        type: string
        title: "API Key"
        description: "Your API key for authentication"
        airbyte_secret: true
        order: 0
```

This template provides a complete, production-ready YAML manifest that can be imported directly into Airbyte Connector Builder.