{{ config(materialized = 'ephemeral') }}

SELECT
    id          AS host_id,
    name        AS host_name,
    -- Keep as string for now, but normalize case and whitespace
    TRIM(LOWER(is_superhost)) AS is_superhost,
    created_at,
    updated_at
FROM {{ source('airbnb', 'hosts') }}
