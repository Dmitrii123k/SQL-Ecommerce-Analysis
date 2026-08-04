from sqlalchemy import create_engine
import pandas as pd

engine = create_engine(
    "postgresql+psycopg2://postgres:postgres123@localhost:5432/ecommerce"
)

df = pd.read_excel("data/raw/Online Retail.xlsx")

df.columns = [
    "invoice_no",
    "stock_code",
    "description",
    "quantity",
    "invoice_date",
    "unit_price",
    "customer_id",
    "country",
]

df.to_sql(
    "online_retail",
    engine,
    if_exists="append",
    index=False,
    chunksize=10000,
    method="multi",
)

print("Загрузка завершена.")