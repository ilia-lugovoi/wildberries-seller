select
    supplierarticle,
    subject,
    category,
    brand,

    case
        when barcode is null then '2000939535947'
        else barcode::text
    end as barcode,

    размер,
    рекомендуемая_цена,
    цвет,
    страна_производства

from {{ source('raw', 'nomenclature') }}