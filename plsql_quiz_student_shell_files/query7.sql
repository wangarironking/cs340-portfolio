-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement sp_modify_cert_table using
-- ALTER TABLE to add an integer cert_total column with a default
-- value of zero for certification count tracking.

-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_modify_cert_table;
DELIMITER //
-- Leave the following query code untouched
CREATE PROCEDURE sp_modify_cert_table()
BEGIN
    -- Add the new column cert_total to bsg_cert table
    ALTER TABLE bsg_cert
    ADD COLUMN cert_total INT DEFAULT 0;

END //



-- ------- Do not alter query code below this line -----------
DELIMITER ;
