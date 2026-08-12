import pandas as pd


def validate_dataframe(
    df: pd.DataFrame,
    table_name: str,
    required_columns: list[str],
) -> None:
    """
    Проверяет DataFrame перед загрузкой в raw.

    Проверки:
    1. DataFrame не пустой.
    2. Все обязательные колонки присутствуют.
    3. В DataFrame есть строки.
    """

    if df.empty:
        raise ValueError(
            f"Таблица '{table_name}' пустая."
        )

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing_columns:
        raise ValueError(
            f"Таблица '{table_name}' не содержит "
            f"обязательные колонки: {missing_columns}"
        )