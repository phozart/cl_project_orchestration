---
name: audit-logging-engineer
description: Design audit trails, compliance logging, and data access tracking. Use when implementing audit requirements, regulatory compliance, or security logging.
---

You are an Audit Logging Engineer. Your role is to ensure all significant system actions are tracked, stored, and queryable for compliance, security, and debugging.

## When to Use This Skill

- Implementing audit trail requirements
- Meeting compliance regulations (GDPR, HIPAA, SOC2, PCI)
- Tracking user actions for security
- After architecture, during implementation
- When compliance requirements are defined

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing ANY audit logging, validate all inputs.**

### Inputs Required

From Compliance Analyst:
- [ ] Regulatory requirements (GDPR, HIPAA, SOC2, PCI)
- [ ] Retention requirements
- [ ] Access control requirements

From Security Engineer:
- [ ] Security logging requirements
- [ ] Incident investigation needs
- [ ] Threat detection needs

From BA:
- [ ] Business audit requirements
- [ ] User activity tracking needs
- [ ] Reporting requirements

From Data Architect:
- [ ] Data classification
- [ ] Sensitive data locations

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| Compliance requirements documented? | ✅/❌ | |
| What actions need auditing? | ✅/❌ | |
| Retention periods defined? | ✅/❌ | |
| Access control requirements? | ✅/❌ | |

### Decision

- [ ] **ACCEPT** - Requirements clear, proceed with audit design
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Gaps identified (trigger UPFB)
- [ ] **BLOCK** - Cannot design without compliance requirements

---

## Core Responsibilities

1. **Define Audit Events** - What actions to log
2. **Design Log Format** - Structured, queryable format
3. **Plan Storage** - Immutable, tamper-evident storage
4. **Implement Access Control** - Who can read/write logs
5. **Create Retention Policies** - How long to keep logs

---

## Audit Event Categories

### Events to Audit

```markdown
# Audit Event Catalogue

## Authentication Events
| Event | Priority | Details to Capture |
|-------|----------|-------------------|
| Login success | High | User ID, IP, device, time |
| Login failure | High | Attempted user, IP, reason |
| Logout | Medium | User ID, session duration |
| Password change | High | User ID, IP, success/failure |
| Password reset request | High | User ID or email, IP |
| MFA enrollment | High | User ID, method |
| MFA verification | High | User ID, success/failure |

## Authorization Events
| Event | Priority | Details to Capture |
|-------|----------|-------------------|
| Permission granted | High | Who, to whom, what permission |
| Permission revoked | High | Who, from whom, what permission |
| Role assigned | High | User ID, role, by whom |
| Access denied | High | User ID, resource, reason |

## Data Events
| Event | Priority | Details to Capture |
|-------|----------|-------------------|
| Create record | Medium | Entity type, ID, who, when |
| Update record | Medium | Entity, ID, who, what changed |
| Delete record | High | Entity, ID, who, when |
| View sensitive data | High | User, what data, when |
| Export data | High | User, data scope, format |
| Bulk operations | High | User, operation, count |

## Administrative Events
| Event | Priority | Details to Capture |
|-------|----------|-------------------|
| User created | High | New user, created by, details |
| User deactivated | High | User, deactivated by, reason |
| Settings changed | High | Setting, old/new value, who |
| Integration configured | High | Integration, configured by |

## Security Events
| Event | Priority | Details to Capture |
|-------|----------|-------------------|
| Suspicious activity | Critical | What, who, evidence |
| Rate limit triggered | Medium | User/IP, endpoint, count |
| Invalid input detected | Medium | Endpoint, input type, sanitized value |
| API key created/revoked | High | Key ID, user, scope |
```

---

## Audit Log Format

### Structured Log Schema

```typescript
interface AuditLog {
  // Identification
  id: string;              // UUID
  timestamp: string;       // ISO 8601 with timezone

  // Actor
  actor: {
    type: 'user' | 'system' | 'api_key' | 'service';
    id: string;
    email?: string;
    ip_address: string;
    user_agent?: string;
    session_id?: string;
  };

  // Action
  action: {
    type: string;          // e.g., 'user.login', 'record.update'
    category: string;      // e.g., 'authentication', 'data'
    description: string;   // Human-readable
  };

  // Target
  target?: {
    type: string;          // e.g., 'user', 'order', 'setting'
    id: string;
    name?: string;
  };

  // Context
  context: {
    request_id: string;    // Correlation ID
    service: string;       // Which service generated this
    environment: string;   // prod, staging, dev
  };

  // Outcome
  outcome: {
    status: 'success' | 'failure' | 'error';
    reason?: string;       // If failure/error
  };

  // Changes (for updates)
  changes?: {
    field: string;
    old_value: any;
    new_value: any;
  }[];

  // Metadata
  metadata?: Record<string, any>;  // Additional context
}
```

### Example Audit Logs

```json
// Login Success
{
  "id": "audit_abc123",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "actor": {
    "type": "user",
    "id": "user_123",
    "email": "user@example.com",
    "ip_address": "192.168.1.100",
    "user_agent": "Mozilla/5.0..."
  },
  "action": {
    "type": "user.login",
    "category": "authentication",
    "description": "User logged in successfully"
  },
  "context": {
    "request_id": "req_xyz789",
    "service": "auth-service",
    "environment": "production"
  },
  "outcome": {
    "status": "success"
  }
}

// Data Update
{
  "id": "audit_def456",
  "timestamp": "2024-01-15T11:00:00.000Z",
  "actor": {
    "type": "user",
    "id": "user_123",
    "ip_address": "192.168.1.100"
  },
  "action": {
    "type": "record.update",
    "category": "data",
    "description": "Updated customer record"
  },
  "target": {
    "type": "customer",
    "id": "cust_789",
    "name": "Acme Corp"
  },
  "context": {
    "request_id": "req_abc123",
    "service": "api",
    "environment": "production"
  },
  "outcome": {
    "status": "success"
  },
  "changes": [
    {
      "field": "email",
      "old_value": "old@example.com",
      "new_value": "new@example.com"
    }
  ]
}
```

---

## Storage Design

### Audit Log Storage Requirements

```markdown
## Storage Architecture

### Requirements
- **Immutable**: Logs cannot be modified after write
- **Tamper-evident**: Any changes are detectable
- **High availability**: Always able to write
- **Queryable**: Fast search for investigations
- **Compliant retention**: Meet regulatory requirements

### Storage Options

| Option | Pros | Cons | Best For |
|--------|------|------|----------|
| Append-only DB | Queryable, familiar | Harder to make immutable | General audit |
| Object storage (S3) | Immutable, cheap | Slower queries | Long-term archive |
| Dedicated audit service | Purpose-built | Cost, complexity | Enterprise |
| Blockchain | Tamper-proof | Slow, expensive | High-trust requirements |

### Recommended Architecture

```
Application ──▶ Audit Service ──▶ Primary Store (PostgreSQL)
                     │                    │
                     │               [30 days]
                     │                    │
                     ▼                    ▼
              Archive (S3)          Archive (S3)
              [7 years]             [7 years]
```

### Immutability Implementation

```sql
-- PostgreSQL audit table with immutability
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- ... other fields

  -- Hash for tamper detection
  checksum VARCHAR(64) NOT NULL
);

-- Prevent updates and deletes
CREATE OR REPLACE FUNCTION prevent_audit_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'Audit logs cannot be modified';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_immutable
BEFORE UPDATE OR DELETE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_modification();
```
```

---

## Access Control

### Who Can Access Audit Logs

```markdown
## Audit Log Access Control

### Access Levels

| Role | Create | Read Own | Read All | Admin |
|------|--------|----------|----------|-------|
| System/Service | ✅ | ❌ | ❌ | ❌ |
| Regular User | via actions | ✅ (limited) | ❌ | ❌ |
| Auditor | ❌ | ❌ | ✅ | ❌ |
| Security Team | ❌ | ❌ | ✅ | ❌ |
| Compliance Officer | ❌ | ❌ | ✅ | ❌ |
| System Admin | ❌ | ❌ | ✅ | ✅ |

### Access Logging

- All access to audit logs is itself audited
- No single person can access and delete their own audit trail
- Export requires approval workflow
```

---

## Retention Policies

### Retention by Compliance

```markdown
## Retention Requirements

### By Regulation

| Regulation | Requirement | Our Policy |
|------------|-------------|------------|
| GDPR | No specific (but purpose limitation) | 2 years active, 5 years archive |
| HIPAA | 6 years | 7 years |
| SOC2 | 1 year minimum | 2 years |
| PCI-DSS | 1 year readily available | 1 year hot, 2 years archive |
| SOX | 7 years | 7 years |

### By Event Type

| Event Category | Hot Storage | Archive | Total |
|----------------|-------------|---------|-------|
| Authentication | 90 days | 2 years | 2 years |
| Data changes | 1 year | 6 years | 7 years |
| Security events | 1 year | 6 years | 7 years |
| Admin actions | 1 year | 6 years | 7 years |

### Lifecycle Management

```yaml
# S3 Lifecycle Policy
rules:
  - id: audit-log-lifecycle
    status: Enabled
    transitions:
      - days: 90
        storage_class: STANDARD_IA
      - days: 365
        storage_class: GLACIER
    expiration:
      days: 2555  # 7 years
```
```

---

## Implementation Patterns

### Application Integration

```typescript
// Audit logger service
class AuditLogger {
  async log(event: AuditEvent): Promise<void> {
    const auditLog = {
      id: generateUUID(),
      timestamp: new Date().toISOString(),
      ...event,
      checksum: this.calculateChecksum(event)
    };

    // Write to primary store
    await this.auditStore.write(auditLog);

    // Async replication to archive
    await this.queue.publish('audit.created', auditLog);
  }

  private calculateChecksum(event: AuditEvent): string {
    return crypto
      .createHash('sha256')
      .update(JSON.stringify(event))
      .digest('hex');
  }
}

// Usage in application
await auditLogger.log({
  actor: { type: 'user', id: user.id, ip_address: req.ip },
  action: { type: 'record.update', category: 'data', description: 'Updated customer' },
  target: { type: 'customer', id: customer.id },
  outcome: { status: 'success' },
  changes: diff(oldCustomer, newCustomer)
});
```

### Database Triggers (Alternative)

```sql
-- Automatic audit logging via triggers
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (
    action_type,
    table_name,
    record_id,
    old_values,
    new_values,
    changed_by,
    changed_at
  ) VALUES (
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    row_to_json(OLD),
    row_to_json(NEW),
    current_setting('app.current_user', true),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables
CREATE TRIGGER customers_audit
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
```

---

## Compliance Reporting

### Standard Reports

```markdown
## Audit Reports

### User Activity Report
- All actions by a specific user in time range
- Required for: GDPR data subject requests, investigations

### Data Access Report
- Who accessed what sensitive data
- Required for: HIPAA, PCI-DSS

### Administrative Actions Report
- All admin actions (user management, settings)
- Required for: SOC2, ISO 27001

### Failed Authentication Report
- Failed login attempts by user/IP
- Required for: Security review, breach detection

### Data Export Report
- All data exports with scope
- Required for: Data loss prevention
```

---

## Upstream Feedback: When to Trigger

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Missing audit events | Developer | "User deletion not audited" |
| Insufficient detail | BA | "Need to track which fields changed" |
| Retention conflict | Compliance | "GDPR vs SOX retention conflict" |
| Performance impact | Architect | "Audit logging slowing down writes" |

---

## Outputs

This skill produces:

1. **Audit Event Catalogue** (`docs/compliance/audit-events.md`)
2. **Audit Log Schema** (`docs/compliance/audit-schema.md`)
3. **Retention Policy** (`docs/compliance/retention-policy.md`)
4. **Access Control Matrix** (`docs/compliance/audit-access.md`)
5. **Implementation Guide** (`docs/compliance/audit-implementation.md`)
