-- Note: Only use single-line comments in this file.

-- Citation for the following code:
-- Date: 11/03/2026
-- Based on the CS340 starter code and a ChatGPT-generated solution.
-- Degree of originality: AI-assisted implementation, reviewed and
-- customized by Aron Wang, with student modifications and verification.
-- Source URL: https://chatgpt.com/
-- AI Tool: ChatGPT (OpenAI).
-- Prompts: Requested implementation of v_cert_people using JOINs
-- between certification, people, and planet tables, including
-- a LEFT JOIN for nullable homeworlds and the planet_name alias.


-- Leave the following query code untouched
DROP VIEW  IF EXISTS v_cert_people;

-- ------- Write your code below this line -----------
CREATE VIEW v_cert_people AS
SELECT
    c.title,
    p.fname,
    p.lname,
    pl.name AS planet_name
FROM
    bsg_cert_people cp
JOIN
    bsg_cert c ON cp.cid = c.id
JOIN
    bsg_people p ON cp.pid = p.id
LEFT JOIN
    bsg_planets pl ON p.homeworld = pl.id
ORDER BY
    c.title, p.fname, p.lname;

