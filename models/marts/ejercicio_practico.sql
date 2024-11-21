
with 

orders as (

    select * from {{ ref('stg_sql_server_dbo__orders') }} 


    ),

users as (

    select * from {{ ref('stg_sql_server_dbo__users') }}


    ),

user_order_count as (

    select
        DISTINCT user_id,
        COUNT(order_id) as total_orders
    from
        orders
    group by
        user_id
),


renamed as (

    select
        COUNT(DISTINCT u.user_id) as total_usuarios,
        AVG(DATEDIFF(DAY, o.created_at_utc, delivered_at_utc)) as promedio_tiempo_entrega_dias,
        SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) as una_compra,
        SUM(CASE WHEN total_orders = 2 THEN 1 ELSE 0 END) as dos_compra,
        SUM(CASE WHEN total_orders >= 3 THEN 1 ELSE 0 END) as tres_o_mas_compras

    from 
        users u
        inner join orders o 
            on u.user_id = o.user_id
        inner join user_order_count u_count
            on u.user_id = u_count.user_id


)

select 
    *
from renamed
