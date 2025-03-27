/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */

WITH film_data AS (
  SELECT 
    f.title, 
    SUM(COALESCE(p.amount, 0.00)) AS revenue
  FROM film AS f
  LEFT JOIN inventory AS i ON f.film_id = i.film_id
  LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
  LEFT JOIN payment AS p ON r.rental_id = p.rental_id
  GROUP BY f.title
),
cumulative AS (
  SELECT
    RANK() OVER (ORDER BY revenue DESC) AS rank,
    title,
    revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS "total revenue"
  FROM film_data
)
SELECT
    rank,
    title,
    revenue,
    "total revenue",
    TO_CHAR((100.0 * "total revenue") / NULLIF(SUM(revenue) OVER (), 0), 'FM900.00') AS "percent revenue"
FROM cumulative
ORDER BY revenue DESC, title;

