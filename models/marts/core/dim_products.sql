
with

products as  (

    select * from {{ ref('stg_sql_server_dbo__products')}}

),


renamed as (

    select 
        
        product_id,
        product_price,
        product_name,
        product_inventory,
        _fivetran_deleted,
        datetime_load_utc
        
    FROM products
)

SELECT * FROM renamed