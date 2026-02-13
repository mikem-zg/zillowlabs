## Development Workflow Patterns and Templates

### Role-Based Quick Commands

#### For Developers
```bash
# Get development-focused workflow view
/development-workflow --operation="show-workflow" --role="developer"

# Validate technical setup
/development-workflow --operation="validate-setup" --focus_area="delivery"

# Discover integration patterns for development tasks
/development-workflow --operation="discover-integration" --focus_area="planning"
```

**Developer Perspective Workflow:**
1. **Task Planning**: planning-workflow.md → scope-management.md
2. **Development**: validation-protocols.md → mcp-integration.md
3. **Completion**: delivery-tracking.md → accuracy-and-honesty.md
4. **Communication**: standup.md → status-update-standards.md

**Key Benefits:**
- Clear task lifecycle with accountability checkpoints
- Evidence-based completion validation
- Technical communication templates for engineering audience
- Integration with MCP tools for efficient validation

#### For Managers
```bash
# Get management overview of all processes
/development-workflow --operation="show-workflow" --role="manager"

# Identify process optimization opportunities
/development-workflow --operation="optimize-processes" --role="manager"

# Validate communication and reporting setup
/development-workflow --operation="validate-setup" --focus_area="communication"
```

**Manager Perspective Workflow:**
1. **Team Coordination**: stakeholder-communication.md → project-dashboards.md
2. **Progress Tracking**: delivery-tracking.md → scope-management.md
3. **Status Reporting**: status-update-standards.md → weekly-update.md
4. **Review Processes**: retro.md → demo-day.md

**Key Benefits:**
- Structured stakeholder communication hierarchy
- Delivery accountability with metrics visibility
- Business-focused communication templates
- Team performance assessment integration

#### For Stakeholders
```bash
# Get business-focused workflow overview
/development-workflow --operation="show-workflow" --role="stakeholder"

# Focus on validation and quality assurance
/development-workflow --operation="validate-setup" --focus_area="validation"

# Review cross-process coordination
/development-workflow --operation="discover-integration" --focus_area="cross-process"
```

**Stakeholder Perspective Workflow:**
1. **Progress Visibility**: weekly-update.md → project-dashboards.md
2. **Outcome Tracking**: demo-day.md → stakeholder-communication.md
3. **Value Assessment**: delivery-tracking.md → scope-management.md
4. **Strategic Alignment**: retro.md accountability review

**Key Benefits:**
- Clear business outcome communication
- Evidence-based delivery claims
- Strategic progress visibility
- Accountability and improvement tracking

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

### Complete Development Workflow Template
```
1. Planning Phase
   scope-management.md → planning-workflow.md
   • Assess scope within limits (5 tasks, 3 chains, 2 integrations)
   • Create tasks with acceptance criteria and validation methods

2. Development Phase
   validation-protocols.md → mcp-integration.md
   • Validate all claims with MCP tool evidence
   • Maintain evidence collection throughout development

3. Communication Phase
   status-update-standards.md → stakeholder-communication.md
   • Use audience-appropriate templates (engineering/manager/stakeholder)
   • Coordinate updates through stakeholder hierarchy

4. Completion Phase
   delivery-tracking.md → accuracy-and-honesty.md
   • Validate acceptance criteria with evidence
   • Mark complete only with full validation proof

5. Review Phase
   project-dashboards.md → [retro.md, demo-day.md]
   • Aggregate metrics for visibility and improvement
   • Conduct accountability assessment and learning capture
```

### Discovery Patterns

#### By Daily Usage
- **Daily Standup**: standup.md → status-update-standards.md → delivery-tracking.md
- **Task Management**: planning-workflow.md → delivery-tracking.md → validation-protocols.md
- **Progress Updates**: weekly-update.md → stakeholder-communication.md → project-dashboards.md
- **Quality Assurance**: validation-protocols.md → accuracy-and-honesty.md → mcp-integration.md

#### By Process Focus
- **Planning Excellence**: scope-management.md → planning-workflow.md → delivery-tracking.md
- **Communication Clarity**: status-update-standards.md → communication-protocols.md → stakeholder-communication.md
- **Delivery Accountability**: delivery-tracking.md → validation-protocols.md → accuracy-and-honesty.md
- **Continuous Improvement**: project-dashboards.md → retro.md → demo-day.md

#### By Integration Complexity
- **Simple Integration**: File A references File B (e.g., standup.md uses status-update-standards.md)
- **Coordinated Integration**: Multiple files work together (e.g., planning → delivery → communication)
- **System Integration**: Full workflow coordination (e.g., scope → planning → delivery → validation → communication → review)

This template library provides the foundation for systematic development workflow coordination and role-based process optimization.