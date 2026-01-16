# Project Title
## Credit Default Risk Scoring Using Transaction & Behavioral Data
### Business Problem

Banks face significant losses from loan defaults, especially when early warning signs are missed. Traditional credit scoring often relies on static attributes like income and credit history, which fail to capture real-time behavioral risk.

#### Objective:
Build a rule-based customer default risk scoring model using transaction behavior, loan history, and customer demographics — similar to an early-stage credit risk monitoring system used by retail banks.
### Stakeholders
1. Credit Risk Team – to identify high-risk customers proactively
2. Collections Team – to prioritize follow-ups
3. Product & Policy Teams – to refine lending rules and thresholds
### Data Overview
A synthetic but realistic banking dataset was generated to simulate production-scale data:
| Table               | Description                                                   |
| ------------------- | ------------------------------------------------------------- |
| `dim_customers`     | 100K customers with income, geography, tenure                 |
| `dim_merchants`     | Merchant categories (Gambling, Essentials, Electronics, etc.) |
| `fact_transactions` | 2M transactions over 1 year                                   |
| `fact_loans`        | 40K loans with status (Active, Closed, Defaulted)             |













#### Tech Stack
PostgreSQL:
- SQL (CTEs, joins, indexing, aggregation)
- Relational modeling (Star Schema)
