{{ config(materialized='incremental',unique_key=['orderid','lineno'], schema = env_var('DBT_STAGE_SCHEMA','staging'))}}

select od.*, o.orderdate as orderdate from
{{source('qwt_raw','orders')}} as o inner join
{{source('qwt_raw','order_details')}} as od
on o.orderid=od.orderid

{% if is_incremental() %}

  where orderdate > (select max(orderdate) from {{ this }})

{% endif %}
