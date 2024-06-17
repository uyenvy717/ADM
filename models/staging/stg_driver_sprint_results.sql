select
    year::int as year,
    round::int as round,
    name as race_name,
    CAST(date as DATE) as race_date,
    "name:1" AS circuit_name,
    COALESCE(carNumber::int, 0) as car_number, -- Replace null with 0
    COALESCE(position::int, 0) as finishing_position, -- Replace null with 0
    COALESCE(points::int, 0) as points, -- Replace null with 0
    COALESCE(time, 'N/A') as time, -- Replace null with 'N/A'
    reason as result_status
from {{ source('formula1', 'driver_sprint_results') }}