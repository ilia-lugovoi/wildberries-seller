import re
import pandas as pd

def sanitize_column_name(col: str) -> str:
    """Перевод названий колонок в snake_case и очистка от спецсимволов."""
    col = col.strip().lower()
    col = re.sub(r"[\s/\-]+", "_", col)
    col = re.sub(r"[^\w_]", "", col)
    return col

def rename_columns(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.columns = [sanitize_column_name(col) for col in df.columns]
    return df