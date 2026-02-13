# Common Workflows

## Workflow 1: Generate a Market Report

End-to-end example of creating a market report presentation.

```python
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials

TEMPLATE_ID = "1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4"

def generate_market_report(creds, title, data):
    """Generate a complete market report from template."""
    slides = build("slides", "v1", credentials=creds)
    drive = build("drive", "v3", credentials=creds)

    # Step 1: Copy the Zillow template
    copy = drive.files().copy(
        fileId=TEMPLATE_ID,
        body={"name": title},
        supportsAllDrives=True
    ).execute()
    pres_id = copy["id"]

    # Step 2: Replace placeholders across all slides
    replacements = {
        "{{title}}": title,
        "{{date}}": data["date"],
        "{{author}}": data["author"],
        "{{median_price}}": data["median_price"],
        "{{yoy_change}}": data["yoy_change"],
        "{{active_listings}}": data["active_listings"],
        "{{days_on_market}}": data["days_on_market"],
    }

    requests = []
    for placeholder, value in replacements.items():
        requests.append({
            "replaceAllText": {
                "containsText": {"text": placeholder, "matchCase": True},
                "replaceText": value
            }
        })

    # Step 3: Add data slides
    requests.append({
        "createSlide": {
            "insertionIndex": 3,
            "slideLayoutReference": {"predefinedLayout": "BIG_NUMBER"}
        }
    })

    # Step 4: Apply all changes in one batch
    slides.presentations().batchUpdate(
        presentationId=pres_id,
        body={"requests": requests}
    ).execute()

    url = f"https://docs.google.com/presentation/d/{pres_id}/edit"
    print(f"Presentation created: {url}")
    return {"id": pres_id, "url": url}

# Usage
data = {
    "date": "February 2025",
    "author": "Zillow Economics",
    "median_price": "$425,000",
    "yoy_change": "+4.2%",
    "active_listings": "1.2M",
    "days_on_market": "32"
}
result = generate_market_report(creds, "Q1 2025 Housing Market Report", data)
```

## Workflow 2: Generate a Product Update Deck

```python
def generate_product_update(creds, title, features):
    """Generate a product update deck with feature slides."""
    slides = build("slides", "v1", credentials=creds)
    drive = build("drive", "v3", credentials=creds)

    # Copy template
    copy = drive.files().copy(
        fileId=TEMPLATE_ID,
        body={"name": title},
        supportsAllDrives=True
    ).execute()
    pres_id = copy["id"]

    requests = []

    # Replace title slide
    requests.append({
        "replaceAllText": {
            "containsText": {"text": "{{title}}", "matchCase": True},
            "replaceText": title
        }
    })

    # Add a slide for each feature
    for i, feature in enumerate(features):
        slide_id = f"feature_slide_{i}"
        requests.append({
            "createSlide": {
                "objectId": slide_id,
                "insertionIndex": i + 2,
                "slideLayoutReference": {"predefinedLayout": "TITLE_AND_BODY"}
            }
        })

    slides.presentations().batchUpdate(
        presentationId=pres_id,
        body={"requests": requests}
    ).execute()

    # Now populate each feature slide with text
    # Get presentation to find placeholder IDs
    presentation = slides.presentations().get(
        presentationId=pres_id
    ).execute()

    text_requests = []
    for i, feature in enumerate(features):
        slide = presentation["slides"][i + 2]
        for element in slide.get("pageElements", []):
            shape = element.get("shape", {})
            placeholder = shape.get("placeholder", {})
            if placeholder.get("type") == "TITLE":
                text_requests.append({
                    "insertText": {
                        "objectId": element["objectId"],
                        "text": feature["title"],
                        "insertionIndex": 0
                    }
                })
            elif placeholder.get("type") == "BODY":
                text_requests.append({
                    "insertText": {
                        "objectId": element["objectId"],
                        "text": feature["description"],
                        "insertionIndex": 0
                    }
                })

    if text_requests:
        slides.presentations().batchUpdate(
            presentationId=pres_id,
            body={"requests": text_requests}
        ).execute()

    url = f"https://docs.google.com/presentation/d/{pres_id}/edit"
    return {"id": pres_id, "url": url}

# Usage
features = [
    {"title": "Improved Search", "description": "Faster results with AI-powered suggestions."},
    {"title": "New Dashboard", "description": "Redesigned analytics with real-time data."},
    {"title": "Mobile Updates", "description": "Responsive design across all devices."},
]
result = generate_product_update(creds, "Product Update — February 2025", features)
```

## Workflow 3: Remove Unwanted Template Slides

After copying the template, you may want to remove slides that don't apply:

```python
def cleanup_template(slides_service, presentation_id, keep_indices):
    """Remove template slides that are not needed."""
    presentation = slides_service.presentations().get(
        presentationId=presentation_id
    ).execute()

    all_slides = presentation.get("slides", [])
    to_delete = [
        slide["objectId"]
        for i, slide in enumerate(all_slides)
        if i not in keep_indices
    ]

    if to_delete:
        requests = [{"deleteObject": {"objectId": sid}} for sid in to_delete]
        slides_service.presentations().batchUpdate(
            presentationId=presentation_id,
            body={"requests": requests}
        ).execute()
```

## Workflow 4: Insert Charts as Images

```python
def add_chart_slide(slides_service, presentation_id, chart_title, chart_image_url):
    """Add a new slide with a chart image."""
    # Create a blank slide for the chart
    create_response = slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": [{
            "createSlide": {
                "slideLayoutReference": {"predefinedLayout": "BLANK"}
            }
        }]}
    ).execute()

    slide_id = create_response["replies"][0]["createSlide"]["objectId"]

    # Add title text box and chart image
    slides_service.presentations().batchUpdate(
        presentationId=presentation_id,
        body={"requests": [
            {
                "createShape": {
                    "objectId": f"{slide_id}_title",
                    "shapeType": "TEXT_BOX",
                    "elementProperties": {
                        "pageObjectId": slide_id,
                        "size": {
                            "height": {"magnitude": 40, "unit": "PT"},
                            "width": {"magnitude": 620, "unit": "PT"}
                        },
                        "transform": {
                            "scaleX": 1, "scaleY": 1,
                            "translateX": 50, "translateY": 30,
                            "unit": "PT"
                        }
                    }
                }
            },
            {
                "insertText": {
                    "objectId": f"{slide_id}_title",
                    "text": chart_title,
                    "insertionIndex": 0
                }
            },
            {
                "updateTextStyle": {
                    "objectId": f"{slide_id}_title",
                    "textRange": {"type": "ALL"},
                    "style": {
                        "bold": True,
                        "fontSize": {"magnitude": 28, "unit": "PT"},
                        "foregroundColor": {
                            "opaqueColor": {
                                "rgbColor": {"red": 0.067, "green": 0.067, "blue": 0.086}
                            }
                        }
                    },
                    "fields": "bold,fontSize,foregroundColor"
                }
            },
            {
                "createImage": {
                    "url": chart_image_url,
                    "elementProperties": {
                        "pageObjectId": slide_id,
                        "size": {
                            "height": {"magnitude": 300, "unit": "PT"},
                            "width": {"magnitude": 600, "unit": "PT"}
                        },
                        "transform": {
                            "scaleX": 1, "scaleY": 1,
                            "translateX": 60, "translateY": 80,
                            "unit": "PT"
                        }
                    }
                }
            }
        ]}
    ).execute()

    return slide_id
```

## Workflow 5: Batch Generate Multiple Presentations

```python
import time

def batch_generate(creds, reports):
    """Generate multiple presentations from a list of report configs."""
    results = []

    for report in reports:
        try:
            result = generate_market_report(creds, report["title"], report["data"])
            results.append({"title": report["title"], "status": "success", **result})
        except Exception as e:
            results.append({"title": report["title"], "status": "error", "error": str(e)})

        # Respect rate limits
        time.sleep(2)

    return results

# Usage
reports = [
    {"title": "Seattle Market Report", "data": {
        "date": "Feb 2025", "author": "Team A",
        "median_price": "$650,000", "yoy_change": "+3.1%",
        "active_listings": "4,200", "days_on_market": "28"
    }},
    {"title": "Portland Market Report", "data": {
        "date": "Feb 2025", "author": "Team B",
        "median_price": "$485,000", "yoy_change": "+2.8%",
        "active_listings": "3,100", "days_on_market": "35"
    }},
]
results = batch_generate(creds, reports)
```

## Workflow 6: Share the Presentation

After creating, grant access:

```python
def share_presentation(drive_service, file_id, email, role="writer"):
    """Share presentation with a user."""
    drive_service.permissions().create(
        fileId=file_id,
        body={
            "type": "user",
            "role": role,  # "reader", "writer", "commenter"
            "emailAddress": email
        },
        sendNotificationEmail=True
    ).execute()

def make_link_shared(drive_service, file_id, role="reader"):
    """Make presentation accessible via link."""
    drive_service.permissions().create(
        fileId=file_id,
        body={
            "type": "anyone",
            "role": role
        }
    ).execute()
```
