{{ config(materialized='table', schema = env_var('DBT_STAGE_SCHEMA','staging'))}}

select * from {{source('qwt_raw','customers')}}