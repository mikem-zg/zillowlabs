# API Documentation

## Authentication

Use JWT tokens in the Authorization header:

```javascript
// Valid JavaScript
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9';
const headers = {
  'Authorization': `Bearer ${token}`
};
```

## User Endpoints

### Get User by ID

```python
# Invalid Python - missing import and syntax error
def get_user(user_id)
    response = requests.get(f"/api/users/{user_id}")
    return response.json()
```

### Create User

```bash
curl -X POST \
  https://api.example.com/users \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "John Doe",
    "email": "john@example.com"
  }'
```

## Error Handling

```json
{
  "error": {
    "code": 400,
    "message": "Invalid request"
  }
}
```

```typescript
// Invalid TypeScript - wrong interface syntax
interface User {
  id: number
  name: string
  email: string
  created_at Date  // Missing colon
}
```