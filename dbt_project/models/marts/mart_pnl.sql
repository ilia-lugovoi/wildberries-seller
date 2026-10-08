with data_agg as (
    select
        operation_date,
        barcode,
        stock_name,

        sum(
            case
                when supplier_oper_name in (
                    'Продажа',
                    'Корректная продажа',
                    'Сторно возвратов'
                )
                then quantity
                else 0
            end
        ) as sales_qty,

        sum(
            case
                when supplier_oper_name in (
                    'Возврат',
                    'Сторно продаж',
                    'Корректный возврат'
                )
                then quantity
                else 0
            end
        ) as return_qty,

        sum(
            case
                when supplier_oper_name in (
                    'Продажа',
                    'Корректная продажа',
                    'Сторно возвратов'
                )
                then retail_price_withdisc_rub * quantity
                else 0
            end
        ) as sales_retail_price_withdisc_rub,

        sum(
            case
                when supplier_oper_name in (
                    'Возврат',
                    'Сторно продаж',
                    'Корректный возврат'
                )
                then retail_price_withdisc_rub * quantity
                else 0
            end
        ) as return_retail_price_withdisc_rub,

        sum(
            case
                when supplier_oper_name in (
                    'Продажа',
                    'Корректная продажа',
                    'Сторно возвратов'
                )
                then ppvz_for_pay * quantity
                else 0
            end
        ) as sales_for_pay,

        sum(
            case
                when supplier_oper_name in (
                    'Возврат',
                    'Сторно продаж',
                    'Корректный возврат'
                )
                then ppvz_for_pay * quantity
                else 0
            end
        ) as return_for_pay,

        sum(
            case
                when supplier_oper_name in (
                    'Логистика',
                    'Оплата брака'
                )
                then delivery_rub
                else 0
            end
        ) as logistics_expense,

        sum(
            case
                when supplier_oper_name = 'Логистика сторно'
                then delivery_rub
                else 0
            end
        ) as logistics_storno,
        
        sum(
            case
                when supplier_oper_name in (
                    'Штрафы',
                    'Штрафы и доплаты',
                    'Штраф МП',
                    'Штраф'
                )
                then penalty
                else 0
            end
        ) as penalties

    from {{ ref('int_pnl') }} 
    group by operation_date, barcode, stock_name
),

prep_data as (
    select
        da.operation_date,
        da.barcode,
        da.stock_name,

        da.sales_qty,
        da.return_qty,
        da.sales_qty - da.return_qty as net_sales_qty,

        da.sales_retail_price_withdisc_rub,
        da.return_retail_price_withdisc_rub,

        da.sales_retail_price_withdisc_rub
            - da.return_retail_price_withdisc_rub
            as net_retail_price_withdisc_rub,

        da.sales_for_pay,
        da.return_for_pay,

        da.sales_for_pay - da.return_for_pay as net_for_pay,

        c.cost_price * (da.sales_qty - da.return_qty) as cogs,

        c.cost_price is not null as is_cogs_available,

        (da.sales_retail_price_withdisc_rub - da.return_retail_price_withdisc_rub)
            - (da.sales_for_pay - da.return_for_pay)
            as wb_commission,

        da.logistics_expense - da.logistics_storno as net_logistics,

        da.penalties

    from data_agg da
    left join {{ ref('stg_cost_price') }} c
        on da.barcode = c.barcode
),

final_data as (
    select
        pd.*,

        pd.net_for_pay - pd.cogs as gross_profit,

        pd.net_for_pay
            - pd.cogs
            - pd.wb_commission
            - pd.net_logistics
            - pd.penalties
            as marketplace_contribution,

        n.supplier_article,
        n.subject,
        n.category,
        n.brand,
        n.size,
        n.size_group,
        n.color,
        n.orig_country,
        n.rec_price
    from prep_data pd
    left join {{ ref('int_nomenclature') }} n
        on pd.barcode = n.barcode
)

select * from final_data