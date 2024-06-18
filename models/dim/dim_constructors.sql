with constructor_results as (
    select * from {{ ref ("stg_constructor_results") }} where year = 2023
),

drivers_teams as (
    select * from {{ ref ("stg_drivers_teams") }}
),

 final as (
    select
        drivers_teams.year,
        drivers_teams.round,
        drivers_teams.team_name,
        drivers_teams.driver_name,
        constructor_results.points as team_points

    from constructor_results
    left join drivers_teams using (year, round, team_name)
)

select * from final
order by year, round, team_points desc