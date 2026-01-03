# Defect Management

## Defect Severity Levels

| Severity | Definition | Examples | Release Impact |
|----------|------------|----------|----------------|
| **Critical** | System unusable, data loss, security breach | Login broken, data corruption, SQL injection | BLOCK release |
| **High** | Major feature broken, no workaround | Payment fails, core workflow broken | FIX before release |
| **Medium** | Feature impaired, workaround exists | Export fails but can copy manually | Track, fix next release |
| **Low** | Cosmetic, minor inconvenience | Typo, alignment off, minor UI glitch | Log, prioritize later |

---

## Defect Template

```markdown
# DEF-XXX: [Short Descriptive Title]

## Classification
- **Severity:** Critical | High | Medium | Low
- **Status:** New | Confirmed | In Progress | Fixed | Verified | Closed
- **Requirement:** REQ-XXX
- **Found in:** [Version/Build]
- **Environment:** [Dev/Staging/Prod]

## Description
[Clear description of the defect]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Result
[What should happen]

## Actual Result
[What actually happens]

## Evidence
- Screenshot: [link]
- Video: [link]
- Logs: [relevant log entries]

## Impact
[Who is affected and how]

## Workaround
[If any workaround exists]

## Resolution
- Fixed by: [Developer]
- Fix description: [What was changed]
- Verified by: [QA]
- Verified date: [Date]
```

---

## Defect Lifecycle

```
NEW → CONFIRMED → IN PROGRESS → FIXED → VERIFIED → CLOSED
       ↓                          ↓
    REJECTED                   REOPENED
```

| Status | Meaning |
|--------|---------|
| New | Just reported, not yet reviewed |
| Confirmed | Reviewed, valid defect |
| In Progress | Developer working on fix |
| Fixed | Developer claims fixed |
| Verified | QA confirmed fix works |
| Closed | Complete, no further action |
| Rejected | Not a defect, works as designed |
| Reopened | Fix didn't work or regressed |

---

## Defect Triage

Daily/weekly triage meeting:

1. Review NEW defects
2. Assign severity
3. Link to requirements (REQ-XXX)
4. Assign owner
5. Set priority for fix

### Triage Checklist

- [ ] Is this a duplicate?
- [ ] Can it be reproduced?
- [ ] What's the severity?
- [ ] Which requirement does it affect?
- [ ] Who should fix it?
- [ ] When should it be fixed?

---

## Defect Metrics

Track these metrics:

| Metric | Formula | Target |
|--------|---------|--------|
| Defect density | Defects / KLOC | < 5 |
| Escape rate | Prod defects / Total defects | < 10% |
| Fix time (Critical) | Time from confirmed to verified | < 24h |
| Fix time (High) | Time from confirmed to verified | < 72h |
| Reopen rate | Reopened / Fixed | < 10% |

---

## Release Blocking Defects

These ALWAYS block release:

- Any Critical severity defect
- Any defect causing data loss or corruption
- Any security vulnerability
- Any defect in core user journey
- Any defect in Must-Have requirement

These require review:

- High severity defects (may ship with workaround if documented)
- Medium severity defects affecting >10% of users
