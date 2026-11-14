-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Adapted from the CS340 starter code and a ChatGPT-generated template.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Asked ChatGPT to implement trigger_after_cert_person_inserted
-- using AFTER INSERT and FOR EACH ROW to automatically call
-- sp_update_cert_count_totals when a certification is assigned.

-- Leave the following query code untouched
DROP TRIGGER IF EXISTS trigger_after_cert_person_inserted;
DELIMITER //

-- ------- Write your code below this line -----------
CREATE TRIGGER trigger_after_cert_person_inserted
AFTER INSERT ON bsg_cert_people
FOR EACH ROW
BEGIN
    -- Update certification totals after a new relationship is inserted
    CALL sp_update_cert_count_totals();
END //


-- ------- Do not alter query code below this line -----------
DELIMITER ;