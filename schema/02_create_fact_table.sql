-- =============================================
-- Retail Analytics Data Warehouse
-- Star Schema - Fact Table
-- SQL Server / T-SQL Implementation
-- =============================================

CREATE TABLE fact_sales (
    sales_key BIGINT PRIMARY KEY IDENTITY(1,1),
    calendar_key INT NOT NULL,
    store_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    transaction_id VARCHAR(50) NOT NULL,
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    sales_amount DECIMAL(12,2) NOT NULL CHECK (sales_amount >= 0),
    discount_amount DECIMAL(12,2) DEFAULT 0 CHECK (discount_amount >= 0),
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Key Constraints
    FOREIGN KEY (calendar_key) REFERENCES dim_calendar(calendar_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);
