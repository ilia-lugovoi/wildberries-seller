
  create view "wb_analytics"."public"."stg_orders__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."orders"
  );