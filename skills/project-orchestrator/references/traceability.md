# Requirements Traceability Enforcement

THE ORCHESTRATOR ENSURES NO REQUIREMENTS ARE LOST.

---

## RTM Checkpoints

| Phase | Action | Block If |
|-------|--------|----------|
| After Requirements | Initialize RTM | RTM not created |
| After Design | Update RTM with design refs | Any REQ-XXX has no design link |
| After Implementation | Dev signs off each REQ-XXX | Any Must-Have not signed off |
| Before QA | Coverage report | <100% Must-Have coverage |
| Before Release | Final traceability report | Any gap |

---

## RTM Rules

| Condition | Meaning |
|-----------|---------|
| Feature in code but NOT in RTM | Undocumented risk |
| Requirement in RTM but NOT in code | **Not implemented (BLOCKER)** |
| RTM shows 50 requirements, only 35 done | **BLOCK RELEASE** |

---

## RTM Structure

```markdown
# Requirements Traceability Matrix

| REQ-ID | Description | Priority | Design Ref | Impl Status | Test Status | Sign-off |
|--------|-------------|----------|------------|-------------|-------------|----------|
| REQ-001 | User login | Must-Have | D-001 | ✓ Complete | ✓ Pass | ✓ |
| REQ-002 | User logout | Must-Have | D-002 | ✓ Complete | ✓ Pass | ✓ |
| REQ-003 | Password reset | Must-Have | D-003 | In Progress | - | - |
```

---

## Coverage Validation

Before QA gate:
```bash
# Count total Must-Have requirements
TOTAL=$(grep -c "Must-Have" docs/traceability/RTM.md)

# Count signed-off Must-Have requirements
DONE=$(grep -c "Must-Have.*✓.*✓.*✓" docs/traceability/RTM.md)

# If DONE < TOTAL → BLOCK
```

---

## Sign-off Requirements

Each requirement needs THREE sign-offs:

1. **Implementation** - Developer confirms code complete
2. **Test** - QA confirms tests pass
3. **Validation** - BA confirms meets acceptance criteria

Missing ANY sign-off on Must-Have = BLOCK RELEASE

---

## Traceability Report Template

```markdown
## Traceability Report: [Date]

### Summary
- Total Requirements: [N]
- Must-Have: [N]
- Should-Have: [N]
- Could-Have: [N]

### Must-Have Status
- Implemented: [N] / [Total]
- Tested: [N] / [Total]
- Signed-off: [N] / [Total]

### Gaps
| REQ-ID | Issue | Owner | ETA |
|--------|-------|-------|-----|

### Decision
- [ ] PROCEED - 100% Must-Have complete
- [ ] BLOCK - Gaps exist, fix before release
```
