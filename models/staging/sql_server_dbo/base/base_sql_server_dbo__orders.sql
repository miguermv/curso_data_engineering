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
        user_id,
        address_id,
        {{ control_null_or_empty('promo_id', "'no promo'") }} AS promo_id,
        {{ control_null_or_empty('shipping_service', "'no_shipped_yet'") }} AS shipping_service_id,
        COALESCE(NULLIF(shipping_service, ''), 'no_shipped_yet') AS shipping_company,
        shipping_cost::DECIMAL(10,2) as shipping_cost_euros,
        order_cost::DECIMAL(10,2) as order_cost_euros,
        order_total::DECIMAL(10,2) as order_total_euros,
        {{ dbt_utils.generate_surrogate_key(['status']) }} as order_status_id,
        status as order_status_desc,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) as estimated_delivery_at_utc,
        CONVERT_TIMEZONE('UTC', delivered_at) as delivered_at_utc,
        NULLIF(tracking_id, '') as tracking_id,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc
        

    from source

)

select * from renamed
