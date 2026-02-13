#!/bin/bash

# Validate code blocks in Markdown files
# Usage: ./validate-code-blocks.sh <markdown-file>

set -euo pipefail

MARKDOWN_FILE="${1:-}"
TEMP_DIR=$(mktemp -d)

if [[ -z "$MARKDOWN_FILE" ]]; then
    echo "Usage: $0 <markdown-file>" >&2
    exit 1
fi

if [[ ! -f "$MARKDOWN_FILE" ]]; then
    echo "Error: File '$MARKDOWN_FILE' not found" >&2
    exit 1
fi

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Extract code blocks with language information
extract_code_blocks() {
    local file="$1"
    local current_lang=""
    local current_block=""
    local in_block=false
    local line_num=0

    while IFS= read -r line; do
        ((line_num++))

        if [[ "$line" =~ ^\`\`\`([a-zA-Z0-9_+-]*) ]]; then
            if $in_block; then
                # End of code block
                if [[ -n "$current_lang" && -n "$current_block" ]]; then
                    validate_code_block "$current_lang" "$current_block" "$line_num"
                fi
                current_lang=""
                current_block=""
                in_block=false
            else
                # Start of code block
                current_lang="${BASH_REMATCH[1]}"
                current_block=""
                in_block=true
            fi
        elif $in_block; then
            current_block+="$line"$'\n'
        fi
    done < "$file"
}

validate_code_block() {
    local lang="$1"
    local code="$2"
    local line_num="$3"
    local temp_file=""
    local validation_result=""

    case "$lang" in
        "javascript" | "js")
            temp_file="$TEMP_DIR/code_$line_num.js"
            echo "$code" > "$temp_file"
            if command -v node >/dev/null 2>&1; then
                if ! node --check "$temp_file" 2>/dev/null; then
                    echo "❌ JavaScript syntax error near line $line_num in $MARKDOWN_FILE"
                    node --check "$temp_file" 2>&1 | head -3
                else
                    echo "✅ JavaScript code block at line $line_num is valid"
                fi
            else
                echo "⚠️  Node.js not available - skipping JavaScript validation"
            fi
            ;;

        "typescript" | "ts")
            temp_file="$TEMP_DIR/code_$line_num.ts"
            echo "$code" > "$temp_file"
            if command -v tsc >/dev/null 2>&1; then
                if ! tsc --noEmit --skipLibCheck "$temp_file" 2>/dev/null; then
                    echo "❌ TypeScript syntax error near line $line_num in $MARKDOWN_FILE"
                    tsc --noEmit --skipLibCheck "$temp_file" 2>&1 | head -3
                else
                    echo "✅ TypeScript code block at line $line_num is valid"
                fi
            else
                echo "⚠️  TypeScript compiler not available - skipping TypeScript validation"
            fi
            ;;

        "python" | "py")
            temp_file="$TEMP_DIR/code_$line_num.py"
            echo "$code" > "$temp_file"
            if command -v python3 >/dev/null 2>&1; then
                if ! python3 -m py_compile "$temp_file" 2>/dev/null; then
                    echo "❌ Python syntax error near line $line_num in $MARKDOWN_FILE"
                    python3 -m py_compile "$temp_file" 2>&1 | head -3
                else
                    echo "✅ Python code block at line $line_num is valid"
                fi
            else
                echo "⚠️  Python not available - skipping Python validation"
            fi
            ;;

        "bash" | "sh" | "shell")
            temp_file="$TEMP_DIR/code_$line_num.sh"
            echo "$code" > "$temp_file"
            if ! bash -n "$temp_file" 2>/dev/null; then
                echo "❌ Shell syntax error near line $line_num in $MARKDOWN_FILE"
                bash -n "$temp_file" 2>&1 | head -3
            else
                echo "✅ Shell code block at line $line_num is valid"
            fi
            ;;

        "json")
            temp_file="$TEMP_DIR/code_$line_num.json"
            echo "$code" > "$temp_file"
            if command -v jq >/dev/null 2>&1; then
                if ! jq empty "$temp_file" 2>/dev/null; then
                    echo "❌ JSON syntax error near line $line_num in $MARKDOWN_FILE"
                    jq empty "$temp_file" 2>&1 | head -3
                else
                    echo "✅ JSON code block at line $line_num is valid"
                fi
            else
                echo "⚠️  jq not available - skipping JSON validation"
            fi
            ;;

        "yaml" | "yml")
            temp_file="$TEMP_DIR/code_$line_num.yml"
            echo "$code" > "$temp_file"
            if command -v python3 >/dev/null 2>&1; then
                if ! python3 -c "import yaml; yaml.safe_load(open('$temp_file'))" 2>/dev/null; then
                    echo "❌ YAML syntax error near line $line_num in $MARKDOWN_FILE"
                    python3 -c "import yaml; yaml.safe_load(open('$temp_file'))" 2>&1 | head -3
                else
                    echo "✅ YAML code block at line $line_num is valid"
                fi
            else
                echo "⚠️  Python/PyYAML not available - skipping YAML validation"
            fi
            ;;

        "")
            echo "⚠️  Code block at line $line_num has no language specified"
            ;;

        *)
            echo "ℹ️  Code block language '$lang' at line $line_num - no validator available"
            ;;
    esac
}

echo "🔍 Validating code blocks in: $MARKDOWN_FILE"
extract_code_blocks "$MARKDOWN_FILE"
echo "✨ Code block validation complete"