select
    supplierarticle as supplier_article,
    subject,
    category,
    brand,

    case
        when barcode is null then '2000939535947'
        else barcode::text
    end as barcode,

    размер as size,
    рекомендуемая_цена as rec_price,
    цвет as color,
    страна_производства as orig_country

from "wb_analytics"."raw"."nomenclature"