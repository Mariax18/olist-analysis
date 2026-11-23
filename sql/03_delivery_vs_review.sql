-- 03_delivery_vs_review.sql
-- Brief question 3: does delivery delay affect review score?
-- Tables: orders, average_score (view: one avg score per order)
-- Decision: delay = delivered after the estimated date; delivered orders with a delivery date only

-- Result: on_time 88163 (4.29), late_up_to_7_days 4880 (3.06), late_over_7_days 2781 (1.70)
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
ORDER BY avg_review DESC;
