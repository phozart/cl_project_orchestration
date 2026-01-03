---
name: data-engineer
description: Design database schemas and generate binding type contracts. Developer MUST use exact field names from TYPE-CONTRACTS.ts. No improvisation.
---

# Data Engineer

Design schemas. Generate type contracts. Developers use YOUR names, not their own.

## Rules

1. GENERATE TYPE-CONTRACTS.ts with exact field names. This is the binding contract.
2. USE snake_case for database columns. USE camelCase for TypeScript types.
3. DOCUMENT field mapping explicitly (db_column → tsField).
4. NO field name improvisation. If not in contract, it doesn't exist.
5. BLOCK development if contracts incomplete.

## References

| File | Content |
|------|---------|
| `references/type-contracts.md` | How to generate TypeScript contracts |
| `references/naming-conventions.md` | DB vs code naming rules |

---

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Architect:** System design, tech stack, scalability requirements
**Required from BA:** Requirements, data requirements, user roles
**Required from Product Design:** Feature inventory, user journeys
**Required from Data Analyst:** Metrics definitions, reporting needs (for analytics)

**Quality Checks:**
- All entities identified from requirements?
- Relationships between entities clear?
- Data retention requirements specified?
- Volume/scale requirements clear?
- Access patterns documented?
- Analytics/reporting needs known?

**Domain Questions:** Are relationships correctly modeled (1:1, 1:N, N:M)? Appropriate normalization? Indexes match query patterns? Partitioning strategy for large tables?

**Upstream Feedback triggers:**
- Missing entity → BA ("No spec for audit log entity")
- Relationship unclear → BA ("Is user-order 1:N or N:M?")
- Scale impossible → Architect ("PostgreSQL won't scale to 1M writes/sec")
- Analytics gap → Data Analyst ("Missing metric for this dashboard")
- Pipeline conflict → Platform Engineer ("Schedule conflicts with backup window")

---

## Data Engineering Flow

```
PHASE 1: DATA MODELING    PHASE 2: PIPELINES       PHASE 3: ANALYTICS
──────────────────────    ─────────────────        ────────────────────
Entity Design         →   ETL Design           →   Warehouse Schema
Schema Definition     →   Pipeline Orchestration→  Data Quality
Migration Strategy    →   Quality Framework    →   Reporting Setup
```

---

# PHASE 1: DATA MODELING

## Entity Relationship Design

```markdown
# Data Model: [Domain]

## Entities

### User
- id: UUID (PK)
- email: VARCHAR(255) UNIQUE
- password_hash: VARCHAR(255)
- role: ENUM('user', 'admin', 'manager')
- created_at: TIMESTAMP
- updated_at: TIMESTAMP

### Team
- id: UUID (PK)
- name: VARCHAR(100)
- owner_id: UUID (FK → User)

### TeamMember (Join Table)
- team_id: UUID (FK → Team)
- user_id: UUID (FK → User)
- role: ENUM('member', 'admin')
- PK: (team_id, user_id)

## Relationships
- User 1:N TeamMember
- Team 1:N TeamMember
```

## SQL Schema

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user'
        CHECK (role IN ('viewer', 'user', 'editor', 'admin', 'super_admin')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50),
    target_id UUID,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_audit_log_target ON audit_log(target_type, target_id);
```

## Migration Strategy

```markdown
# Migration Plan: [Change Description]

## Steps
1. Add new column (non-breaking) - Rollback: DROP COLUMN
2. Backfill data (batches to avoid locks) - Rollback: N/A
3. Add constraint (after backfill) - Rollback: DROP constraint

## Deployment Order
1. Deploy code handling both old and new schema
2. Run migrations
3. Deploy code requiring new schema
4. Remove old code paths
```

---

# PHASE 2: ETL PIPELINES

## Data Warehouse Schema (Star Schema)

```markdown
## Fact Tables

### fact_orders
**Grain**: One row per order line item
**Update Frequency**: Real-time

| Column | Type | Description |
|--------|------|-------------|
| date_key | INT | FK to dim_date |
| customer_key | INT | FK to dim_customer |
| amount | DECIMAL | Order amount |

## Dimension Tables

### dim_customer
**Type**: SCD Type 2 (full history)

| Column | Type | Description |
|--------|------|-------------|
| customer_key | INT | Surrogate key |
| customer_id | VARCHAR | Natural key |
| valid_from | TIMESTAMP | SCD validity |
| is_current | BOOLEAN | Current record |
```

## ETL Pipeline Spec

```markdown
# ETL Pipeline: [Name]

**Source**: [System] | **Target**: [Table] | **Frequency**: [Cron] | **SLA**: [Time]

## Extract
- Type: Database/API/File
- Change Detection: Timestamp/CDC/Full

## Transform
| Step | Logic |
|------|-------|
| Clean nulls | COALESCE(field, 'Unknown') |
| Standardize dates | TO_TIMESTAMP(field, 'format') |
| Lookup dimension | JOIN dim_x ON natural_key |

## Data Quality Rules
| Rule | Action if Fail |
|------|----------------|
| Not Null | Quarantine row |
| Unique | Deduplicate |
| Referential | Use unknown key |

## Load
- Type: Append/Upsert/Truncate-Load
- Batch Size: N rows
```

---

# PHASE 3: DATA QUALITY & REPORTING

## Data Quality Framework

```markdown
## Quality Dimensions

### Completeness
| Check | Threshold |
|-------|-----------|
| dim_user.email Not Null | 100% |
| fact_order.amount Has Value | 99.9% |

### Accuracy
| Check | Threshold |
|-------|-----------|
| Source vs Target sum | < 0.01% diff |
| Source vs Target count | < 0.1% diff |

### Freshness
| Table | Expected Latency |
|-------|-----------------|
| fact_orders | < 4 hours |

## Alerting
| Severity | Condition | Action |
|----------|-----------|--------|
| Critical | Pipeline failed | PagerDuty |
| Warning | Freshness SLA missed | Slack |
```

## Performance Optimization

```markdown
## Table Optimization
| Table | Partitioning | Clustering |
|-------|--------------|------------|
| fact_orders | BY DATE | customer_key |

## Materialized Views
| View | Purpose | Refresh |
|------|---------|---------|
| mv_daily_sales | Dashboard | Hourly |

## Query Patterns
| Pattern | Optimization |
|---------|--------------|
| Date range | Partition pruning |
| Aggregation | Pre-aggregated rollup |
```

---

---

## TYPE CONTRACTS (MANDATORY)

Generate binding TypeScript contracts for ALL entities:

```typescript
// docs/data/TYPE-CONTRACTS.ts

/**
 * DATABASE TO CODE MAPPING
 * DB columns use snake_case, TypeScript uses camelCase
 * This file is the SINGLE SOURCE OF TRUTH
 */

// === User Entity ===
// DB Table: users
export interface User {
  id: string;           // DB: id (UUID)
  email: string;        // DB: email (VARCHAR)
  passwordHash: string; // DB: password_hash (VARCHAR)
  createdAt: Date;      // DB: created_at (TIMESTAMP)
  updatedAt: Date;      // DB: updated_at (TIMESTAMP)
}

// Field mapping for ORM/queries
export const UserFields = {
  id: 'id',
  email: 'email',
  passwordHash: 'password_hash',
  createdAt: 'created_at',
  updatedAt: 'updated_at',
} as const;

// === Create/Update DTOs ===
export interface CreateUserDTO {
  email: string;
  password: string;  // Note: becomes passwordHash after hashing
  name: string;
}

export interface UpdateUserDTO {
  name?: string;
  email?: string;
}
```

### Contract Rules

1. **Every entity** gets an interface with exact field names
2. **Every field** includes comment with DB column name
3. **Field mapping object** for ORM/raw queries
4. **DTOs** for create/update operations

### Developer Usage

Developer MUST:
```typescript
import { User, UserFields, CreateUserDTO } from '@/types/contracts';

// Correct - uses contract types
const user: User = await db.query(`SELECT ${UserFields.email} FROM users`);

// WRONG - inventing field names
const user = { userName: '...' };  // ❌ Not in contract
```

---

## Output Location

```
docs/data/
├── DATA-MODEL.md              # Entity definitions and relationships
├── TYPE-CONTRACTS.ts          # BINDING TypeScript types (MANDATORY)
├── ERD.md                     # Entity-Relationship Diagram (Mermaid)
├── SCHEMA.sql                 # SQL schema definitions
├── WAREHOUSE-SCHEMA.md        # Star schema, dimensions, facts
├── ETL-PIPELINES.md           # Pipeline specifications
├── DATA-QUALITY.md            # Quality rules and monitoring
└── MIGRATIONS/                # Migration scripts
    ├── 001_initial_schema.sql
    └── ...
```

**CRITICAL:** TYPE-CONTRACTS.ts MUST exist before development starts. Developer MUST import and use these types.
