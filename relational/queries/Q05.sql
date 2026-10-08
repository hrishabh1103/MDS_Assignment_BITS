-- Q05
-- Student: Priya N
-- BITS ID: 2026NS12087
-- Requirement: Find the five passengers who have spent the most on non-cancelled bookings.

USE modern_db_lab;
SELECT p.passenger_id, p.full_name, COUNT(b.booking_id) AS bookings, ROUND(SUM(b.journey_fare),2) AS total_spending
FROM PASSENGER p
JOIN BOOKING b ON b.passenger_id = p.passenger_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY p.passenger_id, p.full_name
ORDER BY total_spending DESC
LIMIT 5;
