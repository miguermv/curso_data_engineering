
with

promos as  (

    select * from {{ ref('stg_sql_server_dbo__promos')}}

),


renamed as (

    select 
        promo_id,
        promo_desc,
        discount_euros,
        promo_status,
        _fivetran_deleted,
        datetime_load_utc
        
    FROM promos
)

SELECT * FROM renamed