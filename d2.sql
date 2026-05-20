-- 1. Cleaning up any existing table
DROP TABLE IF EXISTS customers;

-- 2. Creating the table matching your e-commerce headers exactly
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    country VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    membership_tier VARCHAR(50),
    registration_date DATE,
    total_orders INT,
    total_spend_usd NUMERIC(12, 2),
    avg_order_value_usd NUMERIC(12, 2),
    days_since_last_purchase INT,
    preferred_category VARCHAR(100),      
    preferred_payment_method VARCHAR(100),
    preferred_device VARCHAR(50),         
    acquisition_channel VARCHAR(100),     
    reviews_given INT,                   
    avg_review_score NUMERIC(3, 2),      
    returns_made INT,                    
    wishlist_items INT,                    
    newsletter_subscribed INT,           
    churned INT                            
);

-- 3. Importing the e-commerce data
COPY customers (
    customer_id, country, age, gender, membership_tier, registration_date, 
    total_orders, total_spend_usd, avg_order_value_usd, days_since_last_purchase, 
    preferred_category, preferred_payment_method, preferred_device, acquisition_channel, 
    reviews_given, avg_review_score, returns_made, wishlist_items, 
    newsletter_subscribed, churned
)
FROM 'C:/Users/Public/new_project/customers.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');

-- 4. Checking the results
SELECT * FROM customers LIMIT 10;

-- 1. Cleaning up any existing table
DROP TABLE IF EXISTS monthly_revenue;

-- 2. Creating the monthly trends table matching your headers exactly
CREATE TABLE monthly_revenue (
    year INT,
    month INT,
    quarter VARCHAR(10),
    orders INT,
    revenue_usd NUMERIC(15, 2),         
    avg_order_value_usd NUMERIC(12, 2),   
    avg_discount_percent NUMERIC(5, 2),  
    return_rate NUMERIC(5, 4),           
    unique_customers INT,                
    new_customers INT
);

-- 3. Importing the monthly revenue data
COPY monthly_revenue (
    year, month, quarter, orders, revenue_usd, 
    avg_order_value_usd, avg_discount_percent, return_rate, 
    unique_customers, new_customers
)
FROM 'C:/Users/Public/new_project/monthly_revenue.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');

-- 4. Checking the results
SELECT * FROM monthly_revenue LIMIT 12;

-- 1. Clean up any existing table
DROP TABLE IF EXISTS orders;

-- 2. Creating the core transactional orders table matching headers exactly
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),               
    order_date DATE,
    year INT,
    month INT,
    quarter VARCHAR(10),                 
    day_of_week VARCHAR(20),             
    product_name VARCHAR(255),           
    category VARCHAR(100),
    unit_price NUMERIC(10, 2),
    quantity INT,
    subtotal_usd NUMERIC(12, 2),          
    discount_percent NUMERIC(5, 2),  
    discount_amount NUMERIC(10, 2),       
    shipping_fee NUMERIC(10, 2),          
    tax_pct NUMERIC(5, 2),               
    tax_amount NUMERIC(10, 2),           
    total_amount_usd NUMERIC(12, 2),      
    payment_method VARCHAR(50),          
    device_used VARCHAR(50),             
    delivery_status VARCHAR(50),         
    delivery_date DATE,
    order_status VARCHAR(50),            
    returned INT,                        
    customer_segment VARCHAR(50),        
    session_id VARCHAR(100),             
    pages_viewed INT,                    
    is_repeat_customer INT               
);

-- 3. Importing the transactional data
COPY orders (
    order_id, customer_id, order_date, year, month, quarter, day_of_week, 
    product_name, category, unit_price, quantity, subtotal_usd, discount_percent, 
    discount_amount, shipping_fee, tax_pct, tax_amount, total_amount_usd, 
    payment_method, device_used, delivery_status, delivery_date, order_status, 
    returned, customer_segment, session_id, pages_viewed, is_repeat_customer
)
FROM 'C:/Users/Public/new_project/orders.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');

-- 4. Checking the results
SELECT * FROM orders LIMIT 100;


-- 1. Clean up any existing table
DROP TABLE IF EXISTS product_summary;

-- 2. Create the product performance table matching your headers exactly
CREATE TABLE product_summary(
    category VARCHAR(100),
    product_name VARCHAR(255),
    total_orders INT,
    total_revenue_usd NUMERIC(15, 2),
    avg_price NUMERIC(10, 2),
    avg_rating NUMERIC(3, 2),            
    return_rate NUMERIC(5, 2),           
    avg_discount_pct NUMERIC(5, 2),      
    avg_delivery_days NUMERIC(5, 2)      
);

-- 3. Import the product performance data
COPY product_summary (
    category, product_name, total_orders, total_revenue_usd, 
    avg_price, avg_rating, return_rate, avg_discount_pct, 
    avg_delivery_days
)
FROM 'C:/Users/Public/new_project/product_summary.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');

-- 4. Check the results
SELECT * FROM product_summary LIMIT 10;


-- EDA (Exploratory Data Analysis)
-- Checking Data Types and Columns

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'customers'; -- Change to 'orders', 'monthly_revenue', 'product_summary'

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'orders'; 

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'monthly_revenue'; 


SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'product_summary'; 



--  Checking missing values in all 4 datasets
SELECT 
    COUNT(*) - COUNT(customer_id) AS null_customer_id,
    COUNT(*) - COUNT(age) AS null_age,
    COUNT(*) - COUNT(membership_tier) AS null_membership_tier,
    COUNT(*) - COUNT(churned) AS null_churned
FROM customers;

SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN month IS NULL THEN 1 ELSE 0 END) AS null_month,
    SUM(CASE WHEN quarter IS NULL THEN 1 ELSE 0 END) AS null_quarter,
    SUM(CASE WHEN orders IS NULL THEN 1 ELSE 0 END) AS null_orders,
    SUM(CASE WHEN revenue_usd IS NULL THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN avg_order_value_usd IS NULL THEN 1 ELSE 0 END) AS null_avg_order_value,
    SUM(CASE WHEN avg_discount_percent IS NULL THEN 1 ELSE 0 END) AS null_avg_discount,
    SUM(CASE WHEN return_rate IS NULL THEN 1 ELSE 0 END) AS null_return_rate,
    SUM(CASE WHEN unique_customers IS NULL THEN 1 ELSE 0 END) AS null_unique_customers,
    SUM(CASE WHEN new_customers IS NULL THEN 1 ELSE 0 END) AS null_new_customers
FROM monthly_revenue;


SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN month IS NULL THEN 1 ELSE 0 END) AS null_month,
    SUM(CASE WHEN quarter IS NULL THEN 1 ELSE 0 END) AS null_quarter,
    SUM(CASE WHEN day_of_week IS NULL THEN 1 ELSE 0 END) AS null_day_of_week,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN subtotal_usd IS NULL THEN 1 ELSE 0 END) AS null_subtotal_usd,
    SUM(CASE WHEN discount_percent IS NULL THEN 1 ELSE 0 END) AS null_discount_percent,
    SUM(CASE WHEN discount_amount IS NULL THEN 1 ELSE 0 END) AS null_discount_amount,
    SUM(CASE WHEN shipping_fee IS NULL THEN 1 ELSE 0 END) AS null_shipping_fee,
    SUM(CASE WHEN tax_pct IS NULL THEN 1 ELSE 0 END) AS null_tax_pct,
    SUM(CASE WHEN tax_amount IS NULL THEN 1 ELSE 0 END) AS null_tax_amount,
    SUM(CASE WHEN total_amount_usd IS NULL THEN 1 ELSE 0 END) AS null_total_amount_usd,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS null_payment_method,
    SUM(CASE WHEN device_used IS NULL THEN 1 ELSE 0 END) AS null_device_used,
    SUM(CASE WHEN delivery_status IS NULL THEN 1 ELSE 0 END) AS null_delivery_status,
    SUM(CASE WHEN delivery_date IS NULL THEN 1 ELSE 0 END) AS null_delivery_date,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_order_status,
    SUM(CASE WHEN returned IS NULL THEN 1 ELSE 0 END) AS null_returned,
    SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS null_customer_segment,
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS null_session_id,
    SUM(CASE WHEN pages_viewed IS NULL THEN 1 ELSE 0 END) AS null_pages_viewed,
    SUM(CASE WHEN is_repeat_customer IS NULL THEN 1 ELSE 0 END) AS null_is_repeat_customer
FROM orders;

SELECT 
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(customer_id) AS null_customer_id,
    COUNT(*) - COUNT(order_date) AS null_order_date,
    COUNT(*) - COUNT(total_amount_usd) AS null_revenue
FROM orders;

SELECT 
    SUM(CASE WHEN unit_price < 0 THEN 1 ELSE 0 END) AS negative_prices,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantities,
    SUM(CASE WHEN delivery_date < order_date THEN 1 ELSE 0 END) AS impossible_delivery_dates
FROM orders;

SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN total_orders IS NULL THEN 1 ELSE 0 END) AS null_total_orders,
    SUM(CASE WHEN total_revenue_usd IS NULL THEN 1 ELSE 0 END) AS null_total_revenue,
    SUM(CASE WHEN avg_price IS NULL THEN 1 ELSE 0 END) AS null_avg_price,
    SUM(CASE WHEN avg_rating IS NULL THEN 1 ELSE 0 END) AS null_avg_rating,
    SUM(CASE WHEN return_rate IS NULL THEN 1 ELSE 0 END) AS null_return_rate,
    SUM(CASE WHEN avg_discount_pct IS NULL THEN 1 ELSE 0 END) AS null_avg_discount,
    SUM(CASE WHEN avg_delivery_days IS NULL THEN 1 ELSE 0 END) AS null_avg_delivery_days
FROM product_summary;

-- Checking the duplicates in all 4 dataset

SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

SELECT year, month, COUNT(*) 
FROM monthly_revenue 
GROUP BY year, month 
HAVING COUNT(*) > 1;

SELECT category, product_name, COUNT(*) 
FROM product_summary 
GROUP BY category, product_name 
HAVING COUNT(*) > 1;

-- Clean up the missing values by categorizing them properly
UPDATE orders
SET customer_segment = 'Unassigned'
WHERE customer_segment IS NULL;

-- Quick verification check (Should return 0 now)
SELECT COUNT(*) AS remaining_null_segments 
FROM orders 
WHERE customer_segment IS NULL;

-- # Building the RFM Segmentation Engine

CREATE OR REPLACE VIEW v_customer_rfm_segments AS
WITH raw_rfm AS (
    -- Grouping transactions to calculate individual baseline RFM shapes
    SELECT 
        customer_id,
        (SELECT MAX(order_date) FROM orders) - MAX(order_date) AS recency_days,
        COUNT(order_id) AS frequency,
        SUM(total_amount_usd) AS monetary_value
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    -- Breaking behaviors into clean 1-to-5 quintiles using window functions
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score, -- 5 = Very recent, 1 = Long time ago
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,     -- 5 = Buys constantly, 1 = One-time buyer
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS m_score  -- 5 = Big spender, 1 = Low spender
    FROM raw_rfm
)
-- Assigning high-value business labels based on combined quintile metrics
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary_value,
    r_score, 
    f_score, 
    m_score,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Churned / Hibernating'
        ELSE 'About to Sleep / Average'
    END AS customer_lifecycle_segment
FROM rfm_scores;

SELECT * FROM v_customer_rfm_segments 
LIMIT 10;


-- The Revenue Leakage Join (INNER JOIN)
SELECT 
    c.membership_tier,
    COUNT(c.customer_id) AS total_churned_members,
    SUM(c.total_spend_usd) AS total_revenue_lost,
    ROUND(AVG(c.total_spend_usd), 2) AS avg_lost_value_per_customer
FROM customers c
INNER JOIN v_customer_rfm_segments rfm 
    ON c.customer_id = rfm.customer_id
WHERE c.churned = 1
GROUP BY c.membership_tier
ORDER BY total_revenue_lost DESC;

-- Fulfillment Friction Analysis (INNER JOIN)
SELECT 
    o.category,
    ROUND(AVG(p.avg_delivery_days), 1) AS avg_days_to_deliver,
    ROUND(AVG(c.avg_review_score), 2) AS avg_customer_rating,
    ROUND(AVG(c.churned) * 100, 2) AS category_churn_rate_pct
FROM orders o
INNER JOIN product_summary p ON o.product_name = p.product_name
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.category
ORDER BY category_churn_rate_pct DESC;

-- High-Value "At Risk" Target List (LEFT JOIN)

SELECT 
    c.customer_id,
    c.country,
    c.preferred_category,
    rfm.monetary_value AS lifetime_spend_usd,
    rfm.recency_days AS days_since_last_order,
    rfm.customer_lifecycle_segment
FROM v_customer_rfm_segments rfm
LEFT JOIN customers c ON rfm.customer_id = c.customer_id
WHERE rfm.customer_lifecycle_segment = 'At Risk'
ORDER BY rfm.monetary_value DESC
LIMIT 20;

--  Promotion vs. Retention Audit (INNER JOIN)
SELECT 
    CASE 
        WHEN o.discount_percent = 0 THEN 'No Discount'
        WHEN o.discount_percent > 0 AND o.discount_percent <= 15 THEN 'Light Discount (1-15%)'
        ELSE 'Heavy Discount (>15%)'
    END AS discount_cohort,
    COUNT(o.order_id) AS total_orders_placed,
    ROUND(AVG(o.is_repeat_customer) * 100, 2) AS repeat_purchase_rate_pct,
    ROUND(AVG(o.total_amount_usd), 2) AS avg_order_value
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY repeat_purchase_rate_pct DESC;