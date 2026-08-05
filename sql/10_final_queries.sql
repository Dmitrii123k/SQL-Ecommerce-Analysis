-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 10_final_queries.sql
-- Author: Дмитрий
-- =====================================
-- Финальные аналитические запросы проекта
-- ТОП-10 клиентов по общей выручке
SELECT
    customer_id,
    ROUND(SUM((quantity * unit_price)::numeric),2) AS revenue
FROM clean_online_retail
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;
-- Продажи по месяцам
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;
-- ТОП-10 самых продаваемых товаров
SELECT
    stock_code,
    description,
    SUM(quantity) AS total_quantity
FROM clean_online_retail
GROUP BY
    stock_code,
    description
ORDER BY total_quantity DESC
LIMIT 10;
-- Продажи по странам
SELECT
    country,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS revenue,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT invoice_no) AS orders
FROM clean_online_retail
GROUP BY country
ORDER BY revenue DESC;
-- Анализ RFM-сегментов клиентов
SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(monetary), 2) AS avg_revenue,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(frequency), 2) AS avg_orders,
    ROUND(AVG(recency), 2) AS avg_recency
FROM rfm_segments
GROUP BY segment
ORDER BY total_revenue DESC;
