{{
    config(
        materialized='table',
        description='Dimension table listing various order statuses and their descriptions.'
    )
}}

with 

source as (

    {{ generate_status_table() }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['status']) }} as status_id,
        status,
        status_desc

    from source

)

select * from renamed
