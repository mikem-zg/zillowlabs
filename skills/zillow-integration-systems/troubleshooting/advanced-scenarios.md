## Advanced Troubleshooting Scenarios

### Multi-System Failure Scenarios

#### Cascading OAuth Token Failures
When OAuth tokens expire, failures cascade across ZillowAuth → ZillowAgent → ZillowSyncUser → Transaction Sync. Advanced investigation requires tracing the complete dependency chain and identifying system-wide impact scope.

**Investigation Steps:**
1. Check token expiration across all affected accounts
2. Trace downstream system dependencies
3. Identify cascade timing and failure propagation
4. Implement coordinated recovery across systems

#### Agent Resolution Method Conflicts
Team restructures create conflicts between CONNECTED (OAuth), INFERRED (team-based), and UNMATCHED (no resolution) states. Resolution requires temporary state overrides while systems synchronize.

**Conflict Resolution:**
- All resolution method transitions are allowed for operational flexibility
- Priority: CONNECTED (priority 3) > INFERRED (priority 2) > UNMATCHED (priority 1)
- Manual overrides available during team restructuring periods
- Audit trail maintained in `zillow_connection_logs`

#### Transaction Sync Bottlenecks
High-volume accounts (10,000+ agents) require batched resolution queries and queue throttling to prevent timeout failures and system overload.

**Performance Mitigation:**
- Implement batch size limits based on account size
- Use queue throttling for high-volume operations
- Enable circuit breaker protection at 10% failure threshold
- Monitor processing times and adjust batch sizes dynamically

### Performance Optimization Techniques

#### Bulk Agent Resolution
Large-scale agent operations use compound queries handling all 4 verification paths simultaneously, with rate limiting for Zillow API compliance and circuit breaker protection.

```php
// Optimized four-path verification for bulk operations
$bulkVerification = [
    'path1' => $this->getBulkLegacyProfiles($agents),     // Legacy zillow_profile_id
    'path2' => $this->getBulkOAuthRecords($agents),       // OAuth authentication
    'path3' => $this->getBulkModernAgents($agents),       // Modern agent records
    'path4' => $this->getBulkSyncAgents($agents),         // Legacy sync agents
];
```

#### Queue Management
Advanced queue processing implements dynamic batch sizing based on system load, failure rate monitoring, and automatic circuit breaker activation at 10% failure threshold.

**Queue Optimization Strategies:**
- Dynamic batch sizing based on current system load
- Failure rate monitoring with automatic throttling
- Circuit breaker activation at 10% failure threshold
- Dead letter queue for failed operations requiring manual review

#### Caching Strategies
Resolution method caching, OAuth token validation caching, and team hierarchy caching reduce database load during high-volume operations.

**Caching Implementation:**
- Resolution method cache: 5-minute TTL for active agents
- OAuth token validation cache: 30-second TTL for frequently accessed tokens
- Team hierarchy cache: 15-minute TTL with invalidation on team changes

### Forensic Debugging Approaches

#### Transaction Sync Forensics
Complete sync failure investigation traces: deal structure validation → four-path agent verification → contact sync connections → mutex status → recent configuration changes.

**Forensic Investigation Checklist:**
1. **Deal Structure**: Validate property, agent, contact associations
2. **Agent Verification**: Test all 4 verification paths systematically
3. **Sync Connections**: Check ZillowSyncUser health and status
4. **Mutex Status**: Verify no concurrent operations blocking sync
5. **Configuration**: Review recent feature flag and setting changes

#### OAuth Token Lifecycle Analysis
Advanced token investigation examines: token history/transitions → resolution method correlations → Bishop API interactions → refresh attempt patterns.

**Token Lifecycle Tracking:**
- Token creation and refresh timestamps
- Resolution method correlation during OAuth flows
- Bishop API interaction patterns and success rates
- Refresh attempt frequency and failure patterns

#### Cross-System State Validation
Consistency checks across all 6 systems verify ZUID alignment, resolution method coherence, and team hierarchy synchronization.

**State Validation Queries:**
```sql
-- Cross-system ZUID consistency check
SELECT za.zuid, za.account_id, zag.encrypted_zuid, zag.resolution_method
FROM zillow_auth za
LEFT JOIN zillow_agents zag ON za.user_id = zag.user_id
WHERE za.account_id = ? AND (zag.encrypted_zuid IS NULL OR za.zuid != DECRYPT(zag.encrypted_zuid));

-- Team hierarchy synchronization validation
SELECT zt.zillow_team_id, zt.account_id, COUNT(zat.agent_id) as member_count,
       (SELECT COUNT(*) FROM zillow_sync_teams WHERE zillow_team_id = zt.zillow_team_id) as legacy_count
FROM zillow_teams zt
LEFT JOIN zillow_agent_teams zat ON zt.id = zat.team_id
GROUP BY zt.id;
```

### Advanced Integration Architecture

#### Cross-System State Coordination
Coordinated state transitions across multiple systems use distributed transaction patterns with pre-flight validation, rollback preparation, and compensating actions for failed operations.

**State Coordination Pattern:**
1. **Pre-flight Validation**: Check all affected systems before state changes
2. **Distributed Lock Acquisition**: Prevent concurrent modifications
3. **Coordinated State Updates**: Update systems in dependency order
4. **Rollback Preparation**: Maintain rollback state for failure recovery
5. **Compensating Actions**: Automated recovery for partial failures

#### Event-Driven Recovery
CloudEvents and SNS integration enables automatic recovery from common failure patterns: expired tokens, resolution conflicts, queue blockages, and team hierarchy desynchronization.

**Recovery Event Patterns:**
- **Token Expiration Events**: Trigger automatic refresh workflows
- **Resolution Conflict Events**: Initiate state reconciliation processes
- **Queue Blockage Events**: Enable automatic queue clearing and retry
- **Team Sync Events**: Coordinate hierarchy updates across systems

#### System Resilience Patterns
Circuit breaker implementation, graceful degradation strategies, and automatic failover mechanisms maintain system stability during partial component failures.

**Resilience Implementation:**
- **Circuit Breaker**: 10% failure threshold with 60-second recovery window
- **Graceful Degradation**: Fallback to legacy systems during modern system outages
- **Automatic Failover**: Secondary path activation for critical operations
- **Health Check Integration**: Continuous monitoring with automatic recovery

### Edge Cases and Complex Scenarios

#### Legacy System Integration
Handling transitions between legacy (ZillowSyncAgent/ZillowSyncTeam) and modern systems while maintaining backward compatibility and data consistency.

**Migration Strategies:**
- Gradual migration with parallel system operation
- Data consistency validation during transition periods
- Rollback capabilities for migration failures
- Legacy system maintenance during modernization

#### Multi-Account Team Scenarios
Complex team hierarchies spanning multiple FUB accounts require special handling for agent resolution and permission management.

**Cross-Account Team Management:**
- Account-specific permission validation
- Cross-account agent resolution coordination
- Team hierarchy consistency across account boundaries
- Permission inheritance and override patterns

#### High-Volume Account Management
Accounts with 5,000+ agents require specialized processing patterns, bulk operation strategies, and performance monitoring to prevent system impact.

**High-Volume Optimization:**
- Specialized bulk processing workflows
- Rate limiting and throttling for API compliance
- Performance monitoring with automated alerting
- Resource allocation optimization for large accounts

#### Data Migration Scenarios
System upgrades and data migrations between Zillow integration versions require careful state preservation and validation across all 6 systems.

**Migration Planning:**
- State preservation across system versions
- Data validation and consistency checks
- Rollback procedures for migration failures
- Minimal downtime coordination across systems

### Emergency Response Procedures

#### OAuth Token Failures
1. Check token expiration: `zillow_auth.expires_at`
2. Validate encryption key availability
3. Test token refresh flow manually
4. Check Bishop API connectivity
5. Review account-specific OAuth settings

#### Agent Resolution Problems
1. Verify resolution method distribution
2. Check agent-to-user mapping integrity
3. Validate team hierarchy relationships
4. Review recent resolution method changes
5. Test four-path verification logic

#### Transaction Sync Failures
1. Validate sync eligibility requirements
2. Check agent verification paths (1-4)
3. Verify contact sync connections
4. Review deal property associations
5. Check DataSyncSystem records

### Production Scale Context

- **677+ million sync events** processed across all systems
- **85,814 agent records** with resolution tracking
- **29,561 OAuth credentials** managing authentication
- **12,407 lead sync connections** handling pipeline
- **6,864 accounts** with active Zillow integration
- **4-path agent verification** system for transaction eligibility