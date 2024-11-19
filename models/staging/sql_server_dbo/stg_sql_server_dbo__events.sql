with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id,
        TRIM(page_url) as page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        order_id,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::date as date_load_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::time as time_load_utc

    from source

)

select * from renamed
