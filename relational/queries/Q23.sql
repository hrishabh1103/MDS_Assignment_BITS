-- Q23
-- Student: Rupesh Kumar Singh
-- BITS ID: 2026NS12128
-- Requirement: Calculate seat utilization for every trip as the percentage of non-reserved seats used by at least one non-cancelled booking segment.

USE modern_db_lab;
SELECT t.trip_id, t.service_date, r.route_name,
       COUNT(DISTINCT CASE WHEN s.is_reserved_for_staff = FALSE THEN CONCAT(b.seat_bus_id, '-', b.seat_no) END) AS used_seats,
       COUNT(DISTINCT CASE WHEN s.is_reserved_for_staff = FALSE THEN CONCAT(s.bus_id, '-', s.seat_no) END) AS available_seats,
       ROUND(100 * COUNT(DISTINCT CASE WHEN s.is_reserved_for_staff = FALSE THEN CONCAT(b.seat_bus_id, '-', b.seat_no) END) / NULLIF(COUNT(DISTINCT CASE WHEN s.is_reserved_for_staff = FALSE THEN CONCAT(s.bus_id, '-', s.seat_no) END),0),2) AS utilization_percent
FROM TRIP t
JOIN ROUTE r ON r.route_id = t.route_id
JOIN SEAT s ON s.bus_id = t.bus_id
LEFT JOIN BOOKING b ON b.trip_id = t.trip_id AND b.seat_bus_id = s.bus_id AND b.seat_no = s.seat_no AND b.booking_status <> 'CANCELLED'
GROUP BY t.trip_id, t.service_date, r.route_name
ORDER BY utilization_percent DESC, t.trip_id;
