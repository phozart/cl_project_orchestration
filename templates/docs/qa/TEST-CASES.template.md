# Test Cases: {{PROJECT_NAME}}

## Overview
| Metric | Count |
|--------|-------|
| Total Test Cases | {{TOTAL}} |
| Automated | {{AUTOMATED}} |
| Manual | {{MANUAL}} |
| Passed | {{PASSED}} |
| Failed | {{FAILED}} |
| Pending | {{PENDING}} |

---

## Test Case Summary by Feature

| Feature | Test Cases | Passed | Failed | Pending |
|---------|------------|--------|--------|---------|
| F-001: {{Feature}} | 5 | 3 | 1 | 1 |
| F-002: {{Feature}} | 3 | 2 | 0 | 1 |

---

## Test Cases

### TC-001: {{TEST_CASE_TITLE}}

| Field | Value |
|-------|-------|
| **ID** | TC-001 |
| **Feature** | F-001 |
| **Requirement** | REQ-001 |
| **Priority** | High / Medium / Low |
| **Type** | Functional / UI / API / Security |
| **Automation** | Automated / Manual |

**Preconditions**:
- {{PRECONDITION_1}}
- {{PRECONDITION_2}}

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | {{ACTION_1}} | {{EXPECTED_1}} |
| 2 | {{ACTION_2}} | {{EXPECTED_2}} |
| 3 | {{ACTION_3}} | {{EXPECTED_3}} |

**Test Data**:
- {{TEST_DATA_1}}
- {{TEST_DATA_2}}

**Execution**:
| Run | Date | Tester | Result | Notes |
|-----|------|--------|--------|-------|
| 1 | {{DATE}} | {{TESTER}} | Pass/Fail | {{NOTES}} |

---

### TC-002: {{TEST_CASE_TITLE}}

| Field | Value |
|-------|-------|
| **ID** | TC-002 |
| **Feature** | F-001 |
| **Requirement** | REQ-001 |
| **Priority** | High |
| **Type** | Functional |

**Preconditions**:
- User is logged in

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | {{ACTION_1}} | {{EXPECTED_1}} |

**Execution**:
| Run | Date | Tester | Result | Notes |
|-----|------|--------|--------|-------|
| 1 | | | Pending | |

---

## Authentication Test Cases

### TC-AUTH-001: Successful Login

| Field | Value |
|-------|-------|
| **Feature** | F-xxx: User Login |
| **Requirement** | REQ-xxx |
| **Priority** | High |

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form displayed |
| 2 | Enter valid email | Email accepted |
| 3 | Enter valid password | Password field filled |
| 4 | Click Login button | Redirected to dashboard |

### TC-AUTH-002: Invalid Credentials

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter invalid email/password | Error message displayed |
| 2 | Verify no redirect | Remains on login page |

### TC-AUTH-003: Password Reset

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click "Forgot Password" | Reset form displayed |
| 2 | Enter email | Confirmation shown |
| 3 | Check email | Reset link received |
| 4 | Click reset link | Password form displayed |
| 5 | Enter new password | Password updated |

---

## API Test Cases

### TC-API-001: GET {{Resource}} List

| Field | Value |
|-------|-------|
| **Endpoint** | GET /api/{{resources}} |
| **Auth** | Required |

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Send GET request with valid token | 200 OK, list returned |
| 2 | Send GET request without token | 401 Unauthorized |
| 3 | Send GET request with invalid token | 401 Unauthorized |

---

## Edge Cases

### TC-EDGE-001: Empty State

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View page with no data | Empty state message shown |

### TC-EDGE-002: Maximum Input

**Test Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter max length input | Accepted or truncated |

---

## Traceability

| Test Case | Requirement | Feature | Result |
|-----------|-------------|---------|--------|
| TC-001 | REQ-001 | F-001 | ⏳ |
| TC-002 | REQ-001 | F-001 | ⏳ |
| TC-003 | REQ-002 | F-002 | ⏳ |
