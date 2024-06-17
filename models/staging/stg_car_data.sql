select
    Date as telemetry_date,
    RPM::int as rpm,
    Speed::int as speed,
    nGear::int as gear,
    Throttle::int as throttle,
    CASE WHEN Brake = 'true' THEN true ELSE false END as brake, 
    SUBSTRING(Time FROM 12) as lap_time,
    DriverNumber::int as driver_number
from {{ source('formula1', 'car_data') }}