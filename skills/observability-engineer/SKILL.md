---
name: observability-engineer
description: This skill should be used when invoked by project-orchestrator at Gate 3, or when the user asks to "set up logging", "add monitoring", "configure Sentry", "add health checks", or needs production observability. Sets up logging, error tracking, monitoring, and alerting.
---

# Observability Engineer

Set up the infrastructure that lets you know when things break. Without observability, production issues go undetected until users complain.

## When to Use This Skill

**ALWAYS use after implementation**, before deployment:
- After Platform Engineer sets up infrastructure
- After Fullstack Developer completes features
- Before DevOps deploys to production
- When user says "add monitoring", "set up logging", "add error tracking"

---

## Input Validation

> See `_templates/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Platform Engineer:** Infrastructure setup, deployment topology
**Required from Fullstack Developer:** Working application code
**Required from Solution Architect:** System design, external dependencies

**Quality Checks:**
- Application code exists to instrument
- Deployment environment known
- External services identified

**Upstream Feedback triggers:**
- No health endpoint exists → Developer ("Add /health endpoint")
- Missing environment variables → Platform Engineer ("Need logging config")
- Architecture unclear → Architect ("Which services need tracing?")

---

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Logging strategy | Final |
| Error tracking setup | Final |
| Health check endpoints | Final |
| Alert thresholds | Advisory (ops team decides) |
| Dashboard design | Final |
| Tool selection | Shared with Architect |

---

## Core Responsibilities

### 1. Structured Logging

Replace `console.log` with structured, queryable logs:

```typescript
// lib/logger.ts
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: process.env.NODE_ENV === 'development' ? { target: 'pino-pretty' } : undefined,
  base: { env: process.env.NODE_ENV, version: process.env.APP_VERSION },
  redact: ['password', 'token', 'authorization', 'cookie'],
});

export { logger };

// Usage
logger.info('User logged in', { userId: user.id, method: 'password', ip: request.ip });
logger.error('Authentication failed', { email: attemptedEmail, reason: 'invalid_password' });
```

#### Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| `fatal` | App cannot continue | Database connection lost |
| `error` | Operation failed, needs attention | Payment processing failed |
| `warn` | Unusual but handled | Rate limit approaching |
| `info` | Significant events | User signed up, order placed |
| `debug` | Development troubleshooting | Request/response details |

### 2. Error Tracking (Sentry)

```typescript
// lib/sentry.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.APP_VERSION,
  tracesSampleRate: 0.1,  // 100% errors, 10% transactions
  beforeSend(event) {
    if (event.user) { delete event.user.ip_address; delete event.user.email; }
    return event;
  },
  ignoreErrors: ['ResizeObserver loop limit exceeded', 'Network request failed'],
});

// Usage
try {
  await processPayment(order);
} catch (error) {
  Sentry.captureException(error, {
    tags: { component: 'payment' },
    extra: { orderId: order.id, amount: order.total },
  });
  throw error;
}
```

### 3. Health Check Endpoints

```typescript
// app/api/health/route.ts
export async function GET() {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || 'unknown',
    checks: {} as Record<string, { status: string; latency?: number }>,
  };

  // Database check
  const dbStart = Date.now();
  try {
    await db.$queryRaw`SELECT 1`;
    health.checks.database = { status: 'healthy', latency: Date.now() - dbStart };
  } catch {
    health.checks.database = { status: 'unhealthy' };
    health.status = 'unhealthy';
  }

  return NextResponse.json(health, { status: health.status === 'healthy' ? 200 : 503 });
}
```

| Endpoint | Purpose | Response |
|----------|---------|----------|
| `/api/health` | Full health check | All dependencies |
| `/api/health/live` | Liveness probe | App is running |
| `/api/health/ready` | Readiness probe | Can handle traffic |

### 4. Metrics Collection

```typescript
// lib/metrics.ts
import { Counter, Histogram, register } from 'prom-client';

export const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.5, 1, 2, 5],
});

export const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

// Business metrics
export const userSignups = new Counter({ name: 'user_signups_total', help: 'Total signups', labelNames: ['method'] });
```

### 5. Request Tracing

```typescript
// middleware.ts
export function middleware(request: NextRequest) {
  const traceId = request.headers.get('x-trace-id') || uuidv4();
  const response = NextResponse.next();
  response.headers.set('x-trace-id', traceId);
  logger.info('Request received', { traceId, method: request.method, path: request.nextUrl.pathname });
  return response;
}
```

---

## Observability Checklist

### Logging
- [ ] Structured logging configured (not console.log)
- [ ] Log levels used appropriately
- [ ] Sensitive data redacted
- [ ] Request IDs/trace IDs included

### Error Tracking
- [ ] Sentry (or equivalent) configured
- [ ] Source maps uploaded
- [ ] User context added (without PII)
- [ ] Error boundaries in React components

### Health Checks
- [ ] `/api/health` endpoint exists
- [ ] Database connectivity checked
- [ ] Returns 503 when unhealthy

### Metrics
- [ ] Request duration tracked
- [ ] Error rate tracked
- [ ] Key business metrics tracked

### Alerting
- [ ] Critical alerts defined (app down, high errors)
- [ ] Alert channels configured (Slack, PagerDuty)

---

## Environment Variables

```bash
# Observability
LOG_LEVEL=info                          # fatal, error, warn, info, debug
SENTRY_DSN=https://xxx@sentry.io/xxx    # Error tracking
APP_VERSION=1.0.0                       # Release tracking
```

---

## Handoff to DevOps

**Package Contents:**
1. Logger configuration (`lib/logger.ts`)
2. Sentry setup (`lib/sentry.ts`, `sentry.*.config.ts`)
3. Health check endpoints
4. Metrics configuration
5. Environment variables documented

**Verification:**
```bash
curl http://localhost:3000/api/health  # Test health endpoint
npm run dev  # Verify logs are structured
```

---

## Output Location

```
project-root/
├── lib/
│   ├── logger.ts              # Logging configuration
│   ├── sentry.ts              # Error tracking setup
│   └── metrics.ts             # Metrics collection
├── app/api/health/route.ts    # Health check endpoint
├── sentry.client.config.ts    # Sentry client config
├── sentry.server.config.ts    # Sentry server config
└── docs/observability/
    ├── LOGGING.md             # Logging conventions
    └── ALERTS.md              # Alert definitions
```

---

## Integration with Workflow

```
[IMPLEMENTATION] → [IMPLEMENTATION VERIFIER] → [OBSERVABILITY ENGINEER] → [QA] → [DEVOPS]
```

Invoke after implementation, before QA - so errors are tracked during testing.
