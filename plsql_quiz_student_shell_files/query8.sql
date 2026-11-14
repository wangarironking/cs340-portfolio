-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Based on the CS340 starter code and a ChatGPT-generated solution.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Requested implementation of sp_update_cert_count_totals
-- using UPDATE, LEFT JOIN, COUNT(*), GROUP BY, and a subquery
-- to calculate and store certification totals, including zero counts.

-- Leave the following query code untouched
DROP PROCEDURE IF EXISTS sp_update_cert_count_totals;
DELIMITER //

-- ------- Write your code below this line -----------
CREATE PROCEDURE sp_update_cert_count_totals()
BEGIN
    -- Update the cert_total column with the count of people holding each certificate
    UPDATE bsg_cert c
    LEFT JOIN (
        SELECT cid, COUNT(*) AS total
        FROM bsg_cert_people
        GROUP BY cid
    ) cp ON c.id = cp.cid
    SET c.cert_total = COALESCE(cp.total, 0);

END //


-- ------- Do not alter query code below this line -----------
DELIMITER ;