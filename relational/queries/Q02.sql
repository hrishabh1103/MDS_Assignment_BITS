-- Q02
-- Student: Priya N
-- BITS ID: 2026NS12087
-- Requirement: Display every stop of every route in travel order, including distance from the route origin and scheduled offset.

USE modern_db_lab;
SELECT r.route_name, rs.stop_sequence, s.stop_name, s.city, rs.distance_from_origin_km, rs.scheduled_offset_min
FROM ROUTE r
JOIN ROUTE_STOP rs ON rs.route_id = r.route_id
JOIN STOP s ON s.stop_id = rs.stop_id
ORDER BY r.route_id, rs.stop_sequence;
