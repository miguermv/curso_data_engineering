{{ config(
    materialized='incremental',
    unique_key = 'shipping_service_id'
    ) 
}}

with 

source as (

    select
        DISTINCT 
            CASE 
                WHEN shipping_service IS NULL OR shipping_service = '' THEN 'no_shipped_yet'
                ELSE shipping_service
            END AS shipping_service,
        _fivetran_synced
    from {{ source('sql_server_dbo', 'orders') }}
    
{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} as shipping_service_id,
        shipping_service as shipping_service_company

    from source

)

select * from renamed
