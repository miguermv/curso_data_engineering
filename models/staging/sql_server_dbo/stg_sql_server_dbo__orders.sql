with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        NULLIF(shipping_service, '') as shipping_service,
        shipping_cost,
        address_id,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        CASE
            WHEN promo_id is NULL or promo_id = '' 
                THEN {{ dbt_utils.generate_surrogate_key(["'No promo'"]) }}
            ELSE {{ dbt_utils.generate_surrogate_key(['TRIM(promo_id)']) }}
            END as promo_id,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) as estimated_delivery_at_utc,
        order_cost as order_cost_euros,
        user_id,
        order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) as delivered_at_utc,
        NULLIF(tracking_id, '') as tracking_id,
        status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::date as date_load_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::time as time_load_utc

    from source

)

select * from renamed
