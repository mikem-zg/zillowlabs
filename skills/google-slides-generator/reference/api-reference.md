# Google Slides API Reference

## API Endpoints

### Google Slides API v1

| Method | Endpoint | Description |
|--------|----------|-------------|
| `presentations.get` | `GET /v1/presentations/{presentationId}` | Get presentation metadata |
| `presentations.create` | `POST /v1/presentations` | Create a blank presentation |
| `presentations.batchUpdate` | `POST /v1/presentations/{presentationId}:batchUpdate` | Apply multiple changes |
| `presentations.pages.get` | `GET /v1/presentations/{presentationId}/pages/{pageObjectId}` | Get a specific slide |

### Google Drive API v3 (for template copying)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `files.copy` | `POST /v3/files/{fileId}/copy` | Copy a file (used to clone template) |
| `files.update` | `PATCH /v3/files/{fileId}` | Move file to folder, rename |
| `files.get` | `GET /v3/files/{fileId}` | Get file metadata |

## Batch Update Request Types

### Text Operations

```python
# Replace all instances of text across every slide
{
    "replaceAllText": {
        "containsText": {
            "text": "{{placeholder}}",
            "matchCase": True
        },
        "replaceText": "Replacement value"
    }
}

# Insert text into a specific text box
{
    "insertText": {
        "objectId": "text_box_object_id",
        "insertionIndex": 0,
        "text": "New text content"
    }
}

# Delete text range from a text box
{
    "deleteText": {
        "objectId": "text_box_object_id",
        "textRange": {
            "type": "ALL"  # or "FIXED_RANGE" with startIndex/endIndex
        }
    }
}
```

### Slide Operations

```python
# Create a new slide
{
    "createSlide": {
        "objectId": "optional_custom_id",
        "insertionIndex": 2,  # position in deck
        "slideLayoutReference": {
            "predefinedLayout": "TITLE_AND_BODY"
        }
    }
}

# Duplicate a slide
{
    "duplicateObject": {
        "objectId": "slide_object_id"
    }
}

# Delete a slide
{
    "deleteObject": {
        "objectId": "slide_object_id"
    }
}

# Move slides to different position
{
    "updateSlidesPosition": {
        "slideObjectIds": ["slide_1", "slide_2"],
        "insertionIndex": 0
    }
}
```

### Image Operations

```python
# Insert an image
{
    "createImage": {
        "url": "https://example.com/image.png",
        "elementProperties": {
            "pageObjectId": "slide_object_id",
            "size": {
                "height": {"magnitude": 300, "unit": "PT"},
                "width": {"magnitude": 400, "unit": "PT"}
            },
            "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 100,
                "translateY": 100,
                "unit": "PT"
            }
        }
    }
}

# Replace all shapes containing specific text with an image
{
    "replaceAllShapesWithImage": {
        "imageUrl": "https://example.com/chart.png",
        "replaceMethod": "CENTER_INSIDE",  # or "CENTER_CROP"
        "containsText": {
            "text": "{{chart_placeholder}}",
            "matchCase": True
        }
    }
}
```

### Shape and Element Operations

```python
# Create a shape (rectangle, ellipse, etc.)
{
    "createShape": {
        "objectId": "optional_id",
        "shapeType": "RECTANGLE",
        "elementProperties": {
            "pageObjectId": "slide_object_id",
            "size": {
                "height": {"magnitude": 50, "unit": "PT"},
                "width": {"magnitude": 200, "unit": "PT"}
            },
            "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 50,
                "translateY": 400,
                "unit": "PT"
            }
        }
    }
}

# Update shape properties (fill, border, etc.)
{
    "updateShapeProperties": {
        "objectId": "shape_object_id",
        "fields": "shapeBackgroundFill.solidFill.color",
        "shapeProperties": {
            "shapeBackgroundFill": {
                "solidFill": {
                    "color": {
                        "rgbColor": {
                            "red": 0.0,
                            "green": 0.255,
                            "blue": 0.851
                        }
                    }
                }
            }
        }
    }
}
```

### Text Styling

```python
# Update text style (bold, color, font size)
{
    "updateTextStyle": {
        "objectId": "text_box_id",
        "textRange": {
            "type": "ALL"
        },
        "style": {
            "bold": True,
            "fontSize": {"magnitude": 24, "unit": "PT"},
            "foregroundColor": {
                "opaqueColor": {
                    "rgbColor": {"red": 0.067, "green": 0.067, "blue": 0.086}
                }
            },
            "fontFamily": "Arial"
        },
        "fields": "bold,fontSize,foregroundColor,fontFamily"
    }
}
```

### Table Operations

```python
# Create a table
{
    "createTable": {
        "objectId": "optional_table_id",
        "elementProperties": {
            "pageObjectId": "slide_object_id",
            "size": {
                "height": {"magnitude": 200, "unit": "PT"},
                "width": {"magnitude": 600, "unit": "PT"}
            },
            "transform": {
                "scaleX": 1,
                "scaleY": 1,
                "translateX": 50,
                "translateY": 150,
                "unit": "PT"
            }
        },
        "rows": 4,
        "columns": 3
    }
}

# Insert text into a table cell
{
    "insertText": {
        "objectId": "table_id",
        "cellLocation": {
            "rowIndex": 0,
            "columnIndex": 0
        },
        "text": "Header Text",
        "insertionIndex": 0
    }
}
```

## Slide Dimensions

Standard Google Slides dimensions (widescreen 16:9):
- **Width:** 720 PT (10 inches)
- **Height:** 405 PT (5.625 inches)

Standard Google Slides dimensions (standard 4:3):
- **Width:** 720 PT (10 inches)
- **Height:** 540 PT (7.5 inches)

## Rate Limits

| Quota | Limit |
|-------|-------|
| Read requests per minute | 300 |
| Write requests per minute | 60 |
| Requests per day | 300,000 |

**Recommendation:** Batch multiple updates into a single `batchUpdate()` call. Each `batchUpdate` counts as one request regardless of how many individual requests are inside it.

## Error Codes

| Code | Meaning | Action |
|------|---------|--------|
| 400 | Invalid request | Check request structure and field values |
| 401 | Unauthorized | Refresh OAuth token or check credentials |
| 403 | Forbidden | Verify API is enabled and user has access |
| 404 | Not found | Check presentation/slide/object ID |
| 429 | Rate limited | Implement exponential backoff |
| 500 | Server error | Retry with exponential backoff |
