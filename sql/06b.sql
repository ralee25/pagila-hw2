/*
 * This problem is the same as 06.sql,
 * but instead of using the NOT IN operator, you are to use a LEFT JOIN.
 */

SELECT f.title
FROM film as f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
WHERE i.film_id IS NULL
ORDER BY f.title;
