-- Q24
-- Student: Rupesh Kumar Singh
-- BITS ID: 2026NS12128
-- Requirement: Identify trips operating during a festival period and show the festival surcharge percentage applicable to the trip date.

USE modern_db_lab;
SELECT t.trip_id, t.service_date, r.route_name, f.festival_name, f.surcharge_percent
FROM TRIP t
JOIN ROUTE r ON r.route_id = t.route_id
JOIN FESTIVAL f ON t.service_date BETWEEN f.start_date AND f.end_date
ORDER BY t.service_date, t.trip_id;
