# Shared Templates

This file contains shared templates referenced by all workflow skills. Skills should reference these instead of duplicating.

---

## Input Validation Protocol

**Every skill must validate inputs before starting work.**

### Structure

```markdown
## Input Validation

### Required Inputs
[Skill-specific list of required artifacts from upstream]

### Quality Checks
| Check | Status | Notes |
|-------|--------|-------|
| [Skill-specific check] | ✅/❌ | |

### Domain Questions
[What would an expert in this domain notice? What's missing, naive, or overengineered?]

### Decision
- [ ] **ACCEPT** - Proceed with work
- [ ] **CLARIFY** - Need answers (list questions)
- [ ] **UPSTREAM FEEDBACK** - Previous phase needs changes
- [ ] **BLOCK** - Cannot proceed until resolved
```

---

## Upstream Feedback (UPFB)

**Any skill can send feedback to any earlier skill.** This is not failure - it's agile working correctly.

### When to Send Feedback

| Issue Type | Route To |
|------------|----------|
| Requirement is ambiguous | BA |
| Design won't work technically | Architect |
| Users won't understand this | Designer |
| Violates security practices | Security |
| Missing feature for this to work | Product Design |
| Architecture doesn't support this | Architect |
| Data model is wrong | Data Engineer |

### Template

```markdown
## UPFB-XXX: [Source] → [Target]

**Priority**: Critical / High / Medium / Low

### Issue
[What's wrong with the upstream work]

### Impact
[Why this matters - quality, security, usability]

### Suggestion
[Concrete proposal]

### Alternative
[What I'll do if rejected]
```

### Response Format

```markdown
## UPFB-XXX Response

**Decision**: ACCEPT / REJECT / PARTIAL

- If ACCEPT: [Change made, impact on other work]
- If REJECT: [Reason, alternative offered]
- If PARTIAL: [What's accepted/rejected, compromise]
```

---

## Downstream Handoff

When completing work, inform downstream skills:

```markdown
## Handoff: [This Skill] → [Next Skill]

### Artifacts Ready
- [ ] [Artifact 1]: [location]
- [ ] [Artifact 2]: [location]

### Known Issues
- [Any limitations or concerns for downstream]

### Recommended Next Steps
- [What downstream should do first]
```

---

## Quality Gate Check

Before passing a gate:

```markdown
## Gate Check: [Gate Name]

### Completeness
- [ ] All required artifacts exist
- [ ] All acceptance criteria met
- [ ] No blocking issues open

### Traceability
- [ ] All requirements addressed (check RTM)
- [ ] Test coverage adequate

### Decision
- [ ] **PASS** - Proceed to next phase
- [ ] **CONDITIONAL** - Proceed with noted risks
- [ ] **FAIL** - Must address: [issues]
```
