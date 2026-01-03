#!/bin/bash
# Gate Validation Script - Deterministic enforcement for project-orchestrator
# Usage: ./validate-gate.sh <gate-number> [project-root]
# Exit 0 = PASS, Exit 1 = BLOCKED

set -euo pipefail

GATE="${1:-}"
PROJECT_ROOT="${2:-.}"
ERRORS=0
WARNINGS=0

red() { echo -e "\033[0;31m$1\033[0m"; }
green() { echo -e "\033[0;32m$1\033[0m"; }
yellow() { echo -e "\033[0;33m$1\033[0m"; }

fail() { red "FAIL: $1"; ((ERRORS++)); }
warn() { yellow "WARN: $1"; ((WARNINGS++)); }
pass() { green "PASS: $1"; }

check_file() {
  [[ -f "$PROJECT_ROOT/$1" ]] && pass "$1 exists" || fail "$1 missing"
}

check_dir() {
  [[ -d "$PROJECT_ROOT/$1" ]] && pass "$1/ exists" || fail "$1/ missing"
}

count_pattern() {
  local file="$PROJECT_ROOT/$1"
  local pattern="$2"
  local min="$3"
  local label="$4"

  if [[ -f "$file" ]]; then
    local count=$(grep -cE "$pattern" "$file" 2>/dev/null || echo 0)
    if [[ $count -ge $min ]]; then
      pass "$label: $count (min: $min)"
    else
      fail "$label: $count (min: $min)"
    fi
  else
    fail "$file not found for $label check"
  fi
}

check_no_tbd() {
  local file="$PROJECT_ROOT/$1"
  if [[ -f "$file" ]]; then
    if grep -qiE "TBD|TODO|FIXME|XXX" "$file" 2>/dev/null; then
      fail "$1 contains TBD/TODO markers"
    else
      pass "$1 has no TBD markers"
    fi
  fi
}

# ============================================================
# GATE DEFINITIONS
# ============================================================

gate_init() {
  echo "=== GATE INIT: Project Structure ==="
  check_dir "docs"
  check_file "PROJECT-STATUS.md"
  check_dir "docs/discovery"
  check_dir "docs/product"
  check_dir "docs/requirements"
  check_dir "docs/architecture"
}

gate_0() {
  echo "=== GATE 0: Product Design Complete ==="

  # Required files
  check_file "docs/product/FEATURE-INVENTORY.md"
  check_file "docs/product/MVP-SCOPE.md"
  check_file "docs/product/PRODUCT-VISION.md"
  check_file "docs/experience/USER-JOURNEYS.md"

  # Feature count (minimum 30 for any app, 50 for auth apps)
  count_pattern "docs/product/FEATURE-INVENTORY.md" "^-?\s*F-[0-9]+" 30 "Features defined"

  # MVP scope has must-have items
  count_pattern "docs/product/MVP-SCOPE.md" "Must-Have|MUST|Priority.*1|P1" 1 "Must-have priorities"

  # User journeys exist
  count_pattern "docs/experience/USER-JOURNEYS.md" "^#.*Journey|^##.*Journey" 3 "User journeys"

  # No TBDs in locked scope
  check_no_tbd "docs/product/MVP-SCOPE.md"
}

gate_1() {
  echo "=== GATE 1: Requirements Complete ==="

  # Required files
  check_file "docs/requirements/REQUIREMENTS-CATALOGUE.md"

  # Requirements have IDs
  count_pattern "docs/requirements/REQUIREMENTS-CATALOGUE.md" "REQ-[0-9]+" 10 "Requirements with IDs"

  # Requirements have acceptance criteria
  if [[ -f "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" ]]; then
    local reqs=$(grep -cE "REQ-[0-9]+" "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" || echo 0)
    local criteria=$(grep -ciE "acceptance|criteria|given.*when.*then|verify" "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" || echo 0)
    if [[ $criteria -ge $((reqs / 2)) ]]; then
      pass "Acceptance criteria present: $criteria"
    else
      fail "Acceptance criteria sparse: $criteria for $reqs requirements"
    fi
  fi

  # No ambiguous language
  if [[ -f "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" ]]; then
    local ambiguous=$(grep -ciE "should be able|might|maybe|possibly|TBD|somehow" "$PROJECT_ROOT/docs/requirements/REQUIREMENTS-CATALOGUE.md" || echo 0)
    if [[ $ambiguous -eq 0 ]]; then
      pass "No ambiguous language"
    else
      warn "Ambiguous language found: $ambiguous instances"
    fi
  fi

  check_no_tbd "docs/requirements/REQUIREMENTS-CATALOGUE.md"
}

gate_2() {
  echo "=== GATE 2: Architecture Complete ==="

  # Required files
  check_file "docs/architecture/SYSTEM-DESIGN.md"
  check_dir "docs/architecture/ADR"

  # At least one ADR
  local adr_count=$(find "$PROJECT_ROOT/docs/architecture/ADR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  if [[ $adr_count -ge 1 ]]; then
    pass "ADRs documented: $adr_count"
  else
    fail "No ADRs found in docs/architecture/ADR/"
  fi

  # Data model exists
  if grep -qiE "data model|schema|entity|ERD|database" "$PROJECT_ROOT/docs/architecture/SYSTEM-DESIGN.md" 2>/dev/null; then
    pass "Data model referenced"
  else
    fail "No data model in SYSTEM-DESIGN.md"
  fi

  # API contracts exist
  if grep -qiE "API|endpoint|REST|GraphQL|contract" "$PROJECT_ROOT/docs/architecture/SYSTEM-DESIGN.md" 2>/dev/null; then
    pass "API contracts referenced"
  else
    fail "No API contracts in SYSTEM-DESIGN.md"
  fi

  # Security model exists
  if grep -qiE "security|auth|permission|role|access control" "$PROJECT_ROOT/docs/architecture/SYSTEM-DESIGN.md" 2>/dev/null; then
    pass "Security model referenced"
  else
    fail "No security model in SYSTEM-DESIGN.md"
  fi

  # TYPE CONTRACTS - Binding contract from data-engineer
  if [[ -f "$PROJECT_ROOT/docs/data/TYPE-CONTRACTS.ts" ]]; then
    pass "TYPE-CONTRACTS.ts exists (data-engineer output)"
    # Check it has interface definitions
    if grep -qE "export interface" "$PROJECT_ROOT/docs/data/TYPE-CONTRACTS.ts" 2>/dev/null; then
      pass "TYPE-CONTRACTS.ts has interface definitions"
    else
      fail "TYPE-CONTRACTS.ts missing interface definitions"
    fi
  else
    fail "docs/data/TYPE-CONTRACTS.ts missing - data-engineer must generate this"
  fi

  # API CONTRACTS - Binding contract from api-designer
  if [[ -f "$PROJECT_ROOT/docs/api/API-CONTRACTS.ts" ]]; then
    pass "API-CONTRACTS.ts exists (api-designer output)"
    # Check it has interface definitions
    if grep -qE "export interface" "$PROJECT_ROOT/docs/api/API-CONTRACTS.ts" 2>/dev/null; then
      pass "API-CONTRACTS.ts has interface definitions"
    else
      fail "API-CONTRACTS.ts missing interface definitions"
    fi
  else
    fail "docs/api/API-CONTRACTS.ts missing - api-designer must generate this"
  fi

  check_no_tbd "docs/architecture/SYSTEM-DESIGN.md"
}

gate_3() {
  echo "=== GATE 3: Design + Infrastructure Ready ==="

  # Design artifacts
  check_dir "docs/design"

  # Infrastructure files
  if [[ -f "$PROJECT_ROOT/docker-compose.yml" ]] || [[ -f "$PROJECT_ROOT/docker-compose.yaml" ]]; then
    pass "docker-compose exists"
  else
    warn "No docker-compose.yml (may not be required)"
  fi

  check_file ".env.example"

  # README has setup instructions
  if [[ -f "$PROJECT_ROOT/README.md" ]]; then
    if grep -qiE "setup|install|getting started|quickstart" "$PROJECT_ROOT/README.md" 2>/dev/null; then
      pass "README has setup instructions"
    else
      fail "README missing setup instructions"
    fi
  else
    fail "README.md missing"
  fi

  # Test infrastructure exists
  if [[ -d "$PROJECT_ROOT/tests" ]] || [[ -d "$PROJECT_ROOT/__tests__" ]] || [[ -d "$PROJECT_ROOT/test" ]]; then
    pass "Test directory exists"
  else
    fail "No test directory found"
  fi
}

gate_4() {
  echo "=== GATE 4: Implementation Complete ==="

  # RTM exists and is populated
  check_file "docs/traceability/RTM.md"

  if [[ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]]; then
    # Check for sign-offs
    local signoffs=$(grep -ciE "✓|done|complete|implemented|pass" "$PROJECT_ROOT/docs/traceability/RTM.md" || echo 0)
    if [[ $signoffs -ge 5 ]]; then
      pass "RTM has sign-offs: $signoffs"
    else
      fail "RTM sign-offs insufficient: $signoffs"
    fi
  fi

  # Source code exists
  if [[ -d "$PROJECT_ROOT/src" ]] || [[ -d "$PROJECT_ROOT/app" ]] || [[ -d "$PROJECT_ROOT/lib" ]]; then
    pass "Source directory exists"
  else
    fail "No source directory (src/, app/, or lib/)"
  fi

  # Package file exists
  if [[ -f "$PROJECT_ROOT/package.json" ]] || [[ -f "$PROJECT_ROOT/requirements.txt" ]] || [[ -f "$PROJECT_ROOT/pyproject.toml" ]] || [[ -f "$PROJECT_ROOT/Cargo.toml" ]] || [[ -f "$PROJECT_ROOT/go.mod" ]]; then
    pass "Package manifest exists"
  else
    warn "No package manifest found"
  fi

  # CONTRACT USAGE VERIFICATION
  # Check that source code imports from contracts
  local src_dir=""
  [[ -d "$PROJECT_ROOT/src" ]] && src_dir="$PROJECT_ROOT/src"
  [[ -d "$PROJECT_ROOT/app" ]] && src_dir="$PROJECT_ROOT/app"

  if [[ -n "$src_dir" ]]; then
    # Check for contract imports in TypeScript/JavaScript files
    local contract_imports=$(grep -rE "from.*['\"].*contracts|from.*['\"].*TYPE-CONTRACTS|from.*['\"].*API-CONTRACTS" "$src_dir" 2>/dev/null | wc -l | tr -d ' ')
    if [[ $contract_imports -ge 1 ]]; then
      pass "Contract imports found: $contract_imports files"
    else
      warn "No contract imports found - verify developer is using TYPE-CONTRACTS.ts and API-CONTRACTS.ts"
    fi

    # Check for contract types copied to src
    if [[ -f "$src_dir/types/contracts.ts" ]] || [[ -f "$src_dir/contracts/index.ts" ]] || [[ -d "$src_dir/types" ]]; then
      pass "Contract types directory exists in source"
    else
      warn "No types/contracts directory in source - ensure contracts are imported"
    fi
  fi
}

gate_5() {
  echo "=== GATE 5: QA + Release Ready ==="

  # Test results exist
  check_file "docs/qa/TEST-RESULTS.md"

  # No critical defects
  if [[ -f "$PROJECT_ROOT/docs/qa/TEST-RESULTS.md" ]]; then
    local critical=$(grep -ciE "critical|blocker|P0|severity.*1" "$PROJECT_ROOT/docs/qa/TEST-RESULTS.md" || echo 0)
    local resolved=$(grep -ciE "resolved|fixed|closed" "$PROJECT_ROOT/docs/qa/TEST-RESULTS.md" || echo 0)
    if [[ $critical -eq 0 ]] || [[ $resolved -ge $critical ]]; then
      pass "No unresolved critical defects"
    else
      fail "Critical defects unresolved: $critical found, $resolved resolved"
    fi
  fi

  # Security review done
  if [[ -f "$PROJECT_ROOT/docs/qa/SECURITY-REVIEW.md" ]]; then
    pass "Security review documented"
  else
    warn "No SECURITY-REVIEW.md (may be inline)"
  fi

  # All RTM items signed off
  if [[ -f "$PROJECT_ROOT/docs/traceability/RTM.md" ]]; then
    local total=$(grep -cE "REQ-[0-9]+" "$PROJECT_ROOT/docs/traceability/RTM.md" || echo 0)
    local complete=$(grep -cE "REQ-[0-9]+.*✓|REQ-[0-9]+.*complete|REQ-[0-9]+.*done" "$PROJECT_ROOT/docs/traceability/RTM.md" || echo 0)
    if [[ $total -gt 0 ]] && [[ $complete -ge $total ]]; then
      pass "RTM 100% complete: $complete/$total"
    else
      fail "RTM incomplete: $complete/$total"
    fi
  fi
}

# ============================================================
# MAIN
# ============================================================

if [[ -z "$GATE" ]]; then
  echo "Usage: $0 <gate> [project-root]"
  echo "Gates: init, 0, 1, 2, 3, 4, 5, all"
  exit 1
fi

cd "$PROJECT_ROOT" 2>/dev/null || { red "Cannot access $PROJECT_ROOT"; exit 1; }

echo ""
echo "Project: $(pwd)"
echo "Validating: Gate $GATE"
echo "========================================"
echo ""

case "$GATE" in
  init) gate_init ;;
  0) gate_0 ;;
  1) gate_1 ;;
  2) gate_2 ;;
  3) gate_3 ;;
  4) gate_4 ;;
  5) gate_5 ;;
  all)
    gate_init
    echo ""
    gate_0
    echo ""
    gate_1
    echo ""
    gate_2
    echo ""
    gate_3
    echo ""
    gate_4
    echo ""
    gate_5
    ;;
  *) red "Unknown gate: $GATE"; exit 1 ;;
esac

echo ""
echo "========================================"
if [[ $ERRORS -gt 0 ]]; then
  red "GATE $GATE: BLOCKED ($ERRORS errors, $WARNINGS warnings)"
  exit 1
else
  if [[ $WARNINGS -gt 0 ]]; then
    yellow "GATE $GATE: PASS WITH WARNINGS ($WARNINGS warnings)"
  else
    green "GATE $GATE: PASS"
  fi
  exit 0
fi
