{{ config(materialized="view" , schema = env_var('DBT_REPORT_SCHEMA','reporting')) }}

select 

c.companyname, 
c.contactname, 
sum(o.linesalesamount) as linesalesamount, 
sum(o.quantity) as total_orders, 
avg(o.margin) as avg_margin

from
{{ref('dim_customers')}} as c inner join {{ref('fact_orders')}} as o
on c.customerid = o.customerid where c.city = {{var('v_city',"'London'")}}
group by c.companyname, c.contactname
order by linesalesamount desc limit 10