# Project Title
## Customer Credit Risk Scoring Using Transaction & Loan Behavior (SQL)
### Problem Statement
Banks need to proactively identify customers who are likely to default on loans. Traditional credit scores often lag real customer behavior.
The objective of this project was to rank customers by default risk using transaction patterns, loan behavior, and spending habits, enabling early intervention before defaults occur.
### Data
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




























------------------------------------------------------------------

Project: Customer Default Risk Scoring System (SQL)

Business Context

Banks need to proactively identify customers at high risk of loan default in order to:
- reduce credit losses
- intervene early (limit exposure, adjust credit limits, outreach)
- comply with explainability requirements in credit decisions

This project simulates a rule-based customer risk scoring system, similar to early-warning frameworks used by retail banks.

Objective
To rank customers by default risk using:
- transaction behavior
- spending volatility
- loan history
- income stress indicators

The output is a transparent, explainable risk score that can be used by credit risk or collections teams.

Data Model
The project uses a star schema to mirror real banking systems:
Dimensions
dim_customers – demographics, income, tenure proxy
dim_merchants – merchant category (e.g., Gambling, Essentials)

Fact Tables
fact_transactions – 2M card transactions (amount, date, merchant)
fact_loans – loan status and outstanding exposure

Data Generation (Python): All data is synthetically generated using Python (Faker + NumPy) to simulate realistic distributions while preserving privacy.

- 100,000 customers across multiple geographies
- 2 million transactions (randomized amounts and dates)
- Loan penetration of ~40%
- Indexes added for performance optimization

This setup allows testing:
- large joins
- aggregations
- real-world query performance

Risk Signals Engine (SQL): Customer risk is derived using multiple behavioral and financial signals, each mapped to a score.

Key Risk Drivers

1. Gambling Spend Ratio: High gambling spend correlates with impulsive behavior and defaults
2. Spending Volatility: Erratic spending patterns indicate unstable cash flow
3. Loan Health: Active loans -> leverage risk. Past defaults -> strongest predictor of future default
4. Income Stress: Monthly spend exceeding 80% of income indicates low buffer
5. Account Dormancy: Long inactivity may signal financial distress or disengagement

Each rule is intentionally explainable, reflecting real-world regulatory constraints in banking.

Final Risk Score: The final score is a weighted sum of individual risk signals, producing a single interpretable metric per customer.

Low Risk: Monitoring only  
Medium Risk: Credit limit review  
High Risk: Early intervention/ collections


This score is designed for:
- early warning dashboards
- credit policy checks
- analyst-driven investigations

Design Decisions
- Rule-based scoring chosen for explainability and auditability
- Synthetic data used to safely simulate real bank-scale workloads

Future Improvements
- Calibrate score thresholds using historical default labels
- Add ML models (logistic regression, XGBoost) as challenger models
- Introduce time-windowed features (last 30/60/90 days)
- Add customer tenure and product mix features

Tech Stack

PostgreSQL:
SQL (CTEs, joins, aggregations, indexing)
