-- Q16
-- Student: Aditya Singhal
-- BITS ID: 2026NS12028
-- Requirement: Identify trips where the same physical seat was legitimately reused for two or more non-overlapping passenger journey segments.

USE modern_db_lab;
SELECT b.trip_id, b.seat_bus_id AS bus_id, b.seat_no, COUNT(*) AS non_cancelled_bookings
FROM BOOKING b
WHERE b.booking_status IN ('CONFIRMED','COMPLETED')
GROUP BY b.trip_id, b.seat_bus_id, b.seat_no
HAVING COUNT(*) >= 2
ORDER BY b.trip_id, b.seat_no;
