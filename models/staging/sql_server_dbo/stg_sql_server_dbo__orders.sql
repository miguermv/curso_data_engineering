{{ config(
    materialized='incremental',
    unique_key = 'order_id'
    ) 
}}

with 

base_orders as (

    select * from {{ ref('base_sql_server_dbo__orders') }}


),

renamed as (

    select
        order_id,
        user_id,
        address_id,
        promo_id,
        shipping_service_id,
        order_status_id,
        created_at_utc,
        estimated_delivery_at_utc,
        delivered_at_utc,
        tracking_id,
        _fivetran_deleted,
        datetime_load_utc
        

    from base_orders

)

select * from renamed

/*{% if is_incremental() %}

	  WHERE datetime_load_utc > (SELECT MAX(datetime_load_utc) FROM {{ this }} )

{% endif %}*/

--Arreglar incremental: si ejecuto con incremental devuelve la tabla vacia
