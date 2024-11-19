with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::date as date_load_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::time as time_load_utc

    from source

)

select * from renamed
