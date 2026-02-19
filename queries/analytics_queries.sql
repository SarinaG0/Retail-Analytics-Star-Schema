-- =============================================
-- Business Intelligence Analytics Queries
-- =============================================

-- Query 1: Year-to-Date Sales by Month
SELECT 
    c.year,
    c.month,
    c.month_name,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.transaction_id) AS transaction_count
FROM fact_sales f
JOIN dim_calendar c ON f.calendar_key = c.calendar_key
WHERE c.year = 2026
GROUP BY c.year, c.month, c.month_name
ORDER BY c.month;

-- Query 2: Top 5 Products by Revenue
SELECT 
    p.product_name,
    p.brand,
    p.category,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name, p.brand, p.category
ORDER BY total_revenue DESC
LIMIT 5;

-- Query 3: Sales by Region and Category
SELECT 
    s.region,
    p.category,
    SUM(f.sales_amount) AS total_sales,
    AVG(f.sales_amount) AS avg_sales
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY s.region, p.category
ORDER BY s.region, total_sales DESC;

-- Query 4: Customer Purchase Frequency
SELECT 
    c.first_name,
    c.last_name,
    c.city,
    c.state,
    COUNT(DISTINCT f.transaction_id) AS purchase_count,
    SUM(f.sales_amount) AS total_spent
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.first_name, c.last_name, c.city, c.state
ORDER BY total_spent DESC;

-- Query 5: Store Performance Analysis
SELECT 
    s.store_name,
    s.region,
    COUNT(DISTINCT f.transaction_id) AS transactions,
    SUM(f.sales_amount) AS revenue,
    AVG(f.sales_amount) AS avg_transaction_value
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY s.store_name, s.region
ORDER BY revenue DESC;
