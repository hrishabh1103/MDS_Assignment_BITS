-- Q10
-- Student: Mohamed Ibrahim M
-- BITS ID: 2026NS12021
-- Requirement: Find routes whose average non-cancelled booking fare is greater than the overall average non-cancelled booking fare.

USE modern_db_lab;
SELECT r.route_name, ROUND(AVG(b.journey_fare),2) AS route_average_fare
FROM ROUTE r
JOIN TRIP t ON t.route_id = r.route_id
JOIN BOOKING b ON b.trip_id = t.trip_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY r.route_id, r.route_name
HAVING AVG(b.journey_fare) > (
  SELECT AVG(journey_fare) FROM BOOKING WHERE booking_status <> 'CANCELLED'
)
ORDER BY route_average_fare DESC;
