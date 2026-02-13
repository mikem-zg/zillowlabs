## Common Operations

### Data Exploration

```bash
# Quick data overview
mlr --csv --from $1 head -n 5           # Sample data
mlr --csv --from $1 count               # Row count
mlr --csv --from $1 cut -f '' | head -1 # Column names
```

### Data Cleaning

```bash
# Remove empty rows
mlr --csv filter 'NF > 0' file.csv

# Remove duplicates
mlr --csv uniq -a file.csv

# Handle missing values
mlr --csv put 'if ($age == "") {$age = "0"}' file.csv
mlr --csv filter '$name != ""' file.csv  # Remove rows with empty names
```

### Data Transformation

```bash
# Format conversion
mlr --icsv --ojson cat file.csv > output.json    # CSV to JSON
mlr --ijson --ocsv cat file.json > output.csv    # JSON to CSV
mlr --icsv --otsvlite cat file.csv > output.tsv  # CSV to TSV

# Column operations
mlr --csv put '$full_name = $first . " " . $last' file.csv  # Concatenate
mlr --csv put '$price = $price * 1.1' file.csv             # Apply markup
mlr --csv rename old_name,new_name file.csv                # Rename columns
```

### Data Analysis

```bash
# Group operations
mlr --csv stats1 -a sum,mean -f sales -g region file.csv   # Group by region
mlr --csv count -g category file.csv                       # Count by category

# Joins
mlr --csv join -j id -f lookup.csv file.csv               # Inner join
mlr --csv join --ul -j id -f lookup.csv file.csv          # Left join

# Filtering and aggregation
mlr --csv filter '$date >= "2023-01-01"' then stats1 -a sum -f amount file.csv
```

## Integration with Text Tools

### Using awk for Simple Operations

```bash
# Column selection (when Miller isn't available)
awk -F, '{print $1,$3}' file.csv        # Select columns 1 and 3
awk -F, 'NR==1 || $2 > 100' file.csv    # Header + filtered rows

# Basic calculations
awk -F, '{sum += $2} END {print sum}' file.csv  # Sum column 2
```

### Using sort and uniq

```bash
# Sort CSV by column (after header)
(head -1 file.csv && tail -n +2 file.csv | sort -t, -k2,2n)  # Sort by column 2 numerically

# Find unique values in column
cut -d, -f2 file.csv | tail -n +2 | sort | uniq -c  # Count unique values
```

