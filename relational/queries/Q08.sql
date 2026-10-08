-- Q08
-- Student: Mohamed Ibrahim M
-- BITS ID: 2026NS12021
-- Requirement: Analyze successful payment revenue by payment method.

USE modern_db_lab;
SELECT payment_method, COUNT(*) AS successful_payments, ROUND(SUM(amount),2) AS successful_revenue
FROM PAYMENT
WHERE payment_status = 'SUCCESS'
GROUP BY payment_method
ORDER BY successful_revenue DESC;
