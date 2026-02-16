---
name: google-slides-generator
description: Generate professional Google Slides presentations using the Zillow slide deck template. Copy the template, populate slides with content, add new slides, insert images, and follow Zillow branding guidelines via the Google Slides and Drive APIs.
---

## Overview

Generate professional Google Slides presentations using Zillow's official slide deck template. This skill automates the entire workflow: copying the branded template, populating slides with content, adding new slides, inserting images, and ensuring Zillow brand compliance throughout.

**Template:** [Zillow Slide Deck Template](https://docs.google.com/presentation/d/1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4/edit)

**API Reference**: [reference/api-reference.md](reference/api-reference.md)
**Slide Templates**: [reference/slide-templates.md](reference/slide-templates.md)
**Branding Guide**: [reference/branding-guide.md](reference/branding-guide.md)
**Examples**: [examples/common-workflows.md](examples/common-workflows.md)

## Prerequisites

**IMPORTANT: Do NOT ask the user for Google API credentials, service account keys, or OAuth client secrets.** Authentication is handled automatically by the Replit Google Drive connector that is already configured in this project.

Before using this skill, ensure:
1. The **Google Drive integration** is connected in this Replit project (it already is)
2. The connected Google account has at least **Viewer access** to the [Zillow template](https://docs.google.com/presentation/d/1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4/edit)

## Authentication (Automatic via Replit Connector)

**Never ask the user for credentials.** Use the Replit Google Drive connector to obtain an OAuth access token automatically. This token works for both the Drive API and the Slides API.

```typescript
// Google Drive + Slides authentication via Replit connector
// Integration: Google Drive (connection:conn_google-drive)
import { google } from 'googleapis';

let connectionSettings: any;

async function getAccessToken() {
  if (connectionSettings && connectionSettings.settings.expires_at && new Date(connectionSettings.settings.expires_at).getTime() > Date.now()) {
    return connectionSettings.settings.access_token;
  }
  
  const hostname = process.env.REPLIT_CONNECTORS_HOSTNAME;
  const xReplitToken = process.env.REPL_IDENTITY 
    ? 'repl ' + process.env.REPL_IDENTITY 
    : process.env.WEB_REPL_RENEWAL 
    ? 'depl ' + process.env.WEB_REPL_RENEWAL 
    : null;

  if (!xReplitToken) {
    throw new Error('X_REPLIT_TOKEN not found for repl/depl');
  }

  connectionSettings = await fetch(
    'https://' + hostname + '/api/v2/connection?include_secrets=true&connector_names=google-drive',
    {
      headers: {
        'Accept': 'application/json',
        'X_REPLIT_TOKEN': xReplitToken
      }
    }
  ).then(res => res.json()).then(data => data.items?.[0]);

  const accessToken = connectionSettings?.settings?.access_token || connectionSettings.settings?.oauth?.credentials?.access_token;

  if (!connectionSettings || !accessToken) {
    throw new Error('Google Drive not connected. Ask the user to reconnect the Google Drive integration in Replit.');
  }
  return accessToken;
}

// WARNING: Never cache these clients.
// Access tokens expire, so new clients must be created each time.
async function getGoogleClients() {
  const accessToken = await getAccessToken();

  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ access_token: accessToken });

  const drive = google.drive({ version: 'v3', auth: oauth2Client });
  const slides = google.slides({ version: 'v1', auth: oauth2Client });
  return { drive, slides };
}
```

## Zillow Brand Template

**Template ID:** `1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4`

**ALWAYS** start by copying this template. Never create a blank presentation. The template includes:
- Zillow branding (logo, colors, fonts)
- Pre-built master slide layouts
- `{{placeholder}}` patterns for easy content replacement

## Core Workflow

### Essential Operations (Most Common — 90% of Usage)

**1. Create a New Presentation from the Zillow Template**

This is the primary entry point. It copies the Zillow-branded template to the user's Drive, giving them a new presentation pre-loaded with Zillow styling, layouts, and master slides.

```typescript
const TEMPLATE_ID = "1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4";

async function createPresentation(title: string, folderId?: string) {
  const { drive } = await getGoogleClients();

  const body: any = { name: title };
  if (folderId) body.parents = [folderId];

  const response = await drive.files.copy({
    fileId: TEMPLATE_ID,
    requestBody: body,
    supportsAllDrives: true,
  });

  const presentationId = response.data.id!;
  const url = `https://docs.google.com/presentation/d/${presentationId}/edit`;
  return { id: presentationId, url };
}
```

**2. Replace Placeholder Text Across All Slides**

The Zillow template uses `{{placeholder}}` patterns. Replace them in bulk:

```typescript
async function replaceAllText(presentationId: string, replacements: Record<string, string>) {
  const { slides } = await getGoogleClients();

  const requests = Object.entries(replacements).map(([placeholder, value]) => ({
    replaceAllText: {
      containsText: { text: placeholder, matchCase: true },
      replaceText: value,
    },
  }));

  await slides.presentations.batchUpdate({
    presentationId,
    requestBody: { requests },
  });
}
```

**3. Add a New Slide**

```typescript
async function addSlide(presentationId: string, layout = "TITLE_AND_BODY", insertionIndex?: number) {
  const { slides } = await getGoogleClients();

  const request: any = {
    createSlide: {
      slideLayoutReference: { predefinedLayout: layout },
    },
  };
  if (insertionIndex !== undefined) {
    request.createSlide.insertionIndex = insertionIndex;
  }

  const response = await slides.presentations.batchUpdate({
    presentationId,
    requestBody: { requests: [request] },
  });

  return response.data.replies![0].createSlide!.objectId!;
}
```

**4. Insert an Image**

```typescript
async function insertImage(
  presentationId: string,
  slideObjectId: string,
  imageUrl: string,
  x = 100, y = 100, width = 500, height = 300
) {
  const { slides } = await getGoogleClients();

  await slides.presentations.batchUpdate({
    presentationId,
    requestBody: {
      requests: [{
        createImage: {
          url: imageUrl,
          elementProperties: {
            pageObjectId: slideObjectId,
            size: {
              height: { magnitude: height, unit: "PT" },
              width: { magnitude: width, unit: "PT" },
            },
            transform: {
              scaleX: 1, scaleY: 1,
              translateX: x, translateY: y,
              unit: "PT",
            },
          },
        },
      }],
    },
  });
}
```

**5. Get Presentation Info**

```typescript
async function getPresentationInfo(presentationId: string) {
  const { slides } = await getGoogleClients();

  const presentation = await slides.presentations.get({ presentationId });
  const data = presentation.data;

  return {
    title: data.title,
    slideCount: data.slides?.length || 0,
    slides: data.slides?.map((slide, i) => ({
      objectId: slide.objectId,
      index: i,
      layout: slide.slideProperties?.layoutObjectId,
    })) || [],
  };
}
```

**6. Delete a Slide**

```typescript
async function deleteSlide(presentationId: string, slideObjectId: string) {
  const { slides } = await getGoogleClients();

  await slides.presentations.batchUpdate({
    presentationId,
    requestBody: { requests: [{ deleteObject: { objectId: slideObjectId } }] },
  });
}
```

**7. Duplicate a Slide**

```typescript
async function duplicateSlide(presentationId: string, slideObjectId: string) {
  const { slides } = await getGoogleClients();

  const response = await slides.presentations.batchUpdate({
    presentationId,
    requestBody: { requests: [{ duplicateObject: { objectId: slideObjectId } }] },
  });

  return response.data.replies![0].duplicateObject!.objectId!;
}
```

## Available Slide Layouts

The Zillow template includes these predefined layouts:

| Layout | Constant | Best For |
|--------|----------|----------|
| Title Slide | `TITLE` | Opening slide, section dividers |
| Title and Body | `TITLE_AND_BODY` | General content with title and text |
| Two Columns | `TITLE_AND_TWO_COLUMNS` | Side-by-side comparisons |
| Section Header | `SECTION_HEADER` | Major section breaks |
| Blank | `BLANK` | Custom layouts, full-bleed images |
| Caption Only | `CAPTION_ONLY` | Images with captions |
| Big Number | `BIG_NUMBER` | Key statistics, KPIs |
| One Column Text | `ONE_COLUMN_TEXT` | Text-heavy slides |
| Main Point | `MAIN_POINT` | Key takeaways |

> **Full layout reference with dimensions**: [reference/slide-templates.md](reference/slide-templates.md)

## Error Handling

```typescript
try {
  const result = await createPresentation("My Report");
} catch (error: any) {
  const status = error?.response?.status || error?.code;
  if (status === 403) {
    console.error("Permission denied. The connected Google account may not have access to the template. Ask the user to verify sharing settings.");
  } else if (status === 404) {
    console.error("Template not found. Verify the template ID is correct.");
  } else if (status === 429) {
    console.error("Rate limit exceeded. Implement exponential backoff.");
  } else {
    console.error(`API error ${status}:`, error.message);
  }
}
```

## Best Practices

1. **Never ask for credentials** — authentication is automatic via the Replit Google Drive connector
2. **Always use the Zillow template** — never create from scratch; copying the template preserves branding, fonts, and master slide styles
3. **Always use batch updates** — group multiple changes into a single `batchUpdate()` call to minimize API calls
4. **Keep placeholder naming consistent** — use `{{double_curly_braces}}` for all placeholders
5. **Move to folder after creation** — organize generated decks into a shared Drive folder
6. **Check slide object IDs** — always call `getPresentationInfo()` first to retrieve slide object IDs before modifying specific slides
7. **Handle rate limits** — implement exponential backoff for production workloads
8. **Follow Zillow branding** — see [reference/branding-guide.md](reference/branding-guide.md) for color, font, and layout requirements
9. **Never cache Google clients** — access tokens expire; always call `getGoogleClients()` fresh
