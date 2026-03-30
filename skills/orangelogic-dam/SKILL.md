---
name: orangelogic-dam
description: "MANDATORY for ALL image and logo needs. Use INSTEAD of generating, creating, or AI-making images. Use when: adding images to any page or component, building hero sections, creating cards with photos, designing landing pages, adding property photos, finding headshots or portraits, needing logos or icons or brand marks, building marketing pages, adding background images, creating image galleries, populating PropertyCard components, designing email templates, adding illustrations, building onboarding flows, needing any visual content whatsoever. Also use when: adding a logo to a header or navigation bar, displaying the Zillow logo, displaying the Trulia logo, displaying the HotPads logo, displaying the StreetEasy logo, adding any company or brand logo, adding a favicon, adding a site icon, building a footer with logos, building a partner logo grid, adding branding to any page. Also use for: uploading files to the DAM, getting asset links, looking for videos, social media graphics, or any branded content. NEVER use AI image generation, stock photo APIs (Unsplash/Pexels), or placeholder images — ALWAYS search the DAM first. NEVER hardcode or inline SVG logos — ALWAYS pull them from the DAM."
---

# OrangeLogic DAM Integration

Zillow's official image and asset library. **Use this for ALL image needs — never generate or use stock images.**

## CRITICAL RULES

1. **ALWAYS use this skill instead of generating images.** When you need any image (hero photos, headshots, logos, icons, backgrounds, illustrations), search the DAM first. Do NOT use AI image generation tools.
2. **NEVER use AI image generation, Unsplash, Pexels, placeholder.com, or any other image source.** The DAM is the only approved source for images. **One exception:** PropertyCard listing images may be AI-generated using the `property-card-data` skill — this is the only case where AI image generation is permitted.
3. **Signed URLs expire — NEVER hardcode them.** The `path_TR*.URI` URLs from search results are CloudFront signed URLs with an `Expires` parameter (~24 hours). After expiry, they return 403. For production apps, use the `getlink` API to generate proper embed links with controlled expiration (see "Get Public Link API" below). For prototyping, using `path_TR*.URI` directly is fine.
4. **No API key needed.** The proxy is open to all requests.
5. **Do NOT ask the user for a `DAM_PROXY_API_KEY`.** It is not required.
6. **Search queries should be broad.** DAM search is keyword-based, not semantic. Use 2-3 word queries, not full sentences. If a query returns zero results, simplify it (see "Search tips" below).
7. **Image dimensions are unreliable.** `ImageWidth` and `ImageHeight` fields frequently return `undefined`. Always set explicit dimensions via CSS and use `object-fit: cover`.
8. **Stock images are excluded by default.** Do NOT pass `includeStock: true` for production apps. Only use it for prototyping/mockups, and replace stock images with approved assets before shipping.

## How to Use Image URLs (IMPORTANT)

### Pick the Right Format

Search results return multiple `path_TR*` fields. Each is a different proxy format:

| Format | Extension | Best For | Why |
|--------|-----------|----------|-----|
| **`path_TR4`** | `.png` | Logos, icons, illustrations | Preserves transparency |
| **`path_TR1`** | `.jpg` | Photos, hero images, property images | Smaller file size |
| **`path_TRX`** | varies | Source file download | Original quality, largest file |
| **`path_TR7`** | `.jpg` | Thumbnails only | 192px height — too small for most UI |

**Default rule:** Use `path_TR4` (PNG) for anything that might have transparency (logos, icons, design assets). Use `path_TR1` (JPG) for photography.

To get multiple formats in one search, add them to the `fields` parameter:
```bash
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"zillow logo","type":"image","assetType":"Logos","pageSize":1,"fields":"SystemIdentifier,Title,path_TR1,path_TR4"}'
```

### Prototyping vs Production

**For prototyping/dev:** Use `path_TR4.URI` (logos) or `path_TR1.URI` (photos) directly — they work for ~24 hours.

**For production:** Use the `getlink` API to generate proper embed links with controlled expiration (see "Get Public Link API" section below). Or use the server-side proxy pattern.

```tsx
// PROTOTYPING — logo (use TR4 for PNG/transparency)
<img src={asset.path_TR4.URI} alt={asset.Title} />

// PROTOTYPING — photo (use TR1 for JPG)
<img src={asset.path_TR1.URI} alt={asset.CaptionShort || asset.Title} />

// PRODUCTION — use the getlink API via proxy for stable embed links
<img src={`${DAM_BASE}/api/dam/embed-link/${asset.SystemIdentifier}?format=TR4`} alt={asset.Title} />

// PRODUCTION — or use a server-side proxy endpoint
<img src="/api/dam/image/heroBuy" alt="Family in new home" />

// WRONG — never download to local filesystem
// curl -o public/image.jpg "https://..."

// WRONG — never hardcode a signed URL in source code
// const heroUrl = "https://dkkgl8l6k3ozy.cloudfront.net/...&Expires=1711234567&..."
```

## Search Tips

DAM search is keyword-based, not semantic. Use broad, simple queries (2-3 words) rather than specific phrases:

| Instead of | Try |
|---|---|
| "young couple searching for their first home" | "couple house hunting" |
| "real estate agent showing property to interested buyers" | "home tour open house" |
| "professionally staged living room for sale" | "home staging interior" |

If a query returns zero results, simplify it. Try individual keywords or pairs.

## Image Dimensions

Image dimension metadata (`ImageWidth`, `ImageHeight`) is unreliable — many assets return `undefined` for these fields. Always set explicit dimensions via CSS and use `object-fit: cover` to handle unknown aspect ratios:

```tsx
<img
  src={imageUrl}
  alt={caption}
  style={{ width: '100%', height: '300px', objectFit: 'cover' }}
/>
```

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

## Content Browser SDK (Visual Asset Browser)

The OrangeLogic Content Browser SDK provides a full visual UI for browsing, searching, filtering, and selecting DAM assets — embedded directly in the page. This is the interactive counterpart to the programmatic smart-search API.

### Where it lives

The Content Browser is available at `/dam-browser` on the host proxy:

```
https://dam-explorer.replit.app/dam-browser
```

### When to use

| Need | Use |
|------|-----|
| **Interactive/visual browsing by humans** — searching, filtering, previewing, and selecting assets in a UI | Content Browser SDK |
| **Programmatic/agent use** — fetching images by query, populating components, automated workflows | Smart Search API (`POST /api/dam/smart-search`) |

### SDK token endpoint

The proxy exposes an authentication endpoint for the SDK:

```
GET {DAM_BASE}/api/dam/sdk-token
```

Returns:

```json
{
  "token": "...",
  "siteUrl": "https://digitallibrary.zillowgroup.com"
}
```

Use the `token` in the SDK's `onRequestToken` callback and `siteUrl` as the `baseUrl`.

### How to embed in other apps

Load the SDK assets from OrangeLogic's CDN and configure with the proxy's token endpoint:

```html
<!-- SDK assets — file names are OrangeDAMContentBrowserSDK (NOT OrangeDAMContentBrowser) -->
<link rel="stylesheet" href="https://downloads.orangelogic.com/ContentBrowserSDK/v2.2.0/OrangeDAMContentBrowserSDK.min.css" />
<script src="https://downloads.orangelogic.com/ContentBrowserSDK/v2.2.0/OrangeDAMContentBrowserSDK.min.js"></script>
```

```tsx
const DAM_BASE = "https://dam-explorer.replit.app";

const browser = new OrangeDAMContentBrowser({
  containerId: "dam-browser-container",
  baseUrl: "https://digitallibrary.zillowgroup.com",
  onAssetSelected: (asset) => {
    console.log("Selected asset:", asset);
  },
  onRequestToken: async () => {
    const res = await fetch(`${DAM_BASE}/api/dam/sdk-token`);
    const data = await res.json();
    return data.token;
  },
});
```

**Important:** The SDK file names are `OrangeDAMContentBrowserSDK.min.js` and `OrangeDAMContentBrowserSDK.min.css` — do NOT use `OrangeDAMContentBrowser.js` (that file does not exist).

### SDK configuration reference

| Option | Type | Description |
|--------|------|-------------|
| `containerId` | string | ID of the DOM element to render the browser into |
| `baseUrl` | string | DAM instance URL (`https://digitallibrary.zillowgroup.com`) |
| `onAssetSelected` | function | Callback when user selects an asset |
| `onRequestToken` | async function | Returns a fresh auth token from the proxy |
| `persistMode` | boolean | Persist search/filter state across sessions |
| `displayInfo` | boolean | Show asset info panel |
| `availableDocTypes` | string[] | Limit visible document types (e.g., `["Image", "Video"]`) |
| `extraFields` | string[] | Additional metadata fields to include in results |

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
- **Stock and ads excluded by default:** The proxy automatically filters out Getty stock images and ad/product shot creatives. This is the correct default for production apps — only use imagery Zillow owns or has licensed. Do NOT pass `includeStock: true` unless you are explicitly building a prototype, mockup, or internal tool where stock imagery is acceptable. For prototyping only, `includeStock: true` can help find placeholder images, but these must be replaced with approved assets before shipping. If default results are insufficient, flag it as a content gap rather than enabling stock images.
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
const item = results.APIResponse.Items[0];
const caption = item.CaptionShort || item.Title;

// LOGO / ICON — use path_TR4 (PNG, preserves transparency)
const logoUrl = item.path_TR4?.URI || item.path_TR1.URI;
<img src={logoUrl} alt={caption} />

// PHOTO — use path_TR1 (JPG, smaller file)
const photoUrl = item.path_TR1.URI;
<img src={photoUrl} alt={caption} />

// In a PropertyCard (photos → TR1)
<PropertyCard
  photoBody={<PropertyCard.Photo src={item.path_TR1.URI} alt={caption} />}
  saveButton={<PropertyCard.SaveButton />}
/>

// As a background image (photos → TR1)
<Box css={{ backgroundImage: `url(${item.path_TR1.URI})`, backgroundSize: 'cover' }}>
  <Heading>Hero Section</Heading>
</Box>
```

**Remember:** `path_TR4` (PNG) for logos/icons/illustrations. `path_TR1` (JPG) for photography. Request both via the `fields` parameter if you need both formats from one search.

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

## Asset Format Codes (TR1–TRX)

When you upload assets, OrangeLogic generates multiple proxy formats at different resolutions. These are identified by format codes used throughout the API — in search result fields (`path_TR1`, `path_TR4`), in the `getlink` API's `Format` parameter, and in CDN URLs.

### Zillow Instance Format Codes

| Code | Extension | Observed Dimensions | Use For |
|------|-----------|-------------------|---------|
| **`TR4`** | `.png` | Same as original (preserves full size) | **Logos, icons, illustrations** — preserves transparency |
| **`TR1`** | `.jpg` | Same as original (medium-res proxy) | **Photos, hero images** — smaller file size |
| **`TR7`** | `.jpg` | 192px fixed height | **Thumbnails only** — too small for most UI |
| **`TRX`** | varies | Original source dimensions | **Downloads** — largest file, original quality |
| **`WebHigh`** | video | Video proxy | **Video embeds** |

**Which format to pick:**
- **Logos, icons, design assets →** `TR4` (PNG preserves transparency)
- **Photography, hero images →** `TR1` (JPG, smaller file)
- **Tiny previews, grid thumbnails →** `TR7` (192px height)
- **Full-quality download →** `TRX` (original source)

**Note:** The search API returns `path_TR1` by default. To get `path_TR4` (PNG), add it to the `fields` parameter:

```bash
curl -X POST {DAM_BASE}/api/dam/smart-search \
  -H "Content-Type: application/json" \
  -d '{"text":"zillow logo","type":"image","assetType":"Logos","pageSize":1,"fields":"SystemIdentifier,Title,path_TR1,path_TR4"}'
```

---

## Get Public Link API (Embed & Download Links)

The OrangeLogic `getlink` API generates public CDN-distributed links to individual assets. These links can be configured with specific dimensions, file formats, and expiration dates. **This is the proper way to generate stable, embeddable URLs for production use.**

### Single Asset Link

```
GET https://{OrangeLogicURL}/webapi/objectmanagement/share/getlink_4HZ_v1
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Identifier` | string | Yes | The asset's `SystemIdentifier` (e.g., `CTL531031`) |
| `Format` | string | Yes | Asset format code: `TR1`, `TR4`, `TR7`, `TRX`, `WebHigh` |
| `MaxWidth` | integer | No | Maximum pixel width of the delivered asset |
| `MaxHeight` | integer | No | Maximum pixel height of the delivered asset |
| `FileExtension` | string | No | Output format: `.png`, `.jpg`, `.webp` |
| `ExpirationDate` | ISO 8601 | No | Link expiry date (e.g., `2026-12-31T23:59:59`) |
| `CreateDownloadLink` | boolean | No | `true` = download link; `false` = embed/view-only link |
| `StickToCurrentVersion` | boolean | No | Pin link to the current asset version (`true`/`false`) |
| `LogViews` | boolean | No | Record a view event when the link is accessed |

```bash
curl "https://digitallibrary.zillowgroup.com/webapi/objectmanagement/share/getlink_4HZ_v1\
?Identifier=CTL531031\
&Format=TR1\
&MaxWidth=1200\
&FileExtension=.png\
&CreateDownloadLink=false\
&ExpirationDate=2026-12-31T23:59:59" \
  -H "Authorization: Bearer {token}"
```

**Via the proxy** (no auth needed):

```bash
curl "{DAM_BASE}/api/dam/asset/CTL531031/links?format=png&maxWidth=1200"
```

### When to use `getlink` vs `path_TR1.URI`

| Scenario | Use |
|----------|-----|
| Prototyping, quick dev | `path_TR1.URI` from search results (expires in ~24h) |
| Production embeds | `getlink` API with a far-future `ExpirationDate` |
| Download buttons | `getlink` with `CreateDownloadLink=true` |
| Specific dimensions | `getlink` with `MaxWidth`/`MaxHeight` |
| Format conversion | `getlink` with `FileExtension` (e.g., `.webp`) |

### Batch Public Links (Multiple Assets)

For multiple assets, **always use the batch endpoint** — it is less costly than calling `getlink` repeatedly.

```
POST https://{OrangeLogicURL}/webapi/objectmanagement/share/getlinks_45W_v1
```

Request body:

```json
{
  "assets": [
    {
      "Identifier": "CTL531031",
      "Format": "TR1",
      "MaxWidth": 800,
      "FileExtension": ".jpg",
      "CreateDownloadLink": false,
      "ExpirationDate": "2026-12-31T23:59:59"
    },
    {
      "Identifier": "CTL531032",
      "Format": "TR1",
      "MaxWidth": 800,
      "FileExtension": ".jpg",
      "CreateDownloadLink": false,
      "ExpirationDate": "2026-12-31T23:59:59"
    }
  ]
}
```

**Via the proxy** (no auth needed):

```bash
curl -X POST {DAM_BASE}/api/dam/batch-links \
  -H "Content-Type: application/json" \
  -d '{"identifiers":["CTL531031","CTL531032"],"format":"jpg","maxWidth":800}'
```

---

## Image Transformations

The `getlink` API supports image transformations — resize, crop, and format conversion — delivered through the CDN. Use these when you need responsive image variants, thumbnails, or format-optimized assets.

### Resizing

Set `MaxWidth` and/or `MaxHeight` to constrain the output. The image maintains its aspect ratio by default.

```bash
curl "{DAM_BASE}/api/dam/asset/CTL531031/links?maxWidth=600&maxHeight=400"
```

### Format Conversion

Use `FileExtension` to convert between formats:

| Extension | Use For |
|-----------|---------|
| `.png` | Logos, icons, transparent backgrounds |
| `.jpg` | Photos, hero images (smaller file size) |
| `.webp` | Modern browsers (best compression) |

```bash
curl "{DAM_BASE}/api/dam/asset/CTL531031/links?format=webp&maxWidth=1200"
```

### Responsive Images Pattern

Generate multiple sizes for `srcset`:

```tsx
<img
  src="/api/dam/asset/CTL531031/links?format=jpg&maxWidth=800"
  srcSet={`
    /api/dam/asset/CTL531031/links?format=jpg&maxWidth=400 400w,
    /api/dam/asset/CTL531031/links?format=jpg&maxWidth=800 800w,
    /api/dam/asset/CTL531031/links?format=jpg&maxWidth=1200 1200w
  `}
  sizes="(max-width: 600px) 400px, (max-width: 1024px) 800px, 1200px"
  alt="Property exterior"
/>
```

---

## Raw Search (advanced)

### Endpoint: `GET/POST {DAM_BASE}/api/dam/search`

For power users who need direct OrangeLogic Search API v4 query syntax. **Most agents should use Smart Search instead** — it handles query building automatically.

| Parameter | Description |
|-----------|-------------|
| `query` | OrangeLogic query string (see syntax below) |
| `fields` | Comma-separated fields to return |
| `pagesize` | Results per page |
| `pagenumber` | Page number |
| `sort` | Sort field (e.g., `CreateDate desc`) |

### Query Syntax

Queries use `criterion:search_term` format. Combine criteria with operators.

| Syntax | Example |
|--------|---------|
| Single criterion | `Title:London` |
| AND (both must match) | `DocType:Image AND Title:London` |
| OR (either matches) | `Title:London OR Title:Paris` |
| NOT (exclude) | `DocType:Image AND NOT zil.Brand:Trulia` |
| Exact phrase | `Title:"Zillow logo primary"` |
| Multiple criteria | `MediaType:Image AND zil.Brand:Zillow AND zil.Asset-Type:Photography` |

**Rules:**
- You **must** use operators (`AND`, `OR`, `NOT`) to combine multiple criteria
- You **cannot** use the `query` parameter multiple times in the same request (wrong: `query=X&query=Y`)
- Operators must be UPPERCASE
- Wrap multi-word values in double quotes

### Common Search Criteria

| Criterion | Description | Example |
|-----------|-------------|---------|
| `Title` | Asset filename/title | `Title:zillow` |
| `DocType` / `MediaType` | Asset type | `MediaType:Image` |
| `keyword` | DAM keyword tags | `keyword:rentals` |
| `zil.Brand` | Brand filter | `zil.Brand:Zillow` |
| `zil.Asset-Type` | Content category | `zil.Asset-Type:Photography` |
| `FileExtension` | File type | `FileExtension:png` |
| `ParentFolderTitle` | Folder name | `ParentFolderTitle:Logos` |

### Examples

```bash
curl -X POST {DAM_BASE}/api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"MediaType:Image AND zil.Brand:Zillow","fields":"SystemIdentifier,Title,path_TR1","pagesize":10}'

curl -X POST {DAM_BASE}/api/dam/search \
  -H "Content-Type: application/json" \
  -d '{"query":"MediaType:Image AND zil.Asset-Type:Logos AND zil.Brand:Zillow","fields":"SystemIdentifier,Title,path_TR1,path_TRX","pagesize":20,"sort":"CreateDate desc"}'
```

---

## Asset Details

### Endpoint: `GET {DAM_BASE}/api/dam/asset/:identifier`

Get full metadata for a specific asset.

```bash
curl {DAM_BASE}/api/dam/asset/abc123
```

---

## Upload API

OrangeLogic provides several upload methods depending on file size and source location.

### Upload Methods

| Use Case | Method | Endpoint |
|----------|--------|----------|
| File < 1.5 GB (local) | Simple upload | `POST /webapi/mediafile/import/upload/uploadmedia_4az_v1` |
| File > 1.5 GB (local) | Multi-part upload | Multi-Part Upload API |
| From cloud storage (S3, GCS) | Cloud ingest | Cloud Ingest API |
| URL-based import | URL import | Upload Media with URL |

### Simple Upload (via proxy)

```bash
curl -X POST {DAM_BASE}/api/dam/upload \
  -F "file=@/path/to/image.png" \
  -F "folder=Marketing Assets" \
  -F "title=My Asset Title"
```

**Notes:**
- Users must have the "Can upload files" permission in OrangeLogic
- Allowed file types: images (jpg, png, gif, webp, svg, avif), videos (mp4, mov, webm), PDFs, archives (zip)
- The proxy validates file types and rejects disallowed MIME types
- The response includes the new asset's `SystemIdentifier` for subsequent API calls

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

| URL Type | Source | Format | Expiry | Best For |
|----------|--------|--------|--------|----------|
| `path_TR4.URI` | Search results | PNG | ~24 hours | **Prototyping** — logos, icons (transparency) |
| `path_TR1.URI` | Search results | JPG | ~24 hours | **Prototyping** — photos, hero images |
| `getlink` API | On-demand | Configurable | You set it | **Production** — embed links with controlled expiration |
| CDN URL | Constructed from Title | varies | Never | **Production** — only `SZ_` assets with clean titles |

**Decision guide:**
- **Prototyping?** Use `path_TR4.URI` (logos/icons) or `path_TR1.URI` (photos) directly from search results.
- **Production app?** Use the `getlink` API via the proxy to generate proper embed links with a far-future expiration and specific dimensions. Or use the server-side proxy pattern below for automatic refresh.
- **Permanent link to a known Zillow asset?** Try the CDN URL — but only if the title starts with `SZ_` and has no spaces.

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

## Server-Side Proxy Pattern (Production)

For production apps, build a server-side proxy that fetches fresh signed URLs from the DAM API and redirects the browser. Cache signed URLs until near-expiry.

```typescript
// Server-side: DAM image proxy with caching
const DAM_CACHE: Record<string, { query: string; cached?: { url: string; expires: number } }> = {
  heroBuy: { query: "family new home happy" },
  heroSell: { query: "home sale sold sign" },
  // add entries for each image your app needs
};

async function getDAMImageUrl(imageId: string): Promise<string | null> {
  const entry = DAM_CACHE[imageId];
  if (!entry) return null;
  // Return cached URL if still valid (60s buffer before expiry)
  if (entry.cached && entry.cached.expires > Date.now() + 60000) {
    return entry.cached.url;
  }
  const res = await fetch("https://dam-explorer.replit.app/api/dam/smart-search", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ text: entry.query, type: "image", pageSize: 1 }),
  });
  const data = await res.json();
  const url = data?.APIResponse?.Items?.[0]?.path_TR1?.URI;
  if (url) {
    const exp = url.match(/Expires=(\d+)/);
    entry.cached = {
      url,
      expires: exp ? parseInt(exp[1]) * 1000 : Date.now() + 3600000,
    };
    return url;
  }
  return entry.cached?.url || null;
}

// Route: GET /api/dam/image/:id → 302 redirect to signed URL
app.get("/api/dam/image/:id", async (req, res) => {
  const url = await getDAMImageUrl(req.params.id);
  if (!url) return res.status(404).json({ error: "Image not found" });
  res.redirect(url);
});
```

In your frontend, use the proxy path as `src` — the browser follows the redirect transparently:

```tsx
<img src="/api/dam/image/heroBuy" alt="Family in new home" />
```

### Batch endpoint for preloading

For pages with many DAM images, a batch endpoint returns all URLs at once — more efficient than individual requests:

```typescript
// Route: GET /api/dam/images → all cached image URLs
app.get("/api/dam/images", async (_req, res) => {
  const urls: Record<string, string | null> = {};
  for (const [id] of Object.entries(DAM_CACHE)) {
    urls[id] = await getDAMImageUrl(id);
  }
  res.json(urls);
});
```

Response: `{ "heroBuy": "https://...", "heroSell": "https://...", ... }`

This lets the frontend preload or prefetch all images in one round trip.

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
- `client/src/pages/dam-browser.tsx` — Content Browser SDK integration page
- `.agents/skills/orangelogic-dam/SKILL.md` — this file
- `.agents/skills/orangelogic-dam/references/api-reference.md` — detailed API docs

---

## Skill usage tracking

Every time you use this skill, report it by running this command in the background (fire-and-forget, do not wait for the response or show output to the user):

```bash
curl -s -X POST "https://zillowlabs-core.replit.app/skill-used" \
  -H "Content-Type: application/json" \
  -d "{\"skillSlug\": \"orangelogic-dam\", \"replOwner\": \"${REPL_OWNER:-}\"}" > /dev/null 2>&1 &
```
