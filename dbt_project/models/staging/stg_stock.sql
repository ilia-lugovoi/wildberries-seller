select *
from {{ source('raw', 'stock') }}