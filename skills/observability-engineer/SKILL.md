---
name: observability-engineer
description: Set up logging, error tracking, monitoring, and alerting. Use ALWAYS after implementation - apps without observability fail silently in production. Covers structured logging, Sentry/error tracking, health checks, and alerting.
---

# Observability Engineer

Set up the infrastructure that lets you know when things break. Without observability, production issues go undetected until users complain.

## Why This Exists

Common production failures:
- "The app has been down for 3 hours and nobody noticed"
- "Users report errors but we can't reproduce them"
- "We have no idea what's slow or why"
- "Logs are just `console.log('here')` everywhere"

## When to Use This Skill

**ALWAYS use after implementation**, before deployment:
- After Platform Engineer sets up infrastructure
- After Fullstack Developer completes features
- Before DevOps deploys to production
- When user says "add monitoring", "set up logging", "add error tracking"

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Logging strategy | Final |
| Error tracking setup | Final |
| Health check endpoints | Final |
| Alert thresholds | Advisory (ops team decides) |
| Dashboard design | Final |
| Tool selection | Shared with Architect |

## Core Responsibilities

### 1. Structured Logging

Replace `console.log` with structured, queryable logs:

```typescript
// ❌ Bad: Unstructured, hard to query
console.log('User logged in');
console.log('Error:', error);

// ✅ Good: Structured, queryable, contextual
import { logger } from '@/lib/logger';

logger.info('User logged in', {
  userId: user.id,
  email: user.email,
  method: 'password',
  ip: request.ip,
});

logger.error('Authentication failed', {
  email: attemptedEmail,
  reason: 'invalid_password',
  attemptCount: 3,
  ip: request.ip,
});
```

#### Logger Setup (Pino - Recommended)

```typescript
// lib/logger.ts
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: process.env.NODE_ENV === 'development'
    ? { target: 'pino-pretty' }
    : undefined,
  base: {
    env: process.env.NODE_ENV,
    version: process.env.APP_VERSION,
  },
  redact: ['password', 'token', 'authorization', 'cookie'],
});

export { logger };
```

#### Log Levels Convention

| Level | When to Use | Example |
|-------|-------------|---------|
| `fatal` | App cannot continue | Database connection lost permanently |
| `error` | Operation failed, needs attention | Payment processing failed |
| `warn` | Unusual but handled | Rate limit approaching |
| `info` | Significant events | User signed up, order placed |
| `debug` | Development troubleshooting | Request/response details |
| `trace` | Very detailed debugging | Function entry/exit |

### 2. Error Tracking (Sentry)

Capture, aggregate, and alert on errors:

```typescript
// lib/sentry.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.APP_VERSION,

  // Sample 100% of errors, 10% of transactions
  tracesSampleRate: 0.1,

  // Don't send PII
  beforeSend(event) {
    if (event.user) {
      delete event.user.ip_address;
      delete event.user.email;
    }
    return event;
  },

  // Ignore known non-errors
  ignoreErrors: [
    'ResizeObserver loop limit exceeded',
    'Network request failed',
    /Loading chunk \d+ failed/,
  ],
});

// Usage in code
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

#### Error Context Best Practices

```typescript
// Add user context when authenticated
Sentry.setUser({
  id: user.id,
  username: user.name,
  // Don't include email unless necessary
});

// Add breadcrumbs for debugging
Sentry.addBreadcrumb({
  category: 'checkout',
  message: 'User started checkout',
  level: 'info',
  data: { cartItems: cart.items.length },
});
```

### 3. Health Check Endpoints

Every app needs health checks for load balancers and monitoring:

```typescript
// app/api/health/route.ts (Next.js)
import { NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { redis } from '@/lib/redis';

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
    health.checks.database = {
      status: 'healthy',
      latency: Date.now() - dbStart
    };
  } catch (error) {
    health.checks.database = { status: 'unhealthy' };
    health.status = 'unhealthy';
  }

  // Redis check (if used)
  if (redis) {
    const redisStart = Date.now();
    try {
      await redis.ping();
      health.checks.redis = {
        status: 'healthy',
        latency: Date.now() - redisStart
      };
    } catch (error) {
      health.checks.redis = { status: 'unhealthy' };
      health.status = 'unhealthy';
    }
  }

  const statusCode = health.status === 'healthy' ? 200 : 503;
  return NextResponse.json(health, { status: statusCode });
}
```

#### Health Check Types

| Endpoint | Purpose | Response |
|----------|---------|----------|
| `/api/health` | Full health check | All dependencies checked |
| `/api/health/live` | Liveness probe | App is running (simple 200) |
| `/api/health/ready` | Readiness probe | App can handle traffic |

### 4. Metrics Collection

Track key metrics for dashboards and alerting:

```typescript
// lib/metrics.ts
import { Counter, Histogram, register } from 'prom-client';

// Request metrics
export const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.5, 1, 2, 5],
});

export const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

// Business metrics
export const userSignups = new Counter({
  name: 'user_signups_total',
  help: 'Total number of user signups',
  labelNames: ['method'], // 'email', 'google', etc.
});

export const ordersPlaced = new Counter({
  name: 'orders_placed_total',
  help: 'Total number of orders placed',
});

// Expose metrics endpoint
// GET /api/metrics
export async function GET() {
  const metrics = await register.metrics();
  return new Response(metrics, {
    headers: { 'Content-Type': register.contentType },
  });
}
```

### 5. Alerting Rules

Define alerts for critical conditions:

```yaml
# alerts/critical.yaml (Prometheus/Grafana format)
groups:
  - name: critical
    rules:
      # App is down
      - alert: AppDown
        expr: up{job="app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Application is down"

      # High error rate
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status_code=~"5.."}[5m]))
          / sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Error rate above 5%"

      # Slow responses
      - alert: SlowResponses
        expr: |
          histogram_quantile(0.95,
            sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
          ) > 2
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "95th percentile response time above 2s"

      # Database connection issues
      - alert: DatabaseUnhealthy
        expr: health_check_database_status == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Database health check failing"
```

### 6. Request Tracing

Trace requests across services:

```typescript
// middleware.ts
import { NextRequest, NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';

export function middleware(request: NextRequest) {
  // Generate or propagate trace ID
  const traceId = request.headers.get('x-trace-id') || uuidv4();

  const response = NextResponse.next();
  response.headers.set('x-trace-id', traceId);

  // Log request with trace ID
  logger.info('Request received', {
    traceId,
    method: request.method,
    path: request.nextUrl.pathname,
    userAgent: request.headers.get('user-agent'),
  });

  return response;
}
```

## Observability Checklist

Before deployment, verify:

### Logging
- [ ] Structured logging configured (not console.log)
- [ ] Log levels used appropriately
- [ ] Sensitive data redacted (passwords, tokens)
- [ ] Request IDs/trace IDs included
- [ ] Logs shipped to aggregator (if production)

### Error Tracking
- [ ] Sentry (or equivalent) configured
- [ ] Source maps uploaded for stack traces
- [ ] User context added (without PII)
- [ ] Error boundaries in React components
- [ ] Unhandled rejection handler

### Health Checks
- [ ] `/api/health` endpoint exists
- [ ] Database connectivity checked
- [ ] External dependencies checked
- [ ] Returns 503 when unhealthy

### Metrics
- [ ] Request duration tracked
- [ ] Error rate tracked
- [ ] Key business metrics tracked
- [ ] Metrics endpoint exposed

### Alerting
- [ ] Critical alerts defined (app down, high errors)
- [ ] Alert channels configured (Slack, PagerDuty)
- [ ] On-call rotation established (if production)

## Environment Variables

```bash
# .env.example additions

# ===========================================
# Observability
# ===========================================
LOG_LEVEL=info                          # fatal, error, warn, info, debug, trace
SENTRY_DSN=https://xxx@sentry.io/xxx    # Error tracking
APP_VERSION=1.0.0                       # For release tracking

# Optional: External services
LOGTAIL_TOKEN=                          # Log aggregation
GRAFANA_CLOUD_API_KEY=                  # Metrics
PAGERDUTY_INTEGRATION_KEY=              # Alerting
```

## Handoff Protocol

### Handoff to DevOps Engineer

**Package Contents:**
1. Logger configuration (`lib/logger.ts`)
2. Sentry setup (`lib/sentry.ts`, `sentry.*.config.ts`)
3. Health check endpoints
4. Metrics configuration
5. Alert rules (if applicable)
6. Environment variables documented

**Verification:**
```bash
# Test health endpoint
curl http://localhost:3000/api/health

# Verify logs are structured
npm run dev  # Check log output format

# Test error tracking
# Trigger a test error and verify it appears in Sentry
```

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| console.log everywhere | Unstructured, not queryable | Use structured logger |
| Logging sensitive data | Security/compliance risk | Redact passwords, tokens, PII |
| No health checks | Load balancer sends traffic to dead instances | Add /health endpoint |
| Alerts on everything | Alert fatigue, ignored alerts | Alert only on actionable issues |
| No error context | Can't reproduce issues | Include user ID, request ID, state |
| Sampling too aggressively | Miss rare but critical errors | Sample errors at 100%, traces lower |

## Output Location

```
project-root/
├── lib/
│   ├── logger.ts              # Logging configuration
│   ├── sentry.ts              # Error tracking setup
│   └── metrics.ts             # Metrics collection
├── app/api/
│   ├── health/
│   │   └── route.ts           # Health check endpoint
│   └── metrics/
│       └── route.ts           # Prometheus metrics
├── sentry.client.config.ts    # Sentry client config
├── sentry.server.config.ts    # Sentry server config
└── docs/
    └── observability/
        ├── LOGGING.md         # Logging conventions
        ├── ALERTS.md          # Alert definitions
        └── RUNBOOK.md         # Incident response
```

## Integration with Workflow

```
[IMPLEMENTATION] → [IMPLEMENTATION VERIFIER]
        ↓
[OBSERVABILITY ENGINEER] ← Set up logging, errors, health
        ↓
[QA TESTING] → Now errors are tracked during testing
        ↓
[DEVOPS] → Deploy with monitoring configured
```

The Observability Engineer should be invoked:
1. **After Implementation** - Code exists to instrument
2. **Before QA** - Catch errors during testing
3. **Before Deployment** - Production needs monitoring
