# OpenAPI Standards

## OpenAPI 3.1 Structure

```yaml
openapi: 3.1.0
info:
  title: API Name
  version: 1.0.0
  description: API description

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

paths:
  /resource:
    get: ...
    post: ...

components:
  schemas: ...
  securitySchemes: ...

security:
  - bearerAuth: []
```

## Path Naming Conventions

### Rules

| Rule | Example |
|------|---------|
| Use nouns, not verbs | `/users` not `/getUsers` |
| Use plural for collections | `/users` not `/user` |
| Use kebab-case | `/user-profiles` not `/userProfiles` |
| Use path params for IDs | `/users/{id}` not `/users?id=123` |
| Nest for relationships | `/users/{id}/posts` |

### Correct Patterns

```yaml
# Collection
GET    /users              # List users
POST   /users              # Create user

# Resource
GET    /users/{id}         # Get user
PUT    /users/{id}         # Update user
DELETE /users/{id}         # Delete user

# Nested resources
GET    /users/{id}/posts   # List user's posts
POST   /users/{id}/posts   # Create post for user

# Actions (when REST doesn't fit)
POST   /users/{id}/activate    # Custom action
POST   /auth/login             # Authentication
POST   /auth/refresh           # Token refresh
```

### Incorrect Patterns

```yaml
# ❌ WRONG
GET    /getUsers           # Verb in path
GET    /user               # Singular collection
GET    /userProfiles       # camelCase
GET    /users/get/{id}     # Redundant verb
POST   /users/create       # Redundant verb
```

## HTTP Methods

| Method | Usage | Idempotent | Request Body |
|--------|-------|------------|--------------|
| GET | Retrieve resource(s) | Yes | No |
| POST | Create resource | No | Yes |
| PUT | Replace resource | Yes | Yes |
| PATCH | Partial update | Yes | Yes |
| DELETE | Remove resource | Yes | Optional |

## Operation IDs

Every endpoint MUST have a unique `operationId`:

```yaml
paths:
  /users:
    get:
      operationId: getUsers        # List
      summary: List all users
    post:
      operationId: createUser      # Create
      summary: Create a new user

  /users/{id}:
    get:
      operationId: getUserById     # Get single
      summary: Get user by ID
    put:
      operationId: updateUser      # Update
      summary: Update user
    delete:
      operationId: deleteUser      # Delete
      summary: Delete user
```

### Naming Pattern

| Action | Pattern | Example |
|--------|---------|---------|
| List all | `get{Resource}s` | `getUsers` |
| Get one | `get{Resource}ById` | `getUserById` |
| Create | `create{Resource}` | `createUser` |
| Update | `update{Resource}` | `updateUser` |
| Delete | `delete{Resource}` | `deleteUser` |
| Search | `search{Resource}s` | `searchUsers` |
| Custom action | `{action}{Resource}` | `activateUser` |

## Request/Response Schemas

### Request Body

```yaml
paths:
  /users:
    post:
      operationId: createUser
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'

components:
  schemas:
    CreateUserRequest:
      type: object
      required:
        - email
        - password
        - displayName
      properties:
        email:
          type: string
          format: email
          maxLength: 255
        password:
          type: string
          format: password
          minLength: 8
        displayName:
          type: string
          maxLength: 100
```

### Response Body

```yaml
paths:
  /users/{id}:
    get:
      operationId: getUserById
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          description: User not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        displayName:
          type: string
        createdAt:
          type: string
          format: date-time
```

## Status Codes

### Success Codes

| Code | Usage |
|------|-------|
| 200 | GET, PUT, PATCH success with body |
| 201 | POST success (created) |
| 204 | DELETE success (no content) |

### Error Codes

| Code | Usage |
|------|-------|
| 400 | Bad request (validation error) |
| 401 | Unauthorized (no/invalid token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not found |
| 409 | Conflict (duplicate, version mismatch) |
| 422 | Unprocessable entity (business rule violation) |
| 429 | Too many requests (rate limited) |
| 500 | Internal server error |

### Error Response Schema

```yaml
components:
  schemas:
    Error:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          description: Machine-readable error code
        message:
          type: string
          description: Human-readable message
        details:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              message:
                type: string
```

Example error response:
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    { "field": "email", "message": "Invalid email format" },
    { "field": "password", "message": "Password too short" }
  ]
}
```

## Authentication

### Bearer Token (JWT)

```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - bearerAuth: []

paths:
  /users:
    get:
      security:
        - bearerAuth: []  # Requires auth
  /auth/login:
    post:
      security: []  # Public endpoint
```

## Pagination

### Query Parameters

```yaml
paths:
  /users:
    get:
      operationId: getUsers
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: sort
          in: query
          schema:
            type: string
            enum: [createdAt, -createdAt, name, -name]
```

### Response Format

```yaml
components:
  schemas:
    PaginatedUsers:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        pagination:
          type: object
          properties:
            page:
              type: integer
            limit:
              type: integer
            total:
              type: integer
            totalPages:
              type: integer
```

## Filtering

```yaml
paths:
  /users:
    get:
      parameters:
        - name: role
          in: query
          schema:
            type: string
            enum: [admin, user, guest]
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive]
        - name: search
          in: query
          schema:
            type: string
          description: Search by name or email
```

## Versioning

### URL Path Versioning (Recommended)

```yaml
servers:
  - url: https://api.example.com/v1
```

### Header Versioning

```yaml
paths:
  /users:
    get:
      parameters:
        - name: API-Version
          in: header
          schema:
            type: string
            default: "2024-01-01"
```

## Documentation

Every endpoint must include:

```yaml
paths:
  /users/{id}:
    get:
      operationId: getUserById
      summary: Get user by ID          # Short description
      description: |                    # Detailed description
        Retrieves a single user by their unique identifier.
        Returns 404 if user not found.
      tags:
        - Users                         # Grouping
      parameters:
        - name: id
          in: path
          required: true
          description: User's unique identifier
          schema:
            type: string
            format: uuid
```

## Complete Endpoint Example

```yaml
paths:
  /users:
    post:
      operationId: createUser
      summary: Create a new user
      description: |
        Creates a new user account. Email must be unique.
        Sends verification email on success.
      tags:
        - Users
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
            example:
              email: user@example.com
              password: securePassword123
              displayName: John Doe
      responses:
        '201':
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Email already exists
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
```
