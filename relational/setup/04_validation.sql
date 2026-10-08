-- 04_validation.sql
USE modern_db_lab;

SELECT 'PASSENGER' AS table_name, COUNT(*) AS row_count FROM PASSENGER
UNION ALL SELECT 'COACH_TYPE', COUNT(*) FROM COACH_TYPE
UNION ALL SELECT 'BUS', COUNT(*) FROM BUS
UNION ALL SELECT 'SEAT', COUNT(*) FROM SEAT
UNION ALL SELECT 'STOP', COUNT(*) FROM STOP
UNION ALL SELECT 'ROUTE', COUNT(*) FROM ROUTE
UNION ALL SELECT 'ROUTE_STOP', COUNT(*) FROM ROUTE_STOP
UNION ALL SELECT 'TRIP', COUNT(*) FROM TRIP
UNION ALL SELECT 'FARE_RULE', COUNT(*) FROM FARE_RULE
UNION ALL SELECT 'FESTIVAL', COUNT(*) FROM FESTIVAL
UNION ALL SELECT 'BOOKING', COUNT(*) FROM BOOKING
UNION ALL SELECT 'PAYMENT', COUNT(*) FROM PAYMENT;

-- Show bookings with route sequence numbers.
SELECT b.booking_id, b.trip_id, b.seat_no,
       sb.stop_name AS boarding_stop, rb.stop_sequence AS boarding_seq,
       sd.stop_name AS drop_stop, rd.stop_sequence AS drop_seq,
       b.booking_status
FROM BOOKING b
JOIN TRIP t ON t.trip_id=b.trip_id
JOIN ROUTE_STOP rb ON rb.route_id=t.route_id AND rb.stop_id=b.boarding_stop_id
JOIN ROUTE_STOP rd ON rd.route_id=t.route_id AND rd.stop_id=b.drop_stop_id
JOIN STOP sb ON sb.stop_id=b.boarding_stop_id
JOIN STOP sd ON sd.stop_id=b.drop_stop_id
ORDER BY b.trip_id, b.booking_id;

-- Expected: no rows. This detects overlapping active seat segments.
SELECT b1.booking_id AS booking_a, b2.booking_id AS booking_b,
       b1.trip_id, b1.seat_no
FROM BOOKING b1
JOIN BOOKING b2
  ON b1.trip_id=b2.trip_id
 AND b1.seat_bus_id=b2.seat_bus_id
 AND b1.seat_no=b2.seat_no
 AND b1.booking_id < b2.booking_id
 AND b1.booking_status IN ('CONFIRMED','COMPLETED')
 AND b2.booking_status IN ('CONFIRMED','COMPLETED')
JOIN TRIP t ON t.trip_id=b1.trip_id
JOIN ROUTE_STOP a1 ON a1.route_id=t.route_id AND a1.stop_id=b1.boarding_stop_id
JOIN ROUTE_STOP a2 ON a2.route_id=t.route_id AND a2.stop_id=b1.drop_stop_id
JOIN ROUTE_STOP c1 ON c1.route_id=t.route_id AND c1.stop_id=b2.boarding_stop_id
JOIN ROUTE_STOP c2 ON c2.route_id=t.route_id AND c2.stop_id=b2.drop_stop_id
WHERE a1.stop_sequence < c2.stop_sequence
  AND c1.stop_sequence < a2.stop_sequence;

-- Verify every trip seat reference belongs to its assigned bus.
SELECT b.booking_id
FROM BOOKING b JOIN TRIP t ON t.trip_id=b.trip_id
WHERE b.seat_bus_id <> t.bus_id;


-- MANUAL TRIGGER TEST (run separately after loading data; this statement should FAIL):
-- Trip 1, Seat 01 already has 1->2 and 2->3 and 4->5 segments.
-- The following overlaps 1->2 and should be rejected with SQLSTATE 45000.
-- INSERT INTO BOOKING VALUES (999,1,13,1,'01','1','3',NOW(),500.00,'CONFIRMED');
