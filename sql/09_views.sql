-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 09_views.sql
-- Author: Дмитрий Кискин
-- =====================================
-- Views: RFM-анализ клиентов
CREATE VIEW rfm_segments AS
WITH rfm_base AS (
    SELECT
        customer_id,
        DATE '2011-12-09' - MAX(invoice_date)::date AS recency,
        COUNT(DISTINCT invoice_no) AS frequency,
        ROUND(SUM((quantity * unit_price)::numeric), 2) AS monetary
    FROM clean_online_retail
    GROUP BY customer_id
),
rfm_scores AS (
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
SELECT *
FROM customer_segments;

-----------------------------------------------------
-- Проверка результатов RFM клиентов
-----------------------------------------------------

-- ТОП-10 VIP-клиентов
SELECT *
FROM rfm_segments
WHERE segment = 'VIP'
ORDER BY monetary DESC
LIMIT 10;
-----------------------------------------------------
-- Количество клиентов по сегментам
SELECT
    segment,
    COUNT(*) AS customers
FROM rfm_segments
GROUP BY segment
ORDER BY customers DESC;
-----------------------------------------------------
-- Средняя выручка по сегментам
SELECT
    segment,
    ROUND(AVG(monetary), 2) AS avg_revenue
FROM rfm_segments
GROUP BY segment
ORDER BY avg_revenue DESC;
-----------------------------------------------------
-- Среднее количество заказов
SELECT
    segment,
    ROUND(AVG(frequency), 2) AS avg_orders
FROM rfm_segments
GROUP BY segment
ORDER BY avg_orders DESC;
-----------------------------------------------------