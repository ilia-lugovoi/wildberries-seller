select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      select
    count(*) as actual_count
from "wb_analytics"."public"."stg_nomenclature"
having count(*) != 567
      
    ) dbt_internal_test