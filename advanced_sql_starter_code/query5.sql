-- Find the film_title of all films which feature both UMA WOOD and FRED COSTNER
-- Order the results by film_title in descending order.
--  Warning: this is a tricky one and while the syntax is all things you know, you have to think a bit oustide the box 
--  to figure out how to get a table that shows pairs of actors in movies.

-- Put your query for Q5 here.


/*
-- Citation for the following code: Code Syntax and Templates provided from CS340 @ OSU Advanced SQL Assignment Hints
-- Original work, no AI tools were used.
*/

SELECT uw.title as film_title FROM
(
SELECT film.film_id, film.title FROM film

JOIN film_actor ON film.film_id = film_actor.film_id

JOIN actor ON film_actor.actor_id = actor.actor_id

WHERE actor.actor_id = 13) AS uw
-- #13 = Uma Wood. Can be replaced with a subquery) as uw

JOIN
(
SELECT film.film_id, film.title FROM film

JOIN film_actor ON film.film_id = film_actor.film_id

JOIN actor ON film_actor.actor_id = actor.actor_id

WHERE actor.actor_id = 16) AS fc
-- #13 = Uma Wood. Can be replaced with a subquery) AS fc

ON uw.film_id = fc.film_id

ORDER BY film_title DESC;