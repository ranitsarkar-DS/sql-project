SELECT
  column_name,
  data_type
FROM
  `target.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'customers';


SELECT
  MIN(order_purchase_timestamp) AS first_order,
  MAX(order_purchase_timestamp) AS last_order
FROM
  `target.orders`;


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


SELECT
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  COUNT(DISTINCT order_id) AS order_count
FROM
  `target.orders`
GROUP BY
  month
ORDER BY
  month;


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

SELECT
  c.customer_state,
  COUNT(c.customer_id) AS no_of_customers
FROM
  `target.customers` c
GROUP BY
  c.customer_state
ORDER BY
  no_of_customers DESC;




SELECT
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  (
    (
      SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018 AND
      EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8 THEN
      p.payment_value END)
      -
      SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017 AND
      EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8 THEN
      p.payment_value END)
    )
    /
    SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017 AND
    EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8 THEN
    p.payment_value END)
  )*100 AS percent_increase
FROM
  `target.orders` o
JOIN
  `target.order_payments` p ON o.order_id = p.order_id
WHERE
  EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018) AND
  EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY 1
ORDER BY 1;




SELECT
  c.customer_state,
  ROUND(AVG(i.price), 2) AS mean_price,
  ROUND(SUM(i.price), 2) AS total_price,
  ROUND(AVG(i.freight_value), 2) AS mean_freight_value,
  ROUND(SUM(i.freight_value), 2) AS total_freight_value
FROM
  `target.orders` o
JOIN
  `target.order_items` i ON o.order_id = i.order_id
JOIN
  `target.customers` c ON o.customer_id = c.customer_id
GROUP BY
  c.customer_state;


SELECT
  order_id,
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) 
  AS delivered_in_days,
  DATE_DIFF(order_estimated_delivery_date, order_purchase_timestamp, DAY) 
  AS estimated_delivery_in_days,
  DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY) 
  AS estimated_minus_actual_delivery_days
FROM
  `target.orders`
WHERE
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) IS NOT NULL
ORDER BY
  delivered_in_days;



SELECT
  c.customer_state,
  ROUND(AVG(DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)), 2) 
  AS avg_time_to_delivery,
  ROUND(AVG(DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY)), 2) 
  AS avg_diff_estimated_delivery
FROM
  `target.orders` o
JOIN
  `target.customers` c ON o.customer_id = c.customer_id
WHERE
  DATE_DIFF(order_purchase_timestamp, order_delivered_customer_date, DAY) IS NOT NULL
  AND
  DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY) IS NOT NULL
GROUP BY
  c.customer_state
ORDER BY
  avg_time_to_delivery;



SELECT
  c.customer_state,
  ROUND(AVG(i.freight_value), 2) AS mean_freight_value,
  ROUND(AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)), 2) 
  AS time_to_delivery,
  ROUND(AVG(DATE_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, DAY)), 2) 
  AS diff_estimated_delivery
FROM
  `target.orders` o
JOIN
  `target.order_items` i ON o.order_id = i.order_id
JOIN
  `target.customers` c ON o.customer_id = c.customer_id
GROUP BY
  c.customer_state
ORDER BY
  mean_freight_value;


SELECT
  p.payment_type,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  COUNT(DISTINCT o.order_id) AS order_count
FROM
  `target.orders` o
JOIN
  `target.order_payments` p
ON
  o.order_id = p.order_id
GROUP BY
  1, 2
ORDER BY
  1, 2;


SELECT
  p.payment_installments,
  COUNT(o.order_id) AS order_count
FROM
  `target.orders` o
JOIN
  `target.order_payments` p
ON
  o.order_id = p.order_id
WHERE
  o.order_status != 'canceled'
GROUP BY
  1
ORDER BY
  2 DESC;
