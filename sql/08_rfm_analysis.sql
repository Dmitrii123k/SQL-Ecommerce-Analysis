-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 08_rfm_analysis.sql
-- Author: Дмитрий Кискин
-- =====================================
--R — Recency-Как давно клиент совершал последнюю покупку?
--F — Frequency-Как часто покупает клиент?
--M — Monetary-Сколько денег принес клиент?
--запрос_1_Найдем дату последней покупки в базе
SELECT
    MAX(invoice_date) AS last_date
FROM clean_online_retail;
--запрос_2_Посчитаем RFM-показатели
SELECT
    customer_id,
    MAX(invoice_date) AS last_purchase,
    COUNT(DISTINCT invoice_no) AS frequency,
    ROUND(SUM((quantity * unit_price)::numeric), 2) AS monetary
FROM clean_online_retail
GROUP BY customer_id
ORDER BY monetary DESC;
--запрос_3_Рассчитываем Recency
WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(invoice_date) AS last_purchase,
        COUNT(DISTINCT invoice_no) AS frequency,
        SUM(quantity * unit_price) AS monetary
    FROM clean_online_retail
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_purchase,
    (
        MAX(last_purchase) OVER ()
        - last_purchase
    ) AS recency,
    frequency,
    ROUND(monetary::numeric,2) AS monetary
FROM rfm_base
ORDER BY monetary DESC;
