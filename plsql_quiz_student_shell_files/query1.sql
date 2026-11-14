-- Note: Only use single-line comments in this file.

-- Citation for the following code:

-- Date: 11/03/2026
-- Based on the CS340 starter code and a ChatGPT-generated solution.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Requested implementation of sp_query1 using HHMM input
-- validation, STR_TO_DATE(), HOUR(), and IF/ELSEIF statements
-- to determine the appropriate greeting.

-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_query1;
DELIMITER //

-- ------- Write your code below this line -----------
CREATE PROCEDURE sp_query1 (IN timeNow VARCHAR(4), OUT greeting VARCHAR(50))
BEGIN
    DECLARE current_hour INT;
    DECLARE formatted_time TIME;

    -- Validate input format
    IF timeNow IS NULL
       OR LENGTH(timeNow) != 4
       OR timeNow NOT REGEXP '^[0-2][0-9][0-5][0-9]$'
       OR CAST(LEFT(timeNow, 2) AS UNSIGNED) > 23 THEN

        SET greeting = 'Invalid time format. Please use HHMM.';

    ELSE

        -- Convert the input timeNow to TIME format
        SET formatted_time = TIME(
            STR_TO_DATE(timeNow, '%H%i')
        );

        -- Extract the hour
        SET current_hour = HOUR(formatted_time);

        -- SET OUTVAR 'greeting' to a string value based on current_hour
        IF current_hour >= 6 AND current_hour < 12 THEN
            SET greeting = 'Good morning';

        ELSEIF current_hour >= 12 AND current_hour < 17 THEN
            SET greeting = 'Good afternoon';

        ELSEIF current_hour >= 17 AND current_hour < 24 THEN
            SET greeting = 'Good evening';

        ELSE
            SET greeting = 'My it''s late, shouldn''t you be in bed?';

        END IF;

    END IF;
END //
-- ------- Do not alter query code below this line -----------
DELIMITER ;