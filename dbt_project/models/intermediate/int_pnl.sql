select
    rrd_id,
    shk_id,

    barcode as source_barcode,

    case
        when barcode is null
            or barcode not in (
                select distinct barcode
                from {{ ref('int_nomenclature') }}
                where barcode is not null
            )
        then 'UNKNOWN'
        else barcode
    end as barcode,

    doc_type_name,
    supplier_oper_name,

    operation_date,
    order_dt,
    sale_dt,

    quantity,
    return_amount,

    retail_price * 3.5 as retail_price, -- *3.5 - корректировка обезличенных данных
    sale_percent,

    retail_price_withdisc_rub * 3.5 as retail_price_withdisc_rub, -- *3.5 - корректировка обезличенных данных
    commission_percent,

    ppvz_for_pay * 3.5 as ppvz_for_pay, -- *3.5 - корректировка обезличенных данных
    ppvz_sales_commission,
    ppvz_vw,
    ppvz_reward,
    ppvz_vw_nds,

    delivery_rub,

    gi_id,
    gi_box_type_name,

    bonus_type_name,
    penalty,
    additional_payment,

    realizationreport_id,
    rid,
    srid,
    nm_id,
    sa_name,

    load_date,
    report_date_from,
    report_date_to,

    delivery_amount,

    stock_name,
    site_country,
    ppvz_office_id,

    supplier_promo,

    ppvz_spp_prc,
    ppvz_kvw_prc_base,
    ppvz_kvw_prc

from {{ ref('stg_report') }}
where operation_date > '2021-12-31' -- В этот день и месяц была проведена только одна и тестовая продажа с возвратом, а с января 22 года начались реальные продажи