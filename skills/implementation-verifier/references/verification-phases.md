# Verification Phases

Detailed steps for each verification phase. Execute in order. Stop on failure.

---

## Phase 1: Build Verification

```bash
npm run build  # Or: yarn build, pnpm build
```

**Checks:**
- [ ] Build completes with exit code 0
- [ ] No TypeScript/compilation errors
- [ ] No missing dependencies
- [ ] Build output exists (dist/, .next/, build/)

**If fails:**
```
STOP. Return to fullstack-developer.
Error: Build failed - [error message]
```

---

## Phase 2: Infrastructure Verification

```bash
docker-compose up -d
docker-compose ps  # All should show "Up"
docker-compose exec db psql -U postgres -c "SELECT 1"  # Returns 1
```

**Checks:**
- [ ] All Docker containers start
- [ ] Database accessible
- [ ] Cache/Redis accessible (if used)
- [ ] No port conflicts

**If fails:**
```
STOP. Return to platform-engineer.
Error: Infrastructure - [container/service] failed to start
```

---

## Phase 3: Database Verification

```bash
npm run db:migrate  # Must exit 0
npm run db:seed     # Must exit 0
```

**Checks:**
- [ ] Migrations run without errors
- [ ] All expected tables exist
- [ ] Seed data present
- [ ] Foreign keys valid

**If fails:**
```
STOP. Return to platform-engineer + data-engineer.
Error: Database - [migration/seed] failed
```

---

## Phase 4: Application Startup

```bash
npm run dev &
sleep 5
curl -I http://localhost:3000
```

**Checks:**
- [ ] App starts without crash
- [ ] No unhandled exceptions in console
- [ ] Responds on expected port
- [ ] Health endpoint returns 200

**If fails:**
```
STOP. Return to fullstack-developer.
Error: Application - Startup failed or not responding
```

---

## Phase 5: Route Verification

Test all main routes respond (not 404 or 500):

```bash
# Homepage
curl -I http://localhost:3000/
# Expected: 200 or 3xx redirect

# Auth pages
curl -I http://localhost:3000/login
curl -I http://localhost:3000/signup
# Expected: 200

# API health
curl -I http://localhost:3000/api/health
# Expected: 200

# Static assets
curl -I http://localhost:3000/favicon.ico
# Expected: 200
```

**Checks:**
- [ ] Homepage loads (200 or redirect)
- [ ] Login/signup pages load
- [ ] API health endpoint responds
- [ ] Static assets load
- [ ] No 404s on main navigation
- [ ] No 500 errors

---

## Phase 6: Authentication Flow

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!@#"}'
# Expected: 200 with token/session

# Authenticated route
curl -H "Authorization: Bearer [token]" \
  http://localhost:3000/api/user/profile
# Expected: 200

# Logout
curl -X POST http://localhost:3000/api/auth/logout \
  -H "Authorization: Bearer [token]"
# Expected: 200
```

**Checks:**
- [ ] Login returns session/token
- [ ] Authenticated routes work with token
- [ ] Logout invalidates session

---

## Phase 7: Core Feature Smoke Test

For each Must-have user story, verify happy path works:

| US-ID | Action | Expected | Actual |
|-------|--------|----------|--------|
| US-001 | [Describe test] | [Expected result] | PASS/FAIL |

**Checks:**
- [ ] Each Must-have story has basic functionality
- [ ] CRUD operations work (Create, Read, Update, Delete)
- [ ] Forms submit successfully
- [ ] Data persists after refresh

---

## Phase 8: Admin Functionality

```bash
# Admin login
curl -X POST http://localhost:3000/api/auth/login \
  -d '{"email":"admin@app.com","password":"AdminPass123!"}'

# Admin dashboard
curl -H "Authorization: Bearer [admin-token]" \
  http://localhost:3000/admin
# Expected: 200

# User list
curl -H "Authorization: Bearer [admin-token]" \
  http://localhost:3000/admin/users
# Expected: 200 with user list
```

**Checks:**
- [ ] Admin user exists (seeded)
- [ ] Admin can log in
- [ ] Admin dashboard accessible
- [ ] User management works
