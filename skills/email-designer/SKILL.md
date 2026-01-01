---
name: email-designer
description: Design transactional email templates for welcome, password reset, notifications, and marketing. Use when app sends emails to users. Covers responsive HTML emails, email service integration, and template systems.
---

# Email Designer

Design and implement the emails your application sends. Transactional emails are often an afterthought, but they're critical touchpoints with users.

## Why This Exists

Common email failures:
- "Welcome email looks broken on mobile"
- "Password reset email went to spam"
- "We forgot to set up email sending"
- "Our emails look like phishing attempts"

## When to Use This Skill

**Use after UI design, before deployment:**
- After UI Designer establishes visual language
- When app has user accounts (welcome, password reset)
- When app has notifications (order confirmations, alerts)
- When user says "set up emails", "email templates"

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Email template design | Final |
| Email service selection | Shared with Architect |
| Template system choice | Final |
| Deliverability best practices | Final |
| Marketing email content | Advisory (marketing decides) |

## Core Responsibilities

### 1. Email Types to Design

Every app with users needs these transactional emails:

| Email Type | Trigger | Priority |
|------------|---------|----------|
| Welcome | User signs up | Must |
| Email Verification | User signs up | Must |
| Password Reset | User requests reset | Must |
| Password Changed | Password updated | Should |
| Login from New Device | Security alert | Should |
| Account Locked | Too many failed attempts | Should |

Apps with commerce/notifications also need:

| Email Type | Trigger | Priority |
|------------|---------|----------|
| Order Confirmation | Order placed | Must |
| Shipping Update | Order shipped | Must |
| Invoice/Receipt | Payment processed | Must |
| Subscription Renewal | Upcoming charge | Should |
| Feature Announcement | New release | Could |

### 2. Email Template Structure

```html
<!-- Base template structure (React Email / MJML) -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>{{subject}}</title>
  <!--[if mso]>
  <style type="text/css">
    table { border-collapse: collapse; }
    .fallback-font { font-family: Arial, sans-serif; }
  </style>
  <![endif]-->
</head>
<body style="margin: 0; padding: 0; background-color: #f4f4f5;">
  <!-- Preheader (preview text) -->
  <div style="display: none; max-height: 0; overflow: hidden;">
    {{preheader}}
  </div>

  <!-- Main container -->
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td align="center" style="padding: 40px 20px;">
        <!-- Content wrapper (max 600px) -->
        <table role="presentation" width="600" cellspacing="0" cellpadding="0"
               style="max-width: 600px; width: 100%;">

          <!-- Header with logo -->
          <tr>
            <td align="center" style="padding-bottom: 32px;">
              <img src="{{logoUrl}}" alt="{{appName}}" width="120"
                   style="display: block;">
            </td>
          </tr>

          <!-- Main content card -->
          <tr>
            <td style="background-color: #ffffff; border-radius: 8px;
                       padding: 40px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
              {{content}}
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td align="center" style="padding-top: 32px; color: #71717a;
                                      font-size: 12px; font-family: system-ui, sans-serif;">
              <p style="margin: 0 0 8px;">
                {{companyName}} · {{companyAddress}}
              </p>
              <p style="margin: 0;">
                <a href="{{unsubscribeUrl}}" style="color: #71717a;">Unsubscribe</a>
                ·
                <a href="{{preferencesUrl}}" style="color: #71717a;">Email Preferences</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

### 3. React Email Templates (Recommended)

```tsx
// emails/welcome.tsx
import {
  Body, Container, Head, Heading, Html, Img, Link,
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
          <Img
            src="https://app.com/logo.png"
            width="120"
            height="40"
            alt="AppName"
            style={logo}
          />

          <Heading style={heading}>Welcome, {userName}!</Heading>

          <Text style={paragraph}>
            Thanks for signing up for AppName. We're excited to have you on board.
          </Text>

          <Text style={paragraph}>
            To get started, please verify your email address:
          </Text>

          <Section style={buttonContainer}>
            <Button style={button} href={verifyUrl}>
              Verify Email Address
            </Button>
          </Section>

          <Text style={paragraph}>
            Or copy and paste this link into your browser:
          </Text>

          <Text style={link}>{verifyUrl}</Text>

          <Text style={paragraph}>
            This link expires in 24 hours.
          </Text>

          <Text style={footer}>
            If you didn't create an account, you can safely ignore this email.
          </Text>
        </Container>
      </Body>
    </Html>
  );
}

// Styles
const main = {
  backgroundColor: '#f4f4f5',
  fontFamily: 'system-ui, -apple-system, sans-serif',
};

const container = {
  backgroundColor: '#ffffff',
  margin: '40px auto',
  padding: '40px',
  borderRadius: '8px',
  maxWidth: '600px',
};

const logo = {
  margin: '0 auto 32px',
  display: 'block',
};

const heading = {
  fontSize: '24px',
  fontWeight: '600',
  color: '#18181b',
  margin: '0 0 24px',
};

const paragraph = {
  fontSize: '16px',
  lineHeight: '24px',
  color: '#3f3f46',
  margin: '0 0 16px',
};

const buttonContainer = {
  textAlign: 'center' as const,
  margin: '32px 0',
};

const button = {
  backgroundColor: '#2563eb',
  borderRadius: '6px',
  color: '#ffffff',
  fontSize: '16px',
  fontWeight: '600',
  padding: '12px 24px',
  textDecoration: 'none',
};

const link = {
  fontSize: '14px',
  color: '#2563eb',
  wordBreak: 'break-all' as const,
};

const footer = {
  fontSize: '14px',
  color: '#71717a',
  marginTop: '32px',
};
```

### 4. Password Reset Email

```tsx
// emails/password-reset.tsx
import {
  Body, Container, Head, Heading, Html,
  Preview, Section, Text, Button
} from '@react-email/components';

interface PasswordResetEmailProps {
  userName: string;
  resetUrl: string;
  expiresIn: string;
  ipAddress: string;
  location: string;
}

export default function PasswordResetEmail({
  userName,
  resetUrl,
  expiresIn,
  ipAddress,
  location,
}: PasswordResetEmailProps) {
  return (
    <Html>
      <Head />
      <Preview>Reset your password - Link expires in {expiresIn}</Preview>
      <Body style={main}>
        <Container style={container}>
          <Heading style={heading}>Reset Your Password</Heading>

          <Text style={paragraph}>Hi {userName},</Text>

          <Text style={paragraph}>
            We received a request to reset your password. Click the button below
            to create a new password:
          </Text>

          <Section style={buttonContainer}>
            <Button style={button} href={resetUrl}>
              Reset Password
            </Button>
          </Section>

          <Text style={paragraph}>
            This link expires in <strong>{expiresIn}</strong>.
          </Text>

          {/* Security context */}
          <Section style={securityBox}>
            <Text style={securityText}>
              <strong>Request details:</strong><br />
              IP Address: {ipAddress}<br />
              Location: {location}
            </Text>
          </Section>

          <Text style={warning}>
            If you didn't request this password reset, please ignore this email
            or contact support if you're concerned about your account security.
          </Text>
        </Container>
      </Body>
    </Html>
  );
}

const securityBox = {
  backgroundColor: '#f4f4f5',
  borderRadius: '6px',
  padding: '16px',
  marginTop: '24px',
};

const securityText = {
  fontSize: '14px',
  color: '#52525b',
  margin: '0',
  lineHeight: '20px',
};

const warning = {
  fontSize: '14px',
  color: '#71717a',
  marginTop: '24px',
  paddingTop: '24px',
  borderTop: '1px solid #e4e4e7',
};
```

### 5. Email Service Integration

```typescript
// lib/email.ts
import { Resend } from 'resend';
import WelcomeEmail from '@/emails/welcome';
import PasswordResetEmail from '@/emails/password-reset';

const resend = new Resend(process.env.RESEND_API_KEY);

// Type-safe email sending
export const email = {
  async sendWelcome(to: string, userName: string, verifyUrl: string) {
    return resend.emails.send({
      from: 'AppName <noreply@app.com>',
      to,
      subject: 'Welcome to AppName',
      react: WelcomeEmail({ userName, verifyUrl }),
    });
  },

  async sendPasswordReset(
    to: string,
    userName: string,
    resetUrl: string,
    context: { ipAddress: string; location: string }
  ) {
    return resend.emails.send({
      from: 'AppName <noreply@app.com>',
      to,
      subject: 'Reset Your Password',
      react: PasswordResetEmail({
        userName,
        resetUrl,
        expiresIn: '1 hour',
        ...context,
      }),
    });
  },

  async sendOrderConfirmation(to: string, order: Order) {
    // ...
  },
};

// Usage in API routes
await email.sendWelcome(
  user.email,
  user.name,
  `${process.env.APP_URL}/verify?token=${token}`
);
```

### 6. Email Preview Development

```typescript
// Set up email preview server
// package.json
{
  "scripts": {
    "email:dev": "email dev --dir emails --port 3001"
  }
}

// Access at http://localhost:3001 to preview emails
```

## Email Deliverability Checklist

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
- [ ] Tested in major email clients

### Testing
- [ ] Gmail (web, mobile)
- [ ] Outlook (desktop, web)
- [ ] Apple Mail (desktop, iOS)
- [ ] Yahoo Mail
- [ ] Dark mode tested

## Email Template Inventory

```markdown
# Email Template Inventory

## Transactional (Automated)

| Template | Subject Line | Trigger | Status |
|----------|--------------|---------|--------|
| welcome | Welcome to {{appName}} | User signup | Done |
| verify-email | Verify your email | User signup | Done |
| password-reset | Reset your password | Forgot password | Done |
| password-changed | Your password was changed | Password update | Done |
| login-new-device | New login detected | Login from new IP | Pending |

## Notification

| Template | Subject Line | Trigger | Status |
|----------|--------------|---------|--------|
| order-confirmation | Order #{{orderId}} confirmed | Order placed | Done |
| shipping-update | Your order has shipped | Order shipped | Pending |

## Marketing (if applicable)

| Template | Subject Line | Audience | Status |
|----------|--------------|----------|--------|
| feature-announcement | New: {{featureName}} | All users | Pending |
| newsletter | {{appName}} Monthly Update | Subscribers | Pending |
```

## Environment Variables

```bash
# .env.example additions

# ===========================================
# Email
# ===========================================
RESEND_API_KEY=re_xxxxx           # Email service API key
EMAIL_FROM=noreply@app.com        # Default from address
EMAIL_FROM_NAME=AppName           # Display name
APP_URL=https://app.com           # For links in emails

# Optional: Email testing
MAILTRAP_TOKEN=                   # For development/testing
```

## Handoff Protocol

### Handoff to Fullstack Developer

**Package Contents:**
1. Email templates (`/emails/*.tsx`)
2. Email sending utility (`/lib/email.ts`)
3. Email service configuration
4. Template inventory document
5. Test email accounts for QA

**Integration Points:**
```typescript
// Where to call email functions:

// Auth flow
await email.sendWelcome(...)     // After signup
await email.sendVerifyEmail(...) // After signup
await email.sendPasswordReset(...) // Forgot password endpoint
await email.sendPasswordChanged(...) // After password change

// Commerce flow
await email.sendOrderConfirmation(...) // After order placed
await email.sendShippingUpdate(...) // Webhook from shipping provider
```

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| Using @gmail.com as sender | Spam filters block it | Use custom domain |
| No unsubscribe link | Illegal (CAN-SPAM, GDPR) | Always include unsubscribe |
| Giant image emails | Don't load, look like spam | Use HTML with inline styles |
| No plain text version | Accessibility, spam score | Always provide text fallback |
| Sending from "noreply" | Users can't respond | Use "hello@" or "support@" |
| Not testing dark mode | Invisible text on dark | Test all color modes |

## Output Location

```
project-root/
├── emails/                        # Email templates
│   ├── components/               # Shared email components
│   │   ├── Header.tsx
│   │   ├── Footer.tsx
│   │   └── Button.tsx
│   ├── welcome.tsx
│   ├── verify-email.tsx
│   ├── password-reset.tsx
│   ├── password-changed.tsx
│   └── order-confirmation.tsx
├── lib/
│   └── email.ts                  # Email sending utility
└── docs/
    └── emails/
        ├── TEMPLATE-INVENTORY.md # All templates documented
        └── DELIVERABILITY.md     # DNS setup instructions
```

## Integration with Workflow

```
[UI DESIGNER] → Design system (colors, fonts, buttons)
        ↓
[EMAIL DESIGNER] ← Apply design system to emails
        ↓
[FULLSTACK DEVELOPER] → Integrate email sending
        ↓
[QA ENGINEER] → Test email delivery and rendering
```

The Email Designer should be invoked:
1. **After UI Design** - Visual language is established
2. **Before Implementation** - Developer needs templates to integrate
3. **During QA** - Test rendering across email clients
