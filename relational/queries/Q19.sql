-- Q19
-- Student: Aditya Singhal
-- BITS ID: 2026NS12028
-- Requirement: Compare booking volume, average fare, and total revenue across passenger concession categories.

USE modern_db_lab;
SELECT p.concession_category, COUNT(b.booking_id) AS booking_count, ROUND(AVG(b.journey_fare),2) AS average_fare, ROUND(SUM(b.journey_fare),2) AS total_revenue
FROM PASSENGER p
JOIN BOOKING b ON b.passenger_id = p.passenger_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY p.concession_category
ORDER BY total_revenue DESC;
