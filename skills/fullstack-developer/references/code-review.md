# Code Review Checklist

## Before Requesting Review

- [ ] Code compiles without errors
- [ ] All tests pass locally
- [ ] Linting passes (`npm run lint`)
- [ ] Type checking passes (`npm run type-check`)
- [ ] Self-reviewed the diff
- [ ] RTM updated with implementation references

## Review Categories

### 1. Contract Compliance

| Check | Pass/Fail |
|-------|-----------|
| Uses exact field names from TYPE-CONTRACTS.ts | |
| Uses exact function names from API-CONTRACTS.ts | |
| No invented field names | |
| No invented function names | |
| Types imported from contracts | |

```typescript
// ✅ PASS
import { User } from '@/types/contracts';
const user: User = { id: '...', email: '...', displayName: '...' };

// ❌ FAIL
const user = { userId: '...', userEmail: '...' }; // Wrong names
```

### 2. Error Handling

| Check | Pass/Fail |
|-------|-----------|
| All async operations have try/catch | |
| Errors are not swallowed silently | |
| User-facing error messages are helpful | |
| Error states are rendered in UI | |
| API errors return proper status codes | |

```typescript
// ✅ PASS
try {
  await createUser(data);
} catch (error) {
  if (error instanceof ValidationError) {
    showToast({ type: 'error', message: error.message });
  } else {
    showToast({ type: 'error', message: 'Failed to create user' });
    console.error('Create user failed:', error);
  }
}

// ❌ FAIL
try {
  await createUser(data);
} catch {
  // Silent failure
}
```

### 3. Security

| Check | Pass/Fail |
|-------|-----------|
| No secrets in code | |
| User input is validated | |
| SQL queries are parameterized | |
| Authentication checked on protected routes | |
| Authorization verified before actions | |
| No XSS vulnerabilities (dangerouslySetInnerHTML) | |

```typescript
// ✅ PASS - Parameterized query
const user = await db.query('SELECT * FROM users WHERE id = $1', [userId]);

// ❌ FAIL - SQL injection vulnerability
const user = await db.query(`SELECT * FROM users WHERE id = '${userId}'`);
```

### 4. Performance

| Check | Pass/Fail |
|-------|-----------|
| No N+1 queries | |
| Large lists are paginated | |
| Images are optimized/lazy loaded | |
| Expensive computations are memoized | |
| No unnecessary re-renders | |
| API responses are reasonably sized | |

```typescript
// ✅ PASS - Memoized expensive computation
const sortedUsers = useMemo(
  () => users.sort((a, b) => a.name.localeCompare(b.name)),
  [users]
);

// ❌ FAIL - Recomputes on every render
const sortedUsers = users.sort((a, b) => a.name.localeCompare(b.name));
```

### 5. Testing

| Check | Pass/Fail |
|-------|-----------|
| Unit tests for business logic | |
| Integration tests for API endpoints | |
| Edge cases covered | |
| Error paths tested | |
| Test descriptions are clear | |

```typescript
// ✅ PASS - Clear test with edge case
describe('validateEmail', () => {
  it('rejects email without @ symbol', () => {
    expect(validateEmail('invalid')).toBe(false);
  });

  it('accepts valid email with subdomain', () => {
    expect(validateEmail('user@mail.example.com')).toBe(true);
  });
});
```

### 6. Code Quality

| Check | Pass/Fail |
|-------|-----------|
| No duplicate code (DRY) | |
| Functions are single-purpose | |
| Variable names are descriptive | |
| Comments explain "why", not "what" | |
| No magic numbers/strings | |
| Consistent formatting | |

```typescript
// ✅ PASS - Named constant
const MAX_LOGIN_ATTEMPTS = 5;
if (attempts >= MAX_LOGIN_ATTEMPTS) {
  lockAccount();
}

// ❌ FAIL - Magic number
if (attempts >= 5) {
  lockAccount();
}
```

### 7. UI/UX

| Check | Pass/Fail |
|-------|-----------|
| Loading states shown | |
| Error states shown | |
| Empty states shown | |
| Form validation feedback | |
| Accessible (keyboard nav, aria labels) | |
| Responsive design | |

```tsx
// ✅ PASS - All states handled
function UserList() {
  const { data, isLoading, error } = useUsers();

  if (isLoading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  if (data.length === 0) return <EmptyState message="No users found" />;

  return <ul>{data.map(user => <UserCard key={user.id} user={user} />)}</ul>;
}

// ❌ FAIL - Missing states
function UserList() {
  const { data } = useUsers();
  return <ul>{data.map(user => <UserCard key={user.id} user={user} />)}</ul>;
}
```

## Review Feedback Format

### Blocking Issues (Must Fix)

```
🚫 BLOCKING: SQL injection vulnerability in user query
File: src/api/users.ts:45
Issue: User input directly interpolated into SQL query
Fix: Use parameterized query with $1 placeholder
```

### Suggestions (Should Consider)

```
💡 SUGGESTION: Consider memoizing this expensive filter
File: src/components/UserList.tsx:23
Reason: This filter runs on every render, could impact performance with large lists
```

### Nitpicks (Optional)

```
📝 NITPICK: Typo in variable name "recieve" → "receive"
File: src/hooks/useNotifications.ts:12
```

## Review Response

When receiving feedback:

1. **Address all blocking issues** before re-requesting review
2. **Respond to each comment** - either fix or explain why not
3. **Don't take it personally** - code review improves code quality
4. **Ask questions** if feedback is unclear

## Approval Criteria

Code is approved when:

- [ ] All blocking issues resolved
- [ ] Contract compliance verified
- [ ] Tests pass
- [ ] No security vulnerabilities
- [ ] RTM updated
