/*
 * Compute the total revenue for each film.
 */

SELECT f.title, COALESCE(r.revenue, 0.00) AS "revenue"
FROM film AS f
LEFT JOIN (
    SELECT i.film_id, SUM(p.amount) AS revenue
    FROM inventory AS i
    LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
    LEFT JOIN payment AS p ON r.rental_id = p.rental_id
    GROUP BY i.film_id
) AS r ON f.film_id = r.film_id
ORDER BY
    CASE WHEN COALESCE(r.revenue, 0.00) = 0 THEN 1 ELSE 0 END,
    COALESCE(r.revenue, 0.00) DESC,
    f.title;

