{{ config(materialized = 'table') }}

WITH listings AS (
  SELECT * FROM {{ ref('src_listings') }}
)

SELECT
  listing_id,
  listing_name,
  room_type,
  CASE
    WHEN minimum_nights = 0 THEN 1
    ELSE minimum_nights
  END AS minimum_nights,
  price,
  host_id,
  created_at,
  updated_at
FROM listings
WHERE listing_id IS NOT NULL
