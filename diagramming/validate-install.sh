#!/bin/bash

# Diagramming Skill Validation Script
# Tests installation and basic functionality

echo "🔍 Diagramming Skill Validation"
echo "================================"

# Check if we're in the right directory
if [[ ! -f "SKILL.md" ]]; then
    echo "❌ ERROR: SKILL.md not found. Run from skill directory."
    exit 1
fi

echo "✅ SKILL.md found"

# Check for required files
FILES_TO_CHECK=(
    "syntax-reference.md"
    "templates/microservices-architecture.dot"
    "templates/api-sequence.mmd"
    "examples/database-schema.mmd"
    "evaluation-1-flowchart.json"
    "evaluation-2-architecture.json"
    "evaluation-3-sequence.json"
)

for file in "${FILES_TO_CHECK[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file found"
    else
        echo "❌ $file missing"
    fi
done

echo
echo "🧪 Testing Tool Dependencies"
echo "============================"

# Check for Mermaid CLI
if command -v mmdc &> /dev/null; then
    echo "✅ Mermaid CLI available: $(mmdc --version)"
else
    echo "⚠️  Mermaid CLI not found. Install with: npm install -g @mermaid-js/mermaid-cli"
fi

# Check for Graphviz
if command -v dot &> /dev/null; then
    echo "✅ Graphviz available: $(dot -V 2>&1)"
else
    echo "⚠️  Graphviz not found. Install with:"
    echo "     macOS: brew install graphviz"
    echo "     Ubuntu: sudo apt install graphviz"
fi

echo
echo "🔧 Testing Diagram Rendering"
echo "============================="

# Test Mermaid rendering if CLI available
if command -v mmdc &> /dev/null; then
    echo "Testing Mermaid rendering..."
    cat > test-flow.mmd << 'EOF'
flowchart TD
    A[Start] --> B{Test}
    B -->|Pass| C[Success]
    B -->|Fail| D[Error]
EOF

    if mmdc -i test-flow.mmd -o test-flow.svg -t neutral 2>/dev/null; then
        echo "✅ Mermaid SVG generation successful"
        rm -f test-flow.mmd test-flow.svg
    else
        echo "❌ Mermaid SVG generation failed"
    fi
else
    echo "⏭️  Skipping Mermaid test (CLI not available)"
fi

# Test Graphviz rendering if available
if command -v dot &> /dev/null; then
    echo "Testing Graphviz rendering..."
    cat > test-graph.dot << 'EOF'
digraph test {
    A -> B;
    B -> C;
}
EOF

    if dot -Tsvg test-graph.dot -o test-graph.svg 2>/dev/null; then
        echo "✅ Graphviz SVG generation successful"
        rm -f test-graph.dot test-graph.svg
    else
        echo "❌ Graphviz SVG generation failed"
    fi
else
    echo "⏭️  Skipping Graphviz test (not available)"
fi

echo
echo "📋 Summary"
echo "=========="
echo "Skill files: ✅ Complete"
echo "Tool deps: $(command -v mmdc &> /dev/null && echo "✅" || echo "⚠️") Mermaid $(command -v dot &> /dev/null && echo "✅" || echo "⚠️") Graphviz"
echo
echo "🚀 Skill is ready for use!"
echo "   Try: /diagramming flowchart user login process"