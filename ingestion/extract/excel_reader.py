import pandas as pd
from pathlib import Path
from ingestion.utils.logger import logger

def read_excel_file(file_path: Path, sheet_name: str | int = 0) -> pd.DataFrame:
    try:
        logger.info(f"Чтение Excel файла: {file_path}")
        df = pd.read_excel(file_path, sheet_name=sheet_name)
        return df
    except Exception as e:
        logger.error(f"Ошибка при чтении {file_path}: {e}")
        raise