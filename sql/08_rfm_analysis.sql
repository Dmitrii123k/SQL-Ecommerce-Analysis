-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 08_rfm_analysis.sql
-- Author: Дмитрий Кискин
-- =====================================
--R — Recency-Как давно клиент совершал последнюю покупку?
--F — Frequency--Как часто покупает клиент?
--M — Monetary-Сколько денег принес клиент?
--RFM-анализ клиентов и сегментация
WITH rfm_base AS (
    -- Расчет основных RFM-показателей
    SELECT
        customer_id,
        DATE '2011-12-09' - MAX(invoice_date)::date AS recency,
        COUNT(DISTINCT invoice_no) AS frequency,
        ROUND(SUM((quantity * unit_price)::numeric), 2) AS monetary
    FROM clean_online_retail
    GROUP BY customer_id
),
rfm_scores AS (
    -- Присвоение R, F и M оценок
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        CASE
            WHEN recency <= 30 THEN 5
            WHEN recency <= 60 THEN 4
            WHEN recency <= 90 THEN 3
            WHEN recency <= 180 THEN 2
            ELSE 1
        END AS r_score,
        CASE
            WHEN frequency > 10 THEN 5
            WHEN frequency >= 6 THEN 4
            WHEN frequency >= 4 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS f_score,
        CASE
            WHEN monetary > 5000 THEN 5
            WHEN monetary > 1000 THEN 4
            WHEN monetary > 500 THEN 3
            WHEN monetary > 100 THEN 2
            ELSE 1
        END AS m_score
    FROM rfm_base
),
customer_segments AS (
    -- Сегментация клиентов
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        CASE
            WHEN r_score = 5
             AND f_score = 5
             AND m_score = 5
                THEN 'VIP'
            WHEN r_score >= 4
             AND f_score >= 4
                THEN 'Лояльный'
            WHEN r_score >= 4
             AND f_score <= 2
                THEN 'Новый клиент'
            WHEN r_score <= 2
             AND f_score >= 4
                THEN 'Требует внимания'
            ELSE 'Обычный'
        END AS segment
    FROM rfm_scores
)
-- Итоговый отчет по сегментам
SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(monetary), 2) AS avg_revenue,
    ROUND(AVG(frequency), 2) AS avg_orders
FROM customer_segments
GROUP BY segment
ORDER BY avg_revenue DESC;
-----------------------------------------------------
-- VIP-клиенты
WITH rfm_base AS (...),
rfm_scores AS (...),
customer_segments AS (...)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    segment
FROM customer_segments
WHERE segment = 'VIP'
ORDER BY monetary DESC;
-----------------------------------------------------
-- Новые клиенты
WITH rfm_base AS (...),
rfm_scores AS (...),
customer_segments AS (...)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    segment
FROM customer_segments
WHERE segment = 'Новый клиент'
ORDER BY recency;
-----------------------------------------------------
-- Клиенты, требующие внимания
WITH rfm_base AS (...),
rfm_scores AS (...),
customer_segments AS (...)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    segment
FROM customer_segments
WHERE segment = 'Требует внимания'
ORDER BY recency DESC;
-----------------------------------------------------
-- Средняя выручка по сегментам
WITH rfm_base AS (...),
rfm_scores AS (...),
customer_segments AS (...)

SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(monetary),2) AS avg_revenue
FROM customer_segments
GROUP BY segment
ORDER BY avg_revenue DESC;
-----------------------------------------------------
-- Среднее количество заказов
WITH rfm_base AS (...),
rfm_scores AS (...),
customer_segments AS (...)

SELECT
    segment,
    ROUND(AVG(frequency),2) AS avg_orders
FROM customer_segments
GROUP BY segment
ORDER BY avg_orders DESC;
-----------------------------------------------------