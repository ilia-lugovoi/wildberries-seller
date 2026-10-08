select
    rrd_id::bigint as rrd_id,
    shk_id::bigint as shk_id,
    
    barcode::text as barcode,
    subject_name::text as subject,
    brand_name::text as brand,
    ts_name::text as ts_name,

    doc_type_name::text as doc_type_name,
    supplier_oper_name::text as supplier_oper_name,

    rr_dt::date as operation_date,
    order_dt::date as order_dt,
    sale_dt::date as sale_dt,

    quantity::numeric as quantity,
    return_amount::numeric as return_amount,

    retail_price::numeric as retail_price,
    sale_percent::numeric as sale_percent,
    retail_price_withdisc_rub::numeric as retail_price_withdisc_rub,
    commission_percent::numeric as commission_percent,
    ppvz_for_pay::numeric as ppvz_for_pay,
    ppvz_sales_commission::numeric as ppvz_sales_commission,
    ppvz_vw::numeric as ppvz_vw,
    ppvz_reward::numeric as ppvz_reward,
    ppvz_vw_nds::numeric as ppvz_vw_nds,

    delivery_rub::numeric as delivery_rub,

    gi_id::bigint as gi_id,
    gi_box_type_name::text as gi_box_type_name,

    bonus_type_name::text as bonus_type_name,
    penalty::numeric as penalty,
    additional_payment::numeric as additional_payment,

    realizationreport_id::bigint as realizationreport_id,
    rid::bigint as rid,
    id::text as id,
    srid::text as srid,
    nm_id::bigint as nm_id,
    sa_name::text as sa_name,
    dag_date::date as load_date,
    date_from::date as report_date_from,
    date_to::date as report_date_to,

    delivery_amount::numeric as delivery_amount,

    office_name::text as stock_name,
    site_country::text as site_country,
    ppvz_office_id::bigint as ppvz_office_id,

    supplier_promo::numeric as supplier_promo,

    ppvz_spp_prc::numeric as ppvz_spp_prc,
    ppvz_kvw_prc_base::numeric as ppvz_kvw_prc_base,
    ppvz_kvw_prc::numeric as ppvz_kvw_prc

from {{ source('raw', 'report') }}