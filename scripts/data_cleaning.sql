/* 
=====================================================================================================================
PROJECT     : TradeZone E-Commerce Analysis
AUTHOR      : Olamilekan Adesoye
DATE      	: 2024
DATABASE    : PostgreSQL
=====================================================================================================================
-- DATA CLEANING
=====================================================================================================================
*Purpose: To prepare and validate data based on findings and observations in the data profiling stage.
*Approach: Like profiling, this process follows a structured approach. 1) Standardize text columns, 2) Standardize
numerical columns, 3) Handle missing values, 4) Handle Outliers
*Additional Info: All tables were cleaned into a VIEW rather than creating another table to preverse 
the original data and encorage flexibility. Each VIEW was created with CREATE OR REPLACE VIEW and 
named as cleaned_prefix, for example cleaned_sellers and cleaned_orders.
=====================================================================================================================
*/

-- Customer
CREATE OR REPLACE VIEW cleaned_customers AS(
	SELECT
		customer_id,
		first_name,
		last_name,
		email,
		REPLACE(REPLACE(REPLACE(REPLACE(INITCAP(TRIM(city)),'PortHarcourt','Port Harcourt'),
		'Port-Harcourt','Port Harcourt'), 'Lago S','Lagos'),'Portharcourt','Port Harcourt') AS city,
		state,
		account_status,
		signup_date
FROM customers
);

--Sellers
CREATE OR REPLACE VIEW cleaned_sellers AS(
	SELECT
		seller_id,
		seller_name,
		onboarding_date,
		CASE
			WHEN cleaned_product_category = 'Beauty' THEN 'Beauty And Personal Care'
			WHEN cleaned_product_category = 'Food' THEN 'Food And Beverages'
			WHEN cleaned_product_category = 'Sports' THEN 'Sports And Fitness'
			WHEN cleaned_product_category = 'Books' THEN 'Books And Stationery'
			ELSE cleaned_product_category
		END AS product_category,
		REPLACE(REPLACE(REPLACE(REPLACE(INITCAP(TRIM(city)),'PortHarcourt','Port Harcourt'),'Port-Harcourt','Port Harcourt'),
		'Lago S','Lagos'),'Portharcourt','Port Harcourt') AS city,
		state,
		account_status
	FROM (
		SELECT
			*,
			INITCAP(REPLACE(REPLACE(REPLACE(INITCAP(TRIM(product_category)), '&','and')
			,'Electronis','Electronics'),'Fashon','Fashion')) AS cleaned_product_category
		FROM sellers
	)
);

-- Products
CREATE OR REPLACE VIEW cleaned_products AS(
	SELECT
		product_id,
		product_name,
		CASE
			WHEN cleaned_product_category = 'Beauty' THEN 'Beauty And Personal Care'
			WHEN cleaned_product_category = 'Food' THEN 'Food And Beverages'
			WHEN cleaned_product_category = 'Sports' THEN 'Sports And Fitness'
			WHEN cleaned_product_category = 'Books' THEN 'Books And Stationery'
			ELSE cleaned_product_category
		END AS category,
		CASE
			WHEN unit_price IS NULL AND product_id = 'PROD0088' THEN 18000.00
			WHEN unit_price IS NULL AND product_id = 'PROD0104' THEN 33000.00
			WHEN unit_price IS NULL AND product_id = 'PROD0205' THEN 8500.00
			WHEN unit_price IS NULL AND product_id = 'PROD0245' THEN 4000.00
			ELSE unit_price
		END AS unit_price,
		seller_id
	FROM (
		SELECT
			*,
			INITCAP(REPLACE(REPLACE(REPLACE(INITCAP(TRIM(category)), '&','and')
			,'Electronis','Electronics'),'Fashon','Fashion')) AS cleaned_product_category
		FROM products
	)
);

-- Reviews
CREATE OR REPLACE VIEW cleaned_reviews AS(
	SELECT 
		review_id,
		product_id,
		customer_id,
		order_id,
		CASE
			WHEN rating = 0 OR rating < 0 THEN 1
			WHEN rating > 5 THEN 5
			ELSE rating
		END AS rating,
		review_date
	FROM reviews
);

-- Order_Items
CREATE OR REPLACE VIEW cleaned_order_items AS(
	SELECT
		o.item_id,
		o.order_id,
		o.product_id,
		o.quantity,
		p.unit_price,
		o.quantity * p.unit_price AS total_amount
	FROM cleaned_products p
	JOIN order_items o
	ON p.product_id = o.product_id
);

-- Orders

CREATE OR REPLACE VIEW cleaned_orders AS(
	SELECT
		o.order_id,
		o.customer_id,
		o.seller_id,
		o.order_date,
		o.delivery_date,
		o.order_status,
		t.total_amount
	FROM(
		SELECT
			order_id,
			SUM(total_amount) AS total_amount
		FROM cleaned_order_items
		GROUP BY order_id
		)t
	JOIN orders o
	ON t.order_id = o.order_id
	ORDER BY order_id ASC
);


	
