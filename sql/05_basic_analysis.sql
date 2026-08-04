-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 05_basic_analysis.sql
-- Author: Дмитрий
-- =====================================
--Бизнес-метрики
--запрос_1_Общая выручка
SELECT
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS total_revenue
FROM clean_online_retail;
--запрос_2_Общее количество заказов
SELECT
    COUNT(DISTINCT invoice_no) AS total_orders
FROM clean_online_retail;
--запрос_3_Количество клиентов
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM clean_online_retail;
--запрос_4_Средний чек
--Средний чек = общая выручка / количество заказов.
SELECT
    ROUND(
        (
            SUM(quantity * unit_price)
            / COUNT(DISTINCT invoice_no)
        )::numeric,
        2
    ) AS average_order_value
FROM clean_online_retail;

