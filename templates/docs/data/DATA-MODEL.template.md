# Data Model: {{PROJECT_NAME}}

## Overview
| Metric | Value |
|--------|-------|
| **Database** | {{DATABASE_TYPE}} |
| **Total Entities** | {{ENTITY_COUNT}} |
| **Version** | 1.0 |

---

## Entity Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│      User       │       │    {{ENTITY}}   │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │───┐   │ id (PK)         │
│ email           │   │   │ user_id (FK)    │◄──┐
│ password_hash   │   │   │ {{FIELD}}       │   │
│ role            │   │   │ created_at      │   │
│ created_at      │   │   └─────────────────┘   │
│ updated_at      │   │                         │
└─────────────────┘   └─────────────────────────┘
```

---

## Entities

### User

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PK | Unique identifier |
| email | VARCHAR(255) | UNIQUE, NOT NULL | User email |
| password_hash | VARCHAR(255) | NOT NULL | Bcrypt hash |
| role | ENUM | NOT NULL, DEFAULT 'user' | user, admin |
| email_verified | BOOLEAN | DEFAULT false | Email verification status |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |

**Indexes**:
- `idx_users_email` on `email`
- `idx_users_role` on `role`

**Constraints**:
- Email must be valid format
- Password hash must be bcrypt

---

### {{ENTITY_NAME}}

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PK | Unique identifier |
| user_id | UUID | FK → users.id | Owner |
| {{FIELD_1}} | {{TYPE_1}} | {{CONSTRAINTS_1}} | {{DESC_1}} |
| {{FIELD_2}} | {{TYPE_2}} | {{CONSTRAINTS_2}} | {{DESC_2}} |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |

**Indexes**:
- `idx_{{entity}}_user_id` on `user_id`

**Foreign Keys**:
- `user_id` → `users.id` ON DELETE CASCADE

---

## Relationships

| From | To | Type | Description |
|------|-----|------|-------------|
| User | {{Entity}} | 1:N | User owns many {{entities}} |
| {{Entity_A}} | {{Entity_B}} | M:N | {{Description}} |

---

## Enums

### UserRole
| Value | Description |
|-------|-------------|
| user | Regular user |
| admin | Administrator |

### {{EnumName}}
| Value | Description |
|-------|-------------|
| {{VALUE_1}} | {{DESC_1}} |
| {{VALUE_2}} | {{DESC_2}} |

---

## Audit Fields

All entities include:
| Field | Type | Purpose |
|-------|------|---------|
| created_at | TIMESTAMP | Record creation |
| updated_at | TIMESTAMP | Last modification |
| created_by | UUID | Creator (optional) |
| updated_by | UUID | Last modifier (optional) |

---

## Migration Strategy

### Initial Migration
```sql
-- 001_create_users.sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'user',
  email_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

---

## Data Validation Rules

| Entity | Field | Rule |
|--------|-------|------|
| User | email | Valid email format |
| User | password | Min 8 chars, 1 upper, 1 number |
| {{Entity}} | {{Field}} | {{Rule}} |
