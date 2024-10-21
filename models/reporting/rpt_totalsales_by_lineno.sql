{{config(materialized='view', schema='reporting')}}

select orderid,

sum(case when lineno = 1 then Linesalesamount) as 