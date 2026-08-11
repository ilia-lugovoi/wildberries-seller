
  create view "wb_analytics"."public"."stg_sales__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."sales"
  );