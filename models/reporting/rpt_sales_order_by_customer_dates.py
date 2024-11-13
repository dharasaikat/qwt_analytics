import snowflake.snowpark.functions as F
import holidays

def is_holiday(date_col):
    france_holidays = holidays.France()
    is_holidays=(date_col in france_holidays)
    return is_holidays

def avg(x,y):
    return x/y


def model(dbt, sesssion):

    dbt.config(materialized='table' , packages=['holidays'])

    dim_customers_df=dbt.ref('dim_customers')
    fct_orders_df=dbt.ref('fact_orders')

    customers_orders_df = (fct_orders_df.group_by('customerid').agg(
                                                                F.min(F.col('orderdate')).alias('first_order_date'),
                                                                F.max(F.col('orderdate')).alias('recent_order_date'),
                                                                F.sum(F.col('quantity')).alias('total_orders'),
                                                                F.sum(F.col('linesalesamount')).alias('total_sales')
                                                                )
                            )       

    df =  (
            dim_customers_df
            .join(customers_orders_df, dim_customers_df.customerid == customers_orders_df.customerid, 'left')
            .select(
                dim_customers_df.companyname.alias('companyname'),
                dim_customers_df.contactname.alias('contactname'),
                dim_customers_df.city.alias('city'),
                customers_orders_df.first_order_date.alias('first_order_date'),
                customers_orders_df.recent_order_date.alias('recent_order_date'),
                customers_orders_df.total_orders.alias('total_orders'),
                customers_orders_df.total_sales.alias('total_sales')
            )
 
    )    

    final_df = df.withColumn('average_orders_value', avg(df['total_sales'],df['total_orders']))

    final_df = final_df.filter(F.col('first_order_date').isNotNull())

    final_df = final_df.to_pandas()

    final_df['IS_FIRST_ORDER_ON_HOLIDAY'] = final_df['FIRST_ORDER_DATE'].apply(is_holiday)

    return final_df   
