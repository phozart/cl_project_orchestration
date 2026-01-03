# Test Automation Patterns

## Test Pyramid

```
           /\
          /E2E\           <- 10-20 tests: Critical user journeys
         /──────\
        /Integration\      <- 50-100 tests: API, component interactions
       /──────────────\
      /   Unit Tests   \   <- 200+ tests: Functions, utilities, logic
     /────────────────────\
```

**Rule: If it can be tested lower in the pyramid, test it there.**

---

## E2E Tests (Playwright)

### Basic Pattern

```typescript
// tests/e2e/auth/signup.spec.ts
/**
 * @requirement REQ-001 User signup
 * @priority Must
 */
test.describe('User Signup Journey', () => {
  test('user can complete full signup flow', async ({ page }) => {
    // @covers REQ-001, REQ-005
    await page.goto('/signup');
    await page.fill('[name="email"]', 'newuser@example.com');
    await page.fill('[name="password"]', 'SecurePass123!');
    await page.click('button[type="submit"]');
    await expect(page.getByText('Check your email')).toBeVisible();
  });
});
```

### Page Object Model

```typescript
// tests/e2e/pages/LoginPage.ts
export class LoginPage {
  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.locator('[name="email"]');
    this.passwordInput = page.locator('[name="password"]');
    this.submitButton = page.locator('button[type="submit"]');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.page.getByText(message)).toBeVisible();
  }
}
```

### Test Data Management

```typescript
// tests/fixtures/users.ts
export const testUsers = {
  admin: {
    email: 'admin@test.com',
    password: 'AdminPass123!',
    role: 'admin'
  },
  regular: {
    email: 'user@test.com',
    password: 'UserPass123!',
    role: 'user'
  }
};
```

---

## Integration Tests

### API Testing Pattern

```typescript
// tests/integration/api/users.test.ts
/** @requirement REQ-010 User API */
describe('Users API', () => {
  let client: APIClient;
  let authToken: string;

  beforeAll(async () => {
    authToken = await getTestToken();
    client = new APIClient({ token: authToken });
  });

  it('creates a new user with valid data', async () => {
    const response = await client.post('/api/users', {
      email: 'new@example.com',
      password: 'SecurePass123!'
    });
    expect(response.status).toBe(201);
    expect(response.data.id).toBeDefined();
  });

  /** @covers REQ-020 (RBAC) */
  it('regular user cannot access other user details', async () => {
    const response = await client.get(`/api/users/${otherUserId}`);
    expect(response.status).toBe(403);
  });

  /** @covers REQ-015 (Validation) */
  it('rejects invalid email format', async () => {
    const response = await client.post('/api/users', {
      email: 'not-an-email',
      password: 'SecurePass123!'
    });
    expect(response.status).toBe(400);
    expect(response.data.errors).toContain('Invalid email format');
  });
});
```

---

## Unit Tests

### Function Testing

```typescript
// tests/unit/utils/validation.test.ts
describe('validateEmail', () => {
  it('accepts valid email formats', () => {
    expect(validateEmail('user@example.com')).toBe(true);
    expect(validateEmail('user.name@example.co.uk')).toBe(true);
  });

  it('rejects invalid email formats', () => {
    expect(validateEmail('not-an-email')).toBe(false);
    expect(validateEmail('@example.com')).toBe(false);
    expect(validateEmail('user@')).toBe(false);
  });

  it('handles edge cases', () => {
    expect(validateEmail('')).toBe(false);
    expect(validateEmail(null)).toBe(false);
    expect(validateEmail(undefined)).toBe(false);
  });
});
```

---

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test:unit
      - run: npm run test:integration
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
```

---

## Requirement Tracing

Always trace tests to requirements:

```typescript
/**
 * @requirement REQ-XXX
 * @covers REQ-XXX, REQ-YYY
 * @priority Must|Should|Could
 */
```

This enables:
- Coverage reports by requirement
- Gap analysis (requirements without tests)
- Impact analysis (which tests to run for a requirement change)
