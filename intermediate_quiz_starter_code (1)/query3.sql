/*
-- Citation for the following code: Code Syntax and Templates provided from CS340 @ OSU Activity 4,5,6, 7, and 8
-- Original work. Used Gemini to clarify what error caused gradescope to return.
-- Prompt: Hey Gemini why do I have an error

3.1) Employee names and project titles returned in correct order (13 pts) (0/13)
Test Failed: 1142 (42000): SELECT command denied to user 'test'@'localhost' for table 'ei

--Gemini then explains that my terms at after the INNER JOIN were both incorrect
*/
SELECT employee.first_name, employee.last_name, project.title
FROM employee
INNER JOIN works_on ON works_on.eid = employee.id
INNER JOIN project ON works_on.pid= project.id

ORDER BY employee.first_name ASC;
