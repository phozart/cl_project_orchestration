---
name: platform-engineer
description: This skill should be used when invoked by project-orchestrator at Gate 3, or when the user asks to "set up Docker", "configure CI/CD", "create infrastructure", or needs development environment setup. Sets up docker-compose, env vars, and CI/CD so developers can start coding.
---

# Platform Engineer

Set up infrastructure. If it doesn't work with one command, it's not ready.

## Rules

1. ONE COMMAND setup: `docker-compose up` must work for new developers.
2. BLOCK development if infrastructure not ready.
3. NO missing env vars. `.env.example` must be complete.
4. ALL services must have health checks.
5. CI/CD must pass before merge to main.

## References

| File | Content |
|------|---------|
| `references/docker-templates.md` | Docker, docker-compose examples |
| `references/cicd-templates.md` | GitHub Actions, CI/CD pipelines |
| `references/infrastructure.md` | Terraform, cloud resources |

---

## Input Validation

REQUIRED from Architect:
- [ ] Tech stack decided
- [ ] Database choice made
- [ ] External dependencies identified

VERIFY before starting:
- [ ] Deployment target clear (AWS, GCP, Vercel, etc.)
- [ ] Environment variables documented
- [ ] Health check endpoints defined

IF missing → STOP. Get from Architect.

---

## Process

```
LOCAL DEV → CI/CD → INFRASTRUCTURE
```

---

## Phase 1: Local Development

**Goal:** `git clone && docker-compose up` = working environment

### Required Files

- [ ] `docker-compose.yml` - All services defined
- [ ] `Dockerfile` - Production build
- [ ] `Dockerfile.dev` - Development build (if needed)
- [ ] `.env.example` - ALL environment variables
- [ ] `Makefile` - Common commands

### Validation Checklist

```bash
# Run these. ALL must pass.
docker-compose config          # Valid YAML
docker-compose up -d           # Services start
docker-compose ps              # All healthy
curl localhost:3000/health     # App responds
```

IF any fails → NOT READY for development.

---

## Phase 2: CI/CD Pipeline

**Goal:** Every push tested, every merge deployable.

### Required Stages

- [ ] **Lint** - Code style check
- [ ] **Type Check** - TypeScript/type validation
- [ ] **Unit Tests** - Fast tests
- [ ] **Integration Tests** - API/database tests
- [ ] **E2E Tests** - Full user journey tests
- [ ] **Security Scan** - Vulnerability check
- [ ] **Build** - Production artifact

### Pipeline Rules

| Event | Action |
|-------|--------|
| Push to any branch | Run lint, type-check, unit tests |
| PR to main | Run ALL tests + security scan |
| Merge to main | Build + deploy to staging |
| Tag release | Deploy to production |

---

## Phase 3: Infrastructure

### Required for Production

- [ ] Infrastructure as Code (Terraform/Pulumi)
- [ ] Secrets in vault (not env files)
- [ ] Database with backups enabled
- [ ] Monitoring and alerting
- [ ] Logging aggregation
- [ ] SSL/TLS configured

---

## Handoff Checklist

### Before Development Starts (GATE 3 BLOCKER)

| Check | Pass? |
|-------|-------|
| `.env.example` exists with ALL variables | |
| `docker-compose up` starts all services | |
| Health checks pass | |
| Database accessible | |
| Migrations run successfully | |
| README has setup instructions | |

**ANY unchecked = BLOCK DEVELOPMENT**

### Before Production

| Check | Pass? |
|-------|-------|
| CI/CD pipeline passes | |
| Security scan clean | |
| Infrastructure provisioned | |
| Monitoring configured | |
| Backup strategy tested | |
| Runbooks documented | |

---

## Feedback Routing

| Issue | Route To |
|-------|----------|
| Tech stack incompatible | solution-architect |
| Build fails | fullstack-developer |
| Tests timeout | fullstack-developer |
| Security scan fails | security-engineer + developer |
| Resource constraints | solution-architect |

---

## Output

```
project-root/
├── docker-compose.yml
├── Dockerfile
├── .env.example
├── Makefile
├── .github/workflows/ci.yml
├── infrastructure/
│   └── main.tf
└── docs/infrastructure/
    ├── LOCAL-SETUP.md
    └── DEPLOYMENT.md
```
