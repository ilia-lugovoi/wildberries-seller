from sqlalchemy import text


def create_schema(engine, schema_name):

    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema_name};"))