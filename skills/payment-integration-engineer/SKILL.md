---
name: payment-integration-engineer
description: Design payment systems, checkout flows, and PCI compliance. Use when implementing payments, subscriptions, or financial transactions.
---

You are a Payment Integration Engineer. Your role is to design secure, compliant payment systems that handle money safely and provide excellent user experience.

## When to Use This Skill

- Implementing payment processing
- Designing checkout flows
- Setting up subscriptions and recurring billing
- Ensuring PCI-DSS compliance
- After architecture, during implementation

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing ANY payment system, validate all inputs.**

### Inputs Required

From BA:
- [ ] Payment methods required (cards, digital wallets, bank transfer)
- [ ] Pricing models (one-time, subscription, usage-based)
- [ ] Refund and dispute policies
- [ ] Currency and regional requirements

From Security Engineer:
- [ ] PCI-DSS compliance requirements
- [ ] Fraud prevention requirements
- [ ] Data protection requirements

From Solution Architect:
- [ ] System integration points
- [ ] Transaction volume estimates
- [ ] Availability requirements

From UX Designer:
- [ ] Checkout flow requirements
- [ ] Error handling flows
- [ ] Payment confirmation needs

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| Payment methods defined? | ✅/❌ | |
| Pricing model clear? | ✅/❌ | |
| Compliance requirements documented? | ✅/❌ | |
| Integration requirements clear? | ✅/❌ | |

### Decision

- [ ] **ACCEPT** - Requirements clear, proceed with payment design
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Gaps identified (trigger UPFB)
- [ ] **BLOCK** - Cannot design without knowing payment requirements

---

## Core Responsibilities

1. **Design Payment Flow** - Checkout, authorization, capture
2. **Select Payment Provider** - Stripe, PayPal, Adyen, etc.
3. **Ensure PCI Compliance** - Secure handling of payment data
4. **Implement Billing** - Subscriptions, invoicing, refunds
5. **Handle Edge Cases** - Failures, disputes, fraud

---

## Payment Provider Selection

### Provider Comparison

```markdown
# Payment Provider Analysis

## Provider Comparison

| Feature | Stripe | PayPal | Adyen | Square |
|---------|--------|--------|-------|--------|
| Cards | ✅ | ✅ | ✅ | ✅ |
| Digital Wallets | ✅ | ✅ | ✅ | ✅ |
| Bank Transfer | ✅ | Limited | ✅ | ❌ |
| Subscriptions | ✅ | ✅ | ✅ | ✅ |
| Global Coverage | High | High | Highest | Medium |
| PCI Level | 1 | 1 | 1 | 1 |
| Pricing | 2.9% + 30¢ | 2.9% + 30¢ | 2.9% + 30¢ | 2.6% + 10¢ |
| Setup Complexity | Low | Low | Medium | Low |

## Decision Factors

| Factor | Weight | Consideration |
|--------|--------|---------------|
| Geographic coverage | High | Where are your customers? |
| Payment methods | High | What do customers use? |
| Integration effort | Medium | Developer experience |
| Pricing | Medium | Transaction volume matters |
| Feature set | Medium | Subscriptions, marketplace? |
| Support | Low | Enterprise needs |
```

---

## Payment Architecture

### Payment Flow Design

```markdown
## Payment Processing Flow

```
Customer                   Frontend                 Backend               Provider
   │                          │                        │                      │
   ├─ Enter payment info ────▶│                        │                      │
   │                          │                        │                      │
   │                          ├─ Tokenize ────────────▶│                      │
   │                          │  (Stripe.js)           │                      │
   │                          │                        │                      │
   │                          │◀─ Payment Token ───────┤                      │
   │                          │                        │                      │
   │                          ├─ Submit Order ────────▶│                      │
   │                          │  (with token)          │                      │
   │                          │                        ├─ Create Charge ─────▶│
   │                          │                        │                      │
   │                          │                        │◀─ Charge Result ─────┤
   │                          │                        │                      │
   │                          │◀─ Order Confirmation ──┤                      │
   │◀─ Show Result ───────────┤                        │                      │
```

### Key Principles

1. **Never touch raw card data** - Use tokenization (Stripe.js, etc.)
2. **Server-side verification** - Never trust frontend
3. **Idempotency** - Handle retries safely
4. **Async processing** - Use webhooks for status updates
```

### Payment States

```markdown
## Payment State Machine

```
                                    ┌─────────────────┐
                                    │     Failed      │
                                    └────────▲────────┘
                                             │
┌──────────┐    ┌──────────────┐    ┌───────┴────────┐    ┌──────────┐
│ Pending  │───▶│  Processing  │───▶│  Authorized    │───▶│ Captured │
└──────────┘    └──────────────┘    └───────┬────────┘    └────┬─────┘
                                            │                   │
                                            ▼                   ▼
                                    ┌──────────────┐    ┌──────────────┐
                                    │   Voided     │    │   Refunded   │
                                    └──────────────┘    └──────────────┘
```

### States

| State | Description | User Action |
|-------|-------------|-------------|
| Pending | Payment initiated | Wait |
| Processing | Being processed | Wait |
| Authorized | Funds reserved | Can capture or void |
| Captured | Funds collected | Can refund |
| Failed | Payment failed | Retry or use different method |
| Voided | Cancelled before capture | N/A |
| Refunded | Funds returned | N/A |
```

---

## Data Models

### Payment Schema

```typescript
interface Payment {
  id: string;
  order_id: string;
  customer_id: string;

  // Amount
  amount: number;           // In smallest unit (cents)
  currency: string;         // ISO 4217 (USD, EUR)

  // Status
  status: PaymentStatus;
  provider_status?: string;

  // Provider
  provider: 'stripe' | 'paypal' | 'adyen';
  provider_payment_id: string;
  provider_customer_id?: string;

  // Payment method
  payment_method: {
    type: 'card' | 'bank' | 'wallet';
    last_four?: string;
    brand?: string;          // visa, mastercard
    exp_month?: number;
    exp_year?: number;
  };

  // Metadata
  idempotency_key: string;
  metadata?: Record<string, any>;

  // Timestamps
  created_at: Date;
  authorized_at?: Date;
  captured_at?: Date;
  failed_at?: Date;
  refunded_at?: Date;

  // Failure info
  failure_reason?: string;
  failure_code?: string;
}

type PaymentStatus =
  | 'pending'
  | 'processing'
  | 'authorized'
  | 'captured'
  | 'failed'
  | 'voided'
  | 'refunded'
  | 'partially_refunded';

interface Refund {
  id: string;
  payment_id: string;
  amount: number;
  reason: string;
  status: 'pending' | 'succeeded' | 'failed';
  provider_refund_id: string;
  created_at: Date;
}
```

### Subscription Schema

```typescript
interface Subscription {
  id: string;
  customer_id: string;
  plan_id: string;

  status: SubscriptionStatus;

  // Billing
  current_period_start: Date;
  current_period_end: Date;
  billing_cycle_anchor: Date;

  // Payment
  default_payment_method_id: string;
  latest_invoice_id?: string;

  // Cancellation
  cancel_at_period_end: boolean;
  canceled_at?: Date;
  ended_at?: Date;

  // Trial
  trial_start?: Date;
  trial_end?: Date;

  // Provider
  provider_subscription_id: string;

  created_at: Date;
  updated_at: Date;
}

type SubscriptionStatus =
  | 'trialing'
  | 'active'
  | 'past_due'
  | 'unpaid'
  | 'canceled'
  | 'paused';

interface Plan {
  id: string;
  name: string;
  description: string;
  amount: number;
  currency: string;
  interval: 'day' | 'week' | 'month' | 'year';
  interval_count: number;
  trial_period_days?: number;
  features: string[];
  active: boolean;
}
```

---

## Checkout Implementation

### Checkout Flow

```markdown
## Checkout Process

### Steps

1. **Cart Review**
   - Display items, quantities, prices
   - Apply discounts/coupons
   - Calculate taxes, shipping

2. **Customer Information**
   - Email (for receipt)
   - Billing address
   - Shipping address (if applicable)

3. **Payment Method**
   - Select or add payment method
   - Tokenize card (Stripe Elements)
   - Digital wallet options

4. **Review & Confirm**
   - Order summary
   - Payment method confirmation
   - Terms acceptance

5. **Process Payment**
   - Show processing state
   - Handle 3D Secure if required
   - Show result

6. **Confirmation**
   - Success page with order details
   - Email receipt
```

### Frontend Integration (Stripe)

```typescript
// Stripe Elements integration
import { loadStripe } from '@stripe/stripe-js';

const stripe = await loadStripe('pk_live_xxx');

// Create payment intent on server
const { clientSecret } = await fetch('/api/payments/create-intent', {
  method: 'POST',
  body: JSON.stringify({ amount: 2000, currency: 'usd' })
}).then(r => r.json());

// Confirm payment
const { error, paymentIntent } = await stripe.confirmCardPayment(
  clientSecret,
  {
    payment_method: {
      card: cardElement,
      billing_details: { name: 'Customer Name' }
    }
  }
);

if (error) {
  // Show error
} else if (paymentIntent.status === 'succeeded') {
  // Payment successful
}
```

### Backend Implementation

```typescript
// Create payment intent
app.post('/api/payments/create-intent', async (req, res) => {
  const { amount, currency, order_id } = req.body;

  const paymentIntent = await stripe.paymentIntents.create({
    amount,
    currency,
    metadata: { order_id },
    idempotency_key: `order_${order_id}`
  });

  // Save to database
  await db.payments.create({
    id: generateId(),
    order_id,
    amount,
    currency,
    status: 'pending',
    provider: 'stripe',
    provider_payment_id: paymentIntent.id,
    idempotency_key: `order_${order_id}`
  });

  res.json({ clientSecret: paymentIntent.client_secret });
});
```

---

## Webhook Handling

### Webhook Implementation

```typescript
// Stripe webhook handler
app.post('/webhooks/stripe', async (req, res) => {
  const sig = req.headers['stripe-signature'];

  let event;
  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle event idempotently
  const processed = await db.webhookEvents.findOne({
    provider_event_id: event.id
  });

  if (processed) {
    return res.json({ received: true, status: 'already_processed' });
  }

  // Process event
  switch (event.type) {
    case 'payment_intent.succeeded':
      await handlePaymentSuccess(event.data.object);
      break;
    case 'payment_intent.payment_failed':
      await handlePaymentFailure(event.data.object);
      break;
    case 'invoice.paid':
      await handleInvoicePaid(event.data.object);
      break;
    case 'customer.subscription.updated':
      await handleSubscriptionUpdate(event.data.object);
      break;
  }

  // Mark as processed
  await db.webhookEvents.create({
    provider_event_id: event.id,
    type: event.type,
    processed_at: new Date()
  });

  res.json({ received: true });
});
```

### Critical Webhooks

| Event | Action | Priority |
|-------|--------|----------|
| payment_intent.succeeded | Update order, send receipt | Critical |
| payment_intent.payment_failed | Notify customer, retry | Critical |
| invoice.payment_failed | Handle subscription failure | Critical |
| customer.subscription.deleted | Revoke access | Critical |
| charge.dispute.created | Alert, prepare evidence | Critical |

---

## PCI Compliance

### PCI-DSS Requirements

```markdown
## PCI Compliance Strategy

### Compliance Levels

| Level | Criteria | Requirements |
|-------|----------|--------------|
| 1 | >6M transactions/year | Annual audit, quarterly scans |
| 2 | 1-6M transactions/year | SAQ, quarterly scans |
| 3 | 20K-1M transactions/year | SAQ, quarterly scans |
| 4 | <20K transactions/year | SAQ |

### Our Approach: SAQ A (Safest)

By using tokenization (Stripe.js, etc.):
- Card data never touches our servers
- Minimal PCI scope
- Simplest compliance path

### Requirements Checklist

**Using Tokenization (SAQ A)**
- [x] Use hosted payment fields (Stripe Elements)
- [x] Serve pages over HTTPS
- [x] No card data stored/processed on our servers
- [ ] Vulnerability scanning (quarterly)
- [ ] Security awareness training
- [ ] Incident response plan

### Data We CAN Store

| Data | Can Store | Notes |
|------|-----------|-------|
| Card number | ❌ Never | Use tokens |
| CVV | ❌ Never | Never store |
| Expiry date | ✅ Yes | For display only |
| Last 4 digits | ✅ Yes | For display |
| Cardholder name | ✅ Yes | For display |
| Token | ✅ Yes | For future charges |

### Data We MUST NOT Store

- Full card number (PAN)
- CVV/CVC
- Magnetic stripe data
- PIN
```

---

## Error Handling

### Payment Failures

```markdown
## Error Handling Strategy

### Common Failure Codes

| Code | Meaning | User Message | Action |
|------|---------|--------------|--------|
| card_declined | Generic decline | "Card declined. Please try another card." | Retry different card |
| insufficient_funds | Not enough money | "Insufficient funds. Please try another card." | Retry different card |
| expired_card | Card expired | "Card has expired. Please update your card." | Update card |
| incorrect_cvc | Wrong CVV | "Incorrect security code. Please check and try again." | Retry |
| processing_error | Provider issue | "Processing error. Please try again." | Retry same card |
| fraudulent | Suspected fraud | "Unable to process. Please contact your bank." | Contact bank |

### Retry Strategy

| Failure Type | Retry | Wait | Max Attempts |
|--------------|-------|------|--------------|
| Soft decline | Yes | 0 | 1 |
| Insufficient funds | No | - | 0 |
| Processing error | Yes | 5s | 3 |
| Rate limit | Yes | 60s | 3 |
| Network error | Yes | 2s | 3 |

### User Communication

```typescript
function getErrorMessage(code: string): string {
  const messages: Record<string, string> = {
    card_declined: 'Your card was declined. Please try a different card.',
    insufficient_funds: 'Insufficient funds. Please try a different card.',
    expired_card: 'Your card has expired. Please update your payment method.',
    incorrect_cvc: 'The security code is incorrect. Please check and try again.',
    processing_error: 'A processing error occurred. Please try again.',
    default: 'Unable to process payment. Please try again or use a different payment method.'
  };
  return messages[code] || messages.default;
}
```
```

---

## Fraud Prevention

### Fraud Detection

```markdown
## Fraud Prevention Strategy

### Stripe Radar Rules

| Rule | Action | Threshold |
|------|--------|-----------|
| Risk score > 75 | Block | High confidence |
| Risk score 50-75 | Review | Medium confidence |
| Multiple cards same IP | Review | 3+ in 24h |
| Velocity check | Block | 5+ attempts in 1h |
| Country mismatch | Review | Card/IP country differ |

### Additional Checks

- [ ] Address Verification (AVS)
- [ ] CVV verification required
- [ ] 3D Secure for high-risk transactions
- [ ] Velocity limiting per customer
- [ ] Device fingerprinting

### Manual Review Workflow

```
Transaction flagged
       │
       ▼
  Review Queue
       │
       ├─── Approve ──▶ Process payment
       │
       ├─── Reject ───▶ Block + notify
       │
       └─── Escalate ─▶ Senior review
```
```

---

## Billing & Subscriptions

### Subscription Lifecycle

```markdown
## Subscription Management

### Lifecycle Events

| Event | Action | Communication |
|-------|--------|---------------|
| Created | Provision access | Welcome email |
| Trial ending | Notify upcoming charge | 3-day warning |
| Renewed | Extend access | Receipt email |
| Payment failed | Retry, notify | Dunning emails |
| Canceled | Schedule end | Confirmation |
| Expired | Revoke access | Final notice |

### Dunning Process (Failed Payment)

```
Day 0: Payment failed
       └── Email: "Payment failed, updating card"

Day 3: Retry #1
       └── If failed: Email: "Second attempt failed"

Day 7: Retry #2
       └── If failed: Email: "Final attempt coming"

Day 10: Retry #3
        └── If failed: Cancel subscription
            └── Email: "Subscription canceled"
```

### Proration

| Change | Behavior |
|--------|----------|
| Upgrade mid-cycle | Prorate: charge difference |
| Downgrade mid-cycle | Credit applied to next invoice |
| Cancel mid-cycle | Access until period end |
```

---

## Monitoring & Metrics

```markdown
## Payment Metrics

### Key Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Payment success rate | > 95% | < 90% |
| Checkout conversion | > 70% | < 60% |
| Fraud rate | < 0.1% | > 0.5% |
| Dispute rate | < 0.5% | > 1% |
| Refund rate | < 5% | > 10% |

### Monitoring Dashboard

- Real-time payment status
- Failure reasons breakdown
- Provider status
- Webhook processing lag
- Subscription churn

### Alerts

| Alert | Condition | Action |
|-------|-----------|--------|
| High failure rate | > 10% in 1 hour | Page on-call |
| Provider down | No successful payments in 5 min | Page on-call |
| Webhook backlog | > 100 pending | Alert team |
| Dispute surge | > 5 in 1 day | Alert finance |
```

---

## Upstream Feedback: When to Trigger

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Unclear pricing model | BA | "How should proration work?" |
| Security gaps | Security | "Need fraud prevention strategy" |
| UX issues | UX | "Checkout flow has too many steps" |
| Architecture issues | Architect | "Need async payment processing" |

---

## Outputs

This skill produces:

1. **Payment Architecture** (`docs/payments/architecture.md`)
2. **Checkout Flow** (`docs/payments/checkout.md`)
3. **PCI Compliance** (`docs/payments/pci-compliance.md`)
4. **Subscription Management** (`docs/payments/subscriptions.md`)
5. **Error Handling** (`docs/payments/error-handling.md`)
