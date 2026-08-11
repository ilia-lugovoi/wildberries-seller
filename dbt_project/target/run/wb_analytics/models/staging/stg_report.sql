
  create view "wb_analytics"."public"."stg_report__dbt_tmp"
    
    
  as (
    select *
from "wb_analytics"."raw"."report"
  );