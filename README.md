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

PostgreSQL
SQL (CTEs, joins, aggregations, indexing)
