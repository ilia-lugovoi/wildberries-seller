with stock_daily as (
    select
        last_change_date,
        barcode,
        warehouse_name,

        round(sum(quantity), 0) as available_stock,
        round(sum(in_way_to_client), 0) as in_way_to_client,
        round(sum(in_way_from_client), 0) as in_way_from_client,
        round((sum(quantity) + sum(in_way_to_client) + sum(in_way_from_client)), 0) as total_stock

    from {{ ref('stg_stock') }}

    where barcode is not null
      and last_change_date is not null

    group by
        last_change_date,
        barcode,
        warehouse_name

)

select
    sd.*,
    cp.cost_price,
    case
        when sd.available_stock > 0 then
            round(sd.available_stock * cp.cost_price, 2)
        else null
    end as available_stock_cost,
    case
        when sd.in_way_to_client > 0 then
            round(sd.in_way_to_client * cp.cost_price, 2)
        else null
    end as in_way_to_client_cost,
    case
        when sd.in_way_from_client > 0 then
            round(sd.in_way_from_client * cp.cost_price, 2)
        else null
    end as in_way_from_client_cost,
    case
        when sd.total_stock > 0 then
            round(sd.total_stock * cp.cost_price, 2)
        else null
    end as total_stock_cost,
    case
        when cp.cost_price is null then 1
        else 0
    end as is_cost_price_missing,
    n.category,
    n.subject,
    n.supplier_article,
    n.brand,
    n.orig_country,
    n.color,
    n.size_group,
    n.size

from stock_daily sd
left join {{ ref('stg_cost_price') }} cp
    on sd.barcode = cp.barcode
left join {{ ref('int_nomenclature') }} n
    on sd.barcode = n.barcode