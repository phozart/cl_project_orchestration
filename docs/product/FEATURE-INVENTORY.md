# Feature Inventory: Plugin Scaffolding System

## Overview
Total Features: 47
- Must-Have: 28
- Should-Have: 12
- Could-Have: 7

---

## Category 1: Templates Directory Structure

### F-001: Templates Root Directory
- **Description**: Create `templates/` directory at plugin root
- **Priority**: Must
- **Acceptance**: Directory exists, is documented in README

### F-002: Document Templates Subdirectory
- **Description**: Create `templates/docs/` mirroring the docs output structure
- **Priority**: Must
- **Structure**:
  ```
  templates/docs/
  ├── discovery/
  ├── product/
  ├── requirements/
  ├── traceability/
  ├── architecture/
  ├── design/
  ├── api/
  ├── data/
  ├── qa/
  ├── security/
  ├── infrastructure/
  └── legal/
  ```

### F-003: Code Templates Subdirectory
- **Description**: Create `templates/code/` for code project templates
- **Priority**: Should
- **Structure**:
  ```
  templates/code/
  ├── nextjs/
  ├── fastapi/
  └── docker/
  ```

### F-004: Examples Subdirectory
- **Description**: Create `templates/examples/` for filled-in examples
- **Priority**: Should
- **Purpose**: Show what completed documents look like

---

## Category 2: Discovery Phase Templates

### F-005: PROJECT-BRIEF Template
- **Description**: Template for `docs/discovery/PROJECT-BRIEF.md`
- **Priority**: Must
- **Sections**: Problem, Users, Scope, Constraints, Success Criteria

### F-006: PRODUCT-INTAKE Template
- **Description**: Template for `PRODUCT-INTAKE.md`
- **Priority**: Must
- **Sections**: All 9 intake form sections

### F-007: MARKET-ANALYSIS Template
- **Description**: Template for `docs/discovery/MARKET-ANALYSIS.md`
- **Priority**: Could
- **Sections**: TAM/SAM/SOM, Trends, Competition

### F-008: PROJECT-STATUS Template
- **Description**: Template for `PROJECT-STATUS.md`
- **Priority**: Must
- **Sections**: Current state, progress, blockers, activity log

---

## Category 3: Product Phase Templates

### F-009: PRODUCT-VISION Template
- **Description**: Template for `docs/product/PRODUCT-VISION.md`
- **Priority**: Must
- **Sections**: Vision, Value Prop, Strategy, Metrics

### F-010: FEATURE-INVENTORY Template
- **Description**: Template for `docs/product/FEATURE-INVENTORY.md`
- **Priority**: Must
- **Sections**: Feature list with F-XXX IDs

### F-011: MVP-SCOPE Template
- **Description**: Template for `docs/product/MVP-SCOPE.md`
- **Priority**: Must
- **Sections**: In scope, out of scope, success criteria

### F-012: USER-JOURNEYS Template
- **Description**: Template for `docs/product/USER-JOURNEYS.md`
- **Priority**: Should
- **Sections**: Journey maps with steps

---

## Category 4: Requirements Phase Templates

### F-013: BRD Template
- **Description**: Template for `docs/requirements/BRD.md`
- **Priority**: Must
- **Sections**: Business requirements document structure

### F-014: REQUIREMENTS-CATALOGUE Template
- **Description**: Template for `docs/requirements/REQUIREMENTS-CATALOGUE.md`
- **Priority**: Must
- **Sections**: REQ-XXX list with priorities, acceptance criteria

### F-015: USER-STORIES Template
- **Description**: Template for `docs/requirements/USER-STORIES.md`
- **Priority**: Must
- **Sections**: US-XXX list with acceptance criteria

### F-016: RTM Template
- **Description**: Template for `docs/traceability/RTM.md`
- **Priority**: Must
- **Sections**: Requirements Traceability Matrix

---

## Category 5: Architecture Phase Templates

### F-017: SYSTEM-DESIGN Template
- **Description**: Template for `docs/architecture/SYSTEM-DESIGN.md`
- **Priority**: Must
- **Sections**: Components, data flow, deployment

### F-018: ADR Template
- **Description**: Template for `docs/architecture/ADR/ADR-XXX.md`
- **Priority**: Must
- **Sections**: Context, Decision, Consequences

### F-019: TECH-STACK Template
- **Description**: Template for `docs/architecture/TECH-STACK.md`
- **Priority**: Should
- **Sections**: Frontend, Backend, Database, Infrastructure

---

## Category 6: Data & API Templates

### F-020: DATA-MODEL Template
- **Description**: Template for `docs/data/DATA-MODEL.md`
- **Priority**: Must
- **Sections**: Entities, Relationships, Schema

### F-021: API-SPEC Template
- **Description**: Template for `docs/api/API-SPEC.md`
- **Priority**: Must
- **Sections**: Endpoints, Request/Response, Auth

### F-022: DATA-DICTIONARY Template
- **Description**: Template for `docs/data/DATA-DICTIONARY.md`
- **Priority**: Should
- **Sections**: Field definitions, types, constraints

---

## Category 7: Design Phase Templates

### F-023: USER-FLOWS Template
- **Description**: Template for `docs/design/USER-FLOWS.md`
- **Priority**: Must
- **Sections**: Flow diagrams, steps, decisions

### F-024: WIREFRAMES Template
- **Description**: Template for `docs/design/WIREFRAMES.md`
- **Priority**: Should
- **Sections**: Screen layouts, annotations

### F-025: UI-SPEC Template
- **Description**: Template for `docs/design/UI-SPEC.md`
- **Priority**: Should
- **Sections**: Components, styling, interactions

### F-026: DESIGN-SYSTEM Template
- **Description**: Template for `docs/design/DESIGN-SYSTEM.md`
- **Priority**: Could
- **Sections**: Colors, typography, spacing, components

---

## Category 8: QA Phase Templates

### F-027: TEST-PLAN Template
- **Description**: Template for `docs/qa/TEST-PLAN.md`
- **Priority**: Must
- **Sections**: Scope, approach, test cases

### F-028: TEST-CASES Template
- **Description**: Template for `docs/qa/TEST-CASES.md`
- **Priority**: Must
- **Sections**: TC-XXX list linked to requirements

### F-029: DEFECT-LOG Template
- **Description**: Template for `docs/qa/DEFECT-LOG.md`
- **Priority**: Should
- **Sections**: BUG-XXX list with status

---

## Category 9: Infrastructure & Security Templates

### F-030: SECURITY-REVIEW Template
- **Description**: Template for `docs/security/SECURITY-REVIEW.md`
- **Priority**: Must
- **Sections**: Vulnerabilities, recommendations, sign-off

### F-031: INFRASTRUCTURE-SETUP Template
- **Description**: Template for `docs/infrastructure/SETUP.md`
- **Priority**: Should
- **Sections**: Docker, env vars, deployment

### F-032: ENV-EXAMPLE Template
- **Description**: Template for `.env.example`
- **Priority**: Must
- **Sections**: Required environment variables

---

## Category 10: Legal Templates

### F-033: PRIVACY-POLICY Template
- **Description**: Template for `docs/legal/PRIVACY-POLICY.md`
- **Priority**: Should
- **Sections**: Data collection, usage, rights

### F-034: TERMS-OF-SERVICE Template
- **Description**: Template for `docs/legal/TERMS-OF-SERVICE.md`
- **Priority**: Should
- **Sections**: Usage terms, limitations

---

## Category 11: Code Project Templates

### F-035: Next.js Project Template
- **Description**: Template for Next.js + TypeScript project
- **Priority**: Should
- **Files**: package.json, tsconfig.json, app structure

### F-036: FastAPI Project Template
- **Description**: Template for FastAPI + Python project
- **Priority**: Could
- **Files**: pyproject.toml, main.py, structure

### F-037: Docker Compose Template
- **Description**: Template for docker-compose.yml
- **Priority**: Must
- **Services**: App, DB, Redis (configurable)

### F-038: Dockerfile Template
- **Description**: Template for Dockerfile (Node and Python)
- **Priority**: Should
- **Variants**: Node, Python

---

## Category 12: Automation & Tooling

### F-039: Scaffold Docs Script
- **Description**: Script to create full docs/ structure
- **Priority**: Must
- **Command**: `./scripts/scaffold-docs.sh` or MCP tool

### F-040: Template Copy Helper
- **Description**: Script to copy template to target location
- **Priority**: Should
- **Usage**: `./scripts/copy-template.sh <template> <target>`

### F-041: MCP Server (Optional)
- **Description**: MCP server exposing scaffolding tools
- **Priority**: Could
- **Tools**: scaffold_docs, scaffold_code, copy_template

---

## Category 13: Documentation & Instructions

### F-042: Templates README
- **Description**: README.md in templates/ explaining usage
- **Priority**: Must
- **Content**: Structure, how to use, how to extend

### F-043: Skill Integration Guide
- **Description**: How skills should reference templates
- **Priority**: Must
- **Content**: Pattern for skills to use templates

### F-044: Update Existing Skills
- **Description**: Add template references to existing skills
- **Priority**: Should
- **Scope**: Update SKILL.md files with template paths

---

## Category 14: Examples

### F-045: Filled PROJECT-BRIEF Example
- **Description**: Example filled-in project brief
- **Priority**: Should
- **Purpose**: Show users what good output looks like

### F-046: Filled BRD Example
- **Description**: Example filled-in BRD
- **Priority**: Should
- **Purpose**: Reference for Claude and users

### F-047: Complete Project Example
- **Description**: Full docs/ tree with all templates filled
- **Priority**: Could
- **Purpose**: Reference implementation

---

## Feature Priority Summary

| Priority | Count | Categories |
|----------|-------|------------|
| **Must-Have** | 28 | Core templates, automation, docs |
| **Should-Have** | 12 | Extended templates, code, examples |
| **Could-Have** | 7 | Nice-to-haves, MCP, advanced |

## Validation Checklist

- [ ] All 34 skill outputs have templates
- [ ] Templates match current skill output formats
- [ ] Automation scripts work cross-platform (or have alternatives)
- [ ] README explains full usage
- [ ] At least one example is complete
