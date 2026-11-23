-- 05_export.sql: small aggregated tables for the dashboard

COPY (
  SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
         COUNT(DISTINCT o.order_id) AS orders_count,
         ROUND(SUM(o_i.price), 2) AS revenue,
         ROUND(SUM(o_i.price) / COUNT(DISTINCT o.order_id), 2) AS aov
  FROM orders AS o
  JOIN order_items AS o_i ON o.order_id = o_i.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
  GROUP BY month
  ORDER BY month
) TO 'dashboard/monthly.csv' (HEADER, DELIMITER ',');

COPY (
  SELECT CASE
           WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on_time'
           WHEN date_diff('day', o.order_estimated_delivery_date, o.order_delivered_customer_date) <= 7 THEN 'late_up_to_7_days'
           ELSE 'late_over_7_days'
         END AS delivery_group,
         COUNT(*) AS orders_count,
         ROUND(AVG(a.avg_score), 2) AS avg_review
  FROM orders AS o
  JOIN average_score AS a ON o.order_id = a.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
  GROUP BY delivery_group
) TO 'dashboard/delivery_vs_review.csv' (HEADER, DELIMITER ',');

COPY (
  SELECT t.product_category_name_english AS category,
         COUNT(DISTINCT o.order_id) AS orders_count,
         ROUND(SUM(o_i.price)) AS revenue
  FROM orders AS o
  JOIN order_items AS o_i ON o.order_id = o_i.order_id
  JOIN products AS p ON o_i.product_id = p.product_id
  LEFT JOIN category_translation AS t ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY category
  ORDER BY revenue DESC
  LIMIT 10
) TO 'dashboard/top_categories.csv' (HEADER, DELIMITER ',');
