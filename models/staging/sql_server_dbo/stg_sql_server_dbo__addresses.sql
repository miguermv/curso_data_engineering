{{ config(
    materialized='incremental',
    unique_key = 'address_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'addresses') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}
    ),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc


    from source

)

select * from renamed
