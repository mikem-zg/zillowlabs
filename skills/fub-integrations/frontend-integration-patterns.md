# Frontend Integration Patterns (fub-spa)

Frontend development patterns and component architecture for the **Zynaptic Overlords/FUB+ Integrations team** working on external system integrations.

## Project Structure

### Integration Feature Directories
```
fub-spa/src/features/
├── zillow-auth/                    # Zillow authentication & profile linking
├── zillow-in-app-messaging/        # Zillow messaging integration
├── zillow-stage-mappings/          # Pipeline stage synchronization
└── zhl-transfer-modals/            # ZHL loan officer transfers
```

### Type Definitions
```
fub-spa/src/types/
└── zhl-loan-officers.js           # ZHL loan officer data types
```

## Zillow Integration Frontend Architecture

### Authentication Flow Components

**Core Authentication Component:**
```javascript
// src/features/zillow-auth/components/connect-zillow.jsx
import React, { useState } from 'react';
import { useZillowAuth } from '../hooks/use-zillow-auth';

const ConnectZillow = ({ accountId }) => {
    const {
        isAuthenticated,
        connectUrl,
        connect,
        disconnect,
        isLoading
    } = useZillowAuth();

    if (isAuthenticated) {
        return <ZillowConnectedStatus onDisconnect={disconnect} />;
    }

    return (
        <button
            onClick={() => connect(accountId)}
            disabled={isLoading}
        >
            Connect to Zillow
        </button>
    );
};
```

**Profile Linking Modal:**
```javascript
// src/features/zillow-auth/components/link-zillow-profile-modal.jsx
const LinkZillowProfileModal = ({ isOpen, onClose, availableAgents }) => {
    const [selectedAgentId, setSelectedAgentId] = useState(null);

    const handleLinkProfile = async () => {
        // Call backend API to link agent profile
        await linkZillowProfile(selectedAgentId);
        // Update local state to reflect backend database changes
        refetchZillowData();
        onClose();
    };

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <AgentSelectionList
                agents={availableAgents}
                selectedId={selectedAgentId}
                onSelect={setSelectedAgentId}
            />
            <button onClick={handleLinkProfile}>
                Link Selected Profile
            </button>
        </Modal>
    );
};
```

### Custom Hooks for State Management

**Zillow Authentication Hook:**
```javascript
// src/features/zillow-auth/hooks/use-zillow-auth.js
import { useState, useEffect } from 'react';
import { useAccountContext } from '@/contexts/account-context';

export const useZillowAuth = () => {
    const { accountId } = useAccountContext();
    const [authStatus, setAuthStatus] = useState('checking');
    const [zillowData, setZillowData] = useState(null);

    const checkAuthStatus = async () => {
        try {
            // Query backend zillow_auth table via API
            const response = await fetch(`/api/zillow/auth/status/${accountId}`);
            const data = await response.json();

            setAuthStatus(data.isAuthenticated ? 'connected' : 'disconnected');
            setZillowData(data);
        } catch (error) {
            console.error('Failed to check Zillow auth status:', error);
            setAuthStatus('error');
        }
    };

    const connect = async (authParams) => {
        setAuthStatus('connecting');
        try {
            // Initiate OAuth flow with backend
            const response = await fetch('/api/zillow/auth/connect', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    accountId,
                    ...authParams
                })
            });

            if (response.ok) {
                await checkAuthStatus(); // Refresh status from backend
            }
        } catch (error) {
            setAuthStatus('error');
        }
    };

    const disconnect = async () => {
        // Clear backend zillow_auth tokens
        await fetch(`/api/zillow/auth/disconnect/${accountId}`, {
            method: 'DELETE'
        });

        setAuthStatus('disconnected');
        setZillowData(null);
    };

    useEffect(() => {
        checkAuthStatus();
    }, [accountId]);

    return {
        isAuthenticated: authStatus === 'connected',
        authStatus,
        connectUrl: zillowData?.connectUrl,
        zillowAgent: zillowData?.agent,
        connect,
        disconnect,
        refresh: checkAuthStatus,
        isLoading: authStatus === 'connecting' || authStatus === 'checking'
    };
};
```

**Zillow Flex Access Hook:**
```javascript
// src/features/zillow-auth/hooks/use-zillow-flex-access.js
export const useZillowFlexAccess = () => {
    const { accountId } = useAccountContext();
    const [flexAccess, setFlexAccess] = useState({
        hasAccess: false,
        isLoading: true
    });

    useEffect(() => {
        const checkFlexAccess = async () => {
            try {
                // Query backend to check if user has Zillow Flex capabilities
                const response = await fetch(`/api/zillow/flex/eligibility/${accountId}`);
                const data = await response.json();

                setFlexAccess({
                    hasAccess: data.hasFlexAccess,
                    isLoading: false
                });
            } catch (error) {
                setFlexAccess({
                    hasAccess: false,
                    isLoading: false
                });
            }
        };

        checkFlexAccess();
    }, [accountId]);

    return flexAccess;
};
```

### Data Preloading Pattern

```typescript
// src/features/zillow-auth/hooks/use-preload-zillow-data.ts
import { useCallback } from 'react';
import { useQueryClient } from '@tanstack/react-query';

export const usePreloadZillowData = () => {
    const queryClient = useQueryClient();

    const preloadZillowAgents = useCallback(async (accountId: number) => {
        // Preload data that will be needed for Zillow features
        await queryClient.prefetchQuery({
            queryKey: ['zillow-agents', accountId],
            queryFn: () => fetch(`/api/zillow/agents/${accountId}`).then(r => r.json())
        });
    }, [queryClient]);

    const preloadZillowAuth = useCallback(async (accountId: number) => {
        await queryClient.prefetchQuery({
            queryKey: ['zillow-auth', accountId],
            queryFn: () => fetch(`/api/zillow/auth/status/${accountId}`).then(r => r.json())
        });
    }, [queryClient]);

    return {
        preloadZillowAgents,
        preloadZillowAuth
    };
};
```

## ZHL Integration Frontend Architecture

### Type Definitions

```javascript
// src/types/zhl-loan-officers.js
export type ZhlLoanOfficer = {|
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
    workItemId?: string,
    social?: {
        linkedin?: string,
        facebook?: string
    }
|};
```

### ZHL Transfer Modal Components

```javascript
// src/features/zhl-transfer-modals/zhl-modal-container/zhl-modal-container.jsx
import React, { useState, useEffect } from 'react';

const ZhlModalContainer = ({
    contactId,
    isOpen,
    onClose,
    onTransferComplete
}) => {
    const [availableLoanOfficers, setAvailableLoanOfficers] = useState([]);
    const [selectedOfficer, setSelectedOfficer] = useState(null);
    const [isTransferring, setIsTransferring] = useState(false);

    useEffect(() => {
        const loadLoanOfficers = async () => {
            if (!isOpen) return;

            try {
                // Fetch from backend zhl_loan_officers table
                const response = await fetch(`/api/zhl/loan-officers/available`);
                const officers = await response.json();
                setAvailableLoanOfficers(officers);
            } catch (error) {
                console.error('Failed to load loan officers:', error);
            }
        };

        loadLoanOfficers();
    }, [isOpen]);

    const handleTransfer = async () => {
        if (!selectedOfficer) return;

        setIsTransferring(true);
        try {
            // Execute transfer via backend API
            const response = await fetch('/api/zhl/transfer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    contactId,
                    loanOfficerId: selectedOfficer.nmlsId
                })
            });

            if (response.ok) {
                onTransferComplete(selectedOfficer);
                onClose();
            }
        } catch (error) {
            console.error('Transfer failed:', error);
        } finally {
            setIsTransferring(false);
        }
    };

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <h2>Transfer to ZHL Loan Officer</h2>

            <LoanOfficerSelectionList
                officers={availableLoanOfficers}
                selectedOfficer={selectedOfficer}
                onSelect={setSelectedOfficer}
            />

            <div className="modal-actions">
                <button onClick={onClose}>Cancel</button>
                <button
                    onClick={handleTransfer}
                    disabled={!selectedOfficer || isTransferring}
                >
                    {isTransferring ? 'Transferring...' : 'Transfer Contact'}
                </button>
            </div>
        </Modal>
    );
};
```

## API Communication Patterns

### Standard API Request Pattern

```javascript
// Consistent pattern for integration API calls
const makeIntegrationApiCall = async (endpoint, options = {}) => {
    const { accountId } = useAccountContext();

    const defaultHeaders = {
        'Content-Type': 'application/json',
        'X-Account-ID': accountId
    };

    try {
        const response = await fetch(endpoint, {
            headers: { ...defaultHeaders, ...options.headers },
            ...options
        });

        if (!response.ok) {
            throw new Error(`API call failed: ${response.statusText}`);
        }

        return await response.json();
    } catch (error) {
        console.error('Integration API call failed:', error);
        throw error;
    }
};

// Usage examples:
const connectZillow = (authData) =>
    makeIntegrationApiCall('/api/zillow/auth/connect', {
        method: 'POST',
        body: JSON.stringify(authData)
    });

const getZhlLoanOfficers = () =>
    makeIntegrationApiCall('/api/zhl/loan-officers');
```

### Error Handling for External Integrations

```javascript
// Integration-specific error handling
const handleIntegrationError = (error, integrationType) => {
    switch (integrationType) {
        case 'zillow':
            if (error.code === 'OAUTH_TOKEN_EXPIRED') {
                // Redirect to re-authentication
                window.location.href = '/integrations/zillow/auth';
            } else if (error.code === 'ZILLOW_API_RATE_LIMIT') {
                showNotification('Zillow API rate limit reached. Please try again later.', 'warning');
            }
            break;

        case 'zhl':
            if (error.code === 'ZHL_SERVICE_UNAVAILABLE') {
                showNotification('ZHL service is temporarily unavailable.', 'error');
            } else if (error.code === 'LOAN_OFFICER_NOT_AVAILABLE') {
                showNotification('Selected loan officer is not available for transfers.', 'warning');
            }
            break;

        default:
            showNotification('An integration error occurred. Please try again.', 'error');
    }
};
```

## State Management and Synchronization

### Integration State Context

```javascript
// src/contexts/integration-context.js
const IntegrationContext = createContext();

export const IntegrationProvider = ({ children }) => {
    const [integrationStates, setIntegrationStates] = useState({
        zillow: { status: 'disconnected', lastSync: null },
        zhl: { status: 'active', availableOfficers: [] }
    });

    const updateIntegrationState = (integration, newState) => {
        setIntegrationStates(prev => ({
            ...prev,
            [integration]: { ...prev[integration], ...newState }
        }));
    };

    // Sync with backend database changes
    const syncWithBackend = async () => {
        try {
            const response = await fetch('/api/integrations/status');
            const backendStates = await response.json();

            setIntegrationStates(backendStates);
        } catch (error) {
            console.error('Failed to sync integration states:', error);
        }
    };

    useEffect(() => {
        // Periodic sync with backend
        const interval = setInterval(syncWithBackend, 30000); // Every 30 seconds
        return () => clearInterval(interval);
    }, []);

    return (
        <IntegrationContext.Provider value={{
            integrationStates,
            updateIntegrationState,
            syncWithBackend
        }}>
            {children}
        </IntegrationContext.Provider>
    );
};
```

## Testing Patterns for Integration Components

### Component Testing

```javascript
// src/features/zillow-auth/components/__tests__/connect-zillow.test.js
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { ConnectZillow } from '../connect-zillow';
import { useZillowAuth } from '../../hooks/use-zillow-auth';

// Mock the hook
jest.mock('../../hooks/use-zillow-auth');

describe('ConnectZillow', () => {
    beforeEach(() => {
        useZillowAuth.mockReturnValue({
            isAuthenticated: false,
            connect: jest.fn(),
            isLoading: false
        });
    });

    it('should show connect button when not authenticated', () => {
        render(<ConnectZillow accountId={123} />);

        expect(screen.getByText('Connect to Zillow')).toBeInTheDocument();
    });

    it('should call connect when button is clicked', async () => {
        const mockConnect = jest.fn();
        useZillowAuth.mockReturnValue({
            isAuthenticated: false,
            connect: mockConnect,
            isLoading: false
        });

        render(<ConnectZillow accountId={123} />);

        fireEvent.click(screen.getByText('Connect to Zillow'));

        await waitFor(() => {
            expect(mockConnect).toHaveBeenCalledWith(123);
        });
    });
});
```

### Hook Testing

```javascript
// src/features/zillow-auth/hooks/__tests__/use-zillow-auth.test.js
import { renderHook, act } from '@testing-library/react';
import { useZillowAuth } from '../use-zillow-auth';

// Mock API calls
global.fetch = jest.fn();

describe('useZillowAuth', () => {
    beforeEach(() => {
        fetch.mockClear();
    });

    it('should check auth status on mount', async () => {
        fetch.mockResolvedValueOnce({
            ok: true,
            json: async () => ({
                isAuthenticated: true,
                agent: { id: 123, name: 'Test Agent' }
            })
        });

        const { result } = renderHook(() => useZillowAuth());

        await act(async () => {
            // Wait for useEffect to complete
        });

        expect(fetch).toHaveBeenCalledWith('/api/zillow/auth/status/undefined');
        expect(result.current.isAuthenticated).toBe(true);
    });

    it('should handle connection flow', async () => {
        const mockAuthData = { userId: 123 };

        fetch.mockResolvedValueOnce({
            ok: true,
            json: async () => ({ success: true })
        });

        const { result } = renderHook(() => useZillowAuth());

        await act(async () => {
            await result.current.connect(mockAuthData);
        });

        expect(fetch).toHaveBeenCalledWith('/api/zillow/auth/connect', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                accountId: undefined,
                ...mockAuthData
            })
        });
    });
});
```

## Performance Optimization Patterns

### Lazy Loading Integration Features

```javascript
// Lazy load integration components for better performance
import { lazy, Suspense } from 'react';

const ZillowAuthModal = lazy(() =>
    import('./components/link-zillow-profile-modal')
);

const ZhlTransferModal = lazy(() =>
    import('../zhl-transfer-modals/zhl-modal-container')
);

const IntegrationsPage = () => {
    return (
        <div>
            <Suspense fallback={<div>Loading Zillow integration...</div>}>
                <ZillowAuthModal />
            </Suspense>

            <Suspense fallback={<div>Loading ZHL integration...</div>}>
                <ZhlTransferModal />
            </Suspense>
        </div>
    );
};
```

### Data Caching with React Query

```javascript
// Cache integration data to reduce API calls
import { useQuery } from '@tanstack/react-query';

const useZillowAgents = (accountId) => {
    return useQuery({
        queryKey: ['zillow-agents', accountId],
        queryFn: () => fetch(`/api/zillow/agents/${accountId}`).then(r => r.json()),
        staleTime: 5 * 60 * 1000, // 5 minutes
        cacheTime: 10 * 60 * 1000, // 10 minutes
        refetchOnWindowFocus: false
    });
};

const useZhlLoanOfficers = () => {
    return useQuery({
        queryKey: ['zhl-loan-officers'],
        queryFn: () => fetch('/api/zhl/loan-officers').then(r => r.json()),
        staleTime: 15 * 60 * 1000, // 15 minutes - loan officer data changes less frequently
    });
};
```

## Integration Development Guidelines

1. **Always maintain frontend-backend state synchronization**
2. **Handle external API failures gracefully with user-friendly messages**
3. **Use TypeScript for integration data structures where possible**
4. **Cache integration data appropriately to reduce API calls**
5. **Test both success and failure scenarios for external integrations**
6. **Follow consistent patterns for API communication**
7. **Lazy load integration features to improve initial page load**
8. **Use proper error boundaries for integration components**
9. **Maintain account isolation in frontend integration features**
10. **Document integration-specific business logic clearly**

When developing frontend integration features, always consider the backend database implications and ensure that frontend state stays synchronized with the underlying `zillow_auth`, `zillow_agents`, `zhl_loan_officers`, and related tables.