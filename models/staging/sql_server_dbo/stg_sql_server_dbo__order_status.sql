{{ config(
    materialized='incremental',
    unique_key = 'order_status_id'
    ) 
}}

with 

base_orders as (
    
    select * from {{ ref('base_sql_server_dbo__orders') }}
   
    {% if is_incremental() %}

        WHERE datetime_load_utc > (SELECT MAX(datetime_load_utc) FROM {{ this }} )

    {% endif %}
),

renamed as (

    select
        DISTINCT order_status_id,
        order_status_desc,

    from base_orders
)

select * from renamed