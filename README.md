# Project Title

## Credit Default Risk Scoring Using Transaction & Behavioral Data

### Business Problem

Banks face significant losses from loan defaults, especially when early warning signs are missed. Traditional credit scoring often relies on static attributes like income and credit history, which fail to capture real-time behavioral risk.

### Objective

Build a **dynamic, rule-based credit default risk scoring model** using transactional behavior, loan history, peer benchmarking, and customer demographics. The model is implemented entirely in SQL and is designed to surface early warning signals and anomalous customer behavior.

---

### Data Model

The solution uses five core tables:

* **customers** – demographic and employment attributes, tenure, and income
* **transactions** – customer spending behavior over time
* **merchants** – merchant category enrichment (e.g., Gambling)
* **loans** – active and historical loan performance
* **derived CTEs** – analytical feature layers used for scoring

Indexes are created on customer foreign keys to support scalable analytics.

---

### Feature Engineering & Risk Signals

The scoring logic is built using layered CTEs:

1. **Customer Statistics**

   * Average transaction value
   * Transaction volatility (coefficient of variation)
   * Estimated monthly spend

2. **Behavioral Risk Indicators**

   * Gambling spend ratio (share of total spend)
   * Transaction dormancy (days since last transaction)

3. **Loan Health**

   * Active loan count
   * Historical defaults

4. **Peer Benchmarking**

   * Customers grouped into income percentiles
   * Detection of loan outliers relative to income peers

---

### Risk Scoring Rules

Each customer receives a cumulative risk score based on the following rules:

| Rule                   | Risk Signal                  | Score |
| ---------------------- | ---------------------------- | ----- |
| Gambling exposure      | >20% of spend                | +20   |
| Past loan default      | Any prior default            | +25   |
| Transaction volatility | StdDev > 2× mean             | +10   |
| Income stress          | Spend >80% of monthly income | +10   |
| New customer           | Tenure < 6 months            | +5    |
| Account dormancy       | No txn > 90 days             | +5    |
| Peer loan outlier      | Loans > peer avg + 2         | +25   |

The **final risk score** is the sum of all triggered rule scores.

---

### Output

The final query produces:

* Individual rule-level risk contributions
* A consolidated **final_risk_score** per customer
* Results ordered from highest to lowest risk

This makes the model transparent, explainable, and suitable for regulatory or business review.

---

### Use Cases

* Early warning system for default risk
* Behavioral monitoring for retail banking
* Feature prototyping for ML-based credit models
* Regulatory-friendly, explainable risk scoring

---

### Next Enhancements

* Time-windowed behavior (last 30/60/90 days)
* Weight calibration using historical defaults
* Integration with machine learning pipelines
* Country- or segment-specific peer groups
