select
    SUBSTRING(Time FROM 7) as lap_time,
    DriverNumber::int as driver_number,
    SUBSTRING(LapTime FROM 7) as lap_time_total,
    LapNumber as lap_number,
    CASE
        WHEN COALESCE(PitOutTime, '') = '' THEN '00:00:00'
        ELSE SUBSTRING(PitOutTime FROM 7)
    END as pit_out_time,
    CASE
        WHEN COALESCE(PitInTime, '') = '' THEN '00:00:00'
        ELSE SUBSTRING(PitInTime FROM 7)
    END as pit_in_time,
    CASE
        WHEN SUBSTRING(Sector1Time FROM 7) = 'nan' THEN '00:00:00'
        ELSE NULLIF(SUBSTRING(Sector2Time FROM 7), '00:00:00')
    END as sector_1_time,
    CASE
        WHEN SUBSTRING(Sector2Time FROM 7) = 'nan' THEN '00:00:00'
        ELSE NULLIF(SUBSTRING(Sector2Time FROM 7), '00:00:00')
    END as sector_2_time,
    CASE
        WHEN SUBSTRING(Sector3Time FROM 7) = 'nan' THEN '00:00:00'
        ELSE NULLIF(SUBSTRING(Sector2Time FROM 7), '00:00:00')
    END as sector_3_time,
    COALESCE(SpeedI1::DOUBLE, 0.0) as speed_sector_1,
    COALESCE(SpeedI2::DOUBLE, 0.0) as speed_sector_2,
    COALESCE(SpeedFL::DOUBLE, 0.0) as speed_fl,
    COALESCE(SpeedST::DOUBLE, 0.0) as speed_st,
    Compound as tire_compound,
    TyreLife as tire_life
from {{ source('formula1', 'laps') }}