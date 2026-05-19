{{ config(materialized = 'ephemeral') }}

SELECT
  listing_id,
  date            AS review_date,
  reviewer_name,
  comments        AS review_text,
  sentiment       AS REVIEW_SENTIMENT 
FROM {{ source('airbnb', 'reviews') }}
