{{ config(materialized='table', schema = env_var('DBT_STAGE_SCHEMA','staging'))}}

select 

empid,
last_name,
first_name,
title,
to_date(hire_date, 'MM/DD/YY') as hire_date,
office,
extension,
reports_to,
year_salary

from 

{{source('qwt_raw','employees')}}