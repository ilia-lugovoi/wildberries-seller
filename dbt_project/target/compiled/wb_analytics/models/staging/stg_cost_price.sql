with source as (

    select *
    from "wb_analytics"."raw"."cost_price"

),

final as (

    select
        штрих_код::text as barcode,
        себестоимость::numeric as cost_price

    from source

)

select *
from final