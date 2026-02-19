# Retail Analytics Star Schema (SQL Data Warehouse)

## Project Overview

This project demonstrates the **end-to-end process** of building a **retail analytics data warehouse** using the **Star Schema** modeling approach. It covers **data modeling, SQL DDL creation, data population, and advanced analytics queries** for business intelligence (BI) reporting.

**Objective:** Design and implement a scalable data warehouse that enables fast aggregations, drill-down analysis, and actionable business insights for retail operations.

**Key Concepts:** Dimensional modeling, star schema design, surrogate keys, referential integrity, transactional grain

---

## Key Features

- **Star Schema Design** with 4 dimension tables and 1 central fact table
- **Hierarchical Dimensions** (e.g., Year → Quarter → Month → Day in Calendar)
- **Referential Integrity** enforced through foreign key constraints
- **Transactional Grain**, each fact row = one product in one transaction
- **Sample Data** for testing and demonstration
- **Business Intelligence Queries** for common analytics scenarios

---

## Schema Design

### Entity Relationship Diagram
``````mermaid
erDiagram
    dim_calendar ||--o{ fact_sales : "calendar_key"
    dim_store ||--o{ fact_sales : "store_key"
    dim_product ||--o{ fact_sales : "product_key"
    dim_customer ||--o{ fact_sales : "customer_key"

    dim_calendar {
        int calendar_key PK
        date full_date
        int year
        int quarter
        int month
        varchar month_name
        int day
        varchar day_of_week
    }

    dim_store {
        int store_key PK
        varchar store_name
        varchar store_type
        varchar region
        varchar city
        varchar state
        varchar country
        date open_date
    }

    dim_product {
        int product_key PK
        varchar product_name
        varchar brand
        varchar category
        varchar subcategory
        decimal unit_price
    }

    dim_customer {
        int customer_key PK
        varchar first_name
        varchar last_name
        char gender
        date birth_date
        varchar email
        varchar phone
        varchar city
        varchar state
        varchar country
    }

    fact_sales {
        bigint sales_key PK
        int calendar_key FK
        int store_key FK
        int product_key FK
        int customer_key FK
        varchar transaction_id
        int quantity_sold
        decimal sales_amount
        decimal discount_amount
        datetime2 created_at
    }
``````

### Tables Overview

| Table | Type | Purpose | Key Fields |
|-------|------|---------|------------|
| **dim_calendar** | Dimension | Date hierarchy for time-based analysis | year, quarter, month, day |
| **dim_store** | Dimension | Store location and attributes | store_name, region, city, state |
| **dim_product** | Dimension | Product catalog and pricing | product_name, brand, category, unit_price |
| **dim_customer** | Dimension | Customer demographics and contact | name, email, city, birth_date |
| **fact_sales** | Fact | Transactional sales data | quantity_sold, sales_amount, discount_amount |

---

## Implementation Steps

### Step 1: Create Dimension Tables

Dimension tables store descriptive attributes and use **surrogate keys** (auto-generated integers) as primary keys.

**Key Design Decisions:**
- **Surrogate Keys:** Enable Type 2 Slowly Changing Dimensions (SCD) in future
- **Natural Keys:** Stored as attributes (e.g., product_name, store_name)
- **Hierarchies:** Calendar dimension enables drill-down (Year → Quarter → Month → Day)

See: [`schema/01_create_dimensions.sql`](schema/01_create_dimensions.sql)

---

### Step 2: Create Fact Table

The fact table stores measurable events (sales transactions) with foreign keys to all dimensions.

**Key Design Decisions:**
- **Transactional Grain:** One row per product per transaction
- **Foreign Key Constraints:** Ensure referential integrity (no orphaned records)
- **Check Constraints:** Prevent negative quantities or amounts
- **Audit Column:** `created_at` timestamp for data lineage

See: [`schema/02_create_fact_table.sql`](schema/02_create_fact_table.sql)

---

### Step 3: Populate with Sample Data

Sample data demonstrates the schema structure and enables query testing.

See: [`data/sample_data.sql`](data/sample_data.sql)

---

### Step 4: Run Analytics Queries

Business intelligence queries demonstrate common retail analytics scenarios.

See: [`queries/analytics_queries.sql`](queries/analytics_queries.sql)

---

## Sample Analytics Queries

### Query 1: Year-to-Date Sales by Month
``````sql
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
``````

**Business Value:** Track monthly revenue trends and transaction volumes for forecasting and goal setting.

---

### Query 2: Top 5 Products by Revenue
``````sql
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
``````

**Business Value:** Identify best-selling products for inventory optimization and marketing focus.

---

### Query 3: Sales by Region and Category
``````sql
SELECT 
    s.region,
    p.category,
    SUM(f.sales_amount) AS total_sales,
    AVG(f.sales_amount) AS avg_transaction_value
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY s.region, p.category
ORDER BY s.region, total_sales DESC;
``````

**Business Value:** Guide regional marketing strategies and category-specific promotions.

---

### Query 4: Customer Purchase Frequency
``````sql
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    c.city,
    c.state,
    COUNT(DISTINCT f.transaction_id) AS purchase_count,
    SUM(f.sales_amount) AS total_spent,
    AVG(f.sales_amount) AS avg_transaction_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name, c.city, c.state
ORDER BY total_spent DESC;
``````

**Business Value:** Segment customers by value for targeted retention campaigns and loyalty programs.

---

### Query 5: Store Performance Comparison
``````sql
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
``````

**Business Value:** Compare store performance to identify high/low performers and operational best practices.

---

## Business Value

| Capability | Benefit |
|------------|---------|
| **Fast BI Reporting** | Star schema optimized for aggregations; queries run 10-100× faster than normalized schemas |
| **Consistent Data Quality** | Foreign key constraints prevent orphaned records and data integrity issues |
| **Scalable Design** | Easy to add new dimensions (promotions, suppliers, channels) without schema redesign |
| **Actionable Insights** | Supports KPIs like YTD sales, customer lifetime value, regional performance, inventory turnover |
| **Historical Analysis** | Surrogate keys enable Type 2 SCDs for tracking attribute changes over time |
| **Drill-Down Capability** | Hierarchical dimensions allow analysis at different granularities (Year → Quarter → Month → Day) |

---

## Skills Demonstrated

- **Data Modeling:** Star schema design, dimensional modeling, grain definition
- **SQL DDL:** CREATE TABLE statements with data types, constraints, and keys
- **Referential Integrity:** Foreign key relationships, cascading rules
- **Data Quality:** Check constraints, NOT NULL constraints, default values
- **SQL DML:** INSERT statements for data population
- **Analytics Queries:** Multi-table JOINs, aggregations (SUM, COUNT, AVG), GROUP BY, ORDER BY
- **Business Intelligence:** Translating business questions into SQL queries
- **Data Warehouse Concepts:** Fact vs dimension tables, surrogate keys, transactional grain

---

## How to Use This Project

### Option 1: Execute in SQL Server

1. **Requirements:**
   - Microsoft SQL Server (Express Edition or higher)
   - SQL Server Management Studio (SSMS) - [Download free](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

2. **Setup:**
   - Open SSMS
   - Connect to your SQL Server instance
   - Create new database: `CREATE DATABASE RetailAnalytics;`
   - Use the database: `USE RetailAnalytics;`

3. **Run schema files** in order:
   - `schema/01_create_dimensions.sql`
   - `schema/02_create_fact_table.sql`
   - `data/sample_data.sql`
   - `queries/analytics_queries.sql`

### Option 2: Review Code on GitHub

Browse the organized SQL files in the repository to understand the implementation approach and query patterns.

---

## Repository Structure
```````
retail-analytics-star-schema/
│
├── README.md                          ← Project documentation (you are here)
│
├── schema/
│   ├── 01_create_dimensions.sql      ← DDL for dimension tables
│   └── 02_create_fact_table.sql      ← DDL for fact table with foreign keys
│
├── data/
│   └── sample_data.sql                ← Sample INSERT statements for testing
│
├── queries/
│   └── analytics_queries.sql          ← 5 business intelligence queries
│
└── docs/
    └── schema_diagram.md              ← Visual schema representation
```````

---

## Technologies Used

- **Microsoft SQL Server** — Relational database management system
- **T-SQL (Transact-SQL)** — SQL Server's extended SQL syntax
- **SSMS (SQL Server Management Studio)** — Database development and administration tool
- **Data Warehousing Concepts:** Star schema, dimensional modeling, ETL patterns
- **Database Design:** Normalization, denormalization, surrogate keys, referential integrity
- **Business Intelligence:** KPI definition, aggregation queries, OLAP operations

---

## Future Enhancements

Potential extensions to this project:

- [ ] Add **Type 2 Slowly Changing Dimensions** to track historical attribute changes
- [ ] Implement **aggregate tables** (materialized views) for performance optimization
- [ ] Create **date dimension** generator script for populating 10+ years of dates
- [ ] Add **indexes** on foreign keys and frequently queried columns
- [ ] Build **ETL pipeline** scripts for automated data loading
- [ ] Integrate with **BI tools** (Tableau, Power BI) for visualization
- [ ] Add **promotion dimension** to track marketing campaigns and discounts
- [ ] Implement **data quality checks** and validation scripts

---

## Contact

**Sarina Gurung**  
Data Analyst | MS Business Analytics

- Email: sarinagurung012@gmail.com
- LinkedIn: [linkedin.com/in/sarina-gurung-a69b79324](https://www.linkedin.com/in/sarina-gurung-a69b79324/)

---

## License

This project is available for educational and portfolio purposes.

---

**If you found this project helpful, please star this repository!**
```````
