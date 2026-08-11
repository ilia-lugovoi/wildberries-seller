from pathlib import Path
from ingestion.extract.csv_reader import read_csv_file
from ingestion.extract.excel_reader import read_excel_file
from ingestion.transform.column_names import rename_columns
from ingestion.load.postgres import PostgresLoader
from ingestion.utils.logger import logger

DATA_DIR = Path(__file__).resolve().parent.parent / "raw_sources"

FILES_MAP = {
    # CSV
    "orders.csv": ("orders", "csv"),
    "sales.csv": ("sales", "csv"),
    "sales_report.csv": ("report", "csv"),
    "stock.csv": ("stock", "csv"),
    "supplies.csv": ("supplies", "csv"),
    # Excel
    "cost_price.xlsx": ("cost_price", "excel"),
    "nomenclature.xlsx": ("nomenclature", "excel"),
    "tariffs_delivery.xlsx": ("tariffs_delivery", "excel"),
}

def run_ingestion():
    logger.info("Начало процесса Ingestion...")
    loader = PostgresLoader()

    for file_name, (table_name, file_type) in FILES_MAP.items():
        file_path = DATA_DIR / file_name
        if not file_path.exists():
            logger.warning(f"Файл {file_name} не найден, пропускаем.")
            continue

        if file_type == "csv":
            df = read_csv_file(file_path)
        else:
            df = read_excel_file(file_path)

        # Очищаем колонки
        df = rename_columns(df)

        # Загружаем в БД
        loader.load_dataframe(df, table_name=table_name, schema="raw")

    logger.info("Ingestion процесс успешно завершен!")

if __name__ == "__main__":
    run_ingestion()