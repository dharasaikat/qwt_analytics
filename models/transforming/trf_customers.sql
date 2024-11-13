{{config(materialized='table', schema = env_var('DBT_TRF_SCHEMA','transforming'), transient=false, post_hook= 'create or replace table transforming.trf_customers_copy clone {{this}};', pre_hook='use warehouse dbt_queries;')}}

select 

customerid,
companyname,
contactname,
city,
country,
d.divisionname as divisionname,
address,
iff(fax='','NA',fax) as fax,
phone,
postalcode, 
case when stateprovince='' then 'NA' else stateprovince end as stateprovince 
from {{ref('stg_customers')}} as c inner join {{ref('lkp_divisions')}} as d 
on c.divisionid = d.divisionid