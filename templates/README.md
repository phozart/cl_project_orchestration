# Templates

This directory contains templates for all documents produced by the development-workflow-plugin skills. Using templates reduces token usage and ensures consistency across projects.

## Directory Structure

```
templates/
├── README.md                          # This file
├── PRODUCT-INTAKE.template.md         # Product intake form
├── PROJECT-STATUS.template.md         # Project status tracker
├── .env.example.template              # Environment variables
├── docker-compose.template.yml        # Docker configuration
├── docs/
│   ├── discovery/
│   │   └── PROJECT-BRIEF.template.md  # Project brief
│   ├── product/
│   │   ├── PRODUCT-VISION.template.md # Product vision
│   │   ├── FEATURE-INVENTORY.template.md
│   │   └── MVP-SCOPE.template.md
│   ├── requirements/
│   │   ├── BRD.template.md            # Business Requirements
│   │   ├── REQUIREMENTS-CATALOGUE.template.md
│   │   └── USER-STORIES.template.md
│   ├── traceability/
│   │   └── RTM.template.md            # Requirements Traceability Matrix
│   ├── architecture/
│   │   ├── SYSTEM-DESIGN.template.md
│   │   └── ADR/
│   │       └── ADR-001.template.md    # Architecture Decision Record
│   ├── design/                        # UX/UI design docs
│   ├── api/
│   │   └── API-SPEC.template.md       # API specification
│   ├── data/
│   │   └── DATA-MODEL.template.md     # Data model
│   ├── qa/
│   │   ├── TEST-PLAN.template.md
│   │   └── TEST-CASES.template.md
│   ├── security/
│   │   └── SECURITY-REVIEW.template.md
│   ├── infrastructure/                # DevOps docs
│   └── legal/                         # Legal docs
└── code/                              # Code project templates (future)
```

## How to Use Templates

### Option 1: Scaffold Script (Recommended)

Run the scaffold script to create a full project structure:

```bash
# From your project directory
/path/to/development-workflow-plugin/scripts/scaffold-docs.sh "My Project"

# With templates copied
/path/to/development-workflow-plugin/scripts/scaffold-docs.sh "My Project" --with-templates

# Minimal structure only
/path/to/development-workflow-plugin/scripts/scaffold-docs.sh "My Project" --minimal
```

### Option 2: Manual Copy

Copy individual templates as needed:

```bash
# Copy a specific template
cp templates/docs/requirements/BRD.template.md docs/requirements/BRD.md
```

### Option 3: Claude References Templates

Skills can reference templates directly. Example in a skill:

```markdown
When creating the BRD, use the template at:
`templates/docs/requirements/BRD.template.md`

Copy to `docs/requirements/BRD.md` and fill in the placeholders.
```

## Template Placeholders

Templates use `{{PLACEHOLDER}}` syntax for values that need to be filled in:

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | Name of the project |
| `{{PRODUCT_CODE}}` | Product identifier |
| `{{DATE}}` | Current date |
| `{{AUTHOR}}` | Document author |
| `{{FEATURE_NAME}}` | Feature being described |
| `{{REQUIREMENT}}` | Requirement text |

**Example transformation:**

Before:
```markdown
# Project Brief: {{PROJECT_NAME}}
## Product Code: {{PRODUCT_CODE}}
```

After:
```markdown
# Project Brief: Task Manager App
## Product Code: TASK-20260102-001
```

## Benefits

| Benefit | Description |
|---------|-------------|
| **Token Efficiency** | Claude references templates instead of generating structure |
| **Consistency** | Same format across all projects |
| **Completeness** | Templates include all required sections |
| **Speed** | Faster project initialization |

## Customizing Templates

To customize templates for your needs:

1. **Edit existing templates** - Modify any `.template.md` file
2. **Add new templates** - Create new files following the naming convention
3. **Update skill references** - Point skills to your custom templates

## Template Versions

Templates are versioned with the plugin. When updating the plugin:
- New templates may be added
- Existing templates may be updated
- Your customizations in copied files are preserved

## Skill Integration Guide

For skills to use templates efficiently:

### In Skill Instructions

```markdown
## Output Location

**Template**: `templates/docs/requirements/BRD.template.md`
**Target**: `docs/requirements/BRD.md`

When creating this document:
1. Read the template file
2. Copy to target location
3. Replace {{PLACEHOLDERS}} with project-specific values
4. Do NOT regenerate the structure - it's already correct

This saves ~600 tokens per document creation.
```

### Token Savings Estimate

| Document | Without Template | With Template | Savings |
|----------|------------------|---------------|---------|
| PROJECT-BRIEF | ~500 tokens | ~100 tokens | 80% |
| BRD | ~800 tokens | ~200 tokens | 75% |
| RTM | ~400 tokens | ~50 tokens | 88% |
| SYSTEM-DESIGN | ~600 tokens | ~150 tokens | 75% |

## Troubleshooting

### Templates not found
Ensure the plugin path is correct in your Claude Code settings.

### Placeholders not replaced
Remind Claude to replace `{{PLACEHOLDER}}` values with actual content.

### Structure inconsistent
Re-run scaffold script or manually copy fresh templates.
