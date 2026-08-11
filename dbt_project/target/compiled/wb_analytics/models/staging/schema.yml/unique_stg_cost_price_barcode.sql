
    
    

select
    barcode as unique_field,
    count(*) as n_records

from "wb_analytics"."public"."stg_cost_price"
where barcode is not null
group by barcode
having count(*) > 1


