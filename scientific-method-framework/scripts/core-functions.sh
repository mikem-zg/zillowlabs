#!/bin/bash
# Scientific Method Framework - Core Functions
# Reusable bash utilities for systematic software investigation

# Global variables for investigation state
INVESTIGATION_ID=""
INVESTIGATION_DIR=""
HYPOTHESIS_REGISTRY=""
EVIDENCE_MATRIX=""
VALIDATION_REPORT=""

# Initialize scientific investigation with hypothesis registry and evidence tracking
init_scientific_investigation() {
    local investigation_name="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')

    if [[ -z "$investigation_name" ]]; then
        echo "Error: Investigation name required"
        return 1
    fi

    # Create investigation directory
    INVESTIGATION_ID="${investigation_name// /_}_${timestamp}"
    INVESTIGATION_DIR="./investigation_${INVESTIGATION_ID}"
    mkdir -p "$INVESTIGATION_DIR"

    # Initialize core files
    HYPOTHESIS_REGISTRY="$INVESTIGATION_DIR/hypothesis_registry.md"
    EVIDENCE_MATRIX="$INVESTIGATION_DIR/evidence_matrix.md"
    VALIDATION_REPORT="$INVESTIGATION_DIR/validation_report.md"

    # Create hypothesis registry from template
    create_hypothesis_registry "$investigation_name"

    # Create evidence matrix from template
    create_evidence_matrix "$investigation_name"

    # Create validation report template
    create_validation_report "$investigation_name"

    echo "Scientific investigation initialized: $INVESTIGATION_ID"
    echo "Directory: $INVESTIGATION_DIR"
    echo "Hypothesis Registry: $HYPOTHESIS_REGISTRY"
    echo "Evidence Matrix: $EVIDENCE_MATRIX"

    return 0
}

# Create hypothesis registry template
create_hypothesis_registry() {
    local investigation_name="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    cat > "$HYPOTHESIS_REGISTRY" << EOF
# Hypothesis Registry - ${investigation_name}

**Investigation ID**: ${INVESTIGATION_ID}
**Created**: ${timestamp}
**Status**: Active

## Hypothesis Tracking

| ID | Hypothesis | Priority | Evidence For | Evidence Against | Status | Confidence |
|----|-----------|----------|-------------|-----------------|--------|------------|

## Active Testing
- **Current Focus**: [None assigned]
- **Method**: [Testing method to be determined]
- **Expected Completion**: [To be scheduled]

## Testing Log
EOF

    echo "Created hypothesis registry: $HYPOTHESIS_REGISTRY"
}

# Create evidence matrix template
create_evidence_matrix() {
    local investigation_name="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    cat > "$EVIDENCE_MATRIX" << EOF
# Evidence Matrix - ${investigation_name}

**Investigation ID**: ${INVESTIGATION_ID}
**Created**: ${timestamp}

## Evidence Collection

| Source | Evidence | Credibility | Supports | Contradicts | Weight | Timestamp |
|--------|----------|-------------|----------|-------------|--------|-----------|

## Source Credibility Scale
- **Database/Metrics (10/10)**: Direct measurement, high reliability
- **Application Logs (9/10)**: Structured logging, very reliable
- **System Logs (8/10)**: System-generated, reliable
- **Code Analysis (7/10)**: Static analysis, depends on context
- **User Reports (6/10)**: Human observation, subject to interpretation
- **Timeline Correlation (5/10)**: Circumstantial, requires validation
- **Anecdotal (3/10)**: Unstructured observation, low reliability

## Statistical Summary
- **Total Evidence Points**: 0/0
- **Credibility Weighted Score**: 0.0/10
- **Evidence Diversity Index**: 0 (unique source types)
EOF

    echo "Created evidence matrix: $EVIDENCE_MATRIX"
}

# Create validation report template
create_validation_report() {
    local investigation_name="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    cat > "$VALIDATION_REPORT" << EOF
# Validation Report - ${investigation_name}

**Investigation ID**: ${INVESTIGATION_ID}
**Created**: ${timestamp}
**Status**: In Progress

## Investigation Metrics
- **Duration**: ${timestamp} → [Ongoing]
- **Hypotheses Registered**: 0
- **Hypotheses Tested**: 0
- **Evidence Sources**: 0
- **False Leads**: 0
- **Validation Attempts**: 0

## Confidence Assessment
- **Primary Conclusion**: [To be determined]
- **Confidence Level**: [To be calculated]
- **Supporting Evidence Weight**: 0.0/10
- **Alternative Hypotheses Tested**: 0
- **Bias Check Status**: Pending

## Reproducibility Checklist
- [ ] Investigation steps documented with timestamps
- [ ] Data sources and queries preserved
- [ ] Statistical methods specified
- [ ] Independent validation possible
- [ ] False leads documented for learning

## Validation Status
- **Staging Reproduction**: Not started
- **Controlled Testing**: Not started
- **Statistical Validation**: Not started
- **Bias Assessment**: Not started
EOF

    echo "Created validation report: $VALIDATION_REPORT"
}

# Register a hypothesis for systematic testing
register_hypothesis() {
    local hypothesis_id="$1"
    local hypothesis_text="$2"
    local priority="${3:-medium}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    if [[ -z "$hypothesis_id" || -z "$hypothesis_text" ]]; then
        echo "Error: Hypothesis ID and text required"
        echo "Usage: register_hypothesis <id> <hypothesis> [priority]"
        return 1
    fi

    if [[ -z "$HYPOTHESIS_REGISTRY" || ! -f "$HYPOTHESIS_REGISTRY" ]]; then
        echo "Error: No active investigation. Run init_scientific_investigation first."
        return 1
    fi

    # Check if hypothesis already exists
    if grep -q "| $hypothesis_id |" "$HYPOTHESIS_REGISTRY"; then
        echo "Warning: Hypothesis $hypothesis_id already exists. Updating..."
        # Remove existing entry
        sed -i '' "/| $hypothesis_id |/d" "$HYPOTHESIS_REGISTRY"
    fi

    # Add hypothesis to registry
    # Find the table and add the new row
    local temp_file=$(mktemp)
    awk -v id="$hypothesis_id" -v text="$hypothesis_text" -v prio="$priority" '
        /^\| ID \| Hypothesis/ {
            print $0
            getline; print $0  # Print the separator line
            print "| " id " | " text " | " prio " | - | - | Registered | 0% |"
            found_table = 1
            next
        }
        found_table && /^\| / && !/^\| ID/ { next }
        found_table && !/^\| / { found_table = 0 }
        { print }
    ' "$HYPOTHESIS_REGISTRY" > "$temp_file"

    mv "$temp_file" "$HYPOTHESIS_REGISTRY"

    # Add to testing log
    echo "- [$timestamp] Registered hypothesis $hypothesis_id: \"$hypothesis_text\" (Priority: $priority)" >> "$HYPOTHESIS_REGISTRY"

    echo "Registered hypothesis $hypothesis_id: $hypothesis_text"
    update_investigation_metrics
}

# Collect and score evidence with source credibility
collect_evidence() {
    local source="$1"
    local evidence="$2"
    local credibility="$3"
    local supports="${4:-}"
    local contradicts="${5:-}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    if [[ -z "$source" || -z "$evidence" || -z "$credibility" ]]; then
        echo "Error: Source, evidence, and credibility required"
        echo "Usage: collect_evidence <source> <evidence> <credibility> [supports] [contradicts]"
        return 1
    fi

    if [[ -z "$EVIDENCE_MATRIX" || ! -f "$EVIDENCE_MATRIX" ]]; then
        echo "Error: No active investigation. Run init_scientific_investigation first."
        return 1
    fi

    # Validate credibility score
    if ! [[ "$credibility" =~ ^([1-9]|10)/10$ ]]; then
        echo "Error: Credibility must be in format N/10 where N is 1-10"
        return 1
    fi

    # Determine weight based on credibility
    local weight="Low"
    local cred_num=$(echo "$credibility" | cut -d'/' -f1)
    if [[ $cred_num -ge 9 ]]; then
        weight="Critical"
    elif [[ $cred_num -ge 7 ]]; then
        weight="High"
    elif [[ $cred_num -ge 5 ]]; then
        weight="Medium"
    fi

    # Add evidence to matrix
    local temp_file=$(mktemp)
    awk -v src="$source" -v ev="$evidence" -v cred="$credibility" -v sup="$supports" -v con="$contradicts" -v w="$weight" -v ts="$timestamp" '
        /^\| Source \| Evidence/ {
            print $0
            getline; print $0  # Print the separator line
            print "| " src " | " ev " | " cred " | " sup " | " con " | " w " | " ts " |"
            found_table = 1
            next
        }
        found_table && /^\| / && !/^\| Source/ { next }
        found_table && !/^\| / { found_table = 0 }
        { print }
    ' "$EVIDENCE_MATRIX" > "$temp_file"

    mv "$temp_file" "$EVIDENCE_MATRIX"

    echo "Collected evidence from $source (Credibility: $credibility, Weight: $weight)"
    update_evidence_summary
}

# Test a hypothesis with specified method
test_hypothesis() {
    local hypothesis_id="$1"
    shift
    local method=""
    local control=""
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --method=*)
                method="${1#*=}"
                shift
                ;;
            --control=*)
                control="${1#*=}"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    if [[ -z "$hypothesis_id" ]]; then
        echo "Error: Hypothesis ID required"
        echo "Usage: test_hypothesis <hypothesis_id> [--method=<method>] [--control=<control>]"
        return 1
    fi

    if [[ -z "$HYPOTHESIS_REGISTRY" || ! -f "$HYPOTHESIS_REGISTRY" ]]; then
        echo "Error: No active investigation. Run init_scientific_investigation first."
        return 1
    fi

    # Check if hypothesis exists
    if ! grep -q "| $hypothesis_id |" "$HYPOTHESIS_REGISTRY"; then
        echo "Error: Hypothesis $hypothesis_id not found in registry"
        return 1
    fi

    # Update hypothesis status to "Testing"
    sed -i '' "s/| $hypothesis_id | \([^|]*\) | \([^|]*\) | \([^|]*\) | \([^|]*\) | [^|]* |/| $hypothesis_id | \1 | \2 | \3 | \4 | Testing |/" "$HYPOTHESIS_REGISTRY"

    # Update active testing section
    sed -i '' "s/- \*\*Current Focus\*\*: .*/- **Current Focus**: $hypothesis_id/" "$HYPOTHESIS_REGISTRY"
    if [[ -n "$method" ]]; then
        sed -i '' "s/- \*\*Method\*\*: .*/- **Method**: $method/" "$HYPOTHESIS_REGISTRY"
    fi

    # Add to testing log
    echo "- [$timestamp] Started testing hypothesis $hypothesis_id" >> "$HYPOTHESIS_REGISTRY"
    if [[ -n "$method" ]]; then
        echo "  - Method: $method" >> "$HYPOTHESIS_REGISTRY"
    fi
    if [[ -n "$control" ]]; then
        echo "  - Control: $control" >> "$HYPOTHESIS_REGISTRY"
    fi

    echo "Started testing hypothesis $hypothesis_id"
    if [[ -n "$method" ]]; then
        echo "Method: $method"
    fi
    if [[ -n "$control" ]]; then
        echo "Control: $control"
    fi
}

# Validate conclusion with confidence assessment and bias check
validate_conclusion() {
    local confidence_interval=95
    local bias_check=false
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --confidence-interval=*)
                confidence_interval="${1#*=}"
                shift
                ;;
            --bias-check=*)
                bias_check="${1#*=}"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    if [[ -z "$VALIDATION_REPORT" || ! -f "$VALIDATION_REPORT" ]]; then
        echo "Error: No active investigation. Run init_scientific_investigation first."
        return 1
    fi

    # Calculate investigation metrics
    local hypotheses_count=$(grep -c "^| h" "$HYPOTHESIS_REGISTRY" 2>/dev/null || echo 0)
    local evidence_count=$(grep -c "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null || echo 0)
    local tested_count=$(grep -c "Testing\|Validated\|Rejected" "$HYPOTHESIS_REGISTRY" 2>/dev/null || echo 0)

    # Update validation report
    sed -i '' "s/- \*\*Hypotheses Registered\*\*: .*/- **Hypotheses Registered**: $hypotheses_count/" "$VALIDATION_REPORT"
    sed -i '' "s/- \*\*Hypotheses Tested\*\*: .*/- **Hypotheses Tested**: $tested_count/" "$VALIDATION_REPORT"
    sed -i '' "s/- \*\*Evidence Sources\*\*: .*/- **Evidence Sources**: $evidence_count/" "$VALIDATION_REPORT"

    # Update confidence assessment
    sed -i '' "s/- \*\*Confidence Level\*\*: .*/- **Confidence Level**: ${confidence_interval}%/" "$VALIDATION_REPORT"

    if [[ "$bias_check" == "true" ]]; then
        sed -i '' "s/- \*\*Bias Check Status\*\*: .*/- **Bias Check Status**: Completed/" "$VALIDATION_REPORT"

        # Add bias check results
        cat >> "$VALIDATION_REPORT" << EOF

## Bias Check Results - $timestamp
- **Alternative Hypotheses**: $hypotheses_count registered, $tested_count tested
- **Evidence Diversity**: Multiple source types required
- **Confirmation Bias Check**: $(if [[ $tested_count -gt 1 ]]; then echo "PASS - Multiple hypotheses tested"; else echo "WARN - Consider testing alternatives"; fi)
- **Statistical Rigor**: Confidence interval set to ${confidence_interval}%
EOF
    fi

    echo "Validation completed with ${confidence_interval}% confidence interval"
    echo "Hypotheses: $hypotheses_count registered, $tested_count tested"
    echo "Evidence sources: $evidence_count"

    if [[ "$bias_check" == "true" ]]; then
        echo "Bias check: Completed"
        if [[ $tested_count -le 1 && $hypotheses_count -gt 1 ]]; then
            echo "WARNING: Consider testing more alternative hypotheses to reduce confirmation bias"
        fi
    fi
}

# Generate test cases based on investigation findings
generate_test_cases() {
    local target_skill=""
    local hypothesis_driven=false

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target=*)
                target_skill="${1#*=}"
                shift
                ;;
            --hypothesis-driven=*)
                hypothesis_driven="${1#*=}"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    if [[ -z "$HYPOTHESIS_REGISTRY" || ! -f "$HYPOTHESIS_REGISTRY" ]]; then
        echo "Error: No active investigation. Run init_scientific_investigation first."
        return 1
    fi

    echo "## Generated Test Cases from Scientific Investigation"
    echo "**Investigation ID**: $INVESTIGATION_ID"
    echo "**Timestamp**: $(date '+%Y-%m-%d %H:%M:%S UTC')"
    echo ""

    if [[ "$hypothesis_driven" == "true" ]]; then
        echo "### Hypothesis-Driven Test Cases"

        # Extract validated hypotheses
        local validated_hypotheses=$(grep "| h.*| Validated \|" "$HYPOTHESIS_REGISTRY" 2>/dev/null || true)
        local testing_hypotheses=$(grep "| h.*| Testing \|" "$HYPOTHESIS_REGISTRY" 2>/dev/null || true)

        if [[ -n "$validated_hypotheses" ]]; then
            echo "#### Validated Hypotheses - Create Regression Tests"
            echo "$validated_hypotheses" | while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    local hypothesis=$(echo "$line" | cut -d'|' -f3 | xargs)
                    local hypothesis_id=$(echo "$line" | cut -d'|' -f2 | xargs)
                    echo "- **$hypothesis_id**: Test case to prevent regression of \"$hypothesis\""
                fi
            done
        fi

        if [[ -n "$testing_hypotheses" ]]; then
            echo "#### Active Hypotheses - Create Reproduction Tests"
            echo "$testing_hypotheses" | while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    local hypothesis=$(echo "$line" | cut -d'|' -f3 | xargs)
                    local hypothesis_id=$(echo "$line" | cut -d'|' -f2 | xargs)
                    echo "- **$hypothesis_id**: Test case to reproduce conditions for \"$hypothesis\""
                fi
            done
        fi
    fi

    if [[ -n "$target_skill" ]]; then
        echo ""
        echo "### Integration with $target_skill"
        echo "```bash"
        echo "# Pass investigation findings to $target_skill"
        echo "/$target_skill --source=\"scientific-investigation\" \\"
        echo "              --investigation-id=\"$INVESTIGATION_ID\" \\"
        echo "              --evidence-based=true"
        echo "```"
    fi

    echo ""
    echo "### Evidence-Based Test Scenarios"

    # Extract high-credibility evidence for test case generation
    if [[ -f "$EVIDENCE_MATRIX" ]]; then
        echo "#### Based on High-Credibility Evidence (8+/10)"
        grep "| .* | [89]/10\|10/10" "$EVIDENCE_MATRIX" 2>/dev/null | while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                local source=$(echo "$line" | cut -d'|' -f2 | xargs)
                local evidence=$(echo "$line" | cut -d'|' -f3 | xargs)
                echo "- **$source**: Create test to validate \"$evidence\""
            fi
        done
    fi

    return 0
}

# Update investigation metrics in validation report
update_investigation_metrics() {
    if [[ -z "$VALIDATION_REPORT" || ! -f "$VALIDATION_REPORT" ]]; then
        return 0
    fi

    local hypotheses_count=$(grep -c "^| h" "$HYPOTHESIS_REGISTRY" 2>/dev/null || echo 0)
    local evidence_count=$(grep -c "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null || echo 0)

    sed -i '' "s/- \*\*Hypotheses Registered\*\*: .*/- **Hypotheses Registered**: $hypotheses_count/" "$VALIDATION_REPORT"
    sed -i '' "s/- \*\*Evidence Sources\*\*: .*/- **Evidence Sources**: $evidence_count/" "$VALIDATION_REPORT"
}

# Update evidence summary with statistical calculations
update_evidence_summary() {
    if [[ -z "$EVIDENCE_MATRIX" || ! -f "$EVIDENCE_MATRIX" ]]; then
        return 0
    fi

    # Calculate evidence statistics
    local total_evidence=$(grep -c "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null || echo 0)
    local unique_sources=$(grep "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null | cut -d'|' -f2 | sort -u | wc -l | xargs || echo 0)

    # Calculate weighted score
    local weighted_sum=0
    local total_weight=0

    if [[ $total_evidence -gt 0 ]]; then
        while IFS= read -r line; do
            if [[ $line =~ ^\|\ [^S].*\|.*\|\ ([0-9]+)/10\ \| ]]; then
                local credibility="${BASH_REMATCH[1]}"
                weighted_sum=$((weighted_sum + credibility))
                total_weight=$((total_weight + 10))
            fi
        done < <(grep "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null || true)
    fi

    local weighted_average="0.0"
    if [[ $total_weight -gt 0 ]]; then
        weighted_average=$(echo "scale=1; $weighted_sum * 10 / $total_weight" | bc 2>/dev/null || echo "0.0")
    fi

    # Update statistical summary
    local temp_file=$(mktemp)
    awk -v total="$total_evidence" -v weight_avg="$weighted_average" -v sources="$unique_sources" '
        /## Statistical Summary/ {
            print $0
            print "- **Total Evidence Points**: " total "/∞"
            print "- **Credibility Weighted Score**: " weight_avg "/10"
            print "- **Evidence Diversity Index**: " sources " (unique source types)"
            in_summary = 1
            next
        }
        in_summary && /^- \*\*/ { next }
        in_summary && /^$/ { in_summary = 0 }
        { print }
    ' "$EVIDENCE_MATRIX" > "$temp_file"

    mv "$temp_file" "$EVIDENCE_MATRIX"
}

# Print current investigation status
investigation_status() {
    if [[ -z "$INVESTIGATION_ID" ]]; then
        echo "No active investigation"
        return 1
    fi

    echo "=== Scientific Investigation Status ==="
    echo "Investigation ID: $INVESTIGATION_ID"
    echo "Directory: $INVESTIGATION_DIR"
    echo ""

    if [[ -f "$HYPOTHESIS_REGISTRY" ]]; then
        local hypotheses_count=$(grep -c "^| h" "$HYPOTHESIS_REGISTRY" 2>/dev/null || echo 0)
        local tested_count=$(grep -c "Testing\|Validated\|Rejected" "$HYPOTHESIS_REGISTRY" 2>/dev/null || echo 0)
        echo "Hypotheses: $hypotheses_count registered, $tested_count tested"
    fi

    if [[ -f "$EVIDENCE_MATRIX" ]]; then
        local evidence_count=$(grep -c "^| [^S]" "$EVIDENCE_MATRIX" 2>/dev/null || echo 0)
        echo "Evidence sources: $evidence_count"
    fi

    echo ""
    echo "Files:"
    echo "- Hypothesis Registry: $HYPOTHESIS_REGISTRY"
    echo "- Evidence Matrix: $EVIDENCE_MATRIX"
    echo "- Validation Report: $VALIDATION_REPORT"
}

# Export scientific investigation data for integration with other skills
export_investigation_data() {
    local format="${1:-json}"

    if [[ -z "$INVESTIGATION_ID" ]]; then
        echo "Error: No active investigation"
        return 1
    fi

    case "$format" in
        json)
            echo "{"
            echo "  \"investigation_id\": \"$INVESTIGATION_ID\","
            echo "  \"timestamp\": \"$(date '+%Y-%m-%d %H:%M:%S UTC')\","
            echo "  \"directory\": \"$INVESTIGATION_DIR\","
            echo "  \"files\": {"
            echo "    \"hypothesis_registry\": \"$HYPOTHESIS_REGISTRY\","
            echo "    \"evidence_matrix\": \"$EVIDENCE_MATRIX\","
            echo "    \"validation_report\": \"$VALIDATION_REPORT\""
            echo "  }"
            echo "}"
            ;;
        env)
            echo "export INVESTIGATION_ID=\"$INVESTIGATION_ID\""
            echo "export INVESTIGATION_DIR=\"$INVESTIGATION_DIR\""
            echo "export HYPOTHESIS_REGISTRY=\"$HYPOTHESIS_REGISTRY\""
            echo "export EVIDENCE_MATRIX=\"$EVIDENCE_MATRIX\""
            echo "export VALIDATION_REPORT=\"$VALIDATION_REPORT\""
            ;;
        *)
            echo "Error: Unsupported format '$format'. Use 'json' or 'env'"
            return 1
            ;;
    esac
}

# Load existing investigation from directory
load_investigation() {
    local investigation_dir="$1"

    if [[ -z "$investigation_dir" || ! -d "$investigation_dir" ]]; then
        echo "Error: Investigation directory required and must exist"
        return 1
    fi

    INVESTIGATION_DIR="$investigation_dir"
    INVESTIGATION_ID=$(basename "$investigation_dir" | sed 's/^investigation_//')
    HYPOTHESIS_REGISTRY="$investigation_dir/hypothesis_registry.md"
    EVIDENCE_MATRIX="$investigation_dir/evidence_matrix.md"
    VALIDATION_REPORT="$investigation_dir/validation_report.md"

    if [[ ! -f "$HYPOTHESIS_REGISTRY" ]]; then
        echo "Error: Hypothesis registry not found in $investigation_dir"
        return 1
    fi

    echo "Loaded investigation: $INVESTIGATION_ID"
    echo "Directory: $INVESTIGATION_DIR"

    return 0
}

# Helper function to check if required tools are available
check_scientific_dependencies() {
    local missing_tools=()

    # Check for basic tools used in calculations
    if ! command -v bc >/dev/null 2>&1; then
        missing_tools+=("bc")
    fi

    if ! command -v awk >/dev/null 2>&1; then
        missing_tools+=("awk")
    fi

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo "Warning: Missing tools for scientific calculations: ${missing_tools[*]}"
        echo "Install with: brew install bc gawk (on macOS) or appropriate package manager"
        return 1
    fi

    return 0
}

# Initialize scientific method framework
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being run directly, show usage
    echo "Scientific Method Framework - Core Functions"
    echo "Usage: source this file to load scientific investigation utilities"
    echo ""
    echo "Key functions:"
    echo "  init_scientific_investigation <name>  - Start new investigation"
    echo "  register_hypothesis <id> <text>       - Add hypothesis to registry"
    echo "  collect_evidence <source> <evidence>  - Add evidence with credibility"
    echo "  test_hypothesis <id>                  - Begin systematic testing"
    echo "  validate_conclusion                   - Assess confidence and bias"
    echo "  investigation_status                  - Show current status"
    echo ""
    check_scientific_dependencies
else
    # Being sourced, perform initialization check
    check_scientific_dependencies >/dev/null
fi