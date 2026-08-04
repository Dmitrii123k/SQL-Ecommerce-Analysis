-- =====================================
-- Project: SQL Ecommerce Analysis
-- File: 03_data_quality.sql
-- Author: Дмитрий
-- =====================================
--Запросы на сырых данных
--запрос_1_Сколько строк в таблице?
SELECT COUNT(*) AS total_rows
FROM online_retail;
--запрос_2_Посмотреть первые записи
SELECT *
FROM online_retail
LIMIT 10;
--запрос_3_Изучаем структуру
SELECT
    invoice_no,
    stock_code,
    quantity,
    unit_price
FROM online_retail
LIMIT 10;
--запрос_4_За какой период данные?
SELECT
    MIN(invoice_date) AS first_order,
    MAX(invoice_date) AS last_order
FROM online_retail;
--запрос_5_Сколько уникальных клиентов?
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM online_retail;
--запрос_6_Сколько уникальных заказов?
SELECT
    COUNT(DISTINCT invoice_no) AS total_invoices
FROM online_retail;
--запрос_7_Сколько товаров?
SELECT
    COUNT(DISTINCT stock_code) AS total_products
FROM online_retail;
--запрос_8_Сколько стран?
SELECT
    COUNT(DISTINCT country) AS total_countries
FROM online_retail;
--Какие страны?
SELECT DISTINCT country
FROM online_retail
ORDER BY country;
--запрос_9_Проверяем пропуски
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_not_null,
    COUNT(description) AS description_not_null
FROM online_retail;
--запрос_10_Ищем отмененные заказы
SELECT *
FROM online_retail
WHERE invoice_no LIKE 'C%'
LIMIT 20;