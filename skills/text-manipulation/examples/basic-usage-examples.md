## Examples

```bash
# Advanced pattern-based find and replace across multiple files
/text-manipulation --operation="replace" --pattern="old-config-key" --replacement="new-config-key" --scope="**/*.conf" --backup

# Extract and normalize log timestamps across different formats
/text-manipulation --operation="extract-timestamps" --input="logs/*.log" --normalize-format="ISO8601" --output="processed-timestamps.txt"

# Complex string transformations with validation
/text-manipulation --operation="transform" --input="raw-data.txt" --transform="lowercase,trim,remove-duplicates" --validate-encoding="UTF-8"

# Multi-pattern extraction from mixed format files
/text-manipulation --operation="extract" --patterns="email,phone,url" --input="contact-exports/*" --format="json" --output="extracted-contacts.json"

# Log file analysis with filtering and aggregation
/text-manipulation --operation="analyze-logs" --input="application.log" --filter-level="ERROR" --group-by="timestamp-hour" --output="error-analysis.csv"

# Text normalization for data integration
/text-manipulation --operation="normalize" --input="messy-data.txt" --cleanup="whitespace,line-endings,encoding" --encoding="UTF-8" --output="clean-data.txt"
```

