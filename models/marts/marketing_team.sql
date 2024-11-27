
with 

users as (

    select * from {{ ref('stg_sql_server_dbo__users') }} 


    ),

address as (

    select * from {{ ref('stg_sql_server_dbo__addresses') }}


    ),

orders as (

    select * from {{ ref('stg_sql_server_dbo__orders') }}


    ),

orders_costs as (

    select * from {{ ref('stg_sql_server_dbo__orders_costs') }}


    ),

promo as (

    select * from {{ ref('stg_sql_server_dbo__promos') }}


    ),

order_items as (

    select 
        order_id,
        sum(quantity) as sum_quantity
    from {{ ref('stg_sql_server_dbo__order_items') }}
    group by order_id

    ),

renamed as (

    select
        u.user_id,
        first_name,
        last_name,
        email,
        phone_number,
        updated_at_utc,
        address,
        zipcode,
        state,
        country,
        COUNT(o.order_id) as total_number_orders,
        SUM(order_cost_euros)::DECIMAL(10, 2) as total_order_cost_euros,
        SUM(shipping_cost_euros)::DECIMAL(10, 2) as total_shipping_cost_usd,
        SUM(discount_euros) as total_discount_euros,
        SUM(sum_quantity) as total_quantity_product


    from users u
    join orders o on u.user_id = o.user_id
    join orders_costs oc on o.order_id = oc.order_id
    join address a on u.address_id = a.address_id
    join promo p on o.promo_id = p.promo_id
    inner join order_items i on i.order_id = o.order_id
    group by 
        u.user_id,
        first_name,
        last_name,
        email,
        phone_number,
        updated_at_utc,
        address,
        zipcode,
        state,
        country
        

)

select * from renamed
