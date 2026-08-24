select
    id::text as id,

    date::date as order_dt,
    lastchangedate::date as last_change_dt,

    supplierarticle::text as supplier_article,
    techsize::text as tech_size,
    barcode::text as barcode,

    quantity::integer as quantity,

    totalprice::numeric(14, 2) as total_price,
    discountpercent::numeric(5, 2) as discount_percent,

    warehousename::text as warehouse_name,
    oblast::text as oblast,

    odid::bigint as od_id,
    nmid::bigint as nm_id,

    subject::text as subject,
    category::text as category,
    brand::text as brand,

    iscancel::boolean as is_cancel,
    cancel_dt::date as cancel_dt

from {{ source('raw', 'orders') }}