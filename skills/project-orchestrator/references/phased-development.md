# Phased Development Plan

Structure large projects into COMPLETE phases, not partial features.

---

## Phase Structure

Each phase MUST be:
1. **Self-contained** - Delivers value independently
2. **Fully tested** - Complete test coverage for phase scope
3. **Deployable** - Could go to production if needed
4. **Reviewed** - Full-chain review before next phase

---

## Recommended Phase Order

| Phase | Contains | Rationale |
|-------|----------|-----------|
| **Phase 1: Foundation** | Auth, admin panel, core infrastructure | Everything else depends on this |
| **Phase 2: Core Feature** | Main value proposition | Users need this to care |
| **Phase 3: Supporting Features** | Secondary features enhancing core | Build on working core |
| **Phase 4: Polish & Edge Cases** | Error handling, UX improvements | Refine what works |
| **Phase 5: Scale & Optimize** | Performance, caching, monitoring | Optimize proven functionality |

---

## Phase Planning Template

```markdown
## Phase [N]: [Name]

### Goal
[One sentence describing the end state]

### Features Included
- [ ] Feature A (REQ-XXX)
- [ ] Feature B (REQ-XXX)
- [ ] Feature C (REQ-XXX)

### Definition of Done
- [ ] All features implemented and working
- [ ] Unit tests pass (100% for new code)
- [ ] Integration tests pass
- [ ] E2E test for user journey exists
- [ ] Documentation updated
- [ ] Phase Completion Review passed
- [ ] Upstream updates triggered (if needed)

### Dependencies
- Requires Phase [N-1] complete
- External: [Any external dependencies]

### Exit Criteria
Phase is COMPLETE when all Definition of Done items are checked AND Phase Completion Review decision is PROCEED.
```

---

## Phase Execution Rules

| Rule | Meaning |
|------|---------|
| Complete N before N+1 | No "I'll finish this later" - finish NOW |
| Full-chain review each phase | Product Design, BA, QA all validate |
| Fix before proceeding | Don't carry debt to next phase |
| Scope locked once started | New ideas go to future phases |

---

## Example: Auth App Phases

```
Phase 1: Foundation
├── User registration
├── User login/logout
├── Admin panel (CRUD users)
├── Email verification
└── Password reset

Phase 2: Core Features
├── User dashboard
├── Profile management
├── Session management
└── Activity logging

Phase 3: Enhancement
├── OAuth providers (Google, GitHub)
├── 2FA/MFA
├── API key management
└── Webhooks

Phase 4: Polish
├── Rate limiting
├── Security hardening
├── Error page improvements
└── Loading states
```

Each phase: **Build → Test → Review → Update Upstream → Proceed**
