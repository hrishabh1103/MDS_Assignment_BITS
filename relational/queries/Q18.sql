-- Q18
-- Student: Aditya Singhal
-- BITS ID: 2026NS12028
-- Requirement: Find the most frequently booked origin-destination stop pairs.

USE modern_db_lab;
SELECT sb.stop_name AS boarding_stop, sd.stop_name AS drop_stop, COUNT(*) AS booking_count
FROM BOOKING b
JOIN STOP sb ON sb.stop_id = b.boarding_stop_id
JOIN STOP sd ON sd.stop_id = b.drop_stop_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY sb.stop_id, sb.stop_name, sd.stop_id, sd.stop_name
ORDER BY booking_count DESC, boarding_stop, drop_stop;
