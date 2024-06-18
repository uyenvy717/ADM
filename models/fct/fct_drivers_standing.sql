with constructors as (
    select * from {{ ref ("dim_constructors") }}
),

drivers as (
    select * from {{ ref ("dim_drivers") }}
),

-- find the points of another member
other_member_points as (
    select 
        dc.*,
        COALESCE(dc.team_points - dd.points, 0) as other_member_points
    from constructors dc
    left join drivers dd on dc.year = dd.year 
        and dc.round = dd.round and dc.driver_name = dd.driver_name
    order by dc.year, dc.round, dc.team_points desc
),

-- swap the points
personal_points as (
    select 
        op1.year,
        op1.round,
        op1.team_name,
        op1.driver_name,
        op1.team_points,
        op2.other_member_points as personal_points
    from other_member_points op1
    join other_member_points op2 
        on op1.year = op2.year 
        and op1.round = op2.round 
        and op1.team_name = op2.team_name
        and op1.driver_name != op2.driver_name
    order by op1.year, op1.round, op1.team_points desc
),

-- find the missing driver_name
matched_driver_name as (
    select 
        d.year,
        d.round,
        pp.driver_name,
        d.car_number,
        d.finishing_position,
        d.points
    from drivers d
    join personal_points pp 
        on d.year = pp.year
        and d.round = pp.round
        and d.points = pp.personal_points
    where d.driver_name = ''
),

-- correct the drivers data with found name
filled_driver_name as (
    select 
        d.year,
        d.round,
        case
            when d.driver_name = '' then m.driver_name
            else d.driver_name
        end as driver_name,
        d.car_number,
        d.finishing_position,
        d.points
    from drivers d
    left join matched_driver_name m 
        on d.year = m.year
        and d.round = m.round
        and d.points = m.points
),

 final as (
    select 
        year,
        driver_name,
        car_number,
        dense_rank() OVER (ORDER BY SUM(points) DESC) as finishing_position,
        sum(points) as total_points
    from filled_driver_name
    group by car_number, year, driver_name
    order by total_points desc  
)

select * from final