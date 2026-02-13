# Follow Up Boss Python App Template

Copy-paste template for building a production-ready Follow Up Boss integration with Flask, webhook handling, and full API client. Includes both raw `requests` implementation and the official `follow-up-boss` SDK.

---

## Project Structure

```
fub-app/
├── app.py              # Flask server entry point
├── fub_client.py       # FUB API client (raw requests)
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
follow-up-boss>=1.0.0
gunicorn>=22.0.0
```

---

## File: `.env.example`

```
FUB_API_KEY=your_api_key_here
FUB_SYSTEM=YourSystemName
FUB_SYSTEM_KEY=your_system_key_here
FUB_WEBHOOK_SECRET=your_webhook_secret
PORT=3000
FLASK_ENV=development
```

---

## File: `fub_client.py`

### Approach 1: Using the `follow-up-boss` SDK (Recommended)

```python
import os
import logging
from follow_up_boss import FollowUpBossApiClient

logger = logging.getLogger(__name__)

def get_sdk_client() -> FollowUpBossApiClient:
    """Create and return an SDK client instance."""
    return FollowUpBossApiClient(
        api_key=os.environ['FUB_API_KEY'],
        x_system=os.environ['FUB_SYSTEM'],
        x_system_key=os.environ['FUB_SYSTEM_KEY'],
    )


def send_event_sdk(client: FollowUpBossApiClient, event_data: dict) -> dict:
    """Send an event (lead) using the SDK."""
    return client.events.create(event_data)


def get_people_sdk(client: FollowUpBossApiClient, **params) -> dict:
    """Get people with optional filters."""
    return client.people.get_all(**params)


def iter_people_sdk(client: FollowUpBossApiClient, **params):
    """Iterate through ALL people using cursor pagination.

    Yields individual person dicts. Handles pagination automatically.

    Usage:
        client = get_sdk_client()
        for person in iter_people_sdk(client, limit=100, tags='buyer'):
            print(person['firstName'], person['lastName'])
    """
    request_params = {'limit': 100, **params}
    while True:
        data = client.people.get_all(**request_params)
        for person in data.get('people', []):
            yield person
        next_cursor = data.get('_metadata', {}).get('next')
        if not next_cursor:
            break
        request_params = {'limit': 100, 'next': next_cursor}


def get_smart_list_people_sdk(client: FollowUpBossApiClient, list_id: int, **params):
    """Get people from a Smart List with automatic cursor pagination.

    Usage:
        client = get_sdk_client()
        for person in get_smart_list_people_sdk(client, list_id=42):
            print(person['firstName'])
    """
    request_params = {'listId': list_id, 'limit': 100, **params}
    while True:
        data = client.people.get_all(**request_params)
        for person in data.get('people', []):
            yield person
        next_cursor = data.get('_metadata', {}).get('next')
        if not next_cursor:
            break
        request_params = {'listId': list_id, 'limit': 100, 'next': next_cursor}
```

### Approach 2: Raw `requests` Implementation

```python
import os
import time
import logging
from typing import Any, Generator
import requests
from requests.auth import HTTPBasicAuth

logger = logging.getLogger(__name__)

BASE_URL = 'https://api.followupboss.com/v1'


class FUBApiError(Exception):
    def __init__(self, status_code: int, message: str):
        self.status_code = status_code
        self.message = message
        super().__init__(f"FUB API Error {status_code}: {message}")


class FUBClient:
    def __init__(
        self,
        api_key: str | None = None,
        system: str | None = None,
        system_key: str | None = None,
    ):
        self.api_key = api_key or os.environ['FUB_API_KEY']
        self.system = system or os.environ['FUB_SYSTEM']
        self.system_key = system_key or os.environ['FUB_SYSTEM_KEY']
        self.session = requests.Session()
        self.session.auth = HTTPBasicAuth(self.api_key, '')
        self.session.headers.update({
            'Content-Type': 'application/json',
            'X-System': self.system,
            'X-System-Key': self.system_key,
        })

    def _request(
        self,
        method: str,
        endpoint: str,
        params: dict | None = None,
        json_data: dict | None = None,
        max_retries: int = 3,
    ) -> dict | None:
        url = f"{BASE_URL}{endpoint}"

        for attempt in range(max_retries):
            response = self.session.request(
                method=method,
                url=url,
                params=params,
                json=json_data,
            )

            remaining = response.headers.get('X-RateLimit-Remaining')
            if remaining is not None and int(remaining) < 10:
                logger.warning(f"Rate limit warning: {remaining} requests remaining")

            if response.status_code == 204:
                return None

            if response.status_code == 429:
                retry_after = int(response.headers.get('Retry-After', '10'))
                logger.warning(f"Rate limited. Retrying after {retry_after}s (attempt {attempt + 1}/{max_retries})")
                time.sleep(retry_after)
                continue

            if response.status_code >= 400:
                raise FUBApiError(response.status_code, response.text)

            return response.json()

        raise FUBApiError(429, 'Max retries exceeded due to rate limiting')

    def send_event(self, event: dict) -> dict | None:
        return self._request('POST', '/events', json_data=event)

    def get_people(self, **params) -> dict:
        return self._request('GET', '/people', params=params)

    def get_person(self, person_id: int, include_custom_fields: bool = False) -> dict:
        params = {'fields': 'allFields'} if include_custom_fields else None
        return self._request('GET', f'/people/{person_id}', params=params)

    def create_person(self, data: dict, deduplicate: bool = False) -> dict:
        params = {'deduplicate': 'true'} if deduplicate else None
        return self._request('POST', '/people', params=params, json_data=data)

    def update_person(self, person_id: int, data: dict) -> dict:
        return self._request('PUT', f'/people/{person_id}', json_data=data)

    def create_note(self, person_id: int, body: str, subject: str | None = None) -> dict:
        data: dict[str, Any] = {'personId': person_id, 'body': body}
        if subject:
            data['subject'] = subject
        return self._request('POST', '/notes', json_data=data)

    def create_task(self, data: dict) -> dict:
        return self._request('POST', '/tasks', json_data=data)

    def create_deal(self, data: dict) -> dict:
        return self._request('POST', '/deals', json_data=data)

    def iter_people(self, **params) -> Generator[dict, None, None]:
        """Iterate through ALL people using cursor pagination.

        Yields individual person dicts.

        Usage:
            client = FUBClient()
            for person in client.iter_people(limit=100, tags='buyer'):
                print(person['firstName'], person['lastName'])
        """
        request_params = {'limit': 100, **params}
        while True:
            data = self.get_people(**request_params)
            for person in data.get('people', []):
                yield person
            next_cursor = data.get('_metadata', {}).get('next')
            if not next_cursor:
                break
            request_params = {'limit': 100, 'next': next_cursor}

    def iter_smart_list(self, list_id: int, **params) -> Generator[dict, None, None]:
        """Iterate through people in a Smart List.

        Usage:
            client = FUBClient()
            for person in client.iter_smart_list(list_id=42):
                print(person['firstName'])
        """
        request_params = {'listId': list_id, 'limit': 100, **params}
        while True:
            data = self.get_people(**request_params)
            for person in data.get('people', []):
                yield person
            next_cursor = data.get('_metadata', {}).get('next')
            if not next_cursor:
                break
            request_params = {'listId': list_id, 'limit': 100, 'next': next_cursor}
```

---

## File: `webhooks.py`

```python
import os
import hmac
import hashlib
import logging
from flask import Blueprint, request, jsonify

logger = logging.getLogger(__name__)

webhooks_bp = Blueprint('webhooks', __name__, url_prefix='/webhooks')

WEBHOOK_SECRET = os.environ.get('FUB_WEBHOOK_SECRET', '')


def verify_signature(payload: bytes, signature: str, secret: str) -> bool:
    """Verify FUB webhook signature using HMAC SHA256."""
    expected = hmac.new(
        secret.encode('utf-8'),
        payload,
        hashlib.sha256,
    ).hexdigest()
    return hmac.compare_digest(expected, signature)


@webhooks_bp.before_request
def check_signature():
    """Verify webhook signature before processing any webhook."""
    if not WEBHOOK_SECRET:
        logger.warning('FUB_WEBHOOK_SECRET not set — skipping signature verification')
        return

    signature = request.headers.get('FUB-Signature', '')
    if not signature:
        logger.error('Missing FUB-Signature header')
        return jsonify({'error': 'Missing signature'}), 401

    if not verify_signature(request.get_data(), signature, WEBHOOK_SECRET):
        logger.error('Invalid webhook signature')
        return jsonify({'error': 'Invalid signature'}), 401


@webhooks_bp.route('/people-created', methods=['POST'])
def people_created():
    """Handle new person creation in FUB."""
    payload = request.get_json()
    resource_ids = payload.get('resourceIds', [])
    logger.info(f"People created: {resource_ids}")

    for person_id in resource_ids:
        logger.info(f"Processing new person: {person_id}")

    return jsonify({'received': True}), 200


@webhooks_bp.route('/people-updated', methods=['POST'])
def people_updated():
    """Handle person update in FUB."""
    payload = request.get_json()
    resource_ids = payload.get('resourceIds', [])
    logger.info(f"People updated: {resource_ids}")

    for person_id in resource_ids:
        logger.info(f"Processing updated person: {person_id}")

    return jsonify({'received': True}), 200


@webhooks_bp.route('/deals-created', methods=['POST'])
def deals_created():
    """Handle new deal creation in FUB."""
    payload = request.get_json()
    resource_ids = payload.get('resourceIds', [])
    logger.info(f"Deals created: {resource_ids}")
    return jsonify({'received': True}), 200


@webhooks_bp.route('/notes-created', methods=['POST'])
def notes_created():
    """Handle new note creation in FUB."""
    payload = request.get_json()
    resource_ids = payload.get('resourceIds', [])
    logger.info(f"Notes created: {resource_ids}")
    return jsonify({'received': True}), 200


@webhooks_bp.route('/<event_type>', methods=['POST'])
def generic_handler(event_type: str):
    """Generic handler for any FUB webhook event."""
    payload = request.get_json()
    resource_ids = payload.get('resourceIds', [])
    logger.info(f"Webhook event '{event_type}': {resource_ids}")
    return jsonify({'received': True, 'event': event_type}), 200
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

from webhooks import webhooks_bp
app.register_blueprint(webhooks_bp)

from fub_client import FUBClient, FUBApiError

fub = FUBClient()


@app.route('/health')
def health():
    return jsonify({'status': 'ok'})


@app.route('/api/leads', methods=['POST'])
def send_lead():
    """Send a lead into FUB via the Events endpoint."""
    try:
        data = request.get_json()
        event = {
            'source': data.get('source', 'MyApp'),
            'system': os.environ.get('FUB_SYSTEM', 'MyApp'),
            'type': data.get('type', 'General Inquiry'),
            'message': data.get('message', ''),
            'person': {
                'firstName': data.get('firstName'),
                'lastName': data.get('lastName'),
                'emails': [{'value': data['email']}] if data.get('email') else [],
                'phones': [{'value': data['phone']}] if data.get('phone') else [],
                'tags': data.get('tags', []),
            },
        }

        if data.get('property'):
            event['property'] = data['property']

        result = fub.send_event(event)

        if result is None:
            return jsonify({'success': True, 'message': 'Lead received but archived by lead flow'}), 200

        return jsonify({'success': True, 'data': result}), 201

    except FUBApiError as e:
        logger.error(f"FUB API error: {e}")
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error sending lead: {e}")
        return jsonify({'error': 'Failed to send lead'}), 500


@app.route('/api/people')
def list_people():
    """List people with optional filters and pagination."""
    try:
        params = {}
        for key in ['limit', 'next', 'sort', 'tags', 'stage', 'fields', 'listId']:
            value = request.args.get(key)
            if value is not None:
                params[key] = int(value) if key in ('limit', 'listId') else value

        data = fub.get_people(**params)
        return jsonify(data)

    except FUBApiError as e:
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error fetching people: {e}")
        return jsonify({'error': 'Failed to fetch people'}), 500


@app.route('/api/people/<int:person_id>')
def get_person(person_id: int):
    """Get a single person by ID."""
    try:
        include_custom = request.args.get('fields') == 'allFields'
        person = fub.get_person(person_id, include_custom_fields=include_custom)
        return jsonify(person)

    except FUBApiError as e:
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error fetching person: {e}")
        return jsonify({'error': 'Failed to fetch person'}), 500


@app.route('/api/people/<int:person_id>/notes', methods=['POST'])
def add_note(person_id: int):
    """Add a note to a person."""
    try:
        data = request.get_json()
        note = fub.create_note(person_id, data['body'], data.get('subject'))
        return jsonify(note), 201

    except FUBApiError as e:
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error creating note: {e}")
        return jsonify({'error': 'Failed to create note'}), 500


@app.route('/api/tasks', methods=['POST'])
def add_task():
    """Create a task."""
    try:
        data = request.get_json()
        task = fub.create_task(data)
        return jsonify(task), 201

    except FUBApiError as e:
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error creating task: {e}")
        return jsonify({'error': 'Failed to create task'}), 500


@app.route('/api/deals', methods=['POST'])
def add_deal():
    """Create a deal."""
    try:
        data = request.get_json()
        deal = fub.create_deal(data)
        return jsonify(deal), 201

    except FUBApiError as e:
        return jsonify({'error': str(e)}), e.status_code
    except Exception as e:
        logger.error(f"Error creating deal: {e}")
        return jsonify({'error': 'Failed to create deal'}), 500


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
# Follow Up Boss Integration App

Flask app integrating with the Follow Up Boss CRM API.

## Quick Start

```bash
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your FUB credentials
python app.py
```

## Production

```bash
pip install -r requirements.txt
gunicorn app:app --bind 0.0.0.0:3000 --workers 4
```

## Setup

1. Create a trial FUB account at https://app.followupboss.com/signup
2. Generate an API key in Admin → API
3. Register your system at https://apps.followupboss.com/system-registration
4. Copy `.env.example` to `.env` and fill in your credentials

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/leads | Send a lead into FUB via Events |
| GET | /api/people | List people with pagination |
| GET | /api/people/:id | Get a single person |
| POST | /api/people/:id/notes | Add a note to a person |
| POST | /api/tasks | Create a task |
| POST | /api/deals | Create a deal |
| GET | /health | Health check |

## Webhook Endpoints

| Method | Path | FUB Event |
|--------|------|-----------|
| POST | /webhooks/people-created | peopleCreated |
| POST | /webhooks/people-updated | peopleUpdated |
| POST | /webhooks/deals-created | dealsCreated |
| POST | /webhooks/notes-created | notesCreated |
| POST | /webhooks/<event_type> | Any other event |

## Register Webhooks

```bash
curl -X POST https://api.followupboss.com/v1/webhooks \
  -u "$FUB_API_KEY:" \
  -H "X-System: $FUB_SYSTEM" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"event": "peopleCreated", "url": "https://yourapp.com/webhooks/people-created"}'
```
````

---

## Usage Examples

### Pagination with SDK

```python
from fub_client import get_sdk_client, iter_people_sdk

client = get_sdk_client()

for person in iter_people_sdk(client, limit=100, tags='buyer'):
    print(f"{person['firstName']} {person['lastName']} — {person.get('stage', 'N/A')}")
```

### Pagination with Raw Client

```python
from fub_client import FUBClient

fub = FUBClient()

for person in fub.iter_people(limit=100, tags='buyer'):
    print(f"{person['firstName']} {person['lastName']} — {person.get('stage', 'N/A')}")
```

### Smart List Filtering

```python
from fub_client import FUBClient

fub = FUBClient()

for person in fub.iter_smart_list(list_id=42):
    print(f"{person['firstName']} {person['lastName']}")
```

### Smart List Filtering with SDK

```python
from fub_client import get_sdk_client, get_smart_list_people_sdk

client = get_sdk_client()

for person in get_smart_list_people_sdk(client, list_id=42):
    print(f"{person['firstName']} {person['lastName']}")
```

### Sending a Lead with Property Info

```python
from fub_client import FUBClient

fub = FUBClient()

result = fub.send_event({
    'source': 'MyWebsite.com',
    'system': 'MyApp',
    'type': 'Property Inquiry',
    'message': 'Interested in this property',
    'person': {
        'firstName': 'Jane',
        'lastName': 'Doe',
        'emails': [{'value': 'jane@example.com'}],
        'phones': [{'value': '555-123-4567'}],
    },
    'property': {
        'street': '456 Oak Ave',
        'city': 'Cambridge',
        'state': 'MA',
        'code': '02139',
        'price': 750000,
        'mlsNumber': 'MLS123456',
        'url': 'https://mysite.com/listings/456-oak',
    },
})

if result is None:
    print('Lead archived by lead flow')
else:
    print(f'Lead created/updated: {result}')
```

---

## Customization Checklist

When adapting this template:

1. Replace `FUB_SYSTEM` value with your registered system name
2. Update event `source` to match your application name
3. Add additional webhook routes for events you need
4. Implement async processing for webhooks (Celery, Redis queue) instead of inline processing
5. Add authentication to your API routes
6. Configure HTTPS for production webhook URLs
7. Add proper production logging configuration
