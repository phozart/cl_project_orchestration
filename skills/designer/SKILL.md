---
name: designer
description: This skill should be used when invoked by project-orchestrator at Gate 3, or when the user asks to "design the UI", "create wireframes", "design screens", "define components", or needs UX/UI design. Designs all screens with all states using exact field names from TYPE-CONTRACTS.ts.
---

# Designer

Design complete user experiences. All screens. All states. All interactions. **USE TYPE-CONTRACTS.ts for all field names.**

## Rules

1. IMPORT TYPE-CONTRACTS.ts. Use EXACT field names from contracts.
2. DESIGN all screens from user journeys. No journey step without a screen.
3. DEFINE all component states: default, hover, focus, active, disabled, loading, error.
4. SPECIFY empty states, error states, loading states for every screen.
5. MEET WCAG AA accessibility. No exceptions.
6. DOCUMENT responsive breakpoints for all screens.

## References

| File | Content |
|------|---------|
| `references/design-system.md` | Colors, typography, spacing tokens |
| `references/component-specs.md` | Component states and specs |
| `references/interactions.md` | Animation timing, feedback patterns |

---

## Input Validation

REQUIRED before designing:
- [ ] Feature Inventory from Product Design
- [ ] User Journeys mapped
- [ ] Requirements Catalogue from BA
- [ ] **TYPE-CONTRACTS.ts exists** (from data-engineer)

IF missing → STOP. Get from upstream.

---

## TYPE-CONTRACTS Integration (MANDATORY)

Form fields MUST match TYPE-CONTRACTS.ts exactly:

```typescript
// TYPE-CONTRACTS.ts
export interface User {
  id: string;
  email: string;
  displayName: string;
  passwordHash: string;
}
```

```markdown
// DESIGN SPEC - CORRECT
## Registration Form
- Field: `email` (type: email, required)
- Field: `displayName` (type: text, required)
- Field: `password` (type: password, required, min 8 chars)

// DESIGN SPEC - WRONG ❌
## Registration Form
- Field: `userEmail` ← Wrong! Contract says `email`
- Field: `name` ← Wrong! Contract says `displayName`
```

IF field name doesn't exist in contracts → STOP. Route to data-engineer to update contract.

---

## Process

```
UX (Flows, Wireframes) → UI (Design System, Components) → INTERACTIONS (States, Animations)
```

---

## Phase 1: UX

### Required Outputs

- [ ] User flows for each journey
- [ ] Wireframes for each screen
- [ ] Information architecture (navigation, hierarchy)
- [ ] Edge cases defined (empty, error, first-time user)

### Screen Checklist

For EACH screen:
- [ ] Default state
- [ ] Loading state
- [ ] Empty state (no data)
- [ ] Error state
- [ ] First-time user state (if different)

---

## Phase 2: UI

### Design System Required

- [ ] Color palette (primary, semantic, neutral)
- [ ] Typography scale
- [ ] Spacing tokens
- [ ] Border radius tokens
- [ ] Shadow tokens

### Component Specs Required

For EACH component, document:
- [ ] All variants
- [ ] All states (default, hover, focus, active, disabled, loading, error)
- [ ] All sizes
- [ ] CSS specs for developers

---

## Phase 3: Interactions

### Required Specs

- [ ] Response times (instant < 100ms, quick < 300ms)
- [ ] Easing functions
- [ ] Loading patterns (skeleton, spinner, progress)
- [ ] Feedback patterns (success, error, toast)
- [ ] Reduced motion alternatives

---

## Accessibility (MANDATORY)

| Check | Required |
|-------|----------|
| Color contrast | 4.5:1 minimum (AA) |
| Focus visible | All interactive elements |
| Reduced motion | All animations |
| Alt text | All images |
| Form labels | All inputs |

---

## Handoff Checklist

Before handoff to Developer:

- [ ] All screens designed (default + all states)
- [ ] Design system complete
- [ ] Component specs with all states
- [ ] Responsive breakpoints defined
- [ ] Accessibility requirements met
- [ ] Interaction specs documented

IF any unchecked → NOT READY for development.

---

## Output

```
docs/design/
├── USER-FLOWS.md
├── WIREFRAMES.md
├── DESIGN-SYSTEM.md
├── COMPONENTS.md
└── INTERACTIONS.md
```
