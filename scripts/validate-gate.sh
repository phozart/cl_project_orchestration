#!/bin/bash

# =============================================================================
# validate-gate.sh - Validate gate requirements before proceeding
# =============================================================================
# Usage: ./scripts/validate-gate.sh <gate> [project-root]
#
# Gates: init, intake, 0, 1, 2, 3, 4, 5, 6, all
#
# Exit codes:
#   0 = PASS (proceed to next gate)
#   1 = FAIL (halt, fix issues before proceeding)
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

GATE="${1:-all}"
PROJECT_ROOT="${2:-.}"

ERRORS=0
WARNINGS=0

# Helper functions
error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((ERRORS++))
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

check_file() {
    local file="$1"
    local desc="$2"
    if [ -f "$PROJECT_ROOT/$file" ]; then
        pass "$desc exists"
        return 0
    else
        error "$desc missing: $file"
        return 1
    fi
}

check_dir() {
    local dir="$1"
    local desc="$2"
    if [ -d "$PROJECT_ROOT/$dir" ]; then
        pass "$desc exists"
        return 0
    else
        error "$desc missing: $dir"
        return 1
    fi
}

check_no_tbd() {
    local file="$1"
    local desc="$2"
    if [ -f "$PROJECT_ROOT/$file" ]; then
        if grep -qiE "(TBD|TODO|FIXME)" "$PROJECT_ROOT/$file"; then
            error "$desc contains TBD/TODO items"
            return 1
        else
            pass "$desc has no TBD/TODO items"
            return 0
        fi
    fi
    return 1
}

check_content() {
    local file="$1"
    local pattern="$2"
    local desc="$3"
    if [ -f "$PROJECT_ROOT/$file" ]; then
        if grep -qE "$pattern" "$PROJECT_ROOT/$file"; then
            pass "$desc"
            return 0
        else
            error "$desc - pattern not found: $pattern"
            return 1
        fi
    fi
    return 1
}

# =============================================================================
# GATE: init - Project initialization
# =============================================================================
validate_init() {
    info "Validating INIT gate..."

    check_dir "docs" "Documentation directory"
    check_dir "docs/discovery" "Discovery directory"
    check_dir "docs/product" "Product directory"
    check_dir "docs/requirements" "Requirements directory"
    check_dir "docs/architecture" "Architecture directory"
    check_file "PROJECT-STATUS.md" "Project status file"
}

# =============================================================================
# GATE: intake - Product intake complete
# =============================================================================
validate_intake() {
    info "Validating INTAKE gate..."

    check_file "PRODUCT-INTAKE.md" "Product intake form"

    if [ -f "$PROJECT_ROOT/PRODUCT-INTAKE.md" ]; then
        check_no_tbd "PRODUCT-INTAKE.md" "Product intake"

        # Check required sections
        check_content "PRODUCT-INTAKE.md" "## Project Name" "Project name defined"
        check_content "PRODUCT-INTAKE.md" "## Problem Statement" "Problem statement defined"
        check_content "PRODUCT-INTAKE.md" "## Target Users" "Target users identified"
    fi
}

# =============================================================================
# GATE 0: Product Design
# =============================================================================
validate_gate_0() {
    info "Validating GATE 0: Product Design..."

    check_file "docs/product/FEATURE-INVENTORY.md" "Feature inventory"
    check_file "docs/product/MVP-SCOPE.md" "MVP scope"
    check_file "docs/product/USER-JOURNEYS.md" "User journeys"

    if [ -f "$PROJECT_ROOT/docs/product/MVP-SCOPE.md" ]; then
        check_no_tbd "docs/product/MVP-SCOPE.md" "MVP scope"
    fi

    # Check feature count (warn if < 20 features for non-trivial apps)
    if [ -f "$PROJECT_ROOT/docs/product/FEATURE-INVENTORY.md" ]; then
        local feature_count=$(grep -cE "^## F-[0-9]+" "$PROJECT_ROOT/docs/product/FEATURE-INVENTORY.md" 2>/dev/null || echo "0")
        if [ "$feature_count" -lt 10 ]; then
            warn "Feature inventory has only $feature_count features (expected 10+)"
        else
            pass "Feature inventory has $feature_count features"
        fi
    fi

    # Check RTM initialization
    check_file "docs/traceability/RTM.md" "Requirements Traceability Matrix"
}

# =============================================================================
# GATE 1: Requirements
# =============================================================================
validate_gate_1() {
    info "Validating GATE 1: Requirements..."

    check_file "docs/requirements/REQUIREMENTS-CATALOGUE.md" "Requirements catalogue"
    check_file "docs/requirements/USER-STORIES.md" "User stories"

    if [ -f "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" ]; then
        # Check for REQ-XXX format
        local req_count=$(grep -cE "^## REQ-[0-9]+" "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" 2>/dev/null || echo "0")
        if [ "$req_count" -eq 0 ]; then
            error "No requirements with REQ-XXX format found"
        else
            pass "Found $req_count requirements with REQ-XXX format"
        fi

        # Check for acceptance criteria
        if grep -qE "Acceptance Criteria" "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md"; then
            pass "Requirements have acceptance criteria"
        else
            error "Requirements missing acceptance criteria"
        fi
    fi

    # RTM should have requirements listed
    if [ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]; then
        if grep -qE "REQ-[0-9]+" "$PROJECT_ROOT/docs/traceability/RTM.md"; then
            pass "RTM contains requirements"
        else
            error "RTM does not contain requirements"
        fi
    fi
}

# =============================================================================
# GATE 2: Architecture + Legal
# =============================================================================
validate_gate_2() {
    info "Validating GATE 2: Architecture + Legal..."

    check_file "docs/architecture/SYSTEM-DESIGN.md" "System design"
    check_file "docs/architecture/CLASS-DIAGRAM.md" "Class diagram"
    check_dir "docs/architecture/ADR" "Architecture Decision Records"

    # Check for TYPE-CONTRACTS.ts (binding contracts)
    if [ -f "$PROJECT_ROOT/src/contracts/TYPE-CONTRACTS.ts" ] || [ -f "$PROJECT_ROOT/contracts/TYPE-CONTRACTS.ts" ] || [ -f "$PROJECT_ROOT/docs/data/TYPE-CONTRACTS.ts" ]; then
        pass "TYPE-CONTRACTS.ts exists"
    else
        error "TYPE-CONTRACTS.ts missing (required from data-engineer)"
    fi

    # Check for API-CONTRACTS.ts
    if [ -f "$PROJECT_ROOT/src/contracts/API-CONTRACTS.ts" ] || [ -f "$PROJECT_ROOT/contracts/API-CONTRACTS.ts" ] || [ -f "$PROJECT_ROOT/docs/api/API-CONTRACTS.ts" ]; then
        pass "API-CONTRACTS.ts exists"
    else
        error "API-CONTRACTS.ts missing (required from api-designer)"
    fi

    # Check for legal docs
    check_file "docs/legal/PRIVACY-POLICY.md" "Privacy policy" || warn "Privacy policy may be required"
    check_file "docs/legal/TERMS.md" "Terms of service" || warn "Terms of service may be required"

    if [ -f "$PROJECT_ROOT/docs/architecture/SYSTEM-DESIGN.md" ]; then
        check_no_tbd "docs/architecture/SYSTEM-DESIGN.md" "System design"
    fi

    # Check RTM has architecture mapping
    if [ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]; then
        if grep -qE "(Component|Architecture|Design)" "$PROJECT_ROOT/docs/traceability/RTM.md"; then
            pass "RTM contains architecture mapping"
        else
            warn "RTM should contain architecture mapping"
        fi
    fi
}

# =============================================================================
# GATE 3: Design + Platform + Observability
# =============================================================================
validate_gate_3() {
    info "Validating GATE 3: Design + Platform + Observability..."

    check_file "docs/design/DESIGN-SYSTEM.md" "Design system"
    check_file "docs/design/COMPONENTS.md" "Component specs"
    check_file "docker-compose.yml" "Docker compose"

    # Check docker-compose actually works
    if [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
        if command -v docker-compose &> /dev/null || command -v docker &> /dev/null; then
            info "Docker compose file exists. Run 'docker-compose up -d' to verify infrastructure."
            # Note: We don't actually run docker-compose in validation, but orchestrator should
        fi
    fi

    # Check for health endpoint definition
    if [ -f "$PROJECT_ROOT/docs/infrastructure/HEALTH-CHECKS.md" ] || \
       grep -rq "health" "$PROJECT_ROOT/docs/api" 2>/dev/null; then
        pass "Health endpoint defined"
    else
        warn "Health endpoint should be defined"
    fi

    # Check for observability docs
    if [ -d "$PROJECT_ROOT/docs/infrastructure" ]; then
        if [ -f "$PROJECT_ROOT/docs/infrastructure/LOGGING.md" ] || \
           [ -f "$PROJECT_ROOT/docs/infrastructure/OBSERVABILITY.md" ]; then
            pass "Observability documentation exists"
        else
            warn "Observability documentation recommended"
        fi
    fi

    # Check design references TYPE-CONTRACTS
    if [ -f "$PROJECT_ROOT/docs/design/COMPONENTS.md" ]; then
        if grep -qE "(TYPE-CONTRACTS|type.*contract)" "$PROJECT_ROOT/docs/design/COMPONENTS.md"; then
            pass "Design references TYPE-CONTRACTS"
        else
            warn "Design should reference TYPE-CONTRACTS field names"
        fi
    fi
}

# =============================================================================
# GATE 4: Implementation
# =============================================================================
validate_gate_4() {
    info "Validating GATE 4: Implementation..."

    # Check source code exists
    if [ -d "$PROJECT_ROOT/src" ] || [ -d "$PROJECT_ROOT/app" ] || [ -d "$PROJECT_ROOT/lib" ]; then
        pass "Source code directory exists"
    else
        error "No source code directory found (src/, app/, or lib/)"
    fi

    # Check for contract imports in code
    local contract_imports=0
    if find "$PROJECT_ROOT" -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" 2>/dev/null | \
       xargs grep -l "TYPE-CONTRACTS\|API-CONTRACTS" 2>/dev/null | head -1 > /dev/null; then
        pass "Contracts imported in source code"
        contract_imports=1
    else
        warn "Contracts not found imported in source code"
    fi

    # Check for tests
    if [ -d "$PROJECT_ROOT/tests" ] || [ -d "$PROJECT_ROOT/__tests__" ] || \
       find "$PROJECT_ROOT" -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | head -1 > /dev/null; then
        pass "Test files exist"
    else
        error "No test files found"
    fi

    # Check RTM has implementation sign-offs
    if [ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]; then
        if grep -qE "(Implemented|Implementation|file:)" "$PROJECT_ROOT/docs/traceability/RTM.md"; then
            pass "RTM contains implementation references"
        else
            warn "RTM should contain implementation references (file:line)"
        fi
    fi

    # Check legal routes if legal docs exist
    if [ -f "$PROJECT_ROOT/docs/legal/PRIVACY-POLICY.md" ]; then
        if find "$PROJECT_ROOT/src" "$PROJECT_ROOT/app" -name "*.ts" -o -name "*.tsx" 2>/dev/null | \
           xargs grep -l "privacy\|Privacy" 2>/dev/null | head -1 > /dev/null; then
            pass "Privacy route appears to be implemented"
        else
            warn "Privacy policy exists but route may not be implemented"
        fi
    fi
}

# =============================================================================
# GATE 5: QA + Accessibility
# =============================================================================
validate_gate_5() {
    info "Validating GATE 5: QA + Accessibility..."

    check_file "docs/qa/TEST-PLAN.md" "Test plan"
    check_file "docs/qa/TEST-RESULTS.md" "Test results"

    # Check for TC-XXX format test cases
    if [ -f "$PROJECT_ROOT/docs/qa/TEST-CASES.md" ] || [ -f "$PROJECT_ROOT/docs/qa/TEST-PLAN.md" ]; then
        local tc_count=$(grep -cE "TC-[0-9]+" "$PROJECT_ROOT/docs/qa/TEST-CASES.md" "$PROJECT_ROOT/docs/qa/TEST-PLAN.md" 2>/dev/null || echo "0")
        if [ "$tc_count" -gt 0 ]; then
            pass "Found $tc_count test case references (TC-XXX)"
        else
            error "No test cases with TC-XXX format found"
        fi
    fi

    # Check defect tracking
    if [ -f "$PROJECT_ROOT/docs/qa/DEFECTS.md" ]; then
        # Check for open Critical/High defects
        if grep -qE "(Critical|High).*Open" "$PROJECT_ROOT/docs/qa/DEFECTS.md" 2>/dev/null; then
            error "Open Critical/High defects found - BLOCKS RELEASE"
        else
            pass "No open Critical/High defects"
        fi
    fi

    # Check RTM has test results
    if [ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]; then
        if grep -qE "(TC-[0-9]+|Pass|Fail|Test)" "$PROJECT_ROOT/docs/traceability/RTM.md"; then
            pass "RTM contains test results"
        else
            error "RTM missing test results"
        fi
    fi

    # Check accessibility review
    if [ -f "$PROJECT_ROOT/docs/qa/ACCESSIBILITY-REPORT.md" ] || \
       grep -rq "WCAG\|accessibility" "$PROJECT_ROOT/docs/qa" 2>/dev/null; then
        pass "Accessibility documentation exists"
    else
        warn "Accessibility review recommended"
    fi

    # Check performance baseline (if defined)
    if [ -f "$PROJECT_ROOT/docs/qa/PERFORMANCE-REPORT.md" ]; then
        pass "Performance report exists"
    else
        warn "Performance baseline documentation recommended"
    fi
}

# =============================================================================
# GATE 6: Release Preparation
# =============================================================================
validate_gate_6() {
    info "Validating GATE 6: Release Preparation..."

    # Security review
    if [ -f "$PROJECT_ROOT/docs/security/SECURITY-REVIEW.md" ]; then
        if grep -qE "(Critical|High).*vulnerability" "$PROJECT_ROOT/docs/security/SECURITY-REVIEW.md" 2>/dev/null; then
            error "Security vulnerabilities found - BLOCKS RELEASE"
        else
            pass "Security review complete, no critical vulnerabilities"
        fi
    else
        error "Security review not documented"
    fi

    # BA validation
    if [ -f "$PROJECT_ROOT/docs/requirements/BA-VALIDATION.md" ] || \
       grep -q "Validation.*Complete\|BA.*Approved" "$PROJECT_ROOT/docs/qa/TEST-RESULTS.md" 2>/dev/null; then
        pass "BA validation complete"
    else
        warn "BA validation should be documented"
    fi

    # Product validation
    if [ -f "$PROJECT_ROOT/docs/product/PRODUCT-VALIDATION.md" ] || \
       grep -q "Product.*Validated\|Design.*Approved" "$PROJECT_ROOT/docs/qa/TEST-RESULTS.md" 2>/dev/null; then
        pass "Product design validation complete"
    else
        warn "Product design validation should be documented"
    fi

    # Changelog
    check_file "CHANGELOG.md" "Changelog"

    # Rollback plan
    if [ -f "$PROJECT_ROOT/docs/infrastructure/ROLLBACK-PLAN.md" ] || \
       grep -rq "rollback\|Rollback" "$PROJECT_ROOT/docs" 2>/dev/null; then
        pass "Rollback plan documented"
    else
        error "Rollback plan required before release"
    fi

    # Version tag check
    if command -v git &> /dev/null && [ -d "$PROJECT_ROOT/.git" ]; then
        local latest_tag=$(git -C "$PROJECT_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "none")
        if [ "$latest_tag" != "none" ]; then
            pass "Version tagged: $latest_tag"
        else
            warn "No version tag found"
        fi
    fi

    # Project chronicle
    if [ -f "$PROJECT_ROOT/docs/chronicles/PROJECT-CHRONICLE.html" ] || \
       [ -f "$PROJECT_ROOT/docs/chronicles/PROJECT-CHRONICLE.md" ]; then
        pass "Project chronicle generated"
    else
        warn "Project chronicle recommended"
    fi
}

# =============================================================================
# Main validation logic
# =============================================================================

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Gate Validation: $GATE${NC}"
echo -e "${BLUE}  Project Root: $PROJECT_ROOT${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

case $GATE in
    init)
        validate_init
        ;;
    intake)
        validate_intake
        ;;
    0)
        validate_gate_0
        ;;
    1)
        validate_gate_1
        ;;
    2)
        validate_gate_2
        ;;
    3)
        validate_gate_3
        ;;
    4)
        validate_gate_4
        ;;
    5)
        validate_gate_5
        ;;
    6)
        validate_gate_6
        ;;
    all)
        validate_init
        echo ""
        validate_intake
        echo ""
        validate_gate_0
        echo ""
        validate_gate_1
        echo ""
        validate_gate_2
        echo ""
        validate_gate_3
        echo ""
        validate_gate_4
        echo ""
        validate_gate_5
        echo ""
        validate_gate_6
        ;;
    *)
        echo -e "${RED}Unknown gate: $GATE${NC}"
        echo "Valid gates: init, intake, 0, 1, 2, 3, 4, 5, 6, all"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Errors:   ${RED}$ERRORS${NC}"
echo -e "  Warnings: ${YELLOW}$WARNINGS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo -e "${RED}GATE FAILED${NC} - Fix $ERRORS error(s) before proceeding"
    exit 1
else
    echo ""
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}GATE PASSED WITH WARNINGS${NC} - Review $WARNINGS warning(s)"
    else
        echo -e "${GREEN}GATE PASSED${NC}"
    fi
    exit 0
fi
