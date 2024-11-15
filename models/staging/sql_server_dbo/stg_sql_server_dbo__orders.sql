with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        shipping_service,
        shipping_cost,
        address_id,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        /*case
            WHEN promo_id = '' THEN 'N/A'
            ELSE promo_id
            END AS promo_id*/
            md5(promo_id) as promo_id,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) as estimated_delivery_at_utc,
        order_cost,
        user_id,
        order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) as delivered_at_utc,
        tracking_id,
        status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load_utc,

    from source

)

select * from renamed
