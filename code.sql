-- ==========================================================
-- 1. DATABASE SCHEMA SETUP
-- ==========================================================

CREATE TABLE dim_customers (
    cust_id INT PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(10),
    annual_income INT,
    job_tenure_years INT,
    is_bank_employee INT,
    join_date DATE
);

CREATE TABLE dim_merchants (
    m_id INT PRIMARY KEY,
    m_name VARCHAR(255),
    category VARCHAR(100)
);

CREATE TABLE fact_transactions (
    txn_id INT PRIMARY KEY,
    cust_id INT REFERENCES dim_customers(cust_id),
    m_id INT REFERENCES dim_merchants(m_id),
    amount DECIMAL(15,2),
    txn_date DATE
);

CREATE TABLE fact_loans (
    loan_id INT PRIMARY KEY,
    cust_id INT REFERENCES dim_customers(cust_id),
    loan_status VARCHAR(50),
    outstanding_amt INT
);

-- ==========================================================
-- 2. PERFORMANCE OPTIMIZATION
-- ==========================================================

CREATE INDEX idx_txn_cust_id ON fact_transactions(cust_id);
CREATE INDEX idx_loan_cust_id ON fact_loans(cust_id);

-- ==========================================================
-- 3. RISK SCORING MODEL
-- ==========================================================

WITH monthly_balances AS 
(
    SELECT 
        cust_id,
        ROUND(AVG(amount), 2) AS avg_txn_value, 
        ROUND(STDDEV(amount), 2) AS spend_volatility,
        -- Note: Assumes 12 months of data; for new customers, this is a conservative estimate
        ROUND((SUM(amount) / 12), 2) AS est_monthly_spend
    FROM fact_transactions
    GROUP BY cust_id
),

gambling_behavior AS 
(
    SELECT 
        t.cust_id,
        ROUND(SUM(CASE WHEN m.category = 'Gambling' THEN t.amount ELSE 0 END) 
        * 1.0 / NULLIF(SUM(t.amount), 0), 3) AS gambling_ratio
    FROM fact_transactions AS t
    JOIN dim_merchants AS m ON t.m_id = m.m_id
    GROUP BY t.cust_id
),

loan_health AS 
(
    SELECT 
        cust_id,
        COUNT(CASE WHEN loan_status = 'Active' THEN 1 END) AS active_loans,
        COUNT(CASE WHEN loan_status = 'Defaulted' THEN 1 END) AS past_defaults
    FROM fact_loans
    GROUP BY cust_id
),

transaction_recency AS 
(
    SELECT 
        cust_id,
        CURRENT_DATE - MAX(txn_date) AS days_since_last_txn
    FROM fact_transactions
    GROUP BY cust_id
),

scoring_base AS 
(
    SELECT 
        c.cust_id,
        c.annual_income,
        -- Rule 1: High Gambling (>20% of spend)
        CASE WHEN g.gambling_ratio > 0.20 THEN 20 ELSE 0 END AS score_gambling,
		
        -- Rule 2: Multiple Active Loans
        CASE WHEN l.active_loans > 2 THEN 15 ELSE 0 END AS score_loans,
		
        -- Rule 3: Previous Default History (Highest weight)
        CASE WHEN l.past_defaults > 0 THEN 25 ELSE 0 END AS score_history,
		
        -- Rule 4: High Spend Volatility
        CASE WHEN b.spend_volatility > 1000 THEN 10 ELSE 0 END AS score_volatility,
		
        -- Rule 5: Income to Spend Stress (Spending > 80% of income)
        CASE WHEN b.est_monthly_spend > (c.annual_income / 12) * 0.8 THEN 10 ELSE 0 END AS score_debt_stress,
		
        -- Rule 6: New Customer Risk (Tenure < 6 months)
        CASE WHEN c.join_date > CURRENT_DATE - INTERVAL '6 months' THEN 5 ELSE 0 END AS score_tenure,

        -- Rule 7: Large Single Transaction 
        CASE WHEN b.avg_txn_value > 4000 THEN 5 ELSE 0 END AS score_large_txn,
		
        -- Rule 8: Account Dormancy 
        CASE WHEN r.days_since_last_txn > 90 THEN 5 ELSE 0 END AS score_dormancy,
		
        -- Rule 9: Low Income & High Loans
        CASE WHEN c.annual_income < 30000 AND l.active_loans > 0 THEN 5 ELSE 0 END AS score_low_income_risk,
		
        -- Rule 10: Geography Risk (Placeholder)
        CASE WHEN c.country IN ('IN', 'BR') THEN 0 ELSE 0 END AS score_geo 
		
    FROM dim_customers AS c
    LEFT JOIN gambling_behavior AS g ON c.cust_id = g.cust_id
    LEFT JOIN monthly_balances AS b ON c.cust_id = b.cust_id
    LEFT JOIN loan_health AS l ON c.cust_id = l.cust_id
    LEFT JOIN transaction_recency AS r ON c.cust_id = r.cust_id
)

SELECT 
    *,
	(score_gambling + score_loans + score_history + score_volatility + 
	score_debt_stress + score_tenure + score_large_txn + 
    score_dormancy + score_low_income_risk + score_geo) AS final_risk_score
FROM scoring_base
ORDER BY final_risk_score DESC;
