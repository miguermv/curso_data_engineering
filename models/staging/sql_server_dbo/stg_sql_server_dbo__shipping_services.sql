with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key([]) }},
        shipping_service,
        shipping_cost

    from source

)

select * from renamed
