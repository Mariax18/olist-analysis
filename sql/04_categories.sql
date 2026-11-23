-- 04_categories.sql
-- Brief question 4: revenue by product category
-- Tables: orders, order_items, products, category_translation
-- Decision: delivered orders only, revenue = price

-- Top 10 categories by revenue
-- health_beauty 1233132, watches_gifts 1166177, bed_bath_table 1023435
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
LIMIT 10;

-- Share of the top 3 categories in total revenue
WITH cat AS (
  SELECT t.product_category_name_english AS category,
         SUM(o_i.price) AS revenue
  FROM orders AS o
  JOIN order_items AS o_i ON o.order_id = o_i.order_id
  JOIN products AS p ON o_i.product_id = p.product_id
  LEFT JOIN category_translation AS t ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY category
),
top3 AS (
  SELECT revenue FROM cat ORDER BY revenue DESC LIMIT 3
)
SELECT (SELECT SUM(revenue) FROM top3) AS top3_revenue,
       (SELECT SUM(revenue) FROM cat) AS total_revenue,
       ROUND(100.0 * (SELECT SUM(revenue) FROM top3) / (SELECT SUM(revenue) FROM cat), 1) AS top3_share_pct;
