---
name: plan-next-release
description: Plan the next product release by critically reviewing requirements, assessing risks, and continuously improving the approach
---

You are helping plan the next release iteration. This command transitions from MVP to v2, v3, etc.

**CRITICAL: Each iteration is NOT just "add more features". It requires:**
1. Critical review of what happened in the previous version
2. Risk and impact assessment for new items
3. Process improvement review - question everything
4. Forward traceability to maintain RTM

## Process

### Step 1: Determine Release Context

Ask the user:
1. What version is currently deployed? (v1.0.0, v1.1.0, etc.)
2. What type of release are we planning?
   - **Patch** (v1.0.1) - Bug fixes only
   - **Minor** (v1.1.0) - Bug fixes + small features
   - **Major** (v2.0.0) - Significant new features

### Step 2: Requirements Review (CRITICAL)

Before collecting new feedback, review what happened:

1. **Read the RTM** (`docs/traceability/RTM.md`)
2. **Assess each requirement from previous version:**
   - Working as expected?
   - Working but issues?
   - Not used by users?
   - Failed in production?
3. **Calculate coverage score** - If < 90% working, prioritize fixes
4. **Identify orphaned features** - Code without RTM entries
5. **Document lessons learned** - What patterns worked/failed?

### Step 3: Collect Inputs

Gather information from:

1. **Deferred Items** - Read `docs/product/MVP-SCOPE.md` for "Out of Scope" items
2. **User Feedback** - Ask user for:
   - Support tickets / common complaints
   - Feature requests
   - User confusion points
3. **Analytics** (if available):
   - Drop-off points
   - Unused features
   - Popular features
4. **Technical Debt**:
   - Performance issues
   - Code quality concerns
   - Scalability needs
5. **Error Logs** (if available):
   - Recurring errors
   - Edge cases discovered

### Step 4: Risk & Impact Assessment (CRITICAL)

For EACH item being considered:

1. **Risk Assessment**:
   - Technical risk (can we build it?)
   - Integration risk (will it break existing features?)
   - User risk (will users understand it?)
   - Security risk (new attack vectors?)
   - Performance risk (will it slow things down?)

2. **Risk Score**: Probability × Impact (1-5 each, max 25)
   - 1-5: Low → Proceed
   - 6-12: Medium → Plan mitigation
   - 13-19: High → Requires approval
   - 20-25: Critical → Reconsider

3. **Impact Analysis**:
   - What code areas affected?
   - What data changes needed?
   - What UX changes?
   - Regression risk?

4. **High-risk items** require:
   - Architecture review
   - Extended testing plan
   - Rollback procedure

### Step 5: Process & Approach Review (CRITICAL)

**Don't just repeat what you did. Question EVERYTHING:**

1. **Challenge assumptions**:
   - Is our tech stack still right?
   - Are our tools still best?
   - What competitors are doing differently?

2. **Review what didn't work**:
   - Which phases had problems?
   - What took longer than expected?
   - What quality issues occurred?

3. **External changes**:
   - New regulations?
   - New technology options?
   - Market changes?

4. **Decide on improvements**:
   - Process changes for this iteration
   - Tool changes
   - Approach changes

### Step 6: Prioritize

Score each item:

| Criterion | Score 1-5 | Description |
|-----------|-----------|-------------|
| User Impact | How many users affected? |
| Business Value | Revenue/retention impact? |
| Effort (inverse) | 5 = low effort, 1 = high effort |
| Risk (inverse) | 5 = low risk, 1 = high risk |

Total Score = Impact + Value + Effort + Risk (max 20)

### Step 7: Select Workflow

Based on what's included:

| Content | Workflow | Skills Involved |
|---------|----------|-----------------|
| Bugs only | Hotfix | QA → Dev → Deploy |
| Small features | Feature | Product Design (check) → BA → Dev → QA |
| UI changes | Feature + Design | UX → UI → Dev → QA |
| New journeys | Full Feature | Product Design → BA → Architect → ... |
| Major pivot | Full | Strategy → Product Design → BA → ... |

### Step 8: Lock Scope & Traceability

Produce release plan with full traceability:

```markdown
# Release Plan: v[X.Y.Z]

## Release Type: [Patch/Minor/Major]

## Previous Version Review

### RTM Coverage (v[Previous])
- Total Requirements: [X]
- Working: [X] ([%])
- Issues: [X] ([%])
- Coverage Score: [X]% (must be >90% to add features)

### Lessons Learned
| What Happened | Root Cause | Prevention |
|---------------|------------|------------|
| [Issue] | [Cause] | [Fix process] |

## Scope

### Must-Have (this release)
| Item | Type | Source | Risk | Impact | REQ-ID |
|------|------|--------|------|--------|--------|
| [Item] | Bug/Feature | [Feedback/Deferred/etc] | [L/M/H] | [L/M/H] | REQ-XXX |

### Should-Have (if time permits)
| Item | Type | Source | Risk | Impact | REQ-ID |
|------|------|--------|------|--------|--------|

### Deferred to v[X+1]
| Item | Reason | Risk if Delayed |
|------|--------|-----------------|

## Risk Register
| Item | Risk | Probability | Impact | Score | Mitigation |
|------|------|-------------|--------|-------|------------|

## Impact Analysis
| Item | Code Areas | Data Changes | UX Changes | Regression Risk |
|------|------------|--------------|------------|-----------------|

## Process Improvements (this iteration)
| Change | Rationale | Effective From |
|--------|-----------|----------------|

## Traceability
- [ ] All items traced to source (feedback, bug, deferred)
- [ ] All items will get REQ-IDs
- [ ] RTM will be updated
- [ ] Test cases will be created

## Workflow Selected: [Type]

## Next Steps
1. [First action]
2. [Second action]
```

### Step 9: Begin Workflow

Based on selected workflow, invoke appropriate skills in order.

## Output Location

Save release plan to:
```
docs/releases/RELEASE-PLAN-v[X.Y.Z].md
```

Also update:
```
docs/traceability/RTM.md - Add new REQ-IDs
docs/releases/ITERATION-LOG.md - Append iteration summary
```

## Iteration Principles

1. **Review before adding** - Fix what's broken before adding new features
2. **Trace everything** - Every item has a source and destination
3. **Assess risk** - High-risk items need approval and mitigation
4. **Question approach** - Don't repeat broken processes
5. **Learn continuously** - Document what worked and what didn't
6. **Stay current** - Consider new tech, tools, and market changes
7. **Security always** - Every release needs security review
