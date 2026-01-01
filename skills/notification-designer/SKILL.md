---
name: notification-designer
description: Design notification systems including push, in-app, email, and SMS. Use when implementing user notifications, alerts, or messaging systems.
---

You are a Notification Designer. Your role is to design comprehensive notification systems that keep users informed without overwhelming them.

## When to Use This Skill

- Designing notification architecture
- Implementing push, email, SMS, or in-app notifications
- Creating notification preferences and management
- After UX design, during implementation
- When user communication requirements are defined

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing ANY notification system, validate all inputs.**

### Inputs Required

From UX Designer:
- [ ] User journey touchpoints requiring notifications
- [ ] Notification timing and context
- [ ] User preference requirements

From BA:
- [ ] Business notification requirements
- [ ] Compliance requirements (opt-in, opt-out)
- [ ] Notification priority levels

From Solution Architect:
- [ ] System architecture (where notifications originate)
- [ ] Integration requirements (email providers, SMS gateways)

From Security Engineer:
- [ ] Data privacy requirements for notifications
- [ ] Sensitive data handling in notifications

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| All notification triggers identified? | ✅/❌ | |
| User preference requirements clear? | ✅/❌ | |
| Channel requirements defined? | ✅/❌ | |
| Compliance requirements documented? | ✅/❌ | |

### Decision

- [ ] **ACCEPT** - Requirements clear, proceed with notification design
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Gaps identified (trigger UPFB)
- [ ] **BLOCK** - Cannot design without knowing notification requirements

---

## Core Responsibilities

1. **Define Notification Types** - What notifications to send
2. **Design Channel Strategy** - Which channels for which notifications
3. **Create Preference System** - User control over notifications
4. **Plan Delivery Infrastructure** - Reliable, scalable delivery
5. **Implement Rate Limiting** - Prevent notification fatigue

---

## Notification Types

### Notification Catalogue

```markdown
# Notification Catalogue

## Transactional Notifications (Must Send)
| Notification | Channels | Priority | Template |
|--------------|----------|----------|----------|
| Account created | Email | High | welcome_email |
| Password reset | Email, SMS | Critical | password_reset |
| Order confirmed | Email, Push, In-app | High | order_confirmation |
| Payment received | Email, In-app | High | payment_receipt |
| Security alert | Email, SMS, Push | Critical | security_alert |

## Engagement Notifications (Opt-in)
| Notification | Channels | Priority | Frequency |
|--------------|----------|----------|-----------|
| Weekly digest | Email | Low | Weekly |
| New feature | In-app, Push | Medium | On release |
| Activity reminder | Push, Email | Low | Configurable |
| Social updates | Push, In-app | Low | Real-time |

## System Notifications
| Notification | Channels | Priority | Audience |
|--------------|----------|----------|----------|
| Maintenance scheduled | Email, In-app | Medium | All users |
| Service disruption | In-app, Status page | High | Affected users |
| Terms updated | Email | High | All users |
```

---

## Channel Strategy

### Channel Selection Matrix

```markdown
## Channel Characteristics

| Channel | Reach | Urgency | Cost | User Control |
|---------|-------|---------|------|--------------|
| Email | High | Low-Medium | Low | High |
| Push (Mobile) | Medium | High | Free | High |
| Push (Web) | Low | Medium | Free | High |
| SMS | High | Critical | High | Medium |
| In-App | High | Low-Medium | Free | Low |

## Channel Selection Rules

| Criteria | Primary Channel | Fallback |
|----------|----------------|----------|
| Time-sensitive + Critical | SMS | Push → Email |
| Time-sensitive + Normal | Push | In-app → Email |
| Non-urgent + Important | Email | In-app |
| Non-urgent + Informational | In-app | None |
| Marketing | Email (opt-in) | Push (opt-in) |

## Multi-Channel Strategy

```
User Action → Notification Event
                    ↓
            Check User Preferences
                    ↓
    ┌───────────────┼───────────────┐
    ↓               ↓               ↓
  Email         Push/SMS         In-App
(if enabled)  (if critical)    (always)
```
```

---

## Notification Schema

### Data Model

```typescript
interface Notification {
  id: string;

  // Recipient
  user_id: string;
  channels: Channel[];  // ['email', 'push', 'in_app']

  // Content
  type: string;         // 'order_confirmed', 'security_alert'
  category: NotificationCategory;
  title: string;
  body: string;
  data?: Record<string, any>;  // Template variables

  // Delivery
  priority: 'critical' | 'high' | 'medium' | 'low';
  send_at?: Date;       // For scheduled notifications
  expires_at?: Date;    // Don't send after this time

  // Tracking
  status: 'pending' | 'sent' | 'delivered' | 'read' | 'failed';
  sent_via: Channel[];
  created_at: Date;
  updated_at: Date;
}

type Channel = 'email' | 'push_mobile' | 'push_web' | 'sms' | 'in_app';

interface NotificationCategory {
  id: string;
  name: string;
  description: string;
  default_enabled: boolean;
  user_configurable: boolean;
  channels: Channel[];
}
```

### Template System

```typescript
interface NotificationTemplate {
  id: string;
  type: string;

  // Channel-specific content
  email?: {
    subject: string;
    html_body: string;
    text_body: string;
  };

  push?: {
    title: string;
    body: string;
    icon?: string;
    action_url?: string;
  };

  sms?: {
    body: string;  // Max 160 chars
  };

  in_app?: {
    title: string;
    body: string;
    icon?: string;
    action?: { label: string; url: string };
  };

  // Personalization
  variables: string[];  // ['user_name', 'order_id']
}
```

---

## User Preferences

### Preference System Design

```markdown
## Preference Architecture

### Global Settings
- [ ] All notifications on/off (master switch)
- [ ] Quiet hours (e.g., 10pm - 8am)
- [ ] Preferred channels

### Category Settings
| Category | Default | User Can Disable |
|----------|---------|------------------|
| Security | All channels | No |
| Transactional | Email + In-app | Partial (In-app only) |
| Product updates | In-app | Yes |
| Marketing | Off | N/A (opt-in) |
| Social | Push + In-app | Yes |

### Channel Settings
- [ ] Email: Enable/Disable, Frequency (immediate, digest)
- [ ] Push: Enable/Disable per device
- [ ] SMS: Enable/Disable, Only critical
- [ ] In-app: Always on (can dismiss)

### Preference UI

```
Notification Settings
├── Quiet Hours: 10:00 PM - 8:00 AM
├── Security Alerts ⚠️ (Cannot disable)
│   ├── Email: ✓
│   ├── SMS: ✓
│   └── Push: ✓
├── Orders & Payments
│   ├── Email: ✓
│   ├── Push: ✓
│   └── SMS: ○
├── Product Updates
│   ├── Email: ○
│   └── Push: ✓
└── Marketing
    └── Email: ○ (Weekly digest)
```
```

### Preference Schema

```typescript
interface UserNotificationPreferences {
  user_id: string;

  // Global
  master_enabled: boolean;
  quiet_hours?: {
    enabled: boolean;
    start: string;  // "22:00"
    end: string;    // "08:00"
    timezone: string;
  };

  // Per-category preferences
  categories: {
    [category_id: string]: {
      enabled: boolean;
      channels: {
        email: boolean;
        push: boolean;
        sms: boolean;
      };
      frequency?: 'immediate' | 'daily_digest' | 'weekly_digest';
    };
  };

  // Per-channel settings
  channels: {
    email: {
      enabled: boolean;
      address: string;
      verified: boolean;
    };
    push: {
      enabled: boolean;
      devices: PushDevice[];
    };
    sms: {
      enabled: boolean;
      phone: string;
      verified: boolean;
      critical_only: boolean;
    };
  };
}
```

---

## Delivery Architecture

### Infrastructure Design

```markdown
## Notification Pipeline

```
Event Source → Notification Service → Queue → Workers → Channels
     │                │                          │
     │                ▼                          ▼
     │         Preference Check           Delivery Status
     │                │                          │
     │                ▼                          ▼
     │         Template Render            Status Updates
     │                │
     └────────────────┘
            (Skip if disabled)
```

### Components

| Component | Responsibility | Technology |
|-----------|---------------|------------|
| Event Ingestion | Receive notification triggers | API / Event Bus |
| Notification Service | Preference check, routing | Application logic |
| Queue | Buffer, retry, prioritize | Redis / SQS / RabbitMQ |
| Email Worker | Send emails | SendGrid / SES / Postmark |
| Push Worker | Send push notifications | FCM / APNs / OneSignal |
| SMS Worker | Send SMS | Twilio / SNS |
| In-App Worker | Store for retrieval | Database |

### Delivery Guarantees

| Priority | Delivery | Retry Strategy |
|----------|----------|----------------|
| Critical | At-least-once | 5 retries, exponential backoff |
| High | At-least-once | 3 retries |
| Medium | Best effort | 1 retry |
| Low | Best effort | No retry |
```

### Rate Limiting

```markdown
## Rate Limiting Rules

### Per-User Limits
| Channel | Limit | Window | Exception |
|---------|-------|--------|-----------|
| Email | 10 | Hour | Transactional |
| Push | 20 | Hour | Critical |
| SMS | 3 | Day | Security |
| In-App | 50 | Day | None |

### Global Limits
| Channel | Limit | Window |
|---------|-------|--------|
| Email | 10,000 | Hour |
| SMS | 1,000 | Hour |

### Handling Exceeded Limits
1. Queue for later delivery (non-critical)
2. Aggregate into digest
3. Drop with logging (low priority)
4. Always send (critical/security)
```

---

## Implementation Patterns

### Event-Driven Notifications

```typescript
// Event handler
async function handleOrderCreated(event: OrderCreatedEvent) {
  await notificationService.send({
    user_id: event.user_id,
    type: 'order_confirmed',
    priority: 'high',
    data: {
      order_id: event.order_id,
      total: event.total,
      items: event.items
    }
  });
}

// Notification service
class NotificationService {
  async send(request: NotificationRequest): Promise<void> {
    // 1. Load user preferences
    const prefs = await this.getPreferences(request.user_id);

    // 2. Check if enabled
    if (!this.shouldSend(request, prefs)) {
      return;
    }

    // 3. Determine channels
    const channels = this.selectChannels(request, prefs);

    // 4. Render templates
    const messages = await this.renderTemplates(request, channels);

    // 5. Queue for delivery
    for (const message of messages) {
      await this.queue.publish(message.channel, message);
    }
  }
}
```

### In-App Notification Center

```typescript
interface InAppNotification {
  id: string;
  user_id: string;
  type: string;
  title: string;
  body: string;
  icon?: string;
  action_url?: string;
  read: boolean;
  created_at: Date;
}

// API Endpoints
// GET /notifications - List notifications (paginated)
// GET /notifications/unread-count - Badge count
// POST /notifications/:id/read - Mark as read
// POST /notifications/read-all - Mark all as read
// DELETE /notifications/:id - Dismiss
```

---

## Compliance & Best Practices

### Compliance Requirements

```markdown
## Compliance Checklist

### CAN-SPAM (Email)
- [ ] Clear sender identification
- [ ] Accurate subject lines
- [ ] Physical address included
- [ ] Unsubscribe link in every email
- [ ] Honor opt-out within 10 days

### GDPR
- [ ] Explicit consent for marketing
- [ ] Clear privacy notice
- [ ] Right to withdraw consent
- [ ] Data minimization in notifications

### TCPA (SMS - US)
- [ ] Prior express consent for marketing SMS
- [ ] Written consent for autodialed calls
- [ ] Opt-out mechanism
- [ ] Time-of-day restrictions (8am-9pm)
```

### Best Practices

```markdown
## Notification Best Practices

### Content
- [ ] Clear, actionable content
- [ ] Personalized when possible
- [ ] Appropriate urgency level
- [ ] Deep link to relevant screen

### Timing
- [ ] Respect time zones
- [ ] Respect quiet hours
- [ ] Batch low-priority notifications
- [ ] Don't wake users for non-critical

### User Experience
- [ ] Easy to understand preferences
- [ ] One-click unsubscribe
- [ ] Preview what notifications look like
- [ ] Explain why notifications are sent
```

---

## Metrics & Monitoring

```markdown
## Notification Metrics

### Delivery Metrics
| Metric | Definition | Target |
|--------|------------|--------|
| Delivery rate | Delivered / Sent | > 99% |
| Bounce rate | Bounced / Sent | < 1% |
| Open rate (Email) | Opened / Delivered | > 25% |
| Click rate | Clicked / Delivered | > 5% |

### Engagement Metrics
| Metric | Definition | Target |
|--------|------------|--------|
| Push opt-in rate | Enabled / Total users | > 60% |
| Unsubscribe rate | Unsubscribed / Sent | < 0.5% |
| Notification interaction | Clicked / Received | > 10% |

### Health Metrics
| Metric | Alert Threshold |
|--------|----------------|
| Queue depth | > 10,000 |
| Delivery latency | > 5 minutes |
| Error rate | > 1% |
| Provider availability | < 99.9% |
```

---

## Upstream Feedback: When to Trigger

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Missing notification trigger | Developer | "Need event for X action" |
| Unclear user journey | UX | "When should we notify for Y?" |
| Compliance gap | BA | "Need explicit consent for SMS" |
| Performance impact | Architect | "Notification volume exceeds capacity" |

---

## Outputs

This skill produces:

1. **Notification Catalogue** (`docs/notifications/catalogue.md`)
2. **Channel Strategy** (`docs/notifications/channels.md`)
3. **Template Library** (`docs/notifications/templates.md`)
4. **Preference Schema** (`docs/notifications/preferences.md`)
5. **Delivery Architecture** (`docs/notifications/architecture.md`)
