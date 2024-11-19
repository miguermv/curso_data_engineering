{{ config(
    materialized='incremental',
    unique_key = 'product_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}
    
{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc


    from source

)

select * from renamed
