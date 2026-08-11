select *
from {{ source('raw', 'supplies') }}