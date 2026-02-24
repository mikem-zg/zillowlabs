# OrangeLogic DAM API Reference

## Authentication

### Client Credentials Authentication
**Endpoint:** `POST /webapi/security/clientcredentialsauthentication/authenticate_46H_v1`
**Content-Type:** `application/json`

**Request:**
```json
{
  "client_id": "your_client_id",
  "client_secret": "your_client_secret"
}
```

**Response (200):**
```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 7200
}
```

### OAuth 2.0 Token (Third-Party Apps)
**Endpoint:** `POST /webapi/security/oauth2/token_48I_v1`

**Request (form data):**
- `client_id` — Application client ID
- `client_secret` — Application secret
- `grant_type` — `authorization_code` or `refresh_token`
- `code` — Authorization code or refresh token

**Response:**
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "token_type": "Bearer",
  "expires_in": 7200
}
```

### Bearer Token via Email
**Endpoint:** `GET /bearerauthentication/getbearertoken_42P_v1?UserEmail={email}`

Returns a bearer token for an existing Orange Logic user by email address.

---

## Search API

### Search Assets
**Endpoint:** `POST /API/Search/v4.0/Search`
**Content-Type:** `application/x-www-form-urlencoded`
**Auth:** Bearer token

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `query` | string | Search query (see syntax below) |
| `fields` | string | Comma-separated field names to return |
| `format` | string | Response format — use `JSON` (default is XML) |
| `sort` | string | Sort order (e.g., `Relevance`, `DateCreated`) |
| `pagenumber` | int | Page number (1-based) |
| `pagesize` | int | Results per page |
| `debug` | bool | Include debug info |
| `verbose` | bool | Verbose output |
| `includebinned` | bool | Include binned/archived assets |
| `includestorageinfo` | bool | Include storage information |
| `getpermanentassetspaths` | bool | Return permanent asset paths |
| `generateformatifnotexists` | bool | Generate format if missing |

### Query Syntax

**Text search:**
- `Text:Sport` — free text search
- `Text:"Red carpet" AND Cannes` — phrase + keyword
- `Text:("Red carpet" AND Cannes) OR Celebrity` — grouped

**Keyword search:**
- `Keyword:beach` — any keyword
- `Keyword:beach AND sport AND NOT Keyword:France` — boolean
- `Keyword(Common):orange AND NOT Keyword(Geography):orange` — type-specific
- `NativeKeyword:France` — only directly assigned keywords

**Media type:**
- `MediaType:Image` — filter by media type
- `MediaType:Image OR Video` — multiple types

**Document subtype:**
- `DocSubType:Standard Image` — specific subtype

**Field-specific:**
- `Title:sunset` — search in title field
- `keyword:London AND Bridge OR uk AND title:Bridge` — multi-field

**Operators:** `AND`, `OR`, `NOT`, parentheses for grouping

---

## Asset Links

### Get Single Link
**Endpoint:** `GET /webapi/objectmanagement/share/getlink_4HZ_v1`
**Auth:** Bearer token

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Identifier` | string | Asset identifier |
| `Format` | string | Format code (e.g., `Web`, `Original`, `Thumbnail`) |
| `StickToCurrentVersion` | bool | Lock to current version |
| `LogViews` | bool | Log view events |
| `CreateDownloadLink` | bool | Generate downloadable link |
| `ExpirationDate` | string | Link expiration date |
| `MaxWidth` | int | Max width in pixels |
| `MaxHeight` | int | Max height in pixels |
| `FileExtension` | string | Output file extension |
| `ImageResizingMethod` | string | Resize method |

**Response:**
```json
{
  "recordID": "...",
  "identifier": "ABC123",
  "format": "Web",
  "link": "https://cdn.example.com/asset.jpg",
  "maxWidth": 1200,
  "maxHeight": 800,
  "expirationDate": "2026-03-01",
  "fileExtension": "jpg",
  "imageResizingMethod": "Fit"
}
```

### Get Multiple Links (Batch)
**Endpoint:** `POST /webapi/objectmanagement/share/getlinks_45W_v1`
**Auth:** Bearer token
**Content-Type:** `application/json`

**Request:**
```json
{
  "assets": [
    {
      "identifier": "ABC123",
      "format": "Web",
      "createDownloadLink": false,
      "Logviews": false,
      "maxWidth": 800,
      "maxHeight": 600,
      "Fileextension": "jpg"
    },
    {
      "identifier": "ABC123",
      "format": "Original",
      "createDownloadLink": true
    }
  ]
}
```

### Get Presigned Link (Cloud Storage)
**Endpoint:** `GET /webapi/.../getpresignedlink_4ar_v1`

**Parameters:**
- `RecordID` — Asset record ID
- `Format` — Format code
- `GenerateIfNeeded` — Generate if format doesn't exist
- `SkipCheckExistence` — Skip existence check
- `ValidityDuration` — Link TTL

---

## Upload API

### Upload File (< 1.5 GB)
**Endpoint:** `POST /webapi/mediafile/import/upload/uploadmedia_4az_v1`
**Content-Type:** `multipart/form-data`
**Auth:** Bearer token

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `folderRecordID` | string | Target folder ID |
| `files` | file | File(s) to upload |
| `processAssetInBackground` | bool | `true` = faster (background), `false` = sync |

**Response (200):**
```json
{
  "uploadResults": [
    {
      "fileName": "photo.jpg",
      "isSuccess": true,
      "fileIdentifier": "NEW_ASSET_ID",
      "warningMessage": ""
    }
  ]
}
```

### Upload from URL
**Endpoint:** `POST /webapi/mediafile/import/upload`
**Content-Type:** `application/json`
**Auth:** Bearer token

**Request:**
```json
{
  "folderRecordID": "FOLDER_ID",
  "fileURL": "https://example.com/image.jpg",
  "fileName": "my-image.jpg",
  "importMode": "Copy"
}
```

### Upload and Get Link
**Endpoint:** `POST /webapi/mediafile/import/upload` (with `getLink` variant)
**Content-Type:** `multipart/form-data`
**Auth:** Bearer token

Uploads an image and returns a download link to the largest available format.

**Parameters:**
- `folderRecordID` — Target folder
- `files` — File to upload
- `clientFileName` — Filename with extension

---

## List Fields
**Endpoint:** `POST /API/Search/v3.0/ListFields`
**Auth:** Bearer token

Returns all available metadata fields that can be used in search `fields` parameter. Add `format=JSON` to get JSON response.

**Response:**
```json
{
  "Metadata": {
    "MediaEncryptedIdentifier": { "description": "Encrypted asset ID" },
    "SystemIdentifier": { "description": "System unique ID" },
    "Title": { "description": "Asset title" }
  }
}
```

---

## Important Notes

- Default response format is XML — always add `format=JSON` parameter for JSON responses
- GET requests may fail with 403 if the URL is too long — use POST instead
- Parameters in POST can be in HTTP header or URL; header values override URL values
- Auth tokens are valid for a single server; re-authenticate if server changes
- Assets < 1.5 GB: use standard upload. Larger: use multi-part upload API
- Transformations (crop, resize, rotate) are available on generated links only — they don't modify the original asset
