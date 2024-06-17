select
    id as team_id,
    name as team_name,
    nationality,
    url
from {{ source('formula1', 'teams') }}