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
	SELECT
		c.customer_id,
		c.state,
		c.signup_date,
		MIN(o.order_date) AS first_purchase
	FROM cleaned_customers c
	LEFT JOIN cleaned_orders o
		ON c.customer_id = o.customer_id
		AND o.order_date <= c.signup_date + INTERVAL '30 days'
	WHERE EXTRACT(YEAR FROM c.signup_date) = 2024
	GROUP BY c.customer_id, c.state, c.signup_date
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
	SELECT
		c.customer_id,
		c.state,
		c.signup_date,
		MIN(o.order_date) AS first_purchase
	FROM cleaned_customers c
	LEFT JOIN cleaned_orders o
		ON c.customer_id = o.customer_id
	WHERE EXTRACT(YEAR FROM c.signup_date) = 2024
	AND o.order_date <= c.signup_date + INTERVAL '30 days'
	GROUP BY c.customer_id, c.state, c.signup_date
),
retainers AS(
	SELECT
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
SECTION 4a:  Revenue Proportion by Category
=====================================================================================================================
Purpose: To determine the percetage electronics category contribute to the business
=====================================================================================================================
*/
SELECT
	*,
	SUM(total_revenue) OVER() AS overall_total_revenue,
	ROUND((total_revenue * 100) / SUM(total_revenue) OVER(),2) AS revenue_percentage_share
FROM(
	SELECT
		p.category,
		SUM(t.total_amount) AS total_revenue
	FROM cleaned_products p
	LEFT JOIN cleaned_order_items t
		ON p.product_id = t.product_id
	JOIN orders o
		ON t.order_id = o.order_id
	WHERE EXTRACT (YEAR FROM o.order_date) = 2024
	GROUP BY p.category
);

/*
=====================================================================================================================
SECTION 4b: Order Distribution by Category
=====================================================================================================================
Purpose: To determine whether Electronics high revenue is supported by volume of orders. 
=====================================================================================================================
*/
SELECT
	*,
	CUME_DIST() OVER(ORDER BY number_of_orders) AS percentile
FROM(
	SELECT
		p.category,
		COUNT(t.order_id) AS number_of_orders
	FROM cleaned_products p
	LEFT JOIN cleaned_order_items t
		ON p.product_id = t.product_id
	JOIN cleaned_orders o
		ON t.order_id = o.order_id
	WHERE EXTRACT (YEAR FROM o.order_date) = 2024
	GROUP BY p.category
);

/*
=====================================================================================================================
SECTION 5: Seller Fulfillment Efficiency
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
