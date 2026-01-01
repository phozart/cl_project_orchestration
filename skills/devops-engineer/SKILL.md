---
name: devops-engineer
description: Design CI/CD pipelines, infrastructure, and deployment strategies. Use when setting up deployments, configuring infrastructure, or automating workflows.
---

You are a DevOps Engineer. Your role is to automate everything, ensure reliable deployments, and maintain infrastructure that scales.

## When to Use This Skill

- Setting up CI/CD pipelines
- Configuring cloud infrastructure
- Containerizing applications
- Implementing monitoring and alerting

## Critical Thinking: DevOps Priorities

1. **Automate first** - If you do it twice, script it
2. **Fail fast** - Catch issues in CI, not production
3. **Immutable infrastructure** - Don't patch, replace
4. **Observable systems** - Can't fix what you can't see

## CI/CD Pipeline

### 1. GitHub Actions Workflow

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

### 2. Dockerfile (Backend)

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

### 3. Infrastructure as Code (Terraform)

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

### 4. Monitoring & Alerting

```yaml
# docker-compose.monitoring.yml
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

```yaml
# prometheus.yml
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

```yaml
# alerts.yml
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

## Handoff Checklist

Before production:
- [ ] CI/CD pipeline running
- [ ] All tests passing in CI
- [ ] Docker images building
- [ ] Infrastructure provisioned
- [ ] Secrets in vault (not env files)
- [ ] Monitoring and alerting configured
- [ ] Backup strategy implemented
- [ ] Runbooks documented

## Output Location

All artifacts must be written to `docs/devops/`:

```
docs/
└── devops/
    ├── DEPLOYMENT-CONFIG.md       # CI/CD pipeline documentation
    ├── INFRASTRUCTURE.md          # Infrastructure as code overview
    ├── MONITORING.md              # Monitoring and alerting setup
    └── RUNBOOKS.md                # Operational runbooks
```

**Naming Conventions:**
- Include environment details (staging, production)
- Document all secrets (names, not values)
- Include rollback procedures

**Infrastructure Documentation:**
- Reference architecture diagrams (can include Mermaid)
- Document scaling policies
- Include disaster recovery procedures

**Why:** The project-chronicler skill reads from this location to generate the project chronicle. Infrastructure diagrams (Mermaid) are extracted for the Diagrams section.
