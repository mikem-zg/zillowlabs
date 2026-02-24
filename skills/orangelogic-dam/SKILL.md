---
name: orangelogic-dam
description: "Search, retrieve, and upload digital assets through the OrangeLogic DAM API. Use when the user asks to find images, photos, logos, icons, illustrations, videos, marketing assets, brand assets, or any visual content from Zillow's digital asset library. Also use when uploading files to the DAM, getting asset links for designs, looking for marketing materials, campaign assets, social media graphics, product screenshots, headshots, or any branded content. Covers search with query syntax, asset link retrieval, metadata lookup, and file upload."
---

# OrangeLogic DAM Integration

Search, retrieve, and upload digital assets through the OrangeLogic DAM API.

**Base URL:** `https://{ORANGELOGIC_BASE_URL}` (set via env var `ORANGELOGIC_BASE_URL`)
**Auth:** OAuth 2.0 client credentials → Bearer token
**Required env vars:** `ORANGELOGIC_BASE_URL`, `ORANGELOGIC_CLIENT_ID`, `ORANGELOGIC_CLIENT_SECRET`

## Authentication

Client credentials flow — token valid for 2 hours (7200s). The server proxy handles token caching and refresh automatically.

```bash
curl -X POST "https://{base}/webapi/security/clientcredentialsauthentication/authenticate_46H_v1" \
  -H "Content-Type: application/json" \
  -d '{"client_id":"...","client_secret":"..."}'
# Response: { "access_token": "...", "token_type": "Bearer", "expires_in": 7200 }
```

All subsequent calls use `Authorization: Bearer {access_token}`.

## Server Proxy Endpoints

The app exposes these proxy routes (defined in `server/orangelogic.ts`) so the agent and client can call the DAM without exposing credentials:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/dam/search` | POST | Search assets by query |
| `/api/dam/asset/:identifier/link` | GET | Get download/embed link for an asset |
| `/api/dam/asset/:identifier/links` | POST | Get multiple format links for an asset |
| `/api/dam/fields` | GET | List available metadata fields |
| `/api/dam/upload` | POST | Upload a file (multipart/form-data) |
| `/api/dam/upload-url` | POST | Upload from a remote URL |

## Search Assets

### Endpoint: `POST /api/dam/search`

```json
{
  "query": "keyword:house AND MediaType:Image",
  "fields": "SystemIdentifier,Title,path_TR1,MediaEncryptedIdentifier",
  "pageSize": 20,
  "pageNumber": 1,
  "sort": "Relevance"
}
```

### Query Syntax

| Pattern | Example | Description |
|---------|---------|-------------|
| Free text | `Text:modern kitchen` | Search across all text fields |
| Keyword | `Keyword:beach` | Match keyword/tag |
| Media type | `MediaType:Image` | Filter by type (Image, Video, Document, Audio) |
| Subtype | `DocSubType:Standard Image` | Filter by document subtype |
| Boolean | `Keyword:beach AND NOT Keyword:France` | Combine with AND, OR, NOT |
| Phrase | `Text:"red carpet" AND Cannes` | Exact phrase match |
| Grouped | `Text:("red carpet" AND Cannes) OR Celebrity` | Grouped boolean |
| Keyword type | `Keyword(Common):orange AND NOT Keyword(Geography):orange` | Type-specific keyword |
| Native keyword | `NativeKeyword:France` | Only directly assigned (no inheritance) |
| Field-specific | `Title:sunset` | Search specific metadata field |

### Common Fields to Request

Use the `fields` parameter (comma-separated) to control what comes back:

| Field | Description |
|-------|-------------|
| `SystemIdentifier` | Unique asset ID |
| `MediaEncryptedIdentifier` | Encrypted ID for link generation |
| `Title` | Asset title |
| `Description` | Asset description |
| `path_TR1` | Thumbnail/preview URL |
| `Keywords` | Assigned keywords |
| `MediaType` | Image, Video, Document, Audio |
| `DocSubType` | Specific subtype |
| `DateCreated` | Creation date |
| `DateModified` | Last modified date |
| `OriginalFileName` | Original filename |
| `FileSize` | File size |
| `Width` | Image width |
| `Height` | Image height |

### Search Examples

```bash
# Find all images with keyword "kitchen"
curl -X POST /api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"Keyword:kitchen AND MediaType:Image","fields":"SystemIdentifier,Title,path_TR1","pageSize":10}'

# Free text search
curl -X POST /api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"Text:modern home exterior","fields":"SystemIdentifier,Title,path_TR1,Description"}'

# Find SVG illustrations
curl -X POST /api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"Text:illustration AND DocSubType:Vector","fields":"SystemIdentifier,Title,path_TR1"}'
```

## Get Asset Link

### Single link: `GET /api/dam/asset/:identifier/link`

Query params: `format`, `maxWidth`, `maxHeight`, `fileExtension`, `createDownloadLink`

```bash
# Get a web-ready link (max 1200px wide)
curl "/api/dam/asset/ABC123/link?format=Web&maxWidth=1200"

# Get original download link
curl "/api/dam/asset/ABC123/link?createDownloadLink=true"
```

### Multiple formats: `POST /api/dam/asset/:identifier/links`

```json
{
  "formats": [
    { "format": "Web", "maxWidth": 800, "maxHeight": 600 },
    { "format": "Original", "createDownloadLink": true }
  ]
}
```

## Upload Assets

### File upload: `POST /api/dam/upload`

Multipart form data with fields:
- `files` — the file(s) to upload
- `folderRecordID` — target folder ID in the DAM
- `processAssetInBackground` — `true` for async (faster), `false` for sync

```bash
curl -X POST /api/dam/upload \
  -F "files=@/path/to/image.jpg" \
  -F "folderRecordID=FOLDER_ID"
```

Response: `{ "uploadResults": [{ "fileName": "image.jpg", "isSuccess": true, "fileIdentifier": "NEW_ID" }] }`

### URL upload: `POST /api/dam/upload-url`

```json
{
  "folderRecordID": "FOLDER_ID",
  "fileURL": "https://example.com/image.jpg",
  "fileName": "image.jpg",
  "importMode": "Copy"
}
```

## List Available Fields

### `GET /api/dam/fields`

Returns all metadata fields available for search and display. Use this to discover field names for the `fields` parameter in search calls.

## Typical Agent Workflows

### Find an asset for a design

1. `POST /api/dam/search` with relevant query
2. Review results, pick the best match
3. `GET /api/dam/asset/{id}/link?format=Web&maxWidth=1200` to get a usable URL
4. Use the URL in the design

### Upload a new asset

1. `POST /api/dam/upload` with the file and target folder
2. Note the `fileIdentifier` from the response
3. Optionally search for it to confirm ingestion

### Browse available assets

1. `GET /api/dam/fields` to see what metadata is available
2. `POST /api/dam/search` with broad query and relevant fields
3. Refine query based on results

## Error Handling

| Status | Meaning | Action |
|--------|---------|--------|
| 401 | Token expired or invalid | Server auto-refreshes; retry once |
| 403 | URL too long (GET) | Switch to POST |
| 404 | Asset not found | Verify identifier |
| 429 | Rate limited | Wait and retry |

## Implementation Files

- `server/orangelogic.ts` — API client + proxy routes
- `.agents/skills/orangelogic-dam/SKILL.md` — this file
- `.agents/skills/orangelogic-dam/references/api-reference.md` — detailed API docs
