# CivicPulse 311 — NYC 311 Operational Data Platform

CivicPulse 311 is an end-to-end cloud data platform designed to ingest, process, and analyze real-time NYC 311 non-emergency service request data. By modernizing static reporting into an automated analytics architecture, this platform empowers municipal agencies with actionable insights to track SLA compliance, manage request backlogs, and optimize resource allocation across New York City boroughs.

## 🏗️ Architecture Overview

The platform uses a Lakehouse Medallion Architecture orchestrating data flow from raw API payloads to operational database storage:

1. **Ingestion (Bronze Layer):** Orchestrated via **Apache Airflow**, pulling incremental NYC 311 service request updates via Python/Polars and storing raw payloads directly into **Azure Blob Storage** (`bronze` container).
2. **Transformation (Silver Layer):** Cleanses, deduplicates, and formats raw data using **Polars**, saving optimized Parquet files into **Azure Blob Storage** (`silver` container).
3. **Database Load (Gold Layer):** Executes SQL staging and analytical schema transformations to load structured datasets into **Azure Database for PostgreSQL Flexible Server** (`civic_pulse_db`).
4. **Infrastructure as Code (IaC):** Entire cloud infrastructure (Resource Group, Storage Account, Containers, PostgreSQL Flexible Server) provisioned using **Terraform**.

## 🗂️ Repository Structure

```text
CivicPulse_311-NYC_311_Operational_Data_Platform/
├── dags/
│   ├── civic_pulse.py            # Main Airflow DAG orchestrating the pipeline
│   └── sql/
│       └── civic_pulse.sql       # SQL scripts for database staging & transformation
├── img                            # Architectural diagram
├── include/
│   ├── upload_raw_data.py        # Module for ingesting raw data to Azure Storage (Bronze)
│   └── transform.py              # Polars transformation logic for Silver stage
├── terraform/
│   ├── main.tf                   # Core Azure infrastructure definitions
│   └── variables.tf              # Configurable Terraform variables
├── .dockerignore
├── .gitignore
├──  Dockerfile
├──  Readme
├──  LICENSE
└── requirements.txt              # Python dependency definitions
