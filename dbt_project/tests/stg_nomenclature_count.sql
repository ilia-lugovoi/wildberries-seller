select
    count(*) as actual_count
from {{ ref('stg_nomenclature') }}
having count(*) != 567