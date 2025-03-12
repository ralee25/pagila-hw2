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
    f.film_id,
    f.title, 
    COALESCE(SUM(p.amount), 0.00) AS revenue
  FROM film AS f
  LEFT JOIN inventory AS i ON f.film_id = i.film_id
  LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
  LEFT JOIN payment AS p ON r.rental_id = p.rental_id
  GROUP BY f.film_id, f.title
),
cumulative AS (
  SELECT
    title,
    revenue,
    rank() OVER (ORDER BY revenue DESC) AS rank,
    SUM(revenue) OVER (
      ORDER BY revenue DESC, title ASC 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS "total revenue"
  FROM film_data
)
SELECT rank, title, revenue, "total revenue"
FROM cumulative
ORDER BY rank;

