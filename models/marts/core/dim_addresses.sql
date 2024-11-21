
with

addresses as  (

    select * from {{ ref('stg_sql_server_dbo__addresses')}}

),


renamed as (

    select 
        
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        datetime_load_utc
        
    FROM addresses
)

SELECT * FROM renamed