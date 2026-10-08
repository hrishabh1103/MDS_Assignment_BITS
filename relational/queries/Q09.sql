-- Q09
-- Student: Mohamed Ibrahim M
-- BITS ID: 2026NS12021
-- Requirement: Identify refunded payments and show the associated passenger, booking, and refund amount.

USE modern_db_lab;
SELECT py.payment_id, py.booking_id, p.full_name, py.amount, py.payment_time, py.transaction_ref
FROM PAYMENT py
JOIN BOOKING b ON b.booking_id = py.booking_id
JOIN PASSENGER p ON p.passenger_id = b.passenger_id
WHERE py.payment_status = 'REFUNDED'
ORDER BY py.payment_time;
