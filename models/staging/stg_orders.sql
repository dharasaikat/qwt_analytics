{{ config(materialized='incremental',unique_key='orderid', schema = env_var('DBT_STAGE_SCHEMA','staging'))}}

select * from
{{source('qwt_raw','orders')}}

{% if is_incremental() %}

  where orderdate > (select max(orderdate) from {{ this }})

{% endif %}
