# Code Standards

## TypeScript Standards

### Type Safety

```typescript
// ✅ CORRECT - Explicit types, no any
interface User {
  id: string;
  email: string;
  displayName: string;
}

function getUser(id: string): Promise<User> {
  return api.get(`/users/${id}`);
}

// ❌ WRONG - Using any
function getUser(id: any): Promise<any> {
  return api.get(`/users/${id}`);
}
```

### Null Handling

```typescript
// ✅ CORRECT - Explicit null checks
function getUserEmail(user: User | null): string {
  if (!user) {
    throw new Error('User not found');
  }
  return user.email;
}

// ✅ CORRECT - Optional chaining with fallback
const email = user?.email ?? 'unknown@example.com';

// ❌ WRONG - Ignoring null possibility
const email = user.email; // Will crash if user is null
```

### Async/Await

```typescript
// ✅ CORRECT - Proper error handling
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    if (error instanceof ApiError && error.status === 404) {
      throw new UserNotFoundError(id);
    }
    throw error;
  }
}

// ❌ WRONG - Swallowing errors
async function fetchUser(id: string): Promise<User | null> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch {
    return null; // Hides the actual error
  }
}
```

### Imports

```typescript
// ✅ CORRECT - Organized imports
// 1. External libraries
import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';

// 2. Internal modules (absolute paths)
import { Button } from '@/components/ui/Button';
import { useAuth } from '@/hooks/useAuth';

// 3. Types
import type { User } from '@/types/contracts';

// 4. Relative imports (same feature)
import { UserAvatar } from './UserAvatar';
```

## React Standards

### Component Structure

```typescript
// ✅ CORRECT - Clean component structure
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  // 1. Hooks first
  const [isEditing, setIsEditing] = useState(false);

  // 2. Derived state
  const displayName = user.displayName || user.email;

  // 3. Effects
  useEffect(() => {
    // Effect logic
  }, [user.id]);

  // 4. Event handlers
  const handleEdit = () => {
    setIsEditing(true);
    onEdit?.(user);
  };

  // 5. Render
  return (
    <div className="user-card">
      <span>{displayName}</span>
      <button onClick={handleEdit}>Edit</button>
    </div>
  );
}
```

### State Management

```typescript
// ✅ CORRECT - Colocate state, lift only when needed
function UserList() {
  const [selectedId, setSelectedId] = useState<string | null>(null);

  return (
    <div>
      {users.map(user => (
        <UserCard
          key={user.id}
          user={user}
          isSelected={user.id === selectedId}
          onSelect={() => setSelectedId(user.id)}
        />
      ))}
    </div>
  );
}

// ❌ WRONG - Global state for local concern
const useGlobalStore = create((set) => ({
  selectedUserId: null, // Should be local state
}));
```

### Custom Hooks

```typescript
// ✅ CORRECT - Encapsulate logic in hooks
function useUser(id: string) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', id],
    queryFn: () => api.getUser(id),
  });

  return { user: data, isLoading, error };
}

// Usage
function UserProfile({ id }: { id: string }) {
  const { user, isLoading, error } = useUser(id);

  if (isLoading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  return <UserCard user={user} />;
}
```

## Python Standards

### Type Hints

```python
# ✅ CORRECT - Full type hints
from typing import Optional, List
from pydantic import BaseModel

class User(BaseModel):
    id: str
    email: str
    display_name: str

async def get_user(user_id: str) -> Optional[User]:
    """Fetch user by ID."""
    result = await db.users.find_one({"id": user_id})
    return User(**result) if result else None

# ❌ WRONG - No type hints
async def get_user(user_id):
    result = await db.users.find_one({"id": user_id})
    return result
```

### FastAPI Patterns

```python
# ✅ CORRECT - Proper FastAPI structure
from fastapi import APIRouter, HTTPException, Depends
from typing import List

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: str,
    db: Database = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> UserResponse:
    """Get user by ID."""
    user = await db.users.find_one({"id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse(**user)
```

### Error Handling

```python
# ✅ CORRECT - Specific exceptions
class UserNotFoundError(Exception):
    def __init__(self, user_id: str):
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")

async def get_user(user_id: str) -> User:
    user = await db.users.find_one({"id": user_id})
    if not user:
        raise UserNotFoundError(user_id)
    return User(**user)

# ❌ WRONG - Generic exceptions
async def get_user(user_id: str) -> User:
    user = await db.users.find_one({"id": user_id})
    if not user:
        raise Exception("Not found")  # Too generic
    return user
```

## Naming Conventions

| Context | Convention | Example |
|---------|------------|---------|
| React components | PascalCase | `UserCard`, `LoginForm` |
| React hooks | camelCase, use prefix | `useAuth`, `useUser` |
| TypeScript interfaces | PascalCase | `User`, `ApiResponse` |
| TypeScript types | PascalCase | `UserId`, `EmailAddress` |
| Functions/methods | camelCase | `getUser`, `handleSubmit` |
| Constants | SCREAMING_SNAKE | `MAX_RETRIES`, `API_URL` |
| Python functions | snake_case | `get_user`, `create_order` |
| Python classes | PascalCase | `UserService`, `OrderHandler` |
| Database columns | snake_case | `created_at`, `user_id` |
| API endpoints | kebab-case | `/api/v1/user-profiles` |
| Files (TS/React) | PascalCase for components | `UserCard.tsx` |
| Files (Python) | snake_case | `user_service.py` |

## File Organization

```
src/
├── components/
│   ├── ui/              # Reusable UI components
│   │   ├── Button.tsx
│   │   └── Input.tsx
│   └── features/        # Feature-specific components
│       └── users/
│           ├── UserCard.tsx
│           └── UserList.tsx
├── hooks/
│   ├── useAuth.ts
│   └── useUser.ts
├── lib/
│   ├── api.ts           # API client
│   └── utils.ts         # Utility functions
├── types/
│   └── contracts.ts     # TYPE-CONTRACTS.ts copy
└── pages/               # Route components
    └── users/
        └── [id].tsx
```

## Import from Contracts

```typescript
// ✅ CORRECT - Import from contracts
import { User, UserFields } from '@/types/contracts';
import { getUsers, createUser } from '@/api/contracts';

// Use contract types everywhere
const user: User = await createUser(formData);

// ❌ WRONG - Define own types
interface User {
  userId: string;  // Wrong! Contract says 'id'
  userName: string; // Wrong! Contract says 'displayName'
}
```
