{{ config(
    materialized='incremental',
    unique_key = 'order_id'
    ) 
}}

with 

base_orders as (

    select * from {{ ref('base_sql_server_dbo__orders') }}


),

renamed as (

    select
        order_id,
        shipping_cost_euros,
        order_cost_euros,
        order_total_euros
        

    from base_orders

)

select * from renamed

/*{% if is_incremental() %}

	  WHERE datetime_load_utc > (SELECT MAX(datetime_load_utc) FROM {{ this }} )

{% endif %}*/

--Arreglar incremental: si ejecuto con incremental devuelve la tabla vacia
