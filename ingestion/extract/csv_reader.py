from pathlib import Path

import pandas as pd


def read_csv(path: Path) -> pd.DataFrame:
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\Orders.csv';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\Sales.csv';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\Stock.csv';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\Supplies.csv';
    r'C:\Users\ilyal\Documents\Dosc\projects\wildberries-seller\raw_sources\SalesReport.csv'

    return pd.read_csv(path)