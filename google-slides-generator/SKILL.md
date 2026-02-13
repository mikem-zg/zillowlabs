---
name: google-slides-generator
description: Generate professional Google Slides presentations using the Zillow slide deck template. Copy the template, populate slides with content, add new slides, insert images, and follow Zillow branding guidelines via the Google Slides and Drive APIs.
---

## Overview

Generate professional Google Slides presentations using Zillow's official slide deck template. This skill automates the entire workflow: copying the branded template, populating slides with content, adding new slides, inserting images, and ensuring Zillow brand compliance throughout.

**Template:** [Zillow Slide Deck Template](https://docs.google.com/presentation/d/1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4/edit)

📋 **API Reference**: [reference/api-reference.md](reference/api-reference.md)
📝 **Slide Templates**: [reference/slide-templates.md](reference/slide-templates.md)
🎨 **Branding Guide**: [reference/branding-guide.md](reference/branding-guide.md)
💡 **Examples**: [examples/common-workflows.md](examples/common-workflows.md)

## Prerequisites

Before using this skill, ensure the following are available:

1. **Google OAuth 2.0 credentials** with the following scopes:
   - `https://www.googleapis.com/auth/presentations` (Google Slides API)
   - `https://www.googleapis.com/auth/drive` (Google Drive API — for copying templates)
2. **Google Slides API** and **Google Drive API** enabled in your Google Cloud project
3. **Access to the Zillow template** — the user's Google account must have at least Viewer access to the template presentation

## Core Workflow

### Essential Operations (Most Common — 90% of Usage)

**1. Create a New Presentation from the Zillow Template**

This is the primary entry point. It copies the Zillow-branded template to the user's Drive, giving them a new presentation pre-loaded with Zillow styling, layouts, and master slides.

```bash
google-slides-generator --action="create" --title="Q1 2025 Market Report"
```

**How it works under the hood:**
1. Calls Google Drive API `files.copy()` to duplicate the template
2. Renames the copy to the provided title
3. Optionally moves it to a specific Drive folder
4. Returns the new presentation ID and URL

```python
from googleapiclient.discovery import build

TEMPLATE_ID = "1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4"

def create_presentation(drive_service, title, folder_id=None):
    """Copy the Zillow template and rename it."""
    body = {"name": title}
    if folder_id:
        body["parents"] = [folder_id]

    response = drive_service.files().copy(
        fileId=TEMPLATE_ID,
        body=body,
        supportsAllDrives=True
    ).execute()

    presentation_id = response["id"]
    url = f"https://docs.google.com/presentation/d/{presentation_id}/edit"
    return {"id": presentation_id, "url": url}
```

**2. Replace Placeholder Text Across All Slides**

The Zillow template uses `{{placeholder}}` patterns. Replace them in bulk:

```bash
google-slides-generator --action="replace-text" \
  --presentation_id="<PRES_ID>" \
  --replacements='{"{{title}}": "Seattle Market Overview", "{{date}}": "February 2025", "{{author}}": "Jane Smith"}'
```

```python
def replace_all_text(slides_service, presentation_id, replacements):
    """Replace all {{placeholder}} text across every slide."""
    requests = []
    for placeholder, value in replacements.items():
        requests.append({
            "replaceAllText": {
                "containsText": {
                    "text": placeholder,
                    "matchCase": True
                },
                "replaceText": value
            }
        })

    slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": requests}
    ).execute()
```

**3. Add a New Slide**

```bash
google-slides-generator --action="add-slide" \
  --presentation_id="<PRES_ID>" \
  --slide_layout="TITLE_AND_BODY"
```

```python
def add_slide(slides_service, presentation_id, layout="TITLE_AND_BODY", insertion_index=None):
    """Add a new slide with the specified layout."""
    request = {
        "createSlide": {
            "slideLayoutReference": {
                "predefinedLayout": layout
            }
        }
    }
    if insertion_index is not None:
        request["createSlide"]["insertionIndex"] = insertion_index

    response = slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": [request]}
    ).execute()

    return response["replies"][0]["createSlide"]["objectId"]
```

**4. Insert an Image**

```bash
google-slides-generator --action="insert-image" \
  --presentation_id="<PRES_ID>" \
  --slide_index=2 \
  --image_url="https://example.com/chart.png"
```

```python
def insert_image(slides_service, presentation_id, slide_object_id, image_url,
                 x=100, y=100, width=500, height=300):
    """Insert an image onto a specific slide."""
    requests = [{
        "createImage": {
            "url": image_url,
            "elementProperties": {
                "pageObjectId": slide_object_id,
                "size": {
                    "height": {"magnitude": height, "unit": "PT"},
                    "width": {"magnitude": width, "unit": "PT"}
                },
                "transform": {
                    "scaleX": 1,
                    "scaleY": 1,
                    "translateX": x,
                    "translateY": y,
                    "unit": "PT"
                }
            }
        }
    }]

    slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": requests}
    ).execute()
```

**5. Get Presentation Info**

```bash
google-slides-generator --action="get-info" --presentation_id="<PRES_ID>"
```

```python
def get_presentation_info(slides_service, presentation_id):
    """Get presentation metadata and slide count."""
    presentation = slides_service.presentations().get(
        presentationId=presentation_id
    ).execute()

    return {
        "title": presentation.get("title"),
        "slide_count": len(presentation.get("slides", [])),
        "locale": presentation.get("locale"),
        "slides": [
            {
                "objectId": slide["objectId"],
                "index": i,
                "layout": slide.get("slideProperties", {}).get("layoutObjectId")
            }
            for i, slide in enumerate(presentation.get("slides", []))
        ]
    }
```

**6. List All Slides**

```bash
google-slides-generator --action="list-slides" --presentation_id="<PRES_ID>"
```

**7. Delete a Slide**

```bash
google-slides-generator --action="delete-slide" \
  --presentation_id="<PRES_ID>" \
  --slide_index=3
```

```python
def delete_slide(slides_service, presentation_id, slide_object_id):
    """Delete a specific slide by its object ID."""
    slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": [{"deleteObject": {"objectId": slide_object_id}}]}
    ).execute()
```

**8. Duplicate a Slide**

```bash
google-slides-generator --action="duplicate-slide" \
  --presentation_id="<PRES_ID>" \
  --slide_index=1
```

```python
def duplicate_slide(slides_service, presentation_id, slide_object_id):
    """Duplicate an existing slide."""
    response = slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": [{"duplicateObject": {"objectId": slide_object_id}}]}
    ).execute()
    return response["replies"][0]["duplicateObject"]["objectId"]
```

## Authentication Setup

### Using OAuth 2.0 (Interactive / User-facing)

```python
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

SCOPES = [
    "https://www.googleapis.com/auth/presentations",
    "https://www.googleapis.com/auth/drive"
]

def get_services():
    flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
    creds = flow.run_local_server(port=0)

    slides_service = build("slides", "v1", credentials=creds)
    drive_service = build("drive", "v3", credentials=creds)
    return slides_service, drive_service
```

### Using Service Account (Server-to-Server)

```python
from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = [
    "https://www.googleapis.com/auth/presentations",
    "https://www.googleapis.com/auth/drive"
]

creds = service_account.Credentials.from_service_account_file(
    "service-account.json", scopes=SCOPES
)

slides_service = build("slides", "v1", credentials=creds)
drive_service = build("drive", "v3", credentials=creds)
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

→ **Full layout reference with dimensions**: [reference/slide-templates.md](reference/slide-templates.md)

## Error Handling

```python
from googleapiclient.errors import HttpError

try:
    result = create_presentation(drive_service, "My Report")
except HttpError as error:
    status = error.resp.status
    if status == 403:
        print("Permission denied. Check template sharing settings and API scopes.")
    elif status == 404:
        print("Template not found. Verify the template ID is correct.")
    elif status == 429:
        print("Rate limit exceeded. Implement exponential backoff.")
    else:
        print(f"API error {status}: {error}")
```

## Best Practices

1. **Always use batch updates** — group multiple changes into a single `batchUpdate()` call to minimize API calls
2. **Use the template** — never create from scratch; copying the Zillow template preserves branding, fonts, and master slide styles
3. **Keep placeholder naming consistent** — use `{{double_curly_braces}}` for all placeholders
4. **Move to folder after creation** — organize generated decks into a shared Drive folder
5. **Check slide object IDs** — always call `get-info` first to retrieve slide object IDs before modifying specific slides
6. **Handle rate limits** — implement exponential backoff for production workloads
7. **Follow Zillow branding** — see [reference/branding-guide.md](reference/branding-guide.md) for color, font, and layout requirements
