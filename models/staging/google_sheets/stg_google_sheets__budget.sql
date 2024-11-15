{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , extract(month from month) as month
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load_utc
    FROM src_budget
    )

SELECT * FROM renamed_casted
