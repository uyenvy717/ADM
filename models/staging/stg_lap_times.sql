select
    CAST(date as DATE) as lap_date,
    carNumber::int as car_number,
    lap::int as lap_number,
    position::int as finishing_position,
    time as lap_time,
    milliseconds as lap_time_milliseconds
from {{ source('formula1', 'lap_times') }}