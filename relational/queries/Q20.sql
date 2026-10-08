-- Q20
-- Student: Aditya Singhal
-- BITS ID: 2026NS12028
-- Requirement: Find trips whose non-cancelled booking revenue exceeds the average trip revenue among trips on the same route.

USE modern_db_lab;
SELECT t.trip_id, r.route_name, t.service_date, ROUND(SUM(b.journey_fare),2) AS trip_revenue
FROM TRIP t
JOIN ROUTE r ON r.route_id = t.route_id
JOIN BOOKING b ON b.trip_id = t.trip_id
WHERE b.booking_status <> 'CANCELLED'
GROUP BY t.trip_id, r.route_name, t.service_date
HAVING SUM(b.journey_fare) > (
  SELECT AVG(route_trip_revenue)
  FROM (
    SELECT t2.trip_id, SUM(b2.journey_fare) AS route_trip_revenue
    FROM TRIP t2
    JOIN BOOKING b2 ON b2.trip_id = t2.trip_id
    WHERE t2.route_id = t.route_id AND b2.booking_status <> 'CANCELLED'
    GROUP BY t2.trip_id
  ) x
)
ORDER BY trip_revenue DESC;
