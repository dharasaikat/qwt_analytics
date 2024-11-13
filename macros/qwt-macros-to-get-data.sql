{% macro get_linenum() -%}
 
{% set line_num_query %}
select distinct
lineno
from {{ ref('fact_orders') }}
order by 1
{% endset %}
 
{% set results = run_query(line_num_query) %}
 
{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}
 
{{ return(results_list) }}
 
{%- endmacro %}