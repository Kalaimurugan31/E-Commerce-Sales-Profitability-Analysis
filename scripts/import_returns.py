import pandas as pd
import mysql.connector
from getpass import getpass

# CSV file path
file_path = r"C:\Users\kalai\OneDrive\Documents\sql project\sample_-_superstore.csv"

# Load CSV
df = pd.read_csv(file_path)

# Clean column names
df.columns = (
    df.columns.astype(str)
    .str.replace('\ufeff', '', regex=False)
    .str.strip()
    .str.lower()
    .str.replace(r'\s+', '_', regex=True)
)
print("Available columns:", df.columns.tolist())

print("CSV loaded:", df.shape)
print("Columns:", df.columns.tolist())

# Select required columns
df = df[["order_id", "returned"]].dropna()

# Connect to MySQL
connection = mysql.connector.connect(
    host="localhost",
    user=input("MySQL username: "),
    password=getpass("Enter MySQL password: "),
    database="superstore_project"
)

cursor = connection.cursor()

# Create Returns table
cursor.execute("""
CREATE TABLE IF NOT EXISTS returns (
    `Order ID` VARCHAR(50),
    Returned VARCHAR(10)
)
""")

# Clear existing records
cursor.execute("TRUNCATE TABLE returns")

# Insert records
sql = """
INSERT INTO returns (`Order ID`, Returned)
VALUES (%s, %s)
"""

data = list(df.itertuples(index=False, name=None))

cursor.executemany(sql, data)
connection.commit()

print("Returns data imported successfully!")
print("Total records imported:", len(data))

cursor.close()
connection.close()
