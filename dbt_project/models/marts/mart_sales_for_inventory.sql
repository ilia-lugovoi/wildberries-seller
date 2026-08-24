with sales as (

    select
        sale_dt,
        barcode,

        sum(sales_quantity) as sales_quantity,
        sum(revenue) as revenue,
        sum(for_pay) as for_pay,
        sum(cost_price) as cost_price,
        sum(gross_profit) as gross_profit

    from {{ ref('mart_sales_daily') }}

    group by
        sale_dt,
        barcode

),

stock_barcodes as (

    select distinct
        barcode
    from {{ ref('mart_warehouse_inventory_daily') }}

)

select
    s.*,

    case
        when sb.barcode is null then 1
        else 0
    end as is_stock_missing

from sales s
left join stock_barcodes sb
    on s.barcode = sb.barcode