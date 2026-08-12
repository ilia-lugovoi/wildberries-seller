select
    id::text as id,

    date::timestamp as sale_dt,
    lastchangedate::timestamp as last_change_dt,

    supplierarticle::text as supplier_article,
    techsize::text as tech_size,
    barcode::text as barcode,

    quantity::integer as quantity,

    totalprice::numeric(14, 2) as total_price,
    discountpercent::numeric(5, 2) as discount_percent,

    issupply::boolean as is_supply,
    isrealization::boolean as is_realization,

    promocodediscount::numeric(14, 2) as promocode_discount,

    warehousename::text as warehouse_name,
    countryname::text as country,
    oblastokrugname::text as oblast,
    regionname::text as region,

    saleid::text as sale_id,
    odid::bigint as od_id,

    forpay::numeric(14, 2) as for_pay,
    finishedprice::numeric(14, 2) as finished_price,
    pricewithdisc::numeric(14, 2) as price_with_disc,

    nmid::bigint as nm_id,

    subject::text as subject,
    category::text as category,
    brand::text as brand,

    srid::text as sr_id

from {{ source('raw', 'sales') }}