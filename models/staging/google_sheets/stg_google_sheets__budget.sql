{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}

{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )

{% endif %}
),

renamed_casted AS (
    SELECT
          _row as budget_id
        , product_id
        , quantity as quantity_expected_sold
        , month as budget_month
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) as datetime_load_utc

    FROM src_budget
    )

SELECT * FROM renamed_casted
