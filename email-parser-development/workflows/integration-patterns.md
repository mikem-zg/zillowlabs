## Integration with Other Claude Code Skills

### Coordinate with Related Skills

- **code-development**: Use for parser implementation and refactoring with FUB patterns
- **backend-test-development**: Essential for PHPUnit test execution and coverage analysis
- **backend-static-analysis**: Critical for Psalm static analysis and type safety validation
- **datadog-management**: Critical for production monitoring and debugging
- **support-investigation**: Use for troubleshooting parser issues in production
- **serena-mcp**: Use for efficient codebase navigation during development

### Workflow Integration Examples

**Complete email parser development workflow using multiple skills in sequence:**
1. `/email-parser-development --lead_source="NewLeadSource" --action="create"`
2. `/backend-static-analysis` (validate type safety and code quality)
3. `/backend-test-development --target="NewLeadSourceTest.php" --server="fubdev-matttu-dev-01"`
4. `/datadog-management --action="create_monitor" --service="email_parsing" --parser="NewLeadSource"`

**Email parser quality assurance workflow:**
1. `/email-parser-development --lead_source="ExistingParser" --action="debug"`
2. `/backend-static-analysis` (identify Psalm issues and baseline impacts)
3. `/code-development --task="Fix static analysis issues in EmailParser" --scope="bug-fix"`
4. `/backend-test-development --target="ExistingParserTest" --action="regression"`

## Production Monitoring and Validation

### Production Monitoring with Datadog

**Essential Monitoring Queries:**

```
# Parser success rate monitoring
service:fub-backend source:php @logger_name:richdesk.analysis.LeadEmail
| grep "[LeadSourceName] parser"
| stats avg(success_rate) by parser_name

# Error pattern analysis
service:fub-backend source:php @logger_name:richdesk.analysis.LeadEmail
| grep "[LeadSourceName] parser" @level:error
| group by error_message

# Performance monitoring
service:fub-backend source:php @logger_name:richdesk.analysis.LeadEmail
| grep "[LeadSourceName] parser"
| stats avg(processing_time_ms) by parser_name
```

### Production Deployment Validation

**Deployment Checklist:**
- ✓ Parser deployed to production without errors?
- ✓ LeadEmail model updated with new parser registration?
- ✓ Sample emails in parsed directory match expected results?
- ✓ No new Psalm baseline entries or errors introduced?
- ✓ Datadog shows no parsing errors for test emails?
- ✓ Lead attribution appearing correctly in FUB UI?

**Post-Deployment Monitoring:**
```bash
# Monitor parser execution via Datadog
/datadog-management --action="search_logs" --service="fub-backend" --query="[LeadSourceName] parser"

# Validate parser success rate
/datadog-management --action="create_monitor" --metric="fub.email_parser.success_rate" --parser="[LeadSourceName]"

# Set up error alerting
/datadog-management --action="create_alert" --condition="error_rate > 5%" --parser="[LeadSourceName]"
```

## Quality Assurance Validation

### Code Quality Validation

**Static Analysis Requirements:**
- ✓ All parser methods have explicit return types?
- ✓ Parameter types documented with proper PHPDoc?
- ✓ No new Psalm baseline entries for parser classes?
- ✓ Null safety patterns implemented for optional fields?
- ✓ Array shape documentation for complex email data structures?
- ✓ Exception handling with proper type declarations?

**Sample and Testing Validation:**
- ✓ Sample emails have PII properly scrubbed?
- ✓ Parser recognizes all sample variations?
- ✓ Tests cover happy path and edge cases?
- ✓ All tests pass in remote environment?
- ✓ Coverage analysis shows >80% for parser methods?
- ✓ Parsed directory updated with expected results?

**Production Validation:**
- ✓ No errors in Datadog after deployment?
- ✓ Correct lead source attribution in UI?
- ✓ Parser success rate meeting expectations (>95%)?
- ✓ Lead processing pipeline functioning end-to-end?
- ✓ Monitoring alerts configured for failures?

## Debugging and Troubleshooting

### Production Issue Investigation

**Debug Workflow:**
1. `/email-parser-development --lead_source="ProblemParser" --action="debug"`
2. `/datadog-management --action="investigate_errors" --service="email_parsing" --parser="ProblemParser"`
3. `/support-investigation --issue="Email parser failures" --environment="production"`

**Common Issues and Solutions:**
- **Parser not recognizing emails**: Review recognition criteria, check for format changes
- **Missing field extraction**: Verify field parsing patterns, check for HTML structure changes
- **Performance issues**: Analyze complex regex patterns, optimize parsing logic
- **Test failures**: Check sample email format, verify PII scrubbing didn't break parsing

### Continuous Integration

**Pre-deployment Testing:**
```bash
# Complete validation workflow
/email-parser-development --lead_source="[ParserName]" --action="test"
/backend-static-analysis --focus="email_parser" --target="[ParserName]Parser.php"
/backend-test-development --target="[ParserName]Test.php" --coverage_target=80
```