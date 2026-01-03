# Iteration Protocol

This workflow is AGILE, not waterfall. Skills critically review inputs, collaborate, and iterate.

---

## Core Principles

| Principle | Meaning |
|-----------|---------|
| Critical Input Review | Every skill validates before accepting |
| Upstream Feedback | Later skills suggest changes to earlier work |
| Collaboration over Handoff | Skills work together |
| Iterate over Perfect First Time | Expect multiple passes |

---

## Collaboration Points

| Phase | Skills Involved | Purpose |
|-------|-----------------|---------|
| After Product Design | Product + BA + UX | Align on scope |
| After Requirements | BA + Architect + Data + API | Technical feasibility |
| After Architecture | Architect + Dev + Security | Implementation approach |
| Before Implementation | Dev + QA + Security | Test planning, security by design |
| During QA | QA + Dev + BA | Defect triage |

---

## Full-Chain Iteration Matrix

Every skill can trigger updates in BOTH upstream and downstream skills.

| Skill | Finds Issue | Updates |
|-------|-------------|---------|
| BA | Feature missing from vision | Product Design |
| BA | User journey has gaps | Product Design |
| Architect | Requirement technically impossible | BA → Product Design |
| Architect | Security concern with feature | BA + Product Design |
| Designer | Flow doesn't make sense | BA → Product Design |
| Designer | Missing screens/states | BA |
| Platform | Architecture can't deploy | Architect |
| Developer | Design not implementable | Designer |
| Developer | API contract doesn't work | Architect + API Designer |
| Developer | Requirement ambiguous | BA |
| QA | Feature not testable | Developer + BA |
| QA | Acceptance criteria unclear | BA |
| QA | Journey doesn't match design | Designer + Product Design |
| Security | Architecture has vulnerability | Architect |
| Security | Feature design is insecure | Product Design + BA |

---

## Upstream Update Protocol

When downstream finds upstream issue:

1. **DOCUMENT** - Clear description of what's wrong
2. **PROPOSE** - Suggest improvement, don't just complain
3. **ROUTE** - Use Feedback Routing table
4. **WAIT** - Don't proceed with broken foundation
5. **VERIFY** - Confirm fix resolves issue
6. **CONTINUE** - Proceed with corrected inputs

---

## Example Flow

```
Developer finds: "Login API endpoint structure won't support SSO"
         ↓
Routes to: Architect (API design issue)
         ↓
Architect updates: API contract to support SSO
         ↓
Architect notifies: BA (may affect requirements)
         ↓
BA updates: User stories for SSO flow
         ↓
Developer continues: With corrected API contract
```

**This is SUCCESS, not failure.** Finding issues early saves weeks of rework.

---

## Feedback Routing

| Issue Type | Route To |
|------------|----------|
| Requirement gap/ambiguity | business-analyst |
| Architecture flaw | solution-architect |
| Design/UX problem | designer |
| Code bug | fullstack-developer |
| Test gap | qa-engineer |
| Security vulnerability | security-engineer + developer |
| Schema issue | data-engineer |
| Compliance gap | legal-compliance |
| Product mismatch | product-design |

---

## Continuous Improvement Rules

1. **Never proceed with known gaps** - Fix issues NOW
2. **Upstream updates are normal** - Success, not failure
3. **Each phase improves the whole** - Not just adding features
4. **Document learnings** - Each review adds to project knowledge
5. **Test early, test often** - Don't wait for QA to find testability issues
