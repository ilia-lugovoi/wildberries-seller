select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select barcode
from "wb_analytics"."public"."stg_cost_price"
where barcode is null



      
    ) dbt_internal_test