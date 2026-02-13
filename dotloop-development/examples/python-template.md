# Dotloop Python App Template

Copy-paste template for building a production-ready dotloop integration with Flask, OAuth 2.0, webhook handling, and full API client.

---

## Project Structure

```
dotloop-app/
├── app.py              # Flask server entry point
├── dotloop_client.py   # Dotloop API client
├── oauth.py            # OAuth 2.0 blueprint
├── webhooks.py         # Webhook blueprint
├── requirements.txt
├── .env.example
└── README.md
```

---

## File: `requirements.txt`

```
flask>=3.0.0
requests>=2.31.0
python-dotenv>=1.0.0
gunicorn>=22.0.0
```

---

## File: `.env.example`

```
DOTLOOP_CLIENT_ID=your_client_id
DOTLOOP_CLIENT_SECRET=your_client_secret
DOTLOOP_REDIRECT_URI=https://yourapp.com/oauth/callback
DOTLOOP_WEBHOOK_SECRET=your_webhook_signing_key
PORT=3000
FLASK_ENV=development
```

---

## File: `dotloop_client.py`

```python
import os
import time
import logging
from typing import Any, Generator
import requests

logger = logging.getLogger(__name__)

BASE_URL = 'https://api-gateway.dotloop.com/public/v2'


class DotloopApiError(Exception):
    def __init__(self, status_code: int, message: str):
        self.status_code = status_code
        self.message = message
        super().__init__(f"Dotloop API Error {status_code}: {message}")


class DotloopClient:
    def __init__(self, access_token: str | None = None):
        self.access_token = access_token or os.environ.get('DOTLOOP_ACCESS_TOKEN', '')
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': f'Bearer {self.access_token}',
            'Content-Type': 'application/json',
        })

    def set_access_token(self, token: str) -> None:
        self.access_token = token
        self.session.headers['Authorization'] = f'Bearer {token}'

    def _request(
        self,
        method: str,
        endpoint: str,
        params: dict | None = None,
        json_data: dict | None = None,
        max_retries: int = 3,
    ) -> dict:
        url = f"{BASE_URL}{endpoint}"

        for attempt in range(max_retries):
            response = self.session.request(
                method=method,
                url=url,
                params=params,
                json=json_data,
                allow_redirects=True,
            )

            remaining = response.headers.get('X-RateLimit-Remaining')
            reset_ms = response.headers.get('X-RateLimit-Reset')
            if remaining is not None and int(remaining) < 10:
                logger.warning(f"Rate limit warning: {remaining} requests remaining, resets in {reset_ms}ms")

            if response.status_code == 429:
                wait_seconds = int(reset_ms or '5000') / 1000
                logger.warning(f"Rate limited. Waiting {wait_seconds}s (attempt {attempt + 1}/{max_retries})")
                time.sleep(wait_seconds)
                continue

            if response.status_code == 401:
                raise DotloopApiError(401, 'Access token expired or invalid — refresh and retry')

            if response.status_code >= 400:
                raise DotloopApiError(response.status_code, response.text)

            return response.json()

        raise DotloopApiError(429, 'Max retries exceeded due to rate limiting')

    def get_account(self) -> dict:
        return self._request('GET', '/account')

    def get_profiles(self) -> dict:
        return self._request('GET', '/profile')

    def get_profile(self, profile_id: int) -> dict:
        return self._request('GET', f'/profile/{profile_id}')

    def get_loops(self, profile_id: int, batch_number: int = 1, batch_size: int = 50) -> dict:
        return self._request('GET', f'/profile/{profile_id}/loop', params={
            'batch_number': batch_number,
            'batch_size': batch_size,
        })

    def get_loop(self, profile_id: int, loop_id: int) -> dict:
        return self._request('GET', f'/profile/{profile_id}/loop/{loop_id}')

    def create_loop(self, profile_id: int, data: dict) -> dict:
        return self._request('POST', f'/profile/{profile_id}/loop', json_data=data)

    def loop_it(self, profile_id: int, data: dict) -> dict:
        return self._request('POST', '/loop-it', params={'profile_id': profile_id}, json_data=data)

    def get_loop_detail(self, profile_id: int, loop_id: int) -> dict:
        return self._request('GET', f'/profile/{profile_id}/loop/{loop_id}/detail')

    def update_loop_detail(self, profile_id: int, loop_id: int, sections: dict) -> dict:
        return self._request('PATCH', f'/profile/{profile_id}/loop/{loop_id}/detail', json_data=sections)

    def get_participants(self, profile_id: int, loop_id: int) -> dict:
        return self._request('GET', f'/profile/{profile_id}/loop/{loop_id}/participant')

    def add_participant(self, profile_id: int, loop_id: int, data: dict) -> dict:
        return self._request('POST', f'/profile/{profile_id}/loop/{loop_id}/participant', json_data=data)

    def get_contacts(self, batch_number: int = 1, batch_size: int = 50) -> dict:
        return self._request('GET', '/contact', params={
            'batch_number': batch_number,
            'batch_size': batch_size,
        })

    def create_contact(self, data: dict) -> dict:
        return self._request('POST', '/contact', json_data=data)

    def get_loop_templates(self, profile_id: int) -> dict:
        return self._request('GET', f'/profile/{profile_id}/loop-template')

    def iter_loops(self, profile_id: int) -> Generator[dict, None, None]:
        """Generator that auto-paginates through all loops using batch_number.

        Usage:
            client = DotloopClient(access_token)
            for loop in client.iter_loops(profile_id=4711):
                print(loop['name'], loop['status'])
        """
        batch_number = 1
        while True:
            data = self.get_loops(profile_id, batch_number=batch_number, batch_size=50)
            loops = data.get('data', [])
            yield from loops
            if len(loops) < 50:
                break
            batch_number += 1

    def iter_contacts(self) -> Generator[dict, None, None]:
        """Generator that auto-paginates through all contacts.

        Usage:
            client = DotloopClient(access_token)
            for contact in client.iter_contacts():
                print(contact.get('firstName'), contact.get('lastName'))
        """
        batch_number = 1
        while True:
            data = self.get_contacts(batch_number=batch_number, batch_size=50)
            contacts = data.get('data', [])
            yield from contacts
            if len(contacts) < 50:
                break
            batch_number += 1
```

---

## File: `oauth.py`

```python
import os
import secrets
import logging
from base64 import b64encode
from flask import Blueprint, request, redirect, jsonify
import requests as http_requests

logger = logging.getLogger(__name__)

oauth_bp = Blueprint('oauth', __name__, url_prefix='/oauth')

AUTH_BASE = 'https://auth.dotloop.com/oauth'
CLIENT_ID = os.environ.get('DOTLOOP_CLIENT_ID', '')
CLIENT_SECRET = os.environ.get('DOTLOOP_CLIENT_SECRET', '')
REDIRECT_URI = os.environ.get('DOTLOOP_REDIRECT_URI', '')

# In-memory token storage — use a database in production
_token_store: dict[str, dict] = {}


def get_tokens(user_id: str = 'default') -> dict | None:
    return _token_store.get(user_id)


def save_tokens(user_id: str, tokens: dict) -> None:
    import time
    _token_store[user_id] = {**tokens, 'issued_at': time.time()}


def exchange_code_for_tokens(code: str) -> dict:
    """Exchange authorization code for access and refresh tokens."""
    basic_auth = b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()

    response = http_requests.post(
        f'{AUTH_BASE}/token',
        params={
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': REDIRECT_URI,
        },
        headers={'Authorization': f'Basic {basic_auth}'},
    )

    if not response.ok:
        raise Exception(f"Token exchange failed: {response.status_code} {response.text}")

    return response.json()


def refresh_access_token(refresh_token: str) -> dict:
    """Refresh an expired access token.

    CRITICAL: Refreshing invalidates the previous access token immediately.
    In clustered environments, coordinate refresh to avoid race conditions.
    """
    basic_auth = b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()

    response = http_requests.post(
        f'{AUTH_BASE}/token',
        params={
            'grant_type': 'refresh_token',
            'refresh_token': refresh_token,
        },
        headers={'Authorization': f'Basic {basic_auth}'},
    )

    if not response.ok:
        raise Exception(f"Token refresh failed: {response.status_code} {response.text}")

    return response.json()


@oauth_bp.route('/authorize')
def authorize():
    """Redirect user to dotloop for authorization."""
    state = secrets.token_hex(16)
    # In production, store state in session for CSRF validation

    auth_url = (
        f"{AUTH_BASE}/authorize"
        f"?response_type=code"
        f"&client_id={CLIENT_ID}"
        f"&redirect_uri={REDIRECT_URI}"
        f"&state={state}"
    )
    return redirect(auth_url)


@oauth_bp.route('/callback')
def callback():
    """Handle OAuth callback with authorization code."""
    error = request.args.get('error')
    if error:
        logger.error(f"Authorization denied: {error}")
        return jsonify({'error': f'Authorization denied: {error}'}), 400

    code = request.args.get('code')
    if not code:
        return jsonify({'error': 'Missing authorization code'}), 400

    # In production, validate state against session to prevent CSRF

    try:
        tokens = exchange_code_for_tokens(code)
        logger.info('Tokens received successfully')
        save_tokens('default', tokens)

        return jsonify({
            'success': True,
            'message': 'Authorization successful',
            'expires_in': tokens.get('expires_in'),
            'scope': tokens.get('scope'),
        })

    except Exception as e:
        logger.error(f"Token exchange error: {e}")
        return jsonify({'error': 'Token exchange failed'}), 500


@oauth_bp.route('/refresh', methods=['POST'])
def refresh():
    """Refresh access token."""
    data = request.get_json(silent=True) or {}
    user_id = data.get('userId', 'default')
    existing = get_tokens(user_id)

    if not existing:
        return jsonify({'error': 'No tokens found — authorize first'}), 400

    try:
        tokens = refresh_access_token(existing['refresh_token'])
        save_tokens(user_id, tokens)
        logger.info('Token refreshed successfully')

        return jsonify({
            'success': True,
            'expires_in': tokens.get('expires_in'),
        })

    except Exception as e:
        logger.error(f"Token refresh error: {e}")
        return jsonify({'error': 'Token refresh failed'}), 500
```

---

## File: `webhooks.py`

```python
import os
import hmac
import hashlib
import time
import logging
from flask import Blueprint, request, jsonify

logger = logging.getLogger(__name__)

webhooks_bp = Blueprint('webhooks', __name__, url_prefix='/webhooks')

WEBHOOK_SECRET = os.environ.get('DOTLOOP_WEBHOOK_SECRET', '')
MAX_TIMESTAMP_AGE_MS = 5 * 60 * 1000  # 5 minutes

# In-memory processed event tracking — use a database with TTL in production
_processed_events: set[str] = set()


def verify_signature(payload: bytes, signature: str, secret: str) -> bool:
    """Verify dotloop webhook signature using HMAC-SHA1."""
    expected = hmac.new(
        secret.encode('utf-8'),
        payload,
        hashlib.sha1,
    ).hexdigest()
    return hmac.compare_digest(expected, signature)


@webhooks_bp.before_request
def check_signature():
    """Verify webhook signature before processing."""
    if not WEBHOOK_SECRET:
        logger.warning('DOTLOOP_WEBHOOK_SECRET not set — skipping signature verification')
        return

    signature = request.headers.get('X-DOTLOOP-SIGNATURE', '')
    if not signature:
        logger.error('Missing X-DOTLOOP-SIGNATURE header')
        return jsonify({'error': 'Missing signature'}), 401

    if not verify_signature(request.get_data(), signature, WEBHOOK_SECRET):
        logger.error('Invalid webhook signature')
        return jsonify({'error': 'Invalid signature'}), 401


@webhooks_bp.before_request
def check_timestamp():
    """Reject events older than 5 minutes."""
    data = request.get_json(silent=True)
    if not data:
        return

    event_time = data.get('timestamp', 0)
    now_ms = int(time.time() * 1000)

    if abs(now_ms - event_time) > MAX_TIMESTAMP_AGE_MS:
        logger.error(f"Stale event: timestamp {event_time} is more than 5 minutes old")
        return jsonify({'error': 'Event timestamp too old'}), 400


@webhooks_bp.route('/dotloop', methods=['POST'])
def handle_webhook():
    """Handle all dotloop webhook events."""
    payload = request.get_json()
    event_id = payload.get('eventId', '')
    event_type = payload.get('eventType', '')
    event_data = payload.get('event', {})

    # Idempotency check — a single action can trigger multiple events
    if event_id in _processed_events:
        logger.info(f"Duplicate event {event_id}, skipping")
        return jsonify({'received': True, 'duplicate': True}), 200

    _processed_events.add(event_id)

    logger.info(f"Received {event_type}: {event_data}")

    try:
        handler = EVENT_HANDLERS.get(event_type, handle_unknown)
        handler(payload)
    except Exception as e:
        logger.error(f"Error processing {event_type}: {e}")

    return jsonify({'received': True}), 200


def handle_loop_created(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Loop created: {event.get('loopId')} in profile {event.get('profileId')}")


def handle_loop_updated(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Loop updated: {event.get('loopId')}")


def handle_participant_created(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Participant added to loop: {event.get('loopId')}")


def handle_participant_updated(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Participant updated in loop: {event.get('loopId')}")


def handle_participant_deleted(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Participant removed from loop: {event.get('loopId')}")


def handle_document_uploaded(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Document uploaded to loop: {event.get('loopId')}")


def handle_document_completed(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Document completed in loop: {event.get('loopId')}")


def handle_task_updated(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Task updated in loop: {event.get('loopId')}")


def handle_contact_created(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Contact created: {event.get('id')}")


def handle_contact_updated(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Contact updated: {event.get('id')}")


def handle_contact_deleted(payload: dict) -> None:
    event = payload.get('event', {})
    logger.info(f"Contact deleted: {event.get('id')}")


def handle_unknown(payload: dict) -> None:
    logger.info(f"Unhandled event type: {payload.get('eventType')}")


EVENT_HANDLERS = {
    'LOOP_CREATED': handle_loop_created,
    'LOOP_UPDATED': handle_loop_updated,
    'LOOP_PARTICIPANT_CREATED': handle_participant_created,
    'LOOP_PARTICIPANT_UPDATED': handle_participant_updated,
    'LOOP_PARTICIPANT_DELETED': handle_participant_deleted,
    'LOOP_DOCUMENT_UPLOADED': handle_document_uploaded,
    'LOOP_DOCUMENT_COMPLETED': handle_document_completed,
    'LOOP_TASK_UPDATED': handle_task_updated,
    'CONTACT_CREATED': handle_contact_created,
    'CONTACT_UPDATED': handle_contact_updated,
    'CONTACT_DELETED': handle_contact_deleted,
}
```

---

## File: `app.py`

```python
import os
import logging
from dotenv import load_dotenv
from flask import Flask, request, jsonify

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(name)s] %(levelname)s: %(message)s',
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

from oauth import oauth_bp, get_tokens
from webhooks import webhooks_bp

app.register_blueprint(oauth_bp)
app.register_blueprint(webhooks_bp)

from dotloop_client import DotloopClient, DotloopApiError


def get_client() -> DotloopClient:
    tokens = get_tokens('default')
    if not tokens:
        raise DotloopApiError(401, 'Not authenticated — visit /oauth/authorize first')
    return DotloopClient(access_token=tokens['access_token'])


@app.route('/health')
def health():
    return jsonify({'status': 'ok'})


@app.route('/api/account')
def account():
    try:
        client = get_client()
        return jsonify(client.get_account())
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles')
def profiles():
    try:
        client = get_client()
        return jsonify(client.get_profiles())
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loops')
def loops(profile_id: int):
    try:
        client = get_client()
        batch_number = request.args.get('batch_number', 1, type=int)
        batch_size = request.args.get('batch_size', 50, type=int)
        return jsonify(client.get_loops(profile_id, batch_number=batch_number, batch_size=batch_size))
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loops/all')
def all_loops(profile_id: int):
    try:
        client = get_client()
        loops_list = list(client.iter_loops(profile_id))
        return jsonify({'data': loops_list, 'total': len(loops_list)})
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loop-it', methods=['POST'])
def loop_it(profile_id: int):
    try:
        client = get_client()
        data = request.get_json()
        result = client.loop_it(profile_id, data)
        return jsonify(result), 201
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loops/<int:loop_id>/detail')
def loop_detail(profile_id: int, loop_id: int):
    try:
        client = get_client()
        return jsonify(client.get_loop_detail(profile_id, loop_id))
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loops/<int:loop_id>/detail', methods=['PATCH'])
def update_loop_detail(profile_id: int, loop_id: int):
    try:
        client = get_client()
        data = request.get_json()
        return jsonify(client.update_loop_detail(profile_id, loop_id, data))
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/profiles/<int:profile_id>/loops/<int:loop_id>/participants')
def participants(profile_id: int, loop_id: int):
    try:
        client = get_client()
        return jsonify(client.get_participants(profile_id, loop_id))
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/contacts')
def contacts():
    try:
        client = get_client()
        batch_number = request.args.get('batch_number', 1, type=int)
        return jsonify(client.get_contacts(batch_number=batch_number))
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/contacts', methods=['POST'])
def create_contact():
    try:
        client = get_client()
        data = request.get_json()
        return jsonify(client.create_contact(data)), 201
    except DotloopApiError as e:
        return jsonify({'error': e.message}), e.status_code
    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.errorhandler(500)
def server_error(e):
    logger.error(f"Internal server error: {e}")
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3000))
    app.run(host='0.0.0.0', port=port, debug=os.environ.get('FLASK_ENV') == 'development')
```

---

## File: `README.md`

````markdown
# Dotloop Integration App

Flask app integrating with the dotloop real estate transaction management API.

## Quick Start

```bash
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your dotloop credentials
python app.py
```

## Setup

1. Request API access at https://info.dotloop.com/developers or register at https://www.dotloop.com/my/account/#/clients
2. Set your redirect URI to a publicly accessible HTTPS URL
3. Copy `.env.example` to `.env` and fill in your credentials

## OAuth Flow

1. Visit `GET /oauth/authorize` to start the authorization flow
2. User authorizes your app on dotloop
3. Dotloop redirects to `/oauth/callback` with an authorization code
4. The app exchanges the code for access and refresh tokens
5. Access tokens expire every ~12 hours — use `POST /oauth/refresh` to refresh

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /oauth/authorize | Start OAuth flow |
| GET | /oauth/callback | OAuth callback handler |
| POST | /oauth/refresh | Refresh access token |
| GET | /api/account | Get account info |
| GET | /api/profiles | List profiles |
| GET | /api/profiles/:id/loops | List loops (paginated) |
| GET | /api/profiles/:id/loops/all | List ALL loops (auto-paginated) |
| POST | /api/profiles/:id/loop-it | Create loop via Loop-It |
| GET | /api/profiles/:id/loops/:id/detail | Get loop details |
| PATCH | /api/profiles/:id/loops/:id/detail | Update loop details |
| GET | /api/profiles/:id/loops/:id/participants | List participants |
| GET | /api/contacts | List contacts |
| POST | /api/contacts | Create contact |
| GET | /health | Health check |

## Webhook Endpoint

| Method | Path | Description |
|--------|------|-------------|
| POST | /webhooks/dotloop | Receive all dotloop webhook events |

## Register a Webhook

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/subscription" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://yourapp.com/webhooks/dotloop",
    "eventTypes": ["LOOP_CREATED", "LOOP_UPDATED"],
    "signingKey": "your_webhook_secret",
    "externalId": "your-tracking-id"
  }'
```

## Production

```bash
pip install -r requirements.txt
gunicorn app:app --bind 0.0.0.0:3000 --workers 4
```
````

---

## Usage Examples

### Auto-Paginate Through All Loops

```python
from dotloop_client import DotloopClient

client = DotloopClient(access_token='your_token')

for loop in client.iter_loops(profile_id=4711):
    print(f"{loop['name']} — {loop['status']} — {loop['transactionType']}")
```

### Create a Transaction with Loop-It

```python
from dotloop_client import DotloopClient

client = DotloopClient(access_token='your_token')

result = client.loop_it(profile_id=4711, data={
    'name': 'Jane Smith',
    'transactionType': 'PURCHASE_OFFER',
    'status': 'PRE_OFFER',
    'streetName': 'Oak Avenue',
    'streetNumber': '456',
    'city': 'San Francisco',
    'zipCode': '94114',
    'state': 'CA',
    'country': 'US',
    'participants': [
        {
            'fullName': 'Jane Smith',
            'email': 'jane@example.com',
            'role': 'BUYER',
        },
        {
            'fullName': 'Bob Agent',
            'email': 'bob@example.com',
            'role': 'LISTING_AGENT',
        },
    ],
    'templateId': 1424,
})

print(f"Loop created: {result['data']['loopUrl']}")
```

### Update Loop Detail Sections

```python
from dotloop_client import DotloopClient

client = DotloopClient(access_token='your_token')

client.update_loop_detail(profile_id=4711, loop_id=34308, sections={
    'financials': {
        'Purchase/Sale Price': '$500,000',
        'Earnest Money Amount': '$10,000',
    },
    'contractDates': {
        'Contract Agreement Date': '2025-06-15',
        'Closing Date': '2025-07-30',
    },
})
```

### Iterate All Contacts

```python
from dotloop_client import DotloopClient

client = DotloopClient(access_token='your_token')

for contact in client.iter_contacts():
    print(f"{contact.get('firstName', '')} {contact.get('lastName', '')} — {contact.get('email', 'N/A')}")
```

---

## Customization Checklist

When adapting this template:

1. Replace in-memory token storage with a database (encrypted at rest)
2. Add CSRF state validation in the OAuth callback
3. Implement proactive token refresh (at 80% of token lifetime)
4. Add authentication to your API routes (the `/api/*` routes are unprotected in this template)
5. Replace `print`/`logger.info` with structured logging for production
6. Store processed webhook event IDs in a database with TTL instead of in-memory set
7. Configure HTTPS for production webhook URLs
8. Handle concurrent token refresh in clustered environments with distributed locks
9. Add `templateId` to Loop-It requests if the profile requires it (`profile.requiresTemplate`)
10. Implement async webhook processing with a task queue (Celery, Redis) instead of inline handling
