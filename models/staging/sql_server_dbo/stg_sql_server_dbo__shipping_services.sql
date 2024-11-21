--Por hacer: corregir base orders para que no llegue registro 'no_shipped_yet' ya que no es una empresa de reparto

{{ config(
    materialized='incremental',
    unique_key = 'shipping_service_id'
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
        DISTINCT shipping_service_id,
        shipping_company,

    from base_orders 


)

select * from renamed

