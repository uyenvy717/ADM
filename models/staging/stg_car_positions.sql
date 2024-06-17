select
    Date as position_date,
    SUBSTRING(Time FROM 10) as lap_time,
    X::int as x_position,
    Y::int as y_position,
    Z::int as z_position,
    DriverNumber::int as driver_number
from {{ source('formula1', 'car_positions') }}