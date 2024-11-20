{{ config(
    materialized='incremental',
    unique_key = 'promo_id'
    ) 
}}

with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}


),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['TRIM(promo_id)']) }} as promo_id,
        promo_id as promo_desc,
        discount as discount_euros,
        status as promo_status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc


    from source

    UNION ALL 

    select 
        {{ dbt_utils.generate_surrogate_key(["'No promo'"]) }},
        'No promo',
        0,
        'active',
        NULL,
       '1970-01-01T00:00:00'


)

select * from renamed

{% if is_incremental() %}

	  WHERE datetime_load_utc > (SELECT MAX(datetime_load_utc) FROM {{ this }} )

{% endif %}
