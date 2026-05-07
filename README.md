# TradeZone_E-commerce_Analysis
---

## Table of Contents
1. [Project Overview](#project-overview)
2. [About Dataset](#about-dataset)
3. [Project Objectives](#project-objectives)
4. [Data Profiling](#data-profiling)
5. [Data Cleaning Process](#data-cleaning-process)
6. [Analysis](#analysis)
7. [Findings](#findings)
8. [Recommendations](#recommendations)
9. [Limitations](#limitations)
10. [Conclusion](#conclusion)

## Project Overview
This project is a typical end-to-end data analytics project on the dataset of a hypothetical e-commerce called TradeZone covering:
- Data Profiling - a rigorous examination of the entire dataset to identify cases of bad quality data
- Data Cleaning - a process that transfroms substandard data to quality data for accurate analysis
- Data Analysis - the stage that involved drawing insights from data to make actionable recommendations
- Data Visualisation (In progress) - the final stage to create a dashboard and visualize insights for easy understanding of    analyses and findings

**Business Goal**: To gain insights about customer behaviors, sellers efficiency and product productivity and to help Head of Products and Head of Sales drive strategic plans and decsion making for 2025 business year. 

**Tools Used**
- PostgreSQL - data cleaning and analysis
- Tableau (In progress) - Visualization

---
## About Dataset
The dataset is an hypothetical dataset that replicates a typical E-commerce business organisation. It is a relational database containing 7 tables such as customer, sellers, products, orders items, orders, payments and reviews. The dataset contains approximately 11,500 rows and 45 columns across all tables

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

**Source**

HNG Internship

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
1. How effective is TradeZone at converting newly acquired customers in 2024 into first-time buyers within 30 days of signup , and does this differ across Nigerian states?
2. How effective is TradeZone at retaining customers who made their first purchase within 30 days of signup in 2024, and does this differ across Nigerian states?
3. Which products are the strongest contributors to TradeZone's revenue in 2024, and what does this reveal about how revenue is distributed across product categories?
4. What is the relationship between how fast sellers fulfil orders and the ratings they receive from customers?

---

## Data Profiling
Before any cleaning or analysis was performed, all 7 tales were examined to understand its structure, completeness and quality. Below is a summary of finidngs across multiples tables:

### Missing Values
|Table      |Columns|Rows   |
|-----------|-------|-------|            
|order_items|unit_price   | 97      |
|order_items|line_total  | 97      |
|orders     |delivery_date  | 1510     |
|orders   |total_amount  | 150     |
|payment   |amount   | 155     |
|products    |unit_price   | 4     |

**Observation:** The missing unit price and total amount across order_items, orders and payments are connected to missing unit price values in products. Also, the missing delivery date are orders that hadn't been recorded as completed.

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

**Observation:** The city column contains 23 variations of the same 5 values as a result of typos, inconsitent cases and unwanted spacings among others.  

#### Category Columns - products table
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

**Observation:** The product column contains 28 variations of the same 7 values due to occurences of typos, inconsitent cases and unwanted spacings among others.  

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


**Observation:** These products were identifed as outliers which could distort accurate finding during analysis.

### Additional Infromation
Based on other investigations such duplicates checks, data type check, and format and pattern consistency check, there were no anomalies detected. 

#### Full profiling queries available here 
> 📄 [data_profiling.sql](./scripts/data_profiling.sql)

---

## Data Cleaning Process

After profiling the data, it made it easier to clean data to ensure quality and conisistency for accurate analysis. Like profiling, this process follows a structured approach. All tables were cleaned into a VIEW rather than creating another table to preverse the original data and encourage flexibility. Each VIEW was created with CREATE OR REPLACE VIEW and named as cleaned_prefix, for example cleaned_sellers and cleaned_orders.

### Step 1: Standardize Text Columns

**Tables affected:** customers, sellers, products

**Issues Found:** Text columns across multiple tables contained inconsistent values, typos, inconsistent casing, and abbreviations.
Specific cases have been explained in data profling section above in city columns of customers and sellers table amd category column of products tables

**Decision:** INITCAP, TRIM, CASE, Nested REPLACE functions to standardize all text values. CASE WHEN was used to expand abbreviations into full reabable values

**Result:** All text columns standardized across affected tables

### Step 2: Standardize NumericaL Columns

**Tables affected:** reviews

**Issues Found:** Inconsistent rating number such as 0,-1, and 7 were idetified in the rating column.

**Decision:** Used CASE WHEN to convert non-excepted rating number to their nearest possible number rating. 0,-1 to 1 and 7 to 5

**Reason:** To ensure that ratings is consitent with expected range of 1-5, while ensuring no loss of data.

**Result:** The rating column in the review table now contain rating within the range of 1-5

### Step 3: Handle Missing Values

**Tables affected:** products, orders, order_items, payments

**Issues Found:** missing unit prices values in products and order_items table, mising total amoount values in order_items payment, and orders tables and missing delivery date values in the orders table

**Decision:** After close observation, missing unit prices values in product table was connected to the missing unit prices and total amount in multiple tables. With the help of browser and AI, an approximate average price was selected to replace the missing values. Once mising values of products were sorted, JOIN was used reflect unit_price of cleaned_products to solve mising values in order and order_items. However, total_amount of payment table was left untouched. For the missing delivery data, no action was made. 

**Reason:** The decision to replace unit_price with estimated average values gotten from the internet mirrors a real-world situation whereby a data analyst is expected to trace the seller_id and get information about the unit price. For inaction in payment table, observation identified that some amount not recorded were not connected to missing price, and this could signify audit to uncover suspicious activities. While for the missing delivery date values, the missing values simply reflects orders that hasn't been completed yet. 

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

## Analysis

Following data cleaning, analyses were made to answer our research questions and approve or refute our hypothesis.

### Key Metrics

**Total Customers:** N1,030,610,090.90
**Total Orders:** 3015
**Total Revenue:** 341827.56
**Average Order Value:** N341,827.56

### Research Question 1
How effective is TradeZone at converting newly acquired customers in 2024 into first-time buyers within 30 days of signup , and how does this differ across Nigerian states?

**Metric:** Customer Acquisition and 30 days Conversion

```sql
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
```

**Result**

|State|total_new_signup|bought_within_30days|percentage|
|----|-----|----|------|
|Lagos|	146|	72|	49.00|
|FCT|	92|	38	|41.00|
|Rivers|	66|	28|	42.00|
|Oyo|	63|	21	|33.00|
|Kano|	58|	18|	31.00|

### Research Question 2
How effective is TradeZone at retaining customers who made their first purchase within 30 days of signup in 2024, and how does this differ across Nigerian states?
 
**Metric:** Early Customer Cohort Retention

```sql
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
```

**Result**

|State|total_converters|total_retainers|percentage|
|----|-----|----|------|
|Rivers|	28|	23|	82.14|
|Oyo|	21|	17	|80.95|
|Lagos|	72|	58|	80.56|
|FCT|	38|	26	|68.42|
|Kano|	18|	12|	66.67|

### Research Question 3
Which products are the strongest contributors to TradeZone's revenue in 2024, and what does this reveal about how revenue is distributed across product categories?

**Metric:** Top 10 Products by Revenue 
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

**Sub-question 1a:** What percentage does Electronics category contribute to TradeZone overall revenue?

**Metric:** Revenue Proportion by Category 

```sql
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
```
**Result**

|category|total_revenue|overall_total_revenue|revenue_percentage_share|
|----|-----|----|------|
|Beauty And Personal Care|	29838759.52|	874927799.27|	3.41
|Books And Stationery|	12864140.73|	874927799.27|	1.47
|Electronics|	477299023.33|	874927799.27|	54.55
|Fashion|	52867338.87|	874927799.27|	6.04
|Food And Beverages|	16400200.04|	874927799.27|	1.87
|Home And Garden|	165914747.03|	874927799.27|	18.96
|Sports And Fitness|	119743589.75|	874927799.27|	13.69

**Sub-question 1b:** Is Electronics high revenue supported by the volume of orders?

**Metric:** Order Distribution by Category 

```sql
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
```

**Result**

|category|number_of_orders|percentile|
|----|-----|----|
|Beauty And Personal Care|	765|	0.14285714285714285
|Food And Beverages|	767|	0.2857142857142857
|Sports And Fitness|	769|	0.42857142857142855
|Home And Garden|	770|	0.5714285714285714
|Electronics|	773|	0.7142857142857143
|Fashion|	775|	0.8571428571428571
|Books And Stationery|	776|	1

**Comment:** Findings show Electronics category dominated top revenue generating products, therefore two sub-analysis were made to understand the effect on TradeZone business. See [Findings](#findings) for more understanding

### Research Question 4
What is the relationship between how fast sellers fulfil orders and the ratings they receive from customers?

**Metric:** Sellers Fulfillment Efficiency

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

#### Full analysis queries available here 
> 📄 [data_analysis.sql](./scripts/data_analysis.sql)

---

## Findings

### Research Question 1
Findings shows that 30 days conversion rate for all 5 states is significantly low - below 50% for each states. This shows that TradeZone struggles to convert its new users as early as possible. This program could be as a result of sereval reasons such as **low perceived business credibility**, **difficulity in usablity of the website**, **low representation of ideal users for the business**, and **requirement to nudge the customer to purchase a product**.
   
### Research Question 2
This analysis moves previous finidings further as it shows us that among these early purchasing customers across 5 states, a high proportion are retained as they make a second order in the next 90 days. Rivers, Oyo and Lagos has the highest rate over 80% and FCT and Kano fell behind with 68.42% and 66.67% respectivity. This is a positive outcome overall, however there is concern with the high margin difference between 3rd and 4th on the list. This analysis can help us narrow our selected issues to three, it removes the possibility of low representation of ideal user for the business. However futher analysis can be conducted to be valid.

### Research Question 3
1. Finding shows that the leading product is the HP Pavilion 15 Laptop at N26.7 million from just 25 orders and at the bottom of the top 10 is Anker PowerBank at N17.7 milion from 19 orders. However, analysis indicates that top-selling products are concentrated on only Electronics products due to high price value. This could mean two things for our business a) our revenue relies heavily on electronic which creates a problem of dependence. b) Electronics is simply a revenue anchor but other products contribute significantly to the revenue. To approve or refute either hypothesis, a sub analysis was made which was revenue proportion test to understand the level of dependence or independence of our revenue on electronic category and order distribution spread to determine whether high revenue of electronics is supported by volume.
2. The revenue proportion by category indicates that approximately 55% of TradeZone E-commerce is generated by Electronic category while the remaining 6 catgories contributes approxiamtely 45% to the revenue. Electronics in 70th percentaile in the order distribution spread adds that high electronic revenues is also supported by volume of orders in addition to its price value. These results shows that electronic significantly impact on the business' total revenue. While this can be good, it shows our business relies heavily on elecronics sales and this places the business on risk- any market price crash on electronics could affect the overall business revenue negatively.

### Research Question 4
The metrics shows that there is no close relationship between fulfillment time and customer rating. For example, RunFast NG has lowest fulfilment day but has a low customer rating at 3.25 and SportsCentral NG has a long fulfiment time of 4.10 but high average customer rating of 4.08. Accordingly, AgriMartNG and FashionHub NG has the same average fulfillment day of 4.52 but very opposite average customer rating of 2.50 and 3.55 respectively. This shows that multiple factors other than fulfillment time contribute to rating inefficiency. These factors could be packaging standard, product quality or value for money.

---

## Recommendations

1. There is yet to be a conclusion on the certain issue hindering early customer conversions due to lack of data and information. For example, we could have understood if we attract the right customers for each products if we had customer ages and then conduct an analysis to approve or refute this issue accordingly. While data limitation prevents a definitive conclusion, the retention analysis allows us to narrow the probable causes to three. Each carries a different cost of investigation and the following approach is recommeded. To nudge new users, you will most likely need an incentive like new bonus discount or promotion sales like a black friday once in a month for a limited period. If something similar already exist, it futher narrows our issue to two - low business credibility or difficult website usability. Issue of Website usability can be looked at with a very small group of people even employees. Since our rating isn't up to highest standard and this is something that affect trust, we could focus on improving our rating for a long term and on a short term, display something that tells a postive story that would improve engagement - something like a testimonies of good delivery or system improvement.
2. Although customer retention is high across all states, FCT and Kano seems to fall behind with a huge margin against the top 3 states (Rivers, Oyo and Lagos). This is worth paying attention to. We should look at what strategy is faciliting retention in the top states and adopt it to FCT and Kano. However it is important to accommodate the context of the market share in both states.
3. This is perphas the most important segment the company must address crtically. Based on the sub-hypotheses, findings shows that our revenue is reliant on one category- electronics. I would advice we diversify our revenue across multiple products especially if we want inclusive and sustainable growth. For a start, we should improve marketing on 3-4 products with high numbers of orders, as well as, incentive that could attract much sales to the others while still maintaining electronics revenue generation. Home and Garden has the second highest revenue and 4th highest number of orders. This makes the category the most immediate product that should be looked into in the diversification process.
4. Since it is clear that fulfillment time does not single-handedly determine customer rating. Other factors such as state of packaging standard, quality of products, and value for money could be looked it. For the long term, TradeZone could adopt a centralised delivery system whereby it handles the delivery of orders. It would manage delivery from packaging and transportation to customer communication during the process. However this system may be costly to build, it would ensure that TradeZone has control over sitaution concerning delivery and at such, improve overall rating. If there were a data on rating comments or complaint, we could have identified the particualr issue to pay attention on. On a short term, we can include a review box to welcome comments after rating to understand our customer opinions about their orders. Additionaly, accountability and transparency is improtant for rating. Before products appear on website, they should first be scrutinized by TradeZone and when they appear on website, users should know the conditions that their products come with. Also, customers with valid review complaint could be reached out to and compensated with a discount coupon - this could significantly impact on ratings.  

---

## Limitations

1. Several data and information that would have helped in a more complete analysis were unavailable. For example, customer age that would have narrowed our issues effectively in customer conversion problem was unavailable. Likewise, review comments could have helpful to identify the key issues that were affecting our customer ratings.
2. Data is hypothetical and this limited a more contextual based analysis. For a business as TradeZone E-Commerce, several contextual situations could play out that must considered before analysis and most importantly recommendation. 
3. Upon careful observation during the data profiling stage, it was discovered that majority of sellers name didn't correspond to the products they sell. This could distort finding that had to do with sellers but since the data is hypothetical, I had to work with it regardlessly.

--- 

## Conclusion
The purpose of this analysis was to gain insights into three key aspects of TradeZone's business performance in 2024: Customer conversion and retention, Product revenue contribution, and Seller fulfilment efficiency. In each of the three zones the results indicate a real strength in business, but significant structural issues that need to be resolved to enable sustainable development. TradeZone has seen a consistent inability to turn newly signed up users into first-time buyers within 30 days of signing up, with conversion rates in all 5 states remaining below 50%. But, with the retention rates being high in Rivers, Oyo and Lagos, the right customers are being reached. The issue isn't who is signing up, it's what's happening from sign up to purchase. Addressing this disconnect via trust building, usability enhancements, and specific conversion incentives is one of the quickest avenues the business has to do so.

The analysis shows a high concentration risk on the product/revenue side. Electronics makes up about 55% of total revenue in 2024 and leads revenue and order volume by being at the 70th percentile of order distribution for all categories. The top 10 revenue-generating products are all in the Electronics category, with the remaining 6 categories contributing less than the top segment. The second highest revenue category is Home and Garden which is the most realistic for revenue diversification as a starting point. The fulfilment analysis further confirms that speed of delivery is not enough to guarantee customer satisfaction, adding an extra level of difficulty. The lack of correlation between fulfilment speed and customer ratings indicates that other factors like product quality, packaging standards, and the value for money, are as important and possibly more of determining the customers' perception on the platform.

These results collectively suggest a business that is strategically focused and operationally functional. To achieve inclusive and sustainable revenue growth, TradeZone will need to make conscious and careful investments in conversion optimisation, category diversification and a seller quality system that will not just focus on speed, but the whole customer experience. The approach that will be taken in responding to these challenges will be structured and prioritized to enhance TradeZone's strengths and mitigate those vulnerabilities created by the existing revenue structure.




























