import os
from pathlib import Path
from dotenv import load_dotenv

# Определяем корень проекта и путь к .env
PROJECT_ROOT = Path(__file__).resolve().parents[2]
ENV_PATH = PROJECT_ROOT / "ingestion" / ".env"

# Явно подгружаем .env из папки ingestion
load_dotenv(dotenv_path=ENV_PATH)

RAW_DATA_PATH = PROJECT_ROOT / "raw_sources"

# Переменные БД
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

if not DB_PASSWORD:
    raise ValueError("ОШИБКА: Пароль БД не задан в .env файле!")

RAW_SCHEMA = os.getenv("RAW_SCHEMA", "raw")

# Собираем готовую строку подключения для SQLAlchemy
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"