
with

dates as  (

    select * from {{ ref('stg_others__dates')}}

),


renamed as (

    select 
        
        date_id,
        day_of_week_name,
        day_of_week_name_short,
        day_of_month,
        day_of_year,
        week_start_date,
        week_end_date,
        month_of_year,
        month_name,
        month_name_short,
        month_start_date,
        month_end_date,
        quarter_of_year,
        quarter_start_date,
        quarter_end_date,
        year_number
        
    FROM dates
)

SELECT * FROM renamed