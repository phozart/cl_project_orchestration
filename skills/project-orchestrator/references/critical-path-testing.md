# Critical Path Testing

If the core user journey doesn't work, STOP EVERYTHING.

---

## The Anti-Pattern

```
❌ QA finds: User can login, but main feature doesn't work in UI
   QA continues: Testing edge cases, other features, filing minor bugs
   Result: 50 bug reports, but core product is broken → Wasted effort
```

## The Correct Pattern

```
✅ QA finds: User can login, but main feature doesn't work in UI
   QA STOPS: "Core user journey is BLOCKED - cannot proceed"
   Action: Immediate full-chain review → Fix foundation → Then continue
   Result: Core works first, everything else built on solid foundation
```

---

## Severity Classification

| What QA Finds | Severity | Action |
|---------------|----------|--------|
| Core feature doesn't work at all | **BLOCKER** | STOP all testing. Full-chain review. |
| User can't complete main journey | **BLOCKER** | STOP all testing. Fix before proceeding. |
| UI doesn't connect to backend | **BLOCKER** | STOP. Integration failure. |
| Feature works but has bugs | HIGH | Continue testing, track bugs. |
| Edge cases fail | MEDIUM | Note for fix, continue testing. |
| Cosmetic/minor issues | LOW | Log and continue. |

---

## BLOCKER Protocol

When a BLOCKER is found:

1. **STOP** - Do not continue testing other features
2. **DOCUMENT** - What's broken, what evidence exists
3. **TRACE BACK** - Where did this break? Design? Implementation? Integration?
4. **CONVENE** - Get relevant skills (Dev + QA + Architect/Designer)
5. **FIX** - Address root cause, not symptoms
6. **VERIFY** - Core journey works end-to-end
7. **RESUME** - Continue testing from known-good state

---

## Core Journey Checklist

Before detailed testing, verify ALL:

- [ ] User can complete the PRIMARY use case end-to-end
- [ ] Data flows: UI → API → Database → API → UI correctly
- [ ] User sees expected results (not just "no errors")
- [ ] Feature does what it's supposed to do (not just renders)

**ANY checkbox unchecked = BLOCKER = Full-chain review BEFORE continuing.**

---

## Examples

### BLOCKER: Stop Immediately

- Login works but dashboard is blank
- Form submits but data doesn't save
- API returns success but UI shows error
- Feature exists but does nothing when clicked

### HIGH: Track and Continue

- Validation message is wrong
- Edge case throws error
- Performance is slow but functional

### LOW: Log and Continue

- Spacing is off
- Color doesn't match design exactly
- Minor typo in UI
