-- =============================================
-- Sample Data Population
-- =============================================

-- Calendar Dimension Sample Data
INSERT INTO dim_calendar (full_date, year, quarter, month, month_name, day, day_of_week)
VALUES
('2026-01-05', 2026, 1, 1, 'January', 5, 'Monday'),
('2026-02-15', 2026, 1, 2, 'February', 15, 'Sunday'),
('2026-03-20', 2026, 1, 3, 'March', 20, 'Friday');

-- Store Dimension Sample Data
INSERT INTO dim_store (store_name, store_type, region, city, state, country, open_date)
VALUES
('Downtown Superstore', 'Supermarket', 'North', 'New York', 'NY', 'USA', '2015-03-01'),
('West Side Market', 'Grocery', 'West', 'Los Angeles', 'CA', 'USA', '2018-06-15');

-- Product Dimension Sample Data
INSERT INTO dim_product (product_name, brand, category, subcategory, unit_price)
VALUES
('Organic Apples', 'FreshFarm', 'Produce', 'Fruit', 3.50),
('Whole Wheat Bread', 'GrainGood', 'Bakery', 'Bread', 4.25);

-- Customer Dimension Sample Data
INSERT INTO dim_customer (first_name, last_name, gender, birth_date, email, phone, city, state, country)
VALUES
('John', 'Doe', 'M', '1985-06-15', 'john.doe@email.com', '555-1234', 'New York', 'NY', 'USA'),
('Jane', 'Smith', 'F', '1990-03-22', 'jane.smith@email.com', '555-5678', 'Los Angeles', 'CA', 'USA');

-- Fact Table Sample Data
INSERT INTO fact_sales (calendar_key, store_key, product_key, customer_key, transaction_id, quantity_sold, sales_amount, discount_amount)
VALUES
(1, 1, 1, 1, 'TXN1001', 5, 17.50, 0.00),
(2, 2, 2, 2, 'TXN1002', 3, 12.75, 1.00);
