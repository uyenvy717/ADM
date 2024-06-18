select
    year::int as year,
    race_nr::int as round,
    driver as driver_name,
    name as team_name
from {{ source('formula1', 'drivers_teams') }}