-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement sp_insert_person using INSERT,
-- LAST_INSERT_ID(), transactions, COMMIT, ROLLBACK, and an SQL
-- exception handler to return -99 when an insertion fails.


-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_insert_person;
DELIMITER //

-- ------- Write your code below this line -----------

CREATE PROCEDURE sp_insert_person(
    IN fname VARCHAR(255),
    IN lname VARCHAR(255),
    IN age INT,
    IN homeworld INT,
    IN cert_id INT,
    OUT person_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- In case of an error, set the person_id to -99
        SET person_id = -99;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Insert into bsg_people table
    INSERT INTO bsg_people (fname, lname, age, homeworld)
    VALUES (fname, lname, age, homeworld);

    -- Get the last inserted id
    SET person_id = LAST_INSERT_ID();

    -- Insert into bsg_cert_people table
    INSERT INTO bsg_cert_people (cid, pid)
    VALUES (cert_id, person_id);

    COMMIT;
END //


-- ------- Do not alter query code below this line -----------
DELIMITER ;