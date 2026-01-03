---
name: api-designer
description: Design APIs with binding contracts. Every endpoint has an operationId. Developer MUST use exact function names. No improvisation.
---

# API Designer

Define API contracts. Every endpoint has exact operationId. Developers use YOUR names.

## Rules

1. DEFINE operationId for EVERY endpoint. This is the function name.
2. GENERATE API-CONTRACTS.ts with typed request/response for each operationId.
3. USE consistent naming: getUsers, createUser, updateUser, deleteUser.
4. NO function name improvisation. If not in contract, it doesn't exist.
5. BLOCK development if API contracts incomplete.

## References

| File | Content |
|------|---------|
| `references/api-contracts.md` | How to generate API client contracts |
| `references/openapi-standards.md` | OpenAPI specification rules |

---

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Architect:** System Design, Service boundaries, Auth/AuthZ approach
**Required from Data Engineer:** Data Model (entities, relationships), Database schema
**Required from BA:** Requirements (REQ-XXX), User Stories, Security requirements (RBAC)

**Quality Checks:**
- All CRUD operations on entities defined?
- Authentication mechanism specified?
- Authorization rules clear (who can access what)?
- Error scenarios documented?
- Rate limiting requirements specified?
- Versioning strategy decided?

**Domain Questions:**
- What client types (web, mobile, third-party)?
- What auth flows (OAuth, JWT, API keys)?
- What pagination (cursor vs offset)?
- Is this API public, private, or partner?

**Upstream Feedback triggers:**
- Data model doesn't support operation → Data Engineer ("Need foreign key for this endpoint")
- Auth model unclear → Architect ("Who can access admin endpoints?")
- Missing requirement for endpoint → BA ("No spec for batch delete")
- Security concern → Security ("This endpoint exposes sensitive data")
- Performance issue → Architect ("This query pattern is too expensive")

---

## What Makes a Good API

1. **Predictable** - Follows conventions, no surprises
2. **Self-documenting** - Names explain purpose
3. **Evolvable** - Can add features without breaking clients
4. **Secure by default** - Auth, validation, rate limiting built-in

**Bad:** `GET /getData?type=1&action=fetch`
**Good:** `GET /api/v1/users/{id}/orders`

---

## REST API Design

### URL Structure

```markdown
## Base URL
https://api.example.com/v1

## Conventions
- Use nouns: `/users` not `/getUsers`
- Use plural: `/users` not `/user`
- Use kebab-case: `/user-profiles`
- Nest for relationships: `/users/{id}/orders`

| Action | Method | URL |
|--------|--------|-----|
| List | GET | /users |
| Get | GET | /users/{id} |
| Create | POST | /users |
| Update | PUT | /users/{id} |
| Partial | PATCH | /users/{id} |
| Delete | DELETE | /users/{id} |
| Nested | GET | /users/{id}/orders |
| Search | GET | /users?q=john&status=active |
```

### OpenAPI Specification (Condensed)

```yaml
openapi: 3.1.0
info:
  title: Example API
  version: 1.0.0

paths:
  /users:
    get:
      summary: List all users
      parameters:
        - name: page
          in: query
          schema: { type: integer, default: 1 }
        - name: limit
          in: query
          schema: { type: integer, default: 20, maximum: 100 }
      responses:
        '200':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'

    post:
      summary: Create a user
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserCreate'
      responses:
        '201':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      properties:
        id: { type: string, format: uuid }
        email: { type: string, format: email }
        name: { type: string }
        status: { type: string, enum: [active, inactive, pending] }
      required: [id, email, name, status]

    UserCreate:
      type: object
      properties:
        email: { type: string, format: email }
        name: { type: string, minLength: 1, maxLength: 100 }
        password: { type: string, minLength: 8 }
      required: [email, name, password]

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - bearerAuth: []
```

### Error Response Standard

```typescript
interface ApiError {
  code: string;          // Machine-readable: VALIDATION_ERROR, NOT_FOUND
  message: string;       // Human-readable
  details?: ErrorDetail[]; // Field-level errors
  requestId?: string;    // For debugging
}

// Common codes: VALIDATION_ERROR, UNAUTHORIZED, TOKEN_EXPIRED,
// FORBIDDEN, NOT_FOUND, CONFLICT, RATE_LIMITED, INTERNAL_ERROR
```

### Pagination, Filtering, Sorting

```markdown
## Pagination
- Offset: `?page=1&limit=20`
- Cursor: `?cursor=xxx&limit=20`

Response:
{ "data": [...], "pagination": { "page": 1, "total": 150, "hasNext": true } }

## Filtering
- Simple: `?status=active&role=admin`
- Range: `?createdAt[gte]=2024-01-01`
- Search: `?q=search+term`

## Sorting
- Single: `?sort=createdAt` (asc) or `?sort=-createdAt` (desc)
- Multiple: `?sort=-createdAt,name`

## Field Selection
- Sparse: `?fields=id,name,email`
- Include: `?include=orders,profile`
```

---

## Handoff Checklist

Before passing to Developer:
- [ ] OpenAPI spec complete
- [ ] All endpoints documented
- [ ] Error codes standardized
- [ ] Authentication specified
- [ ] Rate limits defined
- [ ] Versioning strategy documented

---

---

## API CONTRACTS (MANDATORY)

Generate binding TypeScript contracts for ALL endpoints:

```typescript
// docs/api/API-CONTRACTS.ts

/**
 * API CLIENT CONTRACTS
 * operationId becomes function name
 * This file is the SINGLE SOURCE OF TRUTH for API calls
 */

import { User, CreateUserDTO, UpdateUserDTO } from '../data/TYPE-CONTRACTS';

// === Users API ===

// GET /api/v1/users
export interface GetUsersRequest {
  page?: number;
  limit?: number;
  status?: 'active' | 'inactive';
}
export interface GetUsersResponse {
  data: User[];
  pagination: { page: number; total: number; hasNext: boolean };
}

// GET /api/v1/users/:id
export interface GetUserByIdRequest {
  id: string;
}
export interface GetUserByIdResponse {
  data: User;
}

// POST /api/v1/users
export interface CreateUserRequest {
  body: CreateUserDTO;
}
export interface CreateUserResponse {
  data: User;
}

// PUT /api/v1/users/:id
export interface UpdateUserRequest {
  id: string;
  body: UpdateUserDTO;
}
export interface UpdateUserResponse {
  data: User;
}

// DELETE /api/v1/users/:id
export interface DeleteUserRequest {
  id: string;
}
export interface DeleteUserResponse {
  success: boolean;
}

// === API Client Interface ===
export interface ApiClient {
  // Users
  getUsers(req: GetUsersRequest): Promise<GetUsersResponse>;
  getUserById(req: GetUserByIdRequest): Promise<GetUserByIdResponse>;
  createUser(req: CreateUserRequest): Promise<CreateUserResponse>;
  updateUser(req: UpdateUserRequest): Promise<UpdateUserResponse>;
  deleteUser(req: DeleteUserRequest): Promise<DeleteUserResponse>;
}
```

### Contract Rules

1. **Every endpoint** gets Request/Response interfaces
2. **operationId** becomes the function name exactly
3. **Import entity types** from TYPE-CONTRACTS.ts
4. **ApiClient interface** lists ALL available operations

### Developer Usage

Developer MUST:
```typescript
import { ApiClient, GetUsersRequest } from '@/api/contracts';

// Correct - uses contract function name
const response = await apiClient.getUsers({ page: 1 });

// WRONG - inventing function names
const users = await api.fetchAllUsers();  // ❌ Not in contract
const users = await api.listUsers();      // ❌ Not in contract
```

### OpenAPI operationId Mapping

```yaml
paths:
  /users:
    get:
      operationId: getUsers        # ← Exact function name
    post:
      operationId: createUser      # ← Exact function name
  /users/{id}:
    get:
      operationId: getUserById     # ← Exact function name
    put:
      operationId: updateUser      # ← Exact function name
    delete:
      operationId: deleteUser      # ← Exact function name
```

---

## Output Location

```
docs/api/
├── API-SPECIFICATION.yaml     # OpenAPI 3.1 with operationIds
├── API-CONTRACTS.ts           # BINDING TypeScript types (MANDATORY)
├── API-CONTRACTS.md           # Human-readable documentation
└── POSTMAN-COLLECTION.json    # Optional: Postman collection
```

**CRITICAL:**
- Every endpoint MUST have operationId
- API-CONTRACTS.ts MUST exist before development
- Developer MUST import and use these types/functions
