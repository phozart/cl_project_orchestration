---
name: legal-advisor
description: Generate privacy policies, terms of service, cookie consent, and legal notices. Use when launching any app that collects user data. Covers GDPR, CCPA, and common compliance requirements.
---

# Legal Advisor

Generate the legal documents your application needs. These aren't optional - they're required by law in many jurisdictions and expected by users.

## Why This Exists

Common legal failures:
- "We launched without a privacy policy and got a GDPR complaint"
- "Users asked about data deletion but we have no process"
- "Our cookie banner is just decoration - no actual consent"
- "We copy-pasted Terms from another site and they don't match our app"

## When to Use This Skill

**ALWAYS use before launch:**
- After Requirements are defined (understand what data is collected)
- After Architecture is defined (understand data flows)
- Before deployment to production
- When user says "privacy policy", "terms of service", "GDPR", "cookie consent"

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Document templates | Final |
| Compliance checklist | Final |
| Legal language | Advisory (lawyer review recommended) |
| Cookie categories | Final |
| Data inventory | Shared with Architect |

**DISCLAIMER**: This skill generates templates and guidance. For high-risk applications (healthcare, finance, children's data), consult a qualified attorney.

## Core Responsibilities

### 1. Privacy Policy

Every app collecting user data needs a privacy policy. Generate based on actual data practices:

```markdown
# Privacy Policy

**Last Updated:** {{date}}

## Introduction

{{companyName}} ("we", "our", "us") operates {{appName}} (the "Service").
This Privacy Policy explains how we collect, use, disclose, and protect your information.

## Information We Collect

### Information You Provide
{{#each providedData}}
- **{{name}}**: {{purpose}}
{{/each}}

Examples:
- **Account Information**: Email, password, name - to create and manage your account
- **Profile Information**: Avatar, bio - to personalize your experience
- **Payment Information**: Card details (processed by Stripe) - to process payments

### Information Collected Automatically
{{#each automaticData}}
- **{{name}}**: {{purpose}}
{{/each}}

Examples:
- **Usage Data**: Pages visited, features used - to improve the Service
- **Device Information**: Browser type, OS, device ID - for security and compatibility
- **Log Data**: IP address, access times - for security and debugging

### Cookies and Tracking
We use cookies for:
- **Essential**: Required for the Service to function
- **Analytics**: Understanding usage patterns (e.g., Google Analytics)
- **Preferences**: Remembering your settings

See our Cookie Policy for details.

## How We Use Your Information

We use collected information to:
{{#each purposes}}
- {{this}}
{{/each}}

Examples:
- Provide and maintain the Service
- Process transactions
- Send service-related communications
- Improve and personalize your experience
- Detect and prevent fraud

## Information Sharing

We do NOT sell your personal information. We share data only:

- **Service Providers**: Third parties that help operate our Service
  {{#each providers}}
  - {{name}}: {{purpose}} ({{privacyUrl}})
  {{/each}}
- **Legal Requirements**: When required by law or to protect rights
- **Business Transfers**: In connection with merger or acquisition

## Data Retention

We retain your data for:
- **Account Data**: Until you delete your account
- **Transaction Records**: {{transactionRetention}} (legal requirement)
- **Log Data**: {{logRetention}}

## Your Rights

{{#if gdprApplies}}
### For EU/UK Users (GDPR)
You have the right to:
- Access your personal data
- Correct inaccurate data
- Delete your data ("right to be forgotten")
- Export your data (portability)
- Object to processing
- Withdraw consent

To exercise these rights, contact us at {{privacyEmail}}.
{{/if}}

{{#if ccpaApplies}}
### For California Users (CCPA)
You have the right to:
- Know what personal information we collect
- Delete your personal information
- Opt-out of sale (we do not sell data)
- Non-discrimination for exercising rights

To exercise these rights, contact us at {{privacyEmail}}.
{{/if}}

## Data Security

We implement appropriate security measures including:
- Encryption in transit (TLS/HTTPS)
- Encryption at rest for sensitive data
- Access controls and authentication
- Regular security assessments

## Children's Privacy

{{#if childrenAllowed}}
Our Service is available to users aged {{minimumAge}} and older.
We do not knowingly collect data from children under {{minimumAge}}.
{{else}}
Our Service is not intended for children under 13.
We do not knowingly collect data from children.
{{/if}}

## International Transfers

{{#if internationalTransfers}}
Your data may be transferred to and processed in countries outside your residence.
We ensure appropriate safeguards are in place.
{{/if}}

## Changes to This Policy

We may update this Privacy Policy. We will notify you of material changes via:
- Email to your registered address
- Prominent notice on the Service

## Contact Us

For privacy inquiries:
- Email: {{privacyEmail}}
- Address: {{companyAddress}}
{{#if dpoEmail}}
- Data Protection Officer: {{dpoEmail}}
{{/if}}
```

### 2. Terms of Service

```markdown
# Terms of Service

**Last Updated:** {{date}}

## Agreement to Terms

By accessing or using {{appName}} ("Service"), you agree to these Terms of Service.
If you disagree, do not use the Service.

## Use of Service

### Eligibility
You must be at least {{minimumAge}} years old to use this Service.

### Account Responsibilities
- You are responsible for maintaining account security
- You must provide accurate information
- You must not share your account credentials
- You are responsible for all activity under your account

### Acceptable Use
You agree NOT to:
- Violate any laws or regulations
- Infringe on intellectual property rights
- Transmit malware or harmful code
- Attempt to gain unauthorized access
- Interfere with the Service's operation
- Harass, abuse, or harm others
- Use the Service for illegal activities
{{#each additionalProhibitions}}
- {{this}}
{{/each}}

## User Content

### Your Content
You retain ownership of content you submit. By submitting content, you grant us
a license to use, display, and distribute it as necessary to provide the Service.

### Content Restrictions
You must not submit content that:
- Is illegal, harmful, or offensive
- Infringes intellectual property rights
- Contains malware or harmful code
- Violates privacy rights

### Content Removal
We may remove content that violates these Terms without notice.

## Intellectual Property

The Service, including its design, features, and content (excluding user content),
is owned by {{companyName}} and protected by intellectual property laws.

## Payment Terms

{{#if hasPaidFeatures}}
### Pricing
- Prices are listed in {{currency}}
- We may change prices with {{priceChangeNotice}} notice

### Billing
- Subscriptions are billed {{billingCycle}}
- You authorize us to charge your payment method

### Refunds
{{refundPolicy}}

### Cancellation
You may cancel your subscription at any time. Access continues until the end
of the current billing period.
{{/if}}

## Disclaimers

THE SERVICE IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND.
WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING:
- MERCHANTABILITY
- FITNESS FOR A PARTICULAR PURPOSE
- NON-INFRINGEMENT

## Limitation of Liability

TO THE MAXIMUM EXTENT PERMITTED BY LAW:
- WE ARE NOT LIABLE FOR INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
- OUR TOTAL LIABILITY IS LIMITED TO THE AMOUNT YOU PAID US IN THE PAST 12 MONTHS

## Indemnification

You agree to indemnify and hold harmless {{companyName}} from claims arising from:
- Your use of the Service
- Your content
- Your violation of these Terms

## Termination

We may terminate or suspend your access immediately, without notice, for:
- Violation of these Terms
- Conduct harmful to other users or the Service
- At our sole discretion

Upon termination, your right to use the Service ceases immediately.

## Governing Law

These Terms are governed by the laws of {{jurisdiction}}, without regard to
conflict of law provisions.

## Dispute Resolution

{{#if arbitration}}
### Arbitration
Disputes will be resolved through binding arbitration, not courts.
You waive your right to a jury trial and class action participation.
{{else}}
### Courts
Disputes will be resolved in the courts of {{jurisdiction}}.
{{/if}}

## Changes to Terms

We may modify these Terms at any time. Continued use after changes constitutes
acceptance. Material changes will be notified via email or Service notice.

## Severability

If any provision is found unenforceable, the remaining provisions continue in effect.

## Contact

Questions about these Terms:
- Email: {{legalEmail}}
- Address: {{companyAddress}}
```

### 3. Cookie Policy & Consent

```markdown
# Cookie Policy

**Last Updated:** {{date}}

## What Are Cookies

Cookies are small text files stored on your device when you visit websites.
They help websites remember your preferences and understand usage patterns.

## How We Use Cookies

### Essential Cookies (Required)
These cookies are necessary for the Service to function. You cannot opt out.

| Cookie | Purpose | Duration |
|--------|---------|----------|
| session_id | Maintains your login session | Session |
| csrf_token | Security protection | Session |
| cookie_consent | Remembers your cookie preferences | 1 year |

### Analytics Cookies (Optional)
Help us understand how visitors use the Service.

| Cookie | Purpose | Duration | Provider |
|--------|---------|----------|----------|
| _ga | Google Analytics tracking | 2 years | Google |
| _gid | Distinguishes users | 24 hours | Google |

### Preference Cookies (Optional)
Remember your settings and preferences.

| Cookie | Purpose | Duration |
|--------|---------|----------|
| theme | Dark/light mode preference | 1 year |
| language | Language preference | 1 year |

### Marketing Cookies (Optional)
Used for advertising and tracking across sites.

| Cookie | Purpose | Duration | Provider |
|--------|---------|----------|----------|
| _fbp | Facebook pixel | 3 months | Facebook |

## Managing Cookies

### Through Our Service
Use our cookie preferences center to control optional cookies.
[Manage Cookie Preferences]

### Through Your Browser
You can also control cookies in your browser settings:
- Chrome: Settings > Privacy and Security > Cookies
- Firefox: Options > Privacy & Security > Cookies
- Safari: Preferences > Privacy > Cookies

Note: Blocking essential cookies may prevent the Service from functioning.

## Third-Party Cookies

Some cookies are set by third-party services we use:
{{#each thirdPartyServices}}
- **{{name}}**: {{purpose}} - [Privacy Policy]({{privacyUrl}})
{{/each}}

## Updates

We may update this Cookie Policy. Check the "Last Updated" date above.

## Contact

Cookie questions: {{privacyEmail}}
```

### 4. Cookie Consent Implementation

```typescript
// components/CookieConsent.tsx
'use client';

import { useState, useEffect } from 'react';

type CookiePreferences = {
  essential: true; // Always true
  analytics: boolean;
  preferences: boolean;
  marketing: boolean;
};

const DEFAULT_PREFERENCES: CookiePreferences = {
  essential: true,
  analytics: false,
  preferences: false,
  marketing: false,
};

export function CookieConsent() {
  const [showBanner, setShowBanner] = useState(false);
  const [showSettings, setShowSettings] = useState(false);
  const [preferences, setPreferences] = useState<CookiePreferences>(DEFAULT_PREFERENCES);

  useEffect(() => {
    const consent = localStorage.getItem('cookie_consent');
    if (!consent) {
      setShowBanner(true);
    }
  }, []);

  const savePreferences = (prefs: CookiePreferences) => {
    localStorage.setItem('cookie_consent', JSON.stringify({
      ...prefs,
      timestamp: new Date().toISOString(),
    }));

    // Apply preferences
    if (prefs.analytics) {
      // Initialize analytics
      initializeAnalytics();
    }

    if (prefs.marketing) {
      // Initialize marketing pixels
      initializeMarketing();
    }

    setShowBanner(false);
    setShowSettings(false);
  };

  const acceptAll = () => {
    savePreferences({
      essential: true,
      analytics: true,
      preferences: true,
      marketing: true,
    });
  };

  const acceptEssential = () => {
    savePreferences(DEFAULT_PREFERENCES);
  };

  if (!showBanner) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t shadow-lg p-4 z-50">
      <div className="max-w-4xl mx-auto">
        {!showSettings ? (
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-sm text-gray-600">
              We use cookies to improve your experience. By using our site, you agree to our{' '}
              <a href="/cookies" className="text-blue-600 underline">Cookie Policy</a>.
            </p>
            <div className="flex gap-2">
              <button onClick={() => setShowSettings(true)} className="btn-secondary">
                Customize
              </button>
              <button onClick={acceptEssential} className="btn-secondary">
                Essential Only
              </button>
              <button onClick={acceptAll} className="btn-primary">
                Accept All
              </button>
            </div>
          </div>
        ) : (
          <CookieSettings
            preferences={preferences}
            onChange={setPreferences}
            onSave={() => savePreferences(preferences)}
            onCancel={() => setShowSettings(false)}
          />
        )}
      </div>
    </div>
  );
}
```

### 5. Data Subject Request Handling

```typescript
// lib/gdpr.ts

interface DataSubjectRequest {
  type: 'access' | 'deletion' | 'export' | 'rectification';
  userId: string;
  requestedAt: Date;
  completedAt?: Date;
  status: 'pending' | 'processing' | 'completed' | 'rejected';
}

export async function handleDataAccessRequest(userId: string) {
  // Gather all user data
  const userData = await gatherUserData(userId);

  return {
    profile: userData.profile,
    content: userData.content,
    activity: userData.activityLog,
    preferences: userData.preferences,
    exportedAt: new Date().toISOString(),
  };
}

export async function handleDataDeletionRequest(userId: string) {
  // 1. Verify identity (important!)
  // 2. Check for legal holds or retention requirements
  // 3. Delete or anonymize data

  await db.$transaction([
    // Delete personal data
    db.user.update({
      where: { id: userId },
      data: {
        email: `deleted-${userId}@deleted.local`,
        name: 'Deleted User',
        avatar: null,
        deletedAt: new Date(),
      },
    }),

    // Anonymize content (keep for integrity, remove PII)
    db.post.updateMany({
      where: { authorId: userId },
      data: { authorId: null }, // or keep with anonymized author
    }),

    // Delete sessions
    db.session.deleteMany({ where: { userId } }),

    // Log the deletion
    db.auditLog.create({
      data: {
        action: 'user.deleted',
        targetId: userId,
        details: { reason: 'GDPR deletion request' },
      },
    }),
  ]);

  return { success: true, deletedAt: new Date() };
}

export async function handleDataExportRequest(userId: string) {
  const data = await handleDataAccessRequest(userId);

  // Format as machine-readable (JSON, CSV)
  return {
    format: 'json',
    data,
    exportedAt: new Date().toISOString(),
    // Provide download link valid for 7 days
  };
}
```

## Legal Checklist by Region

### GDPR (EU/UK)
- [ ] Privacy Policy with required disclosures
- [ ] Cookie consent banner (not just notice)
- [ ] Data Subject Access Request process
- [ ] Right to deletion ("right to be forgotten")
- [ ] Data export/portability
- [ ] Data Processing Agreement with vendors
- [ ] Records of processing activities
- [ ] Data breach notification process (72 hours)
- [ ] DPO appointed (if required)

### CCPA (California)
- [ ] "Do Not Sell My Personal Information" link
- [ ] Privacy Policy with CCPA disclosures
- [ ] Data access request process
- [ ] Data deletion request process
- [ ] Non-discrimination clause

### General (All Regions)
- [ ] Terms of Service
- [ ] Privacy Policy accessible from all pages
- [ ] Cookie Policy (if using cookies)
- [ ] Age verification (if required)
- [ ] Clear unsubscribe mechanism

## Environment Variables

```bash
# .env.example additions

# ===========================================
# Legal/Compliance
# ===========================================
COMPANY_NAME="Your Company, Inc."
COMPANY_ADDRESS="123 Main St, City, State, ZIP"
PRIVACY_EMAIL=privacy@company.com
LEGAL_EMAIL=legal@company.com
MINIMUM_AGE=13
JURISDICTION="State of Delaware, USA"
```

## Handoff Protocol

### Handoff to Fullstack Developer

**Package Contents:**
1. Privacy Policy document
2. Terms of Service document
3. Cookie Policy document
4. Cookie consent component
5. Data request handlers
6. Legal page routes

**Implementation Notes:**
```typescript
// Required routes
/privacy          // Privacy Policy
/terms            // Terms of Service
/cookies          // Cookie Policy
/legal/data-request  // GDPR/CCPA request form

// Required components
<CookieConsent />  // Add to root layout
<Footer />         // Include legal links
```

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| Cookie wall | "Accept or leave" is not valid consent | Offer granular choices |
| Pre-checked boxes | Not valid consent under GDPR | Default to opt-out |
| Buried privacy policy | Users can't find it | Link from every page footer |
| Copy-paste from other sites | Doesn't match your practices | Generate from actual data use |
| No actual consent mechanism | Banner is just for show | Actually honor preferences |
| No deletion process | GDPR violation | Implement data subject requests |

## Output Location

```
project-root/
├── app/
│   ├── privacy/
│   │   └── page.tsx            # Privacy Policy page
│   ├── terms/
│   │   └── page.tsx            # Terms of Service page
│   ├── cookies/
│   │   └── page.tsx            # Cookie Policy page
│   └── legal/
│       └── data-request/
│           └── page.tsx        # Data request form
├── components/
│   └── CookieConsent.tsx       # Cookie consent banner
├── lib/
│   └── gdpr.ts                 # Data request handlers
└── docs/
    └── legal/
        ├── PRIVACY-POLICY.md   # Source document
        ├── TERMS-OF-SERVICE.md # Source document
        ├── COOKIE-POLICY.md    # Source document
        └── COMPLIANCE-CHECKLIST.md
```

## Integration with Workflow

```
[BUSINESS ANALYST] → What data do we collect?
        ↓
[SOLUTION ARCHITECT] → How does data flow?
        ↓
[LEGAL ADVISOR] ← Generate legal documents
        ↓
[FULLSTACK DEVELOPER] → Implement consent, data requests
        ↓
[QA ENGINEER] → Verify consent works, links correct
```

The Legal Advisor should be invoked:
1. **After Requirements** - Understand data collection
2. **After Architecture** - Understand data flows and third parties
3. **Before Deployment** - Must have legal docs before launch
