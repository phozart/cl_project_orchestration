# Feature Checklist Reference

Review EVERY category. Missing features = project failure.

---

## Authentication (10-15 features)

- [ ] User registration (email/password)
- [ ] Email verification
- [ ] User login
- [ ] User logout
- [ ] Password reset request
- [ ] Password reset confirmation
- [ ] OAuth (Google)
- [ ] OAuth (GitHub/Apple/etc.)
- [ ] Two-factor authentication setup
- [ ] Two-factor authentication verification
- [ ] Remember me / persistent sessions
- [ ] Session management (view active sessions)
- [ ] Force logout all sessions
- [ ] Account lockout after failed attempts
- [ ] CAPTCHA for bot protection

---

## User Profile (8-12 features)

- [ ] View profile
- [ ] Edit profile (name, avatar)
- [ ] Change email
- [ ] Change password
- [ ] Delete account
- [ ] Data export (GDPR)
- [ ] Privacy settings
- [ ] Notification preferences
- [ ] Connected accounts (OAuth)
- [ ] API key management
- [ ] Activity log

---

## Admin Panel (15-20 features)

- [ ] Admin dashboard with metrics
- [ ] User list with pagination
- [ ] User search/filter
- [ ] View user details
- [ ] Edit user
- [ ] Ban/suspend user
- [ ] Delete user
- [ ] Impersonate user
- [ ] Role management
- [ ] Permission management
- [ ] System settings
- [ ] Audit log
- [ ] Email template management
- [ ] Feature flags
- [ ] Maintenance mode

---

## Emails (8-12 features)

- [ ] Welcome email
- [ ] Email verification
- [ ] Password reset
- [ ] Password changed notification
- [ ] Account locked notification
- [ ] Login from new device
- [ ] Weekly/monthly digest
- [ ] Subscription confirmation
- [ ] Payment receipt
- [ ] Account deletion confirmation

---

## Notifications (5-8 features)

- [ ] In-app notification center
- [ ] Push notifications (web)
- [ ] Push notifications (mobile)
- [ ] Mark as read
- [ ] Mark all as read
- [ ] Notification preferences
- [ ] Unsubscribe links

---

## Data Operations (10-15 features)

- [ ] Create records
- [ ] Read/view records
- [ ] Update records
- [ ] Delete records (soft delete?)
- [ ] List with pagination
- [ ] Search/filter
- [ ] Sort by multiple fields
- [ ] Bulk select
- [ ] Bulk delete
- [ ] Bulk update
- [ ] Import (CSV/JSON)
- [ ] Export (CSV/JSON/PDF)
- [ ] Archive/restore

---

## UI States (10-12 features)

- [ ] Loading indicators (spinners, skeletons)
- [ ] Empty states ("No data yet")
- [ ] Error states (inline, page-level)
- [ ] Success feedback (toasts)
- [ ] Confirmation dialogs
- [ ] Undo actions
- [ ] Form validation (inline)
- [ ] Form submission states
- [ ] Disabled states
- [ ] Progress indicators
- [ ] Offline state

---

## Error Handling (6-8 features)

- [ ] 404 Not Found page
- [ ] 403 Forbidden page
- [ ] 500 Server Error page
- [ ] Session expired handling
- [ ] Network error handling
- [ ] Validation error display
- [ ] Rate limit exceeded

---

## Legal & Compliance (5-8 features)

- [ ] Privacy policy page
- [ ] Terms of service page
- [ ] Cookie consent banner
- [ ] Cookie preferences
- [ ] GDPR data request form
- [ ] Accessibility statement
- [ ] Security page

---

## Navigation (6-8 features)

- [ ] Main navigation
- [ ] Mobile navigation (hamburger)
- [ ] Breadcrumbs
- [ ] Footer
- [ ] Search (global)
- [ ] User menu (avatar dropdown)
- [ ] Settings navigation

---

## Count Validation

After reviewing all categories:

| Category | Count |
|----------|-------|
| Authentication | |
| User Profile | |
| Admin Panel | |
| Emails | |
| Notifications | |
| Data Operations | |
| UI States | |
| Error Handling | |
| Legal | |
| Navigation | |
| **TOTAL** | |

**Minimum for auth app: 50 features**
**Typical for auth app: 75-100 features**

If total < 50 → STOP. You missed features.
