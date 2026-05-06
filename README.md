# TradeZone_Business_Analytics

---

## Table of Contents
1. [Project Overview](##project-overview)
2. [Tools Used](#tools-used)
3. [About Dataset](##about-dataset)
4. [Data Profiling Summary](#data-profiling-summary)
5. [Data Cleaning Process](#data-cleaning-process)
6. [Analysis & Findings](#analysis--findings)
7. [Recommendations](#recommendations)
8. [Limitations](#limitations)
9. [Conclusion](#conclusion)

## Project Overview
This project is a typical end-to-end data analytics project on an hypothetical e-commerce dataset covering:
- Data Profiling - a rigorous examination of the tables in the dataset to identify cases of bad quality data
- Data Cleaning - a process that transfroms substandard data to quality data for accurate analysis
- Data Analysis - the stage that involved drawing insights from data to make actionable recommendations
- Data Visualisation (In progress) - the final stage to create a dashboard and visualize insights for easy understanding of    analyses and findings

**Business Goal**: To gain insights about customer behaviors, sellers efficiecy and product productivity and help Head of Products and Head of Sales drive strategic plans and decsion making for 2025 business year. 

**Tools Used**
- PostgreSQL - data cleaning and analysis
- Tableau (In progress) - Visualization

---
## About Dataset
The dataset is an hypothetical dataset created by organisers of HNG internship. It is a relational database containing 7 tables such as customer, sellers, products, orders items, orders, payments and reviews. The dataset contains approximately 11,500 rows and 45 columns across all tables

|Table      |Rows  |Columns |Description                                              |
|-----------|------|------- |-------------------------------------------              |
|customers  |865   | 8      |Customer profile and information                         |
|order_items|6426  | 6      |Information about specific items purchased in each orders|
|orders     |3015  | 7      |Information concerning orders                            |
|payments   |2162  | 5      |Payment details and methods                              |
|products   |280   | 5      |Records of Product details                               |
|reviews    |817   | 6      |Information about ratings of products                    |
|sellers    |90    | 8      |Seller profile and information                           |

**Time Period**

The data contain business information of 2023 and 2024

**Schema**
```
customers
├── customer_id (PK)
├── first_name
├── last_name
├── email
├── city
├── state
├── signup_date
└── account_status

order_items
├── item_id (PK)
├── order_id (FK → orders)
├── product_id (FK → products)
├── quantity
├── unit_price
└── line_total

orders
├── order_id (PK)
├── customer_id (FK → customers)
├── seller_id (FK → sellers)
├── order_date
├── delivery_date
├── order_status
└── total_amount

payments
├── payment_id (PK)
├── order_id (FK → orders)
├── payment_method
├── amount
└── payment_date

products
├── product_id (PK)
├── product_name
├── category
├── unit_price
└── seller_id (FK → sellers)

reviews
├── review_id (PK)
├── product_id (FK → products)
├── customer_id (FK → customers)
├── order_id
├── rating
└── review date

sellers
├── sellers_id (PK)
├── seller_name
├── onboarding_date
├── product_category
├── city
├── state
└── account_status

```

--- 

## Project Objectives

**Problem Statement**

Despite growth, TradeZone e-commerce company is challenged with operational problems such as declining customer retention, unproductive sellers and underperforming products, thereby limiting sustainable revene growth. 

**Research Questions**
1. To what extent does early purchase behavior among new customers predict long-term retention, and how does this vary across state?
2. Which products are driving sustainable reveune and does high sales volume correlate with high customer ratings?
3. Do the fastest-filling sellers alos maintain the highest customer ratings, and what does this relationship reveal about the seller-side drivers of revenue underperformace?

---

## Data Profiling
Before any cleaning or analysis was performed, all 7 tales were examined to understand its structure, completeness and quality. Below is a summary of finidngs across multiples tables

### Missing Values
|Table      |Columns|Rows   |
|-----------|------  |------- |            
|order_items|unit_price   | 97      |
|order_items|line_total  | 97      |
|orders     |delivery_date  | 1510     |
|orders   |total_amount  | 150     |
|payment   |amount   | 155     |
|products    |unit_price   | 4     |

**Observation:** The missing unit price and total amount arcoss order_items, orders and payments are connected to missing unit price values in products. Also, the missing delivery date are orders that hadn't been recorded as completed.

### Distinct Values Check

#### City Columns - customers table
|Values       |Count|
|-----------|------  |     
|port harcourt|	27 |
|Abuja|	45|
|Lago s|	54|
| Lagos|	52|
|Kano|	28|
|KANO|	37|
|PORT HARCOURT|	25|
|Abuja |	40|
|abuja |47|
|ABUJA| 49|
|Lagos |	50|
|PortHarcourt|	24|
|Port Harcourt|	27|
|Port-Harcourt|	27|
|kano|	31|
|lagos|	47|
|IBADAN|	41|
|ibadan|	26|
|Ibadan|	29|
|LAGOS| 39|
|Kano |	39|
|Lagos|	52|
|Ibadan|29|

**Observation:** The city column contains 23 variations of the same 5 values as a result of typos, inconsistent cases and unwanted spacings among others.  

#### product category Columns - customers table
|Values      |Count|
|-----------|------  |  
|Fashon|	4|
|Food & Beverages|	4|
|fashion|	2|
|Beauty & Personal Care|	3|
|home & garden|	2|
|Books and Stationery|	4|
|Sports & Fitness|	3|
|SPORTS|	4|
|beauty & personal care|	5|
|electronics|	5|
|books & stationery|	4|
|Fashion|	3|
|Sports and Fitness|	4|
|FOOD|	7|
|ELECTRONICS|	1|
|food & beverages|	3|
|Electronis|	2|
|Books & Stationery|	2|
|HOME & GARDEN|	3|
|FASHION|	4|
|Food and Beverages|	1|
|Home and Garden|	2|
|sports & fitness|	1|

**Observation:** The product column contains 28 variations of the same 7 values due to occurences of typos, inconsistent cases and unwanted spacings among others.  

#### City Columns - sellers table
|Values       |Count|
|-----------|------  |
|port harcourt|	2|
|Abuja|	5|
|Kano|	6|
| Lagos|	2|
|Lago s|	9|
|KANO|	3|
|Abuja |	4|
|PORT HARCOURT|	5|
|abuja|	7|
|ABUJA|	3|
|Lagos |	7|
|PortHarcourt|	5|
|Port-Harcourt|	3|
|kano|	2|
|lagos|	5|
|IBADAN|	2|
|ibadan|	4|
|Ibadan|	3|
|LAGOS|	2|
|Kano |	3|
|Lagos|	7|
|Ibadan |	1|

**Observation:** The city column contains 22 variations of the same 7 values as a result of typos, inconsistent cases and unwanted spacings among others. 

#### Rating Columns - reviews table
|Values       |Count|
|-----------|------  |
|7	|1    |
|1	|69|
|-1	|3|
|5	|248|
|2	|80|
|4	|257|
|0	|1|
|3	|158|

**Observation:** Rating is expected to be in a range of 1 and 5, however there are cases of values like 7,-1 and 0 which interprets as bad data. 

### Outliers Checks

#### Products table and unit_price column
|product_id       |product_name|unit_price| Z-scores
|-----------|--------|------  |-------|
|PROD0006|	JBL Bluetooth Speaker Portable|	308912.61|	3.11
|PROD0011|	Apple AirPods Pro 2nd Gen|	314229.61|	3.17
|PROD0013|	Hisense 32 inch LED TV|	337113.25|	3.45
|PROD0019|	Mechanical Keyboard RGB Backlit|	339524.65|	3.48
|PROD0024|	HP Pavilion 15 Laptop Intel i5 - v2|	321716.92|	3.26
|PROD0025|	Lenovo IdeaPad 3 Laptop 8GB RAM - v2|	330590.39|	3.37
|PROD0028|	TP-Link WiFi Router AC1200 - v2|	316366.34|	3.20


**Observation:** These products were identifies as outliers which could distort accurate finding during analysis.

### Additional Infromation
Based on other investigations such duplicates checks, data type check, and format and pattern consistency check, there were no anomalies detected. 

#### Full profiling queries available here 
> 📄 [data_profiling.sql](./scripts/data_profiling.sql)

---

## Data Cleaning Process

After profiling the data, it made it easier to clean data to ensure quality and conisistency for accurate analysis. Like profiling, this process follows a structured approach. All tables were cleaned into a VIEW rather than creating another table to preverse the original data and encorage flexibility. Each VIEW was created with CREATE OR REPLACE VIEW and named as cleaned_prefix, for example cleaned_sellers and cleaned_orders.

### Step 1: Standardize Text Columns

**Tables affected:** customers, sellers, products

**Issues Found:** Text columns across multiple tables contained inconsitent values, typos, inconsitent casing, and abbreviations.
Specific cases have been explained in data profling section above in city columns of customers and sellers table amd category column of products tables

**Decision:** INITCAP, TRIM, CASE, Nested REPLACE functions to standardize all text values. CASE WHEN was used to expand abbreviations into full reabable values

**Result:** All text columns standardized across affected tables

### Step 2: Standardize Numerica Columns

**Tables affected:** reviews
**Issues Found:** Inconsitent rating number such as 0,-1, and 7 were idetified in the rating column.

**Decision:** Used CASE WHEN to convert non-excepted rating number to their nearest possible number rating. 0,-1 to 1 and 7 to 5

**Reason:** To ensure that ratings is consistent with expected range of 1-5, while ensuring no loss of data.

**Result:** The rating column in the review table now contain rating within the range of 1-5

### Step 3: Handle Missing Values

**Tables affected:** products, orders, order_items, payments

**Issues Found:** missing unit prices values in products and order_items table, mising total amoount values in order_items payment, and orders tables and missing delivery date values in the orders table

**Decision:** After close observation, missing unit prices values in product table was connected in to the missing unit prices and total amount in other tables. With the help of browser and AI, an approximate average price was selected to replace the missing values. Once mising values of products were sorted, JOIN was used reflect unit_price of cleaned_products to solve mising values in order and order_items. However, total_amount of payment table was left untouched. For the missing delivery data, no action was made. 

**Reason:** The decision to replace unit_price with estimated average values gotten from the internet mirrors a real-world situation whereby in the same situation, a data analyst is expected to trace the seller_id and get information about the unit price. For inaction in payment table, through observation identified that some amount not recorded were not connected to missing price, and this could signify audit to uncover suspicious activities. While for the missing delivery date values, the missing values simply reflects orders that hasn't been completed yet. 

**Result:** The unit_price and amount column across multiple tables now contain values. In the VIEW, line total of order_items, and amount of orders table were renamed to total_amount.

### Step 4: Handling Outliers

**Tables affected:** products

**Issues Found:** Extreme values in the unit price column.

**Decision:** No action was made after careful observation.

**Reason:** Products price were checked in real life and it was discovered that prices fall within the range of price, therefore, it is accurate based on the context.

**Result:** The extreme values in unit_price column of the products table was left untouched. 

#### Full cleaning queries available here 
> 📄 [data_cleaning.sql](./scripts/data_cleaning.sql)

---

## Analysis and Findings

Following data cleaning, analyses were made to answer our research questions and approve or refute our hypothesis. To answer each reseach hypothetical questions, 2 business questions were looked into. 

### Research Question 1
To what extent does early purchase behavior among new customers predict long-term retention, and how does this vary across state?

**Sub-question 1:** In the year 2024, how did TradeZone E-commerce perform in converting new customer signups into purchasing customers in 30 days across all states. 

```sql
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
```

**Result**

|State|total_new_signup|bought_within_30days|percentage|
|----|-----|----|------|
|Lagos|	146|	72|	49.00|
|FCT|	92|	38	|41.00|
|Rivers|	66|	28|	42.00|
|Oyo|	63|	21	|33.00|
|Kano|	58|	18|	31.00|

**Sub-question 2:** In the year 2024, how did TradeZone E-commerce perform in retaining the 30 days converters across all states. 

```sql
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
```

**Result**

|State|total_converters|total_retainers|percentage|
|----|-----|----|------|
|Rivers|	28|	23|	82.14|
|Oyo|	21|	17	|80.95|
|Lagos|	72|	58|	80.56|
|FCT|	38|	26	|68.42|
|Kano|	18|	12|	66.67|

### Research Question 2
Which products are driving sustainable reveune and does high sales volume correlate with high customer ratings?

**Sub-question 1:** What are the top 10 revenue generating products in 2024?

```sql
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
```

**Result**

|products|category|total_revenue|total_number_of_orders|
|----|-----|----|------|
|HP Pavilion 15 Laptop Intel i5 - v2|	Electronics|	26702504.36|	25
|Mechanical Keyboard RGB Backlit	|Electronics|	25124824.10|	24
|TP-Link WiFi Router AC1200 - v2|Electronics|	23727475.50|	24
|Hisense 32 inch LED TV|Electronics|	23597927.50|	26
|Apple AirPods Pro 2nd Gen|Electronics|	21681843.09|	25
|JBL Bluetooth Speaker Portable|Electronics|	20388232.26|	22
|Kingston 256GB USB Flash Drive - v2	|Electronics|	19165030.56|	21
|Garmin Forerunner 255 Watch - v2	|Electronics|	18470211.35|	29
|Lenovo IdeaPad 3 Laptop 8GB RAM - v2	|Electronics|	18182471.45|	20
|Anker PowerBank 20000mAh USB-C	|Electronics|	17729180.30|	19


**Sub-question 2:** Does well rated products translate to high revenue?

```sql
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
```

**Result**

|rating_segment|product_count|total_revenue|
|----|-----|----|
|High Rated|	113|	351438299.51|
|Low Rated|	31|	125689450.22	|
|Mid Rated|	121|	501380399.31|

### Research Question 3
Do the fastest-filling sellers alos maintain the highest customer ratings, and what does this relationship reveal about the seller-side drivers of revenue underperformace?

**Sub-question 1:** Does the level of fullfillment time of each sellers impact their customer rating in the market

```sql
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
```

**Result**

|seller_name|average_fulfillment_day|average_customer_rating
|----|-----|----|
|RunFast NG|	3.80|	3.25
|SportNation NG|	3.86|	3.65
|SportsCentral NG|	4.10|	4.08
|GadgetPro NG|	4.16|	3.70
|TechPower NG|	4.40|	3.40
|AgriMart NG|	4.52|	2.50
|FashionHub NG|	4.52|	3.55
|TechHub Nigeria|	4.59|	4.13
|DigiTech NG|	4.60|3.67
|GadgetKing NG|	4.61|	1.79
|AllFashion NG|	4.70|	4.56
|OrganicLife NG|	4.86|	3.67
|PureSkin NG|	4.90	|3.38
|EarthHome NG|	4.90|	3.80
|GreenHome Stores|	4.95|	3.09
|TechStore NG|	4.95	|3.55
|StyleKraft NG|	5.04	|4.07
|WellnessHub NG|	5.08|	3.86
|VogueNG|	5.26	|4.18
|QuickTech NG|	5.38|	3.69


**Sub-question 2:** For consideration for a top seller bonus, who are the most productive sellers with a considerable high rating and have completed at least 10 orders 

```sql
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
```

**Result**

|seller_name|average_rating|total_revenue
|----|-----|----|
|SportsCentral NG|	4.08|	15053739.46
|GlowBeauty Shop|	4.29	|14470467.06
|GreenSpace NG|	4.50	|13934943.44
|HomeNest NG|	4.50	|13131469.72
|BeautyNation NG|	4.27|	13111651.24
|FitZone NG|	4.20	|12282326.09
|VogueNG|	4.22	|11929761.12
|HomeEssentials NG|	4.14|	11690992.11
|SkinGlow NG|	4.22|	11471932.44
|CozyHome NG|	4.00|	11193098.83

### Supporting Question
How does diverese customer groupings contribute to the revenue of the business in 2024?

```sql
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
```

**Result**

|customer_segment|customer_count|average_customer_spend|total_average|
|----|-----|----|----|
|High Spenders|	603|	1446150.38|	872028676.13
|Low Spenders|	47	|22796.30|	1071426.11
|Medium Spenders|	27	|67692.48|	1827697.03

#### Full analysis queries available here 
> 📄 [data_analysis.sql](./scripts/data_analysis.sql)
