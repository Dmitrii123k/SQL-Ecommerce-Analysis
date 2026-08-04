-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 06_sales_analysis.sql
-- Author: Дмитрий Кискин
-- =====================================
--Анализ продаж по времени
--запрос_1_Топ-10 клиентов по выручке
SELECT
    customer_id,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue
FROM clean_online_retail
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;
--запрос_2_Топ-10 товаров по выручке
SELECT
    stock_code,
    description,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue
FROM clean_online_retail
GROUP BY stock_code, description
ORDER BY revenue DESC
LIMIT 10;
--запрос_3_Топ-10 товаров по количеству продаж
SELECT
    stock_code,
    description,
    SUM(quantity) AS total_quantity
FROM clean_online_retail
GROUP BY stock_code, description
ORDER BY total_quantity DESC
LIMIT 10;
--запрос_4_Выручка по месяцам
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;
--запрос_5_Количество заказов по месяцам
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    COUNT(DISTINCT invoice_no) AS orders_count
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;
--запрос_6_Средний чек по месяцам
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(
        (
            SUM(quantity * unit_price)
            /
            COUNT(DISTINCT invoice_no)
        )::numeric,
        2
    ) AS average_order
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;
--запрос_7_Новые клиенты по месяцам
SELECT
    customer_id,
    MIN(invoice_date) AS first_purchase
FROM clean_online_retail
GROUP BY customer_id
ORDER BY first_purchase;
--запрос_8_В какой день недели больше всего заказов?
SELECT
    EXTRACT(DOW FROM invoice_date) AS day_of_week,
    CASE EXTRACT(DOW FROM invoice_date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_name,
    COUNT(DISTINCT invoice_no) AS orders_count
FROM clean_online_retail
GROUP BY EXTRACT(DOW FROM invoice_date), day_name
ORDER BY day_of_week;
--запрос_9_В каком часу чаще делают покупки?
SELECT
    EXTRACT(HOUR FROM invoice_date) AS hour,
    COUNT(DISTINCT invoice_no) AS orders_count
FROM clean_online_retail
GROUP BY EXTRACT(HOUR FROM invoice_date)
ORDER BY hour;
--запрос_10_Топ-5 месяцев по выручке
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY revenue DESC
LIMIT 5;
