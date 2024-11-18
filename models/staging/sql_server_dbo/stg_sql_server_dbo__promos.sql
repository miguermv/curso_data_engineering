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
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load_utc

    from source

    UNION ALL 

    select 
        {{ dbt_utils.generate_surrogate_key(["'No promo'"]) }},
        'No promo',
        0,
        'active',
        NULL,
       '1970-01-01T16:00:37.597000+00:00'


)

select * from renamed
