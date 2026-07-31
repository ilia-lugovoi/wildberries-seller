from pathlib import Path

import pandas as pd


def read_excel(path: Path) -> pd.DataFrame:
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\СПР_Номенклатуры.xlsx';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\СПР_Себестоимость.xlsx';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\СПР_ТарифыДоставка.xlsx'

    return pd.read_excel(path)