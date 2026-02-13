## Development Workflow Reference Guide

### Parameters and Operations Reference

#### Required Parameters
- `--operation` (required): Workflow operation type
  - `discover-integration`: Show how configurations integrate and cross-reference
  - `show-workflow`: Display end-to-end workflow coordination
  - `validate-setup`: Check configuration completeness and integration
  - `optimize-processes`: Identify improvement opportunities and best practices

#### Optional Parameters
- `--focus_area` (optional): Specific workflow area
  - `planning`: Task creation, scope management, and planning coordination
  - `delivery`: Task lifecycle, accountability, and completion tracking
  - `communication`: Status updates, stakeholder coordination, and reporting
  - `validation`: Evidence requirements, accuracy standards, and quality assurance
  - `cross-process`: Integration points and workflow coordination

- `--role` (optional): Role-based perspective
  - `developer`: Technical focus on implementation and task management
  - `manager`: Business focus on delivery and team coordination
  - `stakeholder`: Outcome focus on business value and strategic progress

### Troubleshooting Quick Guide

| Issue | Likely Cause | Quick Resolution |
|-------|-------------|------------------|
| Missing workflow visibility | Configuration gaps | Run `validate-setup` operation |
| Unclear process coordination | Integration not understood | Use `discover-integration` |
| Process inefficiencies | Optimization opportunities | Run `optimize-processes` with role focus |
| Communication breakdowns | Template/standard issues | Focus on `communication` area |

### Essential Preconditions

- **Claude Code Configuration**: Access to .claude/ configuration files
- **Workflow Documentation**: Understanding of current process setup
- **Integration Context**: Knowledge of cross-skill coordination requirements

### Workflow Operations Deep Dive

#### 1. Discover Integration (`discover-integration`)
Shows how configurations cross-reference and integrate with configuration relationship matrix and cross-reference analysis. Reveals most referenced files and integration patterns.

#### 2. Show Workflow (`show-workflow`)
Displays end-to-end process coordination from planning through review phases. Shows complete development workflow with role-specific perspectives.

#### 3. Validate Setup (`validate-setup`)
Checks configuration completeness with integration validation checklist covering planning, communication, delivery, and validation integration.

#### 4. Optimize Processes (`optimize-processes`)
Identifies improvement opportunities with process optimization analysis covering high-impact optimizations, medium-impact improvements, and continuous improvement strategies.

### Configuration Files Quick Reference

#### Core Workflow Files
- `process/scope-management.md` - Scope limits and change protocols
- `process/delivery-tracking.md` - Task lifecycle and accountability tracking
- `preferences/communication/status-update-standards.md` - Audience-specific templates
- `preferences/tooling/validation-protocols.md` - Evidence requirements
- `process/stakeholder-communication.md` - Communication hierarchy and coordination
- `core/accuracy-and-honesty.md` - Truth standards and verification
- `process/project-dashboards.md` - Visibility and analytics
- `core/communication-protocols.md` - Foundational communication patterns

#### Command Integration Files
- `commands/standup.md` - Daily status updates
- `commands/weekly-update.md` - Weekly progress reports
- `commands/retro.md` - Sprint retrospectives
- `commands/demo-day.md` - Sprint reviews and demonstrations
- `skills/planning-workflow/SKILL.md` - Task creation and planning

### Integration Flow Examples

#### Planning to Delivery Flow
```
scope-management.md → planning-workflow.md → delivery-tracking.md → validation-protocols.md
```

#### Communication Standards Flow
```
status-update-standards.md → communication-protocols.md → stakeholder-communication.md → [commands]
```

#### Validation and Accountability Flow
```
mcp-integration.md → validation-protocols.md → accuracy-and-honesty.md → delivery-tracking.md
```

#### Metrics and Visibility Flow
```
delivery-tracking.md → project-dashboards.md → stakeholder-communication.md → [communications]
```

### Best Practices Checklist

#### Configuration Management
- [ ] Always update "See Also" sections when adding new integrations
- [ ] Maintain bidirectional cross-references between related files
- [ ] Document integration rationale in "Integration with Other Standards" sections
- [ ] Test workflow coordination through actual usage scenarios

#### Process Coordination
- [ ] Ensure workflow steps reference appropriate configuration files
- [ ] Validate that integration points work bidirectionally
- [ ] Maintain consistency in terminology and standards across files
- [ ] Document exceptions and special cases clearly

#### Continuous Improvement
- [ ] Monitor adoption of integrated standards
- [ ] Collect feedback on configuration discoverability
- [ ] Update cross-references when adding new files
- [ ] Maintain role-based entry point relevance

### Common Usage Patterns

#### Daily Operations
```bash
# Developer daily workflow check
/development-workflow --operation="show-workflow" --role="developer"

# Manager team coordination check
/development-workflow --operation="show-workflow" --role="manager"

# Stakeholder progress visibility
/development-workflow --operation="show-workflow" --role="stakeholder"
```

#### Setup Validation
```bash
# Full setup validation
/development-workflow --operation="validate-setup"

# Area-specific validation
/development-workflow --operation="validate-setup" --focus_area="communication"

# Role-specific validation
/development-workflow --operation="validate-setup" --role="developer"
```

#### Process Improvement
```bash
# General optimization
/development-workflow --operation="optimize-processes"

# Role-focused optimization
/development-workflow --operation="optimize-processes" --role="manager"

# Area-focused optimization
/development-workflow --operation="optimize-processes" --focus_area="delivery"
```

#### Integration Discovery
```bash
# General integration overview
/development-workflow --operation="discover-integration"

# Area-specific integration
/development-workflow --operation="discover-integration" --focus_area="planning"

# Cross-process integration
/development-workflow --operation="discover-integration" --focus_area="cross-process"
```

This reference guide provides comprehensive support for understanding and utilizing the development workflow integration capabilities effectively across all FUB development processes.