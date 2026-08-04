-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 07_cte.sql
-- Author: Дмитрий Кискин
-- =====================================
--CTE (Common Table Expression) — это временная именованная таблица, 
--которая существует только во время выполнения одного запроса
--запрос_1_Выручка по каждому клиенту
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(quantity * unit_price) AS revenue
    FROM clean_online_retail
    GROUP BY customer_id)
SELECT *
FROM customer_revenue
WHERE revenue > 10000
ORDER BY revenue DESC;
--запрос_2_Клиенты с выручкой больше средней
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(quantity * unit_price) AS revenue
    FROM clean_online_retail
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(revenue::numeric,2) AS revenue
FROM customer_revenue
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM customer_revenue
)
ORDER BY revenue DESC;
--запрос_3_Средний чек каждого клиента
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS orders_count,
        SUM(quantity * unit_price) AS revenue
    FROM clean_online_retail
    GROUP BY customer_id
)
SELECT
    customer_id,
    orders_count,
    ROUND(revenue::numeric,2) AS revenue,
    ROUND(
        (revenue / orders_count)::numeric,
        2
    ) AS average_order
FROM customer_orders
ORDER BY revenue DESC;
--запрос_4_Клиенты, сделавшие больше среднего количества заказов
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS total_orders
    FROM clean_online_retail
    GROUP BY customer_id
)
SELECT *
FROM customer_orders
WHERE total_orders >
(
    SELECT AVG(total_orders)
    FROM customer_orders
)
ORDER BY total_orders DESC;
--запрос_5_Самые активные страны
WITH country_sales AS (
    SELECT
        country,
        COUNT(DISTINCT invoice_no) AS orders_count,
        SUM(quantity * unit_price) AS revenue
    FROM clean_online_retail
    GROUP BY country
)
SELECT
    country,
    orders_count,
    ROUND(revenue::numeric,2) AS revenue
FROM country_sales
ORDER BY revenue DESC;