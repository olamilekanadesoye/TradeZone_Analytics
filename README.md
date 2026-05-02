# TradeZone_Business_Analytics
---
## Project Overview
This project is a typical end-to-end data analytics project on an hypothetical e-commerce dataset covering:
- Data Profiling - a rigorous examination of the tables in the dataset to identify cases of bad quality data
- Data Cleaning - a process that transfroms substandard data to quality data for accurate analysis
- Data Analysis - the final stage that involved drawing insights from data to make actionable recommendations

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

# Project Objectives

**Problem**
Despite growth, TradeZone e-commerce company is challenged with operational problems such as declining customer retention, unproductive sellers and underperforming products, thereby limiting sustainable revene growth. 

**Research Questions**
1. To what extent does early purchase behavior among new customers predict long-term retention, and how does this vary across state?
2. Which products are driving sustainable reveune and does high sales volume correlate with high customer ratings?
3. Do the fastest-filling sellers alos maintain the highest customer ratings, and what does this relationship reveal about the seller-side drivers of revenue underperformace? 
