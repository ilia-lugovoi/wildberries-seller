import pandas as pd
from pathlib import Path
from ingestion.utils.logger import logger

def read_csv_file(file_path: Path) -> pd.DataFrame:
    try:
        logger.info(f"Чтение CSV файла: {file_path}")
        # sep=None авто-определяет разделитель (запятая, точка с запятой, табуляция)
        df = pd.read_csv(file_path, sep=None, engine="python", encoding="utf-8")
        return df
    except Exception as e:
        logger.error(f"Ошибка при чтении {file_path}: {e}")
        raise