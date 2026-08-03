from sqlalchemy import create_engine, text
from ingestion.config.settings import DATABASE_URL, RAW_SCHEMA
from ingestion.utils.logger import logger

class PostgresLoader:
    def __init__(self):
        self.engine = create_engine(DATABASE_URL)
        self._ensure_schema_exists()

    def _ensure_schema_exists(self, schema_name: str = RAW_SCHEMA):
        """Создает схему в PostgreSQL, если она не существует."""
        with self.engine.begin() as conn:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema_name};"))

    def load_dataframe(
        self, 
        df, 
        table_name: str, 
        schema: str = RAW_SCHEMA, 
        if_exists: str = "replace"
    ) -> None:
        try:
            logger.info(f"Загрузка {len(df)} строк в {schema}.{table_name}...")
            df.to_sql(
                name=table_name,
                con=self.engine,
                schema=schema,
                if_exists=if_exists,
                index=False,
                chunksize=5000,
                method="multi"
            )
            logger.info(f"Таблица {schema}.{table_name} успешно загружена.")
        except Exception as e:
            logger.error(f"Ошибка загрузки таблицы {table_name}: {e}")
            raise