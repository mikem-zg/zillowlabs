---
name: development-workflow
description: Comprehensive development workflow integration providing visibility into planning, delivery, communication, and validation process coordination for optimal development effectiveness
---

## Overview

Provides comprehensive visibility into Claude Code configuration integration, explaining how planning, delivery tracking, communication, and validation processes coordinate for optimal development effectiveness. Offers discovery paths and integration insights for different roles and use cases.

📋 **Workflow Patterns**: [templates/workflow-patterns.md](templates/workflow-patterns.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **Workflow Reference**: [reference/workflow-reference.md](reference/workflow-reference.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Workflow Discovery and Assessment**
```bash
# Discover workflow integration patterns
/development-workflow --operation="discover-integration"

# Show complete workflow coordination
/development-workflow --operation="show-workflow" --focus_area="cross-process"

# Get role-specific workflow view
/development-workflow --operation="show-workflow" --role="developer"
```

**2. Process Validation and Optimization**
```bash
# Validate current setup completeness
/development-workflow --operation="validate-setup"

# Focus validation on specific area
/development-workflow --operation="validate-setup" --focus_area="planning"

# Identify optimization opportunities
/development-workflow --operation="optimize-processes" --role="manager"
```

**3. Workflow Area Analysis**
```bash
# Analyze planning workflow integration
/development-workflow --operation="discover-integration" --focus_area="planning"

# Review delivery tracking coordination
/development-workflow --operation="show-workflow" --focus_area="delivery"

# Examine communication patterns
/development-workflow --operation="discover-integration" --focus_area="communication"
```

## Quick Reference

### Common Workflow Operations

| Operation | Purpose | Common Use Cases |
|-----------|---------|------------------|
| `discover-integration` | Show configuration relationships | Understanding workflow setup, onboarding new team members |
| `show-workflow` | Display end-to-end process flow | Process documentation, workflow optimization |
| `validate-setup` | Check completeness and integration | Quality assurance, process troubleshooting |
| `optimize-processes` | Identify improvement opportunities | Performance reviews, workflow evolution |

### Key Configuration Files by Workflow Area

#### Planning Workflow Files
- `process/scope-management.md` - Scope limits and change protocols
- `skills/planning-workflow/SKILL.md` - Task creation and planning coordination
- `preferences/tooling/validation-protocols.md` - Evidence requirements

#### Delivery Tracking Files
- `process/delivery-tracking.md` - Task lifecycle and accountability tracking
- `core/accuracy-and-honesty.md` - Truth standards and verification
- `process/project-dashboards.md` - Visibility and analytics

#### Communication Files
- `preferences/communication/status-update-standards.md` - Audience-specific templates
- `core/communication-protocols.md` - Foundational communication patterns
- `process/stakeholder-communication.md` - Communication hierarchy and coordination

→ **Complete workflow patterns and role-based templates**: [templates/workflow-patterns.md](templates/workflow-patterns.md)

### Configuration Relationship Quick Reference

#### Most Referenced Files (Central Integration Points)
1. **delivery-tracking.md** (6+ references) - Central accountability hub
2. **status-update-standards.md** (5+ references) - Communication templates
3. **validation-protocols.md** (4+ references) - Evidence foundation
4. **stakeholder-communication.md** (4+ references) - Coordination center

#### Integration Flow Patterns
```
Planning → Delivery → Communication → Validation
   ↓         ↓           ↓            ↓
Tasks     Progress    Updates      Evidence
   ↓         ↓           ↓            ↓
scope-    delivery-   status-      validation-
mgmt.md   tracking.md update.md    protocols.md
```

## Workflow Operations

### 1. Discover Integration (`discover-integration`)
Shows how configurations cross-reference and integrate with configuration relationship matrix, cross-reference analysis, and integration patterns.

### 2. Show Workflow (`show-workflow`)
Displays end-to-end process coordination from planning phase through review phase, with role-specific perspectives for developer, manager, and stakeholder views.

### 3. Validate Setup (`validate-setup`)
Checks configuration completeness with integration validation checklist covering planning, communication, delivery, and validation integration.

### 4. Optimize Processes (`optimize-processes`)
Identifies improvement opportunities with process optimization analysis covering high-impact optimizations, medium-impact improvements, and continuous improvement strategies.

→ **Complete workflow operations and detailed analysis**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Role-Based Entry Points

### For Developers
```bash
# Get development-focused workflow view
/development-workflow --operation="show-workflow" --role="developer"

# Validate technical setup
/development-workflow --operation="validate-setup" --focus_area="delivery"

# Discover integration patterns for development tasks
/development-workflow --operation="discover-integration" --focus_area="planning"
```

**Key Benefits:**
- Clear task lifecycle with accountability checkpoints
- Evidence-based completion validation
- Technical communication templates for engineering audience
- Integration with MCP tools for efficient validation

### For Managers
```bash
# Get management overview of all processes
/development-workflow --operation="show-workflow" --role="manager"

# Identify process optimization opportunities
/development-workflow --operation="optimize-processes" --role="manager"

# Validate communication and reporting setup
/development-workflow --operation="validate-setup" --focus_area="communication"
```

**Key Benefits:**
- Structured stakeholder communication hierarchy
- Delivery accountability with metrics visibility
- Business-focused communication templates
- Team performance assessment integration

### For Stakeholders
```bash
# Get business-focused workflow overview
/development-workflow --operation="show-workflow" --role="stakeholder"

# Focus on validation and quality assurance
/development-workflow --operation="validate-setup" --focus_area="validation"

# Review cross-process coordination
/development-workflow --operation="discover-integration" --focus_area="cross-process"
```

**Key Benefits:**
- Clear business outcome communication
- Evidence-based delivery claims
- Strategic progress visibility
- Accountability and improvement tracking

→ **Complete role-based workflows and templates**: [templates/workflow-patterns.md](templates/workflow-patterns.md)

## Cross-Skill Integration

### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `planning-workflow` | **Core Planning Integration** | Task creation, scope management, planning coordination → workflow visibility |
| `code-development` | **Development Lifecycle** | Implementation tracking, progress monitoring, delivery coordination |
| `claude-code-maintenance` | **Configuration Management** | Workflow file validation, structure maintenance, integration verification |
| `text-manipulation` | **Status Processing** | Extract status information, format updates, process workflow data |
| `gitlab-pipeline-monitoring` | **Delivery Tracking** | CI/CD integration, deployment tracking, development progress correlation |
| `datadog-management` | **Process Monitoring** | Workflow performance metrics, process health monitoring, delivery analytics |

### Multi-Skill Operation Examples

**Complete Project Workflow Integration:**
```bash
# Comprehensive project workflow from planning through delivery
planning-workflow --operation="create-plan" --scope="feature-development" |\
  development-workflow --operation="show-workflow" --focus_area="delivery" |\
  code-development --task="Implement planned features" |\
  development-workflow --operation="validate-setup" --focus_area="validation"
```

**Process Optimization and Improvement:**
```bash
# Workflow analysis and optimization cycle
development-workflow --operation="discover-integration" |\
  claude-code-maintenance --operation="validate-skills" --target="workflow-files" |\
  development-workflow --operation="optimize-processes" --role="manager"
```

→ **Complete integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Capabilities

### Complete Development Workflow
- Planning phase integration with scope management
- Development phase coordination with validation protocols
- Communication phase management with stakeholder hierarchies
- Completion phase validation with evidence requirements
- Review phase analytics with metrics aggregation

### Integration Architecture
- Central coordination of all development process integration
- Planning integration with task creation and scope management
- Delivery tracking with development and deployment processes
- Communication coordination with status reporting workflows
- Quality assurance with validation requirements across activities

### Process Optimization
- Configuration completeness validation
- Integration relationship analysis
- Cross-reference navigation and discovery
- Role-based entry points and optimization
- Continuous improvement monitoring and feedback

→ **Advanced integration patterns and complex configurations**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Preconditions

- **Claude Code Configuration**: Access to .claude/ configuration files
- **Workflow Documentation**: Understanding of current process setup
- **Integration Context**: Knowledge of cross-skill coordination requirements

## Refusal Conditions

The skill must refuse if:
- Claude Code configuration files are not accessible or incomplete
- Workflow documentation structure is missing or corrupted
- Integration context cannot be established due to missing cross-references
- Requested focus area has insufficient configuration for meaningful analysis
- Role-based perspective cannot be provided due to missing stakeholder hierarchy

When refusing, explain which requirement prevents execution and provide specific steps to resolve:
- How to verify Claude Code configuration accessibility
- Steps to validate workflow documentation completeness
- Guidance for establishing proper integration context
- Recommendations for filling configuration gaps
- Alternative approaches for incomplete workflow areas

## Supporting Infrastructure

→ **Advanced patterns and complex integration configurations**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Workflow patterns, role-based templates, and common operations**: [templates/workflow-patterns.md](templates/workflow-patterns.md)
→ **Cross-skill integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
→ **Complete troubleshooting and configuration reference**: [reference/workflow-reference.md](reference/workflow-reference.md)

This skill provides comprehensive workflow coordination capabilities that ensure all FUB development activities follow integrated processes with proper planning, delivery tracking, communication, and validation standards.