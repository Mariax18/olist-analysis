-- 02_trends.sql
-- Brief question 1: order trend, revenue and AOV
-- Tables: orders, order_items

-- 1. Join fan-out check: 112650 item rows vs 98666 distinct orders
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT o.order_id) AS order_ids
FROM orders AS o
JOIN order_items AS o_i ON o.order_id = o_i.order_id;

-- 2. Orders with no items: 775 in total (unavailable 603, canceled 164, few others), 0 delivered
SELECT o.order_status,
       COUNT(*) FILTER (WHERE o_i.order_id IS NULL) AS no_items
FROM orders AS o
LEFT JOIN order_items AS o_i ON o.order_id = o_i.order_id
GROUP BY o.order_status;

-- 3. Orders and item revenue by status
-- Decision: revenue counts delivered orders only (price, without freight_value)
SELECT COUNT(DISTINCT o.order_id) AS orders_count,
       o.order_status,
       SUM(o_i.price) AS total_price
FROM orders AS o
JOIN order_items AS o_i ON o.order_id = o_i.order_id
GROUP BY o.order_status
ORDER BY total_price DESC;

-- 4. Monthly delivered orders, revenue and AOV (Jan 2017 to Aug 2018)
SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
       COUNT(DISTINCT o.order_id) AS orders_count,
       SUM(o_i.price) AS revenue,
       ROUND(SUM(o_i.price) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders AS o
JOIN order_items AS o_i ON o.order_id = o_i.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY month
ORDER BY month;
