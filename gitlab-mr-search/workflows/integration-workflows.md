## Cross-Skill Integration Workflows and Coordination Patterns

### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `gitlab-mr-management` | **MR Lifecycle** | Search → Create/Update → Merge workflow |
| `gitlab-pipeline-monitoring` | **CI/CD Integration** | Search MRs → Check pipeline status → Debug failures |
| `gitlab-collaboration` | **Review Workflow** | Search MRs → Triage comments → Resolve discussions |
| `code-development` | **Development Cycle** | Find related MRs → Implement changes → Create new MR |
| `support-investigation` | **Issue Resolution** | Search related MRs → Analyze fixes → Document solutions |
| `datadog-management` | **Performance Monitoring** | Find deployment MRs → Correlate with metrics → Investigate issues |

### Multi-Skill Operation Examples

**Complete MR Workflow: Search → Analysis → Action**
```bash
# Comprehensive MR processing pipeline
complete_mr_workflow() {
    # 1. Discover MRs ready for action
    local ready_mrs=$(/gitlab-mr-search --query="state:opened label:ready-for-review")
    
    # 2. Analyze each MR for merge readiness
    for mr in $ready_mrs; do
        local triage=$(/gitlab-mr-search --mr_iid="$mr" --operation="triage-summary")
        
        # 3. Check pipeline status integration
        local pipeline=$(/gitlab-pipeline-monitoring --mr_iid="$mr" --operation="status")
        
        # 4. [Future] Automated merge when available
        # /gitlab-mr-management --operation="merge" --mr_iid="$mr"
        
        echo "MR $mr: $(extract_status "$triage") - Pipeline: $pipeline"
    done
}
```

**Development Workflow: Find Similar Work → Implement → Create MR**
```bash
# Research-driven development workflow
research_driven_development() {
    local feature_name="$1"
    
    # 1. Find related existing work
    local similar_work=$(/gitlab-mr-search --query="$feature_name created_after:last_month")
    
    # 2. Analyze implementation patterns
    echo "Found $(count "$similar_work") related MRs for context"
    
    # 3. Coordinate with code development
    /code-development --task="Implement $feature_name" --context="$similar_work"
    
    # 4. [Future] Create new MR with learned patterns
    # /gitlab-mr-management --operation="create" --template="learned_from:$similar_work"
}
```

**Investigation Workflow: Find Related Changes → Analyze → Debug**
```bash
# Issue investigation with MR correlation
issue_investigation_workflow() {
    local issue_description="$1"
    local timeframe="$2"
    
    # 1. Find recent related changes
    local related_changes=$(/gitlab-mr-search --query="$issue_description merged_after:$timeframe")
    
    # 2. Support investigation with MR context
    /support-investigation --issue="$issue_description" --mr_context="$related_changes"
    
    # 3. Correlate with performance metrics
    /datadog-management --query="$issue_description" --time_range="$timeframe"
    
    # 4. Generate comprehensive analysis
    echo "Investigation complete: $(count "$related_changes") related MRs analyzed"
}
```

### Workflow Handoff Patterns

**From gitlab-mr-search → Other Skills:**
- **MR Metadata and Context**: Provides comprehensive MR details for management operations
- **Search Results for Pipeline Analysis**: Supplies MR lists for pipeline monitoring and CI/CD integration
- **Triage Summaries for Collaboration**: Delivers automated analysis for review workflows
- **Related MR Discovery**: Offers development context and pattern learning opportunities

**To gitlab-mr-search ← Other Skills:**
- **MR Creation Notifications**: Receives updates from management operations for search index updates
- **Pipeline Status Updates**: Gets CI/CD status for search result enrichment and filtering
- **Review Outcomes**: Obtains collaboration workflow results for triage classification updates
- **Project Context**: Accepts development and investigation context for intelligent search enhancement

### Integration Architecture

**FUB GitLab Ecosystem Integration:**

```markdown
gitlab-mr-search serves as the discovery hub for:

1. **Daily Development Workflows**: Morning standup MR reviews, afternoon merge queues
2. **Sprint Planning**: Milestone-based MR tracking, velocity analysis
3. **Release Management**: Branch-specific MR monitoring, hotfix tracking
4. **Code Review Process**: Reviewer assignment discovery, approval status tracking
5. **Quality Assurance**: MR readiness assessment, automated triage classification
```

### Coordinated Development Workflows

**Morning Standup Integration:**
```bash
# Daily standup MR summary
daily_standup_summary() {
    echo "=== Daily MR Status Summary ==="
    
    # 1. My active MRs
    local my_mrs=$(/gitlab-mr-search --query="author:me state:opened")
    echo "My open MRs: $(count "$my_mrs")"
    
    # 2. MRs waiting for my review
    local review_queue=$(/gitlab-mr-search --query="reviewer:me state:opened")
    echo "Review queue: $(count "$review_queue")"
    
    # 3. Team MRs needing attention
    local team_attention=$(/gitlab-mr-search --query="label:needs-attention state:opened")
    echo "Team attention needed: $(count "$team_attention")"
    
    # 4. Pipeline failures requiring action
    local failing=$(/gitlab-mr-search --query="label:pipeline-failed state:opened")
    echo "Pipeline failures: $(count "$failing")"
}
```

**Sprint Planning Coordination:**
```bash
# Sprint planning MR analysis
sprint_planning_analysis() {
    local sprint_milestone="$1"
    
    # 1. Sprint MR overview
    local sprint_mrs=$(/gitlab-mr-search --query="milestone:'$sprint_milestone'")
    
    # 2. Pipeline monitoring integration
    for mr in $sprint_mrs; do
        local pipeline_health=$(/gitlab-pipeline-monitoring --mr_iid="$mr" --operation="health-check")
        echo "MR $mr: $pipeline_health"
    done
    
    # 3. Velocity calculation
    local merged_count=$(echo "$sprint_mrs" | jq '[.[] | select(.state == "merged")] | length')
    echo "Sprint velocity: $merged_count MRs merged"
}
```

**Release Management Integration:**
```bash
# Release preparation workflow
release_preparation_workflow() {
    local release_branch="$1"
    
    # 1. Find release candidate MRs
    local release_candidates=$(/gitlab-mr-search --query="target_branch:$release_branch state:opened")
    
    # 2. Validate pipeline readiness
    for mr in $release_candidates; do
        local pipeline_status=$(/gitlab-pipeline-monitoring --mr_iid="$mr" --operation="release-readiness")
        local triage=$(/gitlab-mr-search --mr_iid="$mr" --operation="triage-summary")
        
        if [[ "$pipeline_status" == "ready" ]] && [[ "$triage" == "ready" ]]; then
            echo "✅ MR $mr ready for release"
        else
            echo "❌ MR $mr blocked: Pipeline=$pipeline_status, Triage=$triage"
        fi
    done
    
    # 3. Generate release summary
    local ready_count=$(count_ready_mrs "$release_candidates")
    echo "Release readiness: $ready_count/$(count "$release_candidates") MRs ready"
}
```

### Advanced Cross-Skill Coordination

**Automated Quality Gates:**
```bash
# Quality gate enforcement with cross-skill coordination
quality_gate_enforcement() {
    local project_path="$1"
    
    # 1. Find MRs ready for quality check
    local candidates=$(/gitlab-mr-search --query="label:ready-for-qa state:opened" --project_path="$project_path")
    
    # 2. Multi-skill validation
    for mr in $candidates; do
        # Pipeline validation
        local pipeline_ok=$(/gitlab-pipeline-monitoring --mr_iid="$mr" --operation="quality-check")
        
        # Code quality analysis
        local code_quality=$(/backend-static-analysis --mr_iid="$mr" --analysis_type="quality-gate")
        
        # Security validation
        local security_ok=$(/support-investigation --operation="security-scan" --mr_iid="$mr")
        
        # Automated decision
        if [[ "$pipeline_ok" == "pass" ]] && [[ "$code_quality" == "pass" ]] && [[ "$security_ok" == "pass" ]]; then
            echo "✅ MR $mr passed quality gates"
            # [Future] Auto-approve: /gitlab-mr-management --operation="approve" --mr_iid="$mr"
        else
            echo "❌ MR $mr failed quality gates: P=$pipeline_ok C=$code_quality S=$security_ok"
        fi
    done
}
```

**Performance Impact Analysis:**
```bash
# Performance impact analysis across skills
performance_impact_analysis() {
    local deployment_mr="$1"
    
    # 1. Analyze deployment MR
    local mr_details=$(/gitlab-mr-search --mr_iid="$deployment_mr" --operation="triage-summary")
    
    # 2. Monitor post-deployment metrics
    local performance_metrics=$(/datadog-management --operation="deployment-impact" --mr_context="$mr_details")
    
    # 3. Correlate with related MRs
    local related_changes=$(/gitlab-mr-search --query="merged_after:last_deploy label:performance")
    
    # 4. Generate impact report
    echo "Performance Impact Analysis for MR $deployment_mr:"
    echo "Metrics change: $performance_metrics"
    echo "Related performance MRs: $(count "$related_changes")"
    
    # 5. Create follow-up investigation if needed
    if [[ "$performance_metrics" == "degraded" ]]; then
        /support-investigation --issue="Performance degradation post MR $deployment_mr" \
                              --environment="production" \
                              --mr_context="$mr_details"
    fi
}
```

### Integration Success Metrics

**Workflow Efficiency Tracking:**
```bash
# Track integration workflow effectiveness
track_integration_effectiveness() {
    # 1. Search operation efficiency
    local search_time=$(measure_search_performance)
    
    # 2. Cross-skill handoff success rate
    local handoff_success=$(measure_handoff_success_rate)
    
    # 3. End-to-end workflow completion time
    local e2e_time=$(measure_e2e_workflow_time)
    
    echo "Integration Metrics:"
    echo "Search efficiency: $search_time ms average"
    echo "Handoff success rate: $handoff_success%"
    echo "E2E workflow time: $e2e_time minutes average"
}
```

These integration workflows provide comprehensive coordination between gitlab-mr-search and all related development skills, enabling sophisticated automated workflows and intelligent development lifecycle management.
