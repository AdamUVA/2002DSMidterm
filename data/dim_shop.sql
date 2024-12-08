-- Set the database to use utf8mb4
ALTER DATABASE myshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Date Dimension
CREATE TABLE IF NOT EXISTS dim_date (
    date_id INT PRIMARY KEY,
    date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    week INT,
    day INT,
    weekday INT,
    weekday_name VARCHAR(20),
    is_weekend BOOLEAN
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Customer Dimension
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id VARCHAR(50),
    customer_name VARCHAR(255),
    segment VARCHAR(50),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    market VARCHAR(50),
    region VARCHAR(50)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Product Dimension
CREATE TABLE IF NOT EXISTS dim_product (
    product_key INT PRIMARY KEY,
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    source VARCHAR(20)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Geography Dimension
CREATE TABLE IF NOT EXISTS dim_geography (
    geo_key INT PRIMARY KEY,
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    market VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(20)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Sales Fact Table
CREATE TABLE IF NOT EXISTS fact_sales (
    order_id VARCHAR(50),
    order_date_id INT,
    ship_date_id INT,
    customer_key INT,
    product_id VARCHAR(50),
    geo_key INT,
    quantity INT,
    sales_amount DECIMAL(10, 2),
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    shipping_cost DECIMAL(10, 2),
    order_priority VARCHAR(50),
    ship_mode VARCHAR(50),
    total_amount DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    net_amount DECIMAL(10, 2),
    FOREIGN KEY (order_date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (ship_date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (geo_key) REFERENCES dim_geography(geo_key)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Product Inventory Fact Table
CREATE TABLE IF NOT EXISTS fact_product_inventory (
    product_key INT,
    price DECIMAL(10, 2),
    rating DECIMAL(3, 2),
    rating_count INT,
    last_updated TIMESTAMP,
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create indexes for better performance
CREATE INDEX idx_date_id ON dim_date(date_id);
CREATE INDEX idx_customer_key ON dim_customer(customer_key);
CREATE INDEX idx_product_key ON dim_product(product_key);
CREATE INDEX idx_geo_key ON dim_geography(geo_key);
CREATE INDEX idx_order_date ON fact_sales(order_date_id);
CREATE INDEX idx_ship_date ON fact_sales(ship_date_id);
CREATE INDEX idx_product_inventory ON fact_product_inventory(product_key);