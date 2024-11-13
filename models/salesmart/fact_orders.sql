{{config(materialized='view', schema = env_var('DBT_SALESMART_SCHEMA','salesmart'))}}

select * from 

{{ref('trf_orders')}}