/* 
=====================================================================================================================
PROJECT     : TradeZone E-Commerce Analysis
AUTHOR      : Olamilekan Adesoye
DATE      	: 2024
DATABASE    : PostgreSQL
=====================================================================================================================
-- DATA ANALYSIS
=====================================================================================================================
*Purpose: To analyse data and generate insights that would guide business decision making and planning for year 2025
=====================================================================================================================
*/

/*
=====================================================================================================================
SECTION 1: Key Metrics
=====================================================================================================================
Task: Caculate total customers, total orders, total revenue and average order value
=====================================================================================================================
*/
SELECT
    COUNT(DISTINCT c.customer_id) AS Total_Customers,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(o.total_amount) AS Total_Revenue,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT o.order_id), 2) AS Average_Order_Value
FROM cleaned_customers c
LEFT JOIN cleaned_orders o 
    ON c.customer_id = o.customer_id;

/*
=====================================================================================================================
SECTION 2: Customer Acquisition & 30-Day Coversion
=====================================================================================================================
Purpose: To measure how effectively the company attracts new customers and the proportion of these users that make
		an order within 30 days.
Task: Find the top 5 states by number of new customer sign-ups in 2024. For each state, calculate what percentage 
	  of these new customers made at least one purchase within their first 30 days of signing up.
=====================================================================================================================
*/
SELECT
	state,
	COUNT(customer_id) AS total_new_signups,
	COUNT(first_purchase) AS bought_within_30_days,
	ROUND(COUNT(first_purchase) * 100 / COUNT(customer_id),2) AS percentage
FROM(
	SELECT DISTINCT ON (c.customer_id)
		c.customer_id,
		c.state,
		o.order_id,
		c.signup_date,
		MIN(o.order_date) OVER(PARTITION BY c.customer_id) AS first_purchase
	FROM cleaned_customers c
	LEFT JOIN cleaned_orders o
		ON c.customer_id = o.customer_id
		AND o.order_date <= c.signup_date + INTERVAL '30 days'
	WHERE EXTRACT(YEAR FROM c.signup_date) = 2024
)
GROUP BY state
ORDER BY total_new_signups DESC;

/*
=====================================================================================================================
SECTION 3: Early Cohort Rentention Rate
=====================================================================================================================
Purpose: To understand how the company performs in retenting customers that purchased within 30 days of conversion
Task: For customers who made a purchase within their first 30 days, what percentage come back to make a 
	  second purchase within 90 days
=====================================================================================================================
*/
WITH converters AS(
	SELECT DISTINCT ON (c.customer_id)
		c.customer_id,
		c.state,
		o.order_id,
		c.signup_date,
		MIN(o.order_date) OVER(PARTITION BY c.customer_id) AS first_purchase
	FROM cleaned_customers c
	LEFT JOIN cleaned_orders o
		ON c.customer_id = o.customer_id
	WHERE EXTRACT(YEAR FROM c.signup_date) = 2024
	AND o.order_date <= c.signup_date + INTERVAL '30 days'
),
retainers AS(
	SELECT DISTINCT ON (e.customer_id)
		e.*
	FROM converters e
	WHERE EXISTS(
		SELECT 1
		FROM cleaned_orders o
		WHERE o.customer_id = e.customer_id
		AND order_date > first_purchase
		AND o.order_date < e.signup_date + INTERVAL '90 days'
))
SELECT
	c.state,
	COUNT(DISTINCT c.customer_id) AS total_converters,
	COUNT(DISTINCT r.customer_id) AS total_retainers,
	ROUND((COUNT(DISTINCT r.customer_id) * 100) / COUNT(DISTINCT c.customer_id):: numeric,2) AS retention_rate_pct
FROM converters c
LEFT JOIN retainers r 
	ON c.customer_id = r.customer_id
GROUP BY c.state
ORDER BY retention_rate_pct DESC

/*
=====================================================================================================================
SECTION 4: Product Performance
=====================================================================================================================
Purpose: To determine products that produce more revenue in 2024. 
Task: Identify the top 10 products by total revenue in 2024, including product name, category, total revenue 
	  and total number of orders. Sort by revenue descending
=====================================================================================================================
*/
SELECT
	p.product_name,
	p.category,
	SUM(t.total_amount) AS total_revenue,
	COUNT(t.order_id) AS total_number_of_orders
FROM cleaned_products p
JOIN cleaned_order_items t
	ON p.product_id = t.product_id
JOIN cleaned_orders o
	ON t.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY p.product_name,p.category
ORDER BY total_revenue DESC
LIMIT 10;

/*
=====================================================================================================================
SECTION 5:Review Rating and Sales Performance
=====================================================================================================================
Purpose: To assess whether product quality, as reflected in customer ratings, correlates with revenue performance — 
		 identifying whether low-rated products are undermining sustainable revenue growth.
Task: Group products based on their average review rating into three categories: High rated, Mid and, Low rate.
	  For each category, calculate the product count and total revenue
=====================================================================================================================
*/
SELECT
	v.avg_rating_segment,
	COUNT(DISTINCT v.product_id) AS product_count,
	SUM(t.total_amount) AS total_revenue
FROM(
	SELECT
		product_id,
		ROUND(AVG(rating),2) AS avg_review_rating,
		CASE
			WHEN ROUND(AVG(rating),2) >= 4.00 THEN 'High Rated'
			WHEN ROUND(AVG(rating),2) BETWEEN 3.0 AND 3.99 THEN 'Mid Rated'
			WHEN ROUND(AVG(rating),2) < 3.00 THEN 'Low Rated'
		END AS avg_rating_segment
	FROM cleaned_reviews
	GROUP BY product_id
) v
LEFT JOIN cleaned_order_items t
ON v.product_id = t.product_id
GROUP BY avg_rating_segment;

/*
=====================================================================================================================
SECTION 6: Seller Fulfillment Efficiency
=====================================================================================================================
Purpose: To evaluate whether the level of seller fulfilment efficiency impact customer ratings. 
Task: Calculate the average day between order placement and delivery for each seller. Return the top 20 sellers 
	  with the fastest average fullfilment times among seller who have completed at least 20 order. Include
	  their average customer rating.
=====================================================================================================================
*/
SELECT
	s.seller_name,
	ROUND(AVG(o.delivery_date - o.order_date),2) AS average_fulfilment_day,
	ROUND(AVG(r.rating),2) AS average_customer_rating
FROM cleaned_sellers s
LEFT JOIN cleaned_orders o
	ON s.seller_id = o.seller_id
LEFT JOIN cleaned_reviews r
	ON o.order_id = r.order_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_name
HAVING COUNT(o.order_id) >= 20
ORDER BY average_fulfilment_day ASC
LIMIT 20;

/*
=====================================================================================================================
SECTION 7: Top Seller Bonus Qualification
=====================================================================================================================
Purpose: To reward high-performing sellers who demonstrate both commercial output and customer satisfaction, 
		 reinforcing quality-driven seller behaviour on the platform.
Task: Identify the top 10 sellers in 2024 by total revenue who completed at least 10 orders and have an 
average customer rating of 4.0 or above. Include their total orders, average rating, and total revenue.
=====================================================================================================================
*/
-- Identify the top 10 sellers in 2024 by total revenue who completed at least 10 orders and have an average customer
-- rating of 4.0 or above. Include their average rating, and total revenue. 
SELECT 
	s.seller_name,
	ROUND(AVG(r.rating),2) AS average_rating,
	SUM(o.total_amount) AS total_revenue
FROM cleaned_sellers s
LEFT JOIN cleaned_orders o
	ON s.seller_id = o.seller_id
LEFT JOIN cleaned_reviews r
	ON r.order_id =o.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2024
GROUP BY s.seller_id,s.seller_name
HAVING COUNT(o.order_id) >= 10
	AND AVG(r.rating) >= 4.00
ORDER BY total_revenue DESC
LIMIT 10;


/*
=====================================================================================================================
SECTION 8:Customer Spend Segmentation
=====================================================================================================================
Purpose: To analyse the distribution and revenue contribution of customers across different categories
Task: Segemnt cusomers based on their total spend in 2024 into three groups: High spenders, Medium and Low Spenders. 
	  For each group, calculate the customer count, average spend per customer and total revenue contribution
=====================================================================================================================
*/
SELECT
	customer_segment,
	COUNT(customer_id) AS customer_count,
	ROUND(AVG(total_spend),2) AS average_spend,
	SUM(total_spend) AS revenue_contribution
FROM(
	SELECT
		customer_id,
		SUM(total_amount) AS total_spend,
		CASE
			WHEN SUM(total_amount) >= 100000 THEN 'High Spenders'
			WHEN SUM(total_amount) BETWEEN 50000 AND 99999 THEN 'Medium Spenders'
			WHEN SUM(total_amount) < 50000 THEN 'Low Spenders'
		END AS customer_segment
	FROM cleaned_orders
	WHERE EXTRACT(YEAR FROM order_date) = 2024
	GROUP BY customer_id
)
GROUP BY customer_segment;




