-- Q06
-- Student: Mohamed Ibrahim M
-- BITS ID: 2026NS12021
-- Requirement: Show every bus together with its coach type, seating style, AC status, capacity, and current status.

USE modern_db_lab;
SELECT b.bus_id, b.registration_no, c.type_name, c.seating_style, c.ac_flag, c.total_capacity, b.status
FROM BUS b
JOIN COACH_TYPE c ON c.coach_type_id = b.coach_type_id
ORDER BY b.bus_id;
