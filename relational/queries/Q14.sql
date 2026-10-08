-- Q14
-- Student: Hrishabh Gupta
-- BITS ID: 2026NS12122
-- Requirement: Find routes for which no trip is currently marked as cancelled.

USE modern_db_lab;
SELECT r.route_id, r.route_name
FROM ROUTE r
WHERE NOT EXISTS (
  SELECT 1 FROM TRIP t
  WHERE t.route_id = r.route_id AND t.trip_status = 'CANCELLED'
)
ORDER BY r.route_id;
