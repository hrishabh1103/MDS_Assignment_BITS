-- Q07
-- Student: Mohamed Ibrahim M
-- BITS ID: 2026NS12021
-- Requirement: Count the number of trips operated by each coach type.

USE modern_db_lab;
SELECT c.type_name, COUNT(t.trip_id) AS trip_count
FROM COACH_TYPE c
LEFT JOIN BUS b ON b.coach_type_id = c.coach_type_id
LEFT JOIN TRIP t ON t.bus_id = b.bus_id
GROUP BY c.coach_type_id, c.type_name
ORDER BY trip_count DESC, c.type_name;
