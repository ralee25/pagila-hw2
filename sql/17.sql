/*
 * Compute the total revenue for each film.
 * The output should include another new column "total revenue" that shows the sum of all the revenue of all previous films.
 *
 * HINT:
 * My solution starts with the solution to problem 16 as a subquery.
 * Then I combine the SUM function with the OVER keyword to create a window function that computes the total.
 * You might find the following stackoverflow answer useful for figuring out the syntax:
 * <https://stackoverflow.com/a/5700744>.
 */

WITH film_data AS (
  SELECT 
    RANK() OVER (ORDER BY COALESCE(SUM(p.amount), 0) DESC) AS rank,
    f.title, 
    ROUND(COALESCE(SUM(p.amount), 0), 2) AS revenue
  FROM film AS f
  LEFT JOIN inventory AS i ON f.film_id = i.film_id
  LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
  LEFT JOIN payment AS p ON r.rental_id = p.rental_id
  GROUP BY f.film_id, f.title
)
SELECT
  rank,
  title,
  revenue,
  SUM(revenue) OVER (ORDER BY rank) AS "total revenue"
FROM film_data
ORDER BY rank, title;

