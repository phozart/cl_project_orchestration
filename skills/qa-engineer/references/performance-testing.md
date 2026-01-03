# Performance Testing

## Performance Budgets

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP (Largest Contentful Paint) | < 2.5s | < 4s | > 4s |
| FID (First Input Delay) | < 100ms | < 300ms | > 300ms |
| CLS (Cumulative Layout Shift) | < 0.1 | < 0.25 | > 0.25 |
| API p95 latency | < 500ms | < 1000ms | > 1000ms |
| Error rate | < 0.1% | < 1% | > 1% |

---

## Load Testing with k6

### Basic Load Test

```javascript
// tests/performance/load.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp up to 100 users
    { duration: '5m', target: 100 },  // Steady state
    { duration: '2m', target: 200 },  // Spike to 200 users
    { duration: '2m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests under 500ms
    http_req_failed: ['rate<0.01'],    // Less than 1% failure rate
  },
};

export default function () {
  const res = http.get('https://api.example.com/users');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
```

### Stress Test

```javascript
export const options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '5m', target: 200 },
    { duration: '2m', target: 300 },  // Push beyond expected load
    { duration: '5m', target: 300 },
    { duration: '5m', target: 0 },
  ],
};
```

### Soak Test

```javascript
export const options = {
  stages: [
    { duration: '5m', target: 100 },
    { duration: '4h', target: 100 },  // Run for 4 hours
    { duration: '5m', target: 0 },
  ],
};
```

---

## Running Performance Tests

```bash
# Basic run
k6 run tests/performance/load.js

# With output to file
k6 run --out json=results.json tests/performance/load.js

# With cloud reporting (if configured)
k6 cloud tests/performance/load.js
```

---

## Performance Report Template

```markdown
# Performance Test Report

## Test Configuration
- Test type: Load / Stress / Soak
- Duration: [X minutes/hours]
- Max virtual users: [N]
- Target endpoint: [URL]

## Results Summary
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| p95 latency | < 500ms | [X]ms | PASS/FAIL |
| p99 latency | < 1000ms | [X]ms | PASS/FAIL |
| Error rate | < 1% | [X]% | PASS/FAIL |
| Throughput | > 100 rps | [X] rps | PASS/FAIL |

## Issues Found
- [Issue 1]
- [Issue 2]

## Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

---

## When Performance Fails

| Issue | Severity | Action |
|-------|----------|--------|
| p95 > 500ms | High | Optimize before release |
| p95 > 1000ms | Critical | BLOCK release |
| Error rate > 1% | Critical | BLOCK release |
| Memory leak detected | Critical | BLOCK release |
| Database connection exhaustion | Critical | BLOCK release |
