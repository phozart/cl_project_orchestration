# System Requirements Checklist

Every app needs these. Check each category.

---

## Authentication & Users (10-15 requirements)

- [ ] User registration with email/password
- [ ] Email verification
- [ ] Password requirements (length, complexity)
- [ ] Password reset request
- [ ] Password reset confirmation
- [ ] Login with email/password
- [ ] Session timeout
- [ ] Remember me option
- [ ] Logout
- [ ] Account deletion (GDPR)
- [ ] OAuth integration (Google/GitHub)
- [ ] Two-factor authentication
- [ ] Account lockout after failed attempts
- [ ] Login from new device notification

---

## Admin & User Management (8-12 requirements)

- [ ] Admin dashboard with metrics
- [ ] List users with pagination
- [ ] Search/filter users
- [ ] View user details
- [ ] Edit user information
- [ ] Change user role
- [ ] Disable/enable account
- [ ] Delete account
- [ ] Invite new users
- [ ] Activity log for admin actions
- [ ] Export user list

---

## Roles & Permissions (5-8 requirements)

- [ ] Define user roles
- [ ] Role-based navigation
- [ ] Role-based feature access
- [ ] Role-based data access
- [ ] Admin can assign/change roles
- [ ] Permission denied handling
- [ ] Role hierarchy

---

## Transactional Emails (8-12 requirements)

- [ ] Welcome email
- [ ] Email verification
- [ ] Password reset
- [ ] Password changed notification
- [ ] Account deleted confirmation
- [ ] Login from new device
- [ ] Subscription confirmation
- [ ] Payment receipt
- [ ] Weekly/monthly digest
- [ ] Notification preferences

---

## Legal & Compliance (5-8 requirements)

- [ ] Privacy policy page
- [ ] Terms of service page
- [ ] Cookie consent banner
- [ ] Cookie preferences
- [ ] Data export (GDPR)
- [ ] Data deletion request
- [ ] Accessibility statement

---

## UI/UX Standards (10-12 requirements)

- [ ] Responsive design (mobile/tablet/desktop)
- [ ] Loading states (spinners, skeletons)
- [ ] Error states (inline, page-level)
- [ ] Success feedback (toasts)
- [ ] Empty states ("No data yet")
- [ ] 404 page
- [ ] 500 page
- [ ] Session expired handling
- [ ] Confirmation dialogs
- [ ] Accessibility (WCAG 2.1 AA)

---

## Data & Storage (10-15 requirements)

- [ ] Data persistence (create/read/update/delete)
- [ ] File upload specifications
- [ ] File size limits
- [ ] File type restrictions
- [ ] Validation rules
- [ ] Export formats (CSV, JSON, PDF)
- [ ] Search functionality
- [ ] Filter functionality
- [ ] Sort functionality
- [ ] Pagination
- [ ] Bulk operations

---

## Count Validation

| App Type | Minimum Requirements |
|----------|---------------------|
| Simple (no accounts) | 20-30 |
| User accounts | 30-50 |
| Complex (admin, RBAC) | 50-80 |
| Enterprise | 80+ |

If below minimum → STOP. You're missing requirements.
