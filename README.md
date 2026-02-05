# Project Title
## Credit Default Risk Scoring Using Transaction & Behavioral Data

### Business Problem
Banks face significant losses from loan defaults, especially when early warning signs are missed. Traditional credit scoring often relies on static attributes like income and credit history, which fail to capture real-time behavioral risk.

#### Objective:
Build a rule-based customer default risk scoring model using transaction behavior, loan history, and customer demographics - similar to an early-stage credit risk monitoring system used by retail banks.

### Stakeholders
1. Credit Risk Team: To identify high-risk customers proactively
2. Collections Team: To prioritize follow-ups
3. Product & Policy Teams: To refine lending rules and thresholds

### Data Overview
A synthetic but realistic banking dataset was generated to simulate production-scale data:
| Table               | Description                                                   |
| ------------------- | ------------------------------------------------------------- |
| `dim_customers`     | ~100K customers with income, geography, tenure                 |
| `dim_merchants`     | Merchant categories (Gambling, Essentials, Electronics, etc.) |
| `fact_transactions` | ~2M transactions over 1 year                                   |
| `fact_loans`        | ~40K loans with status (Active, Closed, Defaulted)             |

### Data Engineering & Modeling Approach
#### 1. Star Schema Design
- Fact tables: Transactions & Loans
- Dimensions: Customers & Merchants
- Indexed customer keys for query performance

#### 2. Feature Engineering
Key behavioral metrics were derived using SQL CTEs:
- **Spending Behavior:** Average transaction value, spending volatility (STDDEV), and estimated monthly spend.
- **Gambling Exposure:** % of total spend at gambling merchants.
- **Loan Health:** Active loan count and past default history.
- **Transaction Recency:** Days since last transaction (Dormancy).

### Risk Scoring Logic
A rule-based scoring model converts business intuition into numeric risk points. 

#### Scoring Rules:
| Risk Signal                    | Points | Rationale |
| ------------------------------ | ------ | --------- |
| Past default history           | +25    | Strongest predictor of future default |
| Gambling > 20% of spend        | +20    | High-risk behavioral indicator |
| More than 2 active loans       | +15    | Indicates over-leveraged status |
| High spend volatility          | +10    | Signals erratic/unstable finances |
| Spending > 80% of income       | +10    | High debt-to-income stress |
| Long inactivity (>90 days)     | +5     | Potential disengagement or job loss |
| Large average transaction size | +5     | Potential runaway spend/fraud risk |
| New Customer (< 6 months)      | +5     | Higher uncertainty with new accounts |
| Low income + active loans      | +5     | Thin financial buffers |
| Geography Risk (Simulated)     | +0     | Placeholder for regional risk factors |

**Final Risk Score** = Sum of all weighted signals.

### Key Insights
- **Behavioral signals outperform static demographics:** Customers with stable income but erratic spending ranked higher risk than lower-income stable spenders.
- **Gambling behavior is a strong risk amplifier:** Even moderate gambling ratios significantly increased final risk scores.
- **Past defaults dominate risk ranking:** Customers with prior defaults consistently surfaced at the top of the risk list.

### Business Recommendations
- **Early Intervention Program:** Flag customers above a risk threshold for proactive engagement.
- **Dynamic Credit Limits:** Reduce exposure for customers showing rising behavioral risk.
- **Explainable Risk Framework:** Use rule-based scores alongside ML models for regulatory compliance.

#### Tech Stack
PostgreSQL (CTEs, Joins, Indexing, Window Functions)
