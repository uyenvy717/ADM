select
    id as driver_id,
    number as car_number,
    code as driver_code,
    CONCAT(forename, ' ', surname) as driver_name,
    forename,
    surname,
    cast(dob as DATE) as date_of_birth,
    nationality,
    url
from {{ source('formula1', 'drivers') }}