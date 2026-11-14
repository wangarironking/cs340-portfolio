-- =========================================================
-- CS 340 Team 80 — Workout City Fitness DB
-- Team: Aron Wang, Micah Ahn
--
-- DDL: creates all tables and loads sample data.
-- Running this file resets the database to a clean state.
--
-- Citation: Original work, based on the team's Project Step 2
-- outline and MySQL Workbench schema.
-- =========================================================

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Drop in reverse dependency order
DROP TABLE IF EXISTS CustomerClasses;
DROP TABLE IF EXISTS Classes;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Trainers;
DROP TABLE IF EXISTS Studios;

-- ---------------------------------------------------------
-- Customers: profile and contact details of each customer
-- ---------------------------------------------------------
CREATE TABLE Customers (
    customerID    INT          NOT NULL AUTO_INCREMENT UNIQUE,
    firstName     VARCHAR(75)  NOT NULL,
    lastName      VARCHAR(75)  NOT NULL,
    emailAddress  VARCHAR(80)  NOT NULL UNIQUE,
    phoneNumber   VARCHAR(20)  NOT NULL,
    PRIMARY KEY (customerID)
);

-- ---------------------------------------------------------
-- Trainers: fitness instructors
-- ---------------------------------------------------------
CREATE TABLE Trainers (
    trainerID         INT          NOT NULL AUTO_INCREMENT UNIQUE,
    firstName         VARCHAR(75)  NOT NULL,
    lastName          VARCHAR(75)  NOT NULL,
    emailAddress      VARCHAR(80)  NOT NULL UNIQUE,
    trainerSpecialty  VARCHAR(50)  NOT NULL,
    PRIMARY KEY (trainerID)
);

-- ---------------------------------------------------------
-- Studios: physical studio rooms
-- ---------------------------------------------------------
CREATE TABLE Studios (
    studioID    INT           NOT NULL AUTO_INCREMENT UNIQUE,
    roomNumber  VARCHAR(30)   NOT NULL UNIQUE,
    roomName    VARCHAR(100)  NOT NULL,
    roomLimit   INT           NOT NULL,
    PRIMARY KEY (studioID)
);

-- ---------------------------------------------------------
-- Classes: fitness classes with timeslot and capacity
--   1:M Trainers -> Classes   (trainerID FK)
--   1:M Studios  -> Classes   (studioID FK)
-- A trainer or studio that still has classes can't be deleted
-- (default RESTRICT), since every class needs both.
-- ---------------------------------------------------------
CREATE TABLE Classes (
    classID     INT           NOT NULL AUTO_INCREMENT UNIQUE,
    trainerID   INT           NOT NULL,
    className   VARCHAR(100)  NOT NULL,
    timeSlot    DATETIME      NOT NULL,
    studioID    INT           NOT NULL,
    classLimit  INT           NOT NULL DEFAULT 50,
    PRIMARY KEY (classID),
    FOREIGN KEY (trainerID) REFERENCES Trainers(trainerID),
    FOREIGN KEY (studioID)  REFERENCES Studios(studioID)
);

-- ---------------------------------------------------------
-- CustomerClasses: intersection table for the M:N between
-- Customers and Classes. Each row is one enrollment.
-- UNIQUE (customerID, classID) blocks double-booking the same
-- customer into the same class.
-- ---------------------------------------------------------
CREATE TABLE CustomerClasses (
    customerClassID  INT   NOT NULL AUTO_INCREMENT UNIQUE,
    customerID       INT   NOT NULL,
    classID          INT   NOT NULL,
    bookingDate      DATE  NOT NULL,
    PRIMARY KEY (customerClassID),
    UNIQUE (customerID, classID),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE,
    FOREIGN KEY (classID)    REFERENCES Classes(classID)      ON DELETE CASCADE
);

-- =========================================================
-- Sample data
-- FKs are looked up by a unique column (email, roomNumber,
-- className) rather than hard-coded IDs.
-- =========================================================

INSERT INTO Customers (firstName, lastName, emailAddress, phoneNumber) VALUES
    ('John',    'Gerald',  'john.gerald@example.com',    '541-555-0101'),
    ('Marcus',  'Cheese',  'marcus.cheese@example.com',  '541-501-1001'),
    ('Simon',   'Belmot',  'simon.belmot@example.com',   '541-441-3332'),
    ('Rebecca', 'Smith',   'rebecca.smith@example.com',  '541-441-3332'),
    ('Alucard', 'Dracula', 'alucard.dracula@example.com','541-441-3332');

INSERT INTO Trainers (firstName, lastName, emailAddress, trainerSpecialty) VALUES
    ('Sean',   'Tiger',   'sean.tiger@example.com',    'Yoga'),
    ('Emily',  'Howard',  'emily.howard@example.com',  'Strength Training'),
    ('Ellie',  'Stuckey', 'ellie.stuckey@example.com', 'Cardio'),
    ('Brynn',  'Davis',   'brynn.davis@example.com',   'Swimming'),
    ('James',  'Castle',  'james.castle@example.com',  'Recovery');

INSERT INTO Studios (roomNumber, roomName, roomLimit) VALUES
    ('100', 'Yoga Room',    30),
    ('101', 'Weights Room', 20),
    ('103', 'Cardio Room',  20),
    ('104', 'Swim Center',  40);

INSERT INTO Classes (trainerID, className, timeSlot, studioID, classLimit) VALUES
    ((SELECT trainerID FROM Trainers WHERE emailAddress = 'sean.tiger@example.com'),
        'Morning Yoga',      '2026-11-02 10:00:00',
        (SELECT studioID FROM Studios WHERE roomNumber = '100'), 25),
    ((SELECT trainerID FROM Trainers WHERE emailAddress = 'emily.howard@example.com'),
        'Strength Training', '2026-11-03 11:00:00',
        (SELECT studioID FROM Studios WHERE roomNumber = '101'), 20),
    ((SELECT trainerID FROM Trainers WHERE emailAddress = 'ellie.stuckey@example.com'),
        'Cardio Fitness',    '2026-11-04 12:00:00',
        (SELECT studioID FROM Studios WHERE roomNumber = '103'), 20),
    ((SELECT trainerID FROM Trainers WHERE emailAddress = 'brynn.davis@example.com'),
        'Swimming Basics',   '2026-11-05 13:00:00',
        (SELECT studioID FROM Studios WHERE roomNumber = '104'), 30),
    ((SELECT trainerID FROM Trainers WHERE emailAddress = 'james.castle@example.com'),
        'Recovery Yoga',     '2026-11-06 14:00:00',
        (SELECT studioID FROM Studios WHERE roomNumber = '100'), 15);

INSERT INTO CustomerClasses (customerID, classID, bookingDate) VALUES
    ((SELECT customerID FROM Customers WHERE emailAddress = 'john.gerald@example.com'),
        (SELECT classID FROM Classes WHERE className = 'Morning Yoga'),      '2026-10-20'),
    ((SELECT customerID FROM Customers WHERE emailAddress = 'john.gerald@example.com'),
        (SELECT classID FROM Classes WHERE className = 'Strength Training'), '2026-10-20'),
    ((SELECT customerID FROM Customers WHERE emailAddress = 'marcus.cheese@example.com'),
        (SELECT classID FROM Classes WHERE className = 'Morning Yoga'),      '2026-10-21'),
    ((SELECT customerID FROM Customers WHERE emailAddress = 'simon.belmot@example.com'),
        (SELECT classID FROM Classes WHERE className = 'Cardio Fitness'),    '2026-10-21'),
    ((SELECT customerID FROM Customers WHERE emailAddress = 'rebecca.smith@example.com'),
        (SELECT classID FROM Classes WHERE className = 'Swimming Basics'),   '2026-10-22');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
