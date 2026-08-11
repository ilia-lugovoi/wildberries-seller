select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    barcode as unique_field,
    count(*) as n_records

from "wb_analytics"."public"."stg_cost_price"
where barcode is not null
group by barcode
having count(*) > 1



      
    ) dbt_internal_test