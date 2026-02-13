## Cross-Skill Integration Workflows and Patterns

### Cross-Skill Workflow Patterns

#### Documentation → Diagramming Integration
```bash
# Create diagrams from existing documentation
documentation-retrieval --query="system architecture" --source="confluence" |
  diagramming --type="architecture" --format="mermaid" --output="system-overview.mmd"

# Generate API flow diagrams from OpenAPI specs
documentation-retrieval --query="API specification" --format="openapi" |
  diagramming --type="sequence" --api_flows=true --format="mermaid"

# Document database schemas with visual diagrams
serena-mcp --operation="analyze-schema" --target="database/migrations/" |
  diagramming --type="erd" --format="mermaid" --output="database-schema.mmd"
```

#### Planning → Diagramming Integration
```bash
# Create project timeline diagrams from planning workflows
planning-workflow --operation="export-timeline" --format="gantt-data" |
  diagramming --type="gantt" --format="mermaid" --output="project-timeline.mmd"

# Generate workflow diagrams from task dependencies
planning-workflow --operation="dependency-analysis" --project="fub-integration" |
  diagramming --type="flowchart" --layout="dependency" --format="mermaid"

# Create milestone visualization from planning data
planning-workflow --operation="milestone-export" --timeframe="quarter" |
  diagramming --type="timeline" --format="mermaid" --style="milestone"
```

#### Code Analysis → Diagramming Integration
```bash
# Generate class diagrams from codebase analysis
serena-mcp --operation="analyze-classes" --target="app/Models/" |
  diagramming --type="class" --format="mermaid" --relationships=true

# Create sequence diagrams from API endpoint analysis
backend-static-analysis --target="AuthController" --analyze_flow=true |
  diagramming --type="sequence" --format="mermaid" --actors="user,api,database"

# Generate architecture diagrams from service dependencies
code-development --operation="analyze-dependencies" --target="services/" |
  diagramming --type="architecture" --format="mermaid" --layers=true
```

### Related Skills Integration Matrix

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `documentation-retrieval` | **Content Visualization** | Transform documentation into visual diagrams, API flow visualization |
| `planning-workflow` | **Project Visualization** | Gantt charts, milestone timelines, dependency mapping |
| `serena-mcp` | **Code Visualization** | Class diagrams, architecture analysis, database schema visualization |
| `backend-static-analysis` | **Flow Analysis** | Sequence diagrams from code flow, dependency visualization |
| `support-investigation` | **Issue Flow Mapping** | Problem flow diagrams, system interaction mapping |
| `confluence-management` | **Documentation Integration** | Embed diagrams in Confluence, update visual documentation |
| `gitlab-pipeline-monitoring` | **Pipeline Visualization** | CI/CD flow diagrams, deployment pipeline mapping |
| `datadog-management` | **Monitoring Visualization** | System health diagrams, alert flow mapping |

### Multi-Skill Operation Examples

#### Complete Architecture Documentation Workflow
1. `serena-mcp` - Analyze codebase structure and dependencies
2. `documentation-retrieval` - Gather existing architecture documentation
3. `diagramming` - Create comprehensive architecture diagrams
4. `confluence-management` - Update documentation with visual diagrams
5. `gitlab-pipeline-monitoring` - Validate diagrams in CI/CD pipeline

#### Issue Investigation with Visual Mapping
1. `support-investigation` - Identify problem components and flow
2. `datadog-management` - Gather system metrics and interaction data
3. `diagramming` - Create issue flow diagrams and system interaction maps
4. `confluence-management` - Document investigation with visual aids
5. `jira-management` - Attach diagrams to issue tickets for clarity

### Advanced Integration Patterns

#### Dynamic Architecture Updates
```bash
# Automated architecture diagram updates
monitor_architecture_changes() {
    local project="$1"
    local watch_dir="$2"

    echo "🏗️ Monitoring architecture changes for $project"

    # Watch for code changes
    inotifywait -m -r -e modify,create,delete "$watch_dir" |
    while read path action file; do
        if [[ "$file" =~ \.(php|js|ts|py)$ ]]; then
            echo "Code change detected: $path$file"

            # Re-analyze architecture
            serena-mcp --operation="analyze-architecture" --target="$watch_dir" --format="json" > architecture.json

            # Update architecture diagram
            diagramming --type="architecture" --input="architecture.json" --format="mermaid" --output="current-architecture.mmd"

            # Auto-commit if significant changes
            if [ -n "$(git diff current-architecture.mmd)" ]; then
                git add current-architecture.mmd
                git commit -m "chore: update architecture diagram

Auto-generated from code changes in $file

Co-Authored-By: Claude Code <noreply@anthropic.com>"
                echo "✅ Architecture diagram updated"
            fi
        fi
    done
}
```

#### Cross-Platform Diagram Synchronization
```bash
# Synchronize diagrams across platforms
sync_diagrams_to_platforms() {
    local diagram_dir="$1"
    local platforms=("confluence" "gitlab" "datadog")

    echo "🔄 Synchronizing diagrams across platforms"

    find "$diagram_dir" -name "*.mmd" -o -name "*.dot" | while read -r diagram_file; do
        local basename=$(basename "$diagram_file" | cut -d. -f1)
        local extension="${diagram_file##*.}"

        # Render diagram to multiple formats
        if [[ "$extension" == "mmd" ]]; then
            mmdc -i "$diagram_file" -o "rendered/${basename}.png"
            mmdc -i "$diagram_file" -o "rendered/${basename}.svg"
        elif [[ "$extension" == "dot" ]]; then
            dot -Tpng -o "rendered/${basename}.png" "$diagram_file"
            dot -Tsvg -o "rendered/${basename}.svg" "$diagram_file"
        fi

        # Update in Confluence
        confluence-management --operation="update-page" \
            --page="Architecture Diagrams" \
            --attachment="rendered/${basename}.png" \
            --description="Updated architecture diagram: $basename"

        # Update in GitLab wiki
        gitlab-pipeline-monitoring --operation="update-wiki" \
            --project="fub/architecture" \
            --page="$basename" \
            --image="rendered/${basename}.svg"

        # Update Datadog dashboard if architecture diagram
        if [[ "$basename" == *"architecture"* ]]; then
            datadog-management --operation="update-dashboard" \
                --dashboard="system-overview" \
                --widget="architecture-diagram" \
                --image="rendered/${basename}.png"
        fi

        echo "✅ Synchronized $basename across platforms"
    done
}
```

#### Planning Integration with Visual Timeline
```bash
# Create visual project timelines from planning data
create_visual_timeline() {
    local project="$1"
    local output_format="$2"

    echo "📅 Creating visual timeline for $project"

    # Export planning data
    local planning_data=$(planning-workflow --operation="export-timeline" --project="$project" --format="json")

    # Generate Gantt diagram
    cat > "timeline-${project}.mmd" << EOF
gantt
    title ${project} Project Timeline
    dateFormat YYYY-MM-DD
    axisFormat %m-%d

EOF

    # Process planning data and add to Gantt
    echo "$planning_data" | jq -r '.phases[] | "\(.name) :\(.start_date), \(.duration)d"' >> "timeline-${project}.mmd"

    # Render timeline
    diagramming --input="timeline-${project}.mmd" --format="$output_format" --output="timeline-${project}"

    # Update project documentation
    confluence-management --operation="update-page" \
        --space="DEV" \
        --title="$project Timeline" \
        --content="timeline-${project}.${output_format}"

    echo "✅ Visual timeline created and documented"
}
```

### Quality Assurance Integration

#### Diagram Validation Pipeline
```bash
# Comprehensive diagram validation workflow
validate_diagram_quality() {
    local diagram_file="$1"

    echo "🔍 Validating diagram quality: $diagram_file"

    # Syntax validation
    if [[ "$diagram_file" == *.mmd ]]; then
        mmdc -i "$diagram_file" -o /dev/null
        local syntax_valid=$?
    elif [[ "$diagram_file" == *.dot ]]; then
        dot -Tsvg -o /dev/null "$diagram_file"
        local syntax_valid=$?
    fi

    if [ $syntax_valid -ne 0 ]; then
        echo "❌ Syntax validation failed"
        return 1
    fi

    # Content validation using markdown-management
    markdown-management --operation="validate-diagram-refs" --file="$diagram_file"
    local content_valid=$?

    # Accessibility validation
    if [[ "$diagram_file" == *.mmd ]]; then
        # Check for alt text and proper labeling
        grep -q "accDescr" "$diagram_file" || echo "⚠️  Consider adding accessibility description"
    fi

    # Cross-reference validation
    documentation-retrieval --operation="validate-diagram-refs" --diagram="$diagram_file"

    if [ $content_valid -eq 0 ]; then
        echo "✅ Diagram validation passed"
        return 0
    else
        echo "❌ Content validation failed"
        return 1
    fi
}
```

### Continuous Integration Patterns

#### Automated Diagram Generation in CI/CD
```yaml
# .gitlab-ci.yml excerpt for diagram automation
diagram-generation:
  stage: documentation
  image: node:18
  before_script:
    - npm install -g @mermaid-js/mermaid-cli
    - apt-get update && apt-get install -y graphviz
  script:
    # Generate architecture diagrams from code analysis
    - |
      find . -name "*.php" -path "*/Controllers/*" | \
      xargs grep -l "class.*Controller" | \
      head -5 | \
      while read controller; do
        echo "Analyzing $controller"
        # Extract controller flow and generate sequence diagram
        php analyze-controller-flow.php "$controller" > "${controller##*/}.flow"
        python3 generate-sequence-diagram.py "${controller##*/}.flow" "${controller##*/}.mmd"
        mmdc -i "${controller##*/}.mmd" -o "diagrams/${controller##*/}.png"
      done

    # Update documentation with generated diagrams
    - |
      for diagram in diagrams/*.png; do
        curl -X POST "$CONFLUENCE_API/content/$PAGE_ID/child/attachment" \
             -H "Authorization: Bearer $CONFLUENCE_TOKEN" \
             -F "file=@$diagram"
      done

  artifacts:
    paths:
      - diagrams/
    expire_in: 1 week

  only:
    changes:
      - "**/*.php"
      - "**/*.js"
      - "**/*.ts"
```

#### Monitoring Integration with Visual Alerts
```bash
# Create visual monitoring dashboards
create_monitoring_diagrams() {
    local environment="$1"

    echo "📊 Creating monitoring diagrams for $environment"

    # Get system health data
    local health_data=$(datadog-management --operation="export-health" --environment="$environment" --format="json")

    # Generate system health diagram
    cat > "system-health-${environment}.mmd" << EOF
graph TD
    subgraph "System Health - $environment"
EOF

    # Process health data and create nodes
    echo "$health_data" | jq -r '.services[] |
        if .status == "healthy" then
            "    \(.name)[🟢 \(.name)]"
        elif .status == "warning" then
            "    \(.name)[🟡 \(.name)]"
        else
            "    \(.name)[🔴 \(.name)]"
        end' >> "system-health-${environment}.mmd"

    echo "    end" >> "system-health-${environment}.mmd"

    # Add styling
    cat >> "system-health-${environment}.mmd" << EOF

    classDef healthy fill:#e8f5e8
    classDef warning fill:#fff3e0
    classDef error fill:#ffebee
EOF

    # Render and deploy
    mmdc -i "system-health-${environment}.mmd" -o "system-health-${environment}.png"

    # Update monitoring dashboard
    datadog-management --operation="update-dashboard" \
        --dashboard="system-overview" \
        --widget="health-diagram" \
        --image="system-health-${environment}.png"

    echo "✅ Monitoring diagrams updated"
}
```

### Workflow Handoff Patterns

#### From Diagramming → Other Skills
- **Generated Diagrams**: Provide visual assets for documentation, presentations, and monitoring
- **Architectural Insights**: Supply system understanding for code development and troubleshooting
- **Process Maps**: Deliver workflow visualizations for planning and process improvement
- **Integration Maps**: Generate system interaction diagrams for integration development

#### To Diagramming ← Other Skills
- **Code Structure**: Receive architectural analysis for diagram generation
- **Planning Data**: Get project timelines and dependencies for Gantt charts
- **System Metrics**: Accept monitoring data for health visualization
- **Documentation Content**: Obtain content for visual representation and flow diagrams

### Success Metrics and Monitoring

#### Diagram Usage Analytics
```bash
# Monitor diagram effectiveness and usage
monitor_diagram_usage() {
    local period="$1"

    echo "📈 Monitoring diagram usage over $period"

    # Confluence view metrics
    local confluence_views=$(confluence-management --operation="analytics" --content_type="diagrams" --period="$period")

    # GitLab wiki access
    local gitlab_access=$(gitlab-pipeline-monitoring --operation="wiki-analytics" --period="$period")

    # Documentation retrieval correlation
    local doc_correlation=$(documentation-retrieval --operation="diagram-correlation" --period="$period")

    # Generate usage report
    generate_diagram_usage_report "$confluence_views" "$gitlab_access" "$doc_correlation"
}
```

#### Diagram Quality Metrics
```bash
# Track diagram quality and maintenance
track_diagram_quality() {
    local diagram_dir="$1"

    echo "🎯 Tracking diagram quality metrics"

    local total_diagrams=$(find "$diagram_dir" -name "*.mmd" -o -name "*.dot" | wc -l)
    local outdated_diagrams=$(find "$diagram_dir" -name "*.mmd" -o -name "*.dot" -mtime +30 | wc -l)
    local validated_diagrams=0

    find "$diagram_dir" -name "*.mmd" -o -name "*.dot" | while read -r diagram; do
        if validate_diagram_quality "$diagram"; then
            ((validated_diagrams++))
        fi
    done

    echo "Total diagrams: $total_diagrams"
    echo "Outdated diagrams: $outdated_diagrams"
    echo "Validated diagrams: $validated_diagrams"
    echo "Quality score: $((validated_diagrams * 100 / total_diagrams))%"
}
```

This comprehensive integration framework ensures diagramming works seamlessly with all related skills, providing visual clarity and enhanced understanding across the FUB development ecosystem.