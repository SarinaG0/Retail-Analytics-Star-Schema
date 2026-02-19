-- =============================================
-- Retail Analytics Data Warehouse
-- Star Schema - Dimension Tables
-- =============================================

-- Calendar Dimension
CREATE TABLE dim_calendar (
    calendar_key INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    full_date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    quarter INT CHECK (quarter BETWEEN 1 AND 4),
    month INT CHECK (month BETWEEN 1 AND 12),
    month_name VARCHAR(20),
    day INT CHECK (day BETWEEN 1 AND 31),
    day_of_week VARCHAR(10)
);

-- Store Dimension
CREATE TABLE dim_store (
    store_key INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    store_name VARCHAR(100) NOT NULL,
    store_type VARCHAR(50),
    region VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    open_date DATE
);

-- Product Dimension
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    product_name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    unit_price DECIMAL(10,2)
);

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender CHAR(1),
    birth_date DATE,
    email VARCHAR(200),
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50)
);
