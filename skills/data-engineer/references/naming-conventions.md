# Naming Conventions

## Database vs Code Naming

| Context | Convention | Example |
|---------|------------|---------|
| Database columns | snake_case | `created_at`, `user_id` |
| TypeScript fields | camelCase | `createdAt`, `userId` |
| Database tables | snake_case, plural | `users`, `order_items` |
| TypeScript interfaces | PascalCase, singular | `User`, `OrderItem` |

## Mapping Rules

### Automatic Conversion

TYPE-CONTRACTS.ts handles the mapping:

```typescript
// Database schema (snake_case)
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

// TypeScript interface (camelCase)
export interface User {
  id: string;
  email: string;
  passwordHash: string;      // ← Mapped from password_hash
  displayName: string;       // ← Mapped from display_name
  createdAt: Date;           // ← Mapped from created_at
  updatedAt: Date;           // ← Mapped from updated_at
}

// Field name constants (for ORM/queries)
export const UserFields = {
  id: 'id',
  email: 'email',
  passwordHash: 'password_hash',   // ← DB column name
  displayName: 'display_name',      // ← DB column name
  createdAt: 'created_at',
  updatedAt: 'updated_at',
} as const;
```

## Database Naming Rules

### Tables

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Plural nouns | `users` | `user` |
| snake_case | `order_items` | `orderItems` |
| No prefixes | `users` | `tbl_users` |
| Descriptive | `user_sessions` | `sessions` |

### Columns

| Rule | Correct | Incorrect |
|------|---------|-----------|
| snake_case | `created_at` | `createdAt` |
| No abbreviations | `description` | `desc` |
| Boolean prefix | `is_active` | `active` |
| Foreign key suffix | `user_id` | `user` |
| Timestamp suffix | `created_at` | `created` |

### Common Column Names

| Concept | Column Name |
|---------|-------------|
| Primary key | `id` |
| Foreign key | `{table}_id` (e.g., `user_id`) |
| Created timestamp | `created_at` |
| Updated timestamp | `updated_at` |
| Deleted timestamp | `deleted_at` |
| Boolean flag | `is_{adjective}` (e.g., `is_active`) |
| Email | `email` |
| Password hash | `password_hash` |
| Display name | `display_name` |
| Status enum | `status` |

## TypeScript Naming Rules

### Interfaces

```typescript
// ✅ CORRECT
interface User { ... }
interface OrderItem { ... }
interface ApiResponse<T> { ... }

// ❌ INCORRECT
interface IUser { ... }        // No I prefix
interface user { ... }         // PascalCase required
interface OrderItems { ... }   // Singular for types
```

### Type Aliases

```typescript
// ✅ CORRECT
type UserId = string;
type EmailAddress = string;
type Status = 'active' | 'inactive';

// ❌ INCORRECT
type userId = string;          // PascalCase required
type USER_ID = string;         // Not SCREAMING_CASE
```

### Enums

```typescript
// ✅ CORRECT
enum UserRole {
  Admin = 'admin',
  User = 'user',
  Guest = 'guest',
}

enum OrderStatus {
  Pending = 'pending',
  Processing = 'processing',
  Completed = 'completed',
}

// ❌ INCORRECT
enum userRole { ... }          // PascalCase required
enum USER_ROLE { ... }         // Not SCREAMING_CASE
```

## Field Mapping Examples

### User Entity

| Database | TypeScript | Notes |
|----------|------------|-------|
| `id` | `id` | Same |
| `email` | `email` | Same |
| `password_hash` | `passwordHash` | Mapped |
| `display_name` | `displayName` | Mapped |
| `is_verified` | `isVerified` | Mapped |
| `created_at` | `createdAt` | Mapped |
| `updated_at` | `updatedAt` | Mapped |

### Order Entity

| Database | TypeScript | Notes |
|----------|------------|-------|
| `id` | `id` | Same |
| `user_id` | `userId` | Mapped (FK) |
| `order_number` | `orderNumber` | Mapped |
| `total_amount` | `totalAmount` | Mapped |
| `shipping_address_id` | `shippingAddressId` | Mapped (FK) |
| `is_paid` | `isPaid` | Mapped (boolean) |

## API Request/Response

### Request Bodies

Use camelCase (TypeScript convention):

```json
{
  "email": "user@example.com",
  "password": "secret123",
  "displayName": "John Doe"
}
```

### Response Bodies

Use camelCase (TypeScript convention):

```json
{
  "id": "uuid-here",
  "email": "user@example.com",
  "displayName": "John Doe",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

## ORM Mapping

### Prisma Example

```prisma
model User {
  id           String   @id @default(uuid())
  email        String   @unique
  passwordHash String   @map("password_hash")
  displayName  String   @map("display_name")
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")

  @@map("users")
}
```

### TypeORM Example

```typescript
@Entity('users')
export class User {
  @PrimaryColumn()
  id: string;

  @Column()
  email: string;

  @Column({ name: 'password_hash' })
  passwordHash: string;

  @Column({ name: 'display_name' })
  displayName: string;

  @Column({ name: 'created_at' })
  createdAt: Date;

  @Column({ name: 'updated_at' })
  updatedAt: Date;
}
```

### Drizzle Example

```typescript
export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  passwordHash: varchar('password_hash', { length: 255 }).notNull(),
  displayName: varchar('display_name', { length: 100 }),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

## Consistency Rules

### Rule 1: Single Source of Truth

TYPE-CONTRACTS.ts is the authoritative source:

```typescript
// TYPE-CONTRACTS.ts - THE source of truth
export interface User {
  id: string;
  email: string;
  passwordHash: string;
  // ...
}

// Everywhere else - IMPORT from contracts
import { User } from '@/types/contracts';
```

### Rule 2: No Invented Names

```typescript
// ✅ CORRECT - Uses contract names
const user: User = {
  id: generateId(),
  email: formData.email,
  passwordHash: await hash(formData.password),
};

// ❌ INCORRECT - Invented names
const user = {
  userId: generateId(),       // Wrong: should be 'id'
  userEmail: formData.email,  // Wrong: should be 'email'
  pwdHash: await hash(...),   // Wrong: should be 'passwordHash'
};
```

### Rule 3: Database Matches Schema

```sql
-- ✅ CORRECT - Matches TYPE-CONTRACTS field mapping
CREATE TABLE users (
  id UUID PRIMARY KEY,
  password_hash VARCHAR(255)   -- Maps to passwordHash
);

-- ❌ INCORRECT - Different column name
CREATE TABLE users (
  id UUID PRIMARY KEY,
  pwd_hash VARCHAR(255)        -- Doesn't match contract
);
```

## Checklist

Before finalizing data model:

- [ ] Database tables use snake_case, plural
- [ ] Database columns use snake_case
- [ ] TypeScript interfaces use PascalCase, singular
- [ ] TypeScript fields use camelCase
- [ ] Field mapping documented in TYPE-CONTRACTS.ts
- [ ] ORM configured with correct column mappings
- [ ] API uses camelCase in request/response bodies
- [ ] No invented names in codebase
