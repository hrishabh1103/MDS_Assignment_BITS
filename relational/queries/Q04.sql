-- Q04
-- Student: Priya N
-- BITS ID: 2026NS12087
-- Requirement: Compare the number of bookings and average journey fare for each passenger concession category.

USE modern_db_lab;
SELECT p.concession_category, COUNT(b.booking_id) AS booking_count, ROUND(AVG(b.journey_fare),2) AS average_fare
FROM PASSENGER p
JOIN BOOKING b ON b.passenger_id = p.passenger_id
GROUP BY p.concession_category
ORDER BY average_fare DESC;
