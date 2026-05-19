
{{ config(
    materialized = 'table',
    contract = { "enforced": true }
) }}

WITH hosts AS (
    SELECT * FROM {{ ref('src_hosts') }}
)

SELECT
    host_id,
    host_name,
    is_superhost,
    created_at,
    updated_at
FROM hosts
WHERE host_id IS NOT NULL
