{{config(materialized='table', schema = env_var('DBT_TRF_SCHEMA','transforming'))}}

select 

ss.orderid,
ss.lineno,
ls.companyname,
ss.shipmentdate,
ss.status,
ss.dbt_valid_from,
ss.dbt_valid_to


from {{ref('shipments_snapshot')}} as ss left join {{ref('lkp_shippers')}} as ls 
on ss.shipperid = ls.shipperid