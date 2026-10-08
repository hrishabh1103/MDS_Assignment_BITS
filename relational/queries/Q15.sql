-- Q15
-- Student: Hrishabh Gupta
-- BITS ID: 2026NS12122
-- Requirement: Find passengers who have made at least one non-cancelled booking but have never made a cancelled booking.

USE modern_db_lab;
SELECT p.passenger_id, p.full_name
FROM PASSENGER p
WHERE EXISTS (
  SELECT 1 FROM BOOKING b WHERE b.passenger_id = p.passenger_id AND b.booking_status <> 'CANCELLED'
)
AND NOT EXISTS (
  SELECT 1 FROM BOOKING b WHERE b.passenger_id = p.passenger_id AND b.booking_status = 'CANCELLED'
)
ORDER BY p.passenger_id;
