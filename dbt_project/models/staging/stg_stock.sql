select
    id,
    lastchangedate::date as last_change_date,

    supplierarticle as supplier_article,
    techsize as tech_size,
    barcode::text as barcode,

    quantity,
    quantityfull as quantity_full,
    quantitynotinorders as quantity_not_in_orders,

    issupply as is_supply,
    isrealization as is_realization,

    inwaytoclient as in_way_to_client,
    inwayfromclient as in_way_from_client,

    warehouse,
    warehousename as warehouse_name,

    nmid,
    subject,
    category,
    daysonsite as days_on_site,
    brand,
    sccode as sc_code,

    price::numeric(14, 2) as price,
    discount::numeric(5, 2) as discount


from {{ source('raw', 'stock') }}