---
name: platform-engineer
description: Complete platform engineering including local dev setup, Docker configuration, CI/CD pipelines, Infrastructure as Code, and deployment automation. Use when setting up development environments, CI/CD, or cloud infrastructure.
---

You are a Platform Engineer. Your role is to build and automate the complete platform - from local development environments to production deployment pipelines.

**Core principle: If you do it twice, automate it.**

## When to Use This Skill

- Setting up local development environment
- Configuring Docker containers
- Creating CI/CD pipelines
- Provisioning cloud infrastructure
- Automating deployments
- After architecture decisions are made
- Before developers start coding

---

## Input Validation Protocol

### Inputs Required

| From | What | Required |
|------|------|----------|
| Solution Architect | Tech stack, system design, deployment target | Yes |
| Data Architect | Database schema, migrations | Yes |
| BA | Environment requirements, compliance needs | For prod |
| Security | Secrets management, scanning requirements | For prod |

### Quick Checks

- [ ] Tech stack decided (language, framework, database)?
- [ ] External dependencies identified (Redis, S3, etc.)?
- [ ] Environment variables documented?
- [ ] Deployment target clear (AWS, GCP, Vercel)?
- [ ] Rollback strategy defined?

**Decision:** ACCEPT / CLARIFY / BLOCK

---

## Platform Engineering Flow

```
PHASE 1: LOCAL DEV       PHASE 2: CI/CD          PHASE 3: INFRASTRUCTURE
────────────────        ────────────────         ─────────────────────────
Docker Setup       →    Build Pipeline      →    Infrastructure as Code
Environment Config →    Test Automation     →    Cloud Resources
Database Init      →    Security Scanning   →    Deployment Config
Dev Scripts        →    Deploy Pipeline     →    Monitoring Setup
```

---

# PHASE 1: LOCAL DEVELOPMENT SETUP

**Goal: New developer runs one command and has a working environment.**

```bash
git clone <repo>
cd <project>
cp .env.example .env
docker-compose up -d
# → App running, database seeded, ready to develop
```

## Docker Configuration

### docker-compose.yml (Development)

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

### Dockerfile.dev (Development)

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

### Dockerfile (Production)

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

## Environment Configuration

### .env.example

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

## Database Setup

### scripts/init-db.sql

```sql
-- Initial database setup
-- Runs automatically when postgres container first starts

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Note: Tables are created by migrations, not here
-- This file is for extensions and initial setup only
```

## Development Scripts

### Makefile

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

---

# PHASE 2: CI/CD PIPELINE

**Goal: Every push is tested, every merge to main is deployable.**

## GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '20'
  PYTHON_VERSION: '3.12'

jobs:
  # ========================================
  # Frontend CI
  # ========================================
  frontend-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
          cache-dependency-path: frontend/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: frontend
      - run: pnpm lint
        working-directory: frontend
      - run: pnpm type-check
        working-directory: frontend

  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
          cache-dependency-path: frontend/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: frontend
      - run: pnpm test:coverage
        working-directory: frontend
      - uses: codecov/codecov-action@v3
        with:
          files: frontend/coverage/lcov.info
          flags: frontend

  frontend-e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
          cache-dependency-path: frontend/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: frontend
      - run: npx playwright install --with-deps
        working-directory: frontend
      - run: pnpm test:e2e
        working-directory: frontend
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: frontend/playwright-report

  # ========================================
  # Backend CI
  # ========================================
  backend-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v3
      - run: uv sync
        working-directory: backend
      - run: uv run ruff check .
        working-directory: backend
      - run: uv run ruff format --check .
        working-directory: backend
      - run: uv run mypy .
        working-directory: backend

  backend-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v3
      - run: uv sync
        working-directory: backend
      - run: uv run pytest --cov --cov-report=xml
        working-directory: backend
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/test
      - uses: codecov/codecov-action@v3
        with:
          files: backend/coverage.xml
          flags: backend

  # ========================================
  # Security Scanning
  # ========================================
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

  # ========================================
  # Build & Deploy
  # ========================================
  build-frontend:
    needs: [frontend-lint, frontend-test, frontend-e2e]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
          cache-dependency-path: frontend/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: frontend
      - run: pnpm build
        working-directory: frontend
        env:
          NEXT_PUBLIC_API_URL: ${{ secrets.API_URL }}
      # Deploy to Vercel/Cloudflare/etc

  build-backend:
    needs: [backend-lint, backend-test, security-scan]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: ghcr.io/${{ github.repository }}/backend:${{ github.sha }}
```

## Backend Dockerfile (Production)

```dockerfile
# backend/Dockerfile
FROM python:3.12-slim as builder

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Production image
FROM python:3.12-slim

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application code
COPY . .

# Set environment
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Run as non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

# PHASE 3: INFRASTRUCTURE AS CODE

## Terraform Configuration

```hcl
# infrastructure/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "app/terraform.tfstate"
    region = "us-east-1"
  }
}

# Variables
variable "environment" {
  type    = string
  default = "production"
}

variable "app_name" {
  type    = string
  default = "myapp"
}

# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.app_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = var.environment != "production"

  tags = {
    Environment = var.environment
  }
}

# RDS PostgreSQL
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.0.0"

  identifier = "${var.app_name}-db"

  engine               = "postgres"
  engine_version       = "16"
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = "db.t3.micro"

  allocated_storage = 20

  db_name  = var.app_name
  username = "admin"
  port     = 5432

  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_ids             = module.vpc.private_subnets

  backup_retention_period = 7
  deletion_protection     = var.environment == "production"
}

# ECS Fargate
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.0.0"

  cluster_name = "${var.app_name}-cluster"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}
```

## Monitoring & Alerting

### docker-compose.monitoring.yml

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana

  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml

volumes:
  grafana-data:
```

### prometheus.yml

```yaml
global:
  scrape_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

rule_files:
  - 'alerts.yml'

scrape_configs:
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:8000']
    metrics_path: /metrics
```

### alerts.yml

```yaml
groups:
  - name: app
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High latency detected (p95 > 1s)"
```

---

## Infrastructure Checklist

### Before Development Handoff

- [ ] `.env.example` exists with all required variables
- [ ] `docker-compose.yml` exists and is valid
- [ ] All services start with `docker-compose up`
- [ ] Health checks configured for critical services
- [ ] Database container starts and is accessible
- [ ] Single command setup works (`make setup`)

### Before Production

- [ ] CI/CD pipeline running
- [ ] All tests passing in CI
- [ ] Docker images building
- [ ] Infrastructure provisioned
- [ ] Secrets in vault (not env files)
- [ ] Monitoring and alerting configured
- [ ] Backup strategy implemented
- [ ] Runbooks documented

---

## Upstream Feedback: When to Trigger

| Issue | Feedback To | Example |
|-------|-------------|---------|
| Tech stack incompatible | Architect | "Can't run X on Docker ARM" |
| Build fails | Developer | "Build command fails with error X" |
| Tests timeout | Developer | "Test suite takes too long for CI" |
| Security scan fails | Security + Dev | "SAST found critical vulnerability" |
| Resource constraints | Architect | "App needs more memory than available" |
| Missing config | Data Architect | "What PostgreSQL extensions needed?" |

---

## Outputs

```
project-root/
├── docker-compose.yml          # Development services
├── docker-compose.prod.yml     # Production services
├── docker-compose.monitoring.yml # Monitoring stack
├── Dockerfile                  # Production image
├── Dockerfile.dev              # Development image
├── .env.example                # Environment template
├── Makefile                    # Common commands
├── scripts/
│   ├── init-db.sql            # Database initialization
│   ├── migrate.sh             # Migration runner
│   └── seed.sh                # Seed data loader
├── .github/
│   └── workflows/
│       └── ci.yml             # CI/CD pipeline
├── infrastructure/
│   ├── main.tf                # Terraform config
│   └── variables.tf           # Terraform variables
└── docs/
    └── infrastructure/
        ├── LOCAL-SETUP.md     # Setup documentation
        ├── DEPLOYMENT.md      # Deployment guide
        └── MONITORING.md      # Monitoring setup
```
