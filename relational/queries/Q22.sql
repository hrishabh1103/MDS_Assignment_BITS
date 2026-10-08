-- Q22
-- Student: Rupesh Kumar Singh
-- BITS ID: 2026NS12128
-- Requirement: Calculate cumulative non-cancelled booking revenue as trips are ordered by service date and trip ID.

USE modern_db_lab;
WITH trip_revenue AS (
  SELECT t.trip_id, t.service_date, r.route_name, COALESCE(SUM(CASE WHEN b.booking_status <> 'CANCELLED' THEN b.journey_fare ELSE 0 END),0) AS trip_revenue
  FROM TRIP t
  JOIN ROUTE r ON r.route_id = t.route_id
  LEFT JOIN BOOKING b ON b.trip_id = t.trip_id
  GROUP BY t.trip_id, t.service_date, r.route_name
)
SELECT trip_id, service_date, route_name, ROUND(trip_revenue,2) AS trip_revenue,
       ROUND(SUM(trip_revenue) OVER (ORDER BY service_date, trip_id ROWS UNBOUNDED PRECEDING),2) AS cumulative_revenue
FROM trip_revenue
ORDER BY service_date, trip_id;
