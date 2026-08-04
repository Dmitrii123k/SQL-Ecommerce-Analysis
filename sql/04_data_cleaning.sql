-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 04_data_cleaning.sql
-- Author: Дмитрий Кискин
-- =====================================
--"Чистый" набор данных, который будет использоваться во всех дальнейших запросах
--запрос_1_Изучаем отмененные заказы
SELECT COUNT(DISTINCT invoice_no) AS cancelled_orders
FROM online_retail
WHERE invoice_no LIKE 'C%';
--запрос_2_Сколько строк имеют отрицательное количество?
SELECT COUNT(*) AS negative_quantity
FROM online_retail
WHERE quantity < 0;
--запрос_3_Есть ли товары с нулевой или отрицательной ценой?
SELECT *
FROM online_retail
WHERE unit_price <= 0;
--запрос_4_Проверяем клиентов без ID
SELECT COUNT(*) AS missing_customers
FROM online_retail
WHERE customer_id IS NULL;
--запрос_5_Создаем очищенное представление (VIEW)
CREATE OR REPLACE VIEW clean_online_retail AS
SELECT *
FROM online_retail
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND invoice_no NOT LIKE 'C%';
--запрос_6_Проверяем количество строк
SELECT COUNT(*)
FROM clean_online_retail;
--запрос_7_Проверяем диапазон дат
SELECT
    MIN(invoice_date),
    MAX(invoice_date)
FROM clean_online_retail;
--запрос_8_Проверяем количество клиентов
SELECT
    COUNT(DISTINCT customer_id)
FROM clean_online_retail;
--запрос_9_Проверяем выручку
SELECT
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM clean_online_retail;




