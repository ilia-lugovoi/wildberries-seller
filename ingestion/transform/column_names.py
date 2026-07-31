import re


def to_snake_case(column_name: str) -> str:

    column_name = column_name.strip().lower()

    column_name = re.sub(r"[ /()-]+", "_", column_name)

    column_name = re.sub(r"__+", "_", column_name)

    return column_name