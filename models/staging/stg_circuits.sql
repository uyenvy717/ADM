select
    name as circuit_name,
    location,
    country,
    latitude,
    longitude,
    COALESCE(altitude, 0) as altitude, -- Replace null with 0
    url
from {{ source('formula1', 'circuits') }}