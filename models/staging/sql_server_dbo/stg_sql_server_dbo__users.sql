with 

source as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        updated_at,
        address_id,
        last_name,
        CONVERT_TIMEZONE('UTC', created_at) as created_at_utc,
        TRIM(REPLACE(phone_number, '-', '')) as phone number, --quitar guiones entre numeros
        first_name,
        email,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load_utc

    from source

)

select * from renamed
