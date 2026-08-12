select
    штрих_код::text as barcode,
    себестоимость::numeric as cost_price

from {{ source('raw', 'cost_price') }}