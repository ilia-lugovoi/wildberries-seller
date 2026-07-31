from sqlalchemy import create_engine

from config.settings import DB_CONFIG


def get_engine():

    connection_string = (
        f"postgresql+psycopg2://"
        f"{DB_CONFIG['user']}:{DB_CONFIG['password']}@"
        f"{DB_CONFIG['host']}:{DB_CONFIG['port']}/"
        f"{DB_CONFIG['database']}"
    )

    return create_engine(connection_string)