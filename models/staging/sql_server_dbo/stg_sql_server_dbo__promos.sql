with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,
        promo_id as desc_promo,
        discount as discount_euros,
        status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load_utc

    from source

    UNION ALL 

    select 
        md5(''),
        'No promo',
        0,
        'inactive',
        NULL,
        NULL


)

select * from renamed
