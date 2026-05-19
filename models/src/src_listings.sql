{{ config(materialized = 'ephemeral') }}

SELECT
  id                AS listing_id,
  listing_url,
  name              AS listing_name,
  room_type,
  minimum_nights,
  host_id,
  -- clean price: remove currency symbol and cast to numeric
  TRY_TO_NUMBER(REPLACE(price, '$', '')) AS price,
  created_at,
  updated_at
FROM {{ source('airbnb', 'listings') }}
