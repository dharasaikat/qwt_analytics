{{config(materialized='table', schema = env_var('DBT_TRF_SCHEMA','transforming'))}}

select 

e.empid,
e.last_name,
e.first_name,
e.title,
e.hire_date,
o.address as officeaddress,
o.city as officecity,
o.stateprovince as officestate,
o.phone as officephone,
iff(e.extension='-','NA',e.extension) as extension,
case when m.first_name is null then e.first_name else m.first_name end as manager_name,
iff(m.title is null ,e.title ,m.title) as manager_title,
e.year_salary

from {{ref('stg_employees')}} as e left join {{ref('stg_employees')}} as m 
on e.reports_to = m.empid
left join {{ref('stg_offices')}} as o
on e.office = o.officeid 