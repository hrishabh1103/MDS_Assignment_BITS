-- 02_create_tables.sql
USE modern_db_lab;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS BOOKING;
DROP TABLE IF EXISTS TRIP;
DROP TABLE IF EXISTS FESTIVAL;
DROP TABLE IF EXISTS FARE_RULE;
DROP TABLE IF EXISTS ROUTE_STOP;
DROP TABLE IF EXISTS ROUTE;
DROP TABLE IF EXISTS STOP;
DROP TABLE IF EXISTS SEAT;
DROP TABLE IF EXISTS BUS;
DROP TABLE IF EXISTS COACH_TYPE;
DROP TABLE IF EXISTS PASSENGER;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE PASSENGER (
  passenger_id INT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(15) NOT NULL UNIQUE,
  email VARCHAR(120) UNIQUE,
  concession_category ENUM('NONE','STUDENT','SENIOR_CITIZEN','DISABLED') NOT NULL DEFAULT 'NONE',
  date_of_birth DATE,
  gender ENUM('MALE','FEMALE','OTHER') NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE COACH_TYPE (
  coach_type_id INT PRIMARY KEY,
  type_name VARCHAR(60) NOT NULL UNIQUE,
  seating_style ENUM('SEATER','SLEEPER','MULTI_AXLE') NOT NULL,
  ac_flag BOOLEAN NOT NULL,
  total_capacity INT NOT NULL,
  description VARCHAR(255),
  CHECK (total_capacity > 0)
) ENGINE=InnoDB;

CREATE TABLE BUS (
  bus_id INT PRIMARY KEY,
  registration_no VARCHAR(20) NOT NULL UNIQUE,
  coach_type_id INT NOT NULL,
  operator_name VARCHAR(100) NOT NULL DEFAULT 'InterCity Express',
  manufacture_year YEAR NOT NULL,
  status ENUM('ACTIVE','MAINTENANCE','RETIRED') NOT NULL DEFAULT 'ACTIVE',
  FOREIGN KEY (coach_type_id) REFERENCES COACH_TYPE(coach_type_id)
) ENGINE=InnoDB;

-- Weak entity: seat number is unique only within a bus.
CREATE TABLE SEAT (
  bus_id INT NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  seat_type ENUM('WINDOW','AISLE','LOWER','UPPER','MIDDLE') NOT NULL,
  deck ENUM('LOWER','UPPER') NOT NULL DEFAULT 'LOWER',
  is_reserved_for_staff BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (bus_id, seat_no),
  FOREIGN KEY (bus_id) REFERENCES BUS(bus_id)
) ENGINE=InnoDB;

CREATE TABLE STOP (
  stop_id INT PRIMARY KEY,
  stop_name VARCHAR(100) NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  terminal_type ENUM('MAIN_TERMINAL','CITY_STOP','BYPASS_STOP') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ROUTE (
  route_id INT PRIMARY KEY,
  route_name VARCHAR(120) NOT NULL UNIQUE,
  origin_city VARCHAR(80) NOT NULL,
  destination_city VARCHAR(80) NOT NULL,
  total_distance_km DECIMAL(8,2) NOT NULL,
  estimated_duration_min INT NOT NULL,
  CHECK (total_distance_km > 0),
  CHECK (estimated_duration_min > 0)
) ENGINE=InnoDB;

CREATE TABLE ROUTE_STOP (
  route_id INT NOT NULL,
  stop_id INT NOT NULL,
  stop_sequence INT NOT NULL,
  distance_from_origin_km DECIMAL(8,2) NOT NULL,
  scheduled_offset_min INT NOT NULL,
  PRIMARY KEY (route_id, stop_id),
  UNIQUE (route_id, stop_sequence),
  FOREIGN KEY (route_id) REFERENCES ROUTE(route_id),
  FOREIGN KEY (stop_id) REFERENCES STOP(stop_id),
  CHECK (stop_sequence > 0),
  CHECK (distance_from_origin_km >= 0),
  CHECK (scheduled_offset_min >= 0)
) ENGINE=InnoDB;

CREATE TABLE TRIP (
  trip_id INT PRIMARY KEY,
  route_id INT NOT NULL,
  bus_id INT NOT NULL,
  service_date DATE NOT NULL,
  departure_time TIME NOT NULL,
  arrival_time TIME NOT NULL,
  trip_status ENUM('SCHEDULED','COMPLETED','CANCELLED','DELAYED') NOT NULL DEFAULT 'SCHEDULED',
  base_fare_per_km DECIMAL(8,2) NOT NULL,
  FOREIGN KEY (route_id) REFERENCES ROUTE(route_id),
  FOREIGN KEY (bus_id) REFERENCES BUS(bus_id),
  CHECK (base_fare_per_km > 0)
) ENGINE=InnoDB;

CREATE TABLE FARE_RULE (
  fare_rule_id INT PRIMARY KEY,
  coach_type_id INT NOT NULL,
  concession_category ENUM('NONE','STUDENT','SENIOR_CITIZEN','DISABLED') NOT NULL,
  min_distance_km DECIMAL(8,2) NOT NULL,
  max_distance_km DECIMAL(8,2),
  fare_per_km DECIMAL(8,2) NOT NULL,
  discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (coach_type_id) REFERENCES COACH_TYPE(coach_type_id),
  CHECK (min_distance_km >= 0),
  CHECK (max_distance_km IS NULL OR max_distance_km > min_distance_km),
  CHECK (fare_per_km > 0),
  CHECK (discount_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE FESTIVAL (
  festival_id INT PRIMARY KEY,
  festival_name VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  surcharge_percent DECIMAL(5,2) NOT NULL,
  CHECK (end_date >= start_date),
  CHECK (surcharge_percent >= 0)
) ENGINE=InnoDB;

CREATE TABLE BOOKING (
  booking_id INT PRIMARY KEY,
  trip_id INT NOT NULL,
  passenger_id INT NOT NULL,
  seat_bus_id INT NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  boarding_stop_id INT NOT NULL,
  drop_stop_id INT NOT NULL,
  booking_time DATETIME NOT NULL,
  journey_fare DECIMAL(10,2) NOT NULL,
  booking_status ENUM('CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'CONFIRMED',
  FOREIGN KEY (trip_id) REFERENCES TRIP(trip_id),
  FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id),
  FOREIGN KEY (seat_bus_id, seat_no) REFERENCES SEAT(bus_id, seat_no),
  FOREIGN KEY (boarding_stop_id) REFERENCES STOP(stop_id),
  FOREIGN KEY (drop_stop_id) REFERENCES STOP(stop_id),
  CHECK (journey_fare >= 0),
  CHECK (boarding_stop_id <> drop_stop_id)
) ENGINE=InnoDB;

CREATE TABLE PAYMENT (
  payment_id INT PRIMARY KEY,
  booking_id INT NOT NULL UNIQUE,
  payment_time DATETIME NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_method ENUM('UPI','CARD','NET_BANKING','CASH','WALLET') NOT NULL,
  payment_status ENUM('SUCCESS','FAILED','REFUNDED','PENDING') NOT NULL,
  transaction_ref VARCHAR(50) NOT NULL UNIQUE,
  FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id),
  CHECK (amount >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_booking_trip_seat ON BOOKING(trip_id, seat_bus_id, seat_no);
CREATE INDEX idx_booking_passenger ON BOOKING(passenger_id);
CREATE INDEX idx_trip_route_date ON TRIP(route_id, service_date);
CREATE INDEX idx_route_stop_lookup ON ROUTE_STOP(route_id, stop_id);
CREATE INDEX idx_route_stop_sequence ON ROUTE_STOP(route_id, stop_sequence);

DELIMITER $$
CREATE TRIGGER trg_booking_validate_before_insert
BEFORE INSERT ON BOOKING
FOR EACH ROW
BEGIN
  DECLARE v_trip_bus INT;
  DECLARE v_board_seq INT;
  DECLARE v_drop_seq INT;
  DECLARE v_conflict_count INT DEFAULT 0;

  SELECT bus_id INTO v_trip_bus FROM TRIP WHERE trip_id = NEW.trip_id;
  IF v_trip_bus IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip does not exist';
  END IF;
  IF NEW.seat_bus_id <> v_trip_bus THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat does not belong to trip bus';
  END IF;

  SELECT rs.stop_sequence INTO v_board_seq
  FROM ROUTE_STOP rs JOIN TRIP t ON t.route_id = rs.route_id
  WHERE t.trip_id = NEW.trip_id AND rs.stop_id = NEW.boarding_stop_id;
  SELECT rs.stop_sequence INTO v_drop_seq
  FROM ROUTE_STOP rs JOIN TRIP t ON t.route_id = rs.route_id
  WHERE t.trip_id = NEW.trip_id AND rs.stop_id = NEW.drop_stop_id;

  IF v_board_seq IS NULL OR v_drop_seq IS NULL OR v_board_seq >= v_drop_seq THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Boarding stop must precede drop stop';
  END IF;

  SELECT COUNT(*) INTO v_conflict_count
  FROM BOOKING b
  JOIN TRIP t ON t.trip_id = b.trip_id
  JOIN ROUTE_STOP rb ON rb.route_id = t.route_id AND rb.stop_id = b.boarding_stop_id
  JOIN ROUTE_STOP rd ON rd.route_id = t.route_id AND rd.stop_id = b.drop_stop_id
  JOIN ROUTE_STOP nb ON nb.route_id = t.route_id AND nb.stop_id = NEW.boarding_stop_id
  JOIN ROUTE_STOP nd ON nd.route_id = t.route_id AND nd.stop_id = NEW.drop_stop_id
  WHERE b.trip_id = NEW.trip_id
    AND b.seat_bus_id = NEW.seat_bus_id
    AND b.seat_no = NEW.seat_no
    AND b.booking_status IN ('CONFIRMED','COMPLETED')
    AND nb.stop_sequence < rd.stop_sequence
    AND nd.stop_sequence > rb.stop_sequence;

  IF v_conflict_count > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat already booked for overlapping journey segment';
  END IF;
END$$

CREATE TRIGGER trg_booking_validate_before_update
BEFORE UPDATE ON BOOKING
FOR EACH ROW
BEGIN
  DECLARE v_trip_bus INT;
  DECLARE v_board_seq INT;
  DECLARE v_drop_seq INT;
  DECLARE v_conflict_count INT DEFAULT 0;

  SELECT bus_id INTO v_trip_bus FROM TRIP WHERE trip_id = NEW.trip_id;
  IF NEW.seat_bus_id <> v_trip_bus THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat does not belong to trip bus';
  END IF;

  SELECT rs.stop_sequence INTO v_board_seq
  FROM ROUTE_STOP rs JOIN TRIP t ON t.route_id = rs.route_id
  WHERE t.trip_id = NEW.trip_id AND rs.stop_id = NEW.boarding_stop_id;
  SELECT rs.stop_sequence INTO v_drop_seq
  FROM ROUTE_STOP rs JOIN TRIP t ON t.route_id = rs.route_id
  WHERE t.trip_id = NEW.trip_id AND rs.stop_id = NEW.drop_stop_id;

  IF v_board_seq IS NULL OR v_drop_seq IS NULL OR v_board_seq >= v_drop_seq THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Boarding stop must precede drop stop';
  END IF;

  SELECT COUNT(*) INTO v_conflict_count
  FROM BOOKING b
  JOIN TRIP t ON t.trip_id = b.trip_id
  JOIN ROUTE_STOP rb ON rb.route_id = t.route_id AND rb.stop_id = b.boarding_stop_id
  JOIN ROUTE_STOP rd ON rd.route_id = t.route_id AND rd.stop_id = b.drop_stop_id
  JOIN ROUTE_STOP nb ON nb.route_id = t.route_id AND nb.stop_id = NEW.boarding_stop_id
  JOIN ROUTE_STOP nd ON nd.route_id = t.route_id AND nd.stop_id = NEW.drop_stop_id
  WHERE b.booking_id <> NEW.booking_id
    AND b.trip_id = NEW.trip_id
    AND b.seat_bus_id = NEW.seat_bus_id
    AND b.seat_no = NEW.seat_no
    AND b.booking_status IN ('CONFIRMED','COMPLETED')
    AND nb.stop_sequence < rd.stop_sequence
    AND nd.stop_sequence > rb.stop_sequence;

  IF v_conflict_count > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat already booked for overlapping journey segment';
  END IF;
END$$
DELIMITER ;
