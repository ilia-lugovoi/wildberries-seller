
  create view "wb_analytics"."public"."stg_tariffs_delivery__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."tariffs_delivery"
  );