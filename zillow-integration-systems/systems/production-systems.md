## 6 Production Systems Architecture

FUB's Zillow integration consists of 6 distinct production systems managing different aspects of the integration:

### Modern Systems (2024-2025)

#### 1. ZillowAuth - OAuth Credential Management
- **Records**: 29,561 records, 3,643 accounts
- **Database**: Common Database (`zillow_auth`)
- **Frontend Components**: `useZillowAuth` hook, `ZillowAgentCard`, `ConnectZillow` button
- **Backend Services**: `ZillowTokenService`, `ZillowTokenServiceV2`, `ZillowProvider`
- **Key Files**:
  - `/apps/richdesk/models/ZillowAuth.php` - Core OAuth model
  - `/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php` - Token management
  - `/apps/richdesk/communications/ZillowConnect.php` - OAuth flow

#### 2. ZillowSyncUser - Lead Synchronization Pipeline
- **Records**: 12,407 records, 5,267 accounts
- **Metrics**: 677+ million sync events, 3.4+ million leads/week
- **Health**: 98.80% system health across all components
- **Database**: Common Database (`zillow_sync_users`)
- **Key Files**:
  - `/apps/richdesk/models/ZillowSyncUser.php` - Core sync user model
  - `/apps/richdesk/communications/ZillowSync.php` - Lead sync operations

#### 3. ZillowAgent - Agent Identity Resolution
- **Records**: 85,814 records, 6,864 accounts
- **Resolution Distribution**:
  - **CONNECTED (46.72%)** - OAuth authenticated via ZillowAuth
  - **INFERRED (15.99%)** - Team-based or heuristic matching
  - **UNMATCHED (37.29%)** - No FUB user mapping found
- **Database**: Client Database (`zillow_agents`)
- **Key Services**: `ZillowIdentityService`, `ZillowIdMapperService`
- **Key Files**:
  - `/apps/richdesk/models/ZillowAgent.php:533` - getResolutionMethodByUserId()
  - `/apps/richdesk/models/ZillowAgentResolutionMethod.php` - Resolution enum logic
  - `/apps/richdesk/integrations/zillow/identity/ZillowIdentityService.php` - Core resolution service

#### 4. ZillowTeam - Team Hierarchy Management
- **Records**: 4,414 records, 4,077 accounts
- **Features**: Team Lead Permissions (`can_connect_team` functionality)
- **Structure**: Junction table for many-to-many relationships
- **Database**: Client Database (`zillow_teams`, `zillow_agent_teams`)
- **Key Files**:
  - `/apps/richdesk/models/ZillowTeam.php` - Team hierarchy (client DB)
  - `/apps/richdesk/models/ZillowAgentTeam.php` - Agent-team junction table

### Legacy Systems (2022-2023, Still Active)

#### 5. ZillowSyncAgent - Legacy Agent Identity Mapping
- **Database**: Client Database
- **Functionality**:
  - Auto-Matching via email, phone, name resolution using `findMatchingUser()`
  - Backward Compatibility by creating "fake" `zillow_profiles` records
- **Key Files**:
  - `/apps/richdesk/models/ZillowSyncAgent.php` - Legacy agent mapping

#### 6. ZillowSyncTeam - Legacy Team Synchronization
- **Database**: Client Database
- **Integration**: Team API endpoints (`/v1/userInfo` and `/v1/teams/{id}/members`)
- **Maintenance**: Orphan Cleanup (removes disconnected teams and members)
- **Key Files**:
  - `/apps/richdesk/models/ZillowSyncTeam.php` - Legacy team mapping

### System Priority Matrix for Troubleshooting

| System | Critical Issues | Common Problems | Resolution Priority |
|--------|----------------|----------------|-------------------|
| `ZillowAuth` | Token expiration, OAuth failures | Rate limiting, refresh issues | **HIGH** - Affects all other systems |
| `ZillowAgent` | Agent not resolving | Profile sync lag, mapping errors | **HIGH** - Core functionality |
| `ZillowTeam` | Team lead mapping | Hierarchy sync issues | **MEDIUM** - Team features |
| `ZillowSyncUser` | User profile sync | Data consistency issues | **MEDIUM** - User experience |
| `ZillowSyncAgent` | Agent data sync | Performance optimization | **LOW** - Background sync |
| `ZillowSyncTeam` | Team data sync | Sync frequency tuning | **LOW** - Background sync |

### Transaction Sync Four-Path Verification

Transaction sync requires agent verification via 4 paths (Transactions.php:885-1017):
- **Path 1**: Legacy zillow_profile_id (deprecated)
- **Path 2**: OAuth authentication (zillow_auth table)
- **Path 3**: Modern agent records (zillow_agents with encrypted_zuid)
- **Path 4**: Legacy sync agents (zillow_sync_agents table)

**Key Debugging Location**: `/apps/richdesk/libraries/service/zillow/util/Transactions.php:885`

### Lead Sync Health Monitoring

ZillowSyncUser manages lead pipeline health with status values:
- `'healthy'` - Normal operation
- `'warning'` - Minor issues detected
- `'error'` - Significant problems requiring attention

### Team Context: Zynaptic Overlords

**Primary Owner**: Zynaptic Overlords team (FUB+ Integrations and Authentication Team)
- **Engineering Manager**: CL Nolen
- **Team Members**: Matt Turland, Eric Medina, Christian Newberry, Nick Esquerra, Amisha Patel, Fernando Barraza
- **Support Channel**: #fub-zyno-support
- **Jira Board**: [ZYN Project](https://zillowgroup.atlassian.net/jira/software/c/projects/ZYN/boards/6168)
- **Team Page**: [Zynaptic Overlords](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/771653669)