{{ config(
    materialized='incremental',
    unique_key = 'order_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}

),

renamed as (

    select
        order_id,
        CASE 
            WHEN shipping_service IS NULL OR shipping_service = '' 
                THEN {{ dbt_utils.generate_surrogate_key(["'no_shipped_yet'"]) }}
            ELSE {{ dbt_utils.generate_surrogate_key(['shipping_service']) }}
        END AS shipping_service_id,
        shipping_cost as shipping_cost_euros,
        address_id,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        CASE
            WHEN promo_id is NULL or promo_id = '' 
                THEN {{ dbt_utils.generate_surrogate_key(["'No promo'"]) }}
            ELSE {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
            END as promo_id,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) as estimated_delivery_at_utc,
        order_cost as order_cost_euros,
        user_id,
        order_total as order_total_euros,
        CONVERT_TIMEZONE('UTC', delivered_at) as delivered_at_utc,
        NULLIF(tracking_id, '') as tracking_id,
        status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc
        

    from source

)

select * from renamed
