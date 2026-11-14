-- =========================================================
-- CS 340 Team 80 — Workout City Fitness DB
-- DML: the queries the application runs.
-- Values written as :name are supplied by the Python app
-- (PyMySQL uses %s placeholders with a params tuple).
--
-- Citation: Original work.
-- =========================================================

-- ===================== Customers =====================
-- READ
SELECT customerID, firstName, lastName, emailAddress, phoneNumber
FROM Customers ORDER BY customerID;

-- CREATE
INSERT INTO Customers (firstName, lastName, emailAddress, phoneNumber)
VALUES (:firstName, :lastName, :emailAddress, :phoneNumber);

-- UPDATE
UPDATE Customers
SET firstName = :firstName, lastName = :lastName,
    emailAddress = :emailAddress, phoneNumber = :phoneNumber
WHERE customerID = :customerID;

-- DELETE (their CustomerClasses rows cascade)
DELETE FROM Customers WHERE customerID = :customerID;

-- ===================== Trainers =====================
-- READ
SELECT trainerID, firstName, lastName, emailAddress, trainerSpecialty
FROM Trainers ORDER BY trainerID;

-- CREATE
INSERT INTO Trainers (firstName, lastName, emailAddress, trainerSpecialty)
VALUES (:firstName, :lastName, :emailAddress, :trainerSpecialty);

-- UPDATE
UPDATE Trainers
SET firstName = :firstName, lastName = :lastName,
    emailAddress = :emailAddress, trainerSpecialty = :trainerSpecialty
WHERE trainerID = :trainerID;

-- DELETE (fails if the trainer still leads a class)
DELETE FROM Trainers WHERE trainerID = :trainerID;

-- ===================== Studios =====================
-- READ
SELECT studioID, roomNumber, roomName, roomLimit
FROM Studios ORDER BY studioID;

-- CREATE
INSERT INTO Studios (roomNumber, roomName, roomLimit)
VALUES (:roomNumber, :roomName, :roomLimit);

-- UPDATE
UPDATE Studios
SET roomNumber = :roomNumber, roomName = :roomName, roomLimit = :roomLimit
WHERE studioID = :studioID;

-- DELETE (fails if the studio still has classes scheduled)
DELETE FROM Studios WHERE studioID = :studioID;

-- ===================== Classes =====================
-- READ: show trainer and studio names instead of raw IDs, plus enrollment count
SELECT c.classID, c.className, c.timeSlot,
       CONCAT(t.firstName, ' ', t.lastName) AS trainer,
       s.roomName AS studio,
       COUNT(cc.customerClassID) AS enrolled,
       c.classLimit
FROM Classes c
JOIN Trainers t ON t.trainerID = c.trainerID
JOIN Studios  s ON s.studioID  = c.studioID
LEFT JOIN CustomerClasses cc ON cc.classID = c.classID
GROUP BY c.classID
ORDER BY c.timeSlot;

-- CREATE
INSERT INTO Classes (trainerID, className, timeSlot, studioID, classLimit)
VALUES (:trainerID, :className, :timeSlot, :studioID, :classLimit);

-- UPDATE
UPDATE Classes
SET trainerID = :trainerID, className = :className, timeSlot = :timeSlot,
    studioID = :studioID, classLimit = :classLimit
WHERE classID = :classID;

-- DELETE (its CustomerClasses rows cascade)
DELETE FROM Classes WHERE classID = :classID;

-- ===================== CustomerClasses (enrollments) =====================
-- READ: show customer and class names instead of raw IDs
SELECT cc.customerClassID,
       CONCAT(cu.firstName, ' ', cu.lastName) AS customer,
       cl.className, cl.timeSlot, cc.bookingDate
FROM CustomerClasses cc
JOIN Customers cu ON cu.customerID = cc.customerID
JOIN Classes   cl ON cl.classID    = cc.classID
ORDER BY cc.bookingDate, cc.customerClassID;

-- Over-enrollment check, run before CREATE
SELECT c.classLimit, COUNT(cc.customerClassID) AS enrolled
FROM Classes c
LEFT JOIN CustomerClasses cc ON cc.classID = c.classID
WHERE c.classID = :classID
GROUP BY c.classID;

-- CREATE (enroll a customer)
INSERT INTO CustomerClasses (customerID, classID, bookingDate)
VALUES (:customerID, :classID, :bookingDate);

-- UPDATE (move an enrollment to another customer/class)
UPDATE CustomerClasses
SET customerID = :customerID, classID = :classID, bookingDate = :bookingDate
WHERE customerClassID = :customerClassID;

-- DELETE (unenroll)
DELETE FROM CustomerClasses WHERE customerClassID = :customerClassID;
