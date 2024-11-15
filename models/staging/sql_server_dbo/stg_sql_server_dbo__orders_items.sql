with 

source as (

    select * from {{ source('sql_server_dbo', 'orders_items') }}

),

renamed as (

    select

    from source

)

select * from renamed
