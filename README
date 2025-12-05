# Data Engineering Assessment -- GCP Streaming Pipeline

## Project Context & Architecture

The original plan was to build everything on Databricks, mainly because of cost benefits and my experience with the platform. But after reviewing the requirements, I decided to rebuild the entire solution on Google Cloud Platform (GCP) instead. This was intentional: I wanted to follow the requested environment exactly and show adaptability by delivering the project in a stack I use less often.

![alt text](./imgs/GCP%20Architecture.png)

The setup started with creating a production-ready GCP environment, including billing quotas needed for services like Dataflow. For messaging, I used Pub/Sub and created the main topic (`backend-events-topic`) along with its subscriptions. I also added a `history` subscription to store the raw data for full auditability.

To simulate real traffic, I built a serverless event generator using Cloud Functions. It produces random events based on the JSON schemas for Orders, Inventory, and User Activity, and continuously publishes them into Pub/Sub.

A full export of the GCP project configuration is included in `exported_GCP_Project.zip`.

## Data Generation & Historical Storage

The data generator source code is in the `cloud_function` directory. It uses Faker and fake-useragent to create realistic synthetic data that matches the required schemas.

![alt text](./imgs/fake%20publisher%20-%20code.png)

The deployed function exposes an HTTP endpoint called `publish_trigger`. It accepts a `count` parameter, which defines how many events to generate. The function randomly distributes messages between Order, Inventory, and User Activity event types.

![alt text](./imgs/fake%20publisher%20-%20function.png)

For historical storage, I added the `backend-events-history-sub` subscription and used Pub/Sub's native Cloud Storage Export feature. Messages are buffered for one minute and then written to the `re-partner-backup-virginia` bucket as NDJSON files. Files use the `events_` prefix and `.json` suffix.

This acts as a simple and low-maintenance Raw Data Lake layer.

![alt text](./imgs/fake%20publisher%20-%20gcs%20historical.png)

## Task 1: Data Modeling & Architecture

Based on the assessment rules, I used Dataflow for processing and BigQuery for storage.

I started by reviewing the JSON schemas and identifying natural relationships in the datasets.

![alt text](./imgs/DER_ecommerce_events.png)

### Reference Tables

I used the `ref_` prefix for reference tables. These contain IDs that link to other tables, while raw event tables match the event schemas directly (e.g., `orders`, `inventory`).

### Constraints & Metadata

I added an `ingestion_time` timestamp column to support auditing.

### Partitioning

Partitioning was based on the main time column for each dataset:

-   **Orders:** `order_date`
-   **Inventory & User Activity:** `timestamp`

This reduces query costs and improves filtering performance.

### Clustering

Clustering was optimized for typical join patterns (PK/FK). I added exceptions based on analytical needs:

-   **Orders:** clustered by `status`
-   **Inventory:** clustered by `reason`
-   **User Activity:** clustered by `activity_type`

### Historical Tracking

Although BigQuery supports Time Travel, I kept the model strictly append-only. This keeps a full, immutable audit history without complex versioning logic.

All DDL scripts are in the `bigquery` directory (file: `ddl_ecommerce.sql`).

## Task 2: Streaming Pipeline

The streaming pipeline was built in Python using Dataflow (Apache Beam).

### Ingestion & GCS

The pipeline consumes messages from the required Pub/Sub subscription and writes all raw data to Cloud Storage using the structure:

    output/{event}/{year}/{month}/{day}/{hour}/{minute}

Files are named using the event type, timestamp, and shard number. Any problematic records are routed to a DLQ under `output/errors/...` using the same folder structure.

![alt text](./imgs/task2%20-%20gcs.png)

### BigQuery Ingestion

After writing raw data to GCS, the pipeline routes each event type using `TaggedOutputs` and streams the records into the related BigQuery tables (`orders`, `inventory`, `user_activity`) in JSON format.

![alt text](./imgs/task2%20-%20bigquery%20activity.png) 
![alt text](./imgs/task2%20-%20bigquery%20inventory.png) 
![alt text](./imgs/task2%20-%20bigquery%20orders.png)

![alt text](./imgs/task2%20-%20dataflow%20execution.png) 
![alt text](./imgs/task2%20-%20dataflow%20jobs.png)

### Constraints, Learning Curve & Delivery Notes

Due to limited available time caused by personal events, I wasn't able to finish the analytical Views or generate data for the reference (`ref_`) tables as originally intended.

This project also required a quick learning curve since my main background is in Apache Spark. Working with Apache Beam and GCP services was new but very constructive.

All pipeline code and the `requirements.txt` file are located in the `dataflow` directory.
