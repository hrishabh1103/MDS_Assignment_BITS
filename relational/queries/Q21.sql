-- Q21
-- Student: Rupesh Kumar Singh
-- BITS ID: 2026NS12128
-- Requirement: Rank routes by total non-cancelled booking revenue.

USE modern_db_lab;
WITH route_revenue AS (
  SELECT r.route_id, r.route_name, COALESCE(SUM(CASE WHEN b.booking_status <> 'CANCELLED' THEN b.journey_fare ELSE 0 END),0) AS total_revenue
  FROM ROUTE r
  LEFT JOIN TRIP t ON t.route_id = r.route_id
  LEFT JOIN BOOKING b ON b.trip_id = t.trip_id
  GROUP BY r.route_id, r.route_name
)
SELECT route_id, route_name, ROUND(total_revenue,2) AS total_revenue, RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM route_revenue
ORDER BY revenue_rank, route_name;
