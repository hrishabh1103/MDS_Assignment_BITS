-- Q01
-- Student: Priya N
-- BITS ID: 2026NS12087
-- Requirement: List each booking with the passenger name, trip date, route name, boarding stop, drop stop, and journey fare.

USE modern_db_lab;
SELECT b.booking_id, p.full_name, t.service_date, r.route_name, sb.stop_name AS boarding_stop, sd.stop_name AS drop_stop, b.journey_fare
FROM BOOKING b
JOIN PASSENGER p ON p.passenger_id = b.passenger_id
JOIN TRIP t ON t.trip_id = b.trip_id
JOIN ROUTE r ON r.route_id = t.route_id
JOIN STOP sb ON sb.stop_id = b.boarding_stop_id
JOIN STOP sd ON sd.stop_id = b.drop_stop_id
ORDER BY t.service_date, b.booking_id;
