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
#### Why synthetic data?
Allows safe simulation of sensitive financial use cases while preserving realistic patterns at scale.

### Data Engineering & Modeling Approach
#### 1. Star Schema Design
- Fact tables: Transactions & Loans
- Dimensions: Customers & Merchants
- Indexed customer keys for query performance
This mirrors real-world banking data warehouses.
#### 2. Feature Engineering (Core of the Project)
Key behavioral metrics were derived using SQL CTEs:
- Spending Behavior
1. Average transaction value
2. Spending volatility (STDDEV)
3. Estimated monthly spend
Rationale: Erratic and oversized spending often correlates with financial instability.
- Gambling Exposure
1. % of total spend at gambling merchants
Gambling-heavy customers are statistically more likely to default.









#### Tech Stack
PostgreSQL:
- SQL (CTEs, joins, indexing, aggregation)
- Relational modeling (Star Schema)
