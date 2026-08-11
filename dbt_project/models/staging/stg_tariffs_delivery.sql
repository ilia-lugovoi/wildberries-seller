select *
from {{ source('raw', 'tariffs_delivery') }}