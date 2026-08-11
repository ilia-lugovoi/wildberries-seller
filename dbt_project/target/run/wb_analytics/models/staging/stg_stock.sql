
  create view "wb_analytics"."public"."stg_stock__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."stock"
  );