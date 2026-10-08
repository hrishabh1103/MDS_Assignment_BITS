-- Q12
-- Student: Hrishabh Gupta
-- BITS ID: 2026NS12122
-- Requirement: Find trips having more non-cancelled bookings than the average number of non-cancelled bookings per trip.

USE modern_db_lab;
SELECT t.trip_id, r.route_name, t.service_date, COUNT(b.booking_id) AS booking_count
FROM TRIP t
JOIN ROUTE r ON r.route_id = t.route_id
JOIN BOOKING b ON b.trip_id = t.trip_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY t.trip_id, r.route_name, t.service_date
HAVING COUNT(b.booking_id) > (
  SELECT AVG(trip_booking_count)
  FROM (
    SELECT trip_id, COUNT(*) AS trip_booking_count
    FROM BOOKING
    WHERE booking_status <> 'CANCELLED'
    GROUP BY trip_id
  ) x
)
ORDER BY booking_count DESC;
