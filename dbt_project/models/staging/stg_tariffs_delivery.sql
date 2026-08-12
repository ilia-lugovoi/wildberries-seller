select
    subject,
    процент_комиссии as commis_prnt,
    процент_комиссии_по_fbs as fbs_commis_prnt,
    cтоимость_логистики as logist_price,
    базовая_стоимость_хранения as base_Storage_cost,
    платная_приёмка__едтовара as paid_goods_acceptance,
    расчёт_по_фактическим_габаритам_т as calc_on_fact_dimensions_t

from {{ source('raw', 'tariffs_delivery') }}