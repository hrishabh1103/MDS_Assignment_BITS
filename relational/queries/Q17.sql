-- Q17
-- Student: Aditya Singhal
-- BITS ID: 2026NS12028
-- Requirement: Rank boarding stops by the number of non-cancelled passengers beginning their journey there.

USE modern_db_lab;
SELECT s.stop_name, s.city, COUNT(b.booking_id) AS passenger_count
FROM STOP s
JOIN BOOKING b ON b.boarding_stop_id = s.stop_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY s.stop_id, s.stop_name, s.city
ORDER BY passenger_count DESC, s.stop_name;
