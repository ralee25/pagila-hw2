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
    COALESCE(SUM(p.amount), 0.00) AS revenue
  FROM film AS f
  LEFT JOIN inventory AS i ON f.film_id = i.film_id
  LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
  LEFT JOIN payment AS p ON r.rental_id = p.rental_id
  GROUP BY f.title
),
cumulative AS (
  SELECT
    rank() OVER (ORDER BY revenue DESC, title DESC) AS rank,
    title,
    revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC, title DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "total revenue",
    100 * SUM(revenue) OVER (ORDER BY revenue DESC, title DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
         / SUM(revenue) OVER () AS percent_val
  FROM film_data
)
SELECT
    rank,
    title,
    revenue,
    "total revenue",
    CASE 
      WHEN percent_val < 100 THEN to_char(percent_val, '00.00')
      ELSE to_char(percent_val, '000.00')
    END AS "percent revenue"
FROM cumulative
ORDER BY rank;

