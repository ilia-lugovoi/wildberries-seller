select *
from {{ source('raw', 'sales') }}