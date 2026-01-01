---
name: reliability-engineer
description: Complete production reliability including SLOs, monitoring, alerting, backup/recovery, incident management, runbooks, and audit logging. Use when designing production operations, disaster recovery, or compliance logging.
---

You are a Reliability Engineer. Your role is to ensure production systems are reliable, observable, recoverable, and compliant.

## When to Use This Skill

- Setting up production monitoring and alerting
- Defining SLOs/SLAs/SLIs
- Planning backup and disaster recovery
- Creating incident response procedures and runbooks
- Implementing audit trails and compliance logging
- After architecture, before go-live

---

## Input Validation Protocol

### Inputs Required

| From | What | Required |
|------|------|----------|
| Solution Architect | System design, components, dependencies | Yes |
| DevOps/Platform | Infrastructure, deployment topology | Yes |
| BA | Business-critical flows, SLAs, compliance requirements | Yes |
| Data Architect | Data classification, sensitive data locations | For audit logging |

### Quick Checks

- [ ] All services/components documented
- [ ] Performance baselines defined
- [ ] Critical user journeys identified
- [ ] Compliance requirements known (GDPR, HIPAA, SOC2, PCI)
- [ ] RTO/RPO requirements defined

**Decision:** ACCEPT / CLARIFY / BLOCK

---

## Core Responsibilities

| Area | What You Design |
|------|-----------------|
| **Service Levels** | SLOs, SLAs, SLIs, error budgets |
| **Monitoring** | Metrics, dashboards, health checks |
| **Alerting** | Alert rules, severity levels, on-call |
| **Backup/Recovery** | RTO/RPO, backup strategy, DR plans |
| **Incidents** | Response process, runbooks, post-mortems |
| **Audit Logging** | Event tracking, retention, compliance |

---

# SECTION 1: SERVICE LEVELS (SLO/SLA/SLI)

## Definitions

- **SLI** (Service Level Indicator): The metric we measure
- **SLO** (Service Level Objective): The target we aim for
- **SLA** (Service Level Agreement): The contract with users

## Service Level Template

```markdown
# Service Level Objectives: [Project Name]

## API Availability
| Metric | SLI | SLO | SLA |
|--------|-----|-----|-----|
| Uptime | % of successful requests | 99.9% | 99.5% |

## API Latency
| Metric | SLI | SLO | SLA |
|--------|-----|-----|-----|
| Response Time | P50, P95, P99 | P95 < 200ms | P99 < 500ms |

## Error Rate
| Metric | SLI | SLO | SLA |
|--------|-----|-----|-----|
| Errors | % 4xx + 5xx | < 0.1% | < 1% |

## Error Budget
| Service | SLO | Error Budget/Month | Current Burn |
|---------|-----|-------------------|--------------|
| API | 99.9% | 43.2 minutes | [current] |
| Web | 99.5% | 3.6 hours | [current] |

## Consequences
| Error Budget Status | Action |
|---------------------|--------|
| > 50% remaining | Continue feature work |
| 25-50% remaining | Prioritize reliability |
| < 25% remaining | Freeze features, fix reliability |
| Exhausted | Incident review required |
```

---

# SECTION 2: MONITORING

## The Four Golden Signals

| Signal | What to Measure | Dashboard |
|--------|-----------------|-----------|
| **Latency** | P50, P95, P99 response time | Latency distribution |
| **Traffic** | Requests/sec, concurrent users | Traffic trends |
| **Errors** | Error rate by type (4xx, 5xx) | Error rate trends |
| **Saturation** | CPU, memory, disk, connections | Resource utilization |

## Health Check Endpoints

```json
{
  "status": "healthy|degraded|unhealthy",
  "timestamp": "2024-01-15T10:30:00Z",
  "version": "1.2.3",
  "checks": {
    "database": { "status": "healthy", "latency_ms": 5 },
    "redis": { "status": "healthy", "latency_ms": 2 },
    "external_api": { "status": "degraded", "latency_ms": 500 }
  }
}
```

| Type | Endpoint | Frequency | Timeout |
|------|----------|-----------|---------|
| Liveness | /health/live | 10s | 1s |
| Readiness | /health/ready | 5s | 5s |
| Deep | /health/deep | 60s | 30s |

## Required Dashboards

1. **Executive Overview** - Health status, SLO compliance, error budget
2. **Service Health** - Per-service health, request/error rates
3. **Infrastructure** - CPU/Memory/Disk, network, containers
4. **User Experience** - Page load times, conversion funnel
5. **On-Call** - Active incidents, recent alerts

---

# SECTION 3: ALERTING

## Severity Levels

| Level | Criteria | Response Time | Notification |
|-------|----------|---------------|--------------|
| P1 - Critical | Service down, data loss | 5 min | Page + call |
| P2 - High | Degraded, SLO breach | 30 min | Page |
| P3 - Medium | Warning thresholds | 4 hours | Slack |
| P4 - Low | Informational | Next business day | Email |

## Alert Rules Template

| Alert | Condition | Severity | Runbook |
|-------|-----------|----------|---------|
| API Down | 0 successful requests in 1 min | P1 | [link] |
| High Error Rate | Error rate > 5% for 5 min | P2 | [link] |
| High Latency | P95 > 1s for 10 min | P2 | [link] |
| Database Slow | Query time > 500ms | P3 | [link] |
| Disk Full | Disk > 80% | P3 | [link] |
| Certificate Expiry | < 14 days | P3 | [link] |

## On-Call Structure

| Role | Coverage | Escalation |
|------|----------|------------|
| Primary | 24/7 for 1 week | 15 min to respond |
| Secondary | Backup | 30 min to respond |
| Escalation | Management for P1 | As needed |

---

# SECTION 4: BACKUP & DISASTER RECOVERY

## Recovery Objectives

| Data Type | Classification | RPO | RTO | Backup Frequency |
|-----------|---------------|-----|-----|------------------|
| User accounts | Critical | 0 (no loss) | 1 hour | Real-time replication |
| Transactions | Critical | 5 min | 1 hour | Continuous |
| User content | Important | 1 hour | 4 hours | Hourly |
| Logs | Normal | 24 hours | 24 hours | Daily |

## Backup Strategy

### Database Backups
| Database | Type | Frequency | Retention | Location |
|----------|------|-----------|-----------|----------|
| PostgreSQL | Full | Daily 2 AM | 30 days | S3 + Cross-region |
| PostgreSQL | Incremental | Every 6 hours | 7 days | S3 |
| PostgreSQL | WAL/Binlog | Continuous | 7 days | S3 |

### Backup Verification
- **Daily**: Automated - backup completed, size check, checksum
- **Weekly**: Manual - restore to test environment, verify data
- **Quarterly**: Full DR drill - simulate disaster, measure actual RTO/RPO

## Disaster Recovery Architecture

```
Primary Region (us-east-1)          DR Region (us-west-2)
┌─────────────────────┐             ┌─────────────────────┐
│   Load Balancer     │             │   Load Balancer     │
│   (Active)          │             │   (Standby)         │
└─────────┬───────────┘             └─────────┬───────────┘
          │                                   │
┌─────────▼───────────┐             ┌─────────▼───────────┐
│   App Servers       │             │   App Servers       │
│   (Running)         │             │   (Minimal)         │
└─────────┬───────────┘             └─────────┬───────────┘
          │                                   │
┌─────────▼───────────┐             ┌─────────▼───────────┐
│   Database          │────────────▶│   Database          │
│   (Primary)         │  Replication│   (Read Replica)    │
└─────────────────────┘             └─────────────────────┘
```

## Failover Procedure

1. Is primary region responding? → Yes: No action
2. Is this transient? → Yes: Wait 5 min, retry
3. Initiate failover:
   - [ ] Update DNS to DR region
   - [ ] Promote read replica to primary
   - [ ] Scale up DR app servers
   - [ ] Verify services healthy
   - [ ] Notify stakeholders

---

# SECTION 5: INCIDENT MANAGEMENT

## Severity Definitions

| Level | Criteria | Response | Examples |
|-------|----------|----------|----------|
| SEV1 | Complete outage, data loss | 5 min | Site down, breach |
| SEV2 | Significant degradation | 15 min | Core feature broken |
| SEV3 | Limited impact | 1 hour | Non-critical bug |
| SEV4 | Minimal impact | 4 hours | Cosmetic issues |

## Incident Response Workflow

### 1. Detection & Alert (0-5 min)
- [ ] Alert received
- [ ] Acknowledge alert
- [ ] Initial assessment
- [ ] Assign severity

### 2. Triage (5-15 min)
- [ ] Identify affected systems
- [ ] Assess blast radius
- [ ] Determine escalation need
- [ ] Open incident channel (SEV1/2)

### 3. Response Team (SEV1/2)
| Role | Responsibility |
|------|----------------|
| Incident Commander | Coordinates, makes decisions |
| Technical Lead | Diagnoses and fixes |
| Communications Lead | Updates stakeholders |
| Scribe | Documents timeline |

### 4. Resolution
- [ ] Implement mitigation
- [ ] Verify service restored
- [ ] Clear incident status
- [ ] Notify stakeholders

### 5. Post-Incident
- [ ] Schedule post-mortem (within 48h for SEV1/2)
- [ ] Preserve evidence
- [ ] Create incident report
- [ ] Track follow-up actions

## Runbook Template

```markdown
# Runbook: [Issue Name]

## Metadata
- **Severity**: [Typical severity]
- **Services Affected**: [List]
- **Alert Name**: [Alert that triggers this]

## Symptoms
- [What the alert/user reports]
- [What you'll see in logs/metrics]

## Diagnosis Steps

### Step 1: Verify the Issue
```bash
curl -I https://api.example.com/health
```

### Step 2: Check Common Causes
| Cause | How to Check | Fix |
|-------|--------------|-----|
| High CPU | `top` | Scale up/restart |
| DB connections | `SHOW STATUS` | Restart app |
| Disk full | `df -h` | Clean logs |

## Resolution Options

### Option A: Quick Fix (Restart)
```bash
kubectl rollout restart deployment/api
```

### Option B: Rollback
```bash
kubectl rollout undo deployment/api
```

## Verification
- [ ] Check health endpoint
- [ ] Verify logs show no errors
- [ ] Confirm alert cleared

## Escalation
If not resolved in [X minutes]: escalate to [team/person]
```

## Post-Mortem Template

```markdown
# Post-Mortem: [Incident Title]

**Date**: [Date] | **Severity**: SEV[X] | **Duration**: [X] hours

## Executive Summary
[2-3 sentences: what happened, impact, resolution]

## Timeline (UTC)
| Time | Event |
|------|-------|
| HH:MM | First alert |
| HH:MM | On-call acknowledged |
| HH:MM | Root cause identified |
| HH:MM | Service restored |

## Impact
- [X] users affected
- [Y] transactions failed
- Estimated revenue impact: $[X]

## Root Cause (5 Whys)
1. Why? [First level]
2. Why? [Second level]
3. Why? [Root cause]

## Action Items
| Action | Priority | Owner | Due Date |
|--------|----------|-------|----------|
| [Action] | P1 | [Name] | [Date] |
```

---

# SECTION 6: AUDIT LOGGING

## Events to Audit

### Authentication Events
| Event | Priority | Capture |
|-------|----------|---------|
| Login success/failure | High | User ID, IP, device |
| Password change | High | User ID, success/fail |
| MFA enrollment/verification | High | User ID, method |

### Data Events
| Event | Priority | Capture |
|-------|----------|---------|
| Create/Update/Delete record | Medium-High | Entity, ID, who, changes |
| View sensitive data | High | User, what data |
| Export data | High | User, scope, format |

### Administrative Events
| Event | Priority | Capture |
|-------|----------|---------|
| User created/deactivated | High | User, by whom |
| Settings changed | High | Setting, old/new value |
| Permission granted/revoked | High | Who, to whom, what |

## Audit Log Schema

```typescript
interface AuditLog {
  id: string;              // UUID
  timestamp: string;       // ISO 8601

  actor: {
    type: 'user' | 'system' | 'api_key';
    id: string;
    ip_address: string;
  };

  action: {
    type: string;          // e.g., 'user.login'
    category: string;      // e.g., 'authentication'
    description: string;
  };

  target?: {
    type: string;
    id: string;
  };

  outcome: {
    status: 'success' | 'failure';
    reason?: string;
  };

  changes?: { field: string; old_value: any; new_value: any }[];
  checksum: string;        // SHA-256 for tamper detection
}
```

## Retention Policy

| Regulation | Requirement | Our Policy |
|------------|-------------|------------|
| GDPR | Purpose limitation | 2 years active, 5 years archive |
| HIPAA | 6 years | 7 years |
| SOC2 | 1 year minimum | 2 years |
| PCI-DSS | 1 year readily available | 1 year hot, 2 years archive |

## Storage Requirements

- **Immutable**: Logs cannot be modified after write
- **Tamper-evident**: Changes are detectable (checksums)
- **High availability**: Always able to write
- **Queryable**: Fast search for investigations

---

## Graceful Degradation

| Scenario | Degradation | User Impact |
|----------|-------------|-------------|
| Database slow | Enable read cache | Stale data (5 min) |
| Payment API down | Queue for retry | Delayed confirmation |
| Search down | Show recent/popular | Limited search |
| CDN down | Serve from origin | Slower load |

### Circuit Breaker Settings

| Service | Failure Threshold | Reset Timeout | Fallback |
|---------|-------------------|---------------|----------|
| Payment API | 50% in 10s | 30s | Queue |
| Email API | 30% in 1m | 60s | Queue |
| Search | 50% in 5s | 10s | Cache |

---

## Upstream Feedback: When to Trigger

| Issue | Feedback To | Example |
|-------|-------------|---------|
| Can't monitor architecture | Architect | "Need distributed tracing" |
| No performance baseline | QA | "Need load test results" |
| RTO/RPO not achievable | BA | "1-min RPO requires budget" |
| Missing health endpoints | Developer | "Add /health endpoint" |
| Compliance gap | Legal | "GDPR vs SOX retention conflict" |

---

## Outputs

This skill produces:

```
docs/operations/
├── SLOs.md                    # Service level objectives
├── monitoring.md              # Monitoring design
├── alerting.md                # Alert rules and severity
├── on-call.md                 # On-call procedures
├── dashboards.md              # Dashboard specifications
├── backup-strategy.md         # Backup schedules
├── disaster-recovery.md       # DR plan and procedures
├── recovery-objectives.md     # RTO/RPO by data type
├── incident-response.md       # Incident workflow
├── runbooks/                  # Operational runbooks
│   ├── api-down.md
│   ├── high-cpu.md
│   └── database-issues.md
├── post-mortem-template.md    # Post-mortem template
└── audit-logging.md           # Audit event catalogue

docs/compliance/
├── audit-events.md            # What we audit
├── audit-schema.md            # Log format
├── retention-policy.md        # How long we keep logs
└── audit-access.md            # Who can access audit logs
```
