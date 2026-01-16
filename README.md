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
##### - Spending Behavior
1. Average transaction value
2. Spending volatility (STDDEV)
3. Estimated monthly spend
Rationale: Erratic and oversized spending often correlates with financial instability.
##### - Gambling Exposure
1. % of total spend at gambling merchants
Gambling-heavy customers are statistically more likely to default.
##### - Loan Health
1. Active loan count
2. Past default history
Past default is the strongest predictor of future default.
##### - Transaction Recency
1. Days since last transaction
Dormancy can signal job loss, disengagement, or financial distress.

### Risk Scoring Logic
A rule-based scoring model converts business intuition into numeric risk points.
Each rule answers one question: “Does this customer exhibit risky behavior?”

#### Scoring Examples:
| Risk Signal                    | Points |
| ------------------------------ | ------ |
| Gambling > 20% of spend        | +20    |
| Past default history           | +25    |
| More than 2 active loans       | +15    |
| High spend volatility          | +10    |
| Spending > 80% of income       | +10    |
| Long inactivity (>90 days)     | +5     |
| Large average transaction size | +5     |
| Low income + active loans      | +5     |

Final Risk Score = Sum of all rule-based signals
This mirrors interpretable risk models commonly used in regulated banking environments where explainability is critical.


### Key Insights
- Behavioral signals outperform static demographics
Customers with stable income but erratic spending ranked higher risk than lower-income stable spenders.
- Gambling behavior is a strong risk amplifier
Even moderate gambling ratios significantly increased final risk scores.
- Past defaults dominate risk ranking
Customers with prior defaults consistently surfaced at the top of the risk list.
- Dormancy is an underrated early warning
Long inactivity combined with debt exposure flagged hidden risk cases.


### Business Recommendations
- Early Intervention Program
Flag customers above a risk threshold for proactive engagement.
- Dynamic Credit Limits
Reduce exposure for customers showing rising behavioral risk.
- Targeted Monitoring
Prioritize customers with gambling-heavy spend + active loans.
- Explainable Risk Framework
Use rule-based scores alongside ML models for regulatory compliance.


### Impact (Estimated)
If deployed in a real banking environment, this model could:
- Reduce default losses by 10–15% through early detection
- Improve collections efficiency by prioritizing top-risk customers
- Provide transparent, auditable credit decisions






#### Tech Stack
PostgreSQL:
- SQL (CTEs, joins, indexing, aggregation)
- Relational modeling (Star Schema)
