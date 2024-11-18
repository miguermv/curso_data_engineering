with 

source as (

 {{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2019-01-01' as date)",
    end_date="cast('2030-12-31' as date)"
   )}} as hola

),

renamed as (

    select
        hola
     
        
    from source

)

select * from renamed
