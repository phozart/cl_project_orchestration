# Templates Reference

Template directory: `templates/`

Run scaffold script: `./scripts/scaffold-docs.sh "Project Name" --with-templates`

---

## Templates by Phase

| Phase | Templates |
|-------|-----------|
| **Intake** | `PRODUCT-INTAKE.template.md`, `PROJECT-STATUS.template.md` |
| **Discovery** | `docs/discovery/PROJECT-BRIEF.template.md` |
| **Product** | `docs/product/PRODUCT-VISION.template.md`, `FEATURE-INVENTORY.template.md`, `MVP-SCOPE.template.md` |
| **Requirements** | `docs/requirements/BRD.template.md`, `REQUIREMENTS-CATALOGUE.template.md`, `USER-STORIES.template.md` |
| **Architecture** | `docs/architecture/SYSTEM-DESIGN.template.md`, `ADR/ADR-001.template.md` |
| **QA** | `docs/qa/TEST-PLAN.template.md`, `TEST-CASES.template.md` |
| **Traceability** | `docs/traceability/RTM.template.md` |

---

## Output Structure

```
docs/
├── discovery/
│   └── PROJECT-BRIEF.md
├── product/
│   ├── PRODUCT-VISION.md
│   ├── FEATURE-INVENTORY.md
│   └── MVP-SCOPE.md
├── experience/
│   └── USER-JOURNEYS.md
├── requirements/
│   ├── BRD.md
│   ├── REQUIREMENTS-CATALOGUE.md
│   └── USER-STORIES.md
├── architecture/
│   ├── SYSTEM-DESIGN.md
│   └── ADR/
│       └── ADR-001-*.md
├── design/
│   └── [design artifacts]
├── qa/
│   ├── TEST-PLAN.md
│   ├── TEST-CASES.md
│   ├── TEST-RESULTS.md
│   └── SECURITY-REVIEW.md
├── traceability/
│   └── RTM.md
└── PROJECT-STATUS.md
```

---

## Template Syntax

Templates use `{{PLACEHOLDER}}` syntax.

Example:
```markdown
# {{PROJECT_NAME}}

## Vision
{{PRODUCT_VISION}}

## Features
{{FEATURE_LIST}}
```

Replace placeholders with actual content. Remove placeholder syntax when complete.

---

## Skill-Specific Templates

Each skill has its own Templates section with specific instructions:

| Skill | Templates It Uses |
|-------|-------------------|
| product-design | PRODUCT-VISION, FEATURE-INVENTORY, MVP-SCOPE |
| business-analyst | BRD, REQUIREMENTS-CATALOGUE, USER-STORIES |
| solution-architect | SYSTEM-DESIGN, ADR templates |
| qa-engineer | TEST-PLAN, TEST-CASES |
| project-tracker | RTM |
