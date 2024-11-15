with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        case 
            when promo_id is null then '9999'
            else md5(promo_id)
            end as promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
