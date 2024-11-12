select

orderid,
sum(LINESALESAMOUNT) as sales

from 
{{ref('fact_orders')}}

group by orderid
having sales<0