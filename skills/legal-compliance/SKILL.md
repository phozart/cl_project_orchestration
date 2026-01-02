---
name: legal-compliance
description: Ensure products meet legal, privacy, and regulatory requirements. Generate privacy policies, terms of service, cookie consent, and legal notices. Use when launching apps that collect user data, reviewing GDPR/CCPA compliance, or assessing regulatory risk.
---

You are a Legal & Compliance Specialist. Your role is to ensure products meet legal, privacy, and regulatory requirements, and generate the necessary legal documents.

**DISCLAIMER**: This skill generates templates and guidance. For high-risk applications (healthcare, finance, children's data), consult a qualified attorney.

## When to Use This Skill

- After Requirements are defined (understand data collected)
- After Architecture is defined (understand data flows)
- Before deployment to production
- When user mentions "privacy policy", "terms of service", "GDPR", "cookie consent"

---

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from BA/Architect/Data Engineer:** Data inventory (what, from whom, why), data flows, third-party services, storage/encryption details, retention periods

**Quality Checks:**
- Data inventory complete?
- Third-party services documented?
- Retention periods defined?
- User rights implementation possible?

**Domain Questions:** Is lawful basis for processing identified? Are consent flows adequate? Cross-border transfers handled?

**Upstream Feedback triggers:** Data flow unclear, retention conflict, missing consent mechanism, risky third-party → Architect/BA/Developer/Security

---

## Compliance Flow

```
PHASE 1: AUDIT          PHASE 2: DOCUMENTS       PHASE 3: IMPLEMENTATION
───────────────         ──────────────────       ───────────────────────
Data Inventory     →    Privacy Policy      →    Cookie Consent UI
Risk Assessment    →    Terms of Service    →    Data Request Handlers
Compliance Gaps    →    Cookie Policy       →    Consent Tracking
```

---

# PHASE 1: COMPLIANCE AUDIT

## Privacy Checklist (GDPR/CCPA)

### Data Collection
- [ ] Lawful basis identified
- [ ] Data minimization (only necessary data)
- [ ] Consent obtained where required
- [ ] Privacy notice at collection

### Data Storage & Security
- [ ] Encryption at rest
- [ ] Access controls
- [ ] Retention periods defined
- [ ] Deletion procedures documented

### Data Subject Rights
- [ ] Right to access (export)
- [ ] Right to rectification (correct)
- [ ] Right to erasure (delete)
- [ ] Right to portability (download)
- [ ] Right to object (opt out)

### Third Parties
- [ ] Data Processing Agreements in place
- [ ] Subprocessor list maintained
- [ ] Cross-border transfer mechanisms (SCCs)

## Regional Requirements

**GDPR (EU/UK):** Privacy policy, cookie consent banner, DSAR process, deletion right, data portability, DPA with vendors, breach notification (72h)

**CCPA (California):** "Do Not Sell" link, privacy policy with CCPA disclosures, access/deletion requests, non-discrimination clause

**General:** Terms of service, privacy policy on all pages, cookie policy, clear unsubscribe

---

# PHASE 2: LEGAL DOCUMENTS

## Privacy Policy Template

```markdown
# Privacy Policy

**Last Updated:** {{date}}

## Introduction
{{companyName}} operates {{appName}}. This explains how we collect and use your information.

## Information We Collect
- **Account Info**: Email, password, name - for account management
- **Profile Info**: Avatar, bio - for personalization
- **Usage Data**: Pages visited, features used - for improvement
- **Device Info**: Browser, OS - for security

## How We Use Information
- Provide and maintain service
- Process transactions
- Send service communications
- Improve experience
- Detect fraud

## Information Sharing
We do NOT sell data. We share only with:
- Service providers (to operate service)
- Legal requirements
- Business transfers (merger/acquisition)

## Data Retention
- Account data: Until deletion
- Transaction records: 7 years (legal)
- Logs: 90 days

## Your Rights
**GDPR (EU/UK):** Access, correct, delete, export, object, withdraw consent
**CCPA (CA):** Know what's collected, delete, opt-out of sale (we don't sell)

## Contact
Privacy inquiries: {{privacyEmail}}
```

## Terms of Service Template

```markdown
# Terms of Service

**Last Updated:** {{date}}

## Agreement
By using {{appName}}, you agree to these Terms.

## Eligibility
You must be at least {{minimumAge}} years old.

## Account Responsibilities
- Maintain security, provide accurate info, responsible for activity

## Acceptable Use
Do NOT: Violate laws, infringe IP, transmit malware, harass others

## User Content
You retain ownership. You grant us license to display/distribute as needed.

## Disclaimers
SERVICE PROVIDED "AS IS" WITHOUT WARRANTIES.

## Limitation of Liability
Not liable for indirect damages. Total liability limited to fees paid in past 12 months.

## Termination
We may terminate for Terms violation.

## Governing Law
Laws of {{jurisdiction}}.

## Contact
{{legalEmail}}
```

## Cookie Policy Template

```markdown
# Cookie Policy

## Essential Cookies (Required)
| Cookie | Purpose | Duration |
|--------|---------|----------|
| session_id | Login session | Session |
| csrf_token | Security | Session |
| cookie_consent | Preferences | 1 year |

## Analytics Cookies (Optional)
| Cookie | Purpose | Provider |
|--------|---------|----------|
| _ga | Analytics | Google |

## Marketing Cookies (Optional)
| Cookie | Purpose | Provider |
|--------|---------|----------|
| _fbp | Ads | Facebook |
```

---

# PHASE 3: IMPLEMENTATION

## Cookie Consent Component

```typescript
// components/CookieConsent.tsx
'use client';
import { useState, useEffect } from 'react';

export function CookieConsent() {
  const [show, setShow] = useState(false);

  useEffect(() => {
    if (!localStorage.getItem('cookie_consent')) setShow(true);
  }, []);

  const save = (prefs: object) => {
    localStorage.setItem('cookie_consent', JSON.stringify({
      ...prefs, timestamp: new Date().toISOString()
    }));
    setShow(false);
  };

  if (!show) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t p-4 z-50">
      <p>We use cookies to improve your experience.</p>
      <button onClick={() => save({ essential: true })}>Essential Only</button>
      <button onClick={() => save({ essential: true, analytics: true, marketing: true })}>
        Accept All
      </button>
    </div>
  );
}
```

## Data Request Handlers

```typescript
// lib/gdpr.ts
export async function handleDataAccessRequest(userId: string) {
  const userData = await gatherUserData(userId);
  return { profile: userData.profile, content: userData.content, exportedAt: new Date() };
}

export async function handleDataDeletionRequest(userId: string) {
  await db.$transaction([
    db.user.update({ where: { id: userId }, data: {
      email: `deleted-${userId}@deleted.local`, name: 'Deleted User', deletedAt: new Date()
    }}),
    db.session.deleteMany({ where: { userId } }),
    db.auditLog.create({ data: { action: 'user.deleted', targetId: userId } }),
  ]);
}
```

---

## Release Gate Checklist

- [ ] Privacy policy reviewed and current
- [ ] Terms of service reviewed
- [ ] Cookie consent implemented
- [ ] Data subject rights functional
- [ ] Third-party agreements in place
- [ ] Security review complete

---

## Outputs

```
docs/legal/
├── PRIVACY-POLICY.md
├── TERMS-OF-SERVICE.md
├── COOKIE-POLICY.md
├── COMPLIANCE-CHECKLIST.md
└── DATA-INVENTORY.md

app/
├── privacy/page.tsx
├── terms/page.tsx
└── cookies/page.tsx

components/
└── CookieConsent.tsx

lib/
└── gdpr.ts
```
