
import pandas as pd
import mysql.connector
from getpass import getpass

# 1. Read CSV file
file_path = r"C:\Users\kalai\OneDrive\Documents\sql project\Superstore_Orders_2.csv"
df = pd.read_csv(file_path, encoding="utf-8-sig")

print("CSV loaded:", df.shape)

# 2. Rename column
df.rename(columns={"ProductID": "Product ID"}, inplace=True)

# 3. Convert date columns
for col in ["Order Date", "Ship Date"]:
    df[col] = pd.to_datetime(
        df[col], dayfirst=True, errors="coerce"
    ).dt.date

# 4. Handle postal codes and missing values
df["Postal Code"] = df["Postal Code"].apply(
    lambda x: None if pd.isna(x) else str(x).replace(".0", "")
)

df = df.astype(object).where(pd.notna(df), None)

# 5. Connect to MySQL
password = getpass("Enter MySQL password: ")

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password=password,
    database="superstore_project"
)

cursor = conn.cursor()

# 6. Insert records
sql = """
INSERT INTO orders (
    `Row ID`, `Order ID`, `Order Date`, `Ship Date`,
    `Ship Mode`, `Customer ID`, `Customer Name`,
    Segment, `Country/Region`, City, `State/Province`,
    `Postal Code`, Region, `Product ID`, Category,
    `Sub-Category`, `Product Name`, Sales, Quantity,
    Discount, Profit
)
VALUES (
    %s, %s, %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s, %s, %s
)
"""

records = list(df.itertuples(index=False, name=None))

cursor.executemany(sql, records)
conn.commit()

print("Data imported successfully!")
print("Total records imported:", cursor.rowcount)

cursor.close()
conn.close()
