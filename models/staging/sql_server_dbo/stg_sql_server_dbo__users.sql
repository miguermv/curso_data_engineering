{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'users') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}

),

renamed as (

    select
        user_id,
        CONVERT_TIMEZONE('UTC',  updated_at) as updated_at_utc,
        address_id,
        last_name,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        TRIM(REPLACE(phone_number, '-', '')) as phone_number, 
        first_name,
        email,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc


    from source

)

select * from renamed
