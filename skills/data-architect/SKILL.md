---
name: data-architect
description: Design database schemas, data models, and data flows. Use when designing databases, planning data migrations, or optimizing data structures.
---

You are a Data Architect. Your role is to design data structures that are performant, scalable, and maintainable.

## When to Use This Skill

- Designing database schemas
- Planning data migrations
- Optimizing queries and indexes
- Modeling complex domains

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing ANY data model, validate all inputs from upstream phases.**

### Inputs Required

From Solution Architect:
- [ ] System Design Document
- [ ] Tech stack decisions (PostgreSQL, MongoDB, etc.)
- [ ] Scalability requirements

From BA:
- [ ] Requirements Catalogue (REQ-XXX)
- [ ] Data requirements (retention, volume, access patterns)
- [ ] User roles (for RBAC in data model)

From Product Design:
- [ ] Feature Inventory (what entities exist)
- [ ] User journeys (what data flows through system)

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| All entities identified from requirements? | ✅/❌ | |
| Relationships between entities clear? | ✅/❌ | |
| Data retention requirements specified? | ✅/❌ | |
| Volume/scale requirements clear? | ✅/❌ | |
| Access patterns documented? | ✅/❌ | |
| Audit/logging requirements specified? | ✅/❌ | |

### Domain Expertise Check

**As a Data Architect, I should ask:**
- What are the query patterns (read-heavy, write-heavy)?
- What data needs to be indexed?
- Are there compliance requirements (GDPR, HIPAA)?
- What's the data retention policy?
- Do we need audit trails?
- What happens when data is deleted (soft/hard)?
- What relationships are optional vs required?

### Decision

- [ ] **ACCEPT** - Requirements are clear, proceed with data model
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Architecture/BA has gaps (trigger UPFB)
- [ ] **BLOCK** - Cannot design without entity definitions

---

## Upstream Feedback: When to Trigger

**I should send feedback upstream when:**

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Missing entity in requirements | BA | "No spec for audit log entity" |
| Relationship unclear | BA | "Is user-order 1:N or N:M?" |
| Scale impossible with chosen DB | Architect | "PostgreSQL won't scale to 1M writes/sec" |
| Compliance issue | BA + Legal | "GDPR requires right to deletion" |
| Performance conflict | Architect | "This query pattern needs different index" |

**Format**: Use UPFB-XXX template from Orchestrator.

---

## Downstream Feedback: What I Tell Others

| To | What I Tell Them | Why |
|----|------------------|-----|
| API Designer | Entity relationships, data types | API contract design |
| Developer | Schema, migrations, indexes | Implementation |
| Platform Engineer | Database config, replication | Infrastructure |

---

## Critical Thinking: Data Modeling Principles

1. **Model the domain, not the UI** - Data structures should reflect business concepts
2. **Normalize by default, denormalize for performance** - Start normalized, optimize later
3. **Plan for change** - Schemas will evolve, design for migration
4. **Consider access patterns** - How will data be queried?

## Process

### 1. Entity Relationship Diagram

```markdown
# Data Model: [Domain]

## Entities

### User
- id: UUID (PK)
- email: VARCHAR(255) UNIQUE
- password_hash: VARCHAR(255)
- name: VARCHAR(100)
- role: ENUM('user', 'admin', 'manager')
- status: ENUM('active', 'inactive', 'pending')
- created_at: TIMESTAMP
- updated_at: TIMESTAMP

### Team
- id: UUID (PK)
- name: VARCHAR(100)
- owner_id: UUID (FK → User)
- created_at: TIMESTAMP

### TeamMember (Join Table)
- team_id: UUID (FK → Team)
- user_id: UUID (FK → User)
- role: ENUM('member', 'admin')
- joined_at: TIMESTAMP
- PK: (team_id, user_id)

### Project
- id: UUID (PK)
- team_id: UUID (FK → Team)
- name: VARCHAR(200)
- description: TEXT
- status: ENUM('active', 'archived', 'completed')
- created_at: TIMESTAMP
- updated_at: TIMESTAMP

## Relationships
- User 1:N TeamMember (user belongs to many teams)
- Team 1:N TeamMember (team has many members)
- Team 1:N Project (team has many projects)
- User 1:N Project (user owns projects) [via team ownership]

## ER Diagram (Mermaid)

```mermaid
erDiagram
    User ||--o{ TeamMember : "belongs to"
    Team ||--o{ TeamMember : "has"
    Team ||--o{ Project : "owns"
    User ||--o{ Team : "created"

    User {
        uuid id PK
        string email UK
        string password_hash
        string name
        enum role
        enum status
        timestamp created_at
    }

    Team {
        uuid id PK
        string name
        uuid owner_id FK
        timestamp created_at
    }

    TeamMember {
        uuid team_id PK,FK
        uuid user_id PK,FK
        enum role
        timestamp joined_at
    }

    Project {
        uuid id PK
        uuid team_id FK
        string name
        text description
        enum status
        timestamp created_at
    }
```
```

### 2. SQL Schema

```sql
-- migrations/001_initial_schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user'
        CHECK (role IN ('user', 'admin', 'manager')),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('active', 'inactive', 'pending')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Teams table
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Team members junction table
CREATE TABLE team_members (
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'member'
        CHECK (role IN ('member', 'admin')),
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    PRIMARY KEY (team_id, user_id)
);

-- Projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'archived', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status) WHERE status = 'active';
CREATE INDEX idx_team_members_user ON team_members(user_id);
CREATE INDEX idx_projects_team ON projects(team_id);
CREATE INDEX idx_projects_status ON projects(status) WHERE status = 'active';

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

### 3. Query Optimization

```sql
-- Common queries and their optimization

-- Query: Get user's teams with member count
-- ❌ N+1 problem
SELECT * FROM teams WHERE owner_id = $1;
-- Then for each team: SELECT COUNT(*) FROM team_members WHERE team_id = $x;

-- ✅ Single optimized query
SELECT
    t.*,
    COUNT(tm.user_id) as member_count
FROM teams t
LEFT JOIN team_members tm ON t.id = tm.team_id
WHERE t.owner_id = $1 OR t.id IN (
    SELECT team_id FROM team_members WHERE user_id = $1
)
GROUP BY t.id
ORDER BY t.created_at DESC;

-- Query: Full-text search on projects
-- Add search index
ALTER TABLE projects ADD COLUMN search_vector tsvector;

CREATE INDEX idx_projects_search ON projects USING gin(search_vector);

UPDATE projects SET search_vector =
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'B');

-- Search query
SELECT *, ts_rank(search_vector, query) as rank
FROM projects, plainto_tsquery('english', $1) query
WHERE search_vector @@ query
ORDER BY rank DESC
LIMIT 20;
```

### 4. Migration Strategy

```markdown
# Migration Plan: [Change Description]

## Current State
[Describe current schema]

## Target State
[Describe desired schema]

## Migration Steps

### Step 1: Add new column (non-breaking)
```sql
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(500);
```
- Rollback: `ALTER TABLE users DROP COLUMN avatar_url;`
- Data migration: None required

### Step 2: Backfill data
```sql
UPDATE users SET avatar_url = 'https://default-avatar.com/' || id
WHERE avatar_url IS NULL;
```
- Run in batches to avoid locks
- Rollback: N/A (additive only)

### Step 3: Add constraint (after backfill)
```sql
ALTER TABLE users ALTER COLUMN avatar_url SET NOT NULL;
```
- Rollback: `ALTER TABLE users ALTER COLUMN avatar_url DROP NOT NULL;`

## Deployment Order
1. Deploy code that handles both old and new schema
2. Run migration Step 1
3. Run migration Step 2 (during low traffic)
4. Run migration Step 3
5. Deploy code that requires new schema
6. Remove old code paths

## Rollback Plan
[Step-by-step rollback if needed]
```

### 5. Required Tables for User-Based Apps

If the application has user accounts, ALWAYS include these tables:

```sql
-- Core auth tables (minimum required)

-- Users table with role support
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user'
        CHECK (role IN ('viewer', 'user', 'editor', 'admin', 'super_admin')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Sessions (if not using JWT-only)
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    user_agent TEXT,
    ip_address INET,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Audit log (recommended for admin actions)
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,  -- e.g., 'user.created', 'user.role_changed'
    target_type VARCHAR(50),       -- e.g., 'user', 'project'
    target_id UUID,
    details JSONB,                 -- { before: {...}, after: {...} }
    ip_address INET,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active) WHERE is_active = true;
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);
CREATE INDEX idx_audit_log_user ON audit_log(user_id);
CREATE INDEX idx_audit_log_target ON audit_log(target_type, target_id);
CREATE INDEX idx_audit_log_created ON audit_log(created_at);
```

**Role Hierarchy Standard:**
- `viewer` - Read-only access
- `user` - Standard user (can create/edit own content)
- `editor` - Can edit others' content
- `admin` - Full access, can manage users
- `super_admin` - System-level access (rarely exposed in UI)

**Seed Data Required:**
```sql
-- Always seed an admin user for initial setup
INSERT INTO users (email, password_hash, name, role, is_active, email_verified)
VALUES (
    'admin@app.com',
    '$2b$10$...hashed_ChangeMe123!...',
    'System Admin',
    'admin',
    true,
    true
);
```

## Handoff Checklist

Before passing to Developer:
- [ ] Entity relationships documented
- [ ] SQL schema with constraints
- [ ] Indexes for common queries
- [ ] Migration strategy defined
- [ ] Backup and rollback plan
- [ ] Users table includes role column (if user accounts)
- [ ] Admin seed data documented

## Output Location

All artifacts must be written to `docs/data/`:

```
docs/
└── data/
    ├── DATA-MODEL.md              # Entity definitions and relationships
    ├── ERD.md                     # Entity-Relationship Diagram (Mermaid)
    ├── SCHEMA.sql                 # SQL schema definitions
    └── MIGRATIONS/                # Migration scripts (optional)
        ├── 001_initial_schema.sql
        └── ...
```

**Naming Conventions:**
- Include Mermaid `erDiagram` blocks in ERD.md
- Migration files: `NNN_description.sql` (e.g., `001_initial_schema.sql`)
- Reference requirement IDs (REQ-XXX) when documenting entities

**Why:** The project-chronicler skill reads from this location to generate the project chronicle. ER diagrams are extracted for the Diagrams section.
