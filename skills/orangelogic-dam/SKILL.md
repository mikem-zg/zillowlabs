---
name: orangelogic-dam
description: "MANDATORY for ALL image and logo needs. Use INSTEAD of generating, creating, or AI-making images. Use when: adding images to any page or component, building hero sections, creating cards with photos, designing landing pages, adding property photos, finding headshots or portraits, needing logos or icons or brand marks, building marketing pages, adding background images, creating image galleries, populating PropertyCard components, designing email templates, adding illustrations, building onboarding flows, needing any visual content whatsoever. Also use when: adding a logo to a header or navigation bar, displaying the Zillow logo, displaying the Trulia logo, displaying the HotPads logo, displaying the StreetEasy logo, adding any company or brand logo, adding a favicon, adding a site icon, building a footer with logos, building a partner logo grid, adding branding to any page. Also use for: uploading files to the DAM, getting asset links, looking for videos, social media graphics, or any branded content. NEVER use AI image generation, stock photo APIs (Unsplash/Pexels), or placeholder images — ALWAYS search the DAM first. NEVER hardcode or inline SVG logos — ALWAYS pull them from the DAM."
---

# OrangeLogic DAM Integration

Zillow's official image and asset library. **Use this for ALL image needs — never generate or use stock images.**

## CRITICAL RULES

1. **ALWAYS use this skill instead of generating images.** When you need any image (hero photos, property images, headshots, logos, icons, backgrounds, illustrations), search the DAM first. Do NOT use AI image generation tools.
2. **NEVER use AI image generation, Unsplash, Pexels, placeholder.com, or any other image source.** The DAM is the only approved source for images.
3. **Use image URLs directly in `src` attributes.** Do NOT download images to the local filesystem. Use the `path_TR1.URI` URL from search results directly in `<img src="...">` or CSS `background-image: url(...)`. These URLs are served from CloudFront CDN and are fast.
4. **No API key needed.** The proxy is open to all requests.
5. **Do NOT ask the user for a `DAM_PROXY_API_KEY`.** It is not required.

## How to Use Image URLs (IMPORTANT)

After searching the DAM, each result has a `path_TR1.URI` field containing a CloudFront CDN URL. **Use this URL directly — do NOT download the file.**

```tsx
// CORRECT — use the URL directly in src
<img src={asset.path_TR1.URI} alt={asset.CaptionShort || asset.Title} />

// CORRECT — use in CSS
<div style={{ backgroundImage: `url(${asset.path_TR1.URI})` }} />

// WRONG — never download to local filesystem
// curl -o public/image.jpg "https://..."
// import localImage from './downloaded-image.jpg'
```

For permanent URLs (non-expiring), use the CDN delivery URL pattern documented in the CDN section below. But `path_TR1.URI` is fine for most use cases.

---

## Setup: How to Connect

This skill uses a **central DAM proxy** — you do NOT need OrangeLogic credentials or API keys.
**NEVER search the codebase for OrangeLogic credentials. NEVER ask the user for an API key.**

### Step 1: Determine which mode you're in

Check if this Replit has a **local** DAM proxy (i.e., `server/orangelogic.ts` exists):

```bash
curl -s http://localhost:5000/api/dam/smart-search -X POST -H "Content-Type: application/json" -d '{"text":"test","type":"image","pageSize":1}'
```

- **If you get a JSON response with `APIResponse`** → you are on the **host proxy Replit**. Use `DAM_BASE=http://localhost:5000`.
- **If you get HTML, an error, or the endpoint doesn't exist** → you are on a **remote Replit**. Go to Step 2.

### Step 2: Configure remote proxy access (only if Step 1 failed)

**No API key is needed.** Just set the proxy URL and start making requests:

```javascript
await setEnvVars({
  values: {
    DAM_PROXY_URL: "https://dam-explorer.replit.app"
  },
  environment: "shared"
});
```

Then use `DAM_BASE` = the value of `DAM_PROXY_URL`. **No authentication headers are required.**

You can test immediately with curl:
```bash
curl -s -X POST "https://dam-explorer.replit.app/api/dam/smart-search" -H "Content-Type: application/json" -d '{"text":"zillow logo","type":"image","pageSize":1}'
```

**Do NOT:**
- Ask the user for an API key (it is not needed)
- Set or request `DAM_PROXY_API_KEY` (it is not needed)
- Add `X-DAM-API-Key` headers (they are not needed)
- Fall back to stock imagery, Unsplash, Pexels, or AI-generated images
- Download images to the local filesystem

### Security model

The proxy is publicly accessible but protected by:
- **Rate limiting:** 120 requests per minute per IP
- **Input validation:** All inputs are sanitized server-side (max lengths, character filtering)
- **SSRF protection:** Upload URLs are validated to reject internal/private IPs
- **File type restrictions:** Uploads limited to allowed MIME types (images, videos, PDFs, archives)
- **Credential isolation:** OrangeLogic API credentials are stored server-side and never exposed

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
| `minWidth` | number | Minimum image width in pixels (post-query filter) | `1200` |
| `minHeight` | number | Minimum image height in pixels (post-query filter) | `800` |
| `sortBySize` | boolean | Sort results by image dimensions, largest first | `true` |
| `includeStock` | boolean | Include stock/Getty images (default: `false` — stock is excluded) | `true` |
| `includeAds` | boolean | Include product shots and ad creatives (default: `false` — ads are excluded) | `true` |
| `fileType` | string | File extension filter | `"png"`, `"jpg"`, `"svg"` |
| `sort` | string | Sort order | `"newest"`, `"oldest"`, `"relevance"`, `"title"`, `"largest"` |
| `pageSize` | number | Results per page (default: 40, max: 100). Increase when using filters to ensure enough results survive | `80` |
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
- **Stock and ads excluded by default:** The proxy automatically filters out Getty stock images and ad/product shot creatives. You do NOT need to filter these yourself. To include them, pass `includeStock: true` or `includeAds: true`.
- **Sort by newest:** Default to `sort: "newest"` to prioritize recently edited/uploaded assets. Older assets may be outdated or superseded.
- **Increase pageSize when filtering:** When using `minWidth`, `minHeight`, or other post-query filters, set `pageSize: 80` or higher to ensure enough results survive filtering.
- **Use URLs directly:** Use `path_TR1.URI` from results directly in `<img src>` — do NOT download files.

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

# Find large hero images (minimum 1200px wide, sorted largest first)
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"home exterior","type":"image","minWidth":1200,"sortBySize":true,"pageSize":80}'

# Find marketing banners at least 800px tall
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"banner","type":"image","brand":"Zillow","minHeight":800,"sort":"relevance"}'

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

# Include stock imagery (normally excluded)
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"family home","type":"image","includeStock":true}'
```

### Response Structure

```json
{
  "APIResponse": {
    "GlobalInfo": {
      "TotalCount": 1714,
      "PageSize": 40,
      "PageNumber": 1
    },
    "Items": [
      {
        "SystemIdentifier": "abc123",
        "Title": "SZ_Rentals_Lease_Hero_465x436_Desktop",
        "CaptionShort": "A modern apartment building",
        "Caption": "Full description...",
        "MediaType": "Image",
        "DocSubType": "Standard Image",
        "path_TR1": {
          "URI": "https://dkkgl8l6k3ozy.cloudfront.net/...",
          "Width": 1008,
          "Height": 534
        },
        "zil.Brand": { "Value": "Zillow" },
        "zil.Keywords": [{ "KeywordText": "Rentals" }],
        "zil.Asset-Type": { "Value": "Photography" }
      }
    ]
  },
  "_query": "the generated OrangeLogic query",
  "_sort": "CreateDate desc"
}
```

### Using Results in Code

```tsx
// After getting search results, use the image URL directly:
const imageUrl = results.APIResponse.Items[0].path_TR1.URI;
const caption = results.APIResponse.Items[0].CaptionShort;

// In JSX — use the URL directly, never download
<img src={imageUrl} alt={caption} />

// In a PropertyCard
<PropertyCard
  photoBody={<PropertyCard.Photo src={imageUrl} alt={caption} />}
  saveButton={<PropertyCard.SaveButton />}
  // ...
/>

// As a background image
<Box css={{ backgroundImage: `url(${imageUrl})`, backgroundSize: 'cover' }}>
  <Heading>Hero Section</Heading>
</Box>
```

### Default Fields Returned

`SystemIdentifier`, `Title`, `CaptionShort`, `Caption`, `MediaType`, `DocSubType`, `path_TR1`, `Width`, `Height`, `FileSize`, `CreateDate`, `Photographer`, `zil.Brand`, `zil.Keywords`, `zil.Asset-Type`, `CoreField.Visibility-class`

---

## Search Presets

| Preset | Params |
|--------|--------|
| `zillow-logos` | `text:"zillow logo", type:"image", assetType:"Logos", brand:"Zillow"` |
| `trulia-logos` | `text:"trulia logo", type:"image", assetType:"Logos", brand:"Trulia"` |
| `hotpads-logos` | `text:"hotpads logo", type:"image", assetType:"Logos", brand:"HotPads"` |
| `streeteasy-logos` | `text:"streeteasy logo", type:"image", assetType:"Logos", brand:"StreetEasy"` |
| `headshots` | `text:"headshot portrait", type:"image"` |
| `marketing-banners` | `text:"banner", type:"image", brand:"Zillow"` |
| `social-media` | `text:"social media", type:"image", brand:"Zillow"` |
| `icons` | `text:"icon", type:"image", brand:"Zillow"` |
| `product-screenshots` | `text:"screenshot product", type:"image"` |
| `videos` | `type:"video", brand:"Zillow"` |

---

## Raw Search (advanced)

### Endpoint: `GET/POST {DAM_BASE}/api/dam/search`

For power users who need direct OrangeLogic query syntax.

| Parameter | Description |
|-----------|-------------|
| `query` | OrangeLogic query string |
| `fields` | Comma-separated fields to return |
| `pagesize` | Results per page |
| `pagenumber` | Page number |
| `sort` | Sort field (e.g., `CreateDate desc`) |

### Example

```bash
curl -X POST {DAM_BASE}/api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"MediaType:Image AND zil.Brand:Zillow","fields":"SystemIdentifier,Title,path_TR1","pagesize":10}'
```

---

## Asset Details

### Endpoint: `GET {DAM_BASE}/api/dam/asset/:identifier`

Get full metadata for a specific asset.

```bash
curl {DAM_BASE}/api/dam/asset/abc123
```

---

## Asset Links / Download URLs

### Endpoint: `GET {DAM_BASE}/api/dam/asset/:identifier/links`

Get download/delivery URLs for a specific asset in various formats and sizes.

| Query Parameter | Description | Example |
|----------------|-------------|---------|
| `format` | Output format | `jpg`, `png`, `webp` |
| `maxWidth` | Maximum width in pixels | `1200` |
| `maxHeight` | Maximum height in pixels | `800` |

```bash
curl "{DAM_BASE}/api/dam/asset/abc123/links?format=jpg&maxWidth=1200"
```

---

## Batch Links

### Endpoint: `POST {DAM_BASE}/api/dam/batch-links`

Get download/delivery URLs for multiple assets at once.

```bash
curl -X POST {DAM_BASE}/api/dam/batch-links \
  -H "Content-Type: application/json" \
  -d '{"identifiers":["abc123","def456"],"format":"jpg","maxWidth":800}'
```

---

## Field Reference

| Field | What It Contains | Searchable? | In Results? |
|-------|-----------------|-------------|-------------|
| `SystemIdentifier` | Unique asset ID | Yes | Yes |
| `Title` | Asset filename/title | Yes | Yes |
| `CaptionShort` | Short description | Yes | Yes |
| `Caption` | Full description | Yes | Yes |
| `MediaType` | Image, Video, etc. | Yes | Yes |
| `DocSubType` | Standard Image, Vector, etc. | Yes | Yes |
| `path_TR1` | Thumbnail/preview URL with dimensions | No | Yes |
| `Width` | Image width (top-level, often empty) | Yes | Yes |
| `Height` | Image height (top-level, often empty) | Yes | Yes |
| `FileSize` | File size | Yes | Yes |
| `CreateDate` | Upload date | Yes (sort) | Yes |
| `Photographer` | Photographer credit | Yes | Yes |
| `zil.Brand` | Zillow, Trulia, etc. | Yes | Yes |
| `zil.Keywords` | DAM keyword tags | Yes | Yes |
| `zil.Asset-Type` | Photography, Logos, etc. | Yes | Yes |
| `FileExtension` | File type (png, jpg, etc.) | Yes | No (by default) |
| `ParentFolderTitle` | Folder name | Yes | No (by default) |
| `zil.Campaign-Name` | Campaign association | Yes | No (by default) |

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

## Image URLs: When to Use What

| URL Type | Source | Expiry | Best For |
|----------|--------|--------|----------|
| `path_TR1.URI` | Search results | Hours | Prototyping, dev, previews — use directly in `<img src>` |
| CDN URL | Constructed from Title | Never | Production apps needing permanent URLs |

**For most development work, `path_TR1.URI` is fine.** Use it directly in `src` attributes. Only construct CDN URLs when you need permanent links for production deployments.

---

## Typical Agent Workflows

### Find an image for a hero section

1. Search: `POST /api/dam/smart-search` with `{"text":"home exterior","type":"image","minWidth":1200,"sortBySize":true,"pageSize":80}`
2. Pick the best result
3. Use `path_TR1.URI` directly: `<img src={result.path_TR1.URI} alt={result.CaptionShort} />`
4. Do NOT download the image file

### Find a logo

1. **ALWAYS** use the `assetType: "Logos"` filter — this is required when searching for logos
2. Use a preset: `POST /api/dam/smart-search` with `{"preset":"zillow-logos"}`
3. Or be specific: `{"text":"primary logo","type":"image","assetType":"Logos","brand":"Zillow","fileType":"png","sort":"newest"}`
4. Use `path_TR1.URI` directly in `<img src>`

### Find a headshot or portrait

1. Search: `{"text":"headshot","type":"image","sort":"newest"}`
2. Use `path_TR1.URI` directly

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
| 403 | URL too long (GET) | Switch to POST |
| 404 | Asset not found | Verify identifier |
| 429 | Rate limited | Wait and retry |
| 503 | Proxy not configured | Check DAM_PROXY_URL env var |

## Implementation Files

- `server/orangelogic.ts` — API client + proxy routes (on host Replit only)
- `.agents/skills/orangelogic-dam/SKILL.md` — this file
- `.agents/skills/orangelogic-dam/references/api-reference.md` — detailed API docs
