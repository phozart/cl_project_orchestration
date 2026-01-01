---
name: platform-engineer
description: Set up local development infrastructure, Docker configuration, database initialization, and environment setup. Use ALWAYS after architecture decisions are made. This skill ensures the project actually runs, not just exists on paper.
---

# Platform Engineer

Set up the infrastructure that makes the project actually work. While other skills design and document, this skill ensures you can `docker-compose up` and have a working system.

## When to Use This Skill

**ALWAYS use this skill** - it's not optional. Almost every project needs:
- Local development environment
- Database setup and migrations
- Environment configuration
- Container orchestration (usually Docker)

**Trigger Points:**
- After Solution Architect defines tech stack
- After Data Architect defines data model
- Before Fullstack Developer starts coding
- When user says "set up the project", "make it run", "initialize database"

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before setting up ANY infrastructure, validate all inputs from upstream phases.**

### Inputs Required

From Solution Architect:
- [ ] Tech Stack decisions (language, framework, database)
- [ ] System Design Document (service architecture)
- [ ] External dependencies (Redis, S3, email service, etc.)

From Data Architect:
- [ ] Database schema
- [ ] Initial migration files
- [ ] Seed data requirements

From BA:
- [ ] Environment requirements (dev, staging, prod)
- [ ] User roles for initial seeding

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| Database choice is final (PostgreSQL, MongoDB, etc.)? | ✅/❌ | |
| All external services identified? | ✅/❌ | |
| Environment variables documented? | ✅/❌ | |
| Seed data requirements clear? | ✅/❌ | |
| Port/network requirements defined? | ✅/❌ | |

### Domain Expertise Check

**As a Platform Engineer, I should ask:**
- What database version and configuration?
- Are there external services (Redis, S3, email)?
- What environment variables are needed?
- What seed data is required for development?
- Are there any special networking requirements?
- What ports need to be exposed?
- Are there secrets management requirements?

### Decision

- [ ] **ACCEPT** - Architecture clear, proceed with setup
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Architecture has gaps (trigger UPFB)
- [ ] **BLOCK** - Cannot set up without tech stack decisions

---

## Upstream Feedback: When to Trigger

**I should send feedback upstream when:**

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Tech stack incompatible | Architect | "Can't run X on Docker ARM" |
| Missing external service | Architect | "Need Redis for sessions, not specified" |
| Database config unclear | Data Architect | "What PostgreSQL extensions needed?" |
| Security concern | Security | "Secrets in .env needs vault integration" |
| Scale issue | Architect | "This won't run on 1GB RAM" |

**Format**: Use UPFB-XXX template from Orchestrator.

---

## Downstream Feedback: What I Tell Others

| To | What I Tell Them | Why |
|----|------------------|-----|
| Developer | Environment setup, docker commands | Development workflow |
| QA | Test environment setup | Testing infrastructure |
| DevOps | Local config for CI/CD | Pipeline setup |

---

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Docker configuration | Final |
| Local dev setup | Final |
| Database initialization | Final |
| Environment variables | Final |
| CI/CD integration | Shared with DevOps |
| Production infrastructure | Advisory (DevOps decides) |

## Core Responsibilities

### 1. Local Development Environment

Create a one-command setup that gets developers productive:

```bash
# Goal: New developer runs this and has working environment
git clone <repo>
cd <project>
cp .env.example .env
docker-compose up -d
# → App running, database seeded, ready to develop
```

### 2. Docker Configuration

#### docker-compose.yml (Development)

```yaml
# docker-compose.yml
version: '3.8'

services:
  # ===========================================
  # Application
  # ===========================================
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "${APP_PORT:-3000}:3000"
    volumes:
      - .:/app
      - /app/node_modules  # Preserve container node_modules
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    command: npm run dev

  # ===========================================
  # Database
  # ===========================================
  db:
    image: postgres:16-alpine
    ports:
      - "${DB_PORT:-5432}:5432"
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-app_dev}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-postgres}"]
      interval: 5s
      timeout: 5s
      retries: 5

  # ===========================================
  # Cache (if needed)
  # ===========================================
  redis:
    image: redis:7-alpine
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data:/data

  # ===========================================
  # Database Admin (development only)
  # ===========================================
  adminer:
    image: adminer
    ports:
      - "${ADMINER_PORT:-8080}:8080"
    depends_on:
      - db
    profiles:
      - tools

volumes:
  postgres_data:
  redis_data:
```

#### Dockerfile.dev (Development)

```dockerfile
# Dockerfile.dev
FROM node:20-alpine

WORKDIR /app

# Install dependencies first (layer caching)
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Development server
EXPOSE 3000
CMD ["npm", "run", "dev"]
```

#### Dockerfile (Production)

```dockerfile
# Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production image
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 appuser

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

USER appuser

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### 3. Environment Configuration

#### .env.example

```bash
# ===========================================
# Application
# ===========================================
NODE_ENV=development
APP_PORT=3000
APP_URL=http://localhost:3000

# ===========================================
# Database
# ===========================================
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=app_dev
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# ===========================================
# Redis (if used)
# ===========================================
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}

# ===========================================
# Authentication (fill in for your provider)
# ===========================================
# AUTH_SECRET=generate-with-openssl-rand-base64-32
# GOOGLE_CLIENT_ID=
# GOOGLE_CLIENT_SECRET=

# ===========================================
# External Services
# ===========================================
# API_KEY=
# STORAGE_BUCKET=
```

### 4. Database Setup

#### scripts/init-db.sql

```sql
-- Initial database setup
-- This runs automatically when postgres container first starts

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create schemas if needed
-- CREATE SCHEMA IF NOT EXISTS app;

-- Note: Tables are created by migrations, not here
-- This file is for extensions and initial setup only
```

#### scripts/migrate.sh

```bash
#!/bin/bash
set -e

echo "Running database migrations..."

# Wait for database to be ready
until pg_isready -h ${DB_HOST:-localhost} -p ${DB_PORT:-5432} -U ${DB_USER:-postgres}; do
  echo "Waiting for database..."
  sleep 2
done

# Run migrations (adjust for your migration tool)
npm run db:migrate

echo "Migrations complete!"
```

#### scripts/seed.sh

```bash
#!/bin/bash
set -e

echo "Seeding database..."

# Run seed script
npm run db:seed

echo "Database seeded!"
```

### 5. Development Scripts

#### package.json scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",

    "db:migrate": "prisma migrate dev",
    "db:migrate:prod": "prisma migrate deploy",
    "db:seed": "tsx scripts/seed.ts",
    "db:reset": "prisma migrate reset --force",
    "db:studio": "prisma studio",

    "docker:up": "docker-compose up -d",
    "docker:down": "docker-compose down",
    "docker:logs": "docker-compose logs -f",
    "docker:reset": "docker-compose down -v && docker-compose up -d",

    "setup": "npm install && cp -n .env.example .env || true && npm run docker:up && npm run db:migrate && npm run db:seed",
    "setup:clean": "npm run docker:reset && npm run db:migrate && npm run db:seed"
  }
}
```

### 6. Makefile (Alternative to npm scripts)

```makefile
.PHONY: setup dev build test clean

# Default target
all: setup

# First-time setup
setup:
	@echo "Setting up development environment..."
	cp -n .env.example .env || true
	docker-compose up -d
	@echo "Waiting for services..."
	sleep 5
	npm install
	npm run db:migrate
	npm run db:seed
	@echo "Setup complete! Run 'make dev' to start."

# Start development
dev:
	docker-compose up -d db redis
	npm run dev

# Build for production
build:
	npm run build

# Run tests
test:
	npm test

# Clean everything
clean:
	docker-compose down -v
	rm -rf node_modules
	rm -rf .next
	rm -rf dist

# Database operations
db-migrate:
	npm run db:migrate

db-seed:
	npm run db:seed

db-reset:
	npm run db:reset

# View logs
logs:
	docker-compose logs -f

# Shell into containers
shell-db:
	docker-compose exec db psql -U postgres

shell-app:
	docker-compose exec app sh
```

## Infrastructure Checklist

Before handoff to developers:

### Environment
- [ ] `.env.example` exists with all required variables
- [ ] `.env.example` has comments explaining each variable
- [ ] `.env` is in `.gitignore`
- [ ] Default values work for local development

### Docker
- [ ] `docker-compose.yml` exists and is valid
- [ ] All services start with `docker-compose up`
- [ ] Health checks configured for critical services
- [ ] Volumes persist data correctly
- [ ] Port conflicts handled (configurable ports)

### Database
- [ ] Database container starts and is accessible
- [ ] Migrations run successfully
- [ ] Seed data populates correctly
- [ ] Connection string works from app container

### Developer Experience
- [ ] Single command setup works (`npm run setup` or `make setup`)
- [ ] README has clear setup instructions
- [ ] Common issues documented with solutions
- [ ] Development server hot-reloads

### Verification
- [ ] App starts without errors
- [ ] App connects to database
- [ ] Basic routes respond correctly
- [ ] No broken links on main pages

## Common Configurations

### PostgreSQL + Prisma

```typescript
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}
```

### PostgreSQL + Raw SQL (with migrations)

```typescript
// lib/db.ts
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const query = (text: string, params?: any[]) => pool.query(text, params);
```

### MongoDB

```yaml
# docker-compose.yml addition
mongodb:
  image: mongo:7
  ports:
    - "${MONGO_PORT:-27017}:27017"
  environment:
    MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-mongo}
    MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-mongo}
  volumes:
    - mongo_data:/data/db
```

### SQLite (Simple projects)

```yaml
# No docker needed for database
# Just ensure volume mount for persistence
app:
  volumes:
    - ./data:/app/data  # SQLite file location
```

## Handoff Protocol

### Handoff to Fullstack Developer

**Package Contents:**
1. `docker-compose.yml` - Development services
2. `Dockerfile.dev` - Development container
3. `Dockerfile` - Production container
4. `.env.example` - Environment template
5. Database initialization scripts
6. Migration files (if applicable)
7. Seed scripts with sample data
8. `Makefile` or npm scripts for common operations

**Verification Steps (run these before handoff):**
```bash
# Clean slate test
rm -rf node_modules .next dist
docker-compose down -v

# Full setup
make setup  # or npm run setup

# Verify
curl http://localhost:3000  # Should respond
docker-compose exec db psql -U postgres -c "SELECT 1"  # DB accessible
```

**Handoff Checklist:**
- [ ] Fresh clone + setup works
- [ ] All services start
- [ ] Database has seed data
- [ ] App responds on expected port
- [ ] Environment variables documented

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| No .env.example | Developers guess at required vars | Always provide template |
| Hardcoded ports | Port conflicts on developer machines | Use configurable ports |
| No health checks | Services start before ready | Add health checks |
| Manual DB setup | "Works on my machine" | Automate everything |
| No seed data | Empty database, can't test | Provide realistic seeds |
| Production secrets in .env.example | Security risk | Use placeholder values only |
| Assuming global installs | "You need to install X first" | Containerize dependencies |

## Output Location

All artifacts must be written to the project root and `scripts/`:

```
project-root/
├── docker-compose.yml          # Development services
├── docker-compose.prod.yml     # Production services (optional)
├── Dockerfile                  # Production image
├── Dockerfile.dev              # Development image
├── .env.example                # Environment template
├── Makefile                    # Common commands
├── scripts/
│   ├── init-db.sql            # Database initialization
│   ├── migrate.sh             # Migration runner
│   ├── seed.sh                # Seed data loader
│   └── setup.sh               # Full setup script
└── docs/
    └── infrastructure/
        └── LOCAL-SETUP.md     # Setup documentation
```

**Why:** These files are the actual infrastructure, not documentation about infrastructure. They must be in the project root to work.

## Integration with Workflow

The Platform Engineer should be invoked:

1. **After Architecture** - Tech stack is known, can set up correct services
2. **Before Development** - Developers need working environment
3. **After Data Model** - Database schema is known for migrations

```
[Solution Architect] → Tech Stack decided
        ↓
[Data Architect] → Data model defined
        ↓
[Platform Engineer] → Infrastructure set up ← YOU ARE HERE
        ↓
[Fullstack Developer] → Can actually code
```
