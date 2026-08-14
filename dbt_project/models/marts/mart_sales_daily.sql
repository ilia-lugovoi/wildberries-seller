with sales as (
    select
        id,
        sale_dt,
        barcode,
        region,
        case
            when is_realization = false then 0
            when finished_price < 0 then -1
            else quantity
        end as quantity,
        finished_price,
        for_pay
    from {{ ref('stg_sales') }}
    where sale_dt > '2021-12-28'

),

cost_price as (
    select *
    from {{ ref('stg_cost_price') }}

),

merge_cost_price as (
    select
        s.*,
        case
            when s.finished_price < 0 then -c.cost_price
            else c.cost_price
        end as cost_price
    from sales s
    left join cost_price c
        on s.barcode = c.barcode
),

sales_agg as (
    select
        sale_dt,
        barcode,
        region,
        count(*) as sales_count,
        coalesce(sum(quantity), count(*)) as sales_quantity,
        sum(finished_price) * 3 as revenue,
        sum(for_pay) * 3 as for_pay,
        sum(cost_price) as cost_price
    from merge_cost_price
    group by sale_dt, barcode, region
),

nomenclature as (
    select *
    from {{ ref('int_nomenclature') }}

),

final as (
    select
        s.*,
        n.supplier_article,
        n.subject,
        n.category,
        n.brand,
        n.size,
        n.size_group,
        n.color,
        n.orig_country,
        n.rec_price
    from sales_agg s
    left join nomenclature n
        on s.barcode = n.barcode
    
)

select
    sale_dt,
    barcode,
    region,
    sales_count,
    sales_quantity,
    revenue,
    rec_price,
    for_pay,
    cost_price,
    for_pay - cost_price as gross_profit,
    supplier_article,
    subject,
    category,
    brand,
    size,
    size_group,
    color,
    orig_country

from final