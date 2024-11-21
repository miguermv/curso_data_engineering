
with 

users as (

    select * from {{ ref('stg_sql_server_dbo__users') }} 


    ),

events as (

    select * from {{ ref('stg_sql_server_dbo__events') }}


    ),

renamed as (

    select
        session_id,
        u.user_id,
        first_name, 
        email,
        MIN(e.created_at_utc) as first_event_time_utc,
        MAX(e.created_at_utc) as last_event_time_utc,
        TIMEDIFF(MINUTE,  MIN(e.created_at_utc), MAX(e.created_at_utc)) as session_length_minutes,
        COUNT(CASE WHEN event_type='page_view' THEN 1 END) as page_view,
        COUNT(CASE WHEN event_type='add_to_cart' THEN 1 END) as add_to_cart,
        COUNT(CASE WHEN event_type='checkout' THEN 1 END) as checkout,
        COUNT(CASE WHEN event_type='package_shipped' THEN 1 END) as package_shipped
        


    from 
        users u
        join events e
        on u.user_id = e.user_id
    group by session_id, u.user_id, first_name, email

)

select * from renamed
