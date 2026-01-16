import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()
num_customers = 100000

print("Step 1: Generating Customer Demographics with Join Dates...")
countries = ['US', 'IN', 'GB', 'DE', 'FR', 'UAE']
customers = [{
    'cust_id': i,
    'name': fake.name(),
    'country': random.choice(countries),
    'annual_income': random.randint(25000, 150000),
    'job_tenure_years': random.randint(0, 20),
    'is_bank_employee': np.random.choice([0, 1], p=[0.98, 0.02]),
    # Generate join_date within the last 3 years
    'join_date': fake.date_between(start_date='-3y', end_date='today')
} for i in range(1, num_customers + 1)]

df_customers = pd.DataFrame(customers)
df_customers.to_csv('dim_customers.csv', index=False)

# ... [Steps 2, 3, and 4 remain the same as the original script] ...
