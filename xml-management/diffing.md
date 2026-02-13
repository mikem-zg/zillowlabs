# XML Comparison and Diffing Workflows

Semantic XML comparison, configuration diffing, and change analysis workflows for FUB development environments.

## Basic XML Comparison

### Structural XML Diff

**Compare XML files semantically rather than line-by-line:**
```bash
# Semantic XML comparison using xmlstarlet
xml_semantic_diff() {
    local file1="$1"
    local file2="$2"

    # Validate both files first
    if ! xmllint --noout "$file1" 2>/dev/null; then
        echo "Invalid XML: $file1"
        return 1
    fi

    if ! xmllint --noout "$file2" 2>/dev/null; then
        echo "Invalid XML: $file2"
        return 1
    fi

    echo "=== Semantic XML Comparison ==="
    echo "File 1: $(basename "$file1")"
    echo "File 2: $(basename "$file2")"

    # Normalize both files for comparison
    local temp1 temp2
    temp1=$(mktemp -t "xml1.XXXXXX")
    temp2=$(mktemp -t "xml2.XXXXXX")

    xmllint --format --noblanks "$file1" > "$temp1"
    xmllint --format --noblanks "$file2" > "$temp2"

    # Compare normalized files
    if diff -q "$temp1" "$temp2" >/dev/null; then
        echo "✓ XML files are semantically identical"
    else
        echo "✗ XML files differ semantically"
        echo "Differences:"
        diff -u "$temp1" "$temp2" | head -20
    fi

    rm -f "$temp1" "$temp2"
}

# Simple text-based diff for quick checks
xml_quick_diff() {
    local file1="$1"
    local file2="$2"

    echo "Quick XML diff between $(basename "$file1") and $(basename "$file2"):"
    diff -u "$file1" "$file2" | head -20
}
```

### Element-Level Comparison

**Compare specific XML elements or attributes:**
```bash
# Compare specific elements between XML files
compare_xml_elements() {
    local file1="$1"
    local file2="$2"
    local xpath="${3:-//}"

    echo "Comparing elements at xpath: $xpath"

    # Extract elements from both files
    local elements1 elements2
    elements1=$(xmlstarlet sel -t -m "$xpath" -v "name()" -o ":" -v "text()" -n "$file1" | sort)
    elements2=$(xmlstarlet sel -t -m "$xpath" -v "name()" -o ":" -v "text()" -n "$file2" | sort)

    # Compare extracted elements
    local temp1 temp2
    temp1=$(mktemp -t "elements1.XXXXXX")
    temp2=$(mktemp -t "elements2.XXXXXX")

    echo "$elements1" > "$temp1"
    echo "$elements2" > "$temp2"

    if diff -q "$temp1" "$temp2" >/dev/null; then
        echo "✓ Elements are identical"
    else
        echo "Element differences:"
        diff -u "$temp1" "$temp2"
    fi

    rm -f "$temp1" "$temp2"
}

# Compare XML attributes
compare_xml_attributes() {
    local file1="$1"
    local file2="$2"
    local xpath="${3://*/}"

    echo "Comparing attributes for elements: $xpath"

    xmlstarlet sel -t -m "$xpath" \
        -v "name()" -o ":" \
        -m "@*" -v "name()" -o "=" -v "." -o " " -b \
        -n "$file1" | sort > /tmp/attrs1.txt

    xmlstarlet sel -t -m "$xpath" \
        -v "name()" -o ":" \
        -m "@*" -v "name()" -o "=" -v "." -o " " -b \
        -n "$file2" | sort > /tmp/attrs2.txt

    diff -u /tmp/attrs1.txt /tmp/attrs2.txt
    rm -f /tmp/attrs1.txt /tmp/attrs2.txt
}
```

## Configuration File Comparison

### FUB Configuration Diff

**Compare FUB configuration files:**
```bash
# Compare FUB XML configuration files
compare_fub_configs() {
    local config1="$1"  # e.g., config-dev.xml
    local config2="$2"  # e.g., config-prod.xml

    echo "=== FUB Configuration Comparison ==="
    echo "Comparing: $(basename "$config1") vs $(basename "$config2")"

    # Check for database configuration differences
    echo "Database Configuration:"
    local db1 db2
    db1=$(xmlstarlet sel -t -v "//database/host" -o ":" -v "//database/name" "$config1" 2>/dev/null || echo "N/A")
    db2=$(xmlstarlet sel -t -v "//database/host" -o ":" -v "//database/name" "$config2" 2>/dev/null || echo "N/A")

    if [ "$db1" = "$db2" ]; then
        echo "  ✓ Database config identical: $db1"
    else
        echo "  ✗ Database config differs:"
        echo "    File 1: $db1"
        echo "    File 2: $db2"
    fi

    # Check for API endpoint differences
    echo "API Configuration:"
    local api1 api2
    api1=$(xmlstarlet sel -t -v "//api/endpoint" "$config1" 2>/dev/null || echo "N/A")
    api2=$(xmlstarlet sel -t -v "//api/endpoint" "$config2" 2>/dev/null || echo "N/A")

    if [ "$api1" = "$api2" ]; then
        echo "  ✓ API config identical: $api1"
    else
        echo "  ✗ API config differs:"
        echo "    File 1: $api1"
        echo "    File 2: $api2"
    fi

    # Check for feature flags
    echo "Feature Flags:"
    xmlstarlet sel -t -m "//feature[@enabled='true']" -v "@name" -n "$config1" | sort > /tmp/features1.txt
    xmlstarlet sel -t -m "//feature[@enabled='true']" -v "@name" -n "$config2" | sort > /tmp/features2.txt

    if diff -q /tmp/features1.txt /tmp/features2.txt >/dev/null; then
        echo "  ✓ Feature flags identical"
    else
        echo "  ✗ Feature flag differences:"
        diff -u /tmp/features1.txt /tmp/features2.txt
    fi

    rm -f /tmp/features1.txt /tmp/features2.txt
}

# Compare PHPUnit configuration files
compare_phpunit_configs() {
    local phpunit1="$1"
    local phpunit2="$2"

    echo "=== PHPUnit Configuration Comparison ==="

    # Compare test suites
    echo "Test Suites:"
    xmlstarlet sel -t -m "//testsuite" -v "@name" -o " (" -v "count(directory)" -o " dirs)" -n \
        "$phpunit1" > /tmp/suites1.txt
    xmlstarlet sel -t -m "//testsuite" -v "@name" -o " (" -v "count(directory)" -o " dirs)" -n \
        "$phpunit2" > /tmp/suites2.txt

    diff -u /tmp/suites1.txt /tmp/suites2.txt
    rm -f /tmp/suites1.txt /tmp/suites2.txt

    # Compare coverage settings
    echo "Coverage Configuration:"
    local cov1 cov2
    cov1=$(xmlstarlet sel -t -v "//filter/whitelist/@processUncoveredFilesFromWhitelist" "$phpunit1" 2>/dev/null || echo "N/A")
    cov2=$(xmlstarlet sel -t -v "//filter/whitelist/@processUncoveredFilesFromWhitelist" "$phpunit2" 2>/dev/null || echo "N/A")

    if [ "$cov1" = "$cov2" ]; then
        echo "  ✓ Coverage settings identical"
    else
        echo "  ✗ Coverage settings differ: $cov1 vs $cov2"
    fi
}
```

## Data Export Comparison

### Database Export Diff

**Compare XML database exports:**
```bash
# Compare XML database exports
compare_db_exports() {
    local export1="$1"  # e.g., contacts-old.xml
    local export2="$2"  # e.g., contacts-new.xml

    echo "=== Database Export Comparison ==="

    # Record count comparison
    local count1 count2
    count1=$(xmlstarlet sel -t -v "count(//record)" "$export1")
    count2=$(xmlstarlet sel -t -v "count(//record)" "$export2")

    echo "Record Counts:"
    echo "  Export 1: $count1 records"
    echo "  Export 2: $count2 records"
    echo "  Difference: $((count2 - count1)) records"

    # Compare record IDs to find new/removed records
    echo "Record Analysis:"
    xmlstarlet sel -t -m "//record" -v "@id" -n "$export1" | sort > /tmp/ids1.txt
    xmlstarlet sel -t -m "//record" -v "@id" -n "$export2" | sort > /tmp/ids2.txt

    # Find new records
    local new_records
    new_records=$(comm -13 /tmp/ids1.txt /tmp/ids2.txt | wc -l)
    echo "  New records: $new_records"

    # Find removed records
    local removed_records
    removed_records=$(comm -23 /tmp/ids1.txt /tmp/ids2.txt | wc -l)
    echo "  Removed records: $removed_records"

    if [ "$new_records" -gt 0 ] && [ "$new_records" -le 10 ]; then
        echo "  New record IDs:"
        comm -13 /tmp/ids1.txt /tmp/ids2.txt | sed 's/^/    /'
    fi

    if [ "$removed_records" -gt 0 ] && [ "$removed_records" -le 10 ]; then
        echo "  Removed record IDs:"
        comm -23 /tmp/ids1.txt /tmp/ids2.txt | sed 's/^/    /'
    fi

    rm -f /tmp/ids1.txt /tmp/ids2.txt
}

# Compare specific records between exports
compare_record_changes() {
    local export1="$1"
    local export2="$2"
    local record_id="$3"

    echo "=== Record Comparison: ID $record_id ==="

    # Extract specific record from each export
    xmlstarlet sel -t -m "//record[@id='$record_id']" \
        -m "*" -v "name()" -o ": " -v "text()" -n \
        "$export1" > /tmp/record1.txt

    xmlstarlet sel -t -m "//record[@id='$record_id']" \
        -m "*" -v "name()" -o ": " -v "text()" -n \
        "$export2" > /tmp/record2.txt

    if diff -q /tmp/record1.txt /tmp/record2.txt >/dev/null; then
        echo "✓ Record unchanged"
    else
        echo "✗ Record changes detected:"
        diff -u /tmp/record1.txt /tmp/record2.txt
    fi

    rm -f /tmp/record1.txt /tmp/record2.txt
}
```

## Advanced XML Diff Techniques

### Three-Way XML Merge

**Compare XML files for merge conflicts:**
```bash
# Three-way XML comparison for merge scenarios
xml_three_way_diff() {
    local base="$1"    # Common ancestor
    local local="$2"   # Local changes
    local remote="$3"  # Remote changes

    echo "=== Three-Way XML Merge Analysis ==="
    echo "Base: $(basename "$base")"
    echo "Local: $(basename "$local")"
    echo "Remote: $(basename "$remote")"

    # Normalize all files
    local base_norm local_norm remote_norm
    base_norm=$(mktemp -t "base.XXXXXX")
    local_norm=$(mktemp -t "local.XXXXXX")
    remote_norm=$(mktemp -t "remote.XXXXXX")

    xmllint --format "$base" > "$base_norm"
    xmllint --format "$local" > "$local_norm"
    xmllint --format "$remote" > "$remote_norm"

    # Check for conflicts
    echo "Conflict Analysis:"

    # Local vs Base
    if diff -q "$base_norm" "$local_norm" >/dev/null; then
        echo "  ✓ No local changes"
    else
        echo "  ↗ Local changes detected"
    fi

    # Remote vs Base
    if diff -q "$base_norm" "$remote_norm" >/dev/null; then
        echo "  ✓ No remote changes"
    else
        echo "  ↖ Remote changes detected"
    fi

    # Local vs Remote
    if diff -q "$local_norm" "$remote_norm" >/dev/null; then
        echo "  ✓ No merge conflicts (identical changes)"
    else
        echo "  ⚠️ Potential merge conflicts"
        echo "Local vs Remote differences:"
        diff -u "$local_norm" "$remote_norm" | head -20
    fi

    rm -f "$base_norm" "$local_norm" "$remote_norm"
}
```

### XML Diff for Version Control

**Git integration for XML files:**
```bash
# Git diff for XML files with semantic comparison
git_xml_diff() {
    local file="$1"
    local commit1="${2:-HEAD~1}"
    local commit2="${3:-HEAD}"

    echo "=== Git XML Diff: $file ==="
    echo "Comparing $commit1 to $commit2"

    # Extract versions
    local temp1 temp2
    temp1=$(mktemp -t "git_xml1.XXXXXX")
    temp2=$(mktemp -t "git_xml2.XXXXXX")

    git show "$commit1:$file" > "$temp1" 2>/dev/null || {
        echo "File not found in $commit1"
        rm -f "$temp1" "$temp2"
        return 1
    }

    git show "$commit2:$file" > "$temp2" 2>/dev/null || {
        echo "File not found in $commit2"
        rm -f "$temp1" "$temp2"
        return 1
    }

    # Semantic comparison
    xml_semantic_diff "$temp1" "$temp2"

    rm -f "$temp1" "$temp2"
}

# XML diff statistics for commit analysis
xml_diff_stats() {
    local file="$1"
    local commit_range="${2:-HEAD~10..HEAD}"

    echo "=== XML Change Statistics: $file ==="
    echo "Commit range: $commit_range"

    local changes=0
    git log --oneline "$commit_range" -- "$file" | while read commit message; do
        changes=$((changes + 1))
        echo "  $(echo "$commit" | cut -c1-7): $message"
    done

    echo "Total changes: $changes"

    # Show file size evolution
    echo "File size evolution:"
    git log --reverse --oneline "$commit_range" -- "$file" | head -5 | while read commit message; do
        local size
        size=$(git show "$commit:$file" 2>/dev/null | wc -c)
        echo "  $commit: $size bytes"
    done
}
```

## FUB-Specific Diff Workflows

### Configuration Deployment Validation

**Compare configurations before deployment:**
```bash
# Validate XML configuration changes before FUB deployment
validate_config_deployment() {
    local staging_config="$1"
    local production_config="$2"

    echo "=== FUB Configuration Deployment Validation ==="

    # Critical configuration checks
    echo "Critical Configuration Validation:"

    # Database connection validation
    local staging_db prod_db
    staging_db=$(xmlstarlet sel -t -v "//database/host" "$staging_config" 2>/dev/null)
    prod_db=$(xmlstarlet sel -t -v "//database/host" "$production_config" 2>/dev/null)

    if [ "$staging_db" = "$prod_db" ]; then
        echo "  ⚠️ Database hosts are identical (staging: $staging_db, prod: $prod_db)"
    else
        echo "  ✓ Database hosts differ appropriately"
    fi

    # Debug settings validation
    local staging_debug prod_debug
    staging_debug=$(xmlstarlet sel -t -v "//debug/@enabled" "$staging_config" 2>/dev/null)
    prod_debug=$(xmlstarlet sel -t -v "//debug/@enabled" "$production_config" 2>/dev/null)

    if [ "$prod_debug" = "true" ]; then
        echo "  ⚠️ DEBUG ENABLED in production config"
    else
        echo "  ✓ Debug disabled in production"
    fi

    # Environment-specific settings
    echo "Environment Settings Validation:"
    compare_xml_elements "$staging_config" "$production_config" "//environment-specific"
}

# Generate deployment diff report
generate_deployment_diff_report() {
    local old_config="$1"
    local new_config="$2"
    local report_file="${3:-deployment-diff-report.txt}"

    {
        echo "FUB Configuration Deployment Diff Report"
        echo "Generated: $(date)"
        echo "========================================"
        echo ""
        echo "Old Config: $(basename "$old_config")"
        echo "New Config: $(basename "$new_config")"
        echo ""

        # Semantic diff
        xml_semantic_diff "$old_config" "$new_config"

        echo ""
        echo "Element-level Changes:"
        compare_xml_elements "$old_config" "$new_config" "//setting"

        echo ""
        echo "Security and Environment Validation:"
        validate_config_deployment "$new_config" "$old_config"

    } > "$report_file"

    echo "✓ Deployment diff report generated: $report_file"
}
```

### API Response Evolution Analysis

**Track XML API response changes over time:**
```bash
# Compare API response evolution
analyze_api_response_evolution() {
    local old_response="$1"
    local new_response="$2"

    echo "=== API Response Evolution Analysis ==="

    # Response structure changes
    echo "Structure Changes:"
    local old_structure new_structure
    old_structure=$(xmlstarlet sel -t -m "//*" -v "name()" -n "$old_response" | sort | uniq)
    new_structure=$(xmlstarlet sel -t -m "//*" -v "name()" -n "$new_response" | sort | uniq)

    echo "$old_structure" > /tmp/old_struct.txt
    echo "$new_structure" > /tmp/new_struct.txt

    local added_elements removed_elements
    added_elements=$(comm -13 /tmp/old_struct.txt /tmp/new_struct.txt | wc -l)
    removed_elements=$(comm -23 /tmp/old_struct.txt /tmp/new_struct.txt | wc -l)

    echo "  Added elements: $added_elements"
    echo "  Removed elements: $removed_elements"

    if [ "$added_elements" -gt 0 ]; then
        echo "  New elements:"
        comm -13 /tmp/old_struct.txt /tmp/new_struct.txt | sed 's/^/    /'
    fi

    if [ "$removed_elements" -gt 0 ]; then
        echo "  Removed elements:"
        comm -23 /tmp/old_struct.txt /tmp/new_struct.txt | sed 's/^/    /'
    fi

    # Data type or format changes
    echo "Data Changes:"
    compare_xml_elements "$old_response" "$new_response" "//data"

    rm -f /tmp/old_struct.txt /tmp/new_struct.txt
}
```

This diffing guide provides comprehensive XML comparison tools tailored for FUB's development and deployment workflows while maintaining focus on practical configuration and data management scenarios.