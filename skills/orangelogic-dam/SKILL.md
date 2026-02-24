---
name: orangelogic-dam
description: "Search, retrieve, and upload digital assets through the OrangeLogic DAM API. Use when the user asks to find images, photos, logos, icons, illustrations, videos, marketing assets, brand assets, or any visual content from Zillow's digital asset library. Also use when uploading files to the DAM, getting asset links for designs, looking for marketing materials, campaign assets, social media graphics, product screenshots, headshots, or any branded content. Covers smart search with friendly parameters, search presets, raw query syntax, asset link retrieval, metadata lookup, and file upload."
---

# OrangeLogic DAM Integration

Search, retrieve, and upload digital assets through Zillow's OrangeLogic digital asset library.

## Setup: How to Connect

This skill uses a **central DAM proxy** — you do NOT need OrangeLogic credentials in this Replit.
**NEVER search the codebase with `rg`, `grep`, or file reads for OrangeLogic credentials.**

### Step 1: Determine which mode you're in

Check if this Replit has a **local** DAM proxy (i.e., `server/orangelogic.ts` exists):

```bash
curl -s http://localhost:5000/api/dam/smart-search -X POST -H "Content-Type: application/json" -d '{"text":"test","type":"image","pageSize":1}'
```

- **If you get JSON search results** → you are on the **host proxy Replit**. Use `DAM_BASE=http://localhost:5000` with no API key needed.
- **If you get an error or the endpoint doesn't exist** → you are on a **remote Replit**. Use the central proxy. Go to Step 2.

### Step 2: Configure remote proxy access (only if Step 1 failed)

Set these env vars so the agent can reach the central DAM proxy:

```javascript
// Ask the user / project owner for the DAM_PROXY_API_KEY value
await setEnvVars({
  values: {
    DAM_PROXY_URL: "https://dam-explorer.replit.app"
  },
  environment: "shared"
});
// DAM_PROXY_API_KEY must be set separately as a secret — ask the project owner for the value
```

Then use `DAM_BASE` = the value of `DAM_PROXY_URL` and include the API key header in all requests.
The `DAM_PROXY_API_KEY` env var must be set as a secret — never hardcode it in source files.

**Remote requests MUST include the `X-DAM-API-Key` header.**

### Authentication for remote access

All external requests (from other Replits) must include:
```
X-DAM-API-Key: <value from DAM_PROXY_API_KEY env var>
```

Rate limit: 120 requests per minute per API key. Exceeding returns `429 Too Many Requests` with `Retry-After` header.

### Security notes

- The API key must be stored as a Replit secret, never hardcoded in source files
- All inputs are validated and sanitized server-side (max lengths, character filtering)
- Upload URLs are validated to prevent SSRF (internal/private IPs are rejected)
- File uploads are restricted to allowed MIME types (images, videos, PDFs, archives)
- Error responses return generic messages — check server logs for details

---

## RECOMMENDED: Smart Search (use this first)

### Endpoint: `POST {DAM_BASE}/api/dam/smart-search`

The smart search endpoint accepts friendly, natural parameters and automatically builds the correct OrangeLogic query. **Always prefer this over the raw search endpoint.**

### Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `text` | string | Free-text search across all fields | `"zillow logo"` |
| `type` | string | Media type (auto-normalized) | `"image"`, `"video"`, `"photo"`, `"document"` |
| `assetType` | string | DAM asset type filter (auto-normalized). **Use this to filter by content category** | `"Logos"`, `"Photography"`, `"Design Assets"` |
| `brand` | string | Filter by brand | `"Zillow"`, `"Trulia"`, `"HotPads"`, `"StreetEasy"` |
| `keywords` | string | Filter by DAM keywords/tags | `"Getty Migration Flow"` |
| `campaign` | string | Filter by campaign name | `"Super Bowl 2026"` |
| `folder` | string | Filter by parent folder title | `"Logos"` |
| `minWidth` | number | **Avoid** — causes server-side parsing errors. Filter dimensions client-side instead | `1200` |
| `minHeight` | number | **Avoid** — causes server-side parsing errors. Filter dimensions client-side instead | `800` |
| `fileType` | string | File extension filter | `"png"`, `"jpg"`, `"svg"` |
| `sort` | string | Sort order | `"newest"`, `"oldest"`, `"relevance"`, `"title"`, `"largest"` |
| `pageSize` | number | Results per page (default: 40) | `20` |
| `pageNumber` | number | Page number (default: 1) | `2` |
| `preset` | string | Use a predefined search preset | `"zillow-logos"` |
| `fields` | string | Override returned fields | `"SystemIdentifier,Title,path_TR1"` |

### Type Aliases (auto-normalized)

| You can say | Resolves to |
|-------------|-------------|
| `image`, `images`, `photo`, `photos`, `picture`, `pictures` | `Image` |
| `video`, `videos` | `Video` |
| `multimedia` | `Multimedia` |
| `document`, `documents` | `Document` |
| `audio` | `Audio` |

### Asset Type Values (auto-normalized via `assetType` parameter)

| Value | Aliases | Count |
|-------|---------|-------|
| `Photography` | `photos` | ~2,324 |
| `Design Assets` | `design` | ~5,402 |
| `Icon` | `icons` | ~2,039 |
| `Illustration` | `illustrations` | ~2,672 |
| `Logos` | `logo` | ~1,076 |
| `Migrated` | — | ~6,167 |
| `GIF` | `gifs` | ~258 |
| `Testimonials` | `testimonial` | ~54 |
| `Brand Assets` | — | ~1,171 |
| `Copy` | — | ~859 |
| `Commercials` | `commercial` | ~59 |
| `How To` | — | ~109 |

**Important rules:**
- **Logos:** When searching for logos, ALWAYS set `assetType: "Logos"` to filter by the Logos category first. This prevents stock imagery and unrelated results from polluting results.
- **Avoid stock imagery:** Prefer `assetType: "Photography"` or `assetType: "Design Assets"` over unfiltered searches. Assets with `zil.Keywords` containing `"Getty Migration Flow"` are migrated stock — avoid these when Zillow-produced assets are available.
- **Sort by newest:** Default to `sort: "newest"` to prioritize recently edited/uploaded assets. Older assets may be outdated or superseded.

### Sort Options

| Value | Description |
|-------|-------------|
| `newest` | Most recently created first (default) |
| `oldest` | Oldest first |
| `relevance` | Best match first |
| `title` | Alphabetical A-Z |
| `title-desc` | Alphabetical Z-A |
| `largest` | Largest file size first |
| `smallest` | Smallest file size first |

### Smart Search Examples

```bash
# Find Zillow logos (images only)
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"logo","type":"image","brand":"Zillow","sort":"relevance"}'

# Find marketing banners (filter dimensions client-side from path_TR1.Width/Height)
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"banner","type":"image","brand":"Zillow","sort":"relevance"}'

# Find headshots/portraits
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"headshot portrait","type":"image","sort":"newest"}'

# Find PNG icons
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"icon","type":"image","brand":"Zillow","fileType":"png"}'

# Find Zillow videos
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"type":"video","brand":"Zillow","sort":"newest"}'

# Use a preset
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"preset":"zillow-logos"}'
```

### Response Structure

```json
{
  "APIResponse": {
    "GlobalInfo": {
      "TotalCount": 1714,
      "QueryDurationMilliseconds": 257
    },
    "Items": [
      {
        "SystemIdentifier": "ZI12QDL",
        "Title": "Zillow_Primary Logo_1024x1024",
        "CaptionShort": "Zillow primary logo",
        "MediaType": "Image",
        "path_TR1": {
          "URI": "https://dkkgl8l6k3ozy.cloudfront.net/...",
          "Width": 1024,
          "Height": 1024
        },
        "zil.Brand": [{"Value": "Zillow"}],
        "zil.Keywords": [{"Value": "Logo"}]
      }
    ]
  },
  "_query": "Text:logo AND MediaType:Image AND zil.Brand:Zillow",
  "_sort": "Relevancy"
}
```

### Default Fields Returned

Smart search returns these fields automatically (override with `fields` parameter):
`SystemIdentifier`, `Title`, `CaptionShort`, `Caption`, `MediaType`, `DocSubType`, `path_TR1`, `Width`, `Height`, `FileSize`, `CreateDate`, `Photographer`, `zil.Brand`, `zil.Keywords`, `zil.Asset-Type`, `CoreField.Visibility-class`

**Visibility filtering:** Smart search automatically filters results to only include assets with `CoreField.Visibility-class` = `"Approved"`. Non-approved assets (e.g., "Collection") are excluded from results. This cannot be done via the query syntax (the hyphenated field name causes parsing errors), so it is applied as a post-query filter.

---

## Search Presets

### Endpoint: `GET {DAM_BASE}/api/dam/presets`

Returns all available search presets. Use these for common asset discovery tasks.

### Available Presets

| Preset ID | Description | Query Built |
|-----------|-------------|-------------|
| `zillow-logos` | Zillow brand logos | `Text:zillow logo AND MediaType:Image AND zil.Brand:Zillow` |
| `trulia-logos` | Trulia brand logos | `Text:trulia logo AND MediaType:Image AND zil.Brand:Trulia` |
| `hotpads-logos` | HotPads brand logos | `Text:hotpads logo AND MediaType:Image AND zil.Brand:HotPads` |
| `streeteasy-logos` | StreetEasy brand logos | `Text:streeteasy logo AND MediaType:Image AND zil.Brand:StreetEasy` |
| `headshots` | Portrait/headshot photos | `Text:headshot portrait AND MediaType:Image` |
| `marketing-banners` | Marketing display banners | `Text:banner AND MediaType:Image AND zil.Brand:Zillow` |
| `social-media` | Social media graphics | `Text:social media AND MediaType:Image AND zil.Brand:Zillow` |
| `icons` | UI/brand icons | `Text:icon AND MediaType:Image AND zil.Brand:Zillow` |
| `product-screenshots` | Product screenshots | `Text:screenshot product AND MediaType:Image` |
| `videos` | Zillow videos | `MediaType:Video AND zil.Brand:Zillow` |

Presets can be combined with additional filters:
```bash
# Use zillow-logos preset but only get PNGs
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"preset":"zillow-logos","fileType":"png"}'
```

---

## Key Searchable Fields

These are the most useful fields for filtering and displaying DAM assets:

### Content Fields
| Field | Description | Searchable | Returnable |
|-------|-------------|-----------|------------|
| `SystemIdentifier` | Unique asset ID (e.g., "ZI12QDL") | Yes | Yes |
| `Title` | Asset title | Yes | Yes |
| `CaptionShort` | Short headline | Yes | Yes |
| `Caption` | Full description | Yes | Yes |
| `MediaType` | Asset type: Image, Video, Document, Audio, Multimedia | Yes | Yes |
| `DocSubType` | Document subtype | Yes | Yes |

### Zillow-Specific Fields
| Field | Description | Searchable | Returnable |
|-------|-------------|-----------|------------|
| `zil.Brand` | Brand: Zillow, Trulia, HotPads, StreetEasy, etc. | Yes | Yes (array) |
| `zil.Keywords` | Zillow-assigned tags/keywords | Yes | Yes (array) |
| `zil.Asset-Type` | Asset category: Photography, Design Assets, Icon, Illustration, Logos, GIF, Testimonials, Brand Assets, Copy, Commercials, How To, Migrated | Yes | Yes |
| `CoreField.Visibility-class` | Approval status: `Approved`, `Collection`. Smart search auto-filters to Approved only | No (filter post-query) | Yes |
| `RelatedValue.Campaign-Name-(related)` | Associated campaign name | Yes | Yes |
| `zil.Campaign-Target-Audience` | Campaign target audience | Yes | Yes |
| `Workspace.Category` | DAM category | Yes | Yes |
| `integration.Categories` | Integration categories | Yes | Yes |

### File/Technical Fields
| Field | Description | Searchable | Returnable |
|-------|-------------|-----------|------------|
| `path_TR1` | Thumbnail/preview URL with dimensions | No | Yes |
| `Width` | Original image width | Yes (range) | Yes |
| `Height` | Original image height | Yes (range) | Yes |
| `FileSize` | File size | Yes (range) | Yes |
| `FileExtension` | File format (png, jpg, svg, etc.) | Yes | Yes |
| `CreateDate` | When uploaded to DAM | Yes (range) | Yes |
| `MediaDate` | Original creation date | Yes (range) | Yes |

### Attribution Fields
| Field | Description | Searchable | Returnable |
|-------|-------------|-----------|------------|
| `Photographer` | Source/creator name | Yes | Yes |
| `copyright` | Copyright info | Yes | Yes |
| `CreatedBy` | Upload user | Yes | Yes |

### Navigation Fields
| Field | Description | Searchable | Returnable |
|-------|-------------|-----------|------------|
| `ParentFolderTitle` | Parent folder name | Yes | Yes |
| `ParentFolderIdentifier` | Parent folder ID | Yes | Yes |

---

## Raw Search (advanced)

### Endpoint: `POST {DAM_BASE}/api/dam/search`

Use this when you need full control over the OrangeLogic query syntax.

```json
{
  "query": "Text:modern kitchen AND MediaType:Image AND zil.Brand:Zillow",
  "fields": "SystemIdentifier,Title,path_TR1,zil.Brand",
  "pageSize": 20,
  "pageNumber": 1,
  "sort": "CreateDate:Descending"
}
```

### Query Syntax Reference

| Pattern | Example | Description |
|---------|---------|-------------|
| Free text | `Text:modern kitchen` | Search across all text fields |
| Field filter | `MediaType:Image` | Exact field match |
| Brand filter | `zil.Brand:Zillow` | Filter by Zillow brand |
| Boolean AND | `Text:logo AND MediaType:Image` | Both conditions required |
| Boolean OR | `MediaType:Image OR MediaType:Video` | Either condition |
| Boolean NOT | `Text:banner AND NOT Text:social` | Exclude matches |
| Phrase | `Text:"red carpet"` | Exact phrase match |
| Range | `Width>=1200` | Numeric comparison |
| Grouped | `(Text:logo OR Text:icon) AND zil.Brand:Zillow` | Grouped boolean |

---

## Get Asset Link

### Single link: `GET {DAM_BASE}/api/dam/asset/:identifier/link`

Query params: `format`, `maxWidth`, `maxHeight`, `fileExtension`, `createDownloadLink`

```bash
curl "{DAM_BASE}/api/dam/asset/ZI12QDL/link?format=Web&maxWidth=1200"
```

### Multiple formats: `POST {DAM_BASE}/api/dam/asset/:identifier/links`

```json
{
  "formats": [
    { "format": "Web", "maxWidth": 800, "maxHeight": 600 },
    { "format": "Original", "createDownloadLink": true }
  ]
}
```

---

## Upload Assets

### File upload: `POST {DAM_BASE}/api/dam/upload`

Multipart form data: `files` (file), `folderRecordID` (string), `processAssetInBackground` (bool)

### URL upload: `POST {DAM_BASE}/api/dam/upload-url`

```json
{
  "folderRecordID": "FOLDER_ID",
  "fileURL": "https://example.com/image.jpg",
  "fileName": "image.jpg",
  "importMode": "Copy"
}
```

---

## List Available Fields

### `GET {DAM_BASE}/api/dam/fields`

Returns all 894 metadata fields available in the DAM. Use to discover additional field names for search and retrieval.

---

## CDN Delivery URLs (Permanent)

The DAM has a public CDN layer that serves **permanent, non-expiring URLs** for Zillow-produced assets. Always prefer these over the signed `path_TR1.URI` CloudFront URLs, which expire within hours.

### CDN URL Format

```
https://delivery.digitallibrary.zillowgroup.com/public/{Title}_{ext}_{format}.auto
```

| Parameter | Description | Examples |
|-----------|-------------|---------|
| `{Title}` | The asset's `Title` field from search results | `SZ_Rentals_Lease_Hero_465x436_Desktop` |
| `{ext}` | File extension | `png`, `jpg` |
| `{format}` | Size format | `CMS_Extra_Large`, `CMS_Large`, `CMS_Medium` |

### Example

```
https://delivery.digitallibrary.zillowgroup.com/public/SZ_Rentals_Lease_Hero_465x436_Desktop_png_CMS_Extra_Large.auto
```

### CDN URL Rules (Critical)

| Rule | Details |
|------|---------|
| Only `SZ_` assets | Only Zillow-produced assets (titles starting with `SZ_`) reliably have CDN URLs. Getty stock photos with numeric titles (e.g., `2224111854`) return 404 |
| No spaces in titles | Titles must NOT contain spaces or special characters (`&`, etc.). Titles with only underscores, hyphens, and dots work. Spaces → 404 |
| Always test first | Verify with `curl -o /dev/null -w "%{http_code}" "{url}"` before using in production |
| Prefer `png` | Use `png` extension for most Zillow assets (even if the thumbnail appears as jpg). Try `png` first, fall back to `jpg` |
| Format quality | `CMS_Extra_Large` is highest quality. Use `CMS_Large` or `CMS_Medium` for smaller sizes |

---

## Image URLs: Temporary vs Permanent

### `path_TR1.URI` — Temporary (signed CloudFront URLs)

The `path_TR1.URI` field in search results returns signed CloudFront URLs that **expire within hours**. These are useful for previewing results but should NOT be used in production UI.

### CDN delivery URLs — Permanent

Use the CDN URL pattern above for permanent image references. Only works for `SZ_`-prefixed assets without spaces in titles.

### Fallback: Download locally

For assets that don't have CDN URLs (Getty stock with numeric titles, or titles containing spaces/special characters), download via `path_TR1.URI` and save locally:

```bash
curl -o public/assets/image-name.jpg "https://dkkgl8l6k3ozy.cloudfront.net/..."
```

### Distinguishing asset types

| Indicator | Meaning |
|-----------|---------|
| `SZ_` title prefix | Zillow-produced marketing asset — has CDN URL |
| Numeric title (e.g., `2224111854`) | Getty stock photo — no CDN URL, download locally |
| Square aspect ratio | Often clip art or icons, not real photography |
| Large dimensions (800+ px) | Adequate resolution for UI usage |

---

## Typical Agent Workflows

### Find the best asset for a design

1. Start with smart search: `POST /api/dam/smart-search` with `text`, `type`, `brand`, and **always include `assetType`** to filter by content category (e.g., `"Photography"`, `"Design Assets"`, `"Illustration"`)
2. **Sort by `"newest"`** to prioritize recently edited/uploaded assets
3. Review results — skip assets with `zil.Keywords` containing `"Getty Migration Flow"` (migrated stock imagery). Prefer Zillow-produced assets (`SZ_` title prefix)
4. Check `path_TR1.Width` and `path_TR1.Height` for adequate resolution (800+ px). Do NOT use `minWidth`/`minHeight` query parameters (they cause server-side parsing errors); filter dimensions client-side instead
5. Prefer assets with `SZ_` titles (no spaces) — these have permanent CDN delivery URLs
6. Pick the best match
7. Construct the CDN URL: `https://delivery.digitallibrary.zillowgroup.com/public/{Title}_{ext}_{format}.auto`
8. Test the CDN URL with `curl -o /dev/null -w "%{http_code}" "{url}"`. If 404, fall back to downloading via `path_TR1.URI` and saving locally

### Find a logo

1. **ALWAYS** use the `assetType: "Logos"` filter — this is required when searching for logos
2. Use a preset: `POST /api/dam/smart-search` with `{"preset":"zillow-logos"}` (presets now include `assetType: "Logos"` automatically)
3. Or be specific: `{"text":"primary logo","type":"image","assetType":"Logos","brand":"Zillow","fileType":"png","sort":"newest"}`

### Browse by category

1. Use `assetType` to filter by content category: `{"assetType":"Photography","brand":"Zillow","sort":"newest"}`
2. Narrow down with text: `{"text":"banner","assetType":"Design Assets","brand":"Zillow","type":"image"}`

### Upload a new asset

1. `POST /api/dam/upload` with the file and target folder
2. Note the `fileIdentifier` from the response

---

## Error Handling

| Status | Meaning | Action |
|--------|---------|--------|
| 401 | Missing or invalid API key (remote) | Check X-DAM-API-Key header |
| 403 | URL too long (GET) | Switch to POST |
| 404 | Asset not found | Verify identifier |
| 429 | Rate limited | Wait and retry |
| 503 | Proxy not configured | Check DAM_PROXY_URL env var |

## Implementation Files

- `server/orangelogic.ts` — API client + proxy routes (on host Replit only)
- `.agents/skills/orangelogic-dam/SKILL.md` — this file
- `.agents/skills/orangelogic-dam/references/api-reference.md` — detailed API docs
