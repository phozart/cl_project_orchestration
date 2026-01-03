# Architecture Decision Record (ADR) Template

## ADR Format

Use this format for every significant technology decision:

```markdown
# ADR-XXX: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Context
[What is the issue that we're seeing that motivates this decision?]
[What forces are at play?]
[What constraints exist?]

## Decision
[What is the change that we're proposing and/or doing?]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Tradeoff 1]
- [Tradeoff 2]

### Risks
- [Risk 1] - Mitigation: [How we address it]
- [Risk 2] - Mitigation: [How we address it]

## Alternatives Considered

### Alternative 1: [Name]
- Pros: [...]
- Cons: [...]
- Why rejected: [...]

### Alternative 2: [Name]
- Pros: [...]
- Cons: [...]
- Why rejected: [...]
```

## ADR Numbering

- Format: `ADR-XXX-short-description.md`
- Examples:
  - `ADR-001-database-choice.md`
  - `ADR-002-auth-strategy.md`
  - `ADR-003-api-framework.md`

## When to Write an ADR

Write an ADR for:

1. **Database choices** - PostgreSQL vs MySQL vs MongoDB
2. **Framework selections** - Next.js vs Remix, FastAPI vs Django
3. **Authentication approach** - JWT vs sessions, OAuth providers
4. **Hosting decisions** - Vercel vs AWS vs self-hosted
5. **Third-party services** - Stripe vs PayPal, SendGrid vs Postmark
6. **Architecture patterns** - Monolith vs microservices, event-driven
7. **API design** - REST vs GraphQL vs gRPC
8. **Caching strategy** - Redis vs in-memory vs CDN

## Example ADRs

### ADR-001: Database Choice

```markdown
# ADR-001: Use PostgreSQL as Primary Database

## Status
Accepted

## Context
We need a relational database for user data, transactions, and complex queries.
Requirements include ACID compliance, JSON support, and horizontal scaling capability.

## Decision
Use PostgreSQL 15+ as the primary database.

## Consequences

### Positive
- ACID compliant for financial transactions
- Excellent JSON/JSONB support for flexible schemas
- Strong ecosystem and tooling
- Free and open source

### Negative
- Requires more setup than SQLite
- Need to manage connection pooling
- Horizontal scaling requires additional tools (Citus, read replicas)

### Risks
- Connection limits under load - Mitigation: Use PgBouncer for connection pooling
- Schema migrations - Mitigation: Use Flyway/Prisma for version-controlled migrations

## Alternatives Considered

### Alternative 1: MongoDB
- Pros: Flexible schema, easy horizontal scaling
- Cons: No ACID transactions (until recently), eventual consistency issues
- Why rejected: Need strong consistency for financial data

### Alternative 2: MySQL
- Pros: Widely used, good performance
- Cons: Less feature-rich than PostgreSQL, weaker JSON support
- Why rejected: PostgreSQL's advanced features better fit our needs
```

### ADR-002: Authentication Strategy

```markdown
# ADR-002: JWT with Refresh Tokens for Authentication

## Status
Accepted

## Context
Need stateless authentication for API that supports mobile apps and web.
Must support token refresh without requiring re-login.

## Decision
Use JWT access tokens (15 min expiry) with refresh tokens (7 day expiry).
Store refresh tokens in HttpOnly cookies for web, secure storage for mobile.

## Consequences

### Positive
- Stateless authentication scales horizontally
- Works across web and mobile
- Can include user claims in token

### Negative
- Cannot immediately invalidate tokens
- Token size larger than session ID
- Must implement refresh token rotation

### Risks
- Token theft - Mitigation: Short expiry, refresh rotation, secure storage
- Replay attacks - Mitigation: Include `jti` claim, maintain blacklist for logout

## Alternatives Considered

### Alternative 1: Session-based auth
- Pros: Easy invalidation, smaller payload
- Cons: Requires session store, harder to scale
- Why rejected: Complexity of distributed session management

### Alternative 2: OAuth2 only (third-party)
- Pros: No password management
- Cons: Dependency on providers, not all users have accounts
- Why rejected: Need to support email/password signup
```

## ADR Review Checklist

Before accepting an ADR:

- [ ] Context clearly explains the problem
- [ ] Decision is specific and actionable
- [ ] Consequences include both positive and negative
- [ ] Risks have mitigations defined
- [ ] At least 2 alternatives were considered
- [ ] Rejection reasons for alternatives are clear
- [ ] No TBD items remain
