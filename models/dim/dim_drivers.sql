with driver_results as (
    select * from {{ ref ("stg_driver_results") }} where year = 2023
),

drivers as (
    select * from {{ ref ("stg_drivers") }}
),

 final as (
    select
        driver_results.year,
        driver_results.round,
        case 
            when driver_results.car_number = 0 then '' 
            when drivers.car_number is null then '' 
            else drivers.driver_name 
        end as driver_name,
        driver_results.car_number,
        driver_results.finishing_position,
        driver_results.points

    from driver_results
    left join drivers
    on driver_results.car_number = drivers.car_number
)

select * from final
order by year, round, points desc,
    case 
        when finishing_position = 0 then 1 
        else 0 
    end, 
    finishing_position