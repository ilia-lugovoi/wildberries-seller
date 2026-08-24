with inventory as (

    select
        last_change_date,
        barcode,

        sum(available_stock) as available_stock,
        sum(in_way_to_client) as in_way_to_client,
        sum(in_way_from_client) as in_way_from_client,
        sum(total_stock) as total_stock,

        sum(available_stock_cost) as available_stock_cost,
        sum(in_way_to_client_cost) as in_way_to_client_cost,
        sum(in_way_from_client_cost) as in_way_from_client_cost,
        sum(total_stock_cost) as total_stock_cost,

        max(cost_price) as cost_price,

        max(is_cost_price_missing) as is_cost_price_missing

    from {{ ref('mart_warehouse_inventory_daily') }}

    group by
        last_change_date,
        barcode

),

-- Основа таблицы продаж остатков
inventory_intervals as (

    select
        last_change_date,
        barcode,

        lead(last_change_date) over (
            partition by barcode
            order by last_change_date
        ) as next_change_date

    from inventory

),

sales as (

    select
        sale_dt,
        barcode,

        sales_quantity,
        revenue,
        for_pay,
        cost_price,
        gross_profit

    from {{ ref('mart_sales_for_inventory') }}

),

-- Создаем таблицу продаж остатков
sales_for_inventory as (

    select
        i.last_change_date,
        i.barcode,

        coalesce(sum(s.sales_quantity), 0) as sales_quantity,
        coalesce(sum(s.revenue), 0) as revenue,
        coalesce(sum(s.for_pay), 0) as for_pay,
        coalesce(sum(s.cost_price), 0) as sales_cost_price,
        coalesce(sum(s.gross_profit), 0) as gross_profit

    from inventory_intervals i

    left join sales s
        on i.barcode = s.barcode
        and s.sale_dt >= i.last_change_date
        and (
            i.next_change_date is null
            or s.sale_dt < i.next_change_date
        )

    group by
        i.last_change_date,
        i.barcode

),

inventory_result as (

    select
        i.last_change_date,
        i.barcode,

        i.available_stock,
        i.in_way_to_client,
        i.in_way_from_client,
        i.total_stock,

        i.available_stock_cost,
        i.in_way_to_client_cost,
        i.in_way_from_client_cost,
        i.total_stock_cost,

        s.sales_quantity,
        s.revenue,
        s.for_pay,
        s.sales_cost_price,
        s.gross_profit,

        i.cost_price,
        i.is_cost_price_missing,

        0 as is_stock_missing

    from inventory i

    left join sales_for_inventory s
        on i.last_change_date = s.last_change_date
        and i.barcode = s.barcode

),

sales_only as (

    select
        s.sale_dt as last_change_date,
        s.barcode,

        0 as available_stock,
        0 as in_way_to_client,
        0 as in_way_from_client,
        0 as total_stock,

        0 as available_stock_cost,
        0 as in_way_to_client_cost,
        0 as in_way_from_client_cost,
        0 as total_stock_cost,

        s.sales_quantity,
        s.revenue,
        s.for_pay,
        s.cost_price as sales_cost_price,
        s.gross_profit,

        s.cost_price,

        case
            when s.cost_price is null then 1
            else 0
        end as is_cost_price_missing,

        1 as is_stock_missing

    from sales s

    where not exists (

        select 1

        from inventory_intervals i

        where i.barcode = s.barcode
          and s.sale_dt >= i.last_change_date
          and (
              i.next_change_date is null
              or s.sale_dt < i.next_change_date
          )

    )

),

final as (
    select *
    from inventory_result

    union all

    select *
    from sales_only
)

select
    f.*,
    n.category,
    n.subject,
    n.supplier_article,
    n.brand,
    n.orig_country,
    n.color,
    n.size_group,
    n.size

from final as f
left join {{ ref('int_nomenclature') }} n
    on f.barcode = n.barcode