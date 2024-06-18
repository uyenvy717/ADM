select
    id as driver_id,
    COALESCE(number::int, 0) as car_number, -- Replace null with 0
    code as driver_code,
    CONCAT(forename, ' ', surname) as driver_name,
    forename,
    surname,
    cast(dob as DATE) as date_of_birth,
    nationality,
    url
from {{ source('formula1', 'drivers') }}