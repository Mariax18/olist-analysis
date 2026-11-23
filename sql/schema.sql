CREATE VIEW average_score AS
SELECT order_id, avg(review_score) AS avg_score
FROM reviews
GROUP BY order_id;
CREATE TABLE category_translation(
    product_category_name VARCHAR,
    product_category_name_english VARCHAR
);
CREATE TABLE customers(
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR
);
CREATE TABLE order_items(
    order_id VARCHAR,
    order_item_id BIGINT,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price DOUBLE,
    freight_value DOUBLE
);
CREATE TABLE orders(
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
CREATE TABLE payments(
    order_id VARCHAR,
    payment_sequential BIGINT,
    payment_type VARCHAR,
    payment_installments BIGINT,
    payment_value DOUBLE
);
CREATE TABLE products(
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_name_lenght BIGINT,
    product_description_lenght BIGINT,
    product_photos_qty BIGINT,
    product_weight_g BIGINT,
    product_length_cm BIGINT,
    product_height_cm BIGINT,
    product_width_cm BIGINT
);
CREATE VIEW review_avg AS
SELECT order_id, avg(review_score) AS avg_score
FROM reviews
GROUP BY order_id;
CREATE TABLE reviews(
    review_id VARCHAR,
    order_id VARCHAR,
    review_score BIGINT,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
CREATE TABLE sellers(
    seller_id VARCHAR,
    seller_zip_code_prefix VARCHAR,
    seller_city VARCHAR,
    seller_state VARCHAR
);
CREATE VIEW two_join AS
SELECT *
FROM (orders AS o
        INNER JOIN order_items AS o_i ON ((o.order_id = o_i.order_id))
    );
