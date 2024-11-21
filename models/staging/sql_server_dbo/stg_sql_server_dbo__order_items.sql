{{ config(
    materialized='incremental',
    unique_key = 'order_items_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'order_items') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_items_id,
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc

    from source

)

select * from renamed
