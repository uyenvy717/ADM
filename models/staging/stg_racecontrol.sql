select
    line_content as control_time,
    category as control_event
from {{ source('formula1', 'racecontrol') }}