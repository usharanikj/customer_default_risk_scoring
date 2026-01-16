import pandas as pd
import numpy as np
from faker import Faker
import random

fake = Faker()
num_customers = 100000

print("Step 1: Generating Customer Demographics...")
countries = ['US', 'IN', 'GB', 'DE', 'FR', 'UAE']
customers = [{
    'cust_id': i,
    'name': fake.name(),
    'country': random.choice(countries),
    'annual_income': random.randint(25000, 150000),
    'job_tenure_years': random.randint(0, 20),
    'is_bank_employee': np.random.choice([0, 1], p=[0.98, 0.02])
} for i in range(1, num_customers + 1)]

df_customers = pd.DataFrame(customers)
df_customers.to_csv('dim_customers.csv', index=False)

print("Step 2: Generating Merchants...")
merchants = [
    {'m_id': 1, 'm_name': 'Grand Casino', 'category': 'Gambling'},
    {'m_id': 2, 'm_name': 'BetWay Online', 'category': 'Gambling'},
    {'m_id': 3, 'm_name': 'Whole Foods', 'category': 'Essentials'},
    {'m_id': 4, 'm_name': 'Walmart', 'category': 'Essentials'},
    {'m_id': 5, 'm_name': 'Apple Store', 'category': 'Electronics'},
    {'m_id': 6, 'm_name': 'Steam Games', 'category': 'Entertainment'}
]
df_merchants = pd.DataFrame(merchants)
df_merchants.to_csv('dim_merchants.csv', index=False)

print("Step 3: Generating 2 Million Transactions (This may take a minute)...")
# Vectorized approach for speed
txn_cust_ids = np.random.randint(1, num_customers + 1, size=2000000)
txn_m_ids = np.random.randint(1, 7, size=2000000)
txn_amounts = np.round(np.random.uniform(10, 5000, size=2000000), 2)

df_txns = pd.DataFrame({
    'txn_id': range(1, 2000001),
    'cust_id': txn_cust_ids,
    'm_id': txn_m_ids,
    'amount': txn_amounts,
    'txn_date': [fake.date_between(start_date='-1y', end_date='today') for _ in range(2000000)]
})
df_txns.to_csv('fact_transactions.csv', index=False)

print("Step 4: Generating Loan Data...")
loans = [{
    'loan_id': i,
    'cust_id': random.randint(1, num_customers),
    'loan_status': random.choice(['Active', 'Closed', 'Defaulted']),
    'outstanding_amt': random.randint(1000, 50000)
} for i in range(1, 40001)] # 40% loan penetration

pd.DataFrame(loans).to_csv('fact_loans.csv', index=False)
print("Success! 4 CSV files generated.")

# Need to add a join_date column to the dim_customers table in the Python generation script
