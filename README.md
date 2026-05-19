# 🏠 Airbnb Data Engineering Project (S3 → Snowflake → dbt → Dagster → Power BI)

## 📘 Project Overview  
This project demonstrates an **end-to-end modern data engineering pipeline** built using the **Airbnb dataset**.  
The objective is to design, automate, transform, test, and visualize data using a **cloud-native analytics stack** centered around **AWS S3, Snowflake, dbt, and Dagster**.

The pipeline covers the full lifecycle:
- Raw data ingestion from S3  
- Cloud data warehousing in Snowflake  
- Transformations and data quality using dbt  
- Orchestration using Dagster  
- Analytics and reporting using Power BI  

---

## 🧩 Architecture  
![Architecture](architecture/Airbnb_Archietecture.png)

![Architecture](architecture/Pipeline_Architecture.png)

### High-Level Flow  
1. Airbnb CSV files land in **AWS S3**  
2. Data is loaded into **Snowflake Raw Layer** using **Snowflake Stage + Snowpipe or COPY INTO**  
3. **dbt runs inside Snowflake** to transform raw data into analytics-ready models  
4. **Dagster orchestrates dbt runs**  
5. **Power BI connects to Snowflake Analytics Layer** for reporting  

---

## ⚙️ Data Ingestion Pipeline (AWS S3 → Snowflake)

**Source**
- AWS S3 bucket:
  - `listings.csv`
  - `hosts.csv`
  - `reviews.csv`

**Target**
- Snowflake database: `AIRBNB`
- Schema: `RAW`
  - `RAW_LISTINGS`
  - `RAW_HOSTS`
  - `RAW_REVIEWS`

**Ingestion Method**
- Snowflake `COPY INTO` commands reading directly from S3
- In a production setup, this can be extended to:
  - External stages
  - Snowpipe for continuous ingestion

The RAW layer stores data exactly as received with no transformations applied.

---
## 🧱 Data Transformation & Modeling (dbt + Snowflake)

All transformations are implemented using **dbt**, executed directly inside Snowflake.

---

### 🔹 Staging Models (src_)

These models standardize column names and data types from RAW tables.

- `src_listings`
- `src_hosts`
- `src_reviews`

Responsibilities:
- Column renaming
- Type casting
- Basic filtering
- Preparing clean inputs for downstream models

---

### 🔹 Core Dimension & Fact Models

#### Dimensions
- `dim_listings_cleaned`  
  Cleaned Airbnb listings with data quality rules applied

- `dim_hosts_cleansed`  
  Cleaned host attributes with enforced contracts and standardized flags

- `dim_listings_w_hosts`  
  Joined dimension combining listings and host attributes  
  Used as the primary dimension table for BI

#### Fact
- `fct_reviews`  
  Incremental fact table for reviews
  - Uses surrogate keys generated from:
    - `listing_id`
    - `review_date`
    - `reviewer_name`
    - `review_text`
  - Filters out null review text
  - Incrementally loads only new records using `review_date`
  - Supports optional `start_date` and `end_date` dbt variables
  - `on_schema_change = 'fail'` to prevent silent schema drift

---

### 🔹 Mart Layer

- `mart_fullmoon_reviews`  
  Joins `fct_reviews` with a seeded full moon calendar table
  - Adds `is_full_moon` flag
  - Enables behavioral analysis of reviews during full moon vs regular days
  - Used directly by Power BI

---

## 🔁 Incremental Processing Strategy

The `fct_reviews` model uses dbt incremental materialization:

- Loads only records where:
  - `review_date > max(review_date)` in the target table  
  - Or within a configurable `start_date` and `end_date` window
- Prevents full table reloads
- Improves performance and reduces compute cost
- Validated using controlled Snowflake insert testing


---

## ✅ Data Quality & Testing (dbt)

The following dbt tests are implemented:

- `unique`  
  Enforced on primary keys (`review_id`, `listing_id`, `host_id`)

- `not_null`  
  Applied to all critical identifier fields

- `relationships`  
  Ensures referential integrity between:
  - `fct_reviews.listing_id` → `dim_listings_cleaned.listing_id`

- `accepted_values`  
  Validates controlled fields like `room_type`

- `positive_values`  
  Ensures numeric fields such as `minimum_nights` are greater than zero

- **Source Freshness Tests**
  - Applied to `src_reviews`
  - Warn and error thresholds defined to monitor data latency

These tests ensure:
- Clean joins
- No orphan records
- No invalid dimensions
- Analytics-ready data for BI consumption
---

## ⏱️ Orchestration with Dagster  

![Dagster Orchestration](Dagster/dagster.png)

Dagster is used for:

- Scheduling dbt runs  
- Manually triggering dbt pipelines  
- Monitoring asset execution  
- Tracking failures and retries  

Dagster controls **when dbt runs**, while dbt controls **how transformations are performed**.

---

## 📊 Analytics and Visualization (Power BI)  

Power BI connects directly to the **Snowflake Analytics Layer**.

## 📊 Dashboard Previews

### 🟩 Airbnb Listings and Review Performance Overview
![Listings Overview Dashboard](Dashboards/listings_review_overview.png)

A high-level analytical overview of Airbnb listings, review volume, sentiment distribution, and long-term review trends.

**Key Highlights:**
- Interactive filters for Room Type, Host Type, Full Moon, and Review Period  
- KPIs: Total Listings, Total Reviews, Average Price, Positive Review Percentage  
- Listings by Room Type  
- Review Volume: Full Moon vs Regular Days  
- Listings by Host Type (Superhost vs Regular Host)  
- Review Sentiment Breakdown (Positive, Neutral, Negative)  
- Review Trend Over Time  

--- 

### 🟦 Host and Pricing Performance Analysis
![Host Pricing Dashboard](Dashboards/host_pricing_analysis.png)

This dashboard provides insights into how hosts price their listings and how reviews vary across different hosts and room types.

**Key Highlights:**
- Total Listings by Host Name  
- Average Price by Host Type (Superhost vs Regular Host)  
- Average Price by Room Type  
- Top Hosts by Total Reviews  
- Listing-level details including:  
  - Room type  
  - Price  
  - Total reviews  
  - Positive review percentage  

---


---

## 🧱 Tech Stack  

| Layer | Tools and Services |
|------|---------------------|
| Data Source | AWS S3 |
| Ingestion | Snowflake Stage, Snowpipe, COPY INTO |
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Orchestration | Dagster |
| Visualization | Power BI |
| Language | SQL, Jinja |
| Version Control | Git, GitHub |

---

## 🗂️ Dataset Overview  

**Source:** Public Airbnb Open Dataset  

The dataset includes:
- Listings information  
- Host details  
- Customer reviews  
- Availability metrics  

---

## 🧮 Data Model Overview  

| Table | Description |
|--------|-------------|
| `dim_listings_cleaned` | Cleaned Airbnb listing information |
| `dim_hosts_cleansed` | Host level attributes |
| `fct_reviews` | Incremental fact table for reviews |

---

## ⚙️ Key Features  

- End-to-end **ELT pipeline using Snowflake and dbt**  
- **Incremental fact modeling**  
- **Automated orchestration using Dagster**  
- **Enterprise-grade data quality checks**  
- **Cloud-native ingestion from S3**  
- **Analytics-ready Power BI reporting**  

---

## 📁 Repository Structure

```text
├── analyses/
├── assets/
├── macros/
├── models/
│   ├── src/
│   ├── dimensions/
│   └── facts/
├── seeds/
├── snapshots/
├── tests/
├── architecture/
│   └── airbnb_architecture.png
├── dashboards/
│   ├── host_pricing_analysis.png
│   └── listings_review_overview.png
├── dagster/
│   └── dagster_pipeline.png
├── dbt_project.yml
├── packages.yml
└── README.md

