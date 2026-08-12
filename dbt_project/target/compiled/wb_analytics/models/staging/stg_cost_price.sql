select
    штрих_код::text as barcode,
    себестоимость::numeric as cost_price

from "wb_analytics"."raw"."cost_price"