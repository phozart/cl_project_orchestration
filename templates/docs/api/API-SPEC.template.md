# API Specification: {{PROJECT_NAME}}

## Overview
| Field | Value |
|-------|-------|
| **Base URL** | `{{BASE_URL}}` |
| **Version** | v1 |
| **Format** | JSON |
| **Authentication** | Bearer Token |

---

## Authentication

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200)**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "user"
  }
}
```

**Errors**:
| Code | Description |
|------|-------------|
| 401 | Invalid credentials |
| 422 | Validation error |

### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

**Response (201)**:
```json
{
  "message": "Registration successful. Please verify your email.",
  "user": {
    "id": "uuid",
    "email": "user@example.com"
  }
}
```

---

## {{RESOURCE_NAME}}

### List {{Resources}}
```http
GET /api/{{resources}}
Authorization: Bearer {{token}}
```

**Query Parameters**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | int | 1 | Page number |
| limit | int | 20 | Items per page |
| sort | string | created_at | Sort field |
| order | string | desc | Sort order |

**Response (200)**:
```json
{
  "data": [
    {
      "id": "uuid",
      "{{field}}": "{{value}}",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

### Get {{Resource}}
```http
GET /api/{{resources}}/{{id}}
Authorization: Bearer {{token}}
```

**Response (200)**:
```json
{
  "id": "uuid",
  "{{field}}": "{{value}}",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Errors**:
| Code | Description |
|------|-------------|
| 404 | Resource not found |

### Create {{Resource}}
```http
POST /api/{{resources}}
Authorization: Bearer {{token}}
Content-Type: application/json

{
  "{{field}}": "{{value}}"
}
```

**Response (201)**:
```json
{
  "id": "uuid",
  "{{field}}": "{{value}}",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### Update {{Resource}}
```http
PUT /api/{{resources}}/{{id}}
Authorization: Bearer {{token}}
Content-Type: application/json

{
  "{{field}}": "{{new_value}}"
}
```

**Response (200)**:
```json
{
  "id": "uuid",
  "{{field}}": "{{new_value}}",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

### Delete {{Resource}}
```http
DELETE /api/{{resources}}/{{id}}
Authorization: Bearer {{token}}
```

**Response (204)**: No content

---

## Error Responses

All errors follow this format:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
```

### Error Codes
| Code | HTTP Status | Description |
|------|-------------|-------------|
| UNAUTHORIZED | 401 | Missing or invalid token |
| FORBIDDEN | 403 | Insufficient permissions |
| NOT_FOUND | 404 | Resource not found |
| VALIDATION_ERROR | 422 | Invalid input |
| INTERNAL_ERROR | 500 | Server error |

---

## Rate Limiting

| Endpoint | Limit | Window |
|----------|-------|--------|
| /api/auth/* | 10 | 1 minute |
| /api/* | 100 | 1 minute |

Headers:
- `X-RateLimit-Limit`: Max requests
- `X-RateLimit-Remaining`: Remaining requests
- `X-RateLimit-Reset`: Reset timestamp

---

## Pagination

All list endpoints support pagination:
```http
GET /api/{{resources}}?page=2&limit=50
```

Response includes `meta` object with pagination info.

---

## Versioning

API version is included in the URL path:
- Current: `/api/v1/`
- Deprecated versions will be announced 6 months before removal
