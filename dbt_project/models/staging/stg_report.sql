select *
from {{ source('raw', 'report') }}