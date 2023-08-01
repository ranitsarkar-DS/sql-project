# Context:
Target is one of the world’s most recognized brands and one of America’s leading retailers.
Target makes itself a preferred shopping destination by offering outstanding value, inspiration,
innovation and an exceptional guest experience that no other retailer can deliver.
This business case has information of 100k orders from 2016 to 2018 made at Target in Brazil.
Its features allows viewing an order from multiple dimensions: from order status, price,
payment and freight performance to customer location, product attributes and finally reviews
written by customers.

The dataset is taken from kaggle : 
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce


Schema :

![HRhd2Y0](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/0a5b759f-8fda-42d6-99ef-c4c0c6827166)


## Table of Contents :

1. **[Initial Exploration of Dataset](#ini_exp)**
2. **[Exploring the Growing Trend of E-commerce in Brazil](#grw_trend)**
3. **[Evolution of E-commerce Orders in the Brazil Region: Unveiling State-wise Trends and Customer Distribution](#evol)**
4. **[The Impact on Economy: Analyzing Cost Trends and State-wise Price and Freight Values](#imp)**
5. **[Analyzing Sales, Freight, and Delivery Time: Insights from Brazil](#ana)**
6. **[Analyzing Payment Types: Insights on Orders and Payment Installments](#pay)**
7. **[Actionable Insights and Recommendations Based on the Analysis](#act)**
8. **[Conclusion](#con)**



# 1. Initial Exploration of Dataset <a id='ini_exp'></a>

Before diving into the analysis, we performed an initial exploration of Target’s e-commerce dataset. This involved examining the data, cleaning it, and preparing it for analysis. We verified the column data types in the “customers” table using the following SQL query in BigQuery:


SELECT
  column_name,
  data_type
FROM
  `target.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'customers';

By understanding the data types of each table, we ensure accurate analysis and interpretation of the dataset.

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/085db880-4f17-4b3d-b3d3-fabc5a1eb434)

To understand the time period covered by the dataset, we executed the following SQL query:

SELECT
  MIN(order_purchase_timestamp) AS first_order,
  MAX(order_purchase_timestamp) AS last_order
FROM
  `target.orders`;

  ![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/d8fb7c1d-04a7-4b5f-b25e-8dc4a197bf18)

This allowed us to determine the start and end dates of the data i.e. from 4th September 2016 to 17th October 2018, providing a context for our analysis.

Furthermore, we examined the cities and states of customers who placed orders during the specified time period. The following SQL query helped us identify the customer distribution:

SELECT
  DISTINCT c.customer_city,
  c.customer_state,
  COUNT(o.customer_id) order_count
FROM
  target.orders o
JOIN
  target.customers c
ON
  o.customer_id = c.customer_id
GROUP BY
  1, 2
ORDER BY
  3 DESC;

A sample of the output is shown :

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/3b813530-5026-4d4e-acc7-61dd58c9128a)

Here, we can see that sao paulo city from SP state alone has more orders than
the following 5 cities combined. This is because sao paulo is the most populous and richest
state in Brazil.


# 2. Exploring the Growing Trend of E-commerce in Brazil <a id='grw_trend'></a>

### Is there a growing trend on e-commerce in Brazil?

To determine the growing trend of e-commerce in Brazil, we examined the order count over time. Using SQL queries, we extracted the year and month from the order purchase timestamp and counted the distinct order IDs. The following query was executed:

SELECT
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  COUNT(DISTINCT o.order_id) AS order_count
FROM
  `target.orders` o
JOIN
  `target.customers` c
ON
  o.customer_id = c.customer_id
GROUP BY
  year, month
ORDER BY
  year, month;

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/1c43af5a-08e0-43a1-9f6c-296ba46087b8)
![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/32487452-c69e-46ec-ae7d-4cdc6ee9b272)

Based on the analysis of order count, it can be observed that there is a growing trend in e-commerce in Brazil. The count of purchases has shown an overall upward trend, with some fluctuations. However, it’s important to note that the order count alone does not indicate the pace of business growth. To gain a more accurate understanding, we should also consider revenue growth.

SELECT
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year, 
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
  ROUND(SUM(p.payment_value), 2) as revenue
FROM
  `target.orders` o
JOIN
  `target.order_payments` p ON
  o.order_id = p.order_id
GROUP BY
  year, month
ORDER BY
  year, month;


![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/aa5825f7-aa85-4344-8c23-482acd2b87b1)
![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/c6541949-321c-4791-8a0e-3c1638929583)

Here again, we can see a similar trend as above.

### How can we describe a complete scenario?

To paint a complete picture of the e-commerce scenario in Brazil, it is crucial to consider multiple factors that impact sales. These factors include customer demographics, the increase in the customer base, technological advancements, the number of sellers, ease of ordering, customer satisfaction, trust over time, return and exchange policies, payment options, delivery time, order cancellations, and overall economic conditions. A holistic analysis of these aspects would provide a more comprehensive understanding of the e-commerce landscape in Brazil.

### Can we see some seasonality with peaks at specific months?

Analyzing the dataset, we explored the presence of seasonality within specific months. By extracting the month from the order purchase timestamp, we calculated the count of distinct order IDs for each month. The following query was executed:

SELECT
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  COUNT(DISTINCT order_id) AS order_count
FROM
  `target.orders`
GROUP BY
  month
ORDER BY
  month;

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/f2fa0ba1-b3f2-4d6e-97e7-e7b6abd7650a)

Considering the limited dataset provided, it is challenging to draw definitive conclusions regarding seasonality trends. However, from the analysis, we can observe some seasonality in the e-commerce orders. The count of orders generally increases from March to August with fluctuations in between. Notably, there is an increase in orders during February and March, coinciding with the Carnival season in Brazil. Additionally, the month of August shows a peak in order count, potentially related to the Festival de Cachaça dedicated to the national liquor, cachaça. It is important to note that further analysis with a larger dataset would be required to validate these seasonality trends.


### Understanding Buying Patterns of Brazilian Customers

To gain insights into the buying patterns of Brazilian customers, we analyzed the time of day when most orders were placed. The following SQL query was executed to categorize the order purchase timestamps into four periods: dawn, morning, afternoon, and night.

SELECT
  CASE
    WHEN EXTRACT(HOUR FROM o.order_purchase_timestamp) BETWEEN 0 AND 5 THEN 'Dawn'
    WHEN EXTRACT(HOUR FROM o.order_purchase_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM o.order_purchase_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM o.order_purchase_timestamp) BETWEEN 18 AND 23 THEN 'Night'
  END AS hour,
  COUNT(o.order_id) AS order_count
FROM
  target.orders o
JOIN
  target.customers c
ON o.customer_id = c.customer_id
GROUP BY
  hour
ORDER BY
  order_count DESC;

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/744ec10b-01b4-4425-9163-1b2d3607f9dd)

Based on the analysis, we found that Brazilian customers tend to place most orders during the daytime, specifically in the afternoon and night. This indicates that customers prefer to shop online when they have leisure time or after completing their daily activities. It’s important to note that the assumption here is that the recorded timestamps reflect the correct time zone at the time of purchase.

Understanding the buying patterns of customers helps e-commerce businesses optimize their operations. By identifying peak buying times, companies can allocate resources, such as customer service representatives and inventory, more effectively to meet customer demands and provide a seamless shopping experience.

Analyzing the data in this manner provides valuable insights into the behavior and preferences of Brazilian customers. With this information, e-commerce companies like Target can tailor their marketing strategies and promotional campaigns to specific time periods, maximizing their reach and potential sales.

In conclusion, analyzing the buying patterns of Brazilian customers reveals the growing trend of e-commerce in the country, highlights the importance of considering various factors for a complete understanding of the e-commerce scenario, and sheds light on the preferred time periods for online shopping. Armed with these insights, Target and other e-commerce businesses can make data-driven decisions to enhance their operations and improve customer satisfaction.

# 3. Evolution of E-commerce Orders in the Brazil Region: Unveiling State-wise Trends and Customer Distribution <a id='evol'></a>

### Analyzing Month-on-Month Orders by States

To understand the evolution of e-commerce orders in the Brazil region, we analyzed the month-on-month order counts for each state. The following is the SQL query execution:

SELECT
  c.customer_state,
  EXTRACT(month FROM o.order_purchase_timestamp) AS month,
  COUNT(o.order_purchase_timestamp) AS order_count
FROM
  target.orders o
JOIN
  target.customers c
ON
  o.customer_id = c.customer_id
GROUP BY
  c.customer_state, month
ORDER BY
  c.customer_state, month;

Sample of the output is shown:

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/620743ce-0c24-4b6c-af25-1adbeda1d79e)

The analysis shows the month-on-month order counts in each state of Brazil, providing valuable insights into the customer purchase trends on a state-by-state basis. It is evident that São Paulo (SP) consistently has the highest number of orders in any given month, followed by Rio de Janeiro (RJ) and Minas Gerais (MG).

### Distribution of Customers Across Brazilian States

To further explore the e-commerce landscape in Brazil, we examined the distribution of customers across the states. The following SQL query was executed:

SELECT
  c.customer_state,
  COUNT(c.customer_id) AS no_of_customers
FROM
  `target.customers` c
GROUP BY
  c.customer_state
ORDER BY
  no_of_customers DESC;

![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/1909269b-6fad-404a-b18d-70cf40d0e4c6)
![image](https://github.com/ranitsarkar-DS/target-sql-case-study/assets/121813854/97a0f0dd-d0d5-42c0-aa85-d05da7e1f5c4)


The data reveals that the state of São Paulo (SP) has the highest number of customers, which can be attributed to its status as the most populous state in Brazil. This finding also aligns with the previous analysis, indicating a positive correlation between the population of a state and its order count.

Understanding the evolution of e-commerce orders and the distribution of customers across Brazilian states is crucial for businesses like Target to tailor their marketing strategies, optimize logistics, and enhance customer experiences. By leveraging this SQL-driven analysis, e-commerce companies can effectively target specific regions, allocate resources strategically, and deliver personalized experiences that cater to the unique preferences and demands of customers in different states.

In conclusion, analyzing the evolution of e-commerce orders and customer distribution across states in Brazil provides valuable insights into the dynamics of the market. By leveraging SQL and data-driven approaches, businesses can gain a competitive edge, drive growth, and maximize their impact in the rapidly evolving e-commerce landscape of the Brazil region.


# 4. The Impact on Economy: Analyzing Cost Trends and State-wise Price and Freight Values <a id='imp'></a>

### Examining the Percentage Increase in the Cost of Orders from 2017 to 2018 (January to August)

To understand the impact on the economy, we calculated the percentage increase in the cost of orders from 2017 to 2018, considering only the months from January to August. The following SQL query was executed:

# 5. Analyzing Sales, Freight, and Delivery Time: Insights from Brazil <a id='ana'></a>
# 6. Analyzing Payment Types: Insights on Orders and Payment Installments <a id='pay'></a>
# 7. Actionable Insights and Recommendations Based on the Analysis <a id='act'></a>
# 8. Conclusion <a id='con'></a>
