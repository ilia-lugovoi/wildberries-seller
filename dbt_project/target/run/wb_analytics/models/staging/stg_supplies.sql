
  create view "wb_analytics"."public"."stg_supplies__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."supplies"
  );