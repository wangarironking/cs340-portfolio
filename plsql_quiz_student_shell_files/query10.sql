-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement sp_delete_cert_person_update_total
-- using DELETE, ROW_COUNT(), and IF/ELSE logic to check deletion
-- success and call sp_update_cert_count_totals to refresh totals.


-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_delete_cert_person_update_total;
DELIMITER //

-- ------- Write your code below this line -----------
CREATE PROCEDURE sp_delete_cert_person_update_total (
    IN input_cid INT,
    IN input_pid INT
)
BEGIN
    -- Declare a variable to store the number of rows affected by the DELETE
    DECLARE rows_affected INT DEFAULT 0;

    -- Attempt to delete the row with the specified cid and pid
    DELETE FROM bsg_cert_people
    WHERE cid = input_cid
      AND pid = input_pid;

    -- Get the number of rows affected by the DELETE
    SET rows_affected = ROW_COUNT();

    -- Check if the DELETE was successful
    IF rows_affected > 0 THEN
        CALL sp_update_cert_count_totals();

        -- Return single combined success message
        SELECT 'cert deleted and cert count total updated' AS message;
    ELSE
        -- Return error message
        SELECT 'Delete error!' AS message;
    END IF;
END //


-- ------- Do not alter query code below this line -----------
DELIMITER ;