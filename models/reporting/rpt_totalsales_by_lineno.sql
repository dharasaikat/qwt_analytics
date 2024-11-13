{{ config(materialized="view" , schema = env_var('DBT_REPORT_SCHEMA','reporting')) }}
 
{% set linenos=get_linenum() %}
select
orderid,
sum(Linesalesamount) as total_sales,
avg(margin) as avg_margin,
{% for linenum in linenos %}
sum(case when lineno={{linenum}} then Linesalesamount end ) as line{{linenum}}_sales,
{% endfor %}
from
{{ref("fact_orders")}}
group by orderid

