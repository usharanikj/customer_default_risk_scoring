-- 1. DATABASE SCHEMA SETUP

CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(10),
    annual_income INT,
    job_tenure_years INT,
    is_bank_employee INT,
    join_date DATE
);

CREATE TABLE merchants (
    m_id INT PRIMARY KEY,
    m_name VARCHAR(255),
    category VARCHAR(100)
);

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    cust_id INT REFERENCES customers(cust_id),
    m_id INT REFERENCES merchants(m_id),
    amount DECIMAL(15,2),
    txn_date DATE
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    cust_id INT REFERENCES customers(cust_id),
    loan_status VARCHAR(50),
    outstanding_amt INT
);

CREATE INDEX idx_txn_cust_id ON transactions(cust_id);
CREATE INDEX idx_loan_cust_id ON loans(cust_id);


-- 2. RISK SCORING MODEL (DYNAMIC & ANOMALY-BASED)

WITH customer_stats AS 
(
    SELECT 
        cust_id,
        AVG(amount) AS avg_txn_amount,
        STDDEV(amount) AS stddev_txn_amount,
        -- Relative Volatility: Coefficient of Variation (StdDev/Mean)
        -- This flags instability relative to their own spending power
        CASE WHEN AVG(amount) > 0 THEN STDDEV(amount) / AVG(amount) ELSE 0 END AS volatility_index,
        ROUND((SUM(amount) / 12), 2) AS est_monthly_spend
    FROM transactions
    GROUP BY cust_id
),

gambling_behavior AS 
(
    SELECT 
        t.cust_id,
        ROUND(SUM(CASE WHEN m.category = 'Gambling' THEN t.amount ELSE 0 END) 
        * 1.0 / NULLIF(SUM(t.amount), 0), 3) AS gambling_ratio
    FROM transactions AS t
    JOIN merchants AS m ON t.m_id = m.m_id
    GROUP BY t.cust_id
),

loan_health AS 
(
    SELECT 
        cust_id,
        COUNT(CASE WHEN loan_status = 'Active' THEN 1 END) AS active_loans,
        COUNT(CASE WHEN loan_status = 'Defaulted' THEN 1 END) AS past_defaults
    FROM loans
    GROUP BY cust_id
),

peer_groups AS (
    SELECT 
        c.cust_id,
        c.annual_income,
        COALESCE(l.active_loans, 0) AS active_loans,
        NTILE(5) OVER (ORDER BY c.annual_income) AS income_percentile_group
    FROM customers c
    LEFT JOIN loan_health l ON c.cust_id = l.cust_id
),

peer_benchmarks AS (
    SELECT 
        *,
        AVG(active_loans) OVER (PARTITION BY income_percentile_group) AS peer_avg_loans
    FROM peer_groups
),

transaction_recency AS 
(
    SELECT 
        cust_id,
        CURRENT_DATE - MAX(txn_date) AS days_since_last_txn
    FROM transactions
    GROUP BY cust_id
),

scoring_base AS 
(
    SELECT 
        c.cust_id,
        c.annual_income,
        -- Rule 1: High Gambling (>20% of spend)
        CASE WHEN g.gambling_ratio > 0.20 THEN 20 ELSE 0 END AS score_gambling,
		
        -- Rule 2: Previous Default History
        CASE WHEN l.past_defaults > 0 THEN 25 ELSE 0 END AS score_history,
		
        -- Rule 3: High Relative Volatility (Anomaly Detection)
        -- Flagging if standard deviation is more than 2x the average transaction size
        CASE WHEN b.volatility_index > 2.0 THEN 10 ELSE 0 END AS score_volatility,
		
        -- Rule 4: Income to Spend Stress
        CASE WHEN b.est_monthly_spend > (c.annual_income / 12) * 0.8 THEN 10 ELSE 0 END AS score_debt_stress,
		
        -- Rule 5: New Customer Risk
        CASE WHEN c.join_date > CURRENT_DATE - INTERVAL '6 months' THEN 5 ELSE 0 END AS score_tenure,
		
        -- Rule 6: Account Dormancy 
        CASE WHEN r.days_since_last_txn > 90 THEN 5 ELSE 0 END AS score_dormancy,
		
        -- Rule 7: Dynamic Loan Risk (Peer Outliers)
        CASE WHEN pb.active_loans > (pb.peer_avg_loans + 2) THEN 25 ELSE 0 END AS score_peer_outlier
     
    FROM customers AS c
    LEFT JOIN gambling_behavior AS g ON c.cust_id = g.cust_id
    LEFT JOIN customer_stats AS b ON c.cust_id = b.cust_id
    LEFT JOIN loan_health AS l ON c.cust_id = l.cust_id
    LEFT JOIN transaction_recency AS r ON c.cust_id = r.cust_id
    LEFT JOIN peer_benchmarks AS pb ON c.cust_id = pb.cust_id
)

SELECT 
    *,
    (score_gambling + score_history + score_volatility + 
     score_debt_stress + score_tenure + score_dormancy + score_peer_outlier) AS final_risk_score
FROM scoring_base
ORDER BY final_risk_score DESC;