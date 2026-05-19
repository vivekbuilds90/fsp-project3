# Modern Airbnb Data Engineering Pipeline

## Overview

This project demonstrates a complete cloud-based modern data engineering workflow using Airbnb open datasets.

The pipeline covers:
- Data ingestion from AWS S3
- Data warehousing using Snowflake
- Transformation and modeling with dbt
- Workflow orchestration using Dagster
- Business intelligence dashboards using Power BI

The goal of this project is to build a scalable analytics pipeline capable of handling raw structured datasets and converting them into analytics-ready business insights.

---

# Architecture

## Pipeline Flow

1. Raw CSV datasets are uploaded to AWS S3
2. Data is loaded into Snowflake raw tables
3. dbt transforms and models the warehouse data
4. Dagster orchestrates scheduled transformation workflows
5. Power BI connects to Snowflake for analytics dashboards

---

# Technologies Used

| Layer | Technology |
|------|-------------|
| Cloud Storage | AWS S3 |
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Orchestration | Dagster |
| Visualization | Power BI |
| Language | SQL, Jinja |
| Version Control | Git & GitHub |

---

# Dataset Information

The dataset includes:
- Airbnb listing information
- Host information
- Customer reviews
- Pricing metrics
- Availability details

---

# Data Pipeline

## Ingestion Layer

Data files:
- listings.csv
- hosts.csv
- reviews.csv

These files are uploaded into AWS S3 and ingested into Snowflake raw tables using:
- COPY INTO
- External stages
- Snowpipe compatible workflows

---

# Data Modeling

## Staging Models

- src_listings
- src_hosts
- src_reviews

These models standardize:
- column names
- data types
- null handling
- filtering logic

---

## Dimension Models

### dim_listings_cleaned
Contains cleaned listing-level information.

### dim_hosts_cleansed
Contains standardized host attributes.

### dim_listings_w_hosts
Combined host and listing analytical dimension table.

---

## Fact Model

### fct_reviews

Incremental fact table for customer reviews.

Features:
- incremental loading
- surrogate keys
- review-based analytics
- optimized Snowflake transformations

---

# Data Quality Checks

Implemented dbt tests include:
- unique
- not_null
- relationships
- accepted_values
- source freshness tests

These validations ensure:
- clean warehouse models
- referential integrity
- reliable BI reporting

---

# Orchestration

Dagster is used for:
- scheduling dbt jobs
- monitoring execution
- handling retries
- orchestrating transformation workflows

---

# Dashboards

Power BI dashboards provide:
- review trend analysis
- host performance insights
- room type distribution
- pricing analytics
- customer sentiment tracking

---

# Key Features

- End-to-end ELT pipeline
- Incremental transformations
- Cloud-native architecture
- Automated orchestration
- Enterprise-style data modeling
- Analytics-ready reporting

---

# Repository Structure

```text
├── analyses/
├── architecture/
├── assets/
├── Dagster/
├── Dashboards/
├── macros/
├── models/
├── seeds/
├── snapshots/
├── tests/
├── dbt_project.yml
├── packages.yml
├── README.md
