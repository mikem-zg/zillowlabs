## Database Architecture

### Common Database Systems
- `zillow_auth` - OAuth tokens and credentials
- `zillow_sync_users` - Lead sync connections and health monitoring
- `zillow_connection_logs` - Audit trail for resolution changes
- `zillow_lead_events_log` - Lead synchronization event tracking

### Client Database Systems
- `zillow_agents` - Agent identity resolution with 4 resolution methods
- `zillow_teams` - Team hierarchy and relationships
- `zillow_agent_teams` - Many-to-many agent-team memberships
- `zillow_sync_agents` - Legacy agent mappings (backwards compatibility)
- `zillow_sync_teams` - Legacy team mappings (backwards compatibility)

### Database Schema Deep Dive

#### ZillowAgent Resolution Methods
```sql
-- Resolution Method Distribution (Production):
-- CONNECTED (1): 46.72% - OAuth authenticated
-- INFERRED (3): 15.99% - Team-based matching
-- UNMATCHED (4): 37.29% - No resolution
-- Note: Value 2 is deprecated (legacy records exist)

SELECT resolution_method, COUNT(*) as count,
       (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) as percentage
FROM zillow_agents
GROUP BY resolution_method;
```

#### Transaction Sync Eligibility Query
```sql
-- Check if deal is eligible for Zillow sync
-- Requires: Property + Agent (4-path verification) + Contact + DataSyncSystem
SELECT d.id, d.property_id,
       COUNT(DISTINCT da.agent_id) as agent_count,
       COUNT(DISTINCT dc.contact_id) as contact_count
FROM deals d
LEFT JOIN deals_agents da ON d.id = da.deal_id
LEFT JOIN deals_contacts dc ON d.id = dc.deal_id
WHERE d.account_id = ? AND d.id = ?
GROUP BY d.id, d.property_id;
```

#### OAuth Health Check Query
```sql
-- Check OAuth token health across accounts
SELECT za.account_id,
       COUNT(*) as auth_records,
       COUNT(CASE WHEN za.expires_at > NOW() THEN 1 END) as valid_tokens,
       COUNT(CASE WHEN za.expires_at <= NOW() THEN 1 END) as expired_tokens
FROM zillow_auth za
GROUP BY za.account_id
HAVING COUNT(*) > 0;
```

## Frontend Implementation (fub-spa)

### Core Hook: useZillowAuth

**Central authentication management hook**
- **Location**: `src/features/zillow-auth/hooks/use-zillow-auth`
- **Returns**:
  - `authorizationUrlRedirect`
  - `zillowAuthConnection`
  - `agentIdentity`
  - `zillowConnectNotification`
  - `onDisconnectAction`

### UI Components

- **ZillowAgentCard** (`src/features/zillow-auth/components/zillow-agent-card.jsx`) - Agent profile display
- **ConnectZillow** (`src/features/zillow-auth/components/connect-zillow.jsx`) - OAuth initiation button
- **ZillowSettings** (`src/pages/settings/default/zillow-settings.jsx`) - Complete settings integration
- **LinkZillowProfileCard** (`src/pages/getting-started/link-zillow-profile-card.jsx`) - Getting started flow

### Data Models

```typescript
// src/schema/integrations.js
export type ZillowAuthConnection = {
    zuid: number,
    accountId: number,
    userId: number,
    zillowId: ?ZillowId,
    zillowSyncUserId: ?number,
};

export type ZillowAgentIdentity = {
    name: string,
    organization: string,
    phone: string,
    isTopAgent: boolean,
    imageUrl: string,
    ratings?: ZillowAgentRatings,
};
```

### OAuth Implementation Patterns

**OAuth Authorization URL Construction:**
```javascript
const connectZillowHref = `${authorizationUrlRedirect}?${new URLSearchParams({
    return_url: '/2/settings',
}).toString()}`;
```

**Disconnection Implementation:**
```javascript
integrationSchema.actions
    .destroy({ id: 'zillow', resourceId: zillowAuthConnection.zuid })
    .subscribe(() => {
        // Force reload zillow integration
        integrationSchema.actions
            .fetch({ id: 'zillow', includeDetails: true })
            .subscribe((payload) => {
                integrationSchema.actions.dispatch(payload);
            });
    });
```

## Codebase Navigation Reference

### Core Model Files
```
/apps/richdesk/models/
├── ZillowAuth.php                    # OAuth credential management (common DB)
├── ZillowSyncUser.php                # Lead sync pipeline (common DB)
├── ZillowAgent.php                   # Agent identity resolution (client DB)
├── ZillowTeam.php                    # Team hierarchy (client DB)
├── ZillowAgentTeam.php              # Agent-team junction table (client DB)
├── ZillowAgentResolutionMethod.php   # Resolution method enum
├── ZillowSyncAgent.php              # Legacy agent mapping (client DB)
├── ZillowSyncTeam.php               # Legacy team mapping (client DB)
├── ZillowConnectionLog.php          # Audit trail (common DB)
└── ZillowLeadEventsLog.php          # Event tracking (common DB)
```

### Integration Services
```
/apps/richdesk/integrations/zillow/
├── identity/
│   ├── ZillowIdentityService.php     # Core identity resolution
│   ├── ZillowIdMapperService.php     # ID mapping logic
│   └── dtos/                         # Identity DTOs
├── bishop/                           # Bishop API integration
├── event_platform/                  # Event streaming
├── graph/                           # Zillow Graph API
└── ZillowApiAgentSyncDataSource.php # API data source
```

### OAuth and Authentication
```
/apps/richdesk/libraries/service/zillow/
├── oauth/
│   ├── ZillowTokenService.php        # Token management
│   ├── ZillowTokenServiceV2.php      # V2 token service
│   ├── ZillowProviderWrapper.php     # OAuth provider wrapper
│   └── ZillowApi.php                 # API client
└── util/
    ├── Transactions.php              # Transaction sync (4-path verification)
    ├── ZillowLeadEventsSync.php      # Lead event processing
    └── ZillowTechConnect.php         # Tech Connect integration
```

### Communication and Events
```
/apps/richdesk/communications/
├── ZillowSync.php                    # Lead sync operations
└── ZillowConnect.php                 # OAuth connection management

/apps/richdesk/extensions/command/
├── ZillowSyncWorker.php              # Resque queue worker
└── ZillowPropertySyncWorker.php      # Property sync worker
```