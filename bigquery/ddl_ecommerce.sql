-- Create Dataset
CREATE SCHEMA IF NOT EXISTS `ecommerce_events`
OPTIONS(location="us-east4");

-- Ref Customer Table
CREATE OR REPLACE TABLE `ecommerce_events.ref_customers` (
    customer_id STRING,
    PRIMARY KEY (customer_id) NOT ENFORCED
);

-- Ref Product Table
CREATE OR REPLACE TABLE `ecommerce_events.ref_products` (
    product_id STRING,
    PRIMARY KEY (product_id) NOT ENFORCED
);

-- Ref Warehouse Table
CREATE OR REPLACE TABLE `ecommerce_events.ref_warehouses` (
    warehouse_id STRING,
    PRIMARY KEY (warehouse_id) NOT ENFORCED
);

-- Ref Users Table
CREATE OR REPLACE TABLE `ecommerce_events.ref_users` (
    user_id STRING,
    PRIMARY KEY (user_id) NOT ENFORCED
);

-- Order Events Table
CREATE OR REPLACE TABLE `ecommerce_events.orders`
(
    event_type STRING,
    order_id STRING,
    customer_id STRING,
    order_date TIMESTAMP,
    status STRING,
    items ARRAY<STRUCT<
        product_id STRING,
        product_name STRING,
        quantity INT64,
        price FLOAT64
    >>, 
    shipping_address STRUCT<
        street STRING,
        city STRING,
        country STRING
    >, 
    total_amount FLOAT64,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),    
    FOREIGN KEY (customer_id) REFERENCES `ecommerce_events.ref_customers`(customer_id) NOT ENFORCED
)
PARTITION BY DATE(order_date)
CLUSTER BY order_id, customer_id, status;

-- Inventory Events Table
CREATE OR REPLACE TABLE `ecommerce_events.inventory`
(
    event_type STRING,
    inventory_id STRING,
    product_id STRING,
    warehouse_id STRING,
    quantity_change INT64, 
    reason STRING,
    timestamp TIMESTAMP,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (product_id) REFERENCES `ecommerce_events.ref_products`(product_id) NOT ENFORCED,
    FOREIGN KEY (warehouse_id) REFERENCES `ecommerce_events.ref_warehouses`(warehouse_id) NOT ENFORCED
)
PARTITION BY DATE(timestamp)
CLUSTER BY inventory_id, product_id, warehouse_id, reason;

-- User Activity Events Table
CREATE OR REPLACE TABLE `ecommerce_events.user_activity`
(
    event_type STRING,
    user_id STRING,
    activity_type STRING,
    ip_address STRING,
    user_agent STRING,
    timestamp TIMESTAMP,
    metadata STRUCT<
        session_id STRING,
        platform STRING
    >,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (user_id) REFERENCES `ecommerce_events.ref_users`(user_id) NOT ENFORCED
)
PARTITION BY DATE(timestamp)
CLUSTER BY user_id, activity_type;