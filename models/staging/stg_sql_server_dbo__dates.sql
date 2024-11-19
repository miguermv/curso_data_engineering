{{
    config(
        materialized = "table"
    )
}}

with

source as (

    {{ dbt_date.get_base_dates(
        datepart="day",
        start_date="2019-01-01", 
        end_date="2030-12-31"
        ) 
    }}

),

renamed as (

    select
        date_day::date as date_id,
        YEAR(date_day) as year_number,
        MONTH(date_day) as month_number,
        DAY(date_day) as day_number
    from source

)

select * from renamed
