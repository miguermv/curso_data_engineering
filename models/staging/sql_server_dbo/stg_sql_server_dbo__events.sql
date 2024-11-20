{{ config(
    materialized='incremental',
    unique_key = 'event_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

    ),

renamed as (

    select
        event_id,
        TRIM(page_url) as page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        order_id,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc


    from source

)

select * from renamed

{% if is_incremental() %}

	  WHERE datetime_load_utc > (SELECT MAX(datetime_load_utc) FROM {{ this }} )

{% endif %}