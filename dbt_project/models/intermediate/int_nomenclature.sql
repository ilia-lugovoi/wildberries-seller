with nomenclature as (

    select *
    from {{ ref('stg_nomenclature') }}

),

size_mapping as (

    select *
    from {{ ref('size_mapping') }}

)

select
    n.*,
    m.size_group

from nomenclature n

left join size_mapping m
    on n.size = m.size