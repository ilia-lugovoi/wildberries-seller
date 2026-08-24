select
    id,
    incomeid as income_id,

    date::date as supply_date,
    lastchangedate::date as last_change_date,

    supplierarticle as supplier_article,
    techsize as tech_size,
    barcode::text as barcode,

    quantity::integer as quantity,

    warehousename as warehouse_name,
    nmid,
    status


from {{ source('raw', 'supplies') }}