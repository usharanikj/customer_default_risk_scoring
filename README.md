# Project Title
## Customer Credit Risk Scoring Using Transaction & Loan Behavior (SQL)
### Problem Statement
Banks need to proactively identify customers who are likely to default on loans. Traditional credit scores often lag real customer behavior.
The objective of this project was to rank customers by default risk using transaction patterns, loan behavior, and spending habits, enabling early intervention before defaults occur.
### Data
##### Note: All data is synthetically generated using Python (Faker + NumPy) to simulate realistic distributions while preserving privacy.
Synthetic but realistic banking data was generated to simulate a production-scale environment:
- 100,000 customers (demographics, income, job tenure)
- 2 million transactions across multiple merchant categories
- 40,000 loans with active, closed, and defaulted statuses
- Merchant categories included essentials, entertainment, electronics, and gambling
#### Data was modeled using a star schema:
- Dimension tables: dim_customers, dim_merchants
- Fact tables: fact_transactions, fact_loans
### Approach
1. Generated large-scale datasets using Python (Pandas, NumPy, Faker)
2. Designed and loaded a relational schema in SQL
3. Optimized performance using indexes on fact tables
4. Built multiple CTEs to derive behavioral risk metrics:
- Spending volatility
- Gambling spend ratio
- Loan burden and default history
- Income vs spending stress
- Transaction recency (dormancy)
5. Converted business rules into a rule-based risk scoring model
6. Combined all risk signals into a final composite risk score per customer
### Key Risk Signals Identified
- Customers spending >20% on gambling showed significantly higher risk
- Past loan defaults were the strongest predictor of future default
- High spending volatility indicated unstable financial behavior
- Customers spending >80% of income had minimal financial buffers
- Dormant accounts (>90 days inactive) signaled disengagement or distress
### Impact & Business Value
- Created a transparent, explainable early-warning risk model
- Enabled prioritization of high-risk customers for:
- Credit limit reduction
- Proactive outreach
- Stricter lending criteria
- Designed to be easily audited and adjusted by risk teams
### Next Steps
- Incorporate real repayment timelines and delinquency buckets
- Add customer tenure and account age features
- Deploy as a scheduled risk monitoring pipeline

#### Tech Stack

PostgreSQL:
- SQL (CTEs, joins, indexing, aggregation)
- Relational modeling (Star Schema)
