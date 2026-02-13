## Quick Reference

| Operation | Purpose | Input Types | Output Options |
|-----------|---------|-------------|----------------|
| `replace` | Pattern-based find-and-replace | Files, stdin, patterns | In-place, new file, stdout |
| `extract` | Data extraction with regex/patterns | Text files, logs, mixed formats | CSV, JSON, TSV, plain text |
| `transform` | String manipulation and formatting | Any text input | Transformed text, various formats |
| `normalize` | Text cleanup and standardization | Mixed-encoding files, messy data | Clean, standardized text |
| `analyze-logs` | Log file analysis and filtering | Log files, journal entries | Reports, metrics, filtered logs |
| `validate` | Text validation and verification | Any text, structured patterns | Validation reports, cleaned data |

## Preconditions

- Target text files or data streams must be accessible
- Sufficient disk space for output files and optional backups
- Valid regex syntax for pattern-based operations (auto-validated)
- Appropriate permissions for read/write operations on target files
- For log analysis: log files should follow recognizable formats
- For batch operations: glob patterns must match accessible files

