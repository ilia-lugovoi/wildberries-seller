select
    subject,
    процент_комиссии as commission_percent,
    процент_комиссии_по_fbs as fbs_commission_percent,
    cтоимость_логистики as logistics_price,
    базовая_стоимость_хранения as base_storage_cost,
    платная_приёмка__едтовара as paid_goods_acceptance,
    расчёт_по_фактическим_габаритам_т as calculate_on_actual_dimensions

from {{ source('raw', 'tariffs_delivery') }}