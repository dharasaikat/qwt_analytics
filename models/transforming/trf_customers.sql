{{config(materialized='table', schema='transforming')}}

select customerid,
companyname,
contactname,
city,
country,
divisionid,
address,
iff(fax='','NA',fax) as fax,
phone,
postalcode,
case when stateprovince='' then 'NA' else stateprovince end as stateprovince 
from {{ref('stg_customers')}}