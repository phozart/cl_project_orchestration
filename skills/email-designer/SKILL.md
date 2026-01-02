---
name: email-designer
description: Design transactional email templates for welcome, password reset, notifications, and marketing. Use when app sends emails to users. Covers responsive HTML emails, email service integration, and template systems.
---

# Email Designer

Design and implement the emails your application sends. Transactional emails are often an afterthought, but they're critical touchpoints with users.

## When to Use This Skill

**Use after UI design, before deployment:**
- After UI Designer establishes visual language
- When app has user accounts (welcome, password reset)
- When app has notifications (order confirmations, alerts)
- When user says "set up emails", "email templates"

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Designer:** Design system (colors, fonts, buttons)
**Required from BA:** Email triggers and requirements

**Quality Checks:**
- Visual language established for consistent branding?
- All email triggers identified (signup, password reset, orders)?
- Compliance requirements known (CAN-SPAM, GDPR)?

**Upstream Feedback triggers:**
- Missing design tokens for email styling -> Designer
- Email triggers unclear -> BA

---

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Email template design | Final |
| Email service selection | Shared with Architect |
| Template system choice | Final |
| Deliverability best practices | Final |
| Marketing email content | Advisory (marketing decides) |

## Core Email Types

### Transactional (Must-Have)
| Type | Trigger | Priority |
|------|---------|----------|
| Welcome | User signs up | Must |
| Email Verification | User signs up | Must |
| Password Reset | User requests reset | Must |
| Password Changed | Password updated | Should |
| Login from New Device | Security alert | Should |

### Commerce (If Applicable)
| Type | Trigger | Priority |
|------|---------|----------|
| Order Confirmation | Order placed | Must |
| Shipping Update | Order shipped | Must |
| Invoice/Receipt | Payment processed | Must |

---

## React Email Templates (Recommended)

```tsx
// emails/welcome.tsx
import {
  Body, Container, Head, Heading, Html,
  Preview, Section, Text, Button
} from '@react-email/components';

interface WelcomeEmailProps {
  userName: string;
  verifyUrl: string;
}

export default function WelcomeEmail({ userName, verifyUrl }: WelcomeEmailProps) {
  return (
    <Html>
      <Head />
      <Preview>Welcome to AppName - Let's get started</Preview>
      <Body style={main}>
        <Container style={container}>
          <Heading style={heading}>Welcome, {userName}!</Heading>
          <Text style={paragraph}>
            Thanks for signing up. To get started, verify your email:
          </Text>
          <Section style={buttonContainer}>
            <Button style={button} href={verifyUrl}>
              Verify Email Address
            </Button>
          </Section>
          <Text style={footer}>
            If you didn't create an account, ignore this email.
          </Text>
        </Container>
      </Body>
    </Html>
  );
}

const main = { backgroundColor: '#f4f4f5', fontFamily: 'system-ui, sans-serif' };
const container = { backgroundColor: '#ffffff', margin: '40px auto', padding: '40px', borderRadius: '8px', maxWidth: '600px' };
const heading = { fontSize: '24px', fontWeight: '600', color: '#18181b', margin: '0 0 24px' };
const paragraph = { fontSize: '16px', lineHeight: '24px', color: '#3f3f46', margin: '0 0 16px' };
const buttonContainer = { textAlign: 'center' as const, margin: '32px 0' };
const button = { backgroundColor: '#2563eb', borderRadius: '6px', color: '#ffffff', fontSize: '16px', fontWeight: '600', padding: '12px 24px', textDecoration: 'none' };
const footer = { fontSize: '14px', color: '#71717a', marginTop: '32px' };
```

---

## Email Service Integration

```typescript
// lib/email.ts
import { Resend } from 'resend';
import WelcomeEmail from '@/emails/welcome';
import PasswordResetEmail from '@/emails/password-reset';

const resend = new Resend(process.env.RESEND_API_KEY);

export const email = {
  async sendWelcome(to: string, userName: string, verifyUrl: string) {
    return resend.emails.send({
      from: 'AppName <noreply@app.com>',
      to,
      subject: 'Welcome to AppName',
      react: WelcomeEmail({ userName, verifyUrl }),
    });
  },

  async sendPasswordReset(to: string, userName: string, resetUrl: string, context: { ipAddress: string; location: string }) {
    return resend.emails.send({
      from: 'AppName <noreply@app.com>',
      to,
      subject: 'Reset Your Password',
      react: PasswordResetEmail({ userName, resetUrl, expiresIn: '1 hour', ...context }),
    });
  },
};
```

---

## Deliverability Checklist

### Technical Setup
- [ ] SPF record configured
- [ ] DKIM signing enabled
- [ ] DMARC policy set
- [ ] Custom sending domain (not @gmail.com)
- [ ] Unsubscribe link in all emails
- [ ] Physical address in footer (CAN-SPAM)

### Content Best Practices
- [ ] Clear sender name (not "noreply")
- [ ] Descriptive subject lines
- [ ] Preheader text set
- [ ] Alt text for images
- [ ] Plain text version available
- [ ] Mobile-responsive design
- [ ] Tested in Gmail, Outlook, Apple Mail

---

## Environment Variables

```bash
# Email
RESEND_API_KEY=re_xxxxx
EMAIL_FROM=noreply@app.com
EMAIL_FROM_NAME=AppName
APP_URL=https://app.com
```

## Handoff to Fullstack Developer

**Package Contents:**
1. Email templates (`/emails/*.tsx`)
2. Email sending utility (`/lib/email.ts`)
3. Template inventory document
4. Environment variables documented

**Integration Points:**
```typescript
await email.sendWelcome(...)     // After signup
await email.sendPasswordReset(...) // Forgot password endpoint
await email.sendOrderConfirmation(...) // After order placed
```

## Output Location

```
project-root/
├── emails/
│   ├── components/  # Shared (Header, Footer, Button)
│   ├── welcome.tsx
│   ├── verify-email.tsx
│   ├── password-reset.tsx
│   └── order-confirmation.tsx
├── lib/
│   └── email.ts
└── docs/emails/
    ├── TEMPLATE-INVENTORY.md
    └── DELIVERABILITY.md
```
