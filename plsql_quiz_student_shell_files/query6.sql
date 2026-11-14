-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement sp_update_person_homeworld
-- using NULL handling, REGEXP, CAST, planet ID/name lookups,
-- transactions, and rollback for invalid homeworld values.


-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_update_person_homeworld;
DELIMITER //

-- ------- Write your code below this line -----------
CREATE PROCEDURE sp_update_person_homeworld(
    IN person_id INT,
    IN myworld VARCHAR(255)
)
BEGIN
    DECLARE world_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Update error!' AS result;
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Handle NULL input
    IF myworld IS NULL THEN
        UPDATE bsg_people
        SET homeworld = NULL
        WHERE id = person_id;

    ELSE
        -- Check if myworld is an integer
        IF myworld REGEXP '^[0-9]+$' THEN
            SET world_id = CAST(myworld AS UNSIGNED);

            -- Check if world_id exists as a planet, if so, update bsg_people
            -- else, return error
            IF EXISTS (
                SELECT 1
                FROM bsg_planets
                WHERE id = world_id
            ) THEN
                UPDATE bsg_people
                SET homeworld = world_id
                WHERE id = person_id;
            ELSE
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid homeworld ID';
            END IF;

        ELSE
            -- myworld is assumed to be a name, therefore proceed:

            -- Get the ID value of a planet with the name matching myworld's value
            SELECT id INTO world_id
            FROM bsg_planets
            WHERE name = myworld
            LIMIT 1;

            -- Update the person's homeworld in bsg_people
            IF world_id IS NOT NULL THEN
                UPDATE bsg_people
                SET homeworld = world_id
                WHERE id = person_id;
            ELSE
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid homeworld name';
            END IF;

        END IF;
    END IF;

    -- Return the updated person's details
    SELECT
        p.fname,
        p.lname,
        CASE WHEN p.age IS NULL THEN 'NULL' ELSE CAST(p.age AS CHAR) END as age,
        CASE WHEN pl.name IS NULL THEN 'NULL' ELSE pl.name END as homeworld
    FROM bsg_people p
    LEFT JOIN bsg_planets pl ON p.homeworld = pl.id
    WHERE p.id = person_id;

    COMMIT;
END //


-- ------- Do not alter query code below this line -----------
DELIMITER ;