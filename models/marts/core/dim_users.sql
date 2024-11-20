
with

users as  (

    select * from {{ ref('stg_sql_server_dbo__users')}}

),


renamed as (

    select
        user_id,
        updated_at_utc,
        address_id,
        last_name,
        created_at_utc,
        phone_number, 
        first_name,
        email,
        _fivetran_deleted,
        datetime_load_utc

    from users



)

select * from renamed