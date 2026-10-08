-- Q13
-- Student: Hrishabh Gupta
-- BITS ID: 2026NS12122
-- Requirement: For each route, find the highest-fare non-cancelled booking.

USE modern_db_lab;
SELECT r.route_name, b.booking_id, p.full_name, b.journey_fare
FROM BOOKING b
JOIN TRIP t ON t.trip_id = b.trip_id
JOIN ROUTE r ON r.route_id = t.route_id
JOIN PASSENGER p ON p.passenger_id = b.passenger_id
WHERE b.booking_status <> 'CANCELLED'
  AND b.journey_fare = (
    SELECT MAX(b2.journey_fare)
    FROM BOOKING b2
    JOIN TRIP t2 ON t2.trip_id = b2.trip_id
    WHERE t2.route_id = t.route_id AND b2.booking_status <> 'CANCELLED'
  )
ORDER BY r.route_name;
