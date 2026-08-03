# CivicPulse 311 — NYC 311 Operational Data Platform

An end-to-end Azure cloud data engineering pipeline that transforms NYC 311 service request data into analytics-ready datasets using Apache Airflow, Polars, Azure Blob Storage, Azure Data Factory, PostgreSQL, Terraform, and Power BI.

## 📖 Overview

CivicPulse 311 is a cloud-native data engineering project that automates the ingestion, transformation, storage, and delivery of NYC 311 Open Data for operational reporting and analytics.

The platform follows a Medallion (Bronze–Silver–Gold) Architecture, enabling raw API data to be progressively refined into trusted, business-ready datasets. Infrastructure is provisioned using Terraform, orchestration is managed by Apache Airflow, transformations are performed with Polars, and curated data is stored in Azure Database for PostgreSQL for reporting in Power BI.

This project demonstrates modern data engineering practices including:

Automated pipeline orchestration
Cloud object storage
Data lake architecture
Infrastructure as Code (IaC)
Incremental ETL processing
Analytics-ready data modelling

## 🏗️ Solution Architecture

## Pipeline Flow

NYC Open Data (SODA API)
            │
            ▼
Python Ingestion Module
(upload_raw_data.py)
            │
            ▼
Azure Blob Storage
Bronze Layer (CSV)
            │
            ▼
Polars Transformation
(transform.py)
            │
            ▼
Azure Blob Storage
Silver Layer (Parquet)
            │
            ▼
Azure Data Factory
            │
            ▼
Azure PostgreSQL
Gold Layer
            │
            ▼
Power BI Dashboards

## 🚀 Key Features

- Automated hourly data ingestion with Apache Airflow
- Raw data landing in Azure Blob Storage (Bronze Layer)
- High-performance transformation using Polars LazyFrame
- Conversion from CSV to compressed Parquet
- Medallion Architecture (Bronze → Silver → Gold)
- Azure Data Factory pipeline integration
- PostgreSQL analytical data warehouse
- Infrastructure provisioned using Terraform
- Dashboard-ready data model for Power BI

## 🛠️ Technology Stack
## Category	                    Technology
Programming	                    Python 3
Workflow Orchestration	        Apache Airflow
Infrastructure as Code	        Terraform
Cloud Platform	                Microsoft Azure
Object Storage	                Azure Blob Storage
Data Processing	                Polars
Data Integration	            Azure Data Factory
Database	                    Azure Database for PostgreSQL Flexible Server
Analytics	                    Power BI
Data Format	                    CSV, Parquet
Version Control	                Git & GitHub

## 🏛️ Architecture Layers
## 🥉 Bronze Layer — Raw Data

### Technology

- Azure Blob Storage

### Purpose

- Stores immutable raw NYC 311 service request data exactly as received from the API.

### Implementation

- Python Azure Blob SDK
- CSV storage
- Historical archive
- Audit-friendly

## 🥈 Silver Layer — Refined Data

### Technology

- Polars
- Azure Blob Storage

### Purpose

- Transforms raw data into a clean, analytics-friendly format.

### Processing includes

- Column selection
- Column renaming
- Schema standardisation
- Parquet conversion
- Snappy compression

## 🥇 Gold Layer — Analytics

### Technology

- Azure Database for PostgreSQL

### Purpose

- Stores curated business-ready datasets for reporting and dashboard consumption.

#### Current analytical table:

- gold.urban_city_requests

## ⚙️ Airflow Workflow

The pipeline is orchestrated through a single Airflow DAG

Extract Data
      │
      ▼
Upload CSV to Bronze
      │
      ▼
Transform with Polars
      │
      ▼
Create Gold Schema
      │
      ▼
Trigger Azure Data Factory
      │
      ▼
Load into PostgreSQL

### Pipeline schedule:

- Hourly execution
- Automatic retries
- Dependency management
- Modular task design

## ☁️ Infrastructure Provisioning

Azure infrastructure is provisioned using Terraform.

Resources include:

- Azure Resource Group
- Azure Storage Account
- Bronze Storage Container
- Silver Storage Container
- Azure PostgreSQL Flexible Server
- PostgreSQL Database
- Azure Data Factory
- Linked Services
- Parquet Dataset

## 📂 Repository Structure

>>>>>>> 8a1540a (chore(Readme): Updated Readme with detailed architecture, schema, and setup guide, also updated pipeline architecture image)
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
<<<<<<< HEAD
=======

## 📈 Future Enhancements

- Incremental API ingestion using watermarking
- Data quality validation with Great Expectations
- CI/CD pipeline using GitHub Actions
- Container deployment with Azure Container Apps
- Monitoring with Azure Monitor and Log Analytics
- Data lineage and metadata catalog
- Power BI semantic model and enterprise dashboards
- Star schema with dimension and fact tables

## 👨‍💻 Author

### Miracle Osabuogbe

#### Cloud Data Engineer | Azure Data Engineer | Data Analytics Engineer

##### Core Skills

- Python
- SQL
- Apache Airflow
- Polars
- Azure Data Factory
- Azure Blob Storage
- PostgreSQL
- Terraform
- Docker
- Power BI
>>>>>>> 8a1540a (chore(Readme): Updated Readme with detailed architecture, schema, and setup guide, also updated pipeline architecture image)
