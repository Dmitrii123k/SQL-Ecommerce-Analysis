from pathlib import Path
import pandas as pd

# Корневая папка проекта
project_dir = Path(__file__).resolve().parent.parent

# Пути к файлам
input_file = project_dir / "data" / "raw" / "Online Retail.xlsx"
output_dir = project_dir / "data" / "processed"
output_file = output_dir / "online_retail.csv"

# Создаем папку processed, если ее нет
output_dir.mkdir(parents=True, exist_ok=True)

# Читаем Excel
df = pd.read_excel(input_file)

# Преобразуем дату в универсальный формат
df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

# Сохраняем CSV
df.to_csv(
    output_file,
    sep=";",
    index=False,
    encoding="utf-8",
    decimal="."
)

print(f"✅ Готово! Файл сохранен:\n{output_file}")
print(f"Количество строк: {len(df):,}")