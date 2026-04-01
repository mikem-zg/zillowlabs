# Integration Examples

## Node.js / TypeScript

### Setup

```typescript
const BASE_URL = process.env.MESSAGING_PLATFORM_URL;
const API_KEY = process.env.MESSAGING_PLATFORM_API_KEY;

const headers = {
  "Authorization": `Bearer ${API_KEY}`,
  "Content-Type": "application/json",
};
```

### Send SMS

```typescript
async function sendSms(phoneNumber: string, message: string) {
  const res = await fetch(`${BASE_URL}/api/external/send`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      message,
      recipient: { phoneNumber },
    }),
  });
  if (!res.ok) throw new Error(`SMS failed: ${res.status}`);
  return res.json();
}
```

### Send Email

```typescript
async function sendEmail(to: string, from: string, subject: string, html: string) {
  const res = await fetch(`${BASE_URL}/api/external/email/send`, {
    method: "POST",
    headers,
    body: JSON.stringify({ to, from, subject, html }),
  });
  if (!res.ok) throw new Error(`Email failed: ${res.status}`);
  return res.json();
}
```

### Send Batch SMS

```typescript
async function sendBatchSms(message: string, phoneNumbers: string[]) {
  const res = await fetch(`${BASE_URL}/api/external/send-batch`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      message,
      recipients: phoneNumbers.map((p) => ({ phoneNumber: p })),
    }),
  });
  if (!res.ok) throw new Error(`Batch SMS failed: ${res.status}`);
  const { jobId } = await res.json();
  return pollJob(jobId);
}

async function pollJob(jobId: string, intervalMs = 2000): Promise<any> {
  while (true) {
    const res = await fetch(`${BASE_URL}/api/external/jobs/${jobId}`, { headers });
    const job = await res.json();
    if (job.status === "completed" || job.status === "failed") return job;
    await new Promise((r) => setTimeout(r, intervalMs));
  }
}
```

### Send Batch Email

```typescript
async function sendBatchEmail(
  from: string,
  subject: string,
  html: string,
  recipients: string[]
) {
  const res = await fetch(`${BASE_URL}/api/external/email/send-batch`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      from,
      subject,
      html,
      recipients: recipients.map((to) => ({ to })),
    }),
  });
  if (!res.ok) throw new Error(`Batch email failed: ${res.status}`);
  return res.json();
}
```

### Import Contacts

```typescript
async function importContacts(contacts: { phoneNumber: string; firstName?: string; lastName?: string; email?: string }[]) {
  const res = await fetch(`${BASE_URL}/api/external/contacts`, {
    method: "POST",
    headers,
    body: JSON.stringify({ contacts }),
  });
  if (!res.ok) throw new Error(`Contact import failed: ${res.status}`);
  const { jobId } = await res.json();
  return pollJob(jobId);
}
```

### Get Conversation History

```typescript
async function getConversations(phoneNumber: string, limit?: number) {
  const params = new URLSearchParams({ phoneNumber });
  if (limit) params.set("limit", String(limit));
  const res = await fetch(
    `${BASE_URL}/api/external/conversations?${params}`,
    { headers }
  );
  if (!res.ok) throw new Error(`Fetch conversations failed: ${res.status}`);
  return res.json();
}
```

### Check Email Delivery Status

```typescript
async function getEmailDeliveries(limit = 50, offset = 0) {
  const res = await fetch(
    `${BASE_URL}/api/external/email/deliveries?limit=${limit}&offset=${offset}`,
    { headers }
  );
  if (!res.ok) throw new Error(`Fetch deliveries failed: ${res.status}`);
  return res.json();
}

async function getEmailDelivery(emailId: string) {
  const res = await fetch(
    `${BASE_URL}/api/external/email/deliveries/${emailId}`,
    { headers }
  );
  if (!res.ok) throw new Error(`Fetch delivery failed: ${res.status}`);
  return res.json();
}
```

---

## Python

### Setup

```python
import os
import requests
import time

BASE_URL = os.environ["MESSAGING_PLATFORM_URL"]
API_KEY = os.environ["MESSAGING_PLATFORM_API_KEY"]
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
}
```

### Send SMS

```python
def send_sms(phone_number: str, message: str):
    resp = requests.post(
        f"{BASE_URL}/api/external/send",
        headers=HEADERS,
        json={
            "message": message,
            "recipient": {"phoneNumber": phone_number},
        },
    )
    resp.raise_for_status()
    return resp.json()
```

### Send Email

```python
def send_email(to: str, from_addr: str, subject: str, html: str):
    resp = requests.post(
        f"{BASE_URL}/api/external/email/send",
        headers=HEADERS,
        json={"to": to, "from": from_addr, "subject": subject, "html": html},
    )
    resp.raise_for_status()
    return resp.json()
```

### Send Batch SMS with Polling

```python
def send_batch_sms(message: str, phone_numbers: list[str]):
    resp = requests.post(
        f"{BASE_URL}/api/external/send-batch",
        headers=HEADERS,
        json={
            "message": message,
            "recipients": [{"phoneNumber": p} for p in phone_numbers],
        },
    )
    resp.raise_for_status()
    job_id = resp.json()["jobId"]
    return poll_job(job_id)


def poll_job(job_id: str, interval: float = 2.0):
    while True:
        resp = requests.get(
            f"{BASE_URL}/api/external/jobs/{job_id}", headers=HEADERS
        )
        job = resp.json()
        if job["status"] in ("completed", "failed"):
            return job
        time.sleep(interval)
```

### Get Conversation History

```python
def get_conversations(phone_number: str, limit: int = None):
    params = {"phoneNumber": phone_number}
    if limit:
        params["limit"] = limit
    resp = requests.get(
        f"{BASE_URL}/api/external/conversations",
        headers=HEADERS,
        params=params,
    )
    resp.raise_for_status()
    return resp.json()
```

### Import Contacts

```python
def import_contacts(contacts: list[dict]):
    resp = requests.post(
        f"{BASE_URL}/api/external/contacts",
        headers=HEADERS,
        json={"contacts": contacts},
    )
    resp.raise_for_status()
    job_id = resp.json()["jobId"]
    return poll_job(job_id)
```
