# Agile Framework

A self-learning development framework for continuous improvement.

---

## Core Principles

| Principle | Meaning |
|-----------|---------|
| Small Increments | Each iteration delivers something testable |
| Learn and Adapt | Capture learnings after each iteration |
| User-Centric | Every decision ties back to user value |
| Quality Built-In | Testing and review at every step |

---

## Iteration Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                     ITERATION LIFECYCLE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   PLAN → BUILD → REVIEW → LEARN → ADAPT                         │
│     │      │       │        │        │                          │
│     │      │       │        │        └─→ Update next iteration  │
│     │      │       │        └─→ Capture what worked/didn't      │
│     │      │       └─→ Demo to user, gather feedback            │
│     │      └─→ Implement, test, document                        │
│     └─→ Define scope, acceptance criteria                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Iteration Template

Create `/iterations/iteration-N.md` for each iteration:

```markdown
# Iteration [N]: [Name]

## Metadata
- **Start Date:** YYYY-MM-DD
- **Review Date:** YYYY-MM-DD
- **Status:** Planning | In Progress | Review | Complete

## Goal
[One sentence describing what this iteration achieves for users]

## Scope
### In Scope
- [ ] Feature/Fix 1
- [ ] Feature/Fix 2

### Out of Scope (Deferred)
- Item for future iteration

## Acceptance Criteria
How do we know we're done?
- [ ] Criterion 1
- [ ] Criterion 2

## Tasks
| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Task 1 | - | Todo | |
| Task 2 | - | Todo | |

---

## Review (Complete after iteration)

### Demo Results
- What was shown:
- User feedback:

### What Worked
-

### What Didn't Work
-

### Learnings
-

### Adaptations for Next Iteration
-
```

---

## Iteration Review Checklist

Before completing any iteration:

### Functionality
- [ ] All acceptance criteria met
- [ ] No critical bugs introduced
- [ ] Existing features still work

### User Experience
- [ ] Changes are intuitive
- [ ] Error messages are helpful
- [ ] Loading states are present

### Code Quality
- [ ] No TypeScript/lint errors
- [ ] No console errors
- [ ] Tests pass

### Documentation
- [ ] Iteration notes updated
- [ ] Learnings captured
- [ ] Next iteration adjusted based on learnings

---

## Continuous Improvement Log

Track patterns across iterations in `IMPROVEMENT-LOG.md`:

### Recurring Issues

| Issue | Count | Root Cause | Mitigation |
|-------|-------|------------|------------|
| Type mismatches | 3 | Separate frontend/backend | Generate types from API |
| Missing features | 2 | Incomplete requirements | Better upfront analysis |
| [Pattern] | [N] | [Why] | [How to prevent] |

### Improvements Made

| Improvement | Iteration | Impact |
|-------------|-----------|--------|
| Added JWT auth | 1 | Users can log in |
| Fixed type contracts | 1 | Reduced 500 errors |
| [What changed] | [When] | [Result] |

### Technical Debt Log

| Debt | Priority | Target Iteration |
|------|----------|-----------------|
| Password reset missing | High | 2 |
| Email sending | Medium | 3 |
| [What's owed] | [Urgency] | [When to pay] |

---

## Self-Learning Rules

1. **CAPTURE** learnings after every iteration - what worked, what didn't
2. **LOG** recurring issues - if it happens twice, track it
3. **ADAPT** next iteration based on learnings - don't repeat mistakes
4. **TRACK** technical debt - acknowledge, prioritize, schedule
5. **REVIEW** improvement log at project end - measure progress

---

## Quick Commands

### Start New Iteration
1. Copy template to `/iterations/iteration-N.md`
2. Fill in goal and scope
3. Update PROJECT-STATUS.md

### Complete Iteration
1. Fill in Review section (demo, learnings)
2. Update Continuous Improvement Log
3. Adjust next iteration scope based on learnings

### Check Project Health
Review:
- `PROJECT-STATUS.md` - Overall progress
- `iterations/` - Individual iteration details
- `IMPROVEMENT-LOG.md` - Process improvements

---

## Integration with Gates

Each gate includes an iteration review:

| Gate | Iteration Review |
|------|------------------|
| Gate 0 | Product scope locked, learnings from discovery |
| Gate 1 | Requirements complete, learnings from analysis |
| Gate 2 | Architecture ready, learnings from design |
| Gate 3 | Infra ready, learnings from setup |
| Gate 4 | Features complete, learnings from implementation |
| Gate 5 | QA passed, learnings from testing |

**At each gate:** Update IMPROVEMENT-LOG.md with learnings before proceeding.

---

## Anti-Pattern vs. Correct Pattern

### Anti-Pattern: Iteration Without Learning
```
❌ Build → Ship → Build → Ship → Build → Ship (repeat same mistakes)
```

### Correct Pattern: Learn and Adapt
```
✅ Build → Review → Learn → Adapt → Build (improve each cycle)
```

**Key Difference:** Each iteration explicitly captures what worked/didn't and adjusts the next cycle.
