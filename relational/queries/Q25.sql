-- Q25
-- Student: Rupesh Kumar Singh
-- BITS ID: 2026NS12128
-- Requirement: Find non-cancelled bookings whose fare is higher than the average fare for the passenger's concession category.

USE modern_db_lab;
SELECT b.booking_id, p.full_name, p.concession_category, b.journey_fare
FROM BOOKING b
JOIN PASSENGER p ON p.passenger_id = b.passenger_id
WHERE b.booking_status <> 'CANCELLED'
  AND b.journey_fare > (
    SELECT AVG(b2.journey_fare)
    FROM BOOKING b2
    JOIN PASSENGER p2 ON p2.passenger_id = b2.passenger_id
    WHERE p2.concession_category = p.concession_category
      AND b2.booking_status <> 'CANCELLED'
  )
ORDER BY p.concession_category, b.journey_fare DESC;
