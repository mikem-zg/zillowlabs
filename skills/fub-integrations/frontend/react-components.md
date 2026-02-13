## Frontend Integration Patterns (fub-spa)

### Zillow Frontend Integration Features

**Directory:** `src/features/zillow-auth/`

#### Core Components
- **`link-zillow-profile-modal.jsx`** - Modal for linking Zillow profiles
- **`zillow-agent-card.jsx`** - Display Zillow agent information
- **`connect-zillow.jsx`** - Initial Zillow connection flow
- **`zillow-connect-notification.jsx`** - Connection status notifications
- **`zillow-top-agent-badge.jsx`** - Top agent verification display

#### Hooks and State Management
```javascript
// Zillow authentication hook
import { useZillowAuth } from '@/features/zillow-auth/hooks/use-zillow-auth';

const {
    isAuthenticated,
    authStatus,
    connectUrl,
    disconnect
} = useZillowAuth();

// Zillow Flex access validation
import { useZillowFlexAccess } from '@/features/zillow-auth/hooks/use-zillow-flex-access';

const { hasFlexAccess, isLoading } = useZillowFlexAccess();
```

#### Data Preloading Pattern
```typescript
// Preload Zillow data for performance
import { usePreloadZillowData } from '@/features/zillow-auth/hooks/use-preload-zillow-data';

const { preloadZillowAgents, preloadZillowAuth } = usePreloadZillowData();
```

### ZHL Frontend Integration Features

**Directory:** `src/features/zhl-transfer-modals/`

#### Type Definitions
```javascript
// ZHL Loan Officer type (from types/zhl-loan-officers.js)
type ZhlLoanOfficer = {|
    nmlsId: number,
    firstName: string,
    lastName: string,
    email: string,
    phoneNumber: string,
    statesLicensed: string[],
    schedulingUrl: string,
    originationManagerEmail: string,
    shareableLoLinkUrl: string,
    imageUrl: string | null,
    isDedicated: boolean,
    isSuggested?: boolean,
    aboutMe?: string,
    rating?: number,
    totalReviews?: number,
    outOfOfficeStartDate?: string,
    outOfOfficeEndDate?: string,
    teamId?: string,
    reservationId?: string,
    workItemId?: string
|};
```

#### ZHL Modal Components
- **`zhl-modal-container.jsx`** - Container for ZHL transfer modals
- Handles loan officer selection and transfer workflows
- Manages state between frontend and backend ZHL systems

### Additional Integration Features

#### Zillow Stage Mappings
**Directory:** `src/features/zillow-stage-mappings/`
- Maps FUB pipeline stages to Zillow lead status
- Synchronizes stage changes between systems

#### Zillow In-App Messaging
**Directory:** `src/features/zillow-in-app-messaging/`
- Handles Zillow messaging integration
- Syncs messages between Zillow and FUB inbox

## Frontend-Backend Integration Patterns

### API Communication
```javascript
// Typical API call pattern for integrations
const response = await fetch('/api/zillow/auth/connect', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-Account-ID': accountId
    },
    body: JSON.stringify({
        userZuid: zillowUserId,
        agentId: zillowAgentId
    })
});

const authData = await response.json();
```

### State Synchronization
```javascript
// Keep frontend state in sync with backend database changes
useEffect(() => {
    if (zillowAuthStatus === 'connected') {
        // Sync with backend zillow_auth table
        refetchZillowAgents();
        updateContactZillowData();
    }
}, [zillowAuthStatus]);
```

### Error Handling Patterns
```javascript
// Integration-specific error handling
try {
    await connectToZillow(authParams);
} catch (error) {
    if (error.code === 'ZILLOW_OAUTH_EXPIRED') {
        // Redirect to re-authentication
        redirectToZillowAuth();
    } else if (error.code === 'ZHL_SERVICE_UNAVAILABLE') {
        // Show service maintenance message
        showZhlMaintenanceNotice();
    }
}
```

## Frontend Integration Testing

### Component Testing
```javascript
// Example from __tests__/link-zillow-profile-modal.test.js
describe('LinkZillowProfileModal', () => {
    it('should handle zillow agent connection', () => {
        const mockZillowAgent = {
            id: 123,
            name: 'John Agent',
            email: 'john@zillow.com'
        };

        render(<LinkZillowProfileModal agent={mockZillowAgent} />);
        // Test integration flow
    });
});
```

### Hook Testing
```javascript
// Example from __tests__/use-zillow-auth.test.js
describe('useZillowAuth', () => {
    it('should return authentication status from backend', async () => {
        // Mock backend API response
        const mockAuthResponse = {
            isAuthenticated: true,
            authStatus: 'connected'
        };

        // Test hook behavior
        const { result } = renderHook(() => useZillowAuth());
        expect(result.current.isAuthenticated).toBe(true);
    });
});
```

### Integration Test Patterns
```javascript
// Full integration test with backend simulation
describe('ZillowIntegrationFlow', () => {
    it('should complete full zillow connection workflow', async () => {
        // Setup test environment
        const mockAccount = createMockAccount();
        const mockZillowAgent = createMockZillowAgent();

        // Simulate user interaction
        render(<ConnectZillow account={mockAccount} />);

        // Test complete workflow
        fireEvent.click(screen.getByText('Connect to Zillow'));

        // Verify integration state changes
        await waitFor(() => {
            expect(screen.getByText('Connected')).toBeInTheDocument();
        });
    });
});
```

## Performance Optimization

### Component Optimization
```javascript
// Memoize expensive Zillow data calculations
const ZillowAgentCard = React.memo(({ agent }) => {
    const memoizedAgentData = useMemo(() => {
        return processZillowAgentData(agent);
    }, [agent.id, agent.profileData]);

    return (
        <div className="zillow-agent-card">
            {/* Render optimized agent data */}
        </div>
    );
});
```

### Data Loading Optimization
```javascript
// Lazy load integration components
const ZillowAuthModal = React.lazy(() =>
    import('./components/zillow-auth-modal')
);

// Preload critical integration data
useEffect(() => {
    if (user.hasZillowAccess) {
        preloadZillowAgents(user.accountId);
    }
}, [user.hasZillowAccess]);
```