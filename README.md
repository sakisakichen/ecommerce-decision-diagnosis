# Ecommerce Decision Diagnosis — Case #1

Business-first ecommerce analytics case study diagnosing where
a simulated Shopify store loses potential customers—from traffic
to product exploration and purchase.

[View Live Case Study →]

## Business Question

A newly launched ecommerce store was receiving traffic but
generating few orders.

**Where is the customer journey breaking, and what should
the merchant investigate next?**

## Case Snapshot

- 90-day analysis
- 1,500 sessions
- 12 orders
- 0.8% conversion rate
- Shopify Dev Store + BigQuery
- Controlled synthetic behavioral and transaction data

## Analytical Approach

Business Problem
→ Locate WHERE
→ Narrow the weak stage
→ Test explanations
→ Reject unsupported hypotheses
→ Identify the next measurement

## Key Findings

### Finding #1 — The weakness appears before checkout
Session → Add to Cart = **2.0%**.

Mobile (2.05%) and Desktop (2.17%) performed similarly,
so device did not explain the weakness.

### Finding #2 — 60% of sessions did not progress to PDP
Only 600 of 1,500 sessions reached a Product Detail Page.

### Finding #3 — Early disengagement did not explain the gap
No-PDP vs Reached-PDP:

| Metric | No PDP | Reached PDP |
|---|---:|---:|
| Bounce Rate | 43% | 42% |
| Pages / Session | 2.58 | 2.67 |
| Avg. Duration | 96 sec | 117 sec |

Many No-PDP visitors continued browsing.

### Finding #4 — Collection → PDP became the next decision point
553 No-PDP sessions visited a Collection page.

329 of those sessions ended there.

**59.5% of Collection-visiting No-PDP sessions stopped
at Collection.**

## Business Decision

Prioritize measurement of:

Collection View
→ Product Card Impression
→ Product Card Click
→ PDP View

The evidence identifies **where to investigate next**.

It does not prove that imagery, pricing, promotions,
product-card information, merchandising, or mobile UX
caused the friction.

## Data & Tools

- Shopify Dev Store — Product / Variant structure and source capability validation
- BigQuery — analytical environment
- SQL — funnel, behavioral, exit-page, and navigation analysis
- Controlled synthetic data — sessions, behavioral pageviews,
  customers, orders, order lines, and marketing spend

> No real customer data is used in this project.

## Repository Structure

```text
ecommerce-decision-diagnosis/
├── index.html
├── README.md
├── assets/
├── sql/
│   ├── 01_funnel_analysis.sql
│   ├── 02_device_validation.sql
│   ├── 03_pdp_progression.sql
│   ├── 04_behavior_comparison.sql
│   └── 05_exit_navigation_analysis.sql
└── docs/
    └── methodology.md
```

## Technical Evidence

SQL queries used to support the findings are available in
[`/sql`](sql/).

Simulation design, metric definitions, grain, assumptions,
and evidence limitations are documented in
[`/docs/methodology.md`](docs/methodology.md).

## Portfolio Case Study

For the visual business narrative, findings, and recommendations:

**[View the Live Case Study →]**
