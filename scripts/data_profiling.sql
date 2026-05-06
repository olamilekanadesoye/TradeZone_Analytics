/* 
=====================================================================================================================
PROJECT     : TradeZone E-Commerce Analysis
AUTHOR      : Olamilekan Adesoye
DATE      	: 2024
DATABASE    : PostgreSQL
=====================================================================================================================
DATA PROFILING 
=====================================================================================================================
Purpose: To preview the data stored in each tables and identify anomalies before data cleaning. This ensures that
		cleaning is structured and time efficient. 
=====================================================================================================================
*/

SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM products;
SELECT * FROM reviews;
SELECT * FROM sellers;

/*
=====================================================================================================================
SECTION 1: MISSING VALUES CHECKS
=====================================================================================================================
Purpose: To identify columns with null values all columns of multiple tables and to act accordingly
Result: Missing unit_price values in products and order-items table, missing total_amount values in order_items,
		orders, and payment tables and missing values in delivery_date column of orders table
=====================================================================================================================
*/

-- Customers table 
SELECT
	COUNT(*) - COUNT(customer_id) missing_cust_id,
	COUNT(*) - COUNT(first_name) missing_first_name,
	COUNT(*) - COUNT(last_name) missing_last_name,
	COUNT(*) - COUNT(email) missing_email,
	COUNT(*) - COUNT(city) missing_city,
	COUNT(*) - COUNT(state) missing_state,
	COUNT(*) - COUNT(signup_date) missing_signup_date,
	COUNT(*) - COUNT(account_status) missing_account_status
FROM customers;

-- order_items table
SELECT
	COUNT(*) - COUNT(item_id) missing_item_id,
	COUNT(*) - COUNT(order_id) missing_order_id,
	COUNT(*) - COUNT(product_id) missing_product_id,
	COUNT(*) - COUNT(quantity) missing_quantity,
	COUNT(*) - COUNT(unit_price) missing_unit_price,
	COUNT(*) - COUNT(line_total) missing_line_total
FROM order_items;

-- Orders table
SELECT
	COUNT(*) - COUNT(order_id) missing_order_id,
	COUNT(*) - COUNT(customer_id) missing_customer_id,
	COUNT(*) - COUNT(seller_id) missing_seller_id,
	COUNT(*) - COUNT(order_date) missing_order_date,
	COUNT(*) - COUNT(delivery_date) missing_delivery_date,
	COUNT(*) - COUNT(order_status) missing_order_status,
	COUNT(*) - COUNT(total_amount) missing_total_amount
FROM orders;

-- Payments Table
SELECT
	COUNT(*) - COUNT(payment_id) missing_payment_id,
	COUNT(*) - COUNT(order_id) missing_order_id,
	COUNT(*) - COUNT(payment_method) missing_payment_method,
	COUNT(*) - COUNT(amount) missing_amount,
	COUNT(*) - COUNT(payment_date) missing_payment_date
FROM payments;

-- Products table
SELECT 
	COUNT(*) - COUNT(product_id) missing_product_id,
	COUNT(*) - COUNT(product_name) missing_product_name,
	COUNT(*) - COUNT(category) missing_category,
	COUNT(*) - COUNT(unit_price) missing_unit_price,
	COUNT(*) - COUNT(seller_id) seller_id
FROM products;

-- Reviews Table
SELECT
	COUNT(*) - COUNT(review_id) missing_review_id,
	COUNT(*) - COUNT(product_id) missing_product_id,
	COUNT(*) - COUNT(customer_id) missing_customer_id,
	COUNT(*) - COUNT(order_id) missing_order_id,
	COUNT(*) - COUNT(rating) missing_rating,
	COUNT(*) - COUNT(review_date) missing_review_date
FROM reviews;

-- Sellers Table
SELECT
	COUNT(*) - COUNT(seller_id) missing_seller_id,
	COUNT(*) - COUNT(seller_name) missing_seller_name,
	COUNT(*) - COUNT(onboarding_date) missing_onboarding_dat,
	COUNT(*) - COUNT(product_category) missing_product_category,
	COUNT(*) - COUNT(city) missing_city,
	COUNT(*) - COUNT(state) missing_state,
	COUNT(*) - COUNT(account_status) missing_account_status
FROM sellers;

/*
=====================================================================================================================
SECTION 2: DUPLICATE CHECK 
=====================================================================================================================
Purpose: To check for cases wherby records across each tables are repeated.
Result: Each table used a Primary Key that stored unique values for each records and as a result no duplicate 
		was found
=====================================================================================================================
*/

-- Customer_Table
SELECT
	customer_id,
	COUNT(*) AS occurences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Order_Items
SELECT
	item_id,
	COUNT(*) AS occurences
FROM order_items
GROUP BY item_id
HAVING COUNT(*) > 1;

-- Orders
SELECT 
	order_id,
	COUNT(*) AS occurences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Payments
SELECT
	payment_id,
	COUNT(*) AS occurences
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

-- Products
SELECT
	product_id,
	COUNT(*) AS occurences
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Reviews
SELECT
	review_id,
	COUNT(*) AS occurences
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Sellers
SELECT 
	seller_id,
	COUNT(*) AS occurences
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

/*
=====================================================================================================================
SECTION 3: DISTINCT VALUE CHECK
=====================================================================================================================
Purpose: To investigate data quality issue of inconsitent values in each tables.
Result: The city column in customers and sellers table has inconsistent values which could distort findings. 
		Also, rating column within the reviews table had ratings that fell beyond and below 1-5 range.
=====================================================================================================================
*/

-- Customer
SELECT city, COUNT(city) FROM customers GROUP BY city;
SELECT DISTINCT state FROM customers;
SELECT DISTINCT account_status FROM customers;

-- Orders
SELECT DISTINCT order_status FROM orders;

-- Payments
SELECT DISTINCT payment_method FROM payments;

-- Sellers
SELECT product_category, COUNT(product_category) FROM sellers GROUP BY product_category;
SELECT city, COUNT(city) FROM sellers GROUP BY city;
SELECT DISTINCT state FROM sellers;
SELECT DISTINCT account_status FROM sellers;

-- Reviews
SELECT rating, COUNT(rating) FROM reviews GROUP BY rating;

/*
=====================================================================================================================
SECTION 4: VALUE DISTRIBUTION
=====================================================================================================================
Purpose: To ensure that values can be calculated for analysis
Result: Columns containing values across multiple tables are ready for aggregations 
=====================================================================================================================
*/

-- Order_Items
SELECT
	MIN(quantity) AS minimum,
	MAX(quantity) AS maximum,
	AVG(quantity) AS average,
	SUM(quantity) AS total,
	COUNT(*) AS total_rows
FROM order_items;

SELECT
	MIN(unit_price) AS minimum,
	MAX(unit_price) AS maximum,
	AVG(unit_price) AS average,
	SUM(unit_price) AS total,
	COUNT(*) AS total_rows
FROM order_items;

SELECT
	MIN(line_total) AS minimum,
	MAX(line_total) AS maximum,
	AVG(line_total) AS average,
	SUM(line_total) AS total,
	COUNT(*) AS total_rows
FROM order_items;

-- Orders
SELECT
	MIN(total_amount) AS minimum,
	MAX(total_amount) AS maximum,
	AVG(total_amount) AS average,
	SUM(total_amount) AS total,
	COUNT(*) AS total_rows
FROM orders;

-- Payments
SELECT
	MIN(amount) AS minimum,
	MAX(amount) AS maximum,
	AVG(amount) AS average,
	SUM(amount) AS total,
	COUNT(*) AS total_rows
FROM payments;


-- Products
SELECT
	MIN(unit_price) AS minimum,
	MAX(unit_price) AS maximum,
	AVG(unit_price) AS average,
	SUM(unit_price) AS total,
	COUNT(*) AS total_rows
FROM products;



/*
=====================================================================================================================
SECTION 5: Outlier detection
=====================================================================================================================
Purpose: To check for extreme values that might distort finding. Unit_price was looked into because it connected to
		other tables, as well as, the total_amount.
Result: Outliers were found, but Upon review, these represent premium or high-value products whose prices are 
		consistent with their product category and thus were retained.
=====================================================================================================================
*/

SELECT
*
FROM(
	SELECT
		product_id,
		product_name,
		unit_price,
		ROUND((unit_price-AVG(unit_price) OVER())/STDDEV(unit_price) OVER(),2) AS Zscores
	FROM products
)t
WHERE ABS(Zscores) > 3;

SELECT * FROM products;

/*
=====================================================================================================================
SECTION 6: FORMAT AND PATTERN CONSISTENCY
=====================================================================================================================
Purpose: To identify cases whereby the values doesn't fit the format or pattern of the column
Result: Consistency across all columns checked. 
=====================================================================================================================
*/

-- Customer
SELECT email FROM customers
WHERE email NOT LIKE '%@%.%';
