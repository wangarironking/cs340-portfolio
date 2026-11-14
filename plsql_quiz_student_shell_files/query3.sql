-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
--  Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- If AI tools were used:ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement func_cert_count using JOINs,
-- COUNT(*), SELECT INTO, and an UPDATE statement to track function usage.


-- Leave the following query code untouched
Drop TABLE IF EXISTS diag_function_cert_use;
CREATE TABLE diag_function_cert_use (
    used INT DEFAULT 0
);

INSERT INTO diag_function_cert_use (used) VALUES (0)
ON DUPLICATE KEY UPDATE used = used;

DELIMITER //
DROP FUNCTION  IF EXISTS func_cert_count;

-- ------- Write your code below this line -----------
CREATE FUNCTION func_cert_count(cert_title VARCHAR(255))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE cert_count INT;

    -- SELECT query to get the certificate count
    SELECT COUNT(*) INTO cert_count
    FROM bsg_cert_people cp
    JOIN bsg_cert c ON cp.cid = c.id
    WHERE c.title = cert_title;

    -- Increment the used attribute
    UPDATE diag_function_cert_use SET used = used + 1;

    RETURN cert_count;
END //



-- ------- Do not alter query code below this line -----------
DELIMITER ;