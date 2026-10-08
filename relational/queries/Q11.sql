-- Q11
-- Student: Hrishabh Gupta
-- BITS ID: 2026NS12122
-- Requirement: Find passengers whose number of non-cancelled bookings is above the average booking count among passengers who have booked at least once.

USE modern_db_lab;
SELECT p.passenger_id, p.full_name, COUNT(b.booking_id) AS booking_count
FROM PASSENGER p
JOIN BOOKING b ON b.passenger_id = p.passenger_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY p.passenger_id, p.full_name
HAVING COUNT(b.booking_id) > (
  SELECT AVG(passenger_booking_count)
  FROM (
    SELECT passenger_id, COUNT(*) AS passenger_booking_count
    FROM BOOKING
    WHERE booking_status <> 'CANCELLED'
    GROUP BY passenger_id
  ) x
)
ORDER BY booking_count DESC;
