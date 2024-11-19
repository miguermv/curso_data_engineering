with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['TRIM(promo_id)']) }} as promo_id,
        promo_id as desc_promo,
        discount as discount_euros,
        status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::date as date_load_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::time as time_load_utc

    from source

    UNION ALL 

    select 
        {{ dbt_utils.generate_surrogate_key(["'No promo'"]) }},
        'No promo',
        0,
        'active',
        NULL,
       '1970-01-01',
       '00:00:00'


)

select * from renamed
