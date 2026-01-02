# System Design: {{PROJECT_NAME}}

## Document Control
| Field | Value |
|-------|-------|
| **Version** | 1.0 |
| **Status** | Draft / Review / Approved |
| **Author** | {{AUTHOR}} |
| **Date** | {{DATE}} |

---

## 1. Overview

### 1.1 Purpose
{{PURPOSE}}

### 1.2 Scope
{{SCOPE}}

### 1.3 Goals
- {{GOAL_1}}
- {{GOAL_2}}
- {{GOAL_3}}

---

## 2. Architecture Overview

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Web App   │  │ Mobile App  │  │   Admin     │          │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘          │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                        API Layer                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                  API Gateway                         │    │
│  └─────────────────────────────────────────────────────┘    │
│          │                │                │                 │
│          ▼                ▼                ▼                 │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐            │
│  │  Auth     │    │   Core    │    │  Admin    │            │
│  │  Service  │    │  Service  │    │  Service  │            │
│  └───────────┘    └───────────┘    └───────────┘            │
└─────────────────────────────────────────────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐            │
│  │ PostgreSQL│    │   Redis   │    │    S3     │            │
│  └───────────┘    └───────────┘    └───────────┘            │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Component Summary

| Component | Technology | Purpose |
|-----------|------------|---------|
| Web App | {{FRONTEND_TECH}} | User interface |
| API | {{BACKEND_TECH}} | Business logic |
| Database | {{DATABASE_TECH}} | Data persistence |
| Cache | {{CACHE_TECH}} | Performance |
| Storage | {{STORAGE_TECH}} | File storage |

---

## 3. Component Design

### 3.1 Frontend

**Technology**: {{FRONTEND_TECH}}

**Structure**:
```
src/
├── components/     # Reusable UI components
├── pages/          # Route-based pages
├── hooks/          # Custom React hooks
├── services/       # API client
├── store/          # State management
└── utils/          # Helper functions
```

**Key Decisions**:
- {{FRONTEND_DECISION_1}}
- {{FRONTEND_DECISION_2}}

### 3.2 Backend

**Technology**: {{BACKEND_TECH}}

**Structure**:
```
src/
├── routes/         # API endpoints
├── controllers/    # Request handlers
├── services/       # Business logic
├── models/         # Data models
├── middleware/     # Auth, logging, etc.
└── utils/          # Helper functions
```

**Key Decisions**:
- {{BACKEND_DECISION_1}}
- {{BACKEND_DECISION_2}}

### 3.3 Database

**Technology**: {{DATABASE_TECH}}

**Key Tables**:
| Table | Purpose |
|-------|---------|
| users | User accounts |
| {{TABLE_2}} | {{PURPOSE_2}} |
| {{TABLE_3}} | {{PURPOSE_3}} |

---

## 4. Security Architecture

### 4.1 Authentication
- Method: {{AUTH_METHOD}}
- Token: {{TOKEN_TYPE}}
- Expiration: {{EXPIRATION}}

### 4.2 Authorization
- Model: {{AUTHZ_MODEL}}
- Roles: {{ROLES}}

### 4.3 Data Protection
- Encryption at rest: {{AT_REST}}
- Encryption in transit: {{IN_TRANSIT}}

---

## 5. API Design

### 5.1 API Style
{{API_STYLE}} (REST / GraphQL)

### 5.2 Key Endpoints
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | /api/auth/login | User login |
| POST | /api/auth/register | User registration |
| GET | /api/{{RESOURCE}} | List {{RESOURCE}} |
| POST | /api/{{RESOURCE}} | Create {{RESOURCE}} |

---

## 6. Infrastructure

### 6.1 Deployment
- Environment: {{ENVIRONMENT}}
- Provider: {{PROVIDER}}
- Region: {{REGION}}

### 6.2 Scaling Strategy
{{SCALING_STRATEGY}}

---

## 7. Non-Functional Requirements

| Requirement | Target | Approach |
|-------------|--------|----------|
| Response time | < 500ms | Caching, CDN |
| Availability | 99.9% | Multi-AZ |
| Throughput | {{TPS}} TPS | Horizontal scaling |

---

## 8. ADRs (Architecture Decision Records)

| ADR | Decision | Date |
|-----|----------|------|
| ADR-001 | {{DECISION_1}} | {{DATE}} |
| ADR-002 | {{DECISION_2}} | {{DATE}} |

---

## 9. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| {{RISK_1}} | {{IMPACT_1}} | {{MITIGATION_1}} |
