
  create view "wb_analytics"."public"."stg_cost_price__dbt_tmp"
    
    
  as (
    select
    штрих_код::text as barcode,
    себестоимость::numeric as cost_price

from "wb_analytics"."raw"."cost_price"
  );