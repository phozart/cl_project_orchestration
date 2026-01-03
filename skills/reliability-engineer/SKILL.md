---
name: reliability-engineer
description: This skill should be used when the user asks to "define SLOs", "set up disaster recovery", "create runbooks", "configure backups", "add audit logging", or needs production reliability. Designs SLOs, monitoring, alerting, backup/recovery, incident management, and audit logging.
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

## Input Validation

> See `_templates/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Solution Architect:** System design, components, dependencies
**Required from DevOps/Platform:** Infrastructure, deployment topology
**Required from BA:** Business-critical flows, SLAs, compliance requirements
**Required from Data Architect:** Data classification, sensitive data locations (for audit logging)

**Quality Checks:**
- All services/components documented
- Performance baselines defined
- Critical user journeys identified
- Compliance requirements known (GDPR, HIPAA, SOC2, PCI)
- RTO/RPO requirements defined

**Upstream Feedback triggers:**
- Can't monitor architecture → Architect ("Need distributed tracing")
- No performance baseline → QA ("Need load test results")
- RTO/RPO not achievable → BA ("1-min RPO requires budget")
- Missing health endpoints → Developer ("Add /health endpoint")
- Compliance gap → Legal ("GDPR vs SOX retention conflict")

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

## Service Levels (SLO/SLA/SLI)

**Definitions:**
- **SLI** (Service Level Indicator): The metric we measure
- **SLO** (Service Level Objective): The target we aim for
- **SLA** (Service Level Agreement): The contract with users

### Template

| Metric | SLI | SLO | SLA |
|--------|-----|-----|-----|
| Uptime | % of successful requests | 99.9% | 99.5% |
| Latency | P50, P95, P99 | P95 < 200ms | P99 < 500ms |
| Errors | % 4xx + 5xx | < 0.1% | < 1% |

### Error Budget

| Service | SLO | Error Budget/Month | Action When Exhausted |
|---------|-----|-------------------|-----------------------|
| API | 99.9% | 43.2 minutes | Freeze features, fix reliability |
| Web | 99.5% | 3.6 hours | Prioritize reliability work |

---

## Monitoring

### Four Golden Signals

| Signal | What to Measure | Dashboard |
|--------|-----------------|-----------|
| **Latency** | P50, P95, P99 response time | Distribution |
| **Traffic** | Requests/sec, concurrent users | Trends |
| **Errors** | Error rate by type (4xx, 5xx) | Trends |
| **Saturation** | CPU, memory, disk, connections | Utilization |

### Health Check Endpoints

| Type | Endpoint | Frequency | Response |
|------|----------|-----------|----------|
| Liveness | /health/live | 10s | App is running (200) |
| Readiness | /health/ready | 5s | Can handle traffic |
| Deep | /health/deep | 60s | All dependencies checked |

### Required Dashboards
1. **Executive Overview** - Health status, SLO compliance, error budget
2. **Service Health** - Per-service health, request/error rates
3. **Infrastructure** - CPU/Memory/Disk, network, containers
4. **On-Call** - Active incidents, recent alerts

---

## Alerting

### Severity Levels

| Level | Criteria | Response Time | Notification |
|-------|----------|---------------|--------------|
| P1 - Critical | Service down, data loss | 5 min | Page + call |
| P2 - High | Degraded, SLO breach | 30 min | Page |
| P3 - Medium | Warning thresholds | 4 hours | Slack |
| P4 - Low | Informational | Next business day | Email |

### Alert Rules

| Alert | Condition | Severity | Runbook |
|-------|-----------|----------|---------|
| API Down | 0 successful requests in 1 min | P1 | [link] |
| High Error Rate | > 5% for 5 min | P2 | [link] |
| High Latency | P95 > 1s for 10 min | P2 | [link] |
| Disk Full | > 80% | P3 | [link] |
| Cert Expiry | < 14 days | P3 | [link] |

---

## Backup & Disaster Recovery

### Recovery Objectives

| Data Type | RPO | RTO | Backup Frequency |
|-----------|-----|-----|------------------|
| User accounts | 0 (no loss) | 1 hour | Real-time replication |
| Transactions | 5 min | 1 hour | Continuous |
| User content | 1 hour | 4 hours | Hourly |
| Logs | 24 hours | 24 hours | Daily |

### Backup Strategy

| Database | Type | Frequency | Retention | Location |
|----------|------|-----------|-----------|----------|
| PostgreSQL | Full | Daily 2 AM | 30 days | S3 + Cross-region |
| PostgreSQL | Incremental | Every 6 hours | 7 days | S3 |
| PostgreSQL | WAL | Continuous | 7 days | S3 |

### Verification
- **Daily**: Automated - backup completed, size check, checksum
- **Weekly**: Manual - restore to test environment, verify data
- **Quarterly**: Full DR drill - simulate disaster, measure actual RTO/RPO

### Failover Procedure

1. Is primary region responding? → Yes: No action
2. Is this transient? → Yes: Wait 5 min, retry
3. Initiate failover:
   - [ ] Update DNS to DR region
   - [ ] Promote read replica to primary
   - [ ] Scale up DR app servers
   - [ ] Verify services healthy
   - [ ] Notify stakeholders

---

## Incident Management

### Severity Definitions

| Level | Criteria | Response | Examples |
|-------|----------|----------|----------|
| SEV1 | Complete outage, data loss | 5 min | Site down, breach |
| SEV2 | Significant degradation | 15 min | Core feature broken |
| SEV3 | Limited impact | 1 hour | Non-critical bug |

### Response Workflow

1. **Detection (0-5 min)**: Alert received → Acknowledge → Initial assessment → Assign severity
2. **Triage (5-15 min)**: Identify affected systems → Assess blast radius → Open incident channel
3. **Response Team (SEV1/2)**: Incident Commander, Technical Lead, Communications Lead, Scribe
4. **Resolution**: Implement mitigation → Verify restored → Clear incident → Notify stakeholders
5. **Post-Incident**: Schedule post-mortem (48h) → Preserve evidence → Track follow-ups

### Runbook Template

```markdown
# Runbook: [Issue Name]
**Severity**: [Typical] | **Services**: [List] | **Alert**: [Name]

## Symptoms
- [What alert/user reports]
- [What logs/metrics show]

## Diagnosis
| Cause | How to Check | Fix |
|-------|--------------|-----|
| High CPU | `top` | Scale up/restart |
| DB connections | `SHOW STATUS` | Restart app |

## Resolution Options
### Quick Fix: `kubectl rollout restart deployment/api`
### Rollback: `kubectl rollout undo deployment/api`

## Verification
- [ ] Health endpoint returns 200
- [ ] Logs show no errors
- [ ] Alert cleared
```

---

## Audit Logging

### Events to Audit

| Category | Events | Priority |
|----------|--------|----------|
| Authentication | Login success/failure, password change, MFA | High |
| Data | Create/Update/Delete, view sensitive, export | Medium-High |
| Administrative | User created/deactivated, settings changed, permissions | High |

### Audit Log Schema

```typescript
interface AuditLog {
  id: string;
  timestamp: string;  // ISO 8601
  actor: { type: 'user' | 'system' | 'api_key'; id: string; ip_address: string };
  action: { type: string; category: string; description: string };
  target?: { type: string; id: string };
  outcome: { status: 'success' | 'failure'; reason?: string };
  changes?: { field: string; old_value: any; new_value: any }[];
  checksum: string;  // SHA-256 for tamper detection
}
```

### Retention Policy

| Regulation | Requirement | Our Policy |
|------------|-------------|------------|
| GDPR | Purpose limitation | 2 years active, 5 years archive |
| HIPAA | 6 years | 7 years |
| SOC2 | 1 year minimum | 2 years |
| PCI-DSS | 1 year readily available | 1 year hot, 2 years archive |

**Storage Requirements:** Immutable, tamper-evident, high availability, queryable

---

## Graceful Degradation

| Scenario | Degradation | User Impact |
|----------|-------------|-------------|
| Database slow | Enable read cache | Stale data (5 min) |
| Payment API down | Queue for retry | Delayed confirmation |
| Search down | Show recent/popular | Limited search |

### Circuit Breaker Settings

| Service | Failure Threshold | Reset Timeout | Fallback |
|---------|-------------------|---------------|----------|
| Payment API | 50% in 10s | 30s | Queue |
| Email API | 30% in 1m | 60s | Queue |
| Search | 50% in 5s | 10s | Cache |

---

## Outputs

```
docs/operations/
├── SLOs.md                    # Service level objectives
├── monitoring.md              # Monitoring design
├── alerting.md                # Alert rules and severity
├── backup-strategy.md         # Backup schedules
├── disaster-recovery.md       # DR plan and procedures
├── incident-response.md       # Incident workflow
├── runbooks/                  # Operational runbooks
└── audit-logging.md           # Audit event catalogue
```
