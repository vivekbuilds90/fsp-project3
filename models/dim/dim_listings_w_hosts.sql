{{ config(materialized = 'table') }}

WITH l AS (
    SELECT
        listing_id,
        listing_name,
        room_type,
        minimum_nights,
        price,
        host_id,
        created_at,
        updated_at
    FROM {{ ref('dim_listings_cleaned') }}
),
h AS (
    SELECT
        host_id,
        host_name,
        is_superhost,
        created_at  AS host_created_at,
        updated_at  AS host_updated_at
    FROM {{ ref('dim_hosts_cleansed') }}
)

SELECT
    l.listing_id,
    l.listing_name,
    l.room_type,
    l.minimum_nights,
    l.price,
    l.host_id,
    h.host_name,
    h.is_superhost AS host_is_superhost_flag,   -- 't' / 'f'
    CASE
        WHEN h.is_superhost = 't' THEN 'Superhost'
        ELSE 'Regular host'
    END AS host_is_superhost_label,
    l.created_at,
    GREATEST(l.updated_at, h.host_updated_at) AS updated_at
FROM l
LEFT JOIN h ON h.host_id = l.host_id
