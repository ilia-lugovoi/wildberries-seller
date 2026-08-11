select
    count(*) as actual_count
from "wb_analytics"."public"."stg_nomenclature"
having count(*) != 567