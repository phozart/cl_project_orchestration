#!/bin/bash

# =============================================================================
# scaffold-docs.sh - Create project documentation structure
# =============================================================================
# Usage: ./scripts/scaffold-docs.sh [project-name] [--minimal]
#
# Creates the full docs/ directory structure for a new project.
# Optionally copies templates if --with-templates flag is provided.
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory (where templates are located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$PLUGIN_DIR/templates"

# Default values
PROJECT_NAME="${1:-MyProject}"
MINIMAL=false
WITH_TEMPLATES=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --minimal)
            MINIMAL=true
            shift
            ;;
        --with-templates)
            WITH_TEMPLATES=true
            shift
            ;;
        --help)
            echo "Usage: $0 [project-name] [options]"
            echo ""
            echo "Options:"
            echo "  --minimal        Create only essential directories"
            echo "  --with-templates Copy template files to docs/"
            echo "  --help           Show this help message"
            exit 0
            ;;
    esac
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Scaffolding Documentation Structure${NC}"
echo -e "${BLUE}  Project: ${GREEN}$PROJECT_NAME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Create docs directory structure
echo -e "${YELLOW}Creating directories...${NC}"

# Core directories (always created)
CORE_DIRS=(
    "docs/discovery"
    "docs/product"
    "docs/requirements"
    "docs/traceability"
    "docs/architecture/ADR"
    "docs/design"
    "docs/api"
    "docs/data"
    "docs/qa"
    "docs/security"
)

# Extended directories (skip if --minimal)
EXTENDED_DIRS=(
    "docs/infrastructure"
    "docs/legal"
    "docs/emails"
    "docs/notifications"
    "docs/chronicles"
    "iterations"
)

# Create core directories
for dir in "${CORE_DIRS[@]}"; do
    mkdir -p "$dir"
    echo -e "  ${GREEN}✓${NC} $dir"
done

# Create extended directories (unless minimal)
if [ "$MINIMAL" = false ]; then
    for dir in "${EXTENDED_DIRS[@]}"; do
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} $dir"
    done
fi

echo ""

# Copy templates if requested
if [ "$WITH_TEMPLATES" = true ]; then
    echo -e "${YELLOW}Copying templates...${NC}"

    if [ -d "$TEMPLATES_DIR" ]; then
        # Copy document templates
        if [ -d "$TEMPLATES_DIR/docs" ]; then
            cp -r "$TEMPLATES_DIR/docs/"* docs/ 2>/dev/null || true
            echo -e "  ${GREEN}✓${NC} Document templates copied"
        fi

        # Copy root templates
        [ -f "$TEMPLATES_DIR/PROJECT-STATUS.template.md" ] && cp "$TEMPLATES_DIR/PROJECT-STATUS.template.md" PROJECT-STATUS.md
        [ -f "$TEMPLATES_DIR/PRODUCT-INTAKE.template.md" ] && cp "$TEMPLATES_DIR/PRODUCT-INTAKE.template.md" PRODUCT-INTAKE.md
        [ -f "$TEMPLATES_DIR/IMPROVEMENT-LOG.md" ] && cp "$TEMPLATES_DIR/IMPROVEMENT-LOG.md" IMPROVEMENT-LOG.md
        [ -f "$TEMPLATES_DIR/.env.example.template" ] && cp "$TEMPLATES_DIR/.env.example.template" .env.example
        [ -f "$TEMPLATES_DIR/docker-compose.template.yml" ] && cp "$TEMPLATES_DIR/docker-compose.template.yml" docker-compose.yml

        # Copy iteration template to iterations directory
        if [ -d "iterations" ] && [ -f "$TEMPLATES_DIR/ITERATION.md" ]; then
            cp "$TEMPLATES_DIR/ITERATION.md" iterations/iteration-0.md
            echo -e "  ${GREEN}✓${NC} Iteration template copied"
        fi

        echo -e "  ${GREEN}✓${NC} Root templates copied"
    else
        echo -e "  ${RED}✗${NC} Templates directory not found at $TEMPLATES_DIR"
    fi
    echo ""
fi

# Create placeholder files
echo -e "${YELLOW}Creating placeholder files...${NC}"

# Create .gitkeep files to preserve empty directories
find docs -type d -empty -exec touch {}/.gitkeep \;
echo -e "  ${GREEN}✓${NC} .gitkeep files created"

# Create initial PROJECT-STATUS.md if not exists
if [ ! -f "PROJECT-STATUS.md" ]; then
    cat > PROJECT-STATUS.md << EOF
# Project Status: $PROJECT_NAME

## Current State
- **Phase**: Not Started
- **Gate**: -
- **Last Updated**: $(date +%Y-%m-%d)

## Quick Resume
> **What's happening**: Project initialized
> **Next step**: Complete product intake
> **Blockers**: None

## Progress Summary
| Phase | Status | Gate | Date |
|-------|--------|------|------|
| Product Intake | ⏳ Pending | - | - |
| Product Design | ⏳ Pending | Gate 0 | - |
| Requirements | ⏳ Pending | Gate 1 | - |
| Architecture | ⏳ Pending | Gate 2 | - |
| Implementation | ⏳ Pending | Gate 4 | - |
| QA | ⏳ Pending | Gate 5 | - |
| Release | ⏳ Pending | - | - |

## Open Items
- [ ] Complete product intake
- [ ] Define product scope

## Blockers
None

## Artifacts Created
| Artifact | Location | Status |
|----------|----------|--------|
| Project Status | PROJECT-STATUS.md | ✅ Created |
EOF
    echo -e "  ${GREEN}✓${NC} PROJECT-STATUS.md created"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Documentation structure created successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Structure created:"
echo ""
if command -v tree &> /dev/null; then
    tree docs -L 2
else
    find docs -type d | head -20
fi
echo ""
echo -e "Next steps:"
echo -e "  1. Run ${BLUE}/project-orchestrator${NC} to start your project"
echo -e "  2. Or use individual skills directly"
echo ""
