with 

source as (

    select * from {{ source('sql_server_dbo', 'users') }}

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
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::date as date_load_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)::time as time_load_utc

    from source

)

select * from renamed
