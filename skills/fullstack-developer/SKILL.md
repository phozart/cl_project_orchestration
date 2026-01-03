---
name: fullstack-developer
description: Implement features using EXACT names from contracts. No improvisation. Route contract errors back to upstream.
---

# Fullstack Developer

Implement using contracts. Use EXACT names. Route contract errors back.

## Rules

1. READ contracts BEFORE coding. No improvisation.
2. USE exact field names from TYPE-CONTRACTS.ts. No `userId` if contract says `user_id`.
3. USE exact function names from API-CONTRACTS.ts. No `fetchUsers` if contract says `getUsers`.
4. ROUTE contract errors back to data-engineer/api-designer. Don't patch around them.
5. WRITE tests WITH features, not after.
6. SIGN OFF each REQ-XXX in RTM with file:line reference.
7. BLOCK release if any Must-Have not signed off.

## References

| File | Content |
|------|---------|
| `references/code-standards.md` | TypeScript, React, Python patterns |
| `references/code-review.md` | Review checklist |

---

## Input Validation

REQUIRED before coding:
- [ ] System Design document exists
- [ ] `docs/data/TYPE-CONTRACTS.ts` exists (from data-engineer)
- [ ] `docs/api/API-CONTRACTS.ts` exists (from api-designer)
- [ ] UI designs/wireframes available
- [ ] `docker-compose up` works
- [ ] Database accessible

IF any missing → STOP. Get from upstream skill.

---

## CONTRACT USAGE (MANDATORY)

### Before Writing ANY Code

1. READ `docs/data/TYPE-CONTRACTS.ts`
2. READ `docs/api/API-CONTRACTS.ts`
3. COPY contracts to `src/types/` or `src/contracts/`
4. IMPORT and USE these types everywhere

### Correct Usage

```typescript
// ✅ CORRECT - Using contract types
import { User, UserFields } from '@/types/contracts';
import { getUsers, GetUsersRequest } from '@/api/contracts';

const user: User = {
  id: '...',
  email: '...',
  passwordHash: '...',  // Exact name from contract
  createdAt: new Date(),
  updatedAt: new Date()
};

// ✅ CORRECT - Using contract function names
const response = await apiClient.getUsers({ page: 1 });
```

### WRONG Usage

```typescript
// ❌ WRONG - Inventing field names
const user = {
  userId: '...',        // Contract says 'id'
  userEmail: '...',     // Contract says 'email'
  password_hash: '...'  // Contract says 'passwordHash'
};

// ❌ WRONG - Inventing function names
await api.fetchUsers();     // Contract says 'getUsers'
await api.getAllUsers();    // Contract says 'getUsers'
await api.listUsers();      // Contract says 'getUsers'
```

---

## Contract Error Protocol

IF contract doesn't match reality:

| Issue | DO NOT | DO |
|-------|--------|-----|
| Field name wrong | Patch in code | Route to data-engineer to fix contract |
| Function name wrong | Use different name | Route to api-designer to fix contract |
| Missing field | Add it yourself | Route to data-engineer to add to contract |
| Missing endpoint | Build untyped | Route to api-designer to add to contract |

**NEVER work around contract errors. Fix the contract.**

### Contract Error Report

```markdown
## Contract Error: [ID]

**Found in:** [file:line]
**Contract file:** TYPE-CONTRACTS.ts / API-CONTRACTS.ts
**Issue:** [description]

**Expected (from contract):**
```
passwordHash: string
```

**Actual (from reality):**
```
password_hash column in database
```

**Route to:** data-engineer
**Action:** Update TYPE-CONTRACTS.ts field mapping
```

---

## Implementation Order

```
1. Database migrations
2. API endpoints (backend)
3. API integration (frontend data fetching)
4. UI components
5. Business logic
6. Tests (AS YOU GO)
```

---

## Feature = Code + Tests

A feature is NOT implemented until:

- [ ] Code written and working
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Edge cases handled
- [ ] Error states handled
- [ ] RTM updated with sign-off

**No tests = Not implemented = Cannot sign off**

---

## RTM Sign-Off (MANDATORY)

For EACH requirement:

```markdown
| REQ-ID | Status | File(s) | Test File | Notes |
|--------|--------|---------|-----------|-------|
| REQ-001 | ✅ | src/auth/login.ts:45-120 | tests/auth/login.test.ts | |
| REQ-002 | ✅ | src/api/users.ts:20-80 | tests/api/users.test.ts | |
| REQ-003 | ❌ | - | - | Blocked by REQ-001 |
```

Sign-off statuses:
- ✅ Implemented and tested
- ❌ Not implemented
- 🚫 Descoped (with approval)

**Missing sign-off = BLOCK release**

---

## Admin Panel (Apps with Users)

ALWAYS implement:

- [ ] Admin dashboard with metrics
- [ ] User list with pagination
- [ ] User search/filter
- [ ] Edit user
- [ ] Disable/enable user
- [ ] Delete user
- [ ] Role management
- [ ] Seed admin user in scripts/seed

Routes: `/admin`, `/admin/users`, `/admin/settings`

---

## Code Quality Checklist

Before merge:

- [ ] No lint errors
- [ ] No type errors
- [ ] All tests pass
- [ ] Code reviewed
- [ ] RTM updated

---

## Feedback Routing

| Issue | Route To | Action |
|-------|----------|--------|
| Field name mismatch | data-engineer | Update TYPE-CONTRACTS.ts |
| Missing entity/field | data-engineer | Add to TYPE-CONTRACTS.ts |
| Function name mismatch | api-designer | Update API-CONTRACTS.ts |
| Missing endpoint | api-designer | Add to API-CONTRACTS.ts |
| API can't support UI | solution-architect | Revise design |
| DB schema wrong | data-engineer | Update SCHEMA.sql + contracts |
| UI impossible to implement | designer | Revise design |
| Auth mechanism unclear | security-engineer | Document auth flow |
| Requirement ambiguous | business-analyst | Clarify requirement |

**Contract errors ALWAYS go back upstream. Never patch around them.**

---

## Handoff to QA

DELIVER:
- [ ] All features implemented
- [ ] All tests passing
- [ ] RTM with 100% Must-Have sign-offs
- [ ] README updated with setup
- [ ] Admin seeded

IF any unchecked → NOT READY for QA.
